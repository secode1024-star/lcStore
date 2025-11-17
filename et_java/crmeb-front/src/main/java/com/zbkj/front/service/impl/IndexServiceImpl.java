package com.zbkj.front.service.impl;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.StrUtil;
import com.github.pagehelper.PageInfo;
import com.zbkj.common.constants.Constants;
import com.zbkj.common.constants.GroupDataConstants;
import com.zbkj.common.constants.SysConfigConstants;
import com.zbkj.common.constants.VisitRecordConstants;
import com.zbkj.common.model.product.StoreProduct;
import com.zbkj.common.model.system.SystemConfig;
import com.zbkj.common.page.CommonPage;
import com.zbkj.common.request.PageParamRequest;
import com.zbkj.common.response.IndexInfoResponse;
import com.zbkj.common.response.IndexProductResponse;
import com.zbkj.common.response.PageLayoutBottomNavigationResponse;
import com.zbkj.common.response.PcIndexInfoResponse;
import com.zbkj.common.vo.ProCategoryCacheVo;
import com.zbkj.front.service.IndexService;
import com.zbkj.service.service.*;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
* IndexServiceImpl 接口实现
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
public class IndexServiceImpl implements IndexService {

    @Autowired
    private SystemGroupDataService systemGroupDataService;

    @Autowired
    private SystemConfigService systemConfigService;

    @Autowired
    private UserService userService;

    @Autowired
    private StoreProductService storeProductService;

    @Autowired(required = false)
    private com.zbkj.service.service.TranslationService translationService;

    @Autowired
    private ProductCategoryService productCategoryService;

    @Autowired
    private AsyncService asyncService;

    /**
     * 首页数据
     * banner、金刚区、广告位
     * @param language 目标语言代码（可选，如：en, fr, th, lo, jp, kor, ara等），不传或zh-CN则返回中文原文
     */
    @Override
    public IndexInfoResponse getIndexInfo(String language) {
        IndexInfoResponse indexInfoResponse = new IndexInfoResponse();
        
        // 获取原始数据
        List<HashMap<String, Object>> bannerList = systemGroupDataService.getListMapByGid(GroupDataConstants.GROUP_DATA_ID_INDEX_BANNER);
        List<HashMap<String, Object>> bastBannerList = systemGroupDataService.getListMapByGid(GroupDataConstants.GROUP_DATA_ID_INDEX_BEST_BANNER);
        List<HashMap<String, Object>> menusList = systemGroupDataService.getListMapByGid(GroupDataConstants.GROUP_DATA_ID_INDEX_MENU);
        List<HashMap<String, Object>> rankingList = systemGroupDataService.getListMapByGid(GroupDataConstants.GROUP_DATA_ID_STORE_PRODUCT_RANKING);
        
        // 如果提供了语言参数且不是中文，应用翻译
        if (StrUtil.isNotBlank(language) && !"zh-CN".equals(language) && translationService != null) {
            // 翻译banner、菜单、活动等配置数据
            translateSystemGroupDataList(bannerList, language);
            translateSystemGroupDataList(bastBannerList, language);
            translateSystemGroupDataList(menusList, language);
            translateSystemGroupDataList(rankingList, language);
        }
        
        indexInfoResponse.setBanner(bannerList); //首页banner滚动图
        indexInfoResponse.setIndexBannerType(systemConfigService.getValueByKey(SysConfigConstants.FORNT_INDEX_BANNER_TYPE));
        indexInfoResponse.setBastBanner(bastBannerList); //中部推荐banner图
        indexInfoResponse.setMenus(menusList); //导航模块
        indexInfoResponse.setRanking(rankingList); //导航模块
        indexInfoResponse.setShopPayCurrency(systemConfigService.getValueByKey(Constants.SHOP_PAY_CURRENCY)); //商城当前使用的币种

        indexInfoResponse.setLogoUrl(systemConfigService.getValueByKey(SysConfigConstants.CONFIG_KEY_SITE_LOGO));// 企业logo地址
        // 客服部分
        indexInfoResponse.setConsumerType(systemConfigService.getValueByKey(SysConfigConstants.CONFIG_CONSUMER_TYPE));
        switch (indexInfoResponse.getConsumerType()) {
            case Constants.CONSUMER_TYPE_H5:
                indexInfoResponse.setConsumerH5Url(systemConfigService.getValueByKey(SysConfigConstants.CONFIG_CONSUMER_H5_URL));
            case Constants.CONSUMER_TYPE_HOTLINE:
                indexInfoResponse.setConsumerHotline(systemConfigService.getValueByKey(SysConfigConstants.CONFIG_CONSUMER_HOTLINE));
            case Constants.CONSUMER_TYPE_MESSAGE:
                indexInfoResponse.setConsumerMessage(systemConfigService.getValueByKey(SysConfigConstants.CONFIG_CONSUMER_MESSAGE));
            case Constants.CONSUMER_TYPE_EMAIL:
                indexInfoResponse.setConsumerEmail(systemConfigService.getValueByKey(SysConfigConstants.CONFIG_CONSUMER_EMAIL));
        }
        
        // 查询6个首页一级商品分类
        List<ProCategoryCacheVo> categoryVoList = CollUtil.newArrayList();
        List<ProCategoryCacheVo> merchantCacheTree = productCategoryService.getMerchantCacheTree();
        for (int i = 0; i < 6; i++) {
            if (merchantCacheTree.size() < (i +1)) {
                break;
            }
            ProCategoryCacheVo categoryCacheVo = merchantCacheTree.get(i);
            ProCategoryCacheVo cacheVo = new ProCategoryCacheVo();
            cacheVo.setId(categoryCacheVo.getId());
            
            // 翻译分类名称（优先检查数据库是否有已翻译内容）
            String categoryName = categoryCacheVo.getName();
            if (StrUtil.isNotBlank(language) && !"zh-CN".equals(language) && translationService != null) {
                String translatedName = translationService.getCachedTranslation("product_category", 
                        categoryCacheVo.getId(), "name", language, categoryName, null);
                if (StrUtil.isNotBlank(translatedName) && !categoryName.equals(translatedName)) {
                    categoryName = translatedName;
                }
            }
            cacheVo.setName(categoryName);
            cacheVo.setIcon(categoryCacheVo.getIcon());
            categoryVoList.add(cacheVo);
        }
        indexInfoResponse.setCategoryList(categoryVoList);
        
        // 保存用户访问记录
        asyncService.saveUserVisit(userService.getUserId(), VisitRecordConstants.VISIT_TYPE_INDEX);
        return indexInfoResponse;
    }

