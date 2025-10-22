package com.zbkj.service.service.impl;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zbkj.common.constants.CouponConstants;
import com.zbkj.common.constants.DateConstants;
import com.zbkj.common.exception.CrmebException;
import com.zbkj.common.model.coupon.StoreCoupon;
import com.zbkj.common.model.coupon.StoreCouponUser;
import com.zbkj.common.model.product.StoreProduct;
import com.zbkj.common.model.system.SystemAdmin;
import com.zbkj.common.page.CommonPage;
import com.zbkj.common.request.CouponSearchRequest;
import com.zbkj.common.request.PageParamRequest;
import com.zbkj.common.request.StoreCouponRequest;
import com.zbkj.common.request.StoreCouponSearchRequest;
import com.zbkj.common.response.CouponPriceResult;
import com.zbkj.common.response.StoreCouponFrontResponse;
import com.zbkj.common.response.StoreCouponInfoResponse;
import com.zbkj.common.utils.CrmebUtil;
import com.zbkj.common.utils.DateUtil;
import com.zbkj.common.utils.MessageUtils;
import com.zbkj.common.utils.SecurityUtil;
import com.zbkj.common.vo.CouponSimpleVo;
import com.zbkj.common.vo.SimpleProductVo;
import com.zbkj.common.model.product.StoreProductCoupon;
import com.zbkj.service.service.StoreProductCouponService;
import com.zbkj.service.dao.StoreCouponDao;
import com.zbkj.service.service.StoreCouponService;
import com.zbkj.service.service.StoreCouponUserService;
import com.zbkj.service.service.StoreProductService;
import com.zbkj.service.service.UserService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;

/**
 * StoreCouponServiceImpl 接口实现
 * +----------------------------------------------------------------------
 * | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
 * +----------------------------------------------------------------------
 * | Copyright (c) 2016~2025 https://www.crmeb.com All rights reserved.
 * +----------------------------------------------------------------------
 * | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
 * +----------------------------------------------------------------------
 * | Author: CRMEB Team <admin@crmeb.com>
 * +----------------------------------------------------------------------
 */
@Slf4j
@Service
public class StoreCouponServiceImpl extends ServiceImpl<StoreCouponDao, StoreCoupon> implements StoreCouponService {

    @Resource
    private StoreCouponDao dao;

    @Autowired
    private StoreProductService storeProductService;

    @Autowired
    private StoreCouponUserService storeCouponUserService;

    @Autowired
    private UserService userService;

    @Autowired
    private StoreProductCouponService storeProductCouponService;


    /**
     * 保存优惠券表
     * @param request StoreCouponRequest 新增参数
     * @author Mr.Zhang
     * @since 2020-05-18
     */
    @Override
    public boolean create(StoreCouponRequest request) {
        SystemAdmin systemAdmin = SecurityUtil.getLoginUserVo().getUser();
        StoreCoupon storeCoupon = new StoreCoupon();
        BeanUtils.copyProperties(request, storeCoupon);
        if (storeCoupon.getIsLimited() && (storeCoupon.getTotal() == null || storeCoupon.getTotal() == 0)) {
            throw new CrmebException(MessageUtils.message("service.storeCoupon.error.b"));
        }
        if (request.getUseType().equals(CouponConstants.COUPON_USE_TYPE_PRODUCT) && (StrUtil.isBlank(request.getPrimaryKey()))) {
            throw new CrmebException(MessageUtils.message("service.storeCoupon.error.a"));
        }
        storeCoupon.setLastTotal(storeCoupon.getTotal());
        if (!request.getIsForever()) {
            storeCoupon.setReceiveStartTime(DateUtil.nowDateTime()); //开始时间设置为当前时间
        }else{
            if (storeCoupon.getReceiveStartTime() == null || storeCoupon.getReceiveEndTime() == null) {
                throw new CrmebException(MessageUtils.message("service.storeCoupon.error.c"));
            }
            int compareDate = DateUtil.compareDate(DateUtil.dateToStr(storeCoupon.getReceiveStartTime(), DateConstants.DATE_FORMAT), DateUtil.dateToStr(storeCoupon.getReceiveEndTime(), DateConstants.DATE_FORMAT), DateConstants.DATE_FORMAT);
            if (compareDate > -1) {
                throw new CrmebException(MessageUtils.message("service.storeCoupon.error.e"));
            }
        }
        //非固定时间, 领取后多少天
        if (!request.getIsFixedTime()) {
            if (storeCoupon.getDay() == null || storeCoupon.getDay() == 0) {
                throw new CrmebException(MessageUtils.message("service.storeCoupon.error.d"));
            }
            storeCoupon.setUseStartTime(null);
            storeCoupon.setUseEndTime(null);
        }
        storeCoupon.setMerId(systemAdmin.getMerId());
        return save(storeCoupon);
    }

    /**
     * 获取详情
     * @param id Integer id
     * @return StoreCoupon
     */
    @Override
    public StoreCoupon getInfoException(Integer id) {
        //获取优惠券信息
        StoreCoupon storeCoupon = getById(id);
        checkException(storeCoupon);

        return storeCoupon;
    }

    /**
     * 检测当前优惠券是否正常
     * @param storeCoupon StoreCoupon 优惠券对象`
     * @author Mr.Zhang
     * @since 2020-05-18
     */
    private void checkException(StoreCoupon storeCoupon) {
        if (storeCoupon == null || storeCoupon.getIsDel() || !storeCoupon.getStatus()) {
            throw new CrmebException(MessageUtils.message("service.storeCoupon.error.f"));
        }

        //看是否过期
        if (!(storeCoupon.getReceiveEndTime() == null || storeCoupon.getReceiveEndTime().equals(""))) {
            //非永久可领取
            String date = DateUtil.nowDateTimeStr();
            int result = DateUtil.compareDate(date, DateUtil.dateToStr(storeCoupon.getReceiveEndTime(), DateConstants.DATE_FORMAT), DateConstants.DATE_FORMAT);
            if (result == 1) {
                //过期了
                throw new CrmebException(MessageUtils.message("service.storeCoupon.error.i"));
            }
        }

        //看是否有剩余数量
        if (storeCoupon.getIsLimited()) {
            //考虑到并发溢出的问题用大于等于
            if (storeCoupon.getLastTotal() < 1) {
                throw new CrmebException(MessageUtils.message("service.storeCoupon.error.j"));
            }
        }
    }

    /**
     * 优惠券详情
     * @param id Integer 获取可用优惠券的商品id
     * @return StoreCouponInfoResponse
     */
    @Override
    public StoreCouponInfoResponse info(Integer id) {
        SystemAdmin systemAdmin = SecurityUtil.getLoginUserVo().getUser();
        StoreCoupon storeCoupon = getByIdAndMerIdException(id, systemAdmin.getMerId());
        if (!storeCoupon.getStatus()) {
            throw new CrmebException(MessageUtils.message("service.storeCoupon.error.h"));
        }

        List<SimpleProductVo> productList = null;
        if (StrUtil.isNotBlank(storeCoupon.getPrimaryKey()) && storeCoupon.getUseType().equals(CouponConstants.COUPON_USE_TYPE_PRODUCT)) {
            List<Integer> primaryIdList = CrmebUtil.stringToArray(storeCoupon.getPrimaryKey());
            productList = storeProductService.getSimpleListInIds(primaryIdList);
        }

        StoreCouponInfoResponse infoResponse = new StoreCouponInfoResponse();
        BeanUtils.copyProperties(storeCoupon, infoResponse);
        return infoResponse;
    }

    private StoreCoupon getByIdAndMerIdException(Integer id, Integer merId) {
        LambdaQueryWrapper<StoreCoupon> lqw = Wrappers.lambdaQuery();
        lqw.eq(StoreCoupon::getId, id);
        lqw.eq(StoreCoupon::getMerId, merId);
        lqw.eq(StoreCoupon::getIsDel, false);
        lqw.last(" limit 1");
        StoreCoupon storeCoupon = dao.selectOne(lqw);
        if (ObjectUtil.isNull(storeCoupon)) {
            throw new CrmebException(MessageUtils.message("service.storeCoupon.error.g"));
        }
        return storeCoupon;
    }

