package com.zbkj.front.controller;

import com.alibaba.fastjson.JSONObject;
import com.zbkj.common.request.StrToBaseRequest;
import com.zbkj.common.request.UrlToBase64Request;
import com.zbkj.common.result.CommonResult;
import com.zbkj.common.vo.QrCodeVo;
import com.zbkj.service.service.QrCodeService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;


/**
 * 二维码控制器
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

@Slf4j
@RestController
@RequestMapping("api/front/qrcode")
@Api(tags = "二维码控制器")
public class QrCodeController {

    @Autowired
    private QrCodeService qrCodeService;

    @ApiOperation(value = "远程图片转base64")
    @RequestMapping(value = "/url/to/base64", method = RequestMethod.POST)
    public CommonResult<QrCodeVo> urlToBase64(@RequestBody UrlToBase64Request request) {
        return CommonResult.success(qrCodeService.urlToBase64(request.getUrl()));
    }

    @ApiOperation(value = "字符串转base64")
    @RequestMapping(value = "/str/to/base64", method = RequestMethod.POST)
    public CommonResult<QrCodeVo> strToBase64(@Validated @RequestBody StrToBaseRequest request) {
        return CommonResult.success(qrCodeService.strToBase64(request.getText(), request.getWidth(), request.getHeight()));
    }
}



