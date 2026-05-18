# API接口设计 - C端接口（续）

## 4. 询价相关接口

### 4.1 提交询价单

**接口地址**: `POST /api/front/inquiry/submit`

**接口描述**: 提交询价单（游客和登录用户都可以）

**请求头**:
```
Accept-Language: zh/en/ru/ar
Authorization: Bearer {token}  (可选，登录用户需要)
```

**请求参数**:
```java
public class InquirySubmitRequest {
    @ApiModelProperty(value = "询价类型：single-单商品询价，cart-意向清单询价", required = true)
    @NotBlank(message = "询价类型不能为空")
    @Pattern(regexp = "single|cart", message = "询价类型只能是single或cart")
    private String inquiryType;
    
    @ApiModelProperty(value = "商品ID（单商品询价时必填）")
    private Integer productId;
    
    @ApiModelProperty(value = "数量（单商品询价时必填）")
    @Min(value = 1, message = "数量最小为1")
    private Integer quantity;
    
    @ApiModelProperty(value = "意向清单ID列表（意向清单询价时必填）")
    private List<Integer> cartIds;
    
    @ApiModelProperty(value = "联系人姓名", required = true)
    @NotBlank(message = "联系人姓名不能为空")
    @Length(max = 50, message = "联系人姓名长度不能超过50")
    private String realName;
    
    @ApiModelProperty(value = "联系电话", required = true)
    @NotBlank(message = "联系电话不能为空")
    @Length(max = 20, message = "联系电话长度不能超过20")
    private String userPhone;
    
    @ApiModelProperty(value = "联系邮箱", required = true)
    @NotBlank(message = "联系邮箱不能为空")
    @Email(message = "邮箱格式不正确")
    @Length(max = 100, message = "邮箱长度不能超过100")
    private String userEmail;
    
    @ApiModelProperty(value = "国家", required = true)
    @NotBlank(message = "国家不能为空")
    @Length(max = 50, message = "国家长度不能超过50")
    private String country;
    
    @ApiModelProperty(value = "详细地址", required = true)
    @NotBlank(message = "详细地址不能为空")
    @Length(max = 500, message = "详细地址长度不能超过500")
    private String userAddress;
    
    @ApiModelProperty(value = "备注")
    @Length(max = 500, message = "备注长度不能超过500")
    private String userRemark;
}
```

**响应数据**:
```java
public class InquirySubmitVO {
    @ApiModelProperty(value = "询价单号")
    private String inquiryNo;
    
    @ApiModelProperty(value = "提交时间")
    private Date createTime;
}
```

**响应示例**:
```json
{
    "code": 200,
    "message": "询价提交成功",
    "data": {
        "inquiryNo": "INQ202605180001",
        "createTime": "2026-05-18 13:30:00"
    },
    "timestamp": 1715999999999
}
```

**业务逻辑**:
1. 验证商品是否存在且已上架
2. 如果是登录用户，保存uid；如果是游客，uid为null
3. 将用户填写的信息翻译成中文（如果用户语言不是中文）
4. 保存询价单主表（中文 + 原文）
5. 保存询价单详情（商品快照，中文 + 用户语言）
6. 如果是意向清单询价，询价成功后删除对应的意向清单记录
7. 发送邮件通知平台端

---

### 4.2 我的询价单列表

**接口地址**: `GET /api/front/inquiry/my-list`

**接口描述**: 获取当前用户的询价单列表（需要登录）

**请求头**:
```
Accept-Language: zh/en/ru/ar
Authorization: Bearer {token}
```

**请求参数**:
```java
public class InquiryListRequest {
    @ApiModelProperty(value = "页码", example = "1")
    @Min(value = 1, message = "页码最小为1")
    private Integer page = 1;
    
    @ApiModelProperty(value = "每页数量", example = "10")
    @Min(value = 1, message = "每页数量最小为1")
    @Max(value = 50, message = "每页数量最大为50")
    private Integer limit = 10;
    
    @ApiModelProperty(value = "询价状态：0-待处理，1-已处理，2-已废弃")
    private Integer inquiryStatus;
}
```

**响应数据**:
```java
public class InquiryListVO {
    @ApiModelProperty(value = "询价单号")
    private String inquiryNo;
    
    @ApiModelProperty(value = "询价状态：0-待处理，1-已处理，2-已废弃")
    private Integer inquiryStatus;
    
    @ApiModelProperty(value = "询价状态文本（根据语言返回）")
    private String inquiryStatusText;
    
    @ApiModelProperty(value = "商品总数")
    private Integer totalNum;
    
    @ApiModelProperty(value = "联系人姓名（原始语言）")
    private String realName;
    
    @ApiModelProperty(value = "联系电话（原始语言）")
    private String userPhone;
    
    @ApiModelProperty(value = "国家（原始语言）")
    private String country;
    
    @ApiModelProperty(value = "提交时间")
    private Date createTime;
    
    @ApiModelProperty(value = "处理时间")
    private Date processTime;
}
```

