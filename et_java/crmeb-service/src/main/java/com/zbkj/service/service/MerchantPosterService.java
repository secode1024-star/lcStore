package com.zbkj.service.service;

import com.github.pagehelper.PageInfo;
import com.zbkj.common.request.MerchantPosterRequest;
import com.zbkj.common.request.MerchantPosterSearchRequest;
import com.zbkj.common.request.PageParamRequest;
import com.zbkj.common.response.MerchantPosterResponse;

import java.util.List;

/**
 * 商户海报服务接口
 * @author: ZhongYehai
 * @since: 2025-09-23
 */
public interface MerchantPosterService {

    /**
     * 获取商户海报列表
     * @param merId 商户ID
     * @param request 搜索条件
     * @param pageParamRequest 分页参数
     * @return 海报列表
     */
    PageInfo<MerchantPosterResponse> getMerchantList(Integer merId, MerchantPosterSearchRequest request, PageParamRequest pageParamRequest);

    /**
     * 根据ID和商户ID获取海报详情
     * @param id 海报ID
     * @param merId 商户ID
     * @return 海报详情
     */
    MerchantPosterResponse getByIdAndMerId(Integer id, Integer merId);

    /**
     * 创建海报
     * @param request 海报信息
     * @param merId 商户ID
     * @return 是否成功
     */
    Boolean create(MerchantPosterRequest request, Integer merId);

    /**
     * 更新海报
     * @param request 海报信息
     * @param merId 商户ID
     * @return 是否成功
     */
    Boolean update(MerchantPosterRequest request, Integer merId);

    /**
     * 删除海报
     * @param id 海报ID
     * @param merId 商户ID
     * @return 是否成功
     */
    Boolean delete(Integer id, Integer merId);

    /**
     * 批量删除海报
     * @param ids 海报ID列表
     * @param merId 商户ID
     * @return 是否成功
     */
    Boolean batchDelete(List<Integer> ids, Integer merId);

    /**
     * 生成海报
     * @param id 海报ID
     * @param merId 商户ID
     * @return 海报图片URL
     */
    String generatePoster(Integer id, Integer merId);

    /**
     * 更新海报状态
     * @param id 海报ID
     * @param status 状态
     * @param merId 商户ID
     * @return 是否成功
     */
    Boolean updateStatus(Integer id, Integer status, Integer merId);

    /**
     * 平台端获取所有海报列表（不限制商户）
     * @param request 搜索条件
     * @param pageParamRequest 分页参数
     * @return 海报列表
     */
    PageInfo<MerchantPosterResponse> getPlatformList(MerchantPosterSearchRequest request, PageParamRequest pageParamRequest);

    /**
     * 根据ID获取海报详情（平台端使用，不限制商户）
     * @param id 海报ID
     * @return 海报详情
     */
    MerchantPosterResponse getById(Integer id);

    /**
     * 平台端批量删除海报
     * @param ids 海报ID列表
     * @return 是否成功
     */
    Boolean platformBatchDelete(List<Integer> ids);
}



