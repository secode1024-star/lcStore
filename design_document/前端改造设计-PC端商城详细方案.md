# 前端改造设计 - PC端商城详细方案（et_pc）

## 📋 改造清单

### 需要删除的模块和页面

#### 1. 支付相关
- 支付方式选择页面
- 支付页面
- 支付结果页面
- 支付记录页面

#### 2. 订单相关
- 订单列表页面
- 订单详情页面
- 订单跟踪页面
- 物流信息页面

#### 3. 退款售后
- 退款申请页面
- 退款列表页面
- 退款详情页面

#### 4. 会员中心
- 积分页面
- 优惠券页面
- 会员等级页面
- 签到页面

#### 5. 营销活动
- 秒杀页面
- 拼团页面
- 砍价页面

#### 6. 互动功能
- 商品评价页面
- 商品收藏页面
- 店铺关注页面

---

### 需要保留并改造的模块

#### 1. 商品展示模块（重点改造）
- 首页 - **改造**（多语言）
- 商品列表页 - **改造**（多语言）
- 商品详情页 - **改造**（多语言）
- 商品分类页 - **改造**（多语言）
- 商品搜索页 - **改造**（多语言）

#### 2. 购物车模块
- 购物车页面 - **改造为意向清单**

#### 3. 用户中心模块
- 个人信息页 - **简化**
- 地址管理页 - **保留**
- 修改密码页 - **保留**

---

### 需要新增的模块和页面

#### 1. 询价模块
- 询价表单页面 - **新增**
- 我的询价单列表 - **新增**
- 询价单详情页 - **新增**

#### 2. 多语言支持
- 语言切换器组件 - **新增**
- 多语言路由处理 - **新增**

---

## 1. 多语言实现方案

### 1.1 技术方案

**现状**: et_pc已集成vue-i18n 8.26.7

**改造方案**:
1. 扩展语言包（zh/en/ru/ar）
2. 语言切换器组件
3. 语言持久化（localStorage + Cookie）
4. API请求头自动添加Accept-Language
5. 阿拉伯语RTL布局支持
6. 路由国际化（可选）

### 1.2 语言包结构

```javascript
// i18n/zh.js - 中文语言包
export default {
  common: {
    home: '首页',
    category: '分类',
    cart: '意向清单',
    inquiry: '询价',
    user: '用户中心',
    login: '登录',
    register: '注册',
    logout: '退出',
    search: '搜索',
    searchPlaceholder: '请输入商品名称',
    more: '更多',
    viewDetail: '查看详情',
    addToCart: '加入意向清单',
    inquiryNow: '立即询价',
    submit: '提交',
    cancel: '取消',
    confirm: '确认',
    delete: '删除',
    edit: '编辑',
    save: '保存',
    back: '返回',
    loading: '加载中...',
    noData: '暂无数据',
    price: '价格',
    quantity: '数量',
    total: '合计'
  },
  header: {
    welcome: '欢迎来到寰球联采',
    languageSwitch: '语言切换',
    contactUs: '联系我们',
    aboutUs: '关于我们'
  },
  product: {
    category: '商品分类',
    hotProducts: '热门商品',
    newProducts: '最新商品',
    productDetail: '商品详情',
    productName: '商品名称',
    productPrice: '商品价格',
    productDescription: '商品描述',
    productImages: '商品图片',
    priceRange: '价格区间',
    referencePrice: '参考价格',
    keywords: '关键词'
  },
  cart: {
    title: '意向清单',
    empty: '意向清单为空',
    productName: '商品名称',
    price: '价格',
    quantity: '数量',
    operation: '操作',
    remove: '移除',
    clear: '清空',
    inquirySelected: '询价选中商品',
    inquiryAll: '全部询价',
    selectAll: '全选',
    selected: '已选',
    items: '件商品'
  },
  inquiry: {
    title: '提交询价',
    formTitle: '询价信息',
    contactInfo: '联系信息',
    name: '姓名',
    namePlaceholder: '请输入您的姓名',
    email: '邮箱',
    emailPlaceholder: '请输入您的邮箱',
    phone: '电话',
    phonePlaceholder: '请输入您的电话',
    country: '国家',
    countryPlaceholder: '请选择国家',
    address: '地址',
    addressPlaceholder: '请输入详细地址',
    remark: '备注',
    remarkPlaceholder: '请输入备注信息（可选）',
    productList: '询价商品',
    submitSuccess: '询价提交成功',
    submitFailed: '询价提交失败',
    myInquiry: '我的询价单',
    inquiryNo: '询价单号',
    inquiryStatus: '询价状态',
    inquiryTime: '询价时间',
    statusPending: '待处理',
    statusProcessed: '已处理',
    statusCancelled: '已废弃',
    viewDetail: '查看详情'
  },
  user: {
    center: '用户中心',
    profile: '个人信息',
    address: '地址管理',
    inquiry: '我的询价',
    password: '修改密码',
    nickname: '昵称',
    avatar: '头像',
    defaultCountry: '默认国家',
    defaultAddress: '默认地址',
    preferredLanguage: '首选语言'
  },
  validation: {
    required: '此项为必填项',
    emailFormat: '邮箱格式不正确',
    phoneFormat: '电话格式不正确',
    minLength: '长度不能少于{min}个字符',
    maxLength: '长度不能超过{max}个字符'
  },
  message: {
    success: '操作成功',
    failed: '操作失败',
    networkError: '网络错误，请稍后重试',
    loginRequired: '请先登录',
    addToCartSuccess: '已加入意向清单',
    removeFromCartSuccess: '已从意向清单移除',
    inquirySubmitSuccess: '询价提交成功，我们会尽快与您联系'
  }
}
```

