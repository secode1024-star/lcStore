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
 * 翻译失败记录表
 * 用于记录翻译失败的任务，支持手动重试
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@TableName("eb_translation_failure_record")
@ApiModel(value = "TranslationFailureRecord对象", description = "翻译失败记录表")
public class TranslationFailureRecord implements Serializable {

    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "失败记录ID")
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

    @ApiModelProperty(value = "失败原因")
    private String failureReason;

    @ApiModelProperty(value = "重试次数")
    private Integer retryCount;

    @ApiModelProperty(value = "最大重试次数")
    private Integer maxRetries;

    @ApiModelProperty(value = "状态：pending-待重试，retrying-重试中，success-已成功，failed-最终失败")
    private String status;

    @ApiModelProperty(value = "商户ID")
    private Integer merId;

    @ApiModelProperty(value = "创建时间")
    private Date createTime;

    @ApiModelProperty(value = "更新时间")
    private Date updateTime;

    @ApiModelProperty(value = "最后重试时间")
    private Date lastRetryTime;
}
