package com.zbkj.service.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.zbkj.common.model.merchant.MerchantPoster;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Update;

/**
 * 商户海报Mapper接口
 * @author: ZhongYehai
 * @since: 2025-09-23
 */
@Mapper
public interface MerchantPosterDao extends BaseMapper<MerchantPoster> {

    /**
     * 执行原生SQL
     * @param sql SQL语句
     */
    @Update("${sql}")
    void executeSql(String sql);
}















