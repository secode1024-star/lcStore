# API接口设计 - 平台端接口

## 设计原则

1. **RESTful风格** - 遵循REST API设计规范
2. **仅中文** - 平台端永远显示中文，不需要多语言支持
3. **统一响应格式** - 使用CommonResult包装所有响应
4. **权限控制** - 所有接口需要平台管理员登录
5. **分页查询** - 列表接口统一使用PageInfo分页
6. **数据权限** - 可以查看和管理所有商家的数据

---

## 1. 平台管理员登录相关接口

### 1.1 平台管理员登录

**接口地址**: `POST /api/platform/auth/login`

**接口描述**: 平台管理员登录

**请求参数**:
```java
public class PlatformLoginRequest {
    @ApiModelProperty(value = "账号", required = true)
    @NotBlank(message = "账号不能为空")
    private String account;
    
    @ApiModelProperty(value = "密码", required = true)
    @NotBlank(message = "密码不能为空")
    private String password;
}
```

**响应数据**:
```java
public class PlatformLoginVO {
    @ApiModelProperty(value = "管理员ID")
    private Integer adminId;
    
    @ApiModelProperty(value = "管理员姓名")
    private String realName;
    
    @ApiModelProperty(value = "账号")
    private String account;
    
    @ApiModelProperty(value = "Token")
    private String token;
    
    @ApiModelProperty(value = "Token过期时间")
    private Date tokenExpireTime;
}
```

---

## 2. 询价管理接口

### 2.1 询价单列表

**接口地址**: `GET /api/platform/inquiry/list`

**接口描述**: 获取询价单列表（可按商家筛选）

**请求头**:
```
Authorization: Bearer {token}
```

**请求参数**:
```java
public class PlatformInquiryListRequest {
    @ApiModelProperty(value = "页码", example = "1")
    @Min(value = 1, message = "页码最小为1")
    private Integer page = 1;
    
    @ApiModelProperty(value = "每页数量", example = "20")
    @Min(value = 1, message = "每页数量最小为1")
    @Max(value = 100, message = "每页数量最大为100")
    private Integer limit = 20;
    
    @ApiModelProperty(value = "询价单号")
    private String inquiryNo;
    
    @ApiModelProperty(value = "商家ID")
    private Integer merId;
    
    @ApiModelProperty(value = "询价状态：0-待处理，1-已处理，2-已废弃")
    private Integer inquiryStatus;
    
    @ApiModelProperty(value = "用户语言：zh/en/ru/ar")
    private String userLanguage;
    
    @ApiModelProperty(value = "国家")
    private String country;
    
    @ApiModelProperty(value = "开始时间")
    private Date startTime;
    
    @ApiModelProperty(value = "结束时间")
    private Date endTime;
}
```

**响应数据**:
```java
public class PlatformInquiryListVO {
    @ApiModelProperty(value = "询价单号")
    private String inquiryNo;
    
    @ApiModelProperty(value = "询价状态：0-待处理，1-已处理，2-已废弃")
    private Integer inquiryStatus;
    
    @ApiModelProperty(value = "询价状态文本")
    private String inquiryStatusText;
    
    @ApiModelProperty(value = "商品总数")
    private Integer totalNum;
    
    @ApiModelProperty(value = "联系人姓名（中文翻译）")
    private String realName;
    
    @ApiModelProperty(value = "联系电话")
    private String userPhone;
    
    @ApiModelProperty(value = "联系邮箱")
    private String userEmail;
    
    @ApiModelProperty(value = "国家（中文翻译）")
    private String country;
    
    @ApiModelProperty(value = "用户语言")
    private String userLanguage;
    
    @ApiModelProperty(value = "涉及商家数量")
    private Integer merchantCount;
    
    @ApiModelProperty(value = "提交时间")
    private Date createTime;
    
    @ApiModelProperty(value = "处理时间")
    private Date processTime;
}
```

---

### 2.2 询价单详情

**接口地址**: `GET /api/platform/inquiry/detail/{inquiryNo}`

**接口描述**: 获取询价单详细信息（显示中文翻译）

**请求头**:
```
Authorization: Bearer {token}
```

**路径参数**:
- `inquiryNo`: 询价单号

