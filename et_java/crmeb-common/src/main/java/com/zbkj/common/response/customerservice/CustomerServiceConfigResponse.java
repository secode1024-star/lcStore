package com.zbkj.common.response.customerservice;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import java.util.Date;

/**
 * 客服配置响应对象
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value="CustomerServiceConfigResponse对象", description="客服配置响应对象")
public class CustomerServiceConfigResponse {

    @ApiModelProperty(value = "主键ID")
    private Integer id;

    @ApiModelProperty(value = "客服标题")
    private String title;

    @ApiModelProperty(value = "客服名称")
    private String serviceName;

    @ApiModelProperty(value = "客服头像")
    private String serviceAvatar;

    @ApiModelProperty(value = "欢迎消息")
    private String welcomeMessage;

    @ApiModelProperty(value = "是否开启自动回复 0=关闭 1=开启")
    private Boolean autoReply;

    @ApiModelProperty(value = "自动回复消息")
    private String autoReplyMessage;

    @ApiModelProperty(value = "工作时间")
    private String workingHours;

    @ApiModelProperty(value = "离线消息")
    private String offlineMessage;

    @ApiModelProperty(value = "状态 false=离线 true=在线")
    private Boolean status;

    @ApiModelProperty(value = "是否启用客服功能")
    private Boolean isEnabled;

    @ApiModelProperty(value = "排序")
    private Integer sort;

    @ApiModelProperty(value = "创建时间")
    private Date createTime;

    @ApiModelProperty(value = "更新时间")
    private Date updateTime;
}
