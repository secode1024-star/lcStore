# API接口设计 - 补充接口（高优先级-续）

## 4. 平台端系统配置管理接口

### 4.1 系统配置列表

**接口地址**: `GET /api/platform/config/list`

**接口描述**: 获取系统配置列表（分组展示）

**请求头**:
```
Authorization: Bearer {token}
```

**请求参数**:
```java
public class SystemConfigListRequest {
    @ApiModelProperty(value = "配置分组：basic-基础配置，seo-SEO配置，contact-联系方式")
    private String configGroup;
    
    @ApiModelProperty(value = "配置key关键词")
    private String keyword;
}
```

**响应数据**:
```java
public class SystemConfigListVO {
    @ApiModelProperty(value = "配置ID")
    private Integer id;
    
    @ApiModelProperty(value = "配置key")
    private String key;
    
    @ApiModelProperty(value = "配置名称")
    private String name;
    
    @ApiModelProperty(value = "配置值-中文")
    private String value;
    
    @ApiModelProperty(value = "配置值-英文")
    private String valueEn;
    
    @ApiModelProperty(value = "配置值-俄语")
    private String valueRu;
    
    @ApiModelProperty(value = "配置值-阿拉伯语")
    private String valueAr;
    
    @ApiModelProperty(value = "配置类型：text-文本，textarea-多行文本，image-图片")
    private String type;
    
    @ApiModelProperty(value = "配置分组")
    private String configGroup;
    
    @ApiModelProperty(value = "翻译状态：0-未翻译，1-翻译中，2-翻译完成，3-翻译失败")
    private Integer translationStatus;
    
    @ApiModelProperty(value = "是否需要翻译")
    private Boolean needTranslation;
    
    @ApiModelProperty(value = "更新时间")
    private Date updateTime;
}
```

**参考现有代码**:
- 查找现有的SystemConfigService
- 查找eb_system_config表结构
- 复用现有的配置查询逻辑

---

### 4.2 更新系统配置

**接口地址**: `PUT /api/platform/config/update`

**接口描述**: 批量更新系统配置

**请求头**:
```
Authorization: Bearer {token}
```

**请求参数**:
```java
public class SystemConfigUpdateRequest {
    @ApiModelProperty(value = "配置列表", required = true)
    @NotEmpty(message = "配置列表不能为空")
    private List<ConfigItem> configs;
}

public class ConfigItem {
    @ApiModelProperty(value = "配置key", required = true)
    @NotBlank(message = "配置key不能为空")
    private String key;
    
    @ApiModelProperty(value = "配置值", required = true)
    @NotBlank(message = "配置值不能为空")
    private String value;
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
1. 遍历配置列表
2. 检查配置key是否存在
3. 更新配置值
4. 如果配置需要翻译，触发异步翻译
5. 清除配置缓存
6. 发布配置更新事件（用于通知其他模块）

**参考现有代码**:
- 查找现有的SystemConfigService.updateById()方法
- 查找现有的配置缓存逻辑
- 集成翻译服务

---

## 5. 商家端站内消息接口

### 5.1 消息列表

**接口地址**: `GET /api/merchant/message/list`

**接口描述**: 获取商家的站内消息列表

**请求头**:
```
Authorization: Bearer {token}
```

**请求参数**:
```java
public class MessageListRequest {
    @ApiModelProperty(value = "页码", example = "1")
    @Min(value = 1, message = "页码最小为1")
    private Integer page = 1;
    
    @ApiModelProperty(value = "每页数量", example = "20")
    @Min(value = 1, message = "每页数量最小为1")
    @Max(value = 100, message = "每页数量最大为100")
    private Integer limit = 20;
    
    @ApiModelProperty(value = "消息类型：product-商品相关，system-系统通知")
    private String messageType;
    
    @ApiModelProperty(value = "是否已读：true-已读，false-未读")
    private Boolean isRead;
}
```

**响应数据**:
```java
public class MessageListVO {
    @ApiModelProperty(value = "消息ID")
    private Integer id;
    
    @ApiModelProperty(value = "消息类型：product-商品相关，system-系统通知")
    private String messageType;
    
    @ApiModelProperty(value = "消息标题")
    private String title;
    
    @ApiModelProperty(value = "消息摘要（前50个字符）")
    private String summary;
    
