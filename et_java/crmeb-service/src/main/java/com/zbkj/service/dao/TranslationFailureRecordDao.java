package com.zbkj.service.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.zbkj.common.model.translation.TranslationFailureRecord;
import org.apache.ibatis.annotations.Mapper;

/**
 * 翻译失败记录 Mapper 接口
 */
@Mapper
public interface TranslationFailureRecordDao extends BaseMapper<TranslationFailureRecord> {

}
