# 前端改造设计 - PC端商城详细方案（续2）

## 3. 意向清单改造（购物车 → 意向清单）

### 3.1 意向清单页面（cart/index.vue）

**路由**: `/cart`

**改造内容**:
1. 名称改为"意向清单"
2. 删除价格合计功能
3. 改造"结算"按钮为"提交询价"按钮
4. 支持多选询价
5. 多语言支持

**页面布局**:
```
┌─────────────────────────────────────┐
│ 意向清单                             │
├─────────────────────────────────────┤
│ [全选] 商品信息    价格    数量  操作│
├─────────────────────────────────────┤
│ ☑ [图] 商品名称   ¥100    [1▼] [删除]│
│       商品简介    $14.50            │
├─────────────────────────────────────┤
│ ☑ [图] 商品名称   ¥200    [2▼] [删除]│
│       商品简介    $29.00            │
├─────────────────────────────────────┤
│ 已选 2 件商品                        │
│ [清空意向清单] [询价选中商品]        │
└─────────────────────────────────────┘
```

**实现代码**:
```vue
<template>
  <div class="cart-page">
    <h1>{{ $t('cart.title') }}</h1>

    <!-- 空状态 -->
    <div v-if="cartList.length === 0" class="empty-cart">
      <el-empty :description="$t('cart.empty')">
        <el-button type="primary" @click="goHome">
          {{ $t('common.home') }}
        </el-button>
      </el-empty>
    </div>

    <!-- 购物车列表 -->
    <div v-else class="cart-content">
      <!-- 表头 -->
      <div class="cart-header">
        <el-checkbox
          v-model="checkAll"
          :indeterminate="isIndeterminate"
          @change="handleCheckAllChange"
        >
          {{ $t('cart.selectAll') }}
        </el-checkbox>
        <span class="header-product">{{ $t('cart.productName') }}</span>
        <span class="header-price">{{ $t('cart.price') }}</span>
        <span class="header-quantity">{{ $t('cart.quantity') }}</span>
        <span class="header-operation">{{ $t('cart.operation') }}</span>
      </div>

      <!-- 商品列表 -->
      <div class="cart-list">
        <div
          v-for="item in cartList"
          :key="item.id"
          class="cart-item"
        >
          <el-checkbox
            v-model="item.checked"
            @change="handleItemCheck"
          />
          
          <div class="item-product">
            <img :src="getProductImage(item)" :alt="getProductName(item)" />
            <div class="product-info">
              <h3>{{ getProductName(item) }}</h3>
              <p>{{ getProductDesc(item) }}</p>
            </div>
          </div>

          <div class="item-price">
            <span class="price-cny">¥{{ item.price }}</span>
            <span class="price-usd">${{ item.priceUsd }}</span>
          </div>

          <div class="item-quantity">
            <el-input-number
              v-model="item.cartNum"
              :min="1"
              :max="999"
              size="small"
              @change="handleQuantityChange(item)"
            />
          </div>

          <div class="item-operation">
            <el-button
              type="text"
              size="small"
              @click="handleRemove(item)"
            >
              {{ $t('cart.remove') }}
            </el-button>
          </div>
        </div>
      </div>

      <!-- 底部操作栏 -->
      <div class="cart-footer">
        <div class="footer-left">
          <span>{{ $t('cart.selected') }} {{ checkedCount }} {{ $t('cart.items') }}</span>
        </div>
        <div class="footer-right">
          <el-button @click="handleClear">
            {{ $t('cart.clear') }}
          </el-button>
          <el-button
            type="primary"
            :disabled="checkedCount === 0"
            @click="handleInquiry"
          >
            {{ $t('cart.inquirySelected') }}
          </el-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapActions } from 'vuex'

export default {
  name: 'CartPage',
  data() {
    return {
      checkAll: false,
      isIndeterminate: false
    }
  },
  computed: {
    ...mapState('cart', ['cartList']),
    currentLanguage() {
      return this.$i18n.locale
    },
    checkedCount() {
      return this.cartList.filter(item => item.checked).length
    },
    checkedItems() {
      return this.cartList.filter(item => item.checked)
    }
  },
  watch: {
    cartList: {
      handler() {
        this.updateCheckAllStatus()
      },
      deep: true
    }
  },
  mounted() {
    this.fetchCartList()
  },
  methods: {
    ...mapActions('cart', [
      'fetchCartList',
      'updateCartItem',
      'removeCartItem',
      'clearCart'
    ]),
    
    getProductName(item) {
      const langMap = {
        zh: item.productInfo?.storeName,
        en: item.productInfo?.storeNameEn,
        ru: item.productInfo?.storeNameRu,
        ar: item.productInfo?.storeNameAr
      }
      return langMap[this.currentLanguage] || item.productInfo?.storeName
    },
    
    getProductDesc(item) {
      const langMap = {
        zh: item.productInfo?.storeInfo,
        en: item.productInfo?.storeInfoEn,
        ru: item.productInfo?.storeInfoRu,
        ar: item.productInfo?.storeInfoAr
      }
      return langMap[this.currentLanguage] || item.productInfo?.storeInfo
    },
    
    getProductImage(item) {
      const langMap = {
        zh: item.productInfo?.image,
        en: item.productInfo?.imageEn,
        ru: item.productInfo?.imageRu,
        ar: item.productInfo?.imageAr
      }
      return langMap[this.currentLanguage] || item.productInfo?.image
    },
    
    handleCheckAllChange(val) {
      this.cartList.forEach(item => {
        item.checked = val
      })
      this.isIndeterminate = false
    },
    
    handleItemCheck() {
      this.updateCheckAllStatus()
    },
    
    updateCheckAllStatus() {
      const checkedCount = this.checkedCount
      this.checkAll = checkedCount === this.cartList.length
      this.isIndeterminate = checkedCount > 0 && checkedCount < this.cartList.length
    },
    
    handleQuantityChange(item) {
      this.updateCartItem({
        id: item.id,
        cartNum: item.cartNum
      })
    },
    
    handleRemove(item) {
      this.$confirm(
        this.$t('message.confirmDelete'),
        this.$t('common.confirm'),
        {
          confirmButtonText: this.$t('common.confirm'),
          cancelButtonText: this.$t('common.cancel'),
          type: 'warning'
        }
      ).then(() => {
        this.removeCartItem(item.id)
        this.$message.success(this.$t('message.removeFromCartSuccess'))
      }).catch(() => {})
    },
    
    handleClear() {
      this.$confirm(
        this.$t('message.confirmClearCart'),
        this.$t('common.confirm'),
        {
          confirmButtonText: this.$t('common.confirm'),
          cancelButtonText: this.$t('common.cancel'),
          type: 'warning'
        }
      ).then(() => {
        this.clearCart()
        this.$message.success(this.$t('message.success'))
      }).catch(() => {})
    },
    
    handleInquiry() {
      if (this.checkedCount === 0) {
        this.$message.warning(this.$t('message.selectProducts'))
        return
      }
      
      // 跳转到询价页面，携带选中的商品ID
      const productIds = this.checkedItems.map(item => item.productId).join(',')
      this.$router.push({
        path: '/inquiry/submit',
        query: { productIds }
      })
    },
    
    goHome() {
      this.$router.push('/')
    }
  }
}
</script>

<style scoped>
.cart-page {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.empty-cart {
  padding: 100px 0;
}

.cart-header {
  display: flex;
  align-items: center;
  padding: 15px;
  background-color: #f5f7fa;
  border-radius: 4px;
  margin-bottom: 10px;
}

.cart-header .el-checkbox {
  width: 50px;
}

.header-product {
  flex: 1;
}

.header-price,
.header-quantity,
.header-operation {
  width: 150px;
  text-align: center;
}

.cart-item {
  display: flex;
  align-items: center;
  padding: 15px;
  border: 1px solid #eee;
  border-radius: 4px;
  margin-bottom: 10px;
}

.cart-item .el-checkbox {
  width: 50px;
}

.item-product {
  flex: 1;
  display: flex;
  gap: 15px;
}

.item-product img {
  width: 100px;
  height: 100px;
  object-fit: cover;
  border-radius: 4px;
}

.product-info h3 {
  font-size: 16px;
  margin-bottom: 5px;
}

.product-info p {
  font-size: 14px;
  color: #666;
}

.item-price {
  width: 150px;
  text-align: center;
}

.price-cny {
  display: block;
  font-size: 18px;
  color: #f56c6c;
  font-weight: bold;
}

.price-usd {
  display: block;
  font-size: 14px;
  color: #909399;
  margin-top: 5px;
}

.item-quantity {
  width: 150px;
  text-align: center;
}

.item-operation {
  width: 150px;
  text-align: center;
}

.cart-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  background-color: #f5f7fa;
  border-radius: 4px;
  margin-top: 20px;
}

.footer-left {
  font-size: 16px;
}

.footer-right {
  display: flex;
  gap: 15px;
}
</style>
```