    @ApiModelProperty(value = "是否已读")
    private Boolean isRead;
    
    @ApiModelProperty(value = "关联商品ID（如果是商品相关消息）")
    private Integer relatedProductId;
    
    @ApiModelProperty(value = "创建时间")
    private Date createTime;
}
```

**数据库设计**:
```sql
-- 需要新建站内消息表
CREATE TABLE IF NOT EXISTS eb_merchant_message (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    mer_id INT(11) NOT NULL COMMENT '商家ID',
    message_type VARCHAR(20) NOT NULL DEFAULT '' COMMENT '消息类型：product-商品相关，system-系统通知',
    title VARCHAR(200) NOT NULL DEFAULT '' COMMENT '消息标题',
    content TEXT COMMENT '消息内容',
    is_read TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否已读：0-未读，1-已读',
    related_product_id INT(11) NULL COMMENT '关联商品ID',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    INDEX idx_mer_id (mer_id),
    INDEX idx_is_read (is_read),
    INDEX idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家站内消息表';
```

**参考现有代码**:
- 查找现有的消息相关表（可能是eb_system_notification或类似的表）
- 如果没有现有的消息表，需要新建
- 参考现有的分页查询逻辑

---

### 5.2 消息详情

**接口地址**: `GET /api/merchant/message/detail/{id}`

**接口描述**: 获取消息详细内容（自动标记为已读）

**请求头**:
```
Authorization: Bearer {token}
```

**路径参数**:
- `id`: 消息ID

**响应数据**:
```java
public class MessageDetailVO {
    @ApiModelProperty(value = "消息ID")
    private Integer id;
    
    @ApiModelProperty(value = "消息类型：product-商品相关，system-系统通知")
    private String messageType;
    
    @ApiModelProperty(value = "消息标题")
    private String title;
    
    @ApiModelProperty(value = "消息内容")
    private String content;
    
    @ApiModelProperty(value = "是否已读")
    private Boolean isRead;
    
    @ApiModelProperty(value = "关联商品ID")
    private Integer relatedProductId;
    
    @ApiModelProperty(value = "关联商品名称")
    private String relatedProductName;
    
    @ApiModelProperty(value = "创建时间")
    private Date createTime;
}
```

**业务逻辑**:
1. 检查消息是否存在
2. 检查消息是否属于当前商家
3. 如果消息未读，标记为已读
4. 如果有关联商品，查询商品名称
5. 返回消息详情

**参考现有代码**:
- 复用现有的权限检查逻辑
- 参考现有的关联查询方式

---

### 5.3 标记消息已读

**接口地址**: `PUT /api/merchant/message/mark-read/{id}`

**接口描述**: 标记消息为已读

**请求头**:
```
Authorization: Bearer {token}
```

**路径参数**:
- `id`: 消息ID（支持传入"all"表示全部标记为已读）

**响应数据**:
```java
// 返回 CommonResult<String>
{
    "code": 200,
    "message": "标记成功",
    "data": null,
    "timestamp": 1715999999999
}
```

**业务逻辑**:
1. 如果id为"all"，标记当前商家的所有未读消息为已读
2. 如果id为具体消息ID，检查消息是否属于当前商家
3. 更新消息状态为已读
4. 返回成功

**参考现有代码**:
- 参考现有的批量更新逻辑

---

### 5.4 未读消息数量

**接口地址**: `GET /api/merchant/message/unread-count`

**接口描述**: 获取未读消息数量

**请求头**:
```
Authorization: Bearer {token}
```

**响应数据**:
```java
public class UnreadCountVO {
    @ApiModelProperty(value = "未读消息总数")
    private Integer totalCount;
    
    @ApiModelProperty(value = "商品相关未读数")
    private Integer productCount;
    
    @ApiModelProperty(value = "系统通知未读数")
    private Integer systemCount;
}
```

**响应示例**:
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "totalCount": 5,
        "productCount": 3,
        "systemCount": 2
    },
    "timestamp": 1715999999999
}
```

**参考现有代码**:
- 使用COUNT查询统计未读数量
- 按消息类型分组统计

---

## 6. 消息发送Service设计

### 6.1 MessageService接口

```java
/**
 * 站内消息服务
 */
public interface MessageService {
    
    /**
     * 发送商品翻译完成通知
     */
    void sendProductTranslationCompleteMessage(Integer merId, Integer productId, String productName);
    
    /**
     * 发送商品翻译失败通知
     */
    void sendProductTranslationFailedMessage(Integer merId, Integer productId, String productName, String errorMessage);
    
    /**
     * 发送商品审核通过通知
     */
    void sendProductAuditPassMessage(Integer merId, Integer productId, String productName);
    
    /**
     * 发送商品审核拒绝通知
     */
    void sendProductAuditRejectMessage(Integer merId, Integer productId, String productName, String auditRemark);
    
    /**
     * 发送商品强制下架通知
     */
    void sendProductForceOffSaleMessage(Integer merId, Integer productId, String productName, String reason);
    
    /**
     * 发送商家状态变更通知
     */
    void sendMerchantStatusChangeMessage(Integer merId, Boolean status);
    
    /**
     * 发送系统通知
     */
    void sendSystemMessage(Integer merId, String title, String content);
}
```

### 6.2 实现要点

1. **异步发送** - 使用@Async注解，不阻塞主流程
2. **消息模板** - 定义统一的消息模板
3. **失败重试** - 发送失败时记录日志，不影响主流程
4. **批量发送** - 支持批量发送消息（如商家状态变更）

**参考现有代码**:
- 查找现有的通知服务（可能是NotificationService）
- 复用现有的异步发送机制
- 保持与现有通知方式一致

---

## 高优先级接口总结

### 已补充的接口

1. **通用接口** (1个)
   - POST /api/common/upload/image - 图片上传

2. **平台端分类管理** (4个)
   - GET /api/platform/category/list - 分类列表
   - POST /api/platform/category/add - 添加分类
   - PUT /api/platform/category/update/{id} - 更新分类
   - DELETE /api/platform/category/delete/{id} - 删除分类

3. **平台端商家管理** (4个)
   - GET /api/platform/merchant/list - 商家列表
   - GET /api/platform/merchant/detail/{id} - 商家详情
   - PUT /api/platform/merchant/update-status/{id} - 更新商家状态
   - POST /api/platform/merchant/add - 添加商家

4. **平台端系统配置管理** (2个)
   - GET /api/platform/config/list - 系统配置列表
   - PUT /api/platform/config/update - 更新系统配置

5. **商家端站内消息** (4个)
   - GET /api/merchant/message/list - 消息列表
   - GET /api/merchant/message/detail/{id} - 消息详情
   - PUT /api/merchant/message/mark-read/{id} - 标记已读
   - GET /api/merchant/message/unread-count - 未读消息数量

**高优先级接口总计**: 15个

---

## 需要新建的数据库表

### eb_merchant_message（商家站内消息表）

```sql
CREATE TABLE IF NOT EXISTS eb_merchant_message (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    mer_id INT(11) NOT NULL COMMENT '商家ID',
    message_type VARCHAR(20) NOT NULL DEFAULT '' COMMENT '消息类型：product-商品相关，system-系统通知',
    title VARCHAR(200) NOT NULL DEFAULT '' COMMENT '消息标题',
    content TEXT COMMENT '消息内容',
    is_read TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否已读：0-未读，1-已读',
    related_product_id INT(11) NULL COMMENT '关联商品ID',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    INDEX idx_mer_id (mer_id),
    INDEX idx_is_read (is_read),
    INDEX idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家站内消息表';
```

---

## 实现注意事项

### 1. 基于现有代码改造
- 查找现有的Service和Mapper
- 复用现有的业务逻辑
- 保持代码风格一致

### 2. 遵循阿里巴巴规范
- 方法命名：动词+名词
- 参数校验：使用JSR-303注解
- 异常处理：统一异常处理器
- 日志记录：关键操作记录日志

### 3. 性能优化
- 分页查询：使用PageHelper
- 缓存使用：Redis缓存热点数据
- 异步处理：翻译、消息发送使用异步

### 4. 安全性
- 权限校验：检查数据归属
- 参数校验：防止SQL注入
- 密码加密：使用BCrypt
- Token验证：JWT Token

---

## 下一步

高优先级接口已全部补充完成，接下来可以：
1. 补充中优先级接口（密码修改、批量操作、导出等）
2. 或者直接进入前端改造设计阶段

你想继续补充中优先级接口，还是先进入前端改造设计？
