# API接口设计 - 补充接口（高优先级）

## 1. 通用接口

### 1.1 图片上传

**接口地址**: `POST /api/common/upload/image`

**接口描述**: 上传图片到阿里云OSS（C端、商家端、平台端通用）

**请求头**:
```
Authorization: Bearer {token}  (商家端和平台端需要)
Content-Type: multipart/form-data
```

**请求参数**:
```java
public class ImageUploadRequest {
    @ApiModelProperty(value = "图片文件", required = true)
    @NotNull(message = "图片文件不能为空")
    private MultipartFile file;
    
    @ApiModelProperty(value = "上传类型：product-商品图片，avatar-头像，other-其他")
    @NotBlank(message = "上传类型不能为空")
    @Pattern(regexp = "product|avatar|other", message = "上传类型只能是product、avatar或other")
    private String uploadType;
}
```

**响应数据**:
```java
public class ImageUploadVO {
    @ApiModelProperty(value = "图片URL")
    private String imageUrl;
    
    @ApiModelProperty(value = "图片大小（字节）")
    private Long fileSize;
    
    @ApiModelProperty(value = "图片宽度")
    private Integer width;
    
    @ApiModelProperty(value = "图片高度")
    private Integer height;
}
```

**响应示例**:
```json
{
    "code": 200,
    "message": "上传成功",
    "data": {
        "imageUrl": "https://oss.example.com/product/zh/20260518/abc123.jpg",
        "fileSize": 102400,
        "width": 800,
        "height": 600
    },
    "timestamp": 1715999999999
}
```

**业务逻辑**:
1. 验证文件类型（只允许jpg、jpeg、png、gif）
2. 验证文件大小（最大5MB）
3. 生成唯一文件名（使用UUID）
4. 上传到阿里云OSS（根据uploadType分目录存储）
5. 返回图片URL和基本信息

**参考现有代码**:
- 查找现有的文件上传Service（可能是FileService或UploadService）
- 复用现有的OSS配置和上传逻辑
- 保持与现有上传接口的一致性

---

## 2. 平台端分类管理接口

### 2.1 分类列表（管理用）

**接口地址**: `GET /api/platform/category/list`

**接口描述**: 获取商品分类列表（树形结构，包含已删除的分类）

**请求头**:
```
Authorization: Bearer {token}
```

**请求参数**:
```java
public class PlatformCategoryListRequest {
    @ApiModelProperty(value = "分类名称关键词")
    private String keyword;
    
    @ApiModelProperty(value = "显示状态：true-显示，false-隐藏")
    private Boolean isShow;
    
    @ApiModelProperty(value = "是否包含已删除：true-包含，false-不包含")
    private Boolean includeDel = false;
}
```

**响应数据**:
```java
public class PlatformCategoryTreeVO {
    @ApiModelProperty(value = "分类ID")
    private Integer id;
    
    @ApiModelProperty(value = "父级ID")
    private Integer pid;
    
    @ApiModelProperty(value = "分类名称-中文")
    private String name;
    
    @ApiModelProperty(value = "分类名称-英文")
    private String nameEn;
    
    @ApiModelProperty(value = "分类名称-俄语")
    private String nameRu;
    
    @ApiModelProperty(value = "分类名称-阿拉伯语")
    private String nameAr;
    
    @ApiModelProperty(value = "分类图标")
    private String icon;
    
    @ApiModelProperty(value = "分类级别")
    private Integer level;
    
    @ApiModelProperty(value = "排序")
    private Integer sort;
    
    @ApiModelProperty(value = "显示状态")
    private Boolean isShow;
    
    @ApiModelProperty(value = "是否删除")
    private Boolean isDel;
    
    @ApiModelProperty(value = "翻译状态")
    private Integer translationStatus;
    
    @ApiModelProperty(value = "创建时间")
    private Date createTime;
    
    @ApiModelProperty(value = "更新时间")
    private Date updateTime;
    
    @ApiModelProperty(value = "子分类列表")
    private List<PlatformCategoryTreeVO> children;
}
```

**参考现有代码**:
- 查找现有的CategoryService
- 复用现有的分类树构建逻辑
- 扩展查询条件（翻译状态、多语言字段）

---

### 2.2 添加分类

**接口地址**: `POST /api/platform/category/add`

**接口描述**: 添加商品分类

**请求头**:
```
Authorization: Bearer {token}
```

