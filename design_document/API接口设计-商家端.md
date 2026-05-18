# API接口设计 - 商家端接口

## 设计原则

1. **RESTful风格** - 遵循REST API设计规范
2. **仅中文** - 商家端永远显示中文，不需要多语言支持
3. **统一响应格式** - 使用CommonResult包装所有响应
4. **权限控制** - 所有接口需要商家登录，只能操作自己的数据
5. **分页查询** - 列表接口统一使用PageInfo分页

---

## 1. 商家登录相关接口

### 1.1 商家登录

**接口地址**: `POST /api/merchant/auth/login`

**接口描述**: 商家登录

**请求参数**:
```java
public class MerchantLoginRequest {
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
public class MerchantLoginVO {
    @ApiModelProperty(value = "商家ID")
    private Integer merId;
    
    @ApiModelProperty(value = "商家名称")
    private String merName;
    
    @ApiModelProperty(value = "账号")
    private String account;
    
    @ApiModelProperty(value = "Token")
    private String token;
    
    @ApiModelProperty(value = "Token过期时间")
    private Date tokenExpireTime;
}
```

---

## 2. 商品管理接口

### 2.1 商品列表

**接口地址**: `GET /api/merchant/product/list`

**接口描述**: 获取商家的商品列表

**请求头**:
```
Authorization: Bearer {token}
```

**请求参数**:
```java
public class MerchantProductListRequest {
    @ApiModelProperty(value = "页码", example = "1")
    @Min(value = 1, message = "页码最小为1")
    private Integer page = 1;
    
    @ApiModelProperty(value = "每页数量", example = "20")
    @Min(value = 1, message = "每页数量最小为1")
    @Max(value = 100, message = "每页数量最大为100")
    private Integer limit = 20;
    
    @ApiModelProperty(value = "商品名称关键词")
    private String keyword;
    
    @ApiModelProperty(value = "分类ID")
    private Integer categoryId;
    
    @ApiModelProperty(value = "上架状态：true-已上架，false-已下架")
    private Boolean isShow;
    
    @ApiModelProperty(value = "审核状态：0-待审核，1-审核通过，2-审核拒绝")
    private Integer auditStatus;
    
    @ApiModelProperty(value = "翻译状态：0-未翻译，1-翻译中，2-翻译完成，3-翻译失败")
    private Integer translationStatus;
}
```

**响应数据**:
```java
public class MerchantProductListVO {
    @ApiModelProperty(value = "商品ID")
    private Integer id;
    
    @ApiModelProperty(value = "商品名称")
    private String storeName;
    
    @ApiModelProperty(value = "商品主图")
    private String image;
    
    @ApiModelProperty(value = "分类名称")
    private String categoryName;
    
    @ApiModelProperty(value = "人民币价格")
    private BigDecimal price;
    
    @ApiModelProperty(value = "美元价格")
    private BigDecimal priceUsd;
    
    @ApiModelProperty(value = "上架状态：true-已上架，false-已下架")
    private Boolean isShow;
    
    @ApiModelProperty(value = "审核状态：0-待审核，1-审核通过，2-审核拒绝")
    private Integer auditStatus;
    
    @ApiModelProperty(value = "审核状态文本")
    private String auditStatusText;
    
    @ApiModelProperty(value = "翻译状态：0-未翻译，1-翻译中，2-翻译完成，3-翻译失败")
    private Integer translationStatus;
    
    @ApiModelProperty(value = "翻译状态文本")
    private String translationStatusText;
    
    @ApiModelProperty(value = "翻译进度：0-100")
    private Integer translationProgress;
    
    @ApiModelProperty(value = "排序")
    private Integer sort;
    
    @ApiModelProperty(value = "创建时间")
    private Date createTime;
}
```

---

### 2.2 商品详情

**接口地址**: `GET /api/merchant/product/detail/{id}`

**接口描述**: 获取商品详细信息

**请求头**:
```
Authorization: Bearer {token}
```

**路径参数**:
- `id`: 商品ID

**响应数据**:
```java
public class MerchantProductDetailVO {
    @ApiModelProperty(value = "商品ID")
    private Integer id;
    
    @ApiModelProperty(value = "商品名称")
    private String storeName;
    
    @ApiModelProperty(value = "商品简介")
    private String storeInfo;
    
    @ApiModelProperty(value = "商品关键词")
    private String keyword;
    
    @ApiModelProperty(value = "轮播图列表")
    private List<String> sliderImages;
    
    @ApiModelProperty(value = "详情图列表")
    private List<String> detailImages;
    
    @ApiModelProperty(value = "商品详情HTML")
    private String description;
    
    @ApiModelProperty(value = "人民币价格")
    private BigDecimal price;
    
    @ApiModelProperty(value = "美元价格")
    private BigDecimal priceUsd;
    
    @ApiModelProperty(value = "人民币原价")
    private BigDecimal otPrice;
    
    @ApiModelProperty(value = "美元原价")
    private BigDecimal otPriceUsd;
    
    @ApiModelProperty(value = "分类ID")
    private Integer categoryId;
    
    @ApiModelProperty(value = "分类名称")
    private String categoryName;
    
    @ApiModelProperty(value = "排序")
    private Integer sort;
    
    @ApiModelProperty(value = "上架状态")
    private Boolean isShow;
    
    @ApiModelProperty(value = "审核状态")
    private Integer auditStatus;
    
    @ApiModelProperty(value = "审核备注")
    private String auditRemark;
    
    @ApiModelProperty(value = "翻译状态")
    private Integer translationStatus;
    
    @ApiModelProperty(value = "翻译进度")
    private Integer translationProgress;
    
    @ApiModelProperty(value = "翻译错误信息")
    private String translationError;
    
    @ApiModelProperty(value = "创建时间")
    private Date createTime;
    
    @ApiModelProperty(value = "更新时间")
    private Date updateTime;
}
```

