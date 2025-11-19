package com.zbkj.front.service.impl;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import com.github.pagehelper.PageInfo;
import com.zbkj.common.constants.ProductConstants;
import com.zbkj.common.model.merchant.Merchant;
import com.zbkj.common.model.order.OrderDetail;
import com.zbkj.common.model.product.Product;
import com.zbkj.common.model.product.StoreProduct;
import com.zbkj.common.model.product.StoreProductAttr;
import com.zbkj.common.model.product.StoreProductAttrValue;
import com.zbkj.common.model.record.BrowseRecord;
import com.zbkj.common.model.user.User;
import com.zbkj.common.page.CommonPage;
import com.zbkj.common.request.MerchantProductSearchRequest;
import com.zbkj.common.request.PageParamRequest;
import com.zbkj.common.request.ProductRequest;
import com.zbkj.common.response.*;
import com.zbkj.common.utils.CrmebUtil;
import com.zbkj.common.vo.MyRecord;
import com.zbkj.common.vo.ProCategoryCacheVo;
import com.zbkj.service.service.AsyncService;
import com.zbkj.front.service.ProductService;
import com.zbkj.service.service.*;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

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
public class ProductServiceImpl implements ProductService {

    private static final Logger LOGGER = LoggerFactory.getLogger(ProductServiceImpl.class);

    @Autowired
    private StoreProductService storeProductService;
    @Autowired
    private StoreProductReplyService storeProductReplyService;
    @Autowired
    private UserService userService;
    @Autowired
    private StoreProductRelationService storeProductRelationService;
    @Autowired
    private StoreProductAttrService attrService;
    @Autowired
    private StoreProductAttrValueService storeProductAttrValueService;
    @Autowired
    private ProductCategoryService productCategoryService;
    @Autowired
    private AsyncService asyncService;
    @Autowired
    private MerchantService merchantService;
    @Autowired
    private StoreProductCategoryService storeProductCategoryService;
    @Autowired
    private UserMerchantCollectService userMerchantCollectService;
    @Autowired
    private ProductGuaranteeService productGuaranteeService;
    @Autowired
    private BrowseRecordService browseRecordService;
    @Autowired
    private OrderDetailService orderDetailService;
    @Autowired(required = false)
    private com.zbkj.service.service.TranslationService translationService;

    /**
     * 获取商品分类
     * @return List<ProCategoryCacheVo>
     */
    @Override
    public List<ProCategoryCacheVo> getCategory() {
        return productCategoryService.getMerchantCacheTree();
    }

    /**
     * 商品列表
     * @return List<IndexProductResponse>
     */
    @Override
    public PageInfo<IndexProductResponse> getList(ProductRequest request, PageParamRequest pageRequest, String language) {
        PageInfo<StoreProduct> pageInfo = storeProductService.findH5List(request, pageRequest);
        List<StoreProduct> storeProductList = pageInfo.getList();
        if (CollUtil.isEmpty(storeProductList)) {
            return CommonPage.copyPageInfo(pageInfo, CollUtil.newArrayList());
        }
        List<IndexProductResponse> productList = productToIndexProduct(storeProductList);
        
        // 如果提供了语言参数且不是中文，应用翻译
        if (StrUtil.isNotBlank(language) && !"zh-CN".equals(language) && translationService != null) {
            for (IndexProductResponse product : productList) {
                translateProductInfo(product, language, product.getId());
            }
        }
        
        return CommonPage.copyPageInfo(pageInfo, productList);
    }

