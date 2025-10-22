package com.zbkj.common.request.customerservice;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

/**
 * 客服配置请求对象
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value="CustomerServiceConfigRequest对象", description="客服配置请求对象")
public class CustomerServiceConfigRequest {

    @ApiModelProperty(value = "主键ID")
    private Integer id;

    @ApiModelProperty(value = "客服标题")
    private String title;

    @ApiModelProperty(value = "客服名称", required = true)
    @NotBlank(message = "客服名称不能为空")
    private String serviceName;

    @ApiModelProperty(value = "客服头像")
    private String serviceAvatar;

    @ApiModelProperty(value = "欢迎消息")
    private String welcomeMessage;

    @ApiModelProperty(value = "是否开启自动回复 0=关闭 1=开启")
    @NotNull(message = "自动回复设置不能为空")
    private Boolean autoReply;

    @ApiModelProperty(value = "自动回复消息")
    private String autoReplyMessage;

    @ApiModelProperty(value = "工作时间")
    private String workingHours;

    @ApiModelProperty(value = "离线消息")
    private String offlineMessage;

    @ApiModelProperty(value = "状态 false=离线 true=在线")
    @NotNull(message = "状态不能为空")
    private Boolean status;

    @ApiModelProperty(value = "排序")
    private Integer sort;

    @ApiModelProperty(value = "是否启用客服功能")
    private Boolean isEnabled;

    @ApiModelProperty(value = "工作开始时间")
    private String workingHoursStart;

    @ApiModelProperty(value = "工作结束时间")
    private String workingHoursEnd;
}