**响应数据**:
```java
public class PlatformInquiryDetailVO {
    @ApiModelProperty(value = "询价单号")
    private String inquiryNo;
    
    @ApiModelProperty(value = "询价状态：0-待处理，1-已处理，2-已废弃")
    private Integer inquiryStatus;
    
    @ApiModelProperty(value = "询价状态文本")
    private String inquiryStatusText;
    
    @ApiModelProperty(value = "用户ID（登录用户才有）")
    private Integer uid;
    
    @ApiModelProperty(value = "用户语言")
    private String userLanguage;
    
    @ApiModelProperty(value = "联系人姓名（中文翻译）")
    private String realName;
    
    @ApiModelProperty(value = "联系人姓名（原文）")
    private String realNameOriginal;
    
    @ApiModelProperty(value = "联系电话")
    private String userPhone;
    
    @ApiModelProperty(value = "联系邮箱")
    private String userEmail;
    
    @ApiModelProperty(value = "国家（中文翻译）")
    private String country;
    
    @ApiModelProperty(value = "详细地址（中文翻译）")
    private String userAddress;
    
    @ApiModelProperty(value = "详细地址（原文）")
    private String userAddressOriginal;
    
    @ApiModelProperty(value = "备注（中文翻译）")
    private String userRemark;
    
    @ApiModelProperty(value = "备注（原文）")
    private String userRemarkOriginal;
    
    @ApiModelProperty(value = "商品列表（按商家分组）")
    private List<InquiryMerchantGroupVO> merchantGroups;
    
    @ApiModelProperty(value = "提交时间")
    private Date createTime;
    
    @ApiModelProperty(value = "处理时间")
    private Date processTime;
}

public class InquiryMerchantGroupVO {
    @ApiModelProperty(value = "商家ID")
    private Integer merId;
    
    @ApiModelProperty(value = "商家名称")
    private String merName;
    
    @ApiModelProperty(value = "商品列表")
    private List<InquiryItemVO> items;
}

public class InquiryItemVO {
    @ApiModelProperty(value = "商品ID")
    private Integer productId;
    
    @ApiModelProperty(value = "商品名称（中文）")
    private String productName;
    
    @ApiModelProperty(value = "商品图片（中文）")
    private String image;
    
    @ApiModelProperty(value = "人民币价格")
    private BigDecimal price;
    
    @ApiModelProperty(value = "美元价格")
    private BigDecimal priceUsd;
    
    @ApiModelProperty(value = "数量")
    private Integer quantity;
}
```

---

### 2.3 更新询价单状态

**接口地址**: `PUT /api/platform/inquiry/update-status/{inquiryNo}`

**接口描述**: 更新询价单状态

**请求头**:
```
Authorization: Bearer {token}
```

**路径参数**:
- `inquiryNo`: 询价单号

**请求参数**:
```java
public class InquiryUpdateStatusRequest {
    @ApiModelProperty(value = "询价状态：1-已处理，2-已废弃", required = true)
    @NotNull(message = "询价状态不能为空")
    @Min(value = 1, message = "状态值最小为1")
    @Max(value = 2, message = "状态值最大为2")
    private Integer inquiryStatus;
}
```

**响应数据**:
```java
// 返回 CommonResult<String>
{
    "code": 200,
    "message": "更新成功",
    "data": null,
    "timestamp": 1715999999999
}
```

---

### 2.4 询价统计

**接口地址**: `GET /api/platform/inquiry/statistics`

**接口描述**: 获取询价统计数据

**请求头**:
```
Authorization: Bearer {token}
```

**请求参数**:
```java
public class InquiryStatisticsRequest {
    @ApiModelProperty(value = "开始时间")
    private Date startTime;
    
    @ApiModelProperty(value = "结束时间")
    private Date endTime;
    
    @ApiModelProperty(value = "商家ID")
    private Integer merId;
}
```

**响应数据**:
```java
public class InquiryStatisticsVO {
    @ApiModelProperty(value = "总询价单数")
    private Integer totalCount;
    
    @ApiModelProperty(value = "待处理数量")
    private Integer pendingCount;
    
    @ApiModelProperty(value = "已处理数量")
    private Integer processedCount;
    
    @ApiModelProperty(value = "已废弃数量")
    private Integer discardedCount;
    
    @ApiModelProperty(value = "按语言统计")
    private Map<String, Integer> countByLanguage;
    
    @ApiModelProperty(value = "按国家统计（Top 10）")
    private List<CountryStatVO> topCountries;
    
    @ApiModelProperty(value = "按商家统计（Top 10）")
    private List<MerchantStatVO> topMerchants;
    
    @ApiModelProperty(value = "按日期统计（最近30天）")
    private List<DateStatVO> dailyStats;
}

public class CountryStatVO {
    @ApiModelProperty(value = "国家")
    private String country;
    
    @ApiModelProperty(value = "询价数量")
    private Integer count;
}

public class MerchantStatVO {
    @ApiModelProperty(value = "商家ID")
    private Integer merId;
    
    @ApiModelProperty(value = "商家名称")
    private String merName;
    
    @ApiModelProperty(value = "询价数量")
    private Integer count;
}

public class DateStatVO {
    @ApiModelProperty(value = "日期")
    private String date;
    
    @ApiModelProperty(value = "询价数量")
    private Integer count;
}
```