    /**
     * 获取商品详情
     * @param id 商品编号
     * @param language 目标语言代码（可选，如：en, fr, th, lo, jp, kor, ara等），不传或zh-CN则返回中文原文
     * @return 商品详情信息
     */
    @Override
    public ProductDetailResponse getDetail(Integer id, String language) {
        ProductDetailResponse productDetailResponse = new ProductDetailResponse();
        // 查询商品
        StoreProduct storeProduct = storeProductService.getH5Detail(id);
        productDetailResponse.setProductInfo(storeProduct);
        
        // 如果提供了语言参数且不是中文，应用翻译
        if (StrUtil.isNotBlank(language) && !"zh-CN".equals(language) && translationService != null) {
            try {
                LOGGER.info("开始翻译商品详情: productId={}, language={}, storeName={}", 
                           storeProduct.getId(), language, storeProduct.getStoreName());
                translateStoreProduct(storeProduct, language, storeProduct.getId(), storeProduct.getMerId());
                LOGGER.info("翻译后商品名称: {}", storeProduct.getStoreName());
            } catch (Exception e) {
                LOGGER.error("翻译商品详情失败，使用原文: productId={}, language={}, error={}", 
                           storeProduct.getId(), language, e.getMessage(), e);
                // 翻译失败不影响商品详情的正常返回，继续使用原文
            }
        }
        
        if (StrUtil.isNotBlank(storeProduct.getGuaranteeIds())) {
            productDetailResponse.setGuaranteeList(productGuaranteeService.findByIdList(CrmebUtil.stringToArray(storeProduct.getGuaranteeIds())));
        }
        // 获取商品规格
        List<StoreProductAttr> attrList = attrService.getListByProductIdAndType(storeProduct.getId(), ProductConstants.PRODUCT_ACTIVITY_TYPE_NORMAL);
        // 根据制式设置attr属性
        productDetailResponse.setProductAttr(attrList);
        // 根据制式设置sku属性
        HashMap<String, Object> skuMap = CollUtil.newHashMap();
        List<StoreProductAttrValue> storeProductAttrValues = storeProductAttrValueService.getListByProductIdAndType(storeProduct.getId(), ProductConstants.PRODUCT_ACTIVITY_TYPE_NORMAL);
        for (StoreProductAttrValue storeProductAttrValue : storeProductAttrValues) {
            StoreProductAttrValueResponse atr = new StoreProductAttrValueResponse();
            BeanUtils.copyProperties(storeProductAttrValue, atr);
            
            // 如果提供了语言参数且不是中文，翻译SKU属性
            if (StrUtil.isNotBlank(language) && !"zh-CN".equals(language) && translationService != null) {
                try {
                    translateProductAttrValue(atr, language, storeProduct.getId(), storeProduct.getMerId());
                } catch (Exception e) {
                    LOGGER.error("翻译SKU属性失败，使用原文: productId={}, sku={}, error={}", 
                               storeProduct.getId(), atr.getSku(), e.getMessage());
                    // 翻译失败不影响SKU的正常返回
                }
            }
            
            skuMap.put(atr.getSku(), atr);
        }
        productDetailResponse.setProductValue(skuMap);

        // 获取商户信息
        Merchant merchant = merchantService.getById(storeProduct.getMerId());
        ProductMerchantResponse merchantResponse = new ProductMerchantResponse();
        BeanUtils.copyProperties(merchant, merchantResponse);
        // 获取商户推荐商品
        List<ProMerchantProductResponse> merchantProductResponseList = storeProductService.getRecommendedProductsByMerId(merchant.getId(), 4);
        merchantResponse.setProList(merchantProductResponseList);
        merchantResponse.setIsCollect(false);


        // 获取用户
        User user = userService.getInfo();
        // 用户收藏
        if (ObjectUtil.isNotNull(user)) {
            // 查询用户是否收藏收藏
            productDetailResponse.setUserCollect(storeProductRelationService.existCollectByUser(user.getUid(), storeProduct.getId()));
            // 商户是否被关注
            merchantResponse.setIsCollect(userMerchantCollectService.isCollect(user.getUid(), merchant.getId()));
        } else {
            productDetailResponse.setUserCollect(false);
        }
        productDetailResponse.setMerchantInfo(merchantResponse);
        // 异步调用进行数据统计
        asyncService.productDetailStatistics(storeProduct.getId(), ObjectUtil.isNotNull(user) ? user.getUid() : 0);
        return productDetailResponse;
    }

