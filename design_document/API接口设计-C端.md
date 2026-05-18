# API接口设计 - C端接口

## 设计原则

1. **RESTful风格** - 遵循REST API设计规范
2. **多语言支持** - 通过请求头 `Accept-Language` 识别语言（zh/en/ru/ar）
3. **统一响应格式** - 使用CommonResult包装所有响应
4. **可选登录** - 游客可浏览和询价，登录用户可使用意向清单
5. **分页查询** - 列表接口统一使用PageInfo分页
6. **参数校验** - 使用JSR-303注解校验参数

---

## 通用响应格式

```java
/**
 * 统一响应格式
 */
public class CommonResult<T> {
    private Integer code;      // 状态码：200-成功，其他-失败
    private String message;    // 提示信息
    private T data;           // 响应数据
    private Long timestamp;   // 时间戳
}
```

---

## 1. 商品相关接口

### 1.1 商品列表

**接口地址**: `GET /api/front/product/list`

**接口描述**: 获取商品列表，支持分类筛选、关键词搜索、分页

**请求头**:
```
Accept-Language: zh/en/ru/ar
```

**请求参数**:
```java
public class ProductListRequest {
    @ApiModelProperty(value = "页码", example = "1")
    @Min(value = 1, message = "页码最小为1")
    private Integer page = 1;
    
    @ApiModelProperty(value = "每页数量", example = "20")
    @Min(value = 1, message = "每页数量最小为1")
    @Max(value = 100, message = "每页数量最大为100")
    private Integer limit = 20;
    
    @ApiModelProperty(value = "分类ID")
    private Integer categoryId;
    
    @ApiModelProperty(value = "搜索关键词")
    @Length(max = 100, message = "关键词长度不能超过100")
    private String keyword;
    
    @ApiModelProperty(value = "排序方式：default-默认，price_asc-价格升序，price_desc-价格降序，time_desc-最新")
    private String sort = "default";
}
```

**响应数据**:
```java
public class ProductListVO {
    @ApiModelProperty(value = "商品ID")
    private Integer id;
    
    @ApiModelProperty(value = "商品名称（根据语言返回）")
    private String storeName;
    
    @ApiModelProperty(value = "商品简介（根据语言返回）")
    private String storeInfo;
    
    @ApiModelProperty(value = "商品主图（根据语言返回）")
    private String image;
    
    @ApiModelProperty(value = "人民币价格")
    private BigDecimal price;
    
    @ApiModelProperty(value = "美元价格")
    private BigDecimal priceUsd;
    
    @ApiModelProperty(value = "人民币原价")
    private BigDecimal otPrice;
    
    @ApiModelProperty(value = "美元原价")
    private BigDecimal otPriceUsd;
}
```

**响应示例**:
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "pageNum": 1,
        "pageSize": 20,
        "total": 100,
        "list": [
            {
                "id": 1,
                "storeName": "Product Name",
                "storeInfo": "Product Description",
                "image": "https://oss.example.com/product/en/1/slider_0.jpg",
                "price": 100.00,
                "priceUsd": 14.50,
                "otPrice": 120.00,
                "otPriceUsd": 17.40
            }
        ]
    },
    "timestamp": 1715999999999
}
```

---

### 1.2 商品详情

**接口地址**: `GET /api/front/product/detail/{id}`

**接口描述**: 获取商品详细信息

**请求头**:
```
Accept-Language: zh/en/ru/ar
```

**路径参数**:
- `id`: 商品ID

**响应数据**:
```java
public class ProductDetailVO {
    @ApiModelProperty(value = "商品ID")
    private Integer id;
    
    @ApiModelProperty(value = "商品名称（根据语言返回）")
    private String storeName;
    
    @ApiModelProperty(value = "商品简介（根据语言返回）")
    private String storeInfo;
    
    @ApiModelProperty(value = "商品关键词（根据语言返回）")
    private String keyword;
    
    @ApiModelProperty(value = "轮播图列表（根据语言返回）")
    private List<String> sliderImages;
    
    @ApiModelProperty(value = "详情图列表（根据语言返回）")
    private List<String> detailImages;
    
    @ApiModelProperty(value = "商品详情HTML（根据语言返回）")
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
    
