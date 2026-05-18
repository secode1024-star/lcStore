# API接口设计总结

## 📊 接口统计

### C端接口（15个）
1. 商品相关 (2个)
2. 分类相关 (1个)
3. 意向清单相关 (4个)
4. 询价相关 (3个)
5. 用户相关 (4个)
6. 系统配置相关 (1个)

### 商家端接口（12个）
1. 商家登录相关 (1个)
2. 商品管理 (9个)
3. 分类相关 (1个)
4. 商家信息 (1个)

### 平台端接口（12个）
1. 平台管理员登录 (1个)
2. 询价管理 (4个)
3. 商品审核 (3个)
4. 商品管理 (2个)
5. 翻译成本统计 (2个)

**总计：39个接口**

---

## 🎯 设计原则遵循情况

### 1. RESTful风格
- ✅ 使用标准HTTP方法（GET/POST/PUT/DELETE）
- ✅ URL命名清晰，符合资源命名规范
- ✅ 使用路径参数和查询参数

### 2. 统一响应格式
- ✅ 所有接口使用CommonResult包装
- ✅ 包含code、message、data、timestamp字段

### 3. 参数校验
- ✅ 使用JSR-303注解（@NotNull、@NotBlank、@Min、@Max等）
- ✅ 自定义校验规则（@Pattern、@Email等）

### 4. 多语言支持
- ✅ C端通过Accept-Language请求头识别语言
- ✅ 商家端和平台端仅中文

### 5. 权限控制
- ✅ 需要登录的接口使用Authorization请求头
- ✅ 商家端只能操作自己的数据
- ✅ 平台端可以查看所有数据

### 6. 分页查询
- ✅ 列表接口统一使用page和limit参数
- ✅ 响应使用PageInfo包装

---

## 📋 接口详细列表

### C端接口

| 序号 | 接口地址 | 方法 | 描述 | 是否需要登录 |
|------|---------|------|------|-------------|
| 1 | /api/front/product/list | GET | 商品列表 | 否 |
| 2 | /api/front/product/detail/{id} | GET | 商品详情 | 否 |
| 3 | /api/front/category/list | GET | 分类列表 | 否 |
| 4 | /api/front/cart/add | POST | 添加到意向清单 | 是 |
| 5 | /api/front/cart/list | GET | 意向清单列表 | 是 |
| 6 | /api/front/cart/update/{id} | PUT | 更新意向清单数量 | 是 |
| 7 | /api/front/cart/delete/{id} | DELETE | 删除意向清单商品 | 是 |
| 8 | /api/front/inquiry/submit | POST | 提交询价单 | 否 |
| 9 | /api/front/inquiry/my-list | GET | 我的询价单列表 | 是 |
| 10 | /api/front/inquiry/detail/{inquiryNo} | GET | 询价单详情 | 是 |
| 11 | /api/front/user/register | POST | 用户注册 | 否 |
| 12 | /api/front/user/login | POST | 用户登录 | 否 |
| 13 | /api/front/user/info | GET | 获取用户信息 | 是 |
| 14 | /api/front/user/update | PUT | 更新用户信息 | 是 |
| 15 | /api/front/config/info | GET | 获取系统配置 | 否 |

### 商家端接口

| 序号 | 接口地址 | 方法 | 描述 |
|------|---------|------|------|
| 1 | /api/merchant/auth/login | POST | 商家登录 |
| 2 | /api/merchant/product/list | GET | 商品列表 |
| 3 | /api/merchant/product/detail/{id} | GET | 商品详情 |
| 4 | /api/merchant/product/add | POST | 添加商品 |
| 5 | /api/merchant/product/update/{id} | PUT | 编辑商品 |
| 6 | /api/merchant/product/on-sale/{id} | PUT | 上架商品 |
| 7 | /api/merchant/product/off-sale/{id} | PUT | 下架商品 |
| 8 | /api/merchant/product/delete/{id} | DELETE | 删除商品 |
| 9 | /api/merchant/product/retry-translation/{id} | PUT | 重新翻译 |
| 10 | /api/merchant/product/translation-progress/{id} | GET | 查询翻译进度 |
| 11 | /api/merchant/category/list | GET | 分类列表 |
| 12 | /api/merchant/info | GET | 获取商家信息 |

### 平台端接口

