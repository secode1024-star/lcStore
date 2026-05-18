# 前端改造设计 - PC端商城详细方案（续1）

## 2. 商品展示模块改造

### 2.1 首页改造（index.vue）

**路由**: `/`

**改造内容**:
1. 所有文本使用i18n
2. 商品数据根据语言显示对应字段
3. 分类导航多语言显示
4. Banner图片多语言显示

**页面布局**:
```
┌─────────────────────────────────────┐
│ Header（导航栏）                     │
│ [Logo] [首页] [分类] [意向清单] [语言]│
├─────────────────────────────────────┤
│ Banner轮播图（多语言）               │
├─────────────────────────────────────┤
│ 分类导航（多语言）                   │
│ [电子产品] [服装] [家居] [食品]...  │
├─────────────────────────────────────┤
│ 热门商品（多语言）                   │
│ ┌─────┬─────┬─────┬─────┐          │
│ │商品1│商品2│商品3│商品4│          │
│ └─────┴─────┴─────┴─────┘          │
├─────────────────────────────────────┤
│ 最新商品（多语言）                   │
│ ┌─────┬─────┬─────┬─────┐          │
│ │商品5│商品6│商品7│商品8│          │
│ └─────┴─────┴─────┴─────┘          │
├─────────────────────────────────────┤
│ Footer（页脚）                       │
│ 联系方式 | 关于我们 | 版权信息       │
└─────────────────────────────────────┘
```

**多语言数据处理**:
```vue
<template>
  <div class="home-page">
    <!-- 分类导航 -->
    <div class="category-nav">
      <div
        v-for="category in categories"
        :key="category.id"
        class="category-item"
      >
        {{ getCategoryName(category) }}
      </div>
    </div>

    <!-- 热门商品 -->
    <div class="hot-products">
      <h2>{{ $t('product.hotProducts') }}</h2>
      <div class="product-list">
        <product-card
          v-for="product in hotProducts"
          :key="product.id"
          :product="product"
        />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'HomePage',
  data() {
    return {
      categories: [],
      hotProducts: []
    }
  },
  computed: {
    currentLanguage() {
      return this.$i18n.locale
    }
  },
  methods: {
    // 获取分类名称（根据当前语言）
    getCategoryName(category) {
      const langMap = {
        zh: category.name,
        en: category.nameEn,
        ru: category.nameRu,
        ar: category.nameAr
      }
      return langMap[this.currentLanguage] || category.name
    },
    
    // 获取商品名称（根据当前语言）
    getProductName(product) {
      const langMap = {
        zh: product.storeName,
        en: product.storeNameEn,
        ru: product.storeNameRu,
        ar: product.storeNameAr
      }
      return langMap[this.currentLanguage] || product.storeName
    },
    
    // 获取商品图片（根据当前语言）
    getProductImage(product) {
      const langMap = {
        zh: product.image,
        en: product.imageEn,
        ru: product.imageRu,
        ar: product.imageAr
      }
      return langMap[this.currentLanguage] || product.image
    }
  }
}
</script>
```

**API对接**:
```javascript
// api/home.js
import request from '@/utils/request'

// 获取首页数据
export function getHomeData() {
  return request({
    url: '/api/home/data',
    method: 'get'
  })
}

// 获取热门商品
export function getHotProducts(params) {
  return request({
    url: '/api/product/hot',
    method: 'get',
    params
  })
}
```

---

### 2.2 商品列表页改造（list.vue）

**路由**: `/goods/list`

**改造内容**:
1. 商品数据根据语言显示
2. 分类筛选多语言
3. 价格显示人民币+美元
4. 搜索关键词多语言匹配

