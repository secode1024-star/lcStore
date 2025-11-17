package com.zbkj.common.model.translation;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
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
 * 翻译缓存表
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@TableName("eb_translation_cache")
@ApiModel(value="TranslationCache对象", description="翻译缓存表")
public class TranslationCache implements Serializable {

    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "主键ID")
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    @ApiModelProperty(value = "缓存键")
    @TableField("cache_key")
    private String cacheKey;

    @ApiModelProperty(value = "源文本哈希")
    @TableField("source_text_hash")
    private String sourceTextHash;

    @ApiModelProperty(value = "目标语言")
    @TableField("target_language")
    private String targetLanguage;

    @ApiModelProperty(value = "翻译后文本")
    @TableField("translated_text")
    private String translatedText;

    @ApiModelProperty(value = "命中次数")
    @TableField("hit_count")
    private Integer hitCount;

    @ApiModelProperty(value = "过期时间")
    @TableField("expire_time")
    private Date expireTime;

    @ApiModelProperty(value = "创建时间")
    @TableField("create_time")
    private Date createTime;

    @ApiModelProperty(value = "更新时间")
    @TableField("update_time")
    private Date updateTime;
}