| 序号 | 接口地址 | 方法 | 描述 |
|------|---------|------|------|
| 1 | /api/platform/auth/login | POST | 平台管理员登录 |
| 2 | /api/platform/inquiry/list | GET | 询价单列表 |
| 3 | /api/platform/inquiry/detail/{inquiryNo} | GET | 询价单详情 |
| 4 | /api/platform/inquiry/update-status/{inquiryNo} | PUT | 更新询价单状态 |
| 5 | /api/platform/inquiry/statistics | GET | 询价统计 |
| 6 | /api/platform/product/audit-list | GET | 待审核商品列表 |
| 7 | /api/platform/product/audit-detail/{id} | GET | 商品审核详情 |
| 8 | /api/platform/product/audit/{id} | PUT | 审核商品 |
| 9 | /api/platform/product/list | GET | 所有商品列表 |
| 10 | /api/platform/product/force-off-sale/{id} | PUT | 强制下架商品 |
| 11 | /api/platform/translation/cost-statistics | GET | 翻译成本统计 |
| 12 | /api/platform/translation/cache-statistics | GET | 翻译缓存统计 |

---

## 🔍 关键业务流程

### 1. 商品上架流程
```
商家添加商品 → 商家上架商品 → 触发翻译 → 翻译完成 → 自动提交审核 → 平台审核 → 审核通过 → 自动上架
```

**涉及接口**:
- POST /api/merchant/product/add
- PUT /api/merchant/product/on-sale/{id}
- GET /api/merchant/product/translation-progress/{id}
- GET /api/platform/product/audit-list
- PUT /api/platform/product/audit/{id}

### 2. 询价流程
```
用户浏览商品 → 添加到意向清单（可选） → 提交询价 → 平台接收询价 → 平台处理询价
```

**涉及接口**:
- GET /api/front/product/list
- POST /api/front/cart/add
- POST /api/front/inquiry/submit
- GET /api/platform/inquiry/list
- PUT /api/platform/inquiry/update-status/{inquiryNo}

### 3. 用户注册登录流程
```
用户注册 → 用户登录 → 获取Token → 使用Token访问需要登录的接口
```

**涉及接口**:
- POST /api/front/user/register
- POST /api/front/user/login
- GET /api/front/user/info

---

## 📝 请求/响应示例

### 示例1：提交询价单

**请求**:
```http
POST /api/front/inquiry/submit
Accept-Language: en
Content-Type: application/json

{
    "inquiryType": "cart",
    "cartIds": [1, 2, 3],
    "realName": "John Doe",
    "userPhone": "+1234567890",
    "userEmail": "john@example.com",
    "country": "United States",
    "userAddress": "123 Main St, New York, NY 10001",
    "userRemark": "Please quote best price"
}
```

**响应**:
```json
{
    "code": 200,
    "message": "Inquiry submitted successfully",
    "data": {
        "inquiryNo": "INQ202605180001",
        "createTime": "2026-05-18 13:30:00"
    },
    "timestamp": 1715999999999
}
```

### 示例2：商家上架商品

**请求**:
```http
PUT /api/merchant/product/on-sale/123
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**响应**:
```json
{
    "code": 200,
    "message": "商品已提交翻译，翻译完成后将自动提交审核",
    "data": null,
    "timestamp": 1715999999999
}
```

### 示例3：平台审核商品

**请求**:
```http
PUT /api/platform/product/audit/123
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
    "auditStatus": 1,
    "auditRemark": ""
}
```

**响应**:
```json
{
    "code": 200,
    "message": "审核成功",
    "data": null,
    "timestamp": 1715999999999
}
```

---

## 🔐 权限设计

### Token机制
- 使用JWT Token进行身份认证
- Token通过Authorization请求头传递：`Authorization: Bearer {token}`
- Token包含用户/商家/管理员ID和角色信息
- Token有效期：7天

### 权限级别
1. **游客** - 可以浏览商品、提交询价
2. **登录用户** - 可以使用意向清单、查看自己的询价单
3. **商家** - 可以管理自己的商品
4. **平台管理员** - 可以管理所有数据

---

## 📊 错误码设计

| 错误码 | 说明 |
|--------|------|
| 200 | 成功 |
| 400 | 参数错误 |
| 401 | 未登录或Token过期 |
| 403 | 无权限 |
| 404 | 资源不存在 |
| 500 | 服务器内部错误 |

---

## ✅ 符合阿里巴巴规范检查

### 1. 接口命名
- ✅ 使用小写字母和连字符
- ✅ 使用复数形式表示资源集合
- ✅ 使用动词表示操作

### 2. 参数校验
- ✅ 使用JSR-303注解
- ✅ 错误信息清晰明确

### 3. 响应格式
- ✅ 统一使用CommonResult
- ✅ 包含必要的元数据

### 4. 文档完整性
- ✅ 每个接口都有清晰的描述
- ✅ 包含请求参数和响应数据的详细说明
- ✅ 提供请求/响应示例

---

## 📅 更新日志

- **2026-05-18** - 完成API接口设计（C端、商家端、平台端）
- **2026-05-18** - 创建API接口设计总结文档