**页面布局**:
```
┌─────────────────────────────────────┐
│ 面包屑导航                           │
│ 首页 > 电子产品 > 手机               │
├─────────────────────────────────────┤
│ 筛选条件                             │
│ 分类：[全部▼] 价格：[全部▼]         │
│ 排序：[综合▼] [价格升序] [价格降序] │
├─────────────────────────────────────┤
│ 商品列表（网格或列表）               │
│ ┌─────────────────────────────────┐ │
│ │ [图片] 商品名称                  │ │
│ │        商品简介...               │ │
│ │        ¥100 / $14.50            │ │
│ │        [加入意向清单] [立即询价] │ │
│ ├─────────────────────────────────┤ │
│ │ [图片] 商品名称                  │ │
│ │        ...                       │ │
│ └─────────────────────────────────┘ │
│                                     │
│ [分页组件]                           │
└─────────────────────────────────────┘
```

**商品卡片组件**:
```vue
<!-- components/ProductCard.vue -->
<template>
  <div class="product-card">
    <div class="product-image">
      <img :src="productImage" :alt="productName" />
    </div>
    <div class="product-info">
      <h3 class="product-name">{{ productName }}</h3>
      <p class="product-desc">{{ productDesc }}</p>
      <div class="product-price">
        <span class="price-cny">¥{{ product.price }}</span>
        <span class="price-usd">/ ${{ product.priceUsd }}</span>
      </div>
      <div class="product-actions">
        <el-button
          size="small"
          icon="el-icon-shopping-cart-2"
          @click="addToCart"
        >
          {{ $t('common.addToCart') }}
        </el-button>
        <el-button
          size="small"
          type="primary"
          @click="inquiryNow"
        >
          {{ $t('common.inquiryNow') }}
        </el-button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ProductCard',
  props: {
    product: {
      type: Object,
      required: true
    }
  },
  computed: {
    currentLanguage() {
      return this.$i18n.locale
    },
    productName() {
      const langMap = {
        zh: this.product.storeName,
        en: this.product.storeNameEn,
        ru: this.product.storeNameRu,
        ar: this.product.storeNameAr
      }
      return langMap[this.currentLanguage] || this.product.storeName
    },
    productDesc() {
      const langMap = {
        zh: this.product.storeInfo,
        en: this.product.storeInfoEn,
        ru: this.product.storeInfoRu,
        ar: this.product.storeInfoAr
      }
      return langMap[this.currentLanguage] || this.product.storeInfo
    },
    productImage() {
      const langMap = {
        zh: this.product.image,
        en: this.product.imageEn,
        ru: this.product.imageRu,
        ar: this.product.imageAr
      }
      return langMap[this.currentLanguage] || this.product.image
    }
  },
  methods: {
    addToCart() {
      this.$emit('add-to-cart', this.product)
    },
    inquiryNow() {
      this.$emit('inquiry-now', this.product)
    }
  }
}
</script>

<style scoped>
.product-card {
  border: 1px solid #eee;
  border-radius: 4px;
  padding: 15px;
  transition: all 0.3s;
}

.product-card:hover {
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.product-image img {
  width: 100%;
  height: 200px;
  object-fit: cover;
}

.product-name {
  font-size: 16px;
  margin: 10px 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.product-desc {
  font-size: 14px;
  color: #666;
  height: 40px;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.product-price {
  margin: 10px 0;
}

.price-cny {
  font-size: 18px;
  color: #f56c6c;
  font-weight: bold;
}

.price-usd {
  font-size: 14px;
  color: #909399;
  margin-left: 5px;
}

.product-actions {
  display: flex;
  gap: 10px;
}

.product-actions .el-button {
  flex: 1;
}
</style>
```

**API对接**:
```javascript
// api/product.js
import request from '@/utils/request'

// 获取商品列表
export function getProductList(params) {
  return request({
    url: '/api/product/list',
    method: 'get',
    params
  })
}

// 搜索商品
export function searchProducts(params) {
  return request({
    url: '/api/product/search',
    method: 'get',
    params
  })
}
```

---

### 2.3 商品详情页改造（detail.vue）

**路由**: `/goods/detail/:id`