    /**
     * 扣减数量
     * @param id 优惠券id
     * @param num 数量
     * @param isLimited 是否限量
     */
    @Override
    public Boolean deduction(Integer id, Integer num, Boolean isLimited) {
        UpdateWrapper<StoreCoupon> updateWrapper = new UpdateWrapper<>();
        if (isLimited) {
            updateWrapper.setSql(StrUtil.format("last_total = last_total - {}", num));
            updateWrapper.last(StrUtil.format(" and (last_total - {} >= 0)", num));
        } else {
            updateWrapper.setSql(StrUtil.format("last_total = last_total + {}", num));
        }
        updateWrapper.eq("id", id);
        return update(updateWrapper);
    }

    /**
     * 获取用户注册赠送新人券
     * @return List<StoreCoupon>
     */
    @Override
    public List<StoreCoupon> findRegisterList() {
        String dateStr = DateUtil.nowDate(DateConstants.DATE_FORMAT);
        LambdaQueryWrapper<StoreCoupon> lqw = new LambdaQueryWrapper<>();
        lqw.eq(StoreCoupon::getType, 2);
        lqw.eq(StoreCoupon::getStatus, true);
        lqw.eq(StoreCoupon::getIsDel, false);
        lqw.le(StoreCoupon::getReceiveStartTime, dateStr);
        List<StoreCoupon> list = dao.selectList(lqw);
        if (CollUtil.isEmpty(list)) {
            return CollUtil.newArrayList();
        }
        List<StoreCoupon> couponList = list.stream().filter(coupon -> {
            // 是否限量
            if (coupon.getIsLimited() && coupon.getLastTotal() <= 0) {
                return false;
            }
            // 判断是否达到可领取时间
            if (ObjectUtil.isNotNull(coupon.getReceiveStartTime())) {
                //非永久可领取
                int result = DateUtil.compareDate(dateStr, DateUtil.dateToStr(coupon.getReceiveStartTime(), DateConstants.DATE_FORMAT), DateConstants.DATE_FORMAT);
                if (result == -1) {
                    // 未开始
                    return false;
                }
            }

            // 是否有领取结束时间
            if (ObjectUtil.isNotNull(coupon.getReceiveEndTime())) {
                int compareDate = DateUtil.compareDate(dateStr, DateUtil.dateToStr(coupon.getReceiveEndTime(), DateConstants.DATE_FORMAT), DateConstants.DATE_FORMAT);
                if (compareDate > 0) {
                    return false;
                }
            }
            return true;
        }).collect(Collectors.toList());
        return couponList;
    }

    /**
     * 删除优惠券
     * @param id 优惠券id
     * @return Boolean
     */
    @Override
    public Boolean delete(Integer id) {
        SystemAdmin systemAdmin = SecurityUtil.getLoginUserVo().getUser();
        StoreCoupon coupon = getByIdAndMerIdException(id, systemAdmin.getMerId());
        coupon.setIsDel(true);
        return dao.updateById(coupon) > 0;
    }

