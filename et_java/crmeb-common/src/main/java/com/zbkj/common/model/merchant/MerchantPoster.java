package com.zbkj.common.model.merchant;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.Date;

/**
 * 商户海报实体类
 * @author: ZhongYehai
 * @since: 2025-09-23
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@TableName("eb_merchant_poster")
@ApiModel(value = "MerchantPoster对象", description = "商户海报")
public class MerchantPoster implements Serializable {

    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "海报ID")
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    @ApiModelProperty(value = "商户ID")
    private Integer merId;

    @ApiModelProperty(value = "海报标题")
    private String title;

    @ApiModelProperty(value = "海报类型：product-商品海报，store-店铺海报，activity-活动海报，custom-自定义海报")
    private String type;

    @ApiModelProperty(value = "关联商品ID（商品海报时使用）")
    private Integer productId;

    @ApiModelProperty(value = "海报宽度（像素）")
    private Integer width;

    @ApiModelProperty(value = "海报高度（像素）")
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

    @ApiModelProperty(value = "是否显示二维码：0-不显示，1-显示")
    private Boolean showQrCode;

    @ApiModelProperty(value = "二维码内容（通常是商品详情页链接）")
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

    @ApiModelProperty(value = "生成的海报图片URL")
    private String posterImage;

    @ApiModelProperty(value = "状态：0-草稿，1-已发布，2-已下架")
    private Integer status;

    @ApiModelProperty(value = "是否删除：0-未删除，1-已删除")
    private Boolean isDel;

    @ApiModelProperty(value = "创建时间")
    private Date createTime;

    @ApiModelProperty(value = "更新时间")
    private Date updateTime;
}




