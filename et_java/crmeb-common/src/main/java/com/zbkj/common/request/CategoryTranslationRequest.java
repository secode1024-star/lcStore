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
 * 分类翻译请求对象
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value="CategoryTranslationRequest对象", description="分类翻译请求对象")
public class CategoryTranslationRequest implements Serializable {

    private static final long serialVersionUID=1L;

    @ApiModelProperty(value = "源语言", required = true)
    @NotBlank(message = "源语言不能为空")
    private String sourceLang;

    @ApiModelProperty(value = "目标语言", required = true)
    @NotBlank(message = "目标语言不能为空")
    private String targetLang;

    @ApiModelProperty(value = "原始文本", required = true)
    @NotBlank(message = "原始文本不能为空")
    private String originalText;

    @ApiModelProperty(value = "实体ID")
    private Integer entityId;

    @ApiModelProperty(value = "实体类型")
    private String entityType;

    @ApiModelProperty(value = "翻译服务商")
    private String provider;

    @ApiModelProperty(value = "商户ID")
    private Integer merId;
}









