# 前端改造设计 - PC端商城详细方案（完结）

## 4.2 我的询价单列表页面（inquiry/list.vue）

**路由**: `/inquiry/list`

**功能**:
1. 显示用户的所有询价单
2. 筛选条件：询价状态
3. 分页
4. 查看详情
5. 多语言支持

**页面布局**:
```
┌─────────────────────────────────────┐
│ 我的询价单                           │
├─────────────────────────────────────┤
│ 筛选：状态 [全部▼]                  │
├─────────────────────────────────────┤
│ 询价单号  商品数  状态  时间  操作   │
├─────────────────────────────────────┤
│ INQ001    3      待处理  2026-05-18 │
│                          [查看详情]  │
├─────────────────────────────────────┤
│ INQ002    1      已处理  2026-05-17 │
│                          [查看详情]  │
├─────────────────────────────────────┤
│ [分页]                               │
└─────────────────────────────────────┘
```

**实现代码**:
```vue
<template>
  <div class="inquiry-list-page">
    <h1>{{ $t('inquiry.myInquiry') }}</h1>

    <!-- 筛选条件 -->
    <div class="filter-bar">
      <el-select
        v-model="filterStatus"
        :placeholder="$t('inquiry.inquiryStatus')"
        @change="handleFilter"
      >
        <el-option :label="$t('common.all')" value="" />
        <el-option :label="$t('inquiry.statusPending')" value="0" />
        <el-option :label="$t('inquiry.statusProcessed')" value="1" />
        <el-option :label="$t('inquiry.statusCancelled')" value="2" />
      </el-select>
    </div>

    <!-- 询价单列表 -->
    <div v-loading="loading" class="inquiry-list">
      <el-empty v-if="list.length === 0" :description="$t('common.noData')" />
      
      <div
        v-for="item in list"
        :key="item.inquiryNo"
        class="inquiry-item"
      >
        <div class="item-header">
          <span class="inquiry-no">{{ item.inquiryNo }}</span>
          <inquiry-status-tag :status="item.inquiryStatus" />
        </div>
        
        <div class="item-body">
          <div class="item-info">
            <p>{{ $t('inquiry.productList') }}：{{ item.totalNum }} {{ $t('cart.items') }}</p>
            <p>{{ $t('inquiry.inquiryTime') }}：{{ item.createTime }}</p>
          </div>
          
          <div class="item-actions">
            <el-button
              size="small"
              @click="viewDetail(item.inquiryNo)"
            >
              {{ $t('inquiry.viewDetail') }}
            </el-button>
          </div>
        </div>
      </div>
    </div>

    <!-- 分页 -->
    <el-pagination
      v-if="total > 0"
      :current-page="pageNum"
      :page-size="pageSize"
      :total="total"
      layout="total, prev, pager, next"
      @current-change="handlePageChange"
    />
  </div>
</template>

<script>
import { getInquiryList } from '@/api/inquiry'
import InquiryStatusTag from '@/components/InquiryStatusTag'

export default {
  name: 'InquiryList',
  components: { InquiryStatusTag },
  data() {
    return {
      loading: false,
      list: [],
      filterStatus: '',
      pageNum: 1,
      pageSize: 10,
      total: 0
    }
  },
  mounted() {
    this.fetchList()
  },
  methods: {
    async fetchList() {
      this.loading = true
      try {
        const res = await getInquiryList({
          inquiryStatus: this.filterStatus,
          pageNum: this.pageNum,
          pageSize: this.pageSize
        })
        this.list = res.data.list
        this.total = res.data.total
      } catch (error) {
        this.$message.error(this.$t('message.failed'))
      } finally {
        this.loading = false
      }
    },
    
    handleFilter() {
      this.pageNum = 1
      this.fetchList()
    },
    
    handlePageChange(page) {
      this.pageNum = page
      this.fetchList()
    },
    
    viewDetail(inquiryNo) {
      this.$router.push(`/inquiry/detail/${inquiryNo}`)
    }
  }
}
</script>

<style scoped>
.inquiry-list-page {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.filter-bar {
  margin-bottom: 20px;
}

.inquiry-item {
  border: 1px solid #eee;
  border-radius: 4px;
  padding: 15px;
  margin-bottom: 15px;
}

.item-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
  padding-bottom: 10px;
  border-bottom: 1px solid #eee;
}

.inquiry-no {
  font-size: 16px;
  font-weight: bold;
}

.item-body {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.item-info p {
  margin: 5px 0;
  color: #666;
}

.el-pagination {
  margin-top: 20px;
  text-align: center;
}
</style>
```