**请求参数**:
```java
public class CategoryAddRequest {
    @ApiModelProperty(value = "父级ID（0表示顶级分类）", required = true)
    @NotNull(message = "父级ID不能为空")
    @Min(value = 0, message = "父级ID最小为0")
    private Integer pid;
    
    @ApiModelProperty(value = "分类名称", required = true)
    @NotBlank(message = "分类名称不能为空")
    @Length(max = 200, message = "分类名称长度不能超过200")
    private String name;
    
    @ApiModelProperty(value = "分类图标")
    @Length(max = 500, message = "分类图标长度不能超过500")
    private String icon;
    
    @ApiModelProperty(value = "排序", example = "0")
    @Min(value = 0, message = "排序最小为0")
    private Integer sort = 0;
    
    @ApiModelProperty(value = "显示状态", example = "true")
    private Boolean isShow = true;
}
```

**响应数据**:
```java
public class CategoryAddVO {
    @ApiModelProperty(value = "分类ID")
    private Integer categoryId;
}
```

**业务逻辑**:
1. 验证父级分类是否存在（如果pid > 0）
2. 计算分类级别（level = 父级level + 1）
3. 保存分类信息
4. 触发异步翻译（翻译分类名称）
5. 返回分类ID

**参考现有代码**:
- 查找现有的CategoryService.save()方法
- 复用现有的分类级别计算逻辑
- 集成翻译服务

---

### 2.3 更新分类

**接口地址**: `PUT /api/platform/category/update/{id}`

**接口描述**: 更新商品分类

**请求头**:
```
Authorization: Bearer {token}
```

**路径参数**:
- `id`: 分类ID

**请求参数**:
```java
public class CategoryUpdateRequest {
    @ApiModelProperty(value = "分类名称", required = true)
    @NotBlank(message = "分类名称不能为空")
    @Length(max = 200, message = "分类名称长度不能超过200")
    private String name;
    
    @ApiModelProperty(value = "分类图标")
    @Length(max = 500, message = "分类图标长度不能超过500")
    private String icon;
    
    @ApiModelProperty(value = "排序", example = "0")
    @Min(value = 0, message = "排序最小为0")
    private Integer sort;
    
    @ApiModelProperty(value = "显示状态", example = "true")
    private Boolean isShow;
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
1. 检查分类是否存在
2. 检查分类名称是否修改
3. 更新分类信息
4. 如果名称修改，触发异步翻译
5. 清除分类缓存

**参考现有代码**:
- 查找现有的CategoryService.updateById()方法
- 复用现有的更新逻辑
- 集成翻译服务

---

### 2.4 删除分类

**接口地址**: `DELETE /api/platform/category/delete/{id}`

**接口描述**: 删除商品分类（软删除）

**请求头**:
```
Authorization: Bearer {token}
```

**路径参数**:
- `id`: 分类ID

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
1. 检查分类是否存在
2. 检查是否有子分类（有子分类不允许删除）
3. 检查是否有商品使用该分类（有商品不允许删除）
4. 软删除分类（is_del = true）
5. 清除分类缓存

**参考现有代码**:
- 查找现有的CategoryService.removeById()方法
- 复用现有的删除逻辑
- 添加子分类和商品检查

---

## 3. 平台端商家管理接口

### 3.1 商家列表

**接口地址**: `GET /api/platform/merchant/list`

**接口描述**: 获取商家列表

**请求头**:
```
Authorization: Bearer {token}
```

**请求参数**:
```java
public class PlatformMerchantListRequest {
    @ApiModelProperty(value = "页码", example = "1")
    @Min(value = 1, message = "页码最小为1")
    private Integer page = 1;
    
    @ApiModelProperty(value = "每页数量", example = "20")
    @Min(value = 1, message = "每页数量最小为1")
    @Max(value = 100, message = "每页数量最大为100")
    private Integer limit = 20;
    
    @ApiModelProperty(value = "商家名称关键词")
    private String keyword;
    
    @ApiModelProperty(value = "商家状态：true-正常，false-禁用")
    private Boolean status;
}
```

**响应数据**:
```java
public class PlatformMerchantListVO {
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
    
    @ApiModelProperty(value = "商品总数")
    private Integer productCount;
    
    @ApiModelProperty(value = "上架商品数")
    private Integer onSaleProductCount;
    
