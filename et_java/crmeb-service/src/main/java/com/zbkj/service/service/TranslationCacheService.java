package com.zbkj.service.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.zbkj.common.model.translation.TranslationCache;

/**
 * 翻译缓存服务接口
 */
public interface TranslationCacheService extends IService<TranslationCache> {

    /**
     * 根据缓存键获取缓存
     */
    TranslationCache getByCacheKey(String cacheKey);

    /**
     * 增加命中次数
     */
    void incrementHitCount(String cacheKey);
}