---

## 4.3 询价单详情页面（inquiry/detail.vue）

**路由**: `/inquiry/detail/:inquiryNo`

**实现代码**:
```vue
<template>
  <div class="inquiry-detail-page">
    <h1>{{ $t('inquiry.viewDetail') }}</h1>

    <div v-loading="loading" class="detail-content">
      <!-- 基本信息 -->
      <el-card class="info-card">
        <div slot="header">
          <span>{{ $t('inquiry.formTitle') }}</span>
        </div>
        <el-descriptions :column="2" border>
          <el-descriptions-item :label="$t('inquiry.inquiryNo')">
            {{ detail.inquiryNo }}
          </el-descriptions-item>
          <el-descriptions-item :label="$t('inquiry.inquiryStatus')">
            <inquiry-status-tag :status="detail.inquiryStatus" />
          </el-descriptions-item>
          <el-descriptions-item :label="$t('inquiry.inquiryTime')">
            {{ detail.createTime }}
          </el-descriptions-item>
          <el-descriptions-item :label="$t('inquiry.name')">
            {{ detail.realName }}
          </el-descriptions-item>
          <el-descriptions-item :label="$t('inquiry.email')">
            {{ detail.userEmail }}
          </el-descriptions-item>
          <el-descriptions-item :label="$t('inquiry.phone')">
            {{ detail.userPhone }}
          </el-descriptions-item>
          <el-descriptions-item :label="$t('inquiry.country')">
            {{ detail.country }}
          </el-descriptions-item>
          <el-descriptions-item :label="$t('inquiry.address')" :span="2">
            {{ detail.userAddress }}
          </el-descriptions-item>
          <el-descriptions-item
            v-if="detail.userRemark"
            :label="$t('inquiry.remark')"
            :span="2"
          >
            {{ detail.userRemark }}
          </el-descriptions-item>
        </el-descriptions>
      </el-card>

      <!-- 商品列表 -->
      <el-card class="product-card">
        <div slot="header">
          <span>{{ $t('inquiry.productList') }}</span>
        </div>
        <el-table :data="detail.products" border>
          <el-table-column type="index" width="50" />
          <el-table-column :label="$t('product.productName')" min-width="200">
            <template slot-scope="scope">
              <div class="product-cell">
                <img :src="scope.row.image" :alt="scope.row.productName" />
                <span>{{ scope.row.productName }}</span>
              </div>
            </template>
          </el-table-column>
          <el-table-column :label="$t('cart.price')" width="150">
            <template slot-scope="scope">
              <div>
                <div class="price-cny">¥{{ scope.row.price }}</div>
                <div class="price-usd">${{ scope.row.priceUsd }}</div>
              </div>
            </template>
          </el-table-column>
          <el-table-column :label="$t('cart.quantity')" width="100">
            <template slot-scope="scope">
              {{ scope.row.cartNum }}
            </template>
          </el-table-column>
        </el-table>
      </el-card>

      <!-- 返回按钮 -->
      <div class="actions">
        <el-button @click="goBack">{{ $t('common.back') }}</el-button>
      </div>
    </div>
  </div>
</template>

<script>
import { getInquiryDetail } from '@/api/inquiry'
import InquiryStatusTag from '@/components/InquiryStatusTag'

export default {
  name: 'InquiryDetail',
  components: { InquiryStatusTag },
  data() {
    return {
      loading: false,
      detail: {
        products: []
      }
    }
  },
  mounted() {
    this.fetchDetail()
  },
  methods: {
    async fetchDetail() {
      this.loading = true
      try {
        const res = await getInquiryDetail(this.$route.params.inquiryNo)
        this.detail = res.data
      } catch (error) {
        this.$message.error(this.$t('message.failed'))
      } finally {
        this.loading = false
      }
    },
    
    goBack() {
      this.$router.back()
    }
  }
}
</script>

<style scoped>
.inquiry-detail-page {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.info-card,
.product-card {
  margin-bottom: 20px;
}

.product-cell {
  display: flex;
  align-items: center;
  gap: 10px;
}

.product-cell img {
  width: 50px;
  height: 50px;
  object-fit: cover;
  border-radius: 4px;
}

.price-cny {
  font-size: 16px;
  color: #f56c6c;
  font-weight: bold;
}

.price-usd {
  font-size: 14px;
  color: #909399;
}

.actions {
  text-align: center;
}
</style>
```

