package com.zbkj.common.request;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotEmpty;
import java.io.Serializable;
import java.util.List;
import java.util.Map;

/**
 * 批量翻译请求对象
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value = "BatchTranslateRequest对象", description = "批量翻译请求")
public class BatchTranslateRequest implements Serializable {

    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "待翻译文本列表", required = true)
    @NotEmpty(message = "待翻译文本列表不能为空")
    private List<String> texts;

    @ApiModelProperty(value = "源语言", required = true)
    @NotBlank(message = "源语言不能为空")
    private String sourceLang;

    @ApiModelProperty(value = "目标语言", required = true)
    @NotBlank(message = "目标语言不能为空")
    private String targetLang;

    @ApiModelProperty(value = "翻译服务商")
    private String provider;

    @ApiModelProperty(value = "商户ID")
    private Integer merId;

    @ApiModelProperty(value = "字段列表")
    private Map<String, String> fields;

    @ApiModelProperty(value = "目标语言列表")
    private List<String> targetLanguages;

    @ApiModelProperty(value = "实体ID")
    private Integer entityId;

    @ApiModelProperty(value = "实体类型")
    private String entityType;
}