    /**
     * 获取商品SKU详情
     * @param id 商品编号
     * @return 商品详情信息
     */
    @Override
    public ProductDetailResponse getSkuDetail(Integer id) {
        ProductDetailResponse productDetailResponse = new ProductDetailResponse();
        // 查询商品
        StoreProduct storeProduct = storeProductService.getH5Detail(id);
        // 获取商品规格
        List<StoreProductAttr> attrList = attrService.getListByProductIdAndType(storeProduct.getId(), ProductConstants.PRODUCT_ACTIVITY_TYPE_NORMAL);
        // 根据制式设置attr属性
        productDetailResponse.setProductAttr(attrList);
        // 根据制式设置sku属性
        HashMap<String, Object> skuMap = CollUtil.newHashMap();
        List<StoreProductAttrValue> storeProductAttrValues = storeProductAttrValueService.getListByProductIdAndType(storeProduct.getId(), ProductConstants.PRODUCT_ACTIVITY_TYPE_NORMAL);
        for (StoreProductAttrValue storeProductAttrValue : storeProductAttrValues) {
            StoreProductAttrValueResponse atr = new StoreProductAttrValueResponse();
            BeanUtils.copyProperties(storeProductAttrValue, atr);
            skuMap.put(atr.getSku(), atr);
        }
        productDetailResponse.setProductValue(skuMap);
        return productDetailResponse;
    }

    /**
     * 商品评论列表
     * @param proId 商品编号
     * @param type 评价等级|0=全部,1=好评,2=中评,3=差评
     * @param pageParamRequest 分页参数
     * @return List<ProductReplyResponse>
     */
    @Override
    public PageInfo<ProductReplyResponse> getReplyList(Integer proId, Integer type, PageParamRequest pageParamRequest) {
        return storeProductReplyService.getH5List(proId, type, pageParamRequest);
    }

    /**
     * 产品评价数量和好评度
     * @return StoreProductReplayCountResponse
     */
    @Override
    public StoreProductReplayCountResponse getReplyCount(Integer id) {
        MyRecord myRecord = storeProductReplyService.getH5Count(id);
        Long sumCount = myRecord.getLong("sumCount");
        Long goodCount = myRecord.getLong("goodCount");
        Long inCount = myRecord.getLong("mediumCount");
        Long poorCount = myRecord.getLong("poorCount");
        String replyChance = myRecord.getStr("replyChance");
        Integer replyStar = myRecord.getInt("replyStar");
        return new StoreProductReplayCountResponse(sumCount, goodCount, inCount, poorCount, replyChance, replyStar);
    }

    /**
     * 商品列表转为首页商品格式
     * @param storeProductList 商品列表
     */
    private List<IndexProductResponse> productToIndexProduct(List<StoreProduct> storeProductList) {
        List<IndexProductResponse> productResponseArrayList = new ArrayList<>();
        for (StoreProduct storeProduct : storeProductList) {
            IndexProductResponse productResponse = new IndexProductResponse();
            BeanUtils.copyProperties(storeProduct, productResponse);
            productResponseArrayList.add(productResponse);
        }
        return productResponseArrayList;
    }

    /**
     * 商品详情评论
     * @param id 商品id
     * @return ProductDetailReplyResponse
     * 评论只有一条，图文
     * 评价总数
     * 好评率
     */
    @Override
    public ProductDetailReplyResponse getProductReply(Integer id) {
        return storeProductReplyService.getH5ProductReply(id);
    }

    /**
     * 获取商品排行榜
     * @return List
     */
    @Override
    public List<StoreProduct> getLeaderboard() {
        return storeProductService.getLeaderboard();
    }

    /**
     * 商户商品分类列表
     * @param merId 商户id
     * @return List
     */
    @Override
    public List<ProCategoryCacheVo> findMerchantProductCategoryList(Integer merId) {
        return storeProductCategoryService.findListByMerId(merId);
    }