---

## 5. API请求拦截器

### 5.1 请求拦截器（添加语言标识）

```javascript
// utils/request.js
import axios from 'axios'
import { Message } from 'element-ui'
import store from '@/store'
import { getToken } from '@/utils/auth'
import Cookies from 'js-cookie'

const service = axios.create({
  baseURL: process.env.VUE_APP_BASE_API,
  timeout: 15000
})

// 请求拦截器
service.interceptors.request.use(
  config => {
    // 添加token
    if (store.getters.token) {
      config.headers['Authorization'] = 'Bearer ' + getToken()
    }
    
    // 添加语言标识
    const language = Cookies.get('language') || 'zh'
    config.headers['Accept-Language'] = language
    
    return config
  },
  error => {
    console.error(error)
    return Promise.reject(error)
  }
)

// 响应拦截器
service.interceptors.response.use(
  response => {
    const res = response.data
    
    if (res.code !== 200) {
      Message({
        message: res.message || 'Error',
        type: 'error',
        duration: 5 * 1000
      })
      
      // 401: 未登录
      if (res.code === 401) {
        store.dispatch('user/logout').then(() => {
          location.reload()
        })
      }
      
      return Promise.reject(new Error(res.message || 'Error'))
    } else {
      return res
    }
  },
  error => {
    console.error('err' + error)
    Message({
      message: error.message,
      type: 'error',
      duration: 5 * 1000
    })
    return Promise.reject(error)
  }
)

export default service
```

---

## 6. 阿拉伯语RTL支持

### 6.1 RTL样式处理

```javascript
// main.js
import Vue from 'vue'
import App from './App.vue'
import i18n from './i18n'
import Cookies from 'js-cookie'

// 设置初始语言的RTL
const language = Cookies.get('language') || 'zh'
document.documentElement.lang = language
document.documentElement.dir = language === 'ar' ? 'rtl' : 'ltr'

// 监听语言变化
Vue.prototype.$setLanguage = function(lang) {
  i18n.locale = lang
  Cookies.set('language', lang)
  document.documentElement.lang = lang
  document.documentElement.dir = lang === 'ar' ? 'rtl' : 'ltr'
}

new Vue({
  i18n,
  render: h => h(App)
}).$mount('#app')
```

### 6.2 RTL样式文件

```css
/* styles/rtl.css */

/* 阿拉伯语RTL样式 */
[dir="rtl"] {
  direction: rtl;
  text-align: right;
}

/* 调整flex布局 */
[dir="rtl"] .flex-row {
  flex-direction: row-reverse;
}

/* 调整margin和padding */
[dir="rtl"] .ml-10 {
  margin-left: 0;
  margin-right: 10px;
}

[dir="rtl"] .mr-10 {
  margin-right: 0;
  margin-left: 10px;
}

/* 调整图标方向 */
[dir="rtl"] .el-icon-arrow-right:before {
  content: "\e6e0"; /* arrow-left */
}

[dir="rtl"] .el-icon-arrow-left:before {
  content: "\e6de"; /* arrow-right */
}

/* Element UI组件RTL适配 */
[dir="rtl"] .el-input__inner {
  text-align: right;
}

[dir="rtl"] .el-select .el-input .el-select__caret {
  left: 5px;
  right: auto;
}

[dir="rtl"] .el-breadcrumb__separator {
  margin: 0 5px;
  transform: rotate(180deg);
}
```

---

## 7. 路由配置

### 7.1 路由文件