    /**
     * 移动端优惠券列表
     * @param request 查询参数
     * @param pageParamRequest 分页参数
     * @return List<StoreCouponFrontResponse>
     */
    @Override
    public PageInfo<StoreCouponFrontResponse> getH5List(CouponSearchRequest request, PageParamRequest pageParamRequest) {
        // 获取优惠券列表
        PageInfo<StoreCoupon> pageInfo = getListByReceive(request.getUseType(), request.getMerId(), request.getProductId(), pageParamRequest);
        List<StoreCoupon> list = pageInfo.getList();
        if (ObjectUtil.isNull(list)) {
            return CommonPage.copyPageInfo(pageInfo, CollUtil.newArrayList());
        }
        //获取用户当前已领取未使用的优惠券
        HashMap<Integer, StoreCouponUser> couponUserMap = null;
        Integer userId = userService.getUserId();
        if (userId > 0) {
            couponUserMap = storeCouponUserService.getMapByUserId(userId);
        }
        List<StoreCouponFrontResponse> storeCouponFrontResponseArrayList = new ArrayList<>();
        for (StoreCoupon storeCoupon : list) {
            StoreCouponFrontResponse response = new StoreCouponFrontResponse();
            BeanUtils.copyProperties(storeCoupon, response);

            if (userId > 0) {
                if (CollUtil.isNotEmpty(couponUserMap) && couponUserMap.containsKey(storeCoupon.getId())) {
                    response.setIsUse(true);
                }
            }

            if (response.getReceiveEndTime() == null) {
                response.setReceiveStartTime(null);
            }

            // 更改使用时间格式，去掉时分秒
            response.setUseStartTimeStr(DateUtil.dateToStr(storeCoupon.getUseStartTime(), DateConstants.DATE_FORMAT_DATE));
            response.setUseEndTimeStr(DateUtil.dateToStr(storeCoupon.getUseEndTime(), DateConstants.DATE_FORMAT_DATE));
            storeCouponFrontResponseArrayList.add(response);
        }
        return CommonPage.copyPageInfo(pageInfo, storeCouponFrontResponseArrayList);
    }

    /**
     * 修改优惠券状态
     * @param id 优惠券id
     */
    @Override
    public Boolean updateStatus(Integer id) {
        SystemAdmin systemAdmin = SecurityUtil.getLoginUserVo().getUser();
        StoreCoupon coupon = getByIdAndMerIdException(id, systemAdmin.getMerId());
        StoreCoupon storeCoupon = new StoreCoupon();
        storeCoupon.setId(id);
        storeCoupon.setStatus(!coupon.getStatus());
        return updateById(storeCoupon);
    }

    /**
     * 商户端优惠券分页列表
     * @param request 查询参数
     * @param pageParamRequest 分页参数
     * @return PageInfo
     */
    @Override
    public PageInfo<StoreCoupon> getMerchantPageList(StoreCouponSearchRequest request, PageParamRequest pageParamRequest) {
        SystemAdmin systemAdmin = SecurityUtil.getLoginUserVo().getUser();
        Page<StoreCoupon> page = PageHelper.startPage(pageParamRequest.getPage(), pageParamRequest.getLimit());
        //带 StoreCoupon 类的多条件查询
        LambdaQueryWrapper<StoreCoupon> lqw = new LambdaQueryWrapper<>();
        lqw.eq(StoreCoupon::getMerId, systemAdmin.getMerId());
        lqw.eq(StoreCoupon::getIsDel, false);
        if (ObjectUtil.isNotNull(request.getUseType())) {
            lqw.eq(StoreCoupon::getUseType, request.getUseType());
        }
        if (ObjectUtil.isNotNull(request.getType())) {
            lqw.eq(StoreCoupon::getType, request.getType());
        }
        if (ObjectUtil.isNotNull(request.getStatus())) {
            lqw.eq(StoreCoupon::getStatus, request.getStatus());
        }
        if (StrUtil.isNotBlank(request.getName())) {
            lqw.like(StoreCoupon::getName, request.getName());
        }
        lqw.orderByDesc(StoreCoupon::getSort).orderByDesc(StoreCoupon::getId);
        List<StoreCoupon> couponList = dao.selectList(lqw);
        return CommonPage.copyPageInfo(page, couponList);
    }

    /**
     * 商品可用优惠券列表（商品创建时选择使用）
     * @return List
     */
    @Override
    public List<StoreCoupon> getProductUsableList() {
        SystemAdmin systemAdmin = SecurityUtil.getLoginUserVo().getUser();
        //带 StoreCoupon 类的多条件查询
        LambdaQueryWrapper<StoreCoupon> lqw = new LambdaQueryWrapper<>();
        lqw.eq(StoreCoupon::getMerId, systemAdmin.getMerId());
        lqw.eq(StoreCoupon::getIsDel, false);
        lqw.eq(StoreCoupon::getType, CouponConstants.COUPON_TYPE_GIVE_AWAY);
        lqw.eq(StoreCoupon::getStatus, 1);
        lqw.orderByDesc(StoreCoupon::getSort).orderByDesc(StoreCoupon::getId);
        return dao.selectList(lqw);
    }

