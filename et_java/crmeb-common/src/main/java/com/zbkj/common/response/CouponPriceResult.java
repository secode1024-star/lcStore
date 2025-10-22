package com.zbkj.common.response;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 优惠券价格计算结果
 * @author: ZhongYehai
 * @since: 2025-09-25
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value = "CouponPriceResult对象", description = "优惠券价格计算结果")
public class CouponPriceResult implements Serializable {

    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "原价")
    private BigDecimal originalPrice;

    @ApiModelProperty(value = "优惠金额")
    private BigDecimal discountAmount;

    @ApiModelProperty(value = "最终价格")
    private BigDecimal finalPrice;

    @ApiModelProperty(value = "是否可以使用")
    private Boolean canUse;

    @ApiModelProperty(value = "不可使用原因")
    private String reason;

    @ApiModelProperty(value = "是否有优惠券")
    private Boolean hasCoupon;

    @ApiModelProperty(value = "优惠券ID")
    private Integer couponId;

    @ApiModelProperty(value = "优惠券名称")
    private String couponName;

    @ApiModelProperty(value = "优惠券类型")
    private Integer couponType;

    /**
     * 创建无优惠券结果
     */
    public static CouponPriceResult noCoupon(BigDecimal originalPrice) {
        CouponPriceResult result = new CouponPriceResult();
        result.setOriginalPrice(originalPrice);
        result.setDiscountAmount(BigDecimal.ZERO);
        result.setFinalPrice(originalPrice);
        result.setCanUse(false);
        result.setHasCoupon(false);
        return result;
    }

    /**
     * 创建有优惠券结果
     */
    public static CouponPriceResult withCoupon(BigDecimal originalPrice, BigDecimal discountAmount, 
                                               BigDecimal finalPrice, Integer couponId, String couponName, 
                                               Integer couponType, String reason, Integer status) {
        CouponPriceResult result = new CouponPriceResult();
        result.setOriginalPrice(originalPrice);
        result.setDiscountAmount(discountAmount);
        result.setFinalPrice(finalPrice);
        result.setCanUse(status == 1);
        result.setHasCoupon(true);
        result.setCouponId(couponId);
        result.setCouponName(couponName);
        result.setCouponType(couponType);
        result.setReason(reason);
        return result;
    }
}
























