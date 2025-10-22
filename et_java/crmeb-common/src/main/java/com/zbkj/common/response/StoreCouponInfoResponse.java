package com.zbkj.common.response;

import com.zbkj.common.vo.SimpleProductVo;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;
import org.hibernate.validator.constraints.Range;

import javax.validation.constraints.Max;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * 优惠券信息响应对象
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value = "StoreCouponInfoResponse对象", description = "优惠券信息响应对象")
public class StoreCouponInfoResponse implements Serializable {

    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "优惠券ID")
    private Integer id;

    @ApiModelProperty(value = "优惠券名称")
    private String name;

    @ApiModelProperty(value = "优惠券金额")
    private BigDecimal money;

    @ApiModelProperty(value = "最小使用金额")
    private BigDecimal minPrice;

    @ApiModelProperty(value = "使用类型：1-商家券, 2-商品券, 3-平台券")
    private Integer useType;

    @ApiModelProperty(value = "商户ID")
    private Integer merId;

    @ApiModelProperty(value = "状态：0-关闭, 1-开启")
    private Boolean status;

    @ApiModelProperty(value = "开始领取时间")
    private Date receiveStartTime;

    @ApiModelProperty(value = "结束领取时间")
    private Date receiveEndTime;

    @ApiModelProperty(value = "开始使用时间")
    private Date useStartTime;

    @ApiModelProperty(value = "结束使用时间")
    private Date useEndTime;

    @ApiModelProperty(value = "关联的商品ID（商品券时有效）")
    private String primaryKey;

    @ApiModelProperty(value = "天数")
    @Max(value = 999, message = "天数不能超过999天")
    private Integer day;

    @ApiModelProperty(value = "优惠券类型 1 手动领取, 2 新人券, 3 赠送券")
    private Integer type;

    @ApiModelProperty(value = "排序")
    private Integer sort;

    @ApiModelProperty(value = "商品信息")
    private List<SimpleProductVo> productList;

}
