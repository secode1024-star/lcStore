package com.zbkj.common.request.customerservice;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

/**
 * 发送消息请求对象
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value="SendMessageRequest对象", description="发送消息请求对象")
public class SendMessageRequest {

    @ApiModelProperty(value = "会话ID", required = true)
    @NotBlank(message = "会话ID不能为空")
    private String sessionId;

    @ApiModelProperty(value = "消息类型 1=文本 2=图片 3=文件", required = true)
    @NotNull(message = "消息类型不能为空")
    private Integer messageType;

    @ApiModelProperty(value = "消息内容", required = true)
    @NotBlank(message = "消息内容不能为空")
    private String content;
}






