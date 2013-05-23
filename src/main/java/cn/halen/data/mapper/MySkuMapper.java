package cn.halen.data.mapper;

import org.mybatis.spring.support.SqlSessionDaoSupport;

import cn.halen.data.pojo.MySku;

public class MySkuMapper extends SqlSessionDaoSupport {

	public int insert(MySku sku) {
		int count = getSqlSession().insert("cn.halen.data.mapper.SkuMapper.insert", sku);
		return count;
	}
	
	public int delete(int id) {
		int count = getSqlSession().delete("cn.halen.data.mapper.SkuMapper.delete", id);
		return count;
	}
	
	public int update(MySku sku) {
		int count = getSqlSession().update("cn.halen.data.mapper.SkuMapper.update", sku);
		return count;
	}
	
	public MySku select(MySku sku) {
		return getSqlSession().selectOne("cn.halen.data.mapper.SkuMapper.select", sku);
	}
	
	public MySku select(long skuId) {
		return getSqlSession().selectOne("cn.halen.data.mapper.SkuMapper.selectBySkuId", skuId);
	}
}