---

### 2.3 添加商品

**接口地址**: `POST /api/merchant/product/add`

**接口描述**: 添加商品（仅保存，不上架）

**请求头**:
```
Authorization: Bearer {token}
```

**请求参数**:
```java
public class ProductAddRequest {
    @ApiModelProperty(value = "商品名称", required = true)
    @NotBlank(message = "商品名称不能为空")
    @Length(max = 200, message = "商品名称长度不能超过200")
    private String storeName;
    
    @ApiModelProperty(value = "商品简介", required = true)
    @NotBlank(message = "商品简介不能为空")
    @Length(max = 500, message = "商品简介长度不能超过500")
    private String storeInfo;
    
    @ApiModelProperty(value = "商品关键词")
    @Length(max = 200, message = "商品关键词长度不能超过200")
    private String keyword;
    
    @ApiModelProperty(value = "轮播图URL列表（逗号分隔）", required = true)
    @NotBlank(message = "轮播图不能为空")
    private String sliderImage;
    
    @ApiModelProperty(value = "详情图URL列表（逗号分隔）")
    private String detailImages;
    
    @ApiModelProperty(value = "商品详情HTML")
    private String description;
    
    @ApiModelProperty(value = "人民币价格", required = true)
    @NotNull(message = "人民币价格不能为空")
    @DecimalMin(value = "0.01", message = "价格最小为0.01")
    private BigDecimal price;
    
    @ApiModelProperty(value = "美元价格", required = true)
    @NotNull(message = "美元价格不能为空")
    @DecimalMin(value = "0.01", message = "价格最小为0.01")
    private BigDecimal priceUsd;
    
    @ApiModelProperty(value = "人民币原价")
    @DecimalMin(value = "0.00", message = "原价不能为负数")
    private BigDecimal otPrice;
    
    @ApiModelProperty(value = "美元原价")
    @DecimalMin(value = "0.00", message = "原价不能为负数")
    private BigDecimal otPriceUsd;
    
    @ApiModelProperty(value = "分类ID", required = true)
    @NotNull(message = "分类ID不能为空")
    private Integer categoryId;
    
    @ApiModelProperty(value = "排序", example = "0")
    private Integer sort = 0;
}
```

**响应数据**:
```java
public class ProductAddVO {
    @ApiModelProperty(value = "商品ID")
    private Integer productId;
}
```

---

### 2.4 编辑商品

**接口地址**: `PUT /api/merchant/product/update/{id}`

**接口描述**: 编辑商品（只能编辑已下架的商品）

**请求头**:
```
Authorization: Bearer {token}
```

**路径参数**:
- `id`: 商品ID

**请求参数**:
```java
// 与ProductAddRequest相同
public class ProductUpdateRequest {
    // 字段同ProductAddRequest
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

**业务逻辑**:
1. 检查商品是否属于当前商家
2. 检查商品是否已下架（is_show = false）
3. 如果商品已上架，返回错误提示"请先下架商品再编辑"
4. 更新商品信息
5. 重置翻译状态为"未翻译"
6. 重置审核状态为null

---

### 2.5 上架商品

**接口地址**: `PUT /api/merchant/product/on-sale/{id}`

**接口描述**: 上架商品（触发翻译）

**请求头**:
```
Authorization: Bearer {token}
```

**路径参数**:
- `id`: 商品ID

**响应数据**:
```java
// 返回 CommonResult<String>
{
    "code": 200,
    "message": "商品已提交翻译，翻译完成后将自动提交审核",
    "data": null,
    "timestamp": 1715999999999
}
```

**业务逻辑**:
1. 检查商品是否属于当前商家
2. 检查商品是否已下架
3. 更新翻译状态为"翻译中"
4. 触发异步翻译任务
5. 翻译完成后自动提交审核

---

### 2.6 下架商品

**接口地址**: `PUT /api/merchant/product/off-sale/{id}`

**接口描述**: 下架商品

**请求头**:
```
Authorization: Bearer {token}
```

**路径参数**:
- `id`: 商品ID

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

---

### 2.7 删除商品

**接口地址**: `DELETE /api/merchant/product/delete/{id}`

**接口描述**: 删除商品（软删除，只能删除已下架的商品）

**请求头**:
```
Authorization: Bearer {token}
```

**路径参数**:
- `id`: 商品ID

**响应数据**:
```java
// 返回 CommonResult<String>
{
    "code": 200,
    "message": "删除成功",
    "data": null,
    "timestamp": 1715999999999
}
```

**业务逻辑**:
1. 检查商品是否属于当前商家
2. 检查商品是否已下架
3. 如果商品已上架，返回错误提示"请先下架商品再删除"
4. 软删除商品（is_del = true）

---

### 2.8 重新翻译

**接口地址**: `PUT /api/merchant/product/retry-translation/{id}`

**接口描述**: 重新翻译商品（翻译失败时使用）

**请求头**:
```
Authorization: Bearer {token}
```

**路径参数**:
- `id`: 商品ID

**响应数据**:
```java
// 返回 CommonResult<String>
{
    "code": 200,
    "message": "已重新提交翻译",
    "data": null,
    "timestamp": 1715999999999
}
```

**业务逻辑**:
1. 检查商品是否属于当前商家
2. 检查翻译状态是否为"翻译失败"
3. 检查重试次数（最多3次）
4. 重置翻译状态为"翻译中"
5. 触发异步翻译任务

---

### 2.9 查询翻译进度

**接口地址**: `GET /api/merchant/product/translation-progress/{id}`

**接口描述**: 查询商品翻译进度

**请求头**:
```
Authorization: Bearer {token}
```

**路径参数**:
- `id`: 商品ID

**响应数据**:
```java
public class TranslationProgressVO {
    @ApiModelProperty(value = "商品ID")
    private Integer productId;
    
