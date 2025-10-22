package com.zbkj.common.request;

import com.zbkj.common.constants.RegularConstants;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import java.io.Serializable;

/**
 * 修改密码请求对象
 *  +----------------------------------------------------------------------
 *  | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
 *  +----------------------------------------------------------------------
 *  | Copyright (c) 2016~2025 https://www.crmeb.com All rights reserved.
 *  +----------------------------------------------------------------------
 *  | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
 *  +----------------------------------------------------------------------
 *  | Author: CRMEB Team <admin@crmeb.com>
 *  +----------------------------------------------------------------------
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value="UpdatePasswordRequest对象", description="修改密码请求对象")
public class UpdatePasswordRequest implements Serializable {

    private static final long serialVersionUID=1L;

    @ApiModelProperty(value = "新密码", required = true)
    @NotBlank(message = "{validation.password.empty}")
    @Pattern(regexp = RegularConstants.PASSWORD, message = "{validation.password.format}")
    private String newPassword;

    @ApiModelProperty(value = "重复新密码", required = true)
    @NotBlank(message = "{validation.password.repeat.empty}")
    @Pattern(regexp = RegularConstants.PASSWORD, message = "{validation.password.repeat.format}")
    private String passwordAgain;

    @ApiModelProperty(value = "验证码", required = true)
    @NotBlank(message = "{validation.captcha.empty}")
    @Pattern(regexp = RegularConstants.VALIDATE_CODE_NUM_SIX, message = "{validation.captcha.format}")
    private String captcha;


}