### 3.2 Vuex Store（cart模块）

```javascript
// store/modules/cart.js
import { getCartList, addCart, updateCart, deleteCart, clearCart } from '@/api/cart'

const state = {
  cartList: [],
  cartCount: 0
}

const mutations = {
  SET_CART_LIST(state, list) {
    state.cartList = list
    state.cartCount = list.length
  },
  ADD_CART_ITEM(state, item) {
    state.cartList.push(item)
    state.cartCount++
  },
  UPDATE_CART_ITEM(state, { id, cartNum }) {
    const item = state.cartList.find(i => i.id === id)
    if (item) {
      item.cartNum = cartNum
    }
  },
  REMOVE_CART_ITEM(state, id) {
    const index = state.cartList.findIndex(i => i.id === id)
    if (index > -1) {
      state.cartList.splice(index, 1)
      state.cartCount--
    }
  },
  CLEAR_CART(state) {
    state.cartList = []
    state.cartCount = 0
  }
}

const actions = {
  // 获取购物车列表
  async fetchCartList({ commit }) {
    try {
      const res = await getCartList()
      commit('SET_CART_LIST', res.data)
    } catch (error) {
      console.error('获取购物车列表失败', error)
    }
  },
  
  // 添加到购物车
  async addToCart({ commit, dispatch }, product) {
    try {
      await addCart({
        productId: product.id,
        cartNum: 1
      })
      dispatch('fetchCartList')
    } catch (error) {
      console.error('添加到购物车失败', error)
      throw error
    }
  },
  
  // 更新购物车商品
  async updateCartItem({ commit }, { id, cartNum }) {
    try {
      await updateCart(id, { cartNum })
      commit('UPDATE_CART_ITEM', { id, cartNum })
    } catch (error) {
      console.error('更新购物车失败', error)
      throw error
    }
  },
  
  // 删除购物车商品
  async removeCartItem({ commit }, id) {
    try {
      await deleteCart(id)
      commit('REMOVE_CART_ITEM', id)
    } catch (error) {
      console.error('删除购物车商品失败', error)
      throw error
    }
  },
  
  // 清空购物车
  async clearCart({ commit }) {
    try {
      await clearCart()
      commit('CLEAR_CART')
    } catch (error) {
      console.error('清空购物车失败', error)
      throw error
    }
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}
```