    @ApiModelProperty(value = "分类名称（根据语言返回）")
    private String categoryName;
}
```

**响应示例**:
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "id": 1,
        "storeName": "Product Name",
        "storeInfo": "Product Description",
        "keyword": "keyword1,keyword2",
        "sliderImages": [
            "https://oss.example.com/product/en/1/slider_0.jpg",
            "https://oss.example.com/product/en/1/slider_1.jpg"
        ],
        "detailImages": [
            "https://oss.example.com/product/en/1/detail_0.jpg"
        ],
        "description": "<p>Product detail content</p>",
        "price": 100.00,
        "priceUsd": 14.50,
        "otPrice": 120.00,
        "otPriceUsd": 17.40,
        "categoryId": 10,
        "categoryName": "Category Name"
    },
    "timestamp": 1715999999999
}
```

---

## 2. 分类相关接口

### 2.1 分类列表

**接口地址**: `GET /api/front/category/list`

**接口描述**: 获取商品分类列表（树形结构）

**请求头**:
```
Accept-Language: zh/en/ru/ar
```

**响应数据**:
```java
public class CategoryTreeVO {
    @ApiModelProperty(value = "分类ID")
    private Integer id;
    
    @ApiModelProperty(value = "父级ID")
    private Integer pid;
    
    @ApiModelProperty(value = "分类名称（根据语言返回）")
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

**响应示例**:
```json
{
    "code": 200,
    "message": "success",
    "data": [
        {
            "id": 1,
            "pid": 0,
            "name": "Category 1",
            "icon": "icon-url",
            "level": 1,
            "sort": 1,
            "children": [
                {
                    "id": 10,
                    "pid": 1,
                    "name": "Sub Category 1-1",
                    "icon": "",
                    "level": 2,
                    "sort": 1,
                    "children": []
                }
            ]
        }
    ],
    "timestamp": 1715999999999
}
```

---

## 3. 意向清单相关接口

### 3.1 添加到意向清单

**接口地址**: `POST /api/front/cart/add`

**接口描述**: 添加商品到意向清单（需要登录）

**请求头**:
```
Accept-Language: zh/en/ru/ar
Authorization: Bearer {token}
```

**请求参数**:
```java
public class CartAddRequest {
    @ApiModelProperty(value = "商品ID", required = true)
    @NotNull(message = "商品ID不能为空")
    private Integer productId;
    
    @ApiModelProperty(value = "数量", required = true)
    @NotNull(message = "数量不能为空")
    @Min(value = 1, message = "数量最小为1")
    private Integer quantity;
}
```

**响应数据**:
```java
public class CartAddVO {
    @ApiModelProperty(value = "意向清单ID")
    private Integer cartId;
    
    @ApiModelProperty(value = "意向清单商品总数")
    private Integer totalCount;
}
```

---

### 3.2 意向清单列表

**接口地址**: `GET /api/front/cart/list`

**接口描述**: 获取当前用户的意向清单（需要登录）

**请求头**:
```
Accept-Language: zh/en/ru/ar
Authorization: Bearer {token}
```

**响应数据**:
```java
public class CartListVO {
    @ApiModelProperty(value = "意向清单ID")
    private Integer id;
    
    @ApiModelProperty(value = "商品ID")
    private Integer productId;
    
    @ApiModelProperty(value = "商品名称（根据语言返回）")
    private String productName;
    
    @ApiModelProperty(value = "商品图片（根据语言返回）")
    private String productImage;
    
    @ApiModelProperty(value = "人民币价格")
    private BigDecimal price;
    
    @ApiModelProperty(value = "美元价格")
    private BigDecimal priceUsd;
    
    @ApiModelProperty(value = "数量")
    private Integer quantity;
    
    @ApiModelProperty(value = "是否有效：true-有效，false-商品已下架")
    private Boolean isValid;
}
```

---

### 3.3 更新意向清单数量

**接口地址**: `PUT /api/front/cart/update/{id}`

**接口描述**: 更新意向清单中商品的数量（需要登录）

**请求头**:
```
Accept-Language: zh/en/ru/ar
Authorization: Bearer {token}
```

**路径参数**:
- `id`: 意向清单ID

**请求参数**:
```java
public class CartUpdateRequest {
    @ApiModelProperty(value = "数量", required = true)
    @NotNull(message = "数量不能为空")
    @Min(value = 1, message = "数量最小为1")
    private Integer quantity;
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

### 3.4 删除意向清单商品

**接口地址**: `DELETE /api/front/cart/delete/{id}`

**接口描述**: 从意向清单中删除商品（需要登录）

**请求头**:
```
Accept-Language: zh/en/ru/ar
Authorization: Bearer {token}
```

**路径参数**:
- `id`: 意向清单ID

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