    /**
     * 获取优惠券简单对象列表
     * @param idList id列表
     * @return List
     */
    @Override
    public List<CouponSimpleVo> findSimpleListByIdList(List<Integer> idList) {
        LambdaQueryWrapper<StoreCoupon> lqw = Wrappers.lambdaQuery();
        lqw.select(StoreCoupon::getId, StoreCoupon::getName);
        lqw.in(StoreCoupon::getId, idList);
        lqw.eq(StoreCoupon::getIsDel, false);
        List<StoreCoupon> couponList = dao.selectList(lqw);
        return couponList.stream().map(coupon -> {
            CouponSimpleVo simpleVo = new CouponSimpleVo();
            simpleVo.setId(coupon.getId());
            simpleVo.setName(coupon.getName());
            return simpleVo;
        }).collect(Collectors.toList());
    }

    /**
     * 用户可领取的优惠券
     * @return List<StoreCoupon>
     */
    private PageInfo<StoreCoupon> getListByReceive(Integer useType, Integer merId, Integer productId, PageParamRequest pageParamRequest) {
        Date date = DateUtil.nowDateTime();
        //带 StoreCoupon 类的多条件查询
        LambdaQueryWrapper<StoreCoupon> lqw = new LambdaQueryWrapper<>();
        lqw.eq(StoreCoupon::getIsDel, false);
        lqw.eq(StoreCoupon::getStatus, 1);
        //剩余数量大于0 或者不设置上限
        lqw.and(i -> i.gt(StoreCoupon::getLastTotal, 0).or().eq(StoreCoupon::getIsLimited, false));
        //领取时间范围, 结束时间为null则是不限时
        lqw.and(i -> i.isNull(StoreCoupon::getReceiveEndTime).or( p -> p.lt(StoreCoupon::getReceiveStartTime, date).gt(StoreCoupon::getReceiveEndTime, date)));
        // 用户使用时间范围，结束时间为null则是不限时
        lqw.and(i -> i.isNull(StoreCoupon::getUseEndTime).or(p -> p.gt(StoreCoupon::getUseEndTime, date)));
        lqw.eq(StoreCoupon::getType, 1);
        switch (useType) {
            case 1:
                lqw.eq(StoreCoupon::getUseType, CouponConstants.COUPON_USE_TYPE_MERCHANT);
                if (ObjectUtil.isNotNull(merId) && merId > 0) {
                    lqw.eq(StoreCoupon::getMerId, merId);
                }
                break;
            case 2:
                lqw.eq(StoreCoupon::getUseType, CouponConstants.COUPON_USE_TYPE_PRODUCT);
                if (ObjectUtil.isNotNull(merId) && merId > 0) {
                    lqw.eq(StoreCoupon::getMerId, merId);
                }
                if (ObjectUtil.isNotNull(productId) && productId > 0) {
                    StoreProduct storeProduct = storeProductService.getById(productId);
                    lqw.eq(StoreCoupon::getMerId, storeProduct.getMerId());
                    lqw.apply(CrmebUtil.getFindInSetSql("primary_key", productId.toString()));
                }
                break;
            case 3:
                lqw.eq(StoreCoupon::getUseType, CouponConstants.COUPON_USE_TYPE_PLATFORM);
                break;
        }
        lqw.orderByDesc(StoreCoupon::getSort).orderByDesc(StoreCoupon::getId);
        Page<StoreCoupon> page = PageHelper.startPage(pageParamRequest.getPage(), pageParamRequest.getLimit());
        List<StoreCoupon> couponList = dao.selectList(lqw);
        return CommonPage.copyPageInfo(page, couponList);
    }

