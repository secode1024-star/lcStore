package com.zbkj.common.model.translation;

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
 * 商户翻译积分表
 * +----------------------------------------------------------------------
 * | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
 * +----------------------------------------------------------------------
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@TableName("eb_merchant_translation_points")
@ApiModel(value="MerchantTranslationPoints对象", description="商户翻译积分表")
public class MerchantTranslationPoints implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    @ApiModelProperty(value = "主键ID")
    private Integer id;

    @ApiModelProperty(value = "商户ID")
    private Integer merId;

    @ApiModelProperty(value = "累计翻译字符数")
    private Long totalChars;

    @ApiModelProperty(value = "已使用字符数")
    private Long usedChars;

    @ApiModelProperty(value = "剩余可用字符数")
    private Long remainingChars;

    @ApiModelProperty(value = "累计翻译次数")
    private Integer totalTranslations;

    @ApiModelProperty(value = "上次重置时间")
    private Date lastResetTime;

    @ApiModelProperty(value = "创建时间")
    private Date createTime;

    @ApiModelProperty(value = "更新时间")
    private Date updateTime;
}