    /**
     * 商户商品列表
     * @param request 搜索参数
     * @param pageParamRequest 分页参数
     * @return List
     */
    @Override
    public PageInfo<IndexProductResponse> getMerchantProList(MerchantProductSearchRequest request, PageParamRequest pageParamRequest) {
        PageInfo<StoreProduct> pageInfo = storeProductService.findMerchantProH5List(request, pageParamRequest);
        List<StoreProduct> storeProductList = pageInfo.getList();
        if (CollUtil.isEmpty(storeProductList)) {
            return CommonPage.copyPageInfo(pageInfo, CollUtil.newArrayList());
        }
        List<IndexProductResponse> responseList = productToIndexProduct(storeProductList);
        return CommonPage.copyPageInfo(pageInfo, responseList);
    }

    /**
     * 获取已购商品列表
     *
     * @param pageParamRequest 分页参数
     */
    @Override
    public PageInfo<ProductSimpleResponse> findPurchasedList(PageParamRequest pageParamRequest) {
        Integer userId = userService.getUserIdException();
        PageInfo<OrderDetail> pageInfo = orderDetailService.findPurchasedList(userId, pageParamRequest);
        List<OrderDetail> detailList = pageInfo.getList();
        if (CollUtil.isEmpty(detailList)) {
            return CommonPage.copyPageInfo(pageInfo, new ArrayList<>());
        }
        List<Integer> proIdList = detailList.stream().map(OrderDetail::getProductId).distinct().collect(Collectors.toList());
        Map<Integer, StoreProduct> productMap = storeProductService.getMapByIdList(proIdList);
        List<ProductSimpleResponse> responseList = detailList.stream().map(detail -> {
            StoreProduct storeProduct = productMap.get(detail.getProductId());
            ProductSimpleResponse response = new ProductSimpleResponse();
            response.setProductId(storeProduct.getId());
            response.setName(storeProduct.getStoreName());
            response.setImage(storeProduct.getImage());
            response.setPrice(storeProduct.getPrice());
            return response;
        }).collect(Collectors.toList());
        return CommonPage.copyPageInfo(pageInfo, responseList);
    }

    /**
     * 足迹商品列表
     *
     * @param pageParamRequest 分页参数
     */
    @Override
    public PageInfo<ProductSimpleResponse> findBrowseList(PageParamRequest pageParamRequest) {
        Integer userId = userService.getUserIdException();
        PageInfo<BrowseRecord> pageInfo = browseRecordService.findPageByUserId(userId, pageParamRequest);
        List<BrowseRecord> browseRecordList = pageInfo.getList();
        if (CollUtil.isEmpty(browseRecordList)) {
            return CommonPage.copyPageInfo(pageInfo, new ArrayList<>());
        }
        List<Integer> proIdList = browseRecordList.stream().map(BrowseRecord::getProductId).distinct().collect(Collectors.toList());
        Map<Integer, StoreProduct> productMap = storeProductService.getMapByIdList(proIdList);
        List<ProductSimpleResponse> responseList = browseRecordList.stream()
                .flatMap(detail -> {
                    StoreProduct storeProduct = productMap.get(detail.getProductId());
                    if (storeProduct == null) {
                        return Stream.empty(); // 直接跳过，不生成元素
                    }
                    ProductSimpleResponse response = new ProductSimpleResponse();
                    response.setProductId(storeProduct.getId());
                    response.setName(storeProduct.getStoreName());
                    response.setImage(storeProduct.getImage());
                    response.setPrice(storeProduct.getPrice());
                    response.setStock(storeProduct.getStock());
                    return Stream.of(response); // 有效时返回流
                })
                .collect(Collectors.toList());
        return CommonPage.copyPageInfo(pageInfo, responseList);
    }