    @Override
    public List<StoreCoupon> findAvailableCouponsByProductId(Integer productId, Integer merId) {
        System.out.println("=== 🔍 开始查询商品优惠券 - 商品ID: " + productId + ", 商户ID: " + merId + " ===");
        log.info("🔍 开始查询商品优惠券 - 商品ID: {}, 商户ID: {}", productId, merId);
        List<StoreCoupon> availableCoupons = new ArrayList<>();
        Date now = new Date();

        // 1. 查询商品券（use_type = 2）
        LambdaQueryWrapper<StoreCoupon> productCouponWrapper = Wrappers.lambdaQuery();
        productCouponWrapper.eq(StoreCoupon::getUseType, CouponConstants.COUPON_USE_TYPE_PRODUCT)
                .eq(StoreCoupon::getStatus, true)
                .eq(StoreCoupon::getIsDel, false)
                .le(StoreCoupon::getReceiveStartTime, now)
                .and(wrapper -> wrapper.isNull(StoreCoupon::getReceiveEndTime).or().ge(StoreCoupon::getReceiveEndTime, now))
                .and(wrapper -> wrapper.isNull(StoreCoupon::getUseStartTime).or().le(StoreCoupon::getUseStartTime, now))
                .and(wrapper -> wrapper.isNull(StoreCoupon::getUseEndTime).or().ge(StoreCoupon::getUseEndTime, now))
                .like(StoreCoupon::getPrimaryKey, productId.toString());
        List<StoreCoupon> productCoupons = dao.selectList(productCouponWrapper);
        System.out.println("=== 📦 商品券查询结果: 找到 " + productCoupons.size() + " 个商品券 ===");
        log.info("📦 商品券查询结果: 找到 {} 个商品券", productCoupons.size());
        availableCoupons.addAll(productCoupons);

        // 2. 查询商家券（use_type = 1）
        LambdaQueryWrapper<StoreCoupon> merchantCouponWrapper = Wrappers.lambdaQuery();
        merchantCouponWrapper.eq(StoreCoupon::getUseType, CouponConstants.COUPON_USE_TYPE_MERCHANT)
                .eq(StoreCoupon::getStatus, true)
                .eq(StoreCoupon::getIsDel, false)
                .eq(StoreCoupon::getMerId, merId)
                .le(StoreCoupon::getReceiveStartTime, now)
                .and(wrapper -> wrapper.isNull(StoreCoupon::getReceiveEndTime).or().ge(StoreCoupon::getReceiveEndTime, now))
                .and(wrapper -> wrapper.isNull(StoreCoupon::getUseStartTime).or().le(StoreCoupon::getUseStartTime, now))
                .and(wrapper -> wrapper.isNull(StoreCoupon::getUseEndTime).or().ge(StoreCoupon::getUseEndTime, now));
        List<StoreCoupon> merchantCoupons = dao.selectList(merchantCouponWrapper);
        log.info("🏪 商家券查询结果: 找到 {} 个商家券", merchantCoupons.size());
        availableCoupons.addAll(merchantCoupons);

        // 3. 查询平台券（use_type = 3）
        LambdaQueryWrapper<StoreCoupon> platformCouponWrapper = Wrappers.lambdaQuery();
        platformCouponWrapper.eq(StoreCoupon::getUseType, CouponConstants.COUPON_USE_TYPE_PLATFORM)
                .eq(StoreCoupon::getStatus, true)
                .eq(StoreCoupon::getIsDel, false)
                .le(StoreCoupon::getReceiveStartTime, now)
                .and(wrapper -> wrapper.isNull(StoreCoupon::getReceiveEndTime).or().ge(StoreCoupon::getReceiveEndTime, now))
                .and(wrapper -> wrapper.isNull(StoreCoupon::getUseStartTime).or().le(StoreCoupon::getUseStartTime, now))
                .and(wrapper -> wrapper.isNull(StoreCoupon::getUseEndTime).or().ge(StoreCoupon::getUseEndTime, now));
        List<StoreCoupon> platformCoupons = dao.selectList(platformCouponWrapper);
        availableCoupons.addAll(platformCoupons);

        // 4. 通过商品优惠券关联表查询
        List<StoreProductCoupon> productCouponRelations = storeProductCouponService.getListByProductId(productId);
        log.info("🔗 商品优惠券关联表查询结果: 找到 {} 个关联记录", productCouponRelations.size());
        if (CollUtil.isNotEmpty(productCouponRelations)) {
            List<Integer> couponIds = productCouponRelations.stream()
                    .map(StoreProductCoupon::getIssueCouponId)
                    .collect(Collectors.toList());
            
            LambdaQueryWrapper<StoreCoupon> relationCouponWrapper = Wrappers.lambdaQuery();
            relationCouponWrapper.in(StoreCoupon::getId, couponIds)
                    .eq(StoreCoupon::getStatus, true)
                    .eq(StoreCoupon::getIsDel, false)
                    .le(StoreCoupon::getReceiveStartTime, now)
                    .and(wrapper -> wrapper.isNull(StoreCoupon::getReceiveEndTime).or().ge(StoreCoupon::getReceiveEndTime, now))
                    .and(wrapper -> wrapper.isNull(StoreCoupon::getUseStartTime).or().le(StoreCoupon::getUseStartTime, now))
                    .and(wrapper -> wrapper.isNull(StoreCoupon::getUseEndTime).or().ge(StoreCoupon::getUseEndTime, now));
            List<StoreCoupon> relationCoupons = dao.selectList(relationCouponWrapper);
            availableCoupons.addAll(relationCoupons);
        }
        
        // 去重并按优惠金额倒序排列
        List<StoreCoupon> finalCoupons = availableCoupons.stream()
                .distinct()
                .filter(coupon -> coupon.getMoney() != null && coupon.getMoney().compareTo(BigDecimal.ZERO) > 0)
                .sorted((c1, c2) -> c2.getMoney().compareTo(c1.getMoney()))
                .collect(Collectors.toList());
        
        log.info("✅ 优惠券查询完成 - 商品ID: {}, 最终找到 {} 个可用优惠券", productId, finalCoupons.size());
        if (!finalCoupons.isEmpty()) {
            StoreCoupon bestCoupon = finalCoupons.get(0);
            log.info("🎯 最优优惠券: ID={}, 名称={}, 金额={}, 类型={}", 
                bestCoupon.getId(), bestCoupon.getName(), bestCoupon.getMoney(), bestCoupon.getUseType());
        }
        
        return finalCoupons;
    }

