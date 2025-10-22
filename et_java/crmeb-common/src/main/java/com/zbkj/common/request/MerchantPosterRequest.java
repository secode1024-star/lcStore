package com.zbkj.common.request;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.io.Serializable;

/**
 * 商户海报请求对象
 * @author: ZhongYehai
 * @since: 2025-09-23
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value = "MerchantPosterRequest对象", description = "商户海报请求对象")
public class MerchantPosterRequest implements Serializable {

    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "海报ID")
    private Integer id;

    @ApiModelProperty(value = "商户ID（平台端使用）")
    private Integer merId;

    @ApiModelProperty(value = "海报标题")
    @NotBlank(message = "海报标题不能为空")
    private String title;

    @ApiModelProperty(value = "海报类型：product-商品海报，store-店铺海报，activity-活动海报，custom-自定义海报")
    @NotBlank(message = "海报类型不能为空")
    private String type;

    @ApiModelProperty(value = "关联商品ID（商品海报时必填）")
    private Integer productId;

    @ApiModelProperty(value = "海报宽度")
    @NotNull(message = "海报宽度不能为空")
    private Integer width;

    @ApiModelProperty(value = "海报高度")
    @NotNull(message = "海报高度不能为空")
    private Integer height;

    @ApiModelProperty(value = "背景颜色")
    private String backgroundColor;

    @ApiModelProperty(value = "主标题")
    private String mainTitle;

    @ApiModelProperty(value = "副标题")
    private String subTitle;

    @ApiModelProperty(value = "描述信息")
    private String description;

    @ApiModelProperty(value = "字体大小")
    private Integer fontSize;

    @ApiModelProperty(value = "字体颜色")
    private String fontColor;

    @ApiModelProperty(value = "是否显示二维码")
    private Boolean showQrCode;

    @ApiModelProperty(value = "二维码内容")
    private String qrCodeContent;

    @ApiModelProperty(value = "二维码大小")
    private Integer qrCodeSize;

    @ApiModelProperty(value = "二维码位置")
    private String qrCodePosition;

    @ApiModelProperty(value = "模板ID")
    private Integer templateId;

    @ApiModelProperty(value = "配置JSON")
    private String configJson;

    @ApiModelProperty(value = "海报URL")
    private String posterUrl;

    @ApiModelProperty(value = "预览图URL")
    private String previewUrl;

    @ApiModelProperty(value = "状态：0-禁用，1-启用")
    private Integer status;

    @ApiModelProperty(value = "生成的海报图片URL")
    private String posterImage;

}