    /**
     * 翻译商品基本信息（商品名称、描述、关键字、单位等）
     * @param storeProduct 商品对象
     * @param targetLanguage 目标语言
     * @param productId 商品ID
     * @param merId 商户ID
     */
    private void translateStoreProduct(StoreProduct storeProduct, String targetLanguage, Integer productId, Integer merId) {
        if (translationService == null || storeProduct == null) {
            return;
        }
        
        // 翻译商品名称（只从缓存和数据库读取，不调用API）
        if (StrUtil.isNotBlank(storeProduct.getStoreName())) {
            String originalName = storeProduct.getStoreName();
            String translatedName = translationService.getCachedTranslation("product", productId, "storeName", 
                    targetLanguage, originalName, merId);
            LOGGER.info("商品名称翻译: 原文={}, 目标语言={}, 翻译结果={}", originalName, targetLanguage, translatedName);
            
            if (StrUtil.isNotBlank(translatedName) && !originalName.equals(translatedName)) {
                storeProduct.setStoreName(translatedName);
                LOGGER.info("商品名称已更新为翻译版本: {}", translatedName);
            } else {
                LOGGER.warn("未找到商品名称的翻译或翻译结果与原文相同: productId={}, language={}, originalName={}", 
                           productId, targetLanguage, originalName);
            }
        }
        
        // 翻译商品描述（只从缓存和数据库读取，不调用API）
        if (StrUtil.isNotBlank(storeProduct.getStoreInfo())) {
            String translatedInfo = translationService.getCachedTranslation("product", productId, "storeInfo", 
                    targetLanguage, storeProduct.getStoreInfo(), merId);
            if (StrUtil.isNotBlank(translatedInfo) && !storeProduct.getStoreInfo().equals(translatedInfo)) {
                storeProduct.setStoreInfo(translatedInfo);
            }
        }
        
        // 翻译关键字（只从缓存和数据库读取，不调用API）
        if (StrUtil.isNotBlank(storeProduct.getKeyword())) {
            String translatedKeyword = translationService.getCachedTranslation("product", productId, "keyword", 
                    targetLanguage, storeProduct.getKeyword(), merId);
            if (StrUtil.isNotBlank(translatedKeyword) && !storeProduct.getKeyword().equals(translatedKeyword)) {
                storeProduct.setKeyword(translatedKeyword);
            }
        }
        
        // 翻译单位（只从缓存和数据库读取，不调用API）
        if (StrUtil.isNotBlank(storeProduct.getUnitName())) {
            String translatedUnit = translationService.getCachedTranslation("product", productId, "unitName", 
                    targetLanguage, storeProduct.getUnitName(), merId);
            if (StrUtil.isNotBlank(translatedUnit) && !storeProduct.getUnitName().equals(translatedUnit)) {
                storeProduct.setUnitName(translatedUnit);
            }
        }
        
        // 翻译商品详情内容（只从缓存和数据库读取，不调用API）
        if (StrUtil.isNotBlank(storeProduct.getContent())) {
            String originalContent = storeProduct.getContent();
            // 去除HTML标签，只查询纯文本的翻译
            String plainText = originalContent.replaceAll("<[^>]+>", "").trim();
            
            if (StrUtil.isNotBlank(plainText)) {
                String translatedPlainText = translationService.getCachedTranslation("product", productId, "content", 
                        targetLanguage, plainText, merId);
                
                if (StrUtil.isNotBlank(translatedPlainText) && !plainText.equals(translatedPlainText)) {
                    // 将翻译后的纯文本替换回HTML中
                    String translatedContent = originalContent.replaceAll(">([^<]+)<", ">" + translatedPlainText + "<");
                    storeProduct.setContent(translatedContent);
                    LOGGER.info("商品详情内容已翻译: productId={}, language={}, plainText={}, translated={}", 
                              productId, targetLanguage, plainText, translatedPlainText);
                } else {
                    LOGGER.warn("未找到商品详情内容的翻译: productId={}, language={}, plainText={}", 
                              productId, targetLanguage, plainText);
                }
            }
        }
    }

    /**
     * 翻译商品SKU属性（品名、材质、容量、产地、尺寸等）
     * @param attrValueResponse SKU属性响应对象
     * @param targetLanguage 目标语言
     * @param productId 商品ID
     * @param merId 商户ID
     */
    private void translateProductAttrValue(StoreProductAttrValueResponse attrValueResponse, String targetLanguage, 
                                         Integer productId, Integer merId) {
        if (translationService == null || attrValueResponse == null) {
            return;
        }
        
        // 翻译品名（product_name）（只从缓存和数据库读取，不调用API）
        // 兼容两种存储格式：1. product_attr_value + product_name（正确格式） 2. product + spec.productName（旧格式）
        if (StrUtil.isNotBlank(attrValueResponse.getProductName())) {
            String translated = translationService.getCachedTranslation("product_attr_value", productId, "product_name", 
                    targetLanguage, attrValueResponse.getProductName(), merId);
            // 如果新格式找不到，尝试旧格式（兼容性）
            if (StrUtil.isBlank(translated) || attrValueResponse.getProductName().equals(translated)) {
                translated = translationService.getCachedTranslation("product", productId, "spec.productName", 
                        targetLanguage, attrValueResponse.getProductName(), merId);
            }
            if (StrUtil.isNotBlank(translated) && !attrValueResponse.getProductName().equals(translated)) {
                attrValueResponse.setProductName(translated);
            }
        }
        
        // 翻译材质（material）（只从缓存和数据库读取，不调用API）
        if (StrUtil.isNotBlank(attrValueResponse.getMaterial())) {
            String translated = translationService.getCachedTranslation("product_attr_value", productId, "material", 
                    targetLanguage, attrValueResponse.getMaterial(), merId);
            // 兼容旧格式
            if (StrUtil.isBlank(translated) || attrValueResponse.getMaterial().equals(translated)) {
                translated = translationService.getCachedTranslation("product", productId, "spec.material", 
                        targetLanguage, attrValueResponse.getMaterial(), merId);
            }
            if (StrUtil.isNotBlank(translated) && !attrValueResponse.getMaterial().equals(translated)) {
                attrValueResponse.setMaterial(translated);
            }
        }
        
        // 翻译容量（capacity）（只从缓存和数据库读取，不调用API）
        if (StrUtil.isNotBlank(attrValueResponse.getCapacity())) {
            String translated = translationService.getCachedTranslation("product_attr_value", productId, "capacity", 
                    targetLanguage, attrValueResponse.getCapacity(), merId);
            // 兼容旧格式
            if (StrUtil.isBlank(translated) || attrValueResponse.getCapacity().equals(translated)) {
                translated = translationService.getCachedTranslation("product", productId, "spec.capacity", 
                        targetLanguage, attrValueResponse.getCapacity(), merId);
            }
            if (StrUtil.isNotBlank(translated) && !attrValueResponse.getCapacity().equals(translated)) {
                attrValueResponse.setCapacity(translated);
            }
        }
        
        // 翻译产地（origin）（只从缓存和数据库读取，不调用API）
        if (StrUtil.isNotBlank(attrValueResponse.getOrigin())) {
            String translated = translationService.getCachedTranslation("product_attr_value", productId, "origin", 
                    targetLanguage, attrValueResponse.getOrigin(), merId);
            // 兼容旧格式
            if (StrUtil.isBlank(translated) || attrValueResponse.getOrigin().equals(translated)) {
                translated = translationService.getCachedTranslation("product", productId, "spec.origin", 
                        targetLanguage, attrValueResponse.getOrigin(), merId);
            }
            if (StrUtil.isNotBlank(translated) && !attrValueResponse.getOrigin().equals(translated)) {
                attrValueResponse.setOrigin(translated);
            }
        }
        
        // 翻译尺寸（size）（只从缓存和数据库读取，不调用API）
        if (StrUtil.isNotBlank(attrValueResponse.getSize())) {
            String translated = translationService.getCachedTranslation("product_attr_value", productId, "size", 
                    targetLanguage, attrValueResponse.getSize(), merId);
            // 兼容旧格式
            if (StrUtil.isBlank(translated) || attrValueResponse.getSize().equals(translated)) {
                translated = translationService.getCachedTranslation("product", productId, "spec.size", 
                        targetLanguage, attrValueResponse.getSize(), merId);
            }
            if (StrUtil.isNotBlank(translated) && !attrValueResponse.getSize().equals(translated)) {
                attrValueResponse.setSize(translated);
            }
        }
    }

    /**
     * 翻译商品列表项信息（用于商品列表）
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

}