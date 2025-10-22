package com.zbkj.common.request;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotBlank;

/**
 * X OAuth 2.0 登录请求对象
 * +----------------------------------------------------------------------
 * | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
 * +----------------------------------------------------------------------
 * | Copyright (c) 2016~2025 https://www.crmeb.com All rights reserved.
 * +----------------------------------------------------------------------
 * | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
 * +----------------------------------------------------------------------
 * | Author: CRMEB Team <admin@crmeb.com>
 * +----------------------------------------------------------------------
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value="XOAuth2LoginRequest对象", description="X OAuth 2.0 登录请求对象")
public class XOAuth2LoginRequest {
    private static final long serialVersionUID=1L;

    @ApiModelProperty(value = "授权码", required = true)
    @NotBlank(message = "授权码不能为空")
    private String authorizationCode;

    @ApiModelProperty(value = "客户端ID", required = true)
    @NotBlank(message = "客户端ID不能为空")
    private String clientId;

    @ApiModelProperty(value = "代码验证器", required = true)
    @NotBlank(message = "代码验证器不能为空")
    private String codeVerifier;

    @ApiModelProperty(value = "重定向URI", required = true)
    @NotBlank(message = "重定向URI不能为空")
    private String redirectUri;

    @ApiModelProperty(value = "状态参数")
    private String state;
}