---

## 3. 商品审核接口

### 3.1 待审核商品列表

**接口地址**: `GET /api/platform/product/audit-list`

**接口描述**: 获取待审核商品列表

**请求头**:
```
Authorization: Bearer {token}
```

**请求参数**:
```java
public class ProductAuditListRequest {
    @ApiModelProperty(value = "页码", example = "1")
    @Min(value = 1, message = "页码最小为1")
    private Integer page = 1;
    
    @ApiModelProperty(value = "每页数量", example = "20")
    @Min(value = 1, message = "每页数量最小为1")
    @Max(value = 100, message = "每页数量最大为100")
    private Integer limit = 20;
    
    @ApiModelProperty(value = "商家ID")
    private Integer merId;
    
    @ApiModelProperty(value = "审核状态：0-待审核，1-审核通过，2-审核拒绝")
    private Integer auditStatus;
    
    @ApiModelProperty(value = "商品名称关键词")
    private String keyword;
}
```

**响应数据**:
```java
public class ProductAuditListVO {
    @ApiModelProperty(value = "商品ID")
    private Integer id;
    
    @ApiModelProperty(value = "商品名称")
    private String storeName;
    
    @ApiModelProperty(value = "商品主图")
    private String image;
    
    @ApiModelProperty(value = "商家ID")
    private Integer merId;
    
    @ApiModelProperty(value = "商家名称")
    private String merName;
    
    @ApiModelProperty(value = "分类名称")
    private String categoryName;
    
    @ApiModelProperty(value = "人民币价格")
    private BigDecimal price;
    
    @ApiModelProperty(value = "美元价格")
    private BigDecimal priceUsd;
    
    @ApiModelProperty(value = "审核状态：0-待审核，1-审核通过，2-审核拒绝")
    private Integer auditStatus;
    
    @ApiModelProperty(value = "审核状态文本")
    private String auditStatusText;
    
    @ApiModelProperty(value = "翻译状态：0-未翻译，1-翻译中，2-翻译完成，3-翻译失败")
    private Integer translationStatus;
    
    @ApiModelProperty(value = "提交审核时间")
    private Date createTime;
    
    @ApiModelProperty(value = "审核时间")
    private Date auditTime;
}
```

---

### 3.2 商品审核详情

**接口地址**: `GET /api/platform/product/audit-detail/{id}`

**接口描述**: 获取商品审核详情（包含多语言内容）

**请求头**:
```
Authorization: Bearer {token}
```

**路径参数**:
- `id`: 商品ID

**响应数据**:
```java
public class ProductAuditDetailVO {
    @ApiModelProperty(value = "商品ID")
    private Integer id;
    
    @ApiModelProperty(value = "商家ID")
    private Integer merId;
    
    @ApiModelProperty(value = "商家名称")
    private String merName;
    
    @ApiModelProperty(value = "商品名称-中文")
    private String storeName;
    
    @ApiModelProperty(value = "商品名称-英文")
    private String storeNameEn;
    
    @ApiModelProperty(value = "商品名称-俄语")
    private String storeNameRu;
    
    @ApiModelProperty(value = "商品名称-阿拉伯语")
    private String storeNameAr;
    
    @ApiModelProperty(value = "商品简介-中文")
    private String storeInfo;
    
    @ApiModelProperty(value = "商品简介-英文")
    private String storeInfoEn;
    
    @ApiModelProperty(value = "商品简介-俄语")
    private String storeInfoRu;
    
    @ApiModelProperty(value = "商品简介-阿拉伯语")
    private String storeInfoAr;
    
    @ApiModelProperty(value = "轮播图-中文")
    private List<String> sliderImages;
    
    @ApiModelProperty(value = "轮播图-英文")
    private List<String> sliderImagesEn;
    
    @ApiModelProperty(value = "轮播图-俄语")
    private List<String> sliderImagesRu;
    
    @ApiModelProperty(value = "轮播图-阿拉伯语")
    private List<String> sliderImagesAr;
    
    @ApiModelProperty(value = "详情图-中文")
    private List<String> detailImages;
    
    @ApiModelProperty(value = "详情图-英文")
    private List<String> detailImagesEn;
    
    @ApiModelProperty(value = "详情图-俄语")
    private List<String> detailImagesRu;
    
    @ApiModelProperty(value = "详情图-阿拉伯语")
    private List<String> detailImagesAr;
    
    @ApiModelProperty(value = "商品详情-中文")
    private String description;
    
    @ApiModelProperty(value = "商品详情-英文")
    private String descriptionEn;
    
    @ApiModelProperty(value = "商品详情-俄语")
    private String descriptionRu;
    
    @ApiModelProperty(value = "商品详情-阿拉伯语")
    private String descriptionAr;
    
    @ApiModelProperty(value = "人民币价格")
    private BigDecimal price;
    
    @ApiModelProperty(value = "美元价格")
    private BigDecimal priceUsd;
    
    @ApiModelProperty(value = "分类名称")
    private String categoryName;
    
    @ApiModelProperty(value = "审核状态")
    private Integer auditStatus;
    
    @ApiModelProperty(value = "审核备注")
    private String auditRemark;
    
    @ApiModelProperty(value = "翻译状态")
    private Integer translationStatus;
    
    @ApiModelProperty(value = "创建时间")
    private Date createTime;
}
```

