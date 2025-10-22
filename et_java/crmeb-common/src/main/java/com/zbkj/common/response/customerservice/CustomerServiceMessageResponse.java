package com.zbkj.common.response.customerservice;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import java.util.Date;

/**
 * 客服消息响应对象
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value="CustomerServiceMessageResponse对象", description="客服消息响应对象")
public class CustomerServiceMessageResponse {

    @ApiModelProperty(value = "主键ID")
    private Integer id;

    @ApiModelProperty(value = "会话ID")
    private String sessionId;

    @ApiModelProperty(value = "发送者类型 1=用户 2=客服")
    private Integer senderType;

    @ApiModelProperty(value = "发送者ID")
    private Integer senderId;

    @ApiModelProperty(value = "发送者名称")
    private String senderName;

    @ApiModelProperty(value = "发送者头像")
    private String senderAvatar;

    @ApiModelProperty(value = "消息类型 1=文本 2=图片 3=文件")
    private Integer messageType;

    @ApiModelProperty(value = "消息内容")
    private String content;

    @ApiModelProperty(value = "是否已读 0=未读 1=已读")
    private Boolean isRead;

    @ApiModelProperty(value = "阅读时间")
    private Date readTime;

    @ApiModelProperty(value = "创建时间")
    private Date createTime;
}






