package com.zbkj.service.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zbkj.common.model.translation.TranslationCache;
import com.zbkj.service.dao.TranslationCacheDao;
import com.zbkj.service.service.TranslationCacheService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * 翻译缓存服务实现
 */
@Service
public class TranslationCacheServiceImpl extends ServiceImpl<TranslationCacheDao, TranslationCache>
        implements TranslationCacheService {

    @Resource
    private TranslationCacheDao dao;

    @Override
    public TranslationCache getByCacheKey(String cacheKey) {
        LambdaQueryWrapper<TranslationCache> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(TranslationCache::getCacheKey, cacheKey)
               .last("limit 1");
        return dao.selectOne(wrapper);
    }


    @Override
    public void incrementHitCount(String cacheKey) {
        LambdaUpdateWrapper<TranslationCache> wrapper = Wrappers.lambdaUpdate();
        wrapper.eq(TranslationCache::getCacheKey, cacheKey)
               .setSql("hit_count = hit_count + 1");
        dao.update(null, wrapper);
    }
}



