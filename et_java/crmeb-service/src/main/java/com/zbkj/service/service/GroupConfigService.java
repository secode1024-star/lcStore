package com.zbkj.service.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.github.pagehelper.PageInfo;
import com.zbkj.common.model.system.GroupConfig;

import java.util.List;

/**
 * GroupConfigService 接口
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
public interface GroupConfigService extends IService<GroupConfig> {

    /**
     * 通过tag获取数据列表
     *
     * @param tag 标签
     * @param sortRule 排序规则
     * @param status 展示状态：1-展示
     */
    List<GroupConfig> findByTag(Integer tag, String sortRule, Boolean status);



    GroupConfig getByIdException(Integer id);



    /**
     * 通过tag和商户ID删除数据
     *
     * @param tag 标签
     * @param merId 商户ID
     */
    Boolean deleteByTagAndMerId(Integer tag, Integer merId);



    /**
     * 是否存在推荐板块名称
     * @param name 名称
     * @param tag 标签
     */
    Boolean isExistName(String name, Integer tag);

    /**
     * 按tag删除
     */
    Boolean deleteByTag(Integer tag, Integer merId);


}