    @ApiModelProperty(value = "翻译状态：0-未翻译，1-翻译中，2-翻译完成，3-翻译失败")
    private Integer translationStatus;
    
    @ApiModelProperty(value = "翻译状态文本")
    private String translationStatusText;
    
    @ApiModelProperty(value = "翻译进度：0-100")
    private Integer translationProgress;
    
    @ApiModelProperty(value = "翻译错误信息")
    private String translationError;
    
    @ApiModelProperty(value = "最后翻译时间")
    private Date lastTranslationTime;
    
    @ApiModelProperty(value = "异步任务状态：running-运行中，success-成功，failed-失败")
    private String taskStatus;
    
    @ApiModelProperty(value = "任务开始时间")
    private Long taskStartTime;
    
    @ApiModelProperty(value = "任务结束时间")
    private Long taskEndTime;
}
```

---

## 3. 分类相关接口

### 3.1 分类列表

**接口地址**: `GET /api/merchant/category/list`

**接口描述**: 获取商品分类列表（树形结构，仅平台分类）

**请求头**:
```
Authorization: Bearer {token}
```

**响应数据**:
```java
public class CategoryTreeVO {
    @ApiModelProperty(value = "分类ID")
    private Integer id;
    
    @ApiModelProperty(value = "父级ID")
    private Integer pid;
    
    @ApiModelProperty(value = "分类名称")
    private String name;
    
    @ApiModelProperty(value = "分类图标")
    private String icon;
    
    @ApiModelProperty(value = "分类级别")
    private Integer level;
    
    @ApiModelProperty(value = "排序")
    private Integer sort;
    
    @ApiModelProperty(value = "子分类列表")
    private List<CategoryTreeVO> children;
}
```

---

## 4. 商家信息接口

### 4.1 获取商家信息

**接口地址**: `GET /api/merchant/info`

**接口描述**: 获取当前商家信息

**请求头**:
```
Authorization: Bearer {token}
```

**响应数据**:
```java
public class MerchantInfoVO {
    @ApiModelProperty(value = "商家ID")
    private Integer merId;
    
    @ApiModelProperty(value = "商家名称")
    private String merName;
    
    @ApiModelProperty(value = "商家账号")
    private String account;
    
    @ApiModelProperty(value = "联系人")
    private String linkman;
    
    @ApiModelProperty(value = "联系电话")
    private String phone;
    
    @ApiModelProperty(value = "商家状态：true-正常，false-禁用")
    private Boolean status;
    
    @ApiModelProperty(value = "创建时间")
    private Date createTime;
}
```

---

## 商家端接口总结

### 接口列表

1. **商家登录相关** (1个接口)
   - POST /api/merchant/auth/login - 商家登录

2. **商品管理** (9个接口)
   - GET /api/merchant/product/list - 商品列表
   - GET /api/merchant/product/detail/{id} - 商品详情
   - POST /api/merchant/product/add - 添加商品
   - PUT /api/merchant/product/update/{id} - 编辑商品
   - PUT /api/merchant/product/on-sale/{id} - 上架商品
   - PUT /api/merchant/product/off-sale/{id} - 下架商品
   - DELETE /api/merchant/product/delete/{id} - 删除商品
   - PUT /api/merchant/product/retry-translation/{id} - 重新翻译
   - GET /api/merchant/product/translation-progress/{id} - 查询翻译进度

3. **分类相关** (1个接口)
   - GET /api/merchant/category/list - 分类列表

4. **商家信息** (1个接口)
   - GET /api/merchant/info - 获取商家信息

**总计**: 12个接口
