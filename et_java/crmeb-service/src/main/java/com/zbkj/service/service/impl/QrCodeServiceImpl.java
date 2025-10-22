package com.zbkj.service.service.impl;

import cn.hutool.core.util.ObjectUtil;
import cn.hutool.http.HttpRequest;
import cn.hutool.http.HttpResponse;
import com.alibaba.fastjson.JSONObject;
import com.zbkj.common.exception.CrmebException;
import com.zbkj.common.result.CommonResultCode;
import com.zbkj.common.utils.CrmebUtil;
import com.zbkj.common.utils.MessageUtils;
import com.zbkj.common.utils.QRCodeUtil;
import com.zbkj.common.vo.QrCodeVo;
import com.zbkj.service.service.QrCodeService;
import org.apache.commons.codec.binary.Base64;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * QrCodeServiceImpl 接口实现
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
@Service
public class QrCodeServiceImpl implements QrCodeService {

    /**
     * 远程图片转base64
     *
     * @param url 图片链接地址
     * @return QrCodeVo
     */
    @Override
    public QrCodeVo urlToBase64(String url) {
        HttpResponse httpResponse = HttpRequest.get(url).execute();
        byte[] bytes = httpResponse.bodyBytes();
        ;
        String base64Image = CrmebUtil.getBase64Image(Base64.encodeBase64String(bytes));
        QrCodeVo vo = new QrCodeVo();
        vo.setCode(base64Image);
        return vo;
    }

    /**
     * 字符串转base64
     *
     * @param text 待转换字符串
     * @return QrCodeVo base64格式
     */
    @Override
    public QrCodeVo strToBase64(String text, Integer width, Integer height) {
        if ((width < 50 || height < 50) && (width > 500 || height > 500) && text.length() >= 999) {
            throw new CrmebException(CommonResultCode.VALIDATE_FAILED,MessageUtils.message("service.qrCode.error.a"));
        }
        String base64Image;
        try {
            base64Image = QRCodeUtil.crateQRCode(text, width, height);
        } catch (Exception e) {
            throw new CrmebException(MessageUtils.message("service.qrCode.error.b"));
        }
        QrCodeVo vo = new QrCodeVo();
        vo.setCode(base64Image);
        return vo;
    }
}

