package com.zbkj.service.service.impl;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.core.util.URLUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zbkj.common.model.order.OrderDetail;
import com.zbkj.common.page.CommonPage;
import com.zbkj.common.request.CommonSearchRequest;
import com.zbkj.common.request.PageParamRequest;
import com.zbkj.service.dao.OrderDetailDao;
import com.zbkj.service.service.OrderDetailService;
import com.zbkj.service.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
*  OrderDetailServiceImpl 接口实现
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
@Service
public class OrderDetailServiceImpl extends ServiceImpl<OrderDetailDao, OrderDetail> implements OrderDetailService {

    @Resource
    private OrderDetailDao dao;
    @Autowired
    private OrderService orderService;

    /**
     * 根据主订单号获取
     * @param orderNo 订单编号
     * @return List
     */
    @Override
    public List<OrderDetail> getByOrderNo(String orderNo) {
        LambdaQueryWrapper<OrderDetail> lqw = Wrappers.lambdaQuery();
        lqw.eq(OrderDetail::getOrderNo, orderNo);
        return dao.selectList(lqw);
    }


    /**
     * 是否已购买（已收货后才算已购）
     */
    @Override
    public Boolean isPurchased(Integer proId, Integer userId) {
        LambdaQueryWrapper<OrderDetail> lqw = Wrappers.lambdaQuery();
        lqw.select(OrderDetail::getId);
        lqw.eq(OrderDetail::getProductId, proId);
        lqw.eq(OrderDetail::getUid, userId);
        lqw.gt(OrderDetail::getMerId, 0);
        lqw.eq(OrderDetail::getIsReceipt, 1);
        lqw.last("limit 1");
        OrderDetail orderDetail = dao.selectOne(lqw);
        return ObjectUtil.isNotNull(orderDetail) ? Boolean.TRUE : Boolean.FALSE;
    }

    /**
     * 获取已购商品列表
     * @param pageParamRequest 分页参数
     * @return PageInfo
     */
    @Override
    public PageInfo<OrderDetail> findPurchasedList(Integer userId, PageParamRequest pageParamRequest) {
        Page<OrderDetail> page = PageHelper.startPage(pageParamRequest.getPage(), pageParamRequest.getLimit());
        LambdaQueryWrapper<OrderDetail> lqw = Wrappers.lambdaQuery();
        lqw.select(OrderDetail::getId, OrderDetail::getProductId);
        lqw.eq(OrderDetail::getUid, userId);
        lqw.gt(OrderDetail::getMerId, 0);
        lqw.eq(OrderDetail::getIsReceipt, 1);
        lqw.eq(OrderDetail::getProductMarketingType, 0);
        lqw.in(OrderDetail::getProductType, 0,2,5,6);
        lqw.groupBy(OrderDetail::getProductId);
        lqw.orderByDesc(OrderDetail::getId);
        List<OrderDetail> detailList = dao.selectList(lqw);
        return CommonPage.copyPageInfo(page, detailList);
    }

}

