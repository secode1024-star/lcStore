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
 * 翻译记录表
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@TableName("eb_translation")
@ApiModel(value = "Translation对象", description = "翻译记录表")
public class Translation implements Serializable {

    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "翻译记录ID")
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    @ApiModelProperty(value = "实体类型")
    private String entityType;

    @ApiModelProperty(value = "实体ID")
    private Integer entityId;

    @ApiModelProperty(value = "字段名称")
    private String fieldName;

    @ApiModelProperty(value = "源语言")
    private String sourceLanguage;

    @ApiModelProperty(value = "目标语言")
    private String targetLanguage;

    @ApiModelProperty(value = "源文本")
    private String sourceText;

    @ApiModelProperty(value = "译文")
    private String translatedText;

    @ApiModelProperty(value = "翻译服务商")
    private String translationProvider;

    @ApiModelProperty(value = "字符数量")
    private Integer charCount;

    @ApiModelProperty(value = "缓存键")
    private String cacheKey;

    @ApiModelProperty(value = "是否缓存")
    private Boolean isCached;

    @ApiModelProperty(value = "商户ID")
    private Integer merId;

    @ApiModelProperty(value = "创建时间")
    private Date createTime;

    @ApiModelProperty(value = "更新时间")
    private Date updateTime;
}