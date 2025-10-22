package com.zbkj.common.response;

import com.zbkj.common.vo.CouponSimpleVo;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * 商品与优惠券响应对象
 * @author: ZhongYehai
 * @since: 2025-09-25
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value = "StoreProductWithCouponResponse对象", description = "商品与优惠券响应对象")
public class StoreProductWithCouponResponse implements Serializable {

    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "商品ID")
    private Integer id;

    @ApiModelProperty(value = "商户ID")
    private Integer merId;

    @ApiModelProperty(value = "商品图片")
    private String image;

    @ApiModelProperty(value = "轮播图")
    private String sliderImage;

    @ApiModelProperty(value = "商品名称")
    private String storeName;

    @ApiModelProperty(value = "商品简介")
    private String storeInfo;

    @ApiModelProperty(value = "关键字")
    private String keyword;

    @ApiModelProperty(value = "产品条码（一维码）")
    private String barCode;

    @ApiModelProperty(value = "分类id")
    private String cateId;

    @ApiModelProperty(value = "商品价格")
    private BigDecimal price;

    @ApiModelProperty(value = "会员价格")
    private BigDecimal vipPrice;

    @ApiModelProperty(value = "市场价")
    private BigDecimal otPrice;

    @ApiModelProperty(value = "邮费")
    private BigDecimal postage;

    @ApiModelProperty(value = "单位名")
    private String unitName;

    @ApiModelProperty(value = "排序")
    private Integer sort;

    @ApiModelProperty(value = "销量")
    private Integer sales;

    @ApiModelProperty(value = "库存")
    private Integer stock;

    @ApiModelProperty(value = "状态（0：未上架，1：上架）")
    private Boolean isShow;

    @ApiModelProperty(value = "是否热卖")
    private Boolean isHot;

    @ApiModelProperty(value = "是否优惠")
    private Boolean isBenefit;

    @ApiModelProperty(value = "是否精品")
    private Boolean isBest;

    @ApiModelProperty(value = "是否新品")
    private Boolean isNew;

    @ApiModelProperty(value = "产品描述")
    private String description;

    @ApiModelProperty(value = "添加时间")
    private Date createTime;

    @ApiModelProperty(value = "更新时间")
    private Date updateTime;

    @ApiModelProperty(value = "可用优惠券列表")
    private List<CouponSimpleVo> couponList;

    @ApiModelProperty(value = "优惠券价格计算结果")
    private CouponPriceResult couponPriceResult;

    @ApiModelProperty(value = "原始价格")
    private BigDecimal originalPrice;

    @ApiModelProperty(value = "最终价格")
    private BigDecimal finalPrice;

    @ApiModelProperty(value = "最优惠券金额")
    private BigDecimal bestCouponAmount;

    @ApiModelProperty(value = "可用优惠券")
    private List<StoreCouponInfoResponse> availableCoupons;

    @ApiModelProperty(value = "是否有可用优惠券")
    private Boolean hasCoupon;
}
