### 3.3 API接口

```javascript
// api/cart.js
import request from '@/utils/request'

// 获取购物车列表
export function getCartList() {
  return request({
    url: '/api/cart/list',
    method: 'get'
  })
}

// 添加到购物车
export function addCart(data) {
  return request({
    url: '/api/cart/add',
    method: 'post',
    data
  })
}

// 更新购物车
export function updateCart(id, data) {
  return request({
    url: `/api/cart/update/${id}`,
    method: 'put',
    data
  })
}

// 删除购物车商品
export function deleteCart(id) {
  return request({
    url: `/api/cart/delete/${id}`,
    method: 'delete'
  })
}

// 清空购物车
export function clearCart() {
  return request({
    url: '/api/cart/clear',
    method: 'delete'
  })
}
```

---

## 4. 询价模块设计

### 4.1 询价表单页面（inquiry/submit.vue）

**路由**: `/inquiry/submit`

**功能**:
1. 支持单商品询价（从商品详情页进入）
2. 支持多商品询价（从意向清单进入）
3. 游客和登录用户都可以提交
4. 登录用户可以使用保存的地址信息
5. 多语言支持

**页面布局**:
```
┌─────────────────────────────────────┐
│ 提交询价                             │
├─────────────────────────────────────┤
│ 询价商品列表                         │
│ ┌─────────────────────────────────┐ │
│ │ [图] 商品名称  ¥100/$14.50  x1  │ │
│ │ [图] 商品名称  ¥200/$29.00  x2  │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ 联系信息                             │
│ 姓名：[_____________________]        │
│ 邮箱：[_____________________]        │
│ 电话：[_____________________]        │
│ 国家：[选择国家▼]                    │
│ 地址：[_____________________]        │
│ 备注：[_____________________]        │
│       [_____________________]        │
├─────────────────────────────────────┤
│ [提交询价]                           │
└─────────────────────────────────────┘
```