```javascript
// i18n/en.js - 英文语言包
export default {
  common: {
    home: 'Home',
    category: 'Category',
    cart: 'Wishlist',
    inquiry: 'Inquiry',
    user: 'User Center',
    login: 'Login',
    register: 'Register',
    logout: 'Logout',
    search: 'Search',
    searchPlaceholder: 'Enter product name',
    more: 'More',
    viewDetail: 'View Detail',
    addToCart: 'Add to Wishlist',
    inquiryNow: 'Inquiry Now',
    submit: 'Submit',
    cancel: 'Cancel',
    confirm: 'Confirm',
    delete: 'Delete',
    edit: 'Edit',
    save: 'Save',
    back: 'Back',
    loading: 'Loading...',
    noData: 'No Data',
    price: 'Price',
    quantity: 'Quantity',
    total: 'Total'
  },
  header: {
    welcome: 'Welcome to Global Procurement',
    languageSwitch: 'Language',
    contactUs: 'Contact Us',
    aboutUs: 'About Us'
  },
  product: {
    category: 'Category',
    hotProducts: 'Hot Products',
    newProducts: 'New Products',
    productDetail: 'Product Detail',
    productName: 'Product Name',
    productPrice: 'Price',
    productDescription: 'Description',
    productImages: 'Images',
    priceRange: 'Price Range',
    referencePrice: 'Reference Price',
    keywords: 'Keywords'
  },
  cart: {
    title: 'Wishlist',
    empty: 'Your wishlist is empty',
    productName: 'Product',
    price: 'Price',
    quantity: 'Quantity',
    operation: 'Operation',
    remove: 'Remove',
    clear: 'Clear',
    inquirySelected: 'Inquiry Selected',
    inquiryAll: 'Inquiry All',
    selectAll: 'Select All',
    selected: 'Selected',
    items: 'items'
  },
  inquiry: {
    title: 'Submit Inquiry',
    formTitle: 'Inquiry Information',
    contactInfo: 'Contact Information',
    name: 'Name',
    namePlaceholder: 'Enter your name',
    email: 'Email',
    emailPlaceholder: 'Enter your email',
    phone: 'Phone',
    phonePlaceholder: 'Enter your phone',
    country: 'Country',
    countryPlaceholder: 'Select country',
    address: 'Address',
    addressPlaceholder: 'Enter your address',
    remark: 'Remark',
    remarkPlaceholder: 'Enter remark (optional)',
    productList: 'Products',
    submitSuccess: 'Inquiry submitted successfully',
    submitFailed: 'Inquiry submission failed',
    myInquiry: 'My Inquiries',
    inquiryNo: 'Inquiry No.',
    inquiryStatus: 'Status',
    inquiryTime: 'Time',
    statusPending: 'Pending',
    statusProcessed: 'Processed',
    statusCancelled: 'Cancelled',
    viewDetail: 'View Detail'
  },
  user: {
    center: 'User Center',
    profile: 'Profile',
    address: 'Address',
    inquiry: 'My Inquiries',
    password: 'Password',
    nickname: 'Nickname',
    avatar: 'Avatar',
    defaultCountry: 'Default Country',
    defaultAddress: 'Default Address',
    preferredLanguage: 'Preferred Language'
  },
  validation: {
    required: 'This field is required',
    emailFormat: 'Invalid email format',
    phoneFormat: 'Invalid phone format',
    minLength: 'Minimum length is {min} characters',
    maxLength: 'Maximum length is {max} characters'
  },
  message: {
    success: 'Success',
    failed: 'Failed',
    networkError: 'Network error, please try again later',
    loginRequired: 'Please login first',
    addToCartSuccess: 'Added to wishlist',
    removeFromCartSuccess: 'Removed from wishlist',
    inquirySubmitSuccess: 'Inquiry submitted successfully, we will contact you soon'
  }
}
```