    /**
     * 热门搜索
     * @return List<HashMap<String, String>>
     */
    @Override
    public List<HashMap<String, Object>> hotKeywords() {
        return systemGroupDataService.getListMapByGid(GroupDataConstants.GROUP_DATA_ID_INDEX_KEYWORDS);
    }

    /**
     * 获取首页商品列表
     * @param pageParamRequest 分页参数
     * @param language 目标语言代码（可选，如：en, fr, th, lo, jp, kor, ara等），不传或zh-CN则返回中文原文
     * @return List
     */
    @Override
    public PageInfo<IndexProductResponse> findIndexProductList(PageParamRequest pageParamRequest, String language) {
        PageInfo<StoreProduct> pageInfo = storeProductService.getIndexProduct(pageParamRequest);
        List<StoreProduct> storeProductList = pageInfo.getList();
        if(CollUtil.isEmpty(storeProductList)) {
            return CommonPage.copyPageInfo(pageInfo, CollUtil.newArrayList());
        }
        List<IndexProductResponse> productResponseArrayList = new ArrayList<>();
        for (StoreProduct storeProduct : storeProductList) {
            IndexProductResponse productResponse = new IndexProductResponse();
            BeanUtils.copyProperties(storeProduct, productResponse);
            productResponseArrayList.add(productResponse);
        }
        
        // 如果提供了语言参数且不是中文，应用翻译
        if (StrUtil.isNotBlank(language) && !"zh-CN".equals(language) && translationService != null) {
            for (IndexProductResponse product : productResponseArrayList) {
                translateProductInfo(product, language, product.getId());
            }
        }
        
        return CommonPage.copyPageInfo(pageInfo, productResponseArrayList);
    }
    