    @ApiModelProperty(value = "创建时间")
    private Date createTime;
}
```

**参考现有代码**:
- 查找现有的MerchantService或SystemAdminService
- 复用现有的商家查询逻辑
- 添加商品统计查询

---

### 3.2 商家详情

**接口地址**: `GET /api/platform/merchant/detail/{id}`

**接口描述**: 获取商家详细信息

**请求头**:
```
Authorization: Bearer {token}
```

**路径参数**:
- `id`: 商家ID

**响应数据**:
```java
public class PlatformMerchantDetailVO {
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
    
    @ApiModelProperty(value = "商家地址")
    private String address;
    
    @ApiModelProperty(value = "商家状态：true-正常，false-禁用")
    private Boolean status;
    
    @ApiModelProperty(value = "商品总数")
    private Integer productCount;
    
    @ApiModelProperty(value = "上架商品数")
    private Integer onSaleProductCount;
    
    @ApiModelProperty(value = "待审核商品数")
    private Integer auditPendingCount;
    
    @ApiModelProperty(value = "创建时间")
    private Date createTime;
    
    @ApiModelProperty(value = "更新时间")
    private Date updateTime;
}
```

**参考现有代码**:
- 查找现有的MerchantService.getById()方法
- 添加商品统计查询

---

### 3.3 更新商家状态

**接口地址**: `PUT /api/platform/merchant/update-status/{id}`

**接口描述**: 启用/禁用商家

**请求头**:
```
Authorization: Bearer {token}
```

**路径参数**:
- `id`: 商家ID

**请求参数**:
```java
public class MerchantUpdateStatusRequest {
    @ApiModelProperty(value = "商家状态：true-正常，false-禁用", required = true)
    @NotNull(message = "商家状态不能为空")
    private Boolean status;
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
1. 检查商家是否存在
2. 更新商家状态
3. 如果禁用商家，同时下架该商家的所有商品
4. 发送站内消息通知商家

**参考现有代码**:
- 查找现有的MerchantService.updateById()方法
- 添加商品批量下架逻辑

---

### 3.4 添加商家

**接口地址**: `POST /api/platform/merchant/add`

**接口描述**: 添加商家

**请求头**:
```
Authorization: Bearer {token}
```

**请求参数**:
```java
public class MerchantAddRequest {
    @ApiModelProperty(value = "商家名称", required = true)
    @NotBlank(message = "商家名称不能为空")
    @Length(max = 100, message = "商家名称长度不能超过100")
    private String merName;
    
    @ApiModelProperty(value = "商家账号", required = true)
    @NotBlank(message = "商家账号不能为空")
    @Length(min = 3, max = 20, message = "商家账号长度为3-20个字符")
    @Pattern(regexp = "^[a-zA-Z0-9_]+$", message = "商家账号只能包含字母、数字、下划线")
    private String account;
    
    @ApiModelProperty(value = "密码", required = true)
    @NotBlank(message = "密码不能为空")
    @Length(min = 6, max = 20, message = "密码长度为6-20个字符")
    private String password;
    
    @ApiModelProperty(value = "联系人", required = true)
    @NotBlank(message = "联系人不能为空")
    @Length(max = 50, message = "联系人长度不能超过50")
    private String linkman;
    
    @ApiModelProperty(value = "联系电话", required = true)
    @NotBlank(message = "联系电话不能为空")
    @Length(max = 20, message = "联系电话长度不能超过20")
    private String phone;
    
    @ApiModelProperty(value = "商家地址")
    @Length(max = 200, message = "商家地址长度不能超过200")
    private String address;
}
```

**响应数据**:
```java
public class MerchantAddVO {
    @ApiModelProperty(value = "商家ID")
    private Integer merId;
}
```

**业务逻辑**:
1. 检查账号是否已存在
2. 密码加密（使用BCrypt）
3. 创建商家记录（eb_merchant表）
4. 创建商家管理员账号（eb_system_admin表，type=商家类型）
5. 返回商家ID

**参考现有代码**:
- 查找现有的MerchantService.save()方法
- 查找现有的SystemAdminService.save()方法
- 复用现有的密码加密逻辑
- 保持与现有商家创建流程一致

---

## 参考现有代码的重要提示

在实现这些接口时，需要：

1. **查找现有Service**
   - CategoryService
   - MerchantService
   - SystemAdminService
   - FileService/UploadService

2. **复用现有逻辑**
   - 分类树构建
   - 密码加密
   - 文件上传
   - 缓存管理

3. **保持一致性**
   - 命名规范
   - 异常处理
   - 日志记录
   - 事务管理

4. **遵循阿里规范**
   - 方法命名
   - 参数校验
   - 返回值处理
   - 注释规范