```javascript
// router/index.js
import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

export const constantRoutes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('@/views/index')
  },
  {
    path: '/goods/list',
    name: 'GoodsList',
    component: () => import('@/views/goods/list')
  },
  {
    path: '/goods/detail/:id',
    name: 'GoodsDetail',
    component: () => import('@/views/goods/detail')
  },
  {
    path: '/cart',
    name: 'Cart',
    component: () => import('@/views/cart/index')
  },
  {
    path: '/inquiry/submit',
    name: 'InquirySubmit',
    component: () => import('@/views/inquiry/submit')
  },
  {
    path: '/inquiry/list',
    name: 'InquiryList',
    component: () => import('@/views/inquiry/list'),
    meta: { requiresAuth: true }
  },
  {
    path: '/inquiry/detail/:inquiryNo',
    name: 'InquiryDetail',
    component: () => import('@/views/inquiry/detail'),
    meta: { requiresAuth: true }
  },
  {
    path: '/user',
    name: 'User',
    component: () => import('@/views/user/index'),
    meta: { requiresAuth: true },
    children: [
      {
        path: 'profile',
        name: 'UserProfile',
        component: () => import('@/views/user/profile')
      },
      {
        path: 'address',
        name: 'UserAddress',
        component: () => import('@/views/user/address')
      },
      {
        path: 'password',
        name: 'UserPassword',
        component: () => import('@/views/user/password')
      }
    ]
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/login')
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('@/views/register')
  }
]

const router = new Router({
  mode: 'history',
  routes: constantRoutes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  if (to.matched.some(record => record.meta.requiresAuth)) {
    // 需要登录
    const token = localStorage.getItem('token')
    if (!token) {
      next({
        path: '/login',
        query: { redirect: to.fullPath }
      })
    } else {
      next()
    }
  } else {
    next()
  }
})

export default router
```

---

## 8. 通用组件

### 8.1 询价状态标签组件

```vue
<!-- components/InquiryStatusTag.vue -->
<template>
  <el-tag :type="tagType" size="small">
    {{ statusText }}
  </el-tag>
</template>

<script>
export default {
  name: 'InquiryStatusTag',
  props: {
    status: {
      type: Number,
      required: true
    }
  },
  computed: {
    statusText() {
      const statusMap = {
        0: this.$t('inquiry.statusPending'),
        1: this.$t('inquiry.statusProcessed'),
        2: this.$t('inquiry.statusCancelled')
      }
      return statusMap[this.status] || ''
    },
    tagType() {
      const typeMap = {
        0: 'warning',
        1: 'success',
        2: 'info'
      }
      return typeMap[this.status] || 'info'
    }
  }
}
</script>
```

---

## ✅ PC端商城改造总结

### 新增页面（7个）
1. 询价表单页面
2. 我的询价单列表
3. 询价单详情页面
4. （其他页面保留并改造）

### 改造页面（6个）
1. 首页 - 多语言支持
2. 商品列表页 - 多语言支持
3. 商品详情页 - 多语言支持
4. 购物车 → 意向清单
5. 用户中心 - 简化功能
6. 地址管理 - 保留

### 新增组件（3个）
1. 语言切换器
2. 商品卡片组件
3. 询价状态标签

### 删除页面（15+个）
1. 支付相关页面（3个）
2. 订单相关页面（4个）
3. 退款售后页面（3个）
4. 会员中心页面（4个）
5. 营销活动页面（3个）
6. 互动功能页面（3个）

### 核心功能
1. **多语言支持** - vue-i18n实现，支持中英俄阿4种语言
2. **阿拉伯语RTL** - CSS direction属性实现
3. **意向清单** - 复用购物车逻辑，改造UI和交互
4. **询价流程** - 游客和登录用户都可询价
5. **API拦截器** - 自动添加语言标识

### 技术要点
1. 使用Nuxt.js SSR
2. 使用vue-i18n多语言
3. 使用Vuex状态管理
4. 使用Element UI组件库
5. 使用axios请求封装

---

## 📝 PC端商城改造完成

PC端商城的所有设计已完成，包括：
1. 多语言实现方案
2. 商品展示模块改造
3. 意向清单改造
4. 询价模块设计
5. API请求拦截器
6. 阿拉伯语RTL支持
7. 路由配置
8. 通用组件

PC端是C端的核心，已完成详细设计。移动端（et_uniapp）可以参考PC端的设计，主要差异在于使用uni-app框架和移动端UI适配。