---

### 3.3 审核商品

**接口地址**: `PUT /api/platform/product/audit/{id}`

**接口描述**: 审核商品（通过或拒绝）

**请求头**:
```
Authorization: Bearer {token}
```

**路径参数**:
- `id`: 商品ID

**请求参数**:
```java
public class ProductAuditRequest {
    @ApiModelProperty(value = "审核状态：1-审核通过，2-审核拒绝", required = true)
    @NotNull(message = "审核状态不能为空")
    @Min(value = 1, message = "状态值最小为1")
    @Max(value = 2, message = "状态值最大为2")
    private Integer auditStatus;
    
    @ApiModelProperty(value = "审核备注（拒绝时必填）")
    @Length(max = 500, message = "审核备注长度不能超过500")
    private String auditRemark;
}
```

**响应数据**:
```java
// 返回 CommonResult<String>
{
    "code": 200,
    "message": "审核成功",
    "data": null,
    "timestamp": 1715999999999
}
```

**业务逻辑**:
1. 检查商品翻译状态是否为"翻译完成"
2. 更新审核状态和审核备注
3. 记录审核时间
4. 如果审核通过，自动上架商品（is_show = true）
5. 如果审核拒绝，商品保持下架状态
6. 发送站内消息通知商家

---

## 4. 商品管理接口

### 4.1 所有商品列表

**接口地址**: `GET /api/platform/product/list`

**接口描述**: 获取所有商品列表（可按商家筛选）

**请求头**:
```
Authorization: Bearer {token}
```

**请求参数**:
```java
public class PlatformProductListRequest {
    @ApiModelProperty(value = "页码", example = "1")
    @Min(value = 1, message = "页码最小为1")
    private Integer page = 1;
    
    @ApiModelProperty(value = "每页数量", example = "20")
    @Min(value = 1, message = "每页数量最小为1")
    @Max(value = 100, message = "每页数量最大为100")
    private Integer limit = 20;
    
    @ApiModelProperty(value = "商家ID")
    private Integer merId;
    
    @ApiModelProperty(value = "商品名称关键词")
    private String keyword;
    
    @ApiModelProperty(value = "分类ID")
    private Integer categoryId;
    
    @ApiModelProperty(value = "上架状态：true-已上架，false-已下架")
    private Boolean isShow;
    
    @ApiModelProperty(value = "审核状态：0-待审核，1-审核通过，2-审核拒绝")
    private Integer auditStatus;
}
```

**响应数据**:
```java
// 与ProductAuditListVO类似
public class PlatformProductListVO {
    // 字段同ProductAuditListVO
}
```

---

### 4.2 强制下架商品

**接口地址**: `PUT /api/platform/product/force-off-sale/{id}`

**接口描述**: 强制下架商品

**请求头**:
```
Authorization: Bearer {token}
```

**路径参数**:
- `id`: 商品ID

**请求参数**:
```java
public class ForceOffSaleRequest {
    @ApiModelProperty(value = "下架原因", required = true)
    @NotBlank(message = "下架原因不能为空")
    @Length(max = 500, message = "下架原因长度不能超过500")
    private String reason;
}
```

