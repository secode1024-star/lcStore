package com.zbkj.service.service.impl;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zbkj.common.constants.RedisConstants;
import com.zbkj.common.exception.CrmebException;
import com.zbkj.common.model.product.ProductCategory;
import com.zbkj.common.request.ProductCategoryRequest;
import com.zbkj.common.utils.MessageUtils;
import com.zbkj.common.utils.RedisUtil;
import com.zbkj.common.vo.ProCategoryCacheTree;
import com.zbkj.common.vo.ProCategoryCacheVo;
import com.zbkj.service.dao.ProductCategoryDao;
import com.zbkj.service.service.ProductBrandCategoryService;
import com.zbkj.service.service.ProductCategoryService;
import com.zbkj.service.service.StoreProductService;
import com.zbkj.service.service.SystemAttachmentService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.stream.Collectors;

/**
*  ProductCategoryServiceImpl 接口实现
*  +----------------------------------------------------------------------
*  | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
*  +----------------------------------------------------------------------
*  | Copyright (c) 2016~2025 https://www.crmeb.com All rights reserved.
*  +----------------------------------------------------------------------
*  | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
*  +----------------------------------------------------------------------
*  | Author: CRMEB Team <admin@crmeb.com>
*  +----------------------------------------------------------------------
*/
@Service
public class ProductCategoryServiceImpl extends ServiceImpl<ProductCategoryDao, ProductCategory> implements ProductCategoryService {

    @Resource
    private ProductCategoryDao dao;

    @Autowired
    private RedisUtil redisUtil;
    @Autowired
    private SystemAttachmentService systemAttachmentService;
    @Autowired
    private StoreProductService productService;
    @Autowired
    private ProductBrandCategoryService productBrandCategoryService;
    @Autowired
    private com.zbkj.service.service.TranslationService translationService;

    /**
     * 获取分类列表
     */
    @Override
    public List<ProductCategory> getAdminList() {
        LambdaQueryWrapper<ProductCategory> lqw = Wrappers.lambdaQuery();
        lqw.eq(ProductCategory::getIsDel, false);
        lqw.orderByDesc(ProductCategory::getSort);
        lqw.orderByAsc(ProductCategory::getId);
        return dao.selectList(lqw);
    }

    /**
     * 添加商品分类
     * @param request 添加参数
     * @return Boolean
     */
    @Override
    public Boolean add(ProductCategoryRequest request) {
        if (checkName(request.getName())) {
            throw new CrmebException(MessageUtils.message("service.productCategory.error.a"));
        }
        ProductCategory productCategory = new ProductCategory();
        BeanUtils.copyProperties(request, productCategory);
        productCategory.setId(null);
        productCategory.setPid(0);
        if (!request.getLevel().equals(1)) {
            if (request.getPid().equals(0)) {
                throw new CrmebException(MessageUtils.message("service.productCategory.error.b"));
            }
            productCategory.setPid(request.getPid());
        }
        if (StrUtil.isNotEmpty(productCategory.getIcon())) {
            productCategory.setIcon(systemAttachmentService.clearPrefix(productCategory.getIcon()));
        }
        boolean save = save(productCategory);
        if (save) {
            redisUtil.delete(RedisConstants.PRODUCT_CATEGORY_CACHE_LIST_KEY);
            redisUtil.delete(RedisConstants.PRODUCT_CATEGORY_CACHE_MERCHANT_LIST_KEY);
        }
        return save;
    }

    /**
     * 删除分类
     * @param id 分类ID
     * @return Boolean
     * 删除时，需要判断分类是否被使用
     * 1.是否被品牌关联
     * 2.是否被商品使用
     * 后续改成如果1，2级分类，有子分类时无法删除
     */
    @Override
    public Boolean delete(Integer id) {
        ProductCategory category = getByIdException(id);
        if (category.getLevel() < 3) {
            List<ProductCategory> categoryList = findAllChildListByPid(category.getId(), category.getLevel());
            if (CollUtil.isNotEmpty(categoryList)) {
                throw new CrmebException(MessageUtils.message("service.productCategory.error.c"));
            }
        }
        // 判断是否有商品使用该分类
        if (productService.isUsePlatformCategory(category.getId())) {
            throw new CrmebException(MessageUtils.message("service.productCategory.error.d"));
        }
        // 判断是否品牌关联该分类
        if (productBrandCategoryService.isExistCategory(category.getId())) {
            throw new CrmebException(MessageUtils.message("service.productCategory.error.e"));
        }
        category.setIsDel(true);
        boolean update = updateById(category);
        if (update) {
            redisUtil.delete(RedisConstants.PRODUCT_CATEGORY_CACHE_LIST_KEY);
            redisUtil.delete(RedisConstants.PRODUCT_CATEGORY_CACHE_MERCHANT_LIST_KEY);
        }
        return update;
    }

    /**
     * 修改分类
     * @param request 修改参数
     * @return Boolean
     */
    @Override
    public Boolean edit(ProductCategoryRequest request) {
        if (ObjectUtil.isNull(request.getId()) || ObjectUtil.isNull(request.getPid())) {
            throw new CrmebException(MessageUtils.message("service.productCategory.error.f"));
        }
        ProductCategory oldCategory = getByIdException(request.getId());
        if (!oldCategory.getName().equals(request.getName())) {
            if (checkName(request.getName())) {
                throw new CrmebException(MessageUtils.message("service.productCategory.error.a"));
            }
        }
        // 如果分类级别更改，三级分类修改时，需要判断是否有商品/品牌 使用该分类
        if (oldCategory.getLevel().equals(3) && !request.getLevel().equals(3)) {
            // 判断是否有商品使用该分类
            if (productService.isUsePlatformCategory(oldCategory.getId())) {
                throw new CrmebException(MessageUtils.message("service.productCategory.error.g"));
            }
            // 判断是否品牌关联该分类
            if (productBrandCategoryService.isExistCategory(oldCategory.getId())) {
                throw new CrmebException(MessageUtils.message("service.productCategory.error.h"));
            }
        }

        ProductCategory category = new ProductCategory();
        BeanUtils.copyProperties(request, category);
        category.setPid(oldCategory.getPid());
        if (StrUtil.isNotEmpty(category.getIcon())) {
            category.setIcon(systemAttachmentService.clearPrefix(category.getIcon()));
        }
        boolean update = updateById(category);
        if (update) {
            redisUtil.delete(RedisConstants.PRODUCT_CATEGORY_CACHE_LIST_KEY);
            redisUtil.delete(RedisConstants.PRODUCT_CATEGORY_CACHE_MERCHANT_LIST_KEY);
        }
        return update;
    }

    /**
     * 修改分类显示状态
     * @param id 分类ID
     * @return Boolean
     */
    @Override
    public Boolean updateShowStatus(Integer id) {
        ProductCategory category = getByIdException(id);
        category.setIsShow(!category.getIsShow());
        boolean update = updateById(category);
        if (update) {
            // 平台端缓存列表不受显示状态影响
//            redisUtil.delete(RedisConstants.PRODUCT_CATEGORY_CACHE_LIST_KEY);
            redisUtil.delete(RedisConstants.PRODUCT_CATEGORY_CACHE_MERCHANT_LIST_KEY);
        }
        return update;
    }

    /**
     * 获取分类缓存树
     * @return List<ProCategoryCacheVo>
     */
    @Override
    public List<ProCategoryCacheVo> getCacheTree() {
        List<ProductCategory> categoryList = CollUtil.newArrayList();
        if (redisUtil.exists(RedisConstants.PRODUCT_CATEGORY_CACHE_LIST_KEY)) {
            categoryList = redisUtil.get(RedisConstants.PRODUCT_CATEGORY_CACHE_LIST_KEY);
        } else {
            LambdaQueryWrapper<ProductCategory> lqw = Wrappers.lambdaQuery();
            lqw.eq(ProductCategory::getIsDel, false);
            categoryList = dao.selectList(lqw);
            if (CollUtil.isEmpty(categoryList)) {
                return CollUtil.newArrayList();
            }
            redisUtil.set(RedisConstants.PRODUCT_CATEGORY_CACHE_LIST_KEY, categoryList);
        }
        List<ProCategoryCacheVo> voList = categoryList.stream().map(e -> {
            ProCategoryCacheVo cacheVo = new ProCategoryCacheVo();
            BeanUtils.copyProperties(e, cacheVo);
            
            // 添加翻译数据
            try {
                cacheVo.setNameEn(translationService.getCachedTranslation("category", e.getId(), "name", "en", e.getName(), null));
                cacheVo.setNameFr(translationService.getCachedTranslation("category", e.getId(), "name", "fr", e.getName(), null));
                cacheVo.setNameTh(translationService.getCachedTranslation("category", e.getId(), "name", "th", e.getName(), null));
                cacheVo.setNameKo(translationService.getCachedTranslation("category", e.getId(), "name", "ko", e.getName(), null));
                cacheVo.setNameJa(translationService.getCachedTranslation("category", e.getId(), "name", "ja", e.getName(), null));
                cacheVo.setNameAr(translationService.getCachedTranslation("category", e.getId(), "name", "ar", e.getName(), null));
            } catch (Exception ex) {
                // 翻译失败时使用原名称
                cacheVo.setNameEn(e.getName());
                cacheVo.setNameFr(e.getName());
                cacheVo.setNameTh(e.getName());
                cacheVo.setNameKo(e.getName());
                cacheVo.setNameJa(e.getName());
                cacheVo.setNameAr(e.getName());
            }
            
            return cacheVo;
        }).collect(Collectors.toList());
        ProCategoryCacheTree categoryTree = new ProCategoryCacheTree(voList);
        return categoryTree.buildTree();
    }

    /**
     * 商户端分类缓存树
     * @return List<ProCategoryCacheVo>
     */
    @Override
    public List<ProCategoryCacheVo> getMerchantCacheTree() {
        List<ProductCategory> categoryList = CollUtil.newArrayList();
        if (redisUtil.exists(RedisConstants.PRODUCT_CATEGORY_CACHE_MERCHANT_LIST_KEY)) {
            categoryList = redisUtil.get(RedisConstants.PRODUCT_CATEGORY_CACHE_MERCHANT_LIST_KEY);
        } else {
            LambdaQueryWrapper<ProductCategory> lqw = Wrappers.lambdaQuery();
            lqw.eq(ProductCategory::getIsShow, true);
            lqw.eq(ProductCategory::getIsDel, false);
            categoryList = dao.selectList(lqw);
            if (CollUtil.isEmpty(categoryList)) {
                return CollUtil.newArrayList();
            }
            redisUtil.set(RedisConstants.PRODUCT_CATEGORY_CACHE_MERCHANT_LIST_KEY, categoryList);
        }
        List<ProCategoryCacheVo> voList = categoryList.stream().map(e -> {
            ProCategoryCacheVo cacheVo = new ProCategoryCacheVo();
            BeanUtils.copyProperties(e, cacheVo);
            
            // 添加翻译数据（仅从数据库查询，不调用API）
            if (translationService != null) {
                try {
                    String nameEn = translationService.getCachedTranslation("category", e.getId(), "name", "en", e.getName(), null);
                    String nameFr = translationService.getCachedTranslation("category", e.getId(), "name", "fr", e.getName(), null);
                    String nameTh = translationService.getCachedTranslation("category", e.getId(), "name", "th", e.getName(), null);
                    String nameKo = translationService.getCachedTranslation("category", e.getId(), "name", "ko", e.getName(), null);
                    String nameJa = translationService.getCachedTranslation("category", e.getId(), "name", "ja", e.getName(), null);
                    String nameAr = translationService.getCachedTranslation("category", e.getId(), "name", "ar", e.getName(), null);
                    
                    // 如果查询到翻译且不是原文，则设置；否则设置为null（前端会显示原名称）
                    cacheVo.setNameEn(nameEn != null && !nameEn.equals(e.getName()) ? nameEn : null);
                    cacheVo.setNameFr(nameFr != null && !nameFr.equals(e.getName()) ? nameFr : null);
                    cacheVo.setNameTh(nameTh != null && !nameTh.equals(e.getName()) ? nameTh : null);
                    cacheVo.setNameKo(nameKo != null && !nameKo.equals(e.getName()) ? nameKo : null);
                    cacheVo.setNameJa(nameJa != null && !nameJa.equals(e.getName()) ? nameJa : null);
                    cacheVo.setNameAr(nameAr != null && !nameAr.equals(e.getName()) ? nameAr : null);
                } catch (Exception ex) {
                    // 翻译查询失败时，不设置翻译字段（保持为null）
                }
            }
            
            return cacheVo;
        }).collect(Collectors.toList());
        ProCategoryCacheTree categoryTree = new ProCategoryCacheTree(voList);
        return categoryTree.buildTree();
    }

    /**
     * 根据菜单id获取所有下级对象
     * @param pid 菜单id
     * @param level 分类级别
     * @return List<ProductCategory>
     */
    @Override
    public List<ProductCategory> findAllChildListByPid(Integer pid, Integer level) {
        LambdaQueryWrapper<ProductCategory> lqw = Wrappers.lambdaQuery();
        lqw.eq(ProductCategory::getPid, pid);
        lqw.eq(ProductCategory::getIsDel, false);
        if (level.equals(2)) {
            return dao.selectList(lqw);
        }
        // level == 1
        List<ProductCategory> categoryList = dao.selectList(lqw);
        if (CollUtil.isEmpty(categoryList)) {
            return categoryList;
        }
        List<Integer> pidList = categoryList.stream().map(ProductCategory::getId).collect(Collectors.toList());
        lqw.clear();
        lqw.in(ProductCategory::getPid, pidList);
        lqw.eq(ProductCategory::getIsDel, false);
        List<ProductCategory> childCategoryList = dao.selectList(lqw);
        categoryList.addAll(childCategoryList);
        return categoryList;
    }

    private ProductCategory getByIdException(Integer id) {
        ProductCategory category = getById(id);
        if (ObjectUtil.isNull(category) || category.getIsDel()) {
            throw new CrmebException(MessageUtils.message("service.productCategory.error.i"));
        }
        return category;
    }

    /**
     * 校验分类名称
     * @param name 分类名称
     * @return Boolean
     */
    private Boolean checkName(String name) {
        LambdaQueryWrapper<ProductCategory> lqw = Wrappers.lambdaQuery();
        lqw.select(ProductCategory::getId);
        lqw.eq(ProductCategory::getName, name);
        lqw.eq(ProductCategory::getIsDel, false);
        lqw.last(" limit 1");
        ProductCategory productCategory = dao.selectOne(lqw);
        return ObjectUtil.isNotNull(productCategory) ? Boolean.TRUE : Boolean.FALSE;
    }
}