    /**
     * 翻译商品信息
     * @param productResponse 商品响应对象
     * @param targetLanguage 目标语言
     * @param productId 商品ID
     */
    private void translateProductInfo(IndexProductResponse productResponse, String targetLanguage, Integer productId) {
        if (translationService == null || productResponse == null) {
            return;
        }
        
        // 从商品ID获取商品信息以获取merId
        StoreProduct storeProduct = storeProductService.getById(productId);
        if (storeProduct == null) {
            return;
        }
        Integer merId = storeProduct.getMerId();
        
        // 翻译商品名称（只从缓存和数据库读取，不调用API）
        if (StrUtil.isNotBlank(productResponse.getStoreName())) {
            String translatedName = translationService.getCachedTranslation("product", productId, "storeName", 
                    targetLanguage, productResponse.getStoreName(), merId);
            if (StrUtil.isNotBlank(translatedName) && !productResponse.getStoreName().equals(translatedName)) {
                productResponse.setStoreName(translatedName);
            }
        }
        
        // 翻译单位（只从缓存和数据库读取，不调用API）
        if (StrUtil.isNotBlank(productResponse.getUnitName())) {
            String translatedUnit = translationService.getCachedTranslation("product", productId, "unitName", 
                    targetLanguage, productResponse.getUnitName(), merId);
            if (StrUtil.isNotBlank(translatedUnit) && !productResponse.getUnitName().equals(translatedUnit)) {
                productResponse.setUnitName(translatedUnit);
            }
        }
    }

    /**
     * 获取颜色配置
     * @return SystemConfig
     */
    @Override
    public SystemConfig getColorConfig() {
        return systemConfigService.getColorConfig();
    }

    /**
     * 获取全局本地图片域名
     * @return String
     */
    @Override
    public String getImageDomain() {
        String localUploadUrl = systemConfigService.getValueByKey(SysConfigConstants.CONFIG_LOCAL_UPLOAD_URL);
        return StrUtil.isBlank(localUploadUrl) ? "" : localUploadUrl;
    }

    /**
     * PC首页数据
     * @param language 目标语言代码（可选，如：en, fr, th, lo, jp, kor, ara等），不传或zh-CN则返回中文原文
     */
    @Override
    public PcIndexInfoResponse getPcIndexInfo(String language) {
        PcIndexInfoResponse indexInfoResponse = new PcIndexInfoResponse();
        
        // 获取原始数据
        List<HashMap<String, Object>> bannerList = systemGroupDataService.getListMapByGid(GroupDataConstants.GROUP_DATA_ID_PC_HONE_BANNER);
        List<HashMap<String, Object>> bastBannerList = systemGroupDataService.getListMapByGid(GroupDataConstants.GROUP_DATA_ID_INDEX_BEST_BANNER);
        
        // 如果提供了语言参数且不是中文，应用翻译
        if (StrUtil.isNotBlank(language) && !"zh-CN".equals(language) && translationService != null) {
            // 翻译banner、活动等配置数据
            translateSystemGroupDataList(bannerList, language);
            translateSystemGroupDataList(bastBannerList, language);
        }
        
        indexInfoResponse.setBanner(bannerList);
//        indexInfoResponse.setShopStreetBack(systemConfigService.getValueByKey(SysConfigConstants.PC_HOME_SHOP_STREET_BACK_IMAGE));
        indexInfoResponse.setRecommendImage(systemConfigService.getValueByKey(SysConfigConstants.PC_HOME_RECOMMEND_IMAGE));
        indexInfoResponse.setLogoUrl(systemConfigService.getValueByKey(SysConfigConstants.PC_TOP_LOGO));
        indexInfoResponse.setBastBanner(bastBannerList); //中部推荐banner图
        indexInfoResponse.setShopStreetHeaderImag(systemConfigService.getValueByKey(SysConfigConstants.PC_SHOP_STREET_HEADER_IMAGE));
        indexInfoResponse.setShopPayCurrency(systemConfigService.getValueByKey(Constants.SHOP_PAY_CURRENCY)); //商城当前使用的币种
        // 客服部分
        indexInfoResponse.setConsumerType(systemConfigService.getValueByKey(SysConfigConstants.CONFIG_CONSUMER_TYPE));
        switch (indexInfoResponse.getConsumerType()) {
            case Constants.CONSUMER_TYPE_H5:
                indexInfoResponse.setConsumerH5Url(systemConfigService.getValueByKey(SysConfigConstants.CONFIG_CONSUMER_H5_URL));
            case Constants.CONSUMER_TYPE_HOTLINE:
                indexInfoResponse.setConsumerHotline(systemConfigService.getValueByKey(SysConfigConstants.CONFIG_CONSUMER_HOTLINE));
            case Constants.CONSUMER_TYPE_MESSAGE:
                indexInfoResponse.setConsumerMessage(systemConfigService.getValueByKey(SysConfigConstants.CONFIG_CONSUMER_MESSAGE));
            case Constants.CONSUMER_TYPE_EMAIL:
                indexInfoResponse.setConsumerEmail(systemConfigService.getValueByKey(SysConfigConstants.CONFIG_CONSUMER_EMAIL));
        }
        // 保存用户访问记录
        asyncService.saveUserVisit(userService.getUserId(), VisitRecordConstants.VISIT_TYPE_INDEX);
        return indexInfoResponse;
    }

    /**
     * 获取底部导航信息
     */
    @Override
    public PageLayoutBottomNavigationResponse getBottomNavigationInfo() {
        String isCustom = systemConfigService.getValueByKey(SysConfigConstants.CONFIG_BOTTOM_NAVIGATION_IS_CUSTOM);
        List<HashMap<String, Object>> bnList = systemGroupDataService.getListMapByGid(GroupDataConstants.GROUP_DATA_ID_BOTTOM_NAVIGATION);
        PageLayoutBottomNavigationResponse response = new PageLayoutBottomNavigationResponse();
        response.setIsCustom(isCustom);
        response.setBottomNavigationList(bnList);
        return response;
    }
    
    /**
     * 翻译SystemGroupData列表中的文本内容
     * 优先检查数据库是否有已翻译内容
     * 
     * @param dataList SystemGroupData列表（HashMap格式）
     * @param targetLanguage 目标语言
     */
    private void translateSystemGroupDataList(List<HashMap<String, Object>> dataList, String targetLanguage) {
        if (CollUtil.isEmpty(dataList) || translationService == null) {
            return;
        }
        
        // 需要翻译的字段名（常见文本字段）
        String[] textFields = {"name", "title", "info", "desc", "description", "text", "content", "label"};
        
        for (HashMap<String, Object> dataMap : dataList) {
            if (dataMap == null) {
                continue;
            }
            
            // 获取SystemGroupData的ID（用于关联翻译）
            Object idObj = dataMap.get("id");
            Integer groupDataId = null;
            if (idObj != null) {
                if (idObj instanceof Integer) {
                    groupDataId = (Integer) idObj;
                } else if (idObj instanceof Number) {
                    groupDataId = ((Number) idObj).intValue();
                }
            }
            
            // 遍历需要翻译的字段
            for (String fieldName : textFields) {
                Object valueObj = dataMap.get(fieldName);
                if (valueObj == null) {
                    continue;
                }
                
                // 只翻译字符串类型的值
                if (!(valueObj instanceof String)) {
                    continue;
                }
                
                String sourceText = (String) valueObj;
                if (StrUtil.isBlank(sourceText)) {
                    continue;
                }
                
                // 跳过图片URL、链接等非文本内容
                if (sourceText.startsWith("http://") || sourceText.startsWith("https://") || 
                    sourceText.startsWith("/") || sourceText.startsWith("crmebimage/")) {
                    continue;
                }
                
                // 优先检查数据库是否有已翻译内容
                String translatedText = translationService.getCachedTranslation(
                        "system_group_data", 
                        groupDataId, 
                        fieldName, 
                        targetLanguage, 
                        sourceText, 
                        null);
                
                if (StrUtil.isNotBlank(translatedText) && !sourceText.equals(translatedText)) {
                    dataMap.put(fieldName, translatedText);
                }
            }
        }
    }
}