**响应数据**:
```java
// 返回 CommonResult<String>
{
    "code": 200,
    "message": "下架成功",
    "data": null,
    "timestamp": 1715999999999
}
```

**业务逻辑**:
1. 更新商品状态为下架（is_show = false）
2. 记录下架原因
3. 发送站内消息通知商家

---

## 5. 翻译成本统计接口

### 5.1 翻译成本统计

**接口地址**: `GET /api/platform/translation/cost-statistics`

**接口描述**: 获取翻译成本统计数据

**请求头**:
```
Authorization: Bearer {token}
```

**请求参数**:
```java
public class TranslationCostStatisticsRequest {
    @ApiModelProperty(value = "开始时间")
    private Date startTime;
    
    @ApiModelProperty(value = "结束时间")
    private Date endTime;
    
    @ApiModelProperty(value = "商家ID")
    private Integer merId;
}
```

**响应数据**:
```java
public class TranslationCostStatisticsVO {
    @ApiModelProperty(value = "总成本（元）")
    private BigDecimal totalCost;
    
    @ApiModelProperty(value = "总Token数")
    private Integer totalTokens;
    
    @ApiModelProperty(value = "总翻译次数")
    private Integer totalCount;
    
    @ApiModelProperty(value = "按类型统计成本")
    private Map<String, BigDecimal> costByType;
    
    @ApiModelProperty(value = "按翻译类型统计成本")
    private Map<String, BigDecimal> costByTranslationType;
    
    @ApiModelProperty(value = "按商家统计成本（Top 10）")
    private List<MerchantCostStatVO> topMerchants;
    
    @ApiModelProperty(value = "按日期统计成本（最近30天）")
    private List<DateCostStatVO> dailyStats;
}

public class MerchantCostStatVO {
    @ApiModelProperty(value = "商家ID")
    private Integer merId;
    
    @ApiModelProperty(value = "商家名称")
    private String merName;
    
    @ApiModelProperty(value = "翻译成本（元）")
    private BigDecimal cost;
    
    @ApiModelProperty(value = "翻译次数")
    private Integer count;
}

public class DateCostStatVO {
    @ApiModelProperty(value = "日期")
    private String date;
    
    @ApiModelProperty(value = "翻译成本（元）")
    private BigDecimal cost;
    
    @ApiModelProperty(value = "翻译次数")
    private Integer count;
}
```

---

### 5.2 翻译缓存统计

**接口地址**: `GET /api/platform/translation/cache-statistics`

**接口描述**: 获取翻译缓存命中率统计

**请求头**:
```
Authorization: Bearer {token}
```

**请求参数**:
```java
public class TranslationCacheStatisticsRequest {
    @ApiModelProperty(value = "开始时间")
    private Date startTime;
    
    @ApiModelProperty(value = "结束时间")
    private Date endTime;
}
```

**响应数据**:
```java
public class TranslationCacheStatisticsVO {
    @ApiModelProperty(value = "总翻译次数")
    private Integer totalTranslations;
    
    @ApiModelProperty(value = "缓存命中次数")
    private Integer cachedTranslations;
    
    @ApiModelProperty(value = "缓存命中率（%）")
    private BigDecimal hitRate;
    
    @ApiModelProperty(value = "节省成本（元）")
    private BigDecimal savedCost;
}
```

---

## 平台端接口总结

### 接口列表

1. **平台管理员登录** (1个接口)
   - POST /api/platform/auth/login - 平台管理员登录

2. **询价管理** (4个接口)
   - GET /api/platform/inquiry/list - 询价单列表
   - GET /api/platform/inquiry/detail/{inquiryNo} - 询价单详情
   - PUT /api/platform/inquiry/update-status/{inquiryNo} - 更新询价单状态
   - GET /api/platform/inquiry/statistics - 询价统计

3. **商品审核** (3个接口)
   - GET /api/platform/product/audit-list - 待审核商品列表
   - GET /api/platform/product/audit-detail/{id} - 商品审核详情
   - PUT /api/platform/product/audit/{id} - 审核商品

4. **商品管理** (2个接口)
   - GET /api/platform/product/list - 所有商品列表
   - PUT /api/platform/product/force-off-sale/{id} - 强制下架商品

5. **翻译成本统计** (2个接口)
   - GET /api/platform/translation/cost-statistics - 翻译成本统计
   - GET /api/platform/translation/cache-statistics - 翻译缓存统计

**总计**: 12个接口