**改造内容**:
1. 商品信息多语言显示
2. 轮播图多语言显示
3. 详情图多语言显示
4. 商品详情富文本多语言显示
5. 价格显示人民币+美元

**页面布局**:
```
┌─────────────────────────────────────┐
│ 面包屑导航                           │
│ 首页 > 电子产品 > 手机 > 商品详情   │
├─────────────────────────────────────┤
│ 商品主体信息                         │
│ ┌─────────────┬───────────────────┐ │
│ │             │ 商品名称          │ │
│ │   轮播图    │ 商品简介          │ │
│ │  (多语言)   │ 价格：¥100/$14.50 │ │
│ │             │ [加入意向清单]    │ │
│ │             │ [立即询价]        │ │
│ └─────────────┴───────────────────┘ │
├─────────────────────────────────────┤
│ 商品详情（Tab切换）                  │
│ [商品详情] [商品参数]                │
│                                     │
│ 详情图（多语言）                     │
│ [图1] [图2] [图3]                   │
│                                     │
│ 商品详情富文本（多语言）             │
│ <富文本内容>                         │
└─────────────────────────────────────┘
```

**实现代码**:
```vue
<template>
  <div class="product-detail">
    <!-- 面包屑 -->
    <el-breadcrumb separator="/">
      <el-breadcrumb-item :to="{ path: '/' }">
        {{ $t('common.home') }}
      </el-breadcrumb-item>
      <el-breadcrumb-item>{{ categoryName }}</el-breadcrumb-item>
      <el-breadcrumb-item>{{ productName }}</el-breadcrumb-item>
    </el-breadcrumb>

    <!-- 商品主体 -->
    <div class="product-main">
      <!-- 左侧：轮播图 -->
      <div class="product-gallery">
        <el-carousel height="400px">
          <el-carousel-item v-for="(img, index) in sliderImages" :key="index">
            <img :src="img" :alt="productName" />
          </el-carousel-item>
        </el-carousel>
      </div>

      <!-- 右侧：商品信息 -->
      <div class="product-info">
        <h1 class="product-name">{{ productName }}</h1>
        <p class="product-desc">{{ productDesc }}</p>
        
        <div class="product-price">
          <span class="label">{{ $t('product.productPrice') }}：</span>
          <span class="price-cny">¥{{ product.price }}</span>
          <span class="price-usd">/ ${{ product.priceUsd }}</span>
        </div>

        <div class="product-keywords" v-if="productKeywords">
          <span class="label">{{ $t('product.keywords') }}：</span>
          <el-tag
            v-for="(keyword, index) in productKeywords.split(',')"
            :key="index"
            size="small"
            style="margin-right: 5px;"
          >
            {{ keyword }}
          </el-tag>
        </div>

        <div class="product-actions">
          <el-button
            size="large"
            icon="el-icon-shopping-cart-2"
            @click="addToCart"
          >
            {{ $t('common.addToCart') }}
          </el-button>
          <el-button
            size="large"
            type="primary"
            @click="inquiryNow"
          >
            {{ $t('common.inquiryNow') }}
          </el-button>
        </div>
      </div>
    </div>

    <!-- 商品详情 -->
    <div class="product-detail-content">
      <el-tabs v-model="activeTab">
        <el-tab-pane :label="$t('product.productDetail')" name="detail">
          <!-- 详情图 -->
          <div class="detail-images">
            <img
              v-for="(img, index) in detailImages"
              :key="index"
              :src="img"
              :alt="productName"
            />
          </div>
          
          <!-- 富文本详情 -->
          <div class="detail-description" v-html="productDescription"></div>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<script>
import { getProductDetail } from '@/api/product'

export default {
  name: 'ProductDetail',
  data() {
    return {
      product: {},
      activeTab: 'detail'
    }
  },
  computed: {
    currentLanguage() {
      return this.$i18n.locale
    },
    productName() {
      const langMap = {
        zh: this.product.storeName,
        en: this.product.storeNameEn,
        ru: this.product.storeNameRu,
        ar: this.product.storeNameAr
      }
      return langMap[this.currentLanguage] || this.product.storeName
    },
    productDesc() {
      const langMap = {
        zh: this.product.storeInfo,
        en: this.product.storeInfoEn,
        ru: this.product.storeInfoRu,
        ar: this.product.storeInfoAr
      }
      return langMap[this.currentLanguage] || this.product.storeInfo
    },
    productKeywords() {
      const langMap = {
        zh: this.product.keyword,
        en: this.product.keywordEn,
        ru: this.product.keywordRu,
        ar: this.product.keywordAr
      }
      return langMap[this.currentLanguage] || this.product.keyword
    },
    sliderImages() {
      const langMap = {
        zh: this.product.sliderImage,
        en: this.product.sliderImageEn,
        ru: this.product.sliderImageRu,
        ar: this.product.sliderImageAr
      }
      const images = langMap[this.currentLanguage] || this.product.sliderImage
      return images ? images.split(',') : []
    },
    detailImages() {
      const langMap = {
        zh: this.product.detailImages,
        en: this.product.detailImagesEn,
        ru: this.product.detailImagesRu,
        ar: this.product.detailImagesAr
      }
      const images = langMap[this.currentLanguage] || this.product.detailImages
      return images ? images.split(',') : []
    },
    productDescription() {
      const langMap = {
        zh: this.product.description,
        en: this.product.descriptionEn,
        ru: this.product.descriptionRu,
        ar: this.product.descriptionAr
      }
      return langMap[this.currentLanguage] || this.product.description
    },
    categoryName() {
      if (!this.product.category) return ''
      const langMap = {
        zh: this.product.category.name,
        en: this.product.category.nameEn,
        ru: this.product.category.nameRu,
        ar: this.product.category.nameAr
      }
      return langMap[this.currentLanguage] || this.product.category.name
    }
  },
  mounted() {
    this.fetchProductDetail()
  },
  methods: {
    async fetchProductDetail() {
      try {
        const res = await getProductDetail(this.$route.params.id)
        this.product = res.data
      } catch (error) {
        this.$message.error(this.$t('message.failed'))
      }
    },
    addToCart() {
      // 加入意向清单逻辑
      this.$store.dispatch('cart/addToCart', this.product)
      this.$message.success(this.$t('message.addToCartSuccess'))
    },
    inquiryNow() {
      // 跳转到询价页面
      this.$router.push({
        path: '/inquiry/submit',
        query: { productId: this.product.id }
      })
    }
  }
}
</script>

<style scoped>
.product-detail {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.product-main {
  display: flex;
  gap: 30px;
  margin-top: 20px;
}

.product-gallery {
  flex: 1;
}

.product-gallery img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.product-info {
  flex: 1;
}

.product-name {
  font-size: 24px;
  margin-bottom: 10px;
}

.product-desc {
  font-size: 14px;
  color: #666;
  margin-bottom: 20px;
}

.product-price {
  margin-bottom: 20px;
}

.price-cny {
  font-size: 28px;
  color: #f56c6c;
  font-weight: bold;
}

.price-usd {
  font-size: 18px;
  color: #909399;
  margin-left: 10px;
}

.product-keywords {
  margin-bottom: 20px;
}

.product-actions {
  display: flex;
  gap: 15px;
}

.product-actions .el-button {
  flex: 1;
}

.product-detail-content {
  margin-top: 30px;
}

.detail-images img {
  width: 100%;
  margin-bottom: 10px;
}

.detail-description {
  line-height: 1.8;
}
</style>
```

---

## 📝 下一步

PC端商城详细方案第二部分已完成，包括：
1. 首页改造
2. 商品列表页改造
3. 商品详情页改造
4. 商品卡片组件

还需要继续设计：
5. 意向清单改造
6. 询价模块设计
7. 用户中心改造
8. API请求拦截器
9. 阿拉伯语RTL支持
10. 路由配置

继续吗？
