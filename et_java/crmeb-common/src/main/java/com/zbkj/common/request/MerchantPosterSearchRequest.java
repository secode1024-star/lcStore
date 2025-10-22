package com.zbkj.common.request;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import java.io.Serializable;

/**
 * 商户海报搜索请求对象
 * @author: ZhongYehai
 * @since: 2025-09-23
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value = "MerchantPosterSearchRequest对象", description = "商户海报搜索请求")
public class MerchantPosterSearchRequest implements Serializable {

    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "商户ID（平台端搜索使用）")
    private Integer merId;

    @ApiModelProperty(value = "搜索关键词（海报标题）")
    private String keywords;

    @ApiModelProperty(value = "海报类型：product-商品海报，store-店铺海报，activity-活动海报，custom-自定义海报")
    private String type;

    @ApiModelProperty(value = "状态：0-禁用，1-启用")
    private Integer status;

    @ApiModelProperty(value = "关联商品ID")
    private Integer productId;
}


