**响应示例**:
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "pageNum": 1,
        "pageSize": 10,
        "total": 5,
        "list": [
            {
                "inquiryNo": "INQ202605180001",
                "inquiryStatus": 0,
                "inquiryStatusText": "Pending",
                "totalNum": 3,
                "realName": "John Doe",
                "userPhone": "+1234567890",
                "country": "United States",
                "createTime": "2026-05-18 13:30:00",
                "processTime": null
            }
        ]
    },
    "timestamp": 1715999999999
}
```

---

### 4.3 询价单详情

**接口地址**: `GET /api/front/inquiry/detail/{inquiryNo}`

**接口描述**: 获取询价单详细信息（需要登录，只能查看自己的询价单）

**请求头**:
```
Accept-Language: zh/en/ru/ar
Authorization: Bearer {token}
```

**路径参数**:
- `inquiryNo`: 询价单号

**响应数据**:
```java
public class InquiryDetailVO {
    @ApiModelProperty(value = "询价单号")
    private String inquiryNo;
    
    @ApiModelProperty(value = "询价状态：0-待处理，1-已处理，2-已废弃")
    private Integer inquiryStatus;
    
    @ApiModelProperty(value = "询价状态文本（根据语言返回）")
    private String inquiryStatusText;
    
    @ApiModelProperty(value = "联系人姓名（原始语言）")
    private String realName;
    
    @ApiModelProperty(value = "联系电话（原始语言）")
    private String userPhone;
    
    @ApiModelProperty(value = "联系邮箱（原始语言）")
    private String userEmail;
    
    @ApiModelProperty(value = "国家（原始语言）")
    private String country;
    
    @ApiModelProperty(value = "详细地址（原始语言）")
    private String userAddress;
    
    @ApiModelProperty(value = "备注（原始语言）")
    private String userRemark;
    
    @ApiModelProperty(value = "商品列表")
    private List<InquiryItemVO> items;
    
    @ApiModelProperty(value = "提交时间")
    private Date createTime;
    
    @ApiModelProperty(value = "处理时间")
    private Date processTime;
}

public class InquiryItemVO {
    @ApiModelProperty(value = "商品ID")
    private Integer productId;
    
    @ApiModelProperty(value = "商品名称（用户语言）")
    private String productName;
    
    @ApiModelProperty(value = "商品图片（用户语言）")
    private String image;
    
    @ApiModelProperty(value = "人民币价格")
    private BigDecimal price;
    
    @ApiModelProperty(value = "美元价格")
    private BigDecimal priceUsd;
    
    @ApiModelProperty(value = "数量")
    private Integer quantity;
}
```

**响应示例**:
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "inquiryNo": "INQ202605180001",
        "inquiryStatus": 0,
        "inquiryStatusText": "Pending",
        "realName": "John Doe",
        "userPhone": "+1234567890",
        "userEmail": "john@example.com",
        "country": "United States",
        "userAddress": "123 Main St, New York, NY 10001",
        "userRemark": "Please quote best price",
        "items": [
            {
                "productId": 1,
                "productName": "Product Name",
                "image": "https://oss.example.com/product/en/1/slider_0.jpg",
                "price": 100.00,
                "priceUsd": 14.50,
                "quantity": 10
            }
        ],
        "createTime": "2026-05-18 13:30:00",
        "processTime": null
    },
    "timestamp": 1715999999999
}
```

---

## 5. 用户相关接口

### 5.1 用户注册

**接口地址**: `POST /api/front/user/register`

**接口描述**: 用户注册

**请求头**:
```
Accept-Language: zh/en/ru/ar
```

**请求参数**:
```java
public class UserRegisterRequest {
    @ApiModelProperty(value = "用户名", required = true)
    @NotBlank(message = "用户名不能为空")
    @Length(min = 3, max = 20, message = "用户名长度为3-20个字符")
    @Pattern(regexp = "^[a-zA-Z0-9_]+$", message = "用户名只能包含字母、数字、下划线")
    private String username;
    
    @ApiModelProperty(value = "密码", required = true)
    @NotBlank(message = "密码不能为空")
    @Length(min = 6, max = 20, message = "密码长度为6-20个字符")
    private String password;
    
    @ApiModelProperty(value = "邮箱", required = true)
    @NotBlank(message = "邮箱不能为空")
    @Email(message = "邮箱格式不正确")
    private String email;
    
    @ApiModelProperty(value = "手机号")
    @Length(max = 20, message = "手机号长度不能超过20")
    private String phone;
}
```

**响应数据**:
```java
public class UserRegisterVO {
    @ApiModelProperty(value = "用户ID")
    private Integer uid;
    
    @ApiModelProperty(value = "用户名")
    private String username;
    
    @ApiModelProperty(value = "Token")
    private String token;
}
```

---

### 5.2 用户登录

**接口地址**: `POST /api/front/user/login`

**接口描述**: 用户登录

**请求头**:
```
Accept-Language: zh/en/ru/ar
```

**请求参数**:
```java
public class UserLoginRequest {
    @ApiModelProperty(value = "用户名", required = true)
    @NotBlank(message = "用户名不能为空")
    private String username;
    
    @ApiModelProperty(value = "密码", required = true)
    @NotBlank(message = "密码不能为空")
    private String password;
}
```