**注意**: 俄语（ru.js）和阿拉伯语（ar.js）语言包结构相同，只是翻译内容不同。

### 1.3 i18n配置

```javascript
// i18n/index.js
import Vue from 'vue'
import VueI18n from 'vue-i18n'
import Cookies from 'js-cookie'
import elementEnLocale from 'element-ui/lib/locale/lang/en'
import elementZhLocale from 'element-ui/lib/locale/lang/zh-CN'
import elementRuLocale from 'element-ui/lib/locale/lang/ru-RU'
import elementArLocale from 'element-ui/lib/locale/lang/ar'
import zhLocale from './zh'
import enLocale from './en'
import ruLocale from './ru'
import arLocale from './ar'

Vue.use(VueI18n)

const messages = {
  zh: {
    ...zhLocale,
    ...elementZhLocale
  },
  en: {
    ...enLocale,
    ...elementEnLocale
  },
  ru: {
    ...ruLocale,
    ...elementRuLocale
  },
  ar: {
    ...arLocale,
    ...elementArLocale
  }
}

// 获取默认语言
export function getLanguage() {
  const chooseLanguage = Cookies.get('language')
  if (chooseLanguage) return chooseLanguage

  // 如果没有选择语言，使用浏览器语言
  const language = (navigator.language || navigator.browserLanguage).toLowerCase()
  const locales = Object.keys(messages)
  for (const locale of locales) {
    if (language.indexOf(locale) > -1) {
      return locale
    }
  }
  return 'zh'
}

const i18n = new VueI18n({
  locale: getLanguage(),
  messages,
  silentTranslationWarn: true
})

export default i18n
```

### 1.4 语言切换器组件

```vue
<!-- components/LanguageSwitcher.vue -->
<template>
  <el-dropdown @command="handleSetLanguage">
    <div class="language-switcher">
      <i class="el-icon-s-flag"></i>
      <span>{{ currentLanguageName }}</span>
      <i class="el-icon-arrow-down el-icon--right"></i>
    </div>
    <el-dropdown-menu slot="dropdown">
      <el-dropdown-item
        v-for="lang in languages"
        :key="lang.value"
        :command="lang.value"
        :disabled="language === lang.value"
      >
        <span :class="{ 'is-active': language === lang.value }">
          {{ lang.label }}
        </span>
      </el-dropdown-item>
    </el-dropdown-menu>
  </el-dropdown>
</template>

<script>
import Cookies from 'js-cookie'

export default {
  name: 'LanguageSwitcher',
  data() {
    return {
      languages: [
        { label: '中文', value: 'zh' },
        { label: 'English', value: 'en' },
        { label: 'Русский', value: 'ru' },
        { label: 'العربية', value: 'ar' }
      ]
    }
  },
  computed: {
    language() {
      return this.$i18n.locale
    },
    currentLanguageName() {
      const lang = this.languages.find(l => l.value === this.language)
      return lang ? lang.label : 'Language'
    }
  },
  methods: {
    handleSetLanguage(lang) {
      this.$i18n.locale = lang
      Cookies.set('language', lang)
      
      // 设置HTML的lang和dir属性
      document.documentElement.lang = lang
      document.documentElement.dir = lang === 'ar' ? 'rtl' : 'ltr'
      
      // 刷新页面数据
      this.$emit('language-changed', lang)
      
      // 提示用户
      this.$message.success(this.$t('message.success'))
      
      // 重新加载页面（可选）
      // location.reload()
    }
  }
}
</script>

<style scoped>
.language-switcher {
  display: flex;
  align-items: center;
  cursor: pointer;
  padding: 0 10px;
}

.language-switcher:hover {
  color: #409eff;
}

.is-active {
  color: #409eff;
  font-weight: bold;
}
</style>
```

---

## 📝 下一步

PC端商城详细方案第一部分已完成，包括：
1. 改造清单
2. 多语言实现方案（语言包、i18n配置、语言切换器）

还需要继续设计：
3. 商品展示模块改造
4. 意向清单改造
5. 询价模块设计
6. 用户中心改造
7. 阿拉伯语RTL支持
8. API请求拦截器
9. 路由配置

继续吗？
