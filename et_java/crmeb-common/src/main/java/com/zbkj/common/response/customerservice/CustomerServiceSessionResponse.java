package com.zbkj.common.response.customerservice;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import java.util.Date;

/**
 * 客服会话响应对象
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value="CustomerServiceSessionResponse对象", description="客服会话响应对象")
public class CustomerServiceSessionResponse {

    @ApiModelProperty(value = "主键ID")
    private Integer id;

    @ApiModelProperty(value = "会话ID")
    private String sessionId;

    @ApiModelProperty(value = "用户ID")
    private Integer userId;

    @ApiModelProperty(value = "用户名称")
    private String userName;

    @ApiModelProperty(value = "用户头像")
    private String userAvatar;

    @ApiModelProperty(value = "客服ID")
    private Integer serviceId;

    @ApiModelProperty(value = "客服名称")
    private String serviceName;

    @ApiModelProperty(value = "最后一条消息")
    private String lastMessage;

    @ApiModelProperty(value = "最后消息时间")
    private Date lastMessageTime;

    @ApiModelProperty(value = "未读消息数")
    private Integer unreadCount;

    @ApiModelProperty(value = "会话状态 0=关闭 1=进行中")
    private Boolean status;

    @ApiModelProperty(value = "创建时间")
    private Date createTime;
}