**响应数据**:
```java
public class UserLoginVO {
    @ApiModelProperty(value = "用户ID")
    private Integer uid;
    
    @ApiModelProperty(value = "用户名")
    private String username;
    
    @ApiModelProperty(value = "邮箱")
    private String email;
    
    @ApiModelProperty(value = "手机号")
    private String phone;
    
    @ApiModelProperty(value = "Token")
    private String token;
    
    @ApiModelProperty(value = "Token过期时间")
    private Date tokenExpireTime;
}
```

---

### 5.3 获取用户信息

**接口地址**: `GET /api/front/user/info`

**接口描述**: 获取当前登录用户信息

**请求头**:
```
Accept-Language: zh/en/ru/ar
Authorization: Bearer {token}
```

**响应数据**:
```java
public class UserInfoVO {
    @ApiModelProperty(value = "用户ID")
    private Integer uid;
    
    @ApiModelProperty(value = "用户名")
    private String username;
    
    @ApiModelProperty(value = "昵称")
    private String nickname;
    
    @ApiModelProperty(value = "邮箱")
    private String email;
    
    @ApiModelProperty(value = "手机号")
    private String phone;
    
    @ApiModelProperty(value = "头像")
    private String avatar;
    
    @ApiModelProperty(value = "注册时间")
    private Date createTime;
}
```

---

### 5.4 更新用户信息

**接口地址**: `PUT /api/front/user/update`

**接口描述**: 更新当前登录用户信息

**请求头**:
```
Accept-Language: zh/en/ru/ar
Authorization: Bearer {token}
```

**请求参数**:
```java
public class UserUpdateRequest {
    @ApiModelProperty(value = "昵称")
    @Length(max = 50, message = "昵称长度不能超过50")
    private String nickname;
    
    @ApiModelProperty(value = "邮箱")
    @Email(message = "邮箱格式不正确")
    private String email;
    
    @ApiModelProperty(value = "手机号")
    @Length(max = 20, message = "手机号长度不能超过20")
    private String phone;
    
    @ApiModelProperty(value = "头像URL")
    private String avatar;
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

## 6. 系统配置相关接口

### 6.1 获取系统配置

**接口地址**: `GET /api/front/config/info`

**接口描述**: 获取系统配置信息（网站名称、SEO信息、联系方式等）

**请求头**:
```
Accept-Language: zh/en/ru/ar
```

**响应数据**:
```java
public class SystemConfigVO {
    @ApiModelProperty(value = "网站名称（根据语言返回）")
    private String siteName;
    
    @ApiModelProperty(value = "SEO关键词（根据语言返回）")
    private String siteKeywords;
    
    @ApiModelProperty(value = "SEO描述（根据语言返回）")
    private String siteDescription;
    
    @ApiModelProperty(value = "联系邮箱")
    private String contactEmail;
    
    @ApiModelProperty(value = "联系电话")
    private String contactPhone;
    
    @ApiModelProperty(value = "联系地址（根据语言返回）")
    private String contactAddress;
    
    @ApiModelProperty(value = "页脚版权信息（根据语言返回）")
    private String footerCopyright;
    
    @ApiModelProperty(value = "页脚关于我们（根据语言返回）")
    private String footerAbout;
}
```

**响应示例**:
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "siteName": "Multi-language Inquiry Platform",
        "siteKeywords": "inquiry,wholesale,products",
        "siteDescription": "Professional inquiry platform",
        "contactEmail": "contact@example.com",
        "contactPhone": "+86-123-4567-8900",
        "contactAddress": "123 Business Street, City, Country",
        "footerCopyright": "© 2026 Company Name. All rights reserved.",
        "footerAbout": "About us content"
    },
    "timestamp": 1715999999999
}
```

---

## C端接口总结

### 接口列表
1. **商品相关** (2个接口)
   - GET /api/front/product/list - 商品列表
   - GET /api/front/product/detail/{id} - 商品详情

2. **分类相关** (1个接口)
   - GET /api/front/category/list - 分类列表

3. **意向清单相关** (4个接口)
   - POST /api/front/cart/add - 添加到意向清单
   - GET /api/front/cart/list - 意向清单列表
   - PUT /api/front/cart/update/{id} - 更新数量
   - DELETE /api/front/cart/delete/{id} - 删除商品

4. **询价相关** (3个接口)
   - POST /api/front/inquiry/submit - 提交询价单
   - GET /api/front/inquiry/my-list - 我的询价单列表
   - GET /api/front/inquiry/detail/{inquiryNo} - 询价单详情

5. **用户相关** (4个接口)
   - POST /api/front/user/register - 用户注册
   - POST /api/front/user/login - 用户登录
   - GET /api/front/user/info - 获取用户信息
   - PUT /api/front/user/update - 更新用户信息

6. **系统配置相关** (1个接口)
   - GET /api/front/config/info - 获取系统配置

**总计**: 15个接口