**实现代码**:
```vue
<template>
  <div class="inquiry-submit-page">
    <h1>{{ $t('inquiry.title') }}</h1>

    <el-form
      ref="inquiryForm"
      :model="form"
      :rules="rules"
      label-width="120px"
    >
      <!-- 询价商品列表 -->
      <div class="product-section">
        <h3>{{ $t('inquiry.productList') }}</h3>
        <div class="product-list">
          <div
            v-for="item in productList"
            :key="item.id"
            class="product-item"
          >
            <img :src="getProductImage(item)" :alt="getProductName(item)" />
            <div class="product-info">
              <h4>{{ getProductName(item) }}</h4>
              <div class="product-price">
                <span class="price-cny">¥{{ item.price }}</span>
                <span class="price-usd">/ ${{ item.priceUsd }}</span>
              </div>
            </div>
            <div class="product-quantity">
              x {{ item.cartNum || 1 }}
            </div>
          </div>
        </div>
      </div>

      <!-- 联系信息 -->
      <div class="contact-section">
        <h3>{{ $t('inquiry.contactInfo') }}</h3>
        
        <el-form-item :label="$t('inquiry.name')" prop="realName">
          <el-input
            v-model="form.realName"
            :placeholder="$t('inquiry.namePlaceholder')"
          />
        </el-form-item>

        <el-form-item :label="$t('inquiry.email')" prop="userEmail">
          <el-input
            v-model="form.userEmail"
            :placeholder="$t('inquiry.emailPlaceholder')"
          />
        </el-form-item>

        <el-form-item :label="$t('inquiry.phone')" prop="userPhone">
          <el-input
            v-model="form.userPhone"
            :placeholder="$t('inquiry.phonePlaceholder')"
          />
        </el-form-item>

        <el-form-item :label="$t('inquiry.country')" prop="country">
          <el-select
            v-model="form.country"
            :placeholder="$t('inquiry.countryPlaceholder')"
            filterable
          >
            <el-option
              v-for="country in countryList"
              :key="country.code"
              :label="getCountryName(country)"
              :value="country.code"
            />
          </el-select>
        </el-form-item>

        <el-form-item :label="$t('inquiry.address')" prop="userAddress">
          <el-input
            v-model="form.userAddress"
            type="textarea"
            :rows="3"
            :placeholder="$t('inquiry.addressPlaceholder')"
          />
        </el-form-item>

        <el-form-item :label="$t('inquiry.remark')">
          <el-input
            v-model="form.userRemark"
            type="textarea"
            :rows="3"
            :placeholder="$t('inquiry.remarkPlaceholder')"
          />
        </el-form-item>
      </div>

      <!-- 提交按钮 -->
      <el-form-item>
        <el-button
          type="primary"
          size="large"
          :loading="submitting"
          @click="handleSubmit"
        >
          {{ $t('inquiry.title') }}
        </el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
import { getProductDetail } from '@/api/product'
import { submitInquiry } from '@/api/inquiry'
import { countryList } from '@/utils/country'

export default {
  name: 'InquirySubmit',
  data() {
    return {
      form: {
        realName: '',
        userEmail: '',
        userPhone: '',
        country: '',
        userAddress: '',
        userRemark: '',
        userLanguage: this.$i18n.locale
      },
      productList: [],
      countryList: countryList,
      submitting: false,
      rules: {
        realName: [
          { required: true, message: this.$t('validation.required'), trigger: 'blur' }
        ],
        userEmail: [
          { required: true, message: this.$t('validation.required'), trigger: 'blur' },
          { type: 'email', message: this.$t('validation.emailFormat'), trigger: 'blur' }
        ],
        userPhone: [
          { required: true, message: this.$t('validation.required'), trigger: 'blur' }
        ],
        country: [
          { required: true, message: this.$t('validation.required'), trigger: 'change' }
        ],
        userAddress: [
          { required: true, message: this.$t('validation.required'), trigger: 'blur' }
        ]
      }
    }
  },
  computed: {
    currentLanguage() {
      return this.$i18n.locale
    }
  },
  mounted() {
    this.loadProducts()
    this.loadUserInfo()
  },
  methods: {
    async loadProducts() {
      const { productId, productIds } = this.$route.query
      
      if (productId) {
        // 单商品询价
        const res = await getProductDetail(productId)
        this.productList = [{ ...res.data, cartNum: 1 }]
      } else if (productIds) {
        // 多商品询价（从购物车）
        const ids = productIds.split(',')
        const cartList = this.$store.state.cart.cartList
        this.productList = cartList.filter(item => ids.includes(String(item.productId)))
      }
    },
    
    loadUserInfo() {
      // 如果用户已登录，加载用户信息
      const userInfo = this.$store.state.user.userInfo
      if (userInfo) {
        this.form.realName = userInfo.nickname
        this.form.userEmail = userInfo.email
        this.form.userPhone = userInfo.phone
        this.form.country = userInfo.defaultCountry
        this.form.userAddress = userInfo.defaultAddress
      }
    },
    
    getProductName(item) {
      const product = item.productInfo || item
      const langMap = {
        zh: product.storeName,
        en: product.storeNameEn,
        ru: product.storeNameRu,
        ar: product.storeNameAr
      }
      return langMap[this.currentLanguage] || product.storeName
    },
    
    getProductImage(item) {
      const product = item.productInfo || item
      const langMap = {
        zh: product.image,
        en: product.imageEn,
        ru: product.imageRu,
        ar: product.imageAr
      }
      return langMap[this.currentLanguage] || product.image
    },
    
    getCountryName(country) {
      const langMap = {
        zh: country.nameZh,
        en: country.nameEn,
        ru: country.nameRu,
        ar: country.nameAr
      }
      return langMap[this.currentLanguage] || country.nameEn
    },
    
    handleSubmit() {
      this.$refs.inquiryForm.validate(async (valid) => {
        if (!valid) return
        
        this.submitting = true
        try {
          const data = {
            ...this.form,
            products: this.productList.map(item => ({
              productId: item.productId || item.id,
              cartNum: item.cartNum || 1
            }))
          }
          
          await submitInquiry(data)
          
          this.$message.success(this.$t('inquiry.submitSuccess'))
          
          // 清空购物车中已询价的商品
          if (this.$route.query.productIds) {
            const ids = this.$route.query.productIds.split(',')
            ids.forEach(id => {
              this.$store.dispatch('cart/removeCartItem', Number(id))
            })
          }
          
          // 跳转到我的询价单
          this.$router.push('/inquiry/list')
        } catch (error) {
          this.$message.error(this.$t('inquiry.submitFailed'))
        } finally {
          this.submitting = false
        }
      })
    }
  }
}
</script>

<style scoped>
.inquiry-submit-page {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
}

.product-section,
.contact-section {
  margin-bottom: 30px;
}

.product-list {
  border: 1px solid #eee;
  border-radius: 4px;
  padding: 15px;
}

.product-item {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 10px 0;
  border-bottom: 1px solid #eee;
}

.product-item:last-child {
  border-bottom: none;
}

.product-item img {
  width: 80px;
  height: 80px;
  object-fit: cover;
  border-radius: 4px;
}

.product-info {
  flex: 1;
}

.product-info h4 {
  margin-bottom: 5px;
}

.price-cny {
  font-size: 16px;
  color: #f56c6c;
  font-weight: bold;
}

.price-usd {
  font-size: 14px;
  color: #909399;
  margin-left: 5px;
}

.product-quantity {
  font-size: 16px;
  color: #666;
}
</style>
```

---

## 📝 下一步

PC端商城详细方案第三部分已完成，包括：
1. 意向清单改造（页面+Vuex+API）
2. 询价表单页面设计

还需要继续设计：
3. 我的询价单列表页面
4. 询价单详情页面
5. 用户中心改造
6. API请求拦截器
7. 阿拉伯语RTL支持
8. 路由配置

继续吗？
