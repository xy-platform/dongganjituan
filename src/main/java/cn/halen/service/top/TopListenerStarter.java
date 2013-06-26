package cn.halen.service.top;

import java.text.ParseException;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.support.AnnotationConfigWebApplicationContext;

import cn.halen.data.DataConfig;
import cn.halen.data.mapper.MySkuMapper;
import cn.halen.data.pojo.MyStatus;
import cn.halen.data.pojo.MyTrade;
import cn.halen.exception.InsufficientBalanceException;
import cn.halen.exception.InsufficientStockException;
import cn.halen.service.ServiceConfig;
import cn.halen.service.TradeService;
import cn.halen.service.WorkerService;
import cn.halen.service.top.async.ConnectionLifeCycleListenerImpl;
import cn.halen.service.top.async.TopMessageListener;

import com.taobao.api.ApiException;
import com.taobao.api.AutoRetryTaobaoClient;
import com.taobao.api.TaobaoClient;
import com.taobao.api.TaobaoResponse;
import com.taobao.api.domain.Trade;
import com.taobao.api.internal.stream.Configuration;
import com.taobao.api.internal.stream.TopCometStream;
import com.taobao.api.internal.stream.TopCometStreamFactory;
import com.taobao.api.request.IncrementCustomerPermitRequest;

@Service
public class TopListenerStarter implements InitializingBean {
	private Logger log = LoggerFactory.getLogger(TopListenerStarter.class);
	
	@Autowired
	private TopConfig topConfig;
	
	@Autowired
	private TradeService tradeService;
	
	@Autowired
	private MySkuMapper mySkuMapper;
	
	@Autowired
	private TradeClient tradeClient;
	
	@Autowired
	private WorkerService workerService;
	
	public static void main(String[] args) throws ApiException, ParseException, InsufficientStockException, InsufficientBalanceException {
		AnnotationConfigWebApplicationContext context = new AnnotationConfigWebApplicationContext();
		context.register(DataConfig.class, ServiceConfig.class);
		context.refresh();
		context.start();
		//TopListenerStarter starter = (TopListenerStarter) context.getBean("topListenerStarter");
		//starter.start();
	}
	
	public void start() throws ApiException, ParseException, InsufficientStockException, InsufficientBalanceException {
		
		//initTrades();
		
		log.info("Start Top Listener!");
		
		final TaobaoClient client = new AutoRetryTaobaoClient(topConfig.getUrl(), topConfig.getAppKey()
				, topConfig.getAppSecret());

		// 启动主动通知监听器
		for(String token : topConfig.listToken()) {
			permitUser(client, token);
		}
		Configuration conf = new Configuration(topConfig.getAppKey(), topConfig.getAppSecret(), null);
		TopCometStream stream = new TopCometStreamFactory(conf).getInstance();
		stream.setConnectionListener(new ConnectionLifeCycleListenerImpl());
		stream.setMessageListener(new TopMessageListener(workerService));
		stream.start();
		workerService.start();
		
	}
	
	public int initTrades() throws ParseException, ApiException, InsufficientStockException, InsufficientBalanceException {
		int totalCount = 0;
		
		List<Trade> tradeList = tradeClient.queryTradeList(topConfig.listToken());
		for(Trade trade : tradeList) {
			//check trade if exists
			MyTrade dbMyTrade = tradeService.selectByTradeId(String.valueOf(trade.getTid()));
			Trade tradeDetail = tradeClient.getTradeFullInfo(trade.getTid(), topConfig.getToken(trade.getSellerNick()));
			MyTrade myTrade = tradeService.toMyTrade(tradeDetail);
			if(null == myTrade)
				continue;
			if(null == dbMyTrade) {
				myTrade.setMy_status(MyStatus.New.getStatus());
				int count = tradeService.insertMyTrade(myTrade, false);
				totalCount += count;
			} else {
				handleExisting(myTrade);
			}
		}
		return totalCount;
	}
	
	private void handleExisting(MyTrade myTrade) throws ApiException {
		MyTrade dbMyTrade = tradeService.selectTradeDetail(myTrade.getTid());
		if(!myTrade.toString().equals(dbMyTrade.toString()) && myTrade.getModified().getTime() > dbMyTrade.getModified().getTime()) {
			dbMyTrade.setName(myTrade.getName());
			dbMyTrade.setPhone(myTrade.getPhone());
			dbMyTrade.setMobile(myTrade.getMobile());
			dbMyTrade.setState(myTrade.getState());
			dbMyTrade.setCity(myTrade.getCity());
			dbMyTrade.setDistrict(myTrade.getDistrict());
			dbMyTrade.setAddress(myTrade.getAddress());
			dbMyTrade.setSeller_memo(myTrade.getSeller_memo());
			dbMyTrade.setModified(myTrade.getModified());
		}
		tradeService.updateTrade(dbMyTrade);
	}
	
	private void permitUser(TaobaoClient client, String sessionKey) throws ApiException {
		IncrementCustomerPermitRequest req = new IncrementCustomerPermitRequest();
		req.setType("get,notify");
		TaobaoResponse response = client.execute(req, sessionKey);
		System.out.println(response.getErrorCode());
	}

	@Override
	public void afterPropertiesSet() throws Exception {
		log.info("afterPropertiesSet======================================================================1111");
		this.start();
	}
}
