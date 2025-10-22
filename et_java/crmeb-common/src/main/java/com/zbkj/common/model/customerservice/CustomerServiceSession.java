package com.zbkj.common.model.customerservice;

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
 * 客服会话表
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@TableName("eb_customer_service_session")
@ApiModel(value="CustomerServiceSession对象", description="客服会话表")
public class CustomerServiceSession implements Serializable {

    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "主键ID")
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    @ApiModelProperty(value = "用户ID")
    private Integer userId;

    @ApiModelProperty(value = "管理员ID")
    private Integer adminId;

    @ApiModelProperty(value = "会话唯一标识")
    private String sessionKey;

    @ApiModelProperty(value = "会话状态 0=已结束 1=进行中")
    private Integer status;

    @ApiModelProperty(value = "最后消息时间")
    private Date lastMessageTime;

    @ApiModelProperty(value = "创建时间")
    private Date createTime;

    @ApiModelProperty(value = "更新时间")
    private Date updateTime;
}
