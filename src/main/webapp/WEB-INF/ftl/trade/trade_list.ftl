<#import "/templates/root.ftl" as root >

<script language="javascript" src="${rc.contextPath}/js/LodopFuncs.js"></script>
<object  id="LODOP" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width=0 height=0> 
    <embed id="LODOP_EM" type="application/x-print-lodop" width=0 height=0></embed>
</object>

<@root.html active=3 css=["trade_list.css", "jqpagination.css"] js=["pagination.js", "jquery.jqpagination.min.js"]>
	<i class="icon-list-alt"></i>订单列表
	<div style="width: 100%; height: 30px; background-color: #99CCCC; padding-top: 5px; padding-left: 20px;">
		<strong>状态</strong>
		<select id="status" style="width: 8%;">
			<option value="">所有状态</option>
			<#list statusList as status>
				<option value="${status.getStatus()}">${status.getDesc()}</option>
			</#list>
		</select>
		<#if CURRENT_USER.type!="Distributor" && CURRENT_USER.type!="ServiceStaff">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<strong>分销商</strong>
		<select id="seller_nick" style="width: 8%;">
			<option value="">所有分销商</option>
			<#list distributorList as distributor>
			<option value="${distributor}">${distributor}</option>
			</#list>
		</select>
		</#if>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<strong>收货人姓名</strong>
		<input id="name" type="input" value="" style="width: 6%; height: 20px;"/>
		<!-- &nbsp;&nbsp;&nbsp;&nbsp;
		<strong>开始时间</strong>
		<input id="name" type="input" value="" style="width: 8%; height: 20px;"/>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<strong>结束时间</strong>
		<input id="name" type="input" value="" style="width: 8%; height: 20px;"/> -->
		&nbsp;&nbsp;&nbsp;&nbsp;
		<button id="search">搜索</button>&nbsp;&nbsp;&nbsp;&nbsp;共${totalCount}个
	</div>
	<div class="pagination">
	    <a href="#" class="first" data-action="first">&laquo;</a>
	    <a href="#" class="previous" data-action="previous">&lsaquo;</a>
	    <input id="page" type="text" readonly="readonly" data-current-page="${paging.page}" data-page-string="1 of 3" data-max-page="${paging.pageCount}" />
	    <a href="#" class="next" data-action="next">&rsaquo;</a>
	    <a href="#" class="last" data-action="last">&raquo;</a>
	</div>
	<#list trade_list as trade>
		<table>
		    <tbody>
		      <tr class="trade">
		        <td colspan="7">
		        	${trade.come_from!}&nbsp;&nbsp;&nbsp;
		        	<strong>订单编号：</strong></strong>${trade.tid?c}  &nbsp;&nbsp;&nbsp;
		        	<strong>创建时间：</strong>${trade.created?string('yyyy-MM-dd HH:mm:ss')} &nbsp;&nbsp;&nbsp;
		        	<strong>卖家: </strong>${trade.seller_nick} &nbsp;&nbsp;&nbsp;
		        	<strong>买家: <strong>${trade.name} &nbsp;&nbsp;&nbsp;
		        	<strong>${trade.oStatus.desc}<strong>
		        	<span style="float: right; margin-right: 5px;"><strong>${trade.myStatus.desc}<strong></span>
		        </td>
		      </tr>
		      <#assign orderList = trade.myOrderList>
		      <#list orderList as order>
		      	  <tr class="order_list">
		      	  		<td  style="width: 80px;">
		      	  			<img style="width: 80px; height: 80px;" src="${order.pic_path}_80x80.jpg" />
		      	  		</td>
				        <td style="width: 25%;">
				        	<p><strong>名称：</strong>${order.title}</p>
				        	<p><strong>编号：</strong>${order.goods_id}</p>
				        	<p><strong>属性：</strong>${order.sku.color} &nbsp;&nbsp; ${order.sku.size}</p>
				        </td>
				        <td style="width: 10%;">
				        	<p><strong>${order.oStatus.desc}</strong></p>
				        	<p><strong>数量：</strong>${order.quantity}</p>
				        	<p><strong>价格：</strong>${order.payment/100}元</p>
				        </td>
				        <#if order_index==0>
				        <td rowspan="${orderList?size}" style="width: 25%;">
				        	<p><strong>地址：</strong>${trade.state}${trade.city}${trade.district}${trade.address}</p>
				        	<p>
				        		<strong>收货人：</strong>${trade.name} &nbsp;&nbsp;
				        		<strong>电话：</strong>${trade.phone} &nbsp;&nbsp;
				        		<strong>手机：</strong>${trade.mobile} &nbsp;&nbsp;
				        	</p>
				        	<p><strong>邮编：</strong>${trade.postcode}</p>
				        	<#if trade.status=="WAIT_BUYER_CONFIRM_GOODS">
				        		<p><strong>快递：</strong>${order.logistics_company} &nbsp;&nbsp;<strong>单号：</strong>${order.invoice_no}</p>
				        	</#if>
				        	<p>
				        		<strong>总数：</strong>${trade.goods_count} &nbsp;&nbsp;
				        		<strong>总额：</strong>${trade.payment/100}元 &nbsp;&nbsp;
				        		<strong>快递费：</strong>${trade.delivery_money/100}元
				        	</p>
				        </td>
				        <td rowspan="${orderList?size}" style="width: 15%;">
				        	<p><strong>买家留言：</strong>${trade.buyer_message!}</p> &nbsp;&nbsp;
				        	<p><strong>备注：</strong>${trade.seller_memo!}</p>
				        </td>
				        <td rowspan="${orderList?size}" style="text-align: right; padding-right: 10px;">
				        	<#if CURRENT_USER.type=="WareHouse">
				        		<p><strong>快递</strong>: 
				        		<span>${trade.delivery}</span>
				        		<#if trade.status=="WAIT_SELLER_SEND_GOODS" && trade.my_status==2>
					        		<p>打印快递单 &nbsp;&nbsp; <a href="javascript:prn1_preview('${sender}', '${from}', '${from_company}', '${from_address}', '${sender_mobile}',
										'${trade.name}', '${trade.name}', '${trade.state}${trade.city}${trade.district}${trade.address}', '${trade.mobile!''}', '${trade.state}')">预览</a></p>
					        		<p>打印发货单 &nbsp;&nbsp; 预览</p>
					        		<p><a class="find-goods" data-tid="${trade.tid?c}" style="cursor: pointer">拣货</a></p>
					        		<p><a class="no-goods" data-tid="${trade.tid?c}" style="cursor: pointer">无货</a></p>
				        		</#if>
				        		<#if trade.my_status==3>
				        			<p><a class="send-goods" data-tid="${trade.tid?c}" style="cursor: pointer">发货</a></p>
				        			<p><a class="no-goods" data-tid="${trade.tid?c}" style="cursor: pointer">无货</a></p>
				        		</#if>
				        		<#if trade.my_status==-2>
				        			<a class="refund-success" data-tid="${trade.tid?c}" style="cursor: pointer">退货成功</a>
				        		</#if>
				        	</#if> 
				        	<#if CURRENT_USER.type=="Distributor">
				        		<p><strong>快递</strong>: 
				        		<span>${trade.delivery}</span>
				        		<#if trade.my_status==0 || trade.my_status==1>
				        			<select style="display: none;">
				        				<#list logistics as lo>
				        					<option value="${lo.code}" <#if trade.delivery==lo.name>selected</#if>>${lo.name}</option>
				        				</#list>
									</select>
				        			<a style="cursor: pointer;" class="modify-delivery">修改</a>
				        			<a style="cursor: pointer; display: none;" data-tid="${trade.tid}" data-quantity="${trade.goods_count}" 
				        				data-goods="${order.goods_id}" data-province="${trade.state}"
				        				class="modify-delivery-submit">保存</a>
				        			<a style="cursor: pointer; display: none;" class="modify-delivery-cancel">取消</a>
				        		</#if>
				        		</p>
				        		<#if trade.my_status==0>
				        			<p><a class="submit" data-tid="${trade.tid?c}" style="cursor: pointer">提交</a></p>
				        		</#if>
				        		<#if trade.my_status==0 || trade.my_status==1 || trade.my_status==2>
				        			<p><a class="cancel" data-tid="${trade.tid?c}" style="cursor: pointer">作废</a></p>
				        		</#if>
				        		<#if trade.my_status==4>
				        			<p>申请退货</p>
				        		</#if>
				        		<#if trade.my_status==-4 || trade.my_status==-2>
				        			<p>取消退货</p>
				        		</#if>
				        	</#if> 
				        	<#if CURRENT_USER.type=="DistributorManager">
				        		<p><strong>快递</strong>: 
					        		<span>${trade.delivery}</span>
					        		<#if trade.my_status==2>
					        			<select style="display: none;">
					        				<#list logistics as lo>
					        					<option value="${lo.code}" <#if trade.delivery==lo.name>selected</#if>>${lo.name}</option>
					        				</#list>
										</select>
					        			<a style="cursor: pointer;" class="modify-delivery">修改</a>
					        			<a style="cursor: pointer; display: none;" data-tid="${trade.tid}" data-quantity="${trade.goods_count}" 
					        				data-goods="${order.goods_id}" data-province="${trade.state}"
					        				class="modify-delivery-submit">保存</a>
					        			<a style="cursor: pointer; display: none;" class="modify-delivery-cancel">取消</a>
					        		</#if>
				        		</p>
				        		<#if trade.my_status==1>
				        			<a class="cancel" data-tid="${trade.tid?c}" style="cursor: pointer">不通过</a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				        			<a class="approve1" data-tid="${trade.tid?c}" style="cursor: pointer">通过</a>
				        		</#if>
				        		<#if trade.my_status==-4>
				        			同意   不同意
				        		</#if>
				        	</#if> 
				        </td>
				        </#if>
			      </tr>
		      </#list>
		    </tbody>
		</table>
	</#list>
	<div class="pagination" style="float: right;">
	    <a href="#" class="first" data-action="first">&laquo;</a>
	    <a href="#" class="previous" data-action="previous">&lsaquo;</a>
	    <input type="text" readonly="readonly" data-current-page="${paging.page}" data-page-string="1 of 3" data-max-page="${paging.pageCount}" />
	    <a href="#" class="next" data-action="next">&rsaquo;</a>
	    <a href="#" class="last" data-action="last">&raquo;</a>
	</div>
	