    @Override
    public CouponPriceResult calculateProductCouponPrice(Integer productId, BigDecimal originalPrice, Integer merId) {
        log.info("💰 开始计算商品优惠价格 - 商品ID: {}, 原价: {}, 商户ID: {}", productId, originalPrice, merId);
        
        if (productId == null || originalPrice == null || merId == null) {
            log.warn("⚠️ 参数不完整，返回无优惠券结果");
            return CouponPriceResult.noCoupon(originalPrice != null ? originalPrice : BigDecimal.ZERO);
        }
        
        List<StoreCoupon> availableCoupons = findAvailableCouponsByProductId(productId, merId);
        
        if (CollUtil.isEmpty(availableCoupons)) {
            return CouponPriceResult.noCoupon(originalPrice);
        }
        
        StoreCoupon bestCoupon = availableCoupons.get(0);
        
        BigDecimal discountAmount = bestCoupon.getMoney();
        BigDecimal finalPrice = originalPrice.subtract(discountAmount);
        
        if (finalPrice.compareTo(BigDecimal.ZERO) < 0) {
            finalPrice = BigDecimal.valueOf(0.01);
        }
        
        String couponTypeDesc = getCouponTypeDesc(bestCoupon.getUseType());
        
        return CouponPriceResult.withCoupon(
                originalPrice,
                finalPrice,
                discountAmount,
                bestCoupon.getId(),
                bestCoupon.getName(),
                bestCoupon.getUseType(),
                couponTypeDesc,
                bestCoupon.getMerId()
        );
    }

    /**
     * 获取优惠券类型描述
     */
    private String getCouponTypeDesc(Integer useType) {
        if (useType == null) {
            return "未知";
        }
        if (useType.equals(CouponConstants.COUPON_USE_TYPE_MERCHANT)) {
            return "商家券";
        } else if (useType.equals(CouponConstants.COUPON_USE_TYPE_PRODUCT)) {
            return "商品券";
        } else if (useType.equals(CouponConstants.COUPON_USE_TYPE_PLATFORM)) {
            return "平台券";
        } else {
            return "未知";
        }
    }

}

