package com.zbkj.service.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.github.pagehelper.PageInfo;
import com.zbkj.common.model.order.OrderDetail;
import com.zbkj.common.request.CommonSearchRequest;
import com.zbkj.common.request.PageParamRequest;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
*  OrderDetailService 接口
*  +----------------------------------------------------------------------
*  | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
*  +----------------------------------------------------------------------
*  | Copyright (c) 2016~2025 https://www.crmeb.com All rights reserved.
*  +----------------------------------------------------------------------
*  | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
*  +----------------------------------------------------------------------
*  | Author: CRMEB Team <admin@crmeb.com>
*  +----------------------------------------------------------------------
*/
public interface OrderDetailService extends IService<OrderDetail> {

    /**
     * 根据主订单号获取
     * @param orderNo 订单编号
     * @return List
     */
    List<OrderDetail> getByOrderNo(String orderNo);

    /**
     * 是否已购买（已收货后才算已购）
     */
    Boolean isPurchased(Integer proId, Integer userId);


    /**
     * 获取已购商品列表
     * @param pageParamRequest 分页参数
     * @return PageInfo
     */
    PageInfo<OrderDetail> findPurchasedList(Integer userId, PageParamRequest pageParamRequest);
}