</@root.html>


<script>
	function initpage() {
	      $('#name').val('${name!""}');
	      $('#seller_nick').val('${seller_nick!""}');
	      $('#status').val('${status!""}');
	}
	
    var LODOP; //声明为全局变量 
	function prn1_preview(sender, from, from_company, from_address, sender_mobile,
		receiver, to_company, to_address, receiver_mobile, to) {
		CreateOneFormPage();	
		LODOP.ADD_PRINT_SETUP_BKIMG("<img border='0' src='${rc.contextPath}/img/kuaidi/shentong.jpg'>");
		LODOP.SET_SHOW_MODE("BKIMG_IN_PREVIEW",1); //注："BKIMG_IN_PREVIEW"-预览包含背景图 "BKIMG_IN_FIRSTPAGE"- 仅首页包含背景图
		LODOP.SET_PRINT_STYLE("FontSize",18);
		LODOP.SET_PRINT_STYLE("Bold",1);
		LODOP.ADD_PRINT_TEXT(110,86,100,25,sender);
		LODOP.SET_PRINT_STYLEA(0,"FontSize",10);
		LODOP.ADD_PRINT_TEXT(109,253,111,26,from);
		LODOP.SET_PRINT_STYLEA(0,"FontSize",10);
		LODOP.ADD_PRINT_TEXT(150,87,260,25,from_company);
		LODOP.SET_PRINT_STYLEA(0,"FontSize",10);
		LODOP.ADD_PRINT_TEXT(187,79,302,62,from_address);
		LODOP.SET_PRINT_STYLEA(0,"FontSize",10);
		LODOP.ADD_PRINT_TEXT(259,103,164,25,sender_mobile);
		LODOP.SET_PRINT_STYLEA(0,"FontSize",10);
		LODOP.ADD_PRINT_TEXT(112,484,111,25,receiver);
		LODOP.SET_PRINT_STYLEA(0,"FontSize",10);
		LODOP.ADD_PRINT_TEXT(147,479,249,27,to_company);
		LODOP.SET_PRINT_STYLEA(0,"FontSize",10);
		LODOP.ADD_PRINT_TEXT(189,470,309,56,to_address);
		LODOP.SET_PRINT_STYLEA(0,"FontSize",10);
		LODOP.ADD_PRINT_TEXT(261,506,157,24,receiver_mobile);
		LODOP.SET_PRINT_STYLEA(0,"FontSize",10);
		LODOP.ADD_PRINT_TEXT(112,649,125,26,to);
		LODOP.SET_PRINT_STYLEA(0,"FontSize",10);
		//LODOP.PRINT_DESIGN();
		LODOP.PREVIEW();	
	};
	function prn1_print() {		
		CreateOneFormPage();
		LODOP.PRINT();	
	};
	function prn1_printA() {		
		CreateOneFormPage();
		LODOP.PRINTA(); 	
	};	
	function CreateOneFormPage(){
		LODOP=getLodop(document.getElementById('LODOP'),document.getElementById('LODOP_EM'));  
		LODOP.PRINT_INIT("打印控件功能演示_Lodop功能_表单一");
		LODOP.SET_PRINT_STYLE("FontSize",18);
		LODOP.SET_PRINT_STYLE("Bold",1);
		//LODOP.ADD_PRINT_TEXT(50,231,260,39,"打印页面部分内容");
		//LODOP.ADD_PRINT_HTM(88,200,350,600,document.getElementById("form1").innerHTML);
	};	                     
	function prn2_preview() {	
		CreateTwoFormPage();	
		LODOP.PREVIEW();	
	};
	function prn2_manage() {	
		CreateTwoFormPage();
		LODOP.PRINT_SETUP();	
	};	
	function CreateTwoFormPage(){
		LODOP=getLodop(document.getElementById('LODOP'),document.getElementById('LODOP_EM'));  
		LODOP.PRINT_INIT("打印控件功能演示_Lodop功能_表单二");
		LODOP.ADD_PRINT_RECT(70,27,634,242,0,1);
		LODOP.ADD_PRINT_TEXT(29,236,279,38,"页面内容改变布局打印");
		LODOP.SET_PRINT_STYLEA(2,"FontSize",18);
		LODOP.SET_PRINT_STYLEA(2,"Bold",1);
		LODOP.ADD_PRINT_HTM(88,40,321,185,document.getElementById("form1").innerHTML);
		LODOP.ADD_PRINT_HTM(87,355,285,187,document.getElementById("form2").innerHTML);
		LODOP.ADD_PRINT_TEXT(319,58,500,30,"注：其中《表单一》按显示大小，《表单二》在程序控制宽度(285px)内自适应调整");
	};              
	function prn3_preview(){
		LODOP=getLodop(document.getElementById('LODOP'),document.getElementById('LODOP_EM'));  
		LODOP.PRINT_INIT("打印控件功能演示_Lodop功能_全页");
		LODOP.ADD_PRINT_HTM(20,40,700,900,document.documentElement.innerHTML);
		LODOP.PREVIEW();	
	};	
	
	$(document).ready(function() {
		$('.cancel, .approve1, .submit, .no-goods, .find-goods, refund-success').click(function() {
			var action = $(this).attr("class");
			$.ajax({
	            type: "post",//使用get方法访问后台
	            dataType: "json",//返回json格式的数据
	            data: "tid=" + $(this).attr("data-tid") + "&action=" + action,
	            url: "${rc.contextPath}/trade/action/change_status",//要访问的后台地址
	            success: function(result){//msg为返回的数据，在这里做数据绑定
	                if(result.success == false) {
	                	alert(result.errorInfo);
	                } else {
	                	window.location.reload();
	                }
	            }}); 
		})
		
		$('.modify-delivery').click(function() {
			$(this).css("display", "none");
			$(this).next().css("display", "inline");
			$(this).next().next().css("display", "inline");
			$(this).prev().prev("span").css("display", "none");
			$(this).prev("select").css("display", "inline");
		})
		
		$('.modify-delivery-cancel').click(function() {
			$(this).css("display", "none");
			$(this).prev().css("display", "none");
			$(this).prev().prev().css("display", "inline");
			$(this).prev().prev().prev().prev("span").css("display", "inline");
			$(this).prev().prev().prev("select").css("display", "none");
		})
		
		$('.modify-delivery-submit').click(function() {
			var selected = $(this).prev().prev().val();
			var curr = $(this);
			$.ajax({
	            type: "post",//使用get方法访问后台
	            dataType: "json",//返回json格式的数据
	            data: "delivery=" + selected + "&tid=" + $(this).attr("data-tid") + "&goods=" + $(this).attr("data-goods") +
	            	"&quantity=" + $(this).attr("data-quantity") + "&province=" + $(this).attr("data-province"),
	            url: "${rc.contextPath}/trade/action/change_delivery",//要访问的后台地址
	            success: function(result){//msg为返回的数据，在这里做数据绑定
	                if(result.success == false) {
	                	alert(result.errorInfo);
	                } else {
	                	$(curr).css("display", "none");
	                	$(curr).next().css("display", "none");
	                	$(curr).prev().css("display", "inline");
	                	$(curr).prev().prev().css("display", "none");
	                	$(curr).prev().prev().prev().html(result.errorInfo);
	                	$(curr).prev().prev().prev().css("display", "inline");
	                }
	            }}); 
		})
	})
</script>