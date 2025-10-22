package com.zbkj.service.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zbkj.common.exception.CrmebException;
import com.zbkj.common.model.merchant.Merchant;
import com.zbkj.common.model.merchant.MerchantPoster;
import com.zbkj.common.request.MerchantPosterRequest;
import com.zbkj.common.request.MerchantPosterSearchRequest;
import com.zbkj.common.request.PageParamRequest;
import com.zbkj.common.response.MerchantPosterResponse;
import com.zbkj.service.dao.MerchantPosterDao;
import com.zbkj.service.service.MerchantPosterService;
import com.zbkj.service.service.MerchantService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

/**
| 商户海报服务实现
| @author: ZhongYehai
| @since: 2025-09-23
*/
@Slf4j
@Service
public class MerchantPosterServiceImpl implements MerchantPosterService {

    @Autowired
    private MerchantPosterDao merchantPosterDao;

    @Autowired
    private MerchantService merchantService;

    @Override
    public PageInfo<MerchantPosterResponse> getMerchantList(Integer merId, MerchantPosterSearchRequest request, PageParamRequest pageParamRequest) {
        PageHelper.startPage(pageParamRequest.getPage(), pageParamRequest.getLimit());
        
        // 构建查询条件
        LambdaQueryWrapper<MerchantPoster> wrapper = Wrappers.<MerchantPoster>lambdaQuery();
        wrapper.eq(MerchantPoster::getMerId, merId);
        wrapper.eq(MerchantPoster::getIsDel, false);
        
        // 添加搜索条件
        if (request != null) {
            if (StringUtils.hasText(request.getKeywords())) {
                wrapper.like(MerchantPoster::getTitle, request.getKeywords());
            }
            if (StringUtils.hasText(request.getType())) {
                wrapper.eq(MerchantPoster::getType, request.getType());
            }
            if (request.getStatus() != null) {
                wrapper.eq(MerchantPoster::getStatus, request.getStatus());
            }
        }
        
        // 按创建时间倒序
        wrapper.orderByDesc(MerchantPoster::getCreateTime);
        
        List<MerchantPoster> posters = merchantPosterDao.selectList(wrapper);
        
        // 转换为响应对象
        List<MerchantPosterResponse> responseList = posters.stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
        
        return new PageInfo<>(responseList);
    }

    @Override
    public MerchantPosterResponse getByIdAndMerId(Integer id, Integer merId) {
        LambdaQueryWrapper<MerchantPoster> wrapper = Wrappers.<MerchantPoster>lambdaQuery();
        wrapper.eq(MerchantPoster::getId, id);
        wrapper.eq(MerchantPoster::getMerId, merId);
        wrapper.eq(MerchantPoster::getIsDel, false);
        
        MerchantPoster poster = merchantPosterDao.selectOne(wrapper);
        if (poster == null) {
            return null;
        }
        
        return convertToResponse(poster);
    }

    @Override
    public Boolean create(MerchantPosterRequest request, Integer merId) {
        System.out.println("创建海报 - 商户ID: " + merId + ", 海报数据: " + request);
        
        MerchantPoster poster = new MerchantPoster();
        BeanUtils.copyProperties(request, poster);
        poster.setMerId(merId);
        poster.setIsDel(false);
        poster.setCreateTime(new Date());
        poster.setUpdateTime(new Date());
        
        int result = merchantPosterDao.insert(poster);
        return result > 0;
    }
    
    @Override
    public Boolean update(MerchantPosterRequest request, Integer merId) {
        System.out.println("更新海报 - 海报ID: " + request.getId() + ", 海报数据: " + request);
        
        MerchantPoster poster = merchantPosterDao.selectById(request.getId());
        if (poster == null || poster.getIsDel()) {
            throw new RuntimeException("海报不存在或已被删除");
        }
        
        BeanUtils.copyProperties(request, poster);
        poster.setUpdateTime(new Date());
        
        int result = merchantPosterDao.updateById(poster);
        return result > 0;
    }

    @Override
    public Boolean delete(Integer id, Integer merId) {
        System.out.println("删除海报 - 海报ID: " + id + ", 商户ID: " + merId);
        
        MerchantPoster poster = merchantPosterDao.selectById(id);
        if (poster == null || poster.getIsDel() || !poster.getMerId().equals(merId)) {
            throw new RuntimeException("海报不存在或无权删除");
        }
        
        poster.setIsDel(true);
        poster.setUpdateTime(new Date());
        int result = merchantPosterDao.updateById(poster);
        return result > 0;
    }

    @Override
    public Boolean batchDelete(List<Integer> ids, Integer merId) {
        if (ids == null || ids.isEmpty()) {
            return false;
        }
        
        List<MerchantPoster> postersToUpdate = new ArrayList<>();
        for (Integer id : ids) {
            MerchantPoster poster = merchantPosterDao.selectById(id);
            if (poster != null && !poster.getIsDel() && poster.getMerId().equals(merId)) {
                poster.setIsDel(true);
                poster.setUpdateTime(new Date());
                postersToUpdate.add(poster);
            }
        }
        
        if (postersToUpdate.isEmpty()) {
            return false;
        }
        
        for (MerchantPoster poster : postersToUpdate) {
            merchantPosterDao.updateById(poster);
        }
        
        return true;
    }

    @Override
    public PageInfo<MerchantPosterResponse> getPlatformList(MerchantPosterSearchRequest request, PageParamRequest pageParamRequest) {
        try {
            System.out.println("🔥🔥 进入 getPlatformList 方法");
            log.info("🔥 getPlatformList 开始执行");
            
            PageHelper.startPage(pageParamRequest.getPage(), pageParamRequest.getLimit());
            
            // 构建查询条件（平台端查询所有商户的海报）
            LambdaQueryWrapper<MerchantPoster> wrapper = Wrappers.<MerchantPoster>lambdaQuery();
            wrapper.eq(MerchantPoster::getIsDel, false);
            
            // 添加搜索条件
            if (request != null) {
                if (StringUtils.hasText(request.getKeywords())) {
                    wrapper.like(MerchantPoster::getTitle, request.getKeywords());
                }
                if (request.getMerId() != null) {
                    wrapper.eq(MerchantPoster::getMerId, request.getMerId());
                }
                if (StringUtils.hasText(request.getType())) {
                    wrapper.eq(MerchantPoster::getType, request.getType());
                }
            }
            
            wrapper.orderByDesc(MerchantPoster::getCreateTime);
            
            System.out.println("🔥🔥 开始查询数据库");
            log.info("🔥 开始查询海报数据");
            List<MerchantPoster> posterList = merchantPosterDao.selectList(wrapper);
            System.out.println("🔥🔥 查询到数据: " + posterList.size() + " 条");
            log.info("🔥 查询到海报数据: {} 条", posterList.size());
            
            System.out.println("🔥🔥 开始转换响应对象");
            log.info("🔥 开始转换响应对象");
            List<MerchantPosterResponse> responseList = posterList.stream()
                .map(poster -> {
                    try {
                        System.out.println("🔥🔥 转换海报 ID: " + poster.getId() + ", 商户ID: " + poster.getMerId());
                        return this.convertToResponse(poster);
                    } catch (Exception e) {
                        System.out.println("❌❌ 转换海报失败，ID: " + poster.getId() + ", 错误: " + e.getMessage());
                        log.error("❌ 转换海报失败，ID: {}, 错误: {}", poster.getId(), e.getMessage(), e);
                        throw new RuntimeException("转换海报失败: " + e.getMessage(), e);
                    }
                })
                .collect(Collectors.toList());
            
            System.out.println("🔥🔥 转换完成，返回结果");
            log.info("🔥 getPlatformList 执行完成");
            return new PageInfo<>(responseList);
        } catch (Exception e) {
            System.out.println("❌❌ getPlatformList 执行异常: " + e.getMessage());
            log.error("❌ getPlatformList 执行异常: {}", e.getMessage(), e);
            e.printStackTrace();
            throw new RuntimeException("获取平台海报列表失败: " + e.getMessage(), e);
        }
    }

    @Override
    public MerchantPosterResponse getById(Integer id) {
        MerchantPoster poster = merchantPosterDao.selectById(id);
        if (poster == null || poster.getIsDel()) {
            return null;
        }
        return convertToResponse(poster);
    }

    @Override
    public Boolean platformBatchDelete(List<Integer> ids) {
        System.out.println("🔥🔥 进入 platformBatchDelete 方法，IDs: " + ids);
        
        if (ids == null || ids.isEmpty()) {
            System.out.println("🔥🔥 IDs为空，返回false");
            return false;
        }
        
        // 批量物理删除
        for (Integer id : ids) {
            System.out.println("🔥🔥 开始处理海报ID: " + id);
            MerchantPoster poster = merchantPosterDao.selectById(id);
            if (poster != null) {
                System.out.println("🔥🔥 找到海报，执行物理删除: " + poster.getTitle());
                merchantPosterDao.deleteById(id);
                System.out.println("🔥🔥 物理删除完成，海报ID: " + id);
            } else {
                System.out.println("🔥🔥 未找到海报，ID: " + id);
            }
        }
        
        System.out.println("🔥🔥 platformBatchDelete 执行完成，返回true");
        return true;
    }
    
    /**
     * 重置AUTO_INCREMENT到最小可用值
     */
    private void resetAutoIncrement() {
        try {
            // 查询当前最小可用ID
            Integer minAvailableId = getMinAvailableId();
            
            // 直接执行SQL重置AUTO_INCREMENT
            String sql = "ALTER TABLE eb_merchant_poster AUTO_INCREMENT = " + minAvailableId;
            merchantPosterDao.executeSql(sql);
            
            System.out.println("🔥🔥 重置AUTO_INCREMENT到: " + minAvailableId);
        } catch (Exception e) {
            System.out.println("🔥🔥 重置AUTO_INCREMENT失败: " + e.getMessage());
        }
    }
    
    /**
     * 获取最小可用ID
     */
    private Integer getMinAvailableId() {
        try {
            // 查询所有存在的ID
            List<Integer> existingIds = merchantPosterDao.selectObjs(
                Wrappers.<MerchantPoster>lambdaQuery()
                    .select(MerchantPoster::getId)
                    .orderByAsc(MerchantPoster::getId)
            ).stream()
            .map(obj -> (Integer) obj)
            .collect(Collectors.toList());
            
            // 如果没有记录，从1开始
            if (existingIds.isEmpty()) {
                return 1;
            }
            
            // 寻找第一个空缺
            int expectedId = 1;
            for (Integer existingId : existingIds) {
                if (existingId > expectedId) {
                    return expectedId;
                }
                expectedId = existingId + 1;
            }
            
            // 没有空缺，返回下一个ID
            return expectedId;
        } catch (Exception e) {
            System.out.println("🔥🔥 获取最小可用ID失败: " + e.getMessage());
            return 1;
        }
    }

    /**
     * 生成海报
     * @param id 海报ID
     * @param merId 商户ID
     * @return 海报图片URL
     */
    @Override
    public String generatePoster(Integer id, Integer merId) {
        MerchantPoster poster = merchantPosterDao.selectById(id);
        if (poster == null || poster.getIsDel() || !poster.getMerId().equals(merId)) {
            throw new CrmebException("海报不存在或无权限操作");
        }
        // 这里可以添加实际的海报生成逻辑，例如调用图片处理库
        // 暂时返回一个模拟URL
        return "http://example.com/poster/" + id + ".jpg";
    }

    /**
     * 更新海报状态
     * @param id 海报ID
     * @param status 状态
     * @param merId 商户ID
     * @return 是否成功
     */
    @Override
    public Boolean updateStatus(Integer id, Integer status, Integer merId) {
        MerchantPoster poster = merchantPosterDao.selectById(id);
        if (poster == null || poster.getIsDel() || !poster.getMerId().equals(merId)) {
            throw new CrmebException("海报不存在或无权限操作");
        }
        poster.setStatus(status);
        poster.setUpdateTime(new Date());
        return merchantPosterDao.updateById(poster) > 0;
    }

    /**
     * 转换实体为响应对象
     */
    private MerchantPosterResponse convertToResponse(MerchantPoster poster) {
        try {
            System.out.println("🔥🔥 开始转换海报响应对象，ID: " + poster.getId());
            log.debug("🔥 开始转换海报响应对象，ID: {}", poster.getId());
            
            MerchantPosterResponse response = new MerchantPosterResponse();
            BeanUtils.copyProperties(poster, response);
            
            System.out.println("🔥🔥 基础属性复制完成，海报ID: " + poster.getId() + ", 商户ID: " + poster.getMerId());
            
            // 获取商户名称 - 简化版本，先设置默认值确保显示
            if (poster.getMerId() != null) {
                try {
                    System.out.println("🔥🔥 开始获取商户信息，商户ID: " + poster.getMerId());
                    Merchant merchant = merchantService.getById(poster.getMerId());
                    System.out.println("🔥🔥 获取商户信息完成，商户: " + (merchant != null ? merchant.getName() : "null"));
                    
                    if (merchant != null && !merchant.getIsDel()) {
                        response.setMerchantName(merchant.getName());
                        System.out.println("🔥🔥 设置商户名称: " + merchant.getName());
                    } else {
                        response.setMerchantName("商户ID: " + poster.getMerId());
                        System.out.println("🔥🔥 商户不存在或已删除，设置默认名称");
                    }
                } catch (Exception e) {
                    System.out.println("❌❌ 获取商户信息异常: " + e.getMessage());
                    log.error("❌ 获取商户信息异常，商户ID: {}, 错误: {}", poster.getMerId(), e.getMessage(), e);
                    response.setMerchantName("商户ID: " + poster.getMerId() + " (查询异常: " + e.getMessage() + ")");
                }
            } else {
                response.setMerchantName("无商户ID");
                System.out.println("🔥🔥 商户ID为空，设置默认名称");
            }
            
            System.out.println("🔥🔥 转换完成，海报ID: " + poster.getId() + ", 商户名称: " + response.getMerchantName());
            return response;
        } catch (Exception e) {
            System.out.println("❌❌ convertToResponse 异常: " + e.getMessage());
            log.error("❌ convertToResponse 异常，海报ID: {}, 错误: {}", poster != null ? poster.getId() : "null", e.getMessage(), e);
            e.printStackTrace();
            throw new RuntimeException("转换海报响应对象失败: " + e.getMessage(), e);
        }
    }
}