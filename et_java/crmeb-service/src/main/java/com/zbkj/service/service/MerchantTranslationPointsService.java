package com.zbkj.service.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.zbkj.common.model.translation.MerchantTranslationPoints;

import java.util.Map;

/**
 * 商户翻译积分服务接口
 * +----------------------------------------------------------------------
 * | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
 * +----------------------------------------------------------------------
 */
public interface MerchantTranslationPointsService extends IService<MerchantTranslationPoints> {

    /**
     * 获取商户翻译积分信息
     * 
     * @param merId 商户ID
     * @return 积分信息
     */
    Map<String, Object> getPointsInfo(Integer merId);

    /**
     * 初始化或获取商户积分信息
     * 
     * @param merId 商户ID
     * @return 积分信息
     */
    MerchantTranslationPoints getOrInitPoints(Integer merId);

    /**
     * 更新翻译使用量
     * 
     * @param merId 商户ID
     * @param charCount 使用的字符数
     */
    void updateUsage(Integer merId, Integer charCount);

    /**
     * 为商户添加翻译积分
     * 积分规则：1积分 = 10,000字符
     * 
     * @param merId 商户ID
     * @param points 积分数量（1积分 = 10,000字符）
     */
    void addPoints(Integer merId, Integer points);
}



