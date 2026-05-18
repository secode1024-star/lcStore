# 数据库改造SQL脚本说明

## 文件列表

- `01_database_migration.sql` - 数据库结构改造主脚本

## 执行前准备

### 1. 备份数据库
```bash
mysqldump -uroot -p java_et > backup_java_et_$(date +%Y%m%d_%H%M%S).sql
```

### 2. 确认当前数据库状态
```sql
USE java_et;
SHOW TABLES;
SELECT COUNT(*) FROM eb_store_product;
SELECT COUNT(*) FROM eb_store_order;
```

### 3. 检查依赖关系
确认是否有外键约束需要先删除：
```sql
SELECT 
    TABLE_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'java_et'
AND REFERENCED_TABLE_NAME IS NOT NULL;
```

## 执行步骤

### 方式一：命令行执行（推荐）
```bash
mysql -uroot -p java_et < 01_database_migration.sql
```

### 方式二：分步执行
如果担心一次性执行出错，可以分步执行：

1. 先执行数据清空部分（第一部分）
2. 再执行表删除部分（第二部分）
3. 最后执行表结构修改部分（第三至十三部分）

## 脚本内容说明

### 第一部分：清空现有数据
- 清空订单、购物车、商品等业务数据
- **注意**：分类数据默认不清空，如需清空请取消注释

### 第二部分：删除不需要的表
删除以下功能相关的表：
- 支付相关（PayPal、Stripe、微信支付、充值）
- 物流相关（快递、物流跟踪）
- 退款相关
- 优惠券相关
- 积分会员相关
- 评价收藏相关
- 品牌相关
- 商品保障服务
- 营销活动（秒杀、拼团、砍价）
- 订单状态表

### 第三部分：修改商品表
- 删除电商相关字段（库存、销量、积分、成本等）
- 新增多语言字段（商品名称、简介、关键字）
- 新增详情图字段（从富文本中分离）
- 新增轮播图多语言字段
- 新增美元价格字段
- 新增审核状态字段
- 新增翻译状态字段

### 第四部分：修改商品详情表
- 新增多语言详情字段

### 第五部分：修改分类表
- 新增多语言分类名称
- 新增翻译状态字段

### 第六部分：修改订单表为询价单表
- 删除支付、物流、退款相关字段
- 新增询价相关字段（询价单号、国家、询价状态、用户语言）
- 新增联系方式原文字段（保留用户提交的原始语言）

### 第七部分：修改订单详情表
- 新增商品名称多语言字段
- 新增用户看到的商品名称字段

### 第八部分：修改购物车表为意向清单表
- 修改uid为NOT NULL（仅登录用户可用）

### 第九部分：修改用户表
- 删除电商相关字段（积分、余额、佣金、推广等）

### 第十部分：修改系统配置表
- 新增联系方式配置
- 新增常用配置的多语言版本（网站名称、SEO信息、页脚信息）

### 第十一部分：修改翻译记录表
- 新增翻译成本记录字段（token数量、成本、模型名称）

### 第十二部分：创建图片翻译记录表
- 新建表用于记录商品图片的翻译结果
- 支持轮播图和详情图的多语言版本

### 第十三部分：优化索引
- 为新增字段添加索引
- 优化查询性能

## 执行后验证

### 1. 检查表结构
```sql
-- 检查商品表
DESCRIBE eb_store_product;

-- 检查分类表
DESCRIBE eb_product_category;

-- 检查询价单表
DESCRIBE eb_store_order;

-- 检查图片翻译表
DESCRIBE eb_product_image_translation;
```

### 2. 检查数据
```sql
-- 确认数据已清空
SELECT COUNT(*) FROM eb_store_product;
SELECT COUNT(*) FROM eb_store_order;

-- 确认配置已添加
SELECT * FROM eb_system_config WHERE parameter LIKE '%contact%';
SELECT * FROM eb_system_config WHERE parameter LIKE '%_en' OR parameter LIKE '%_ru' OR parameter LIKE '%_ar';
```

### 3. 检查删除的表
```sql
-- 确认表已删除
SHOW TABLES LIKE '%coupon%';
SHOW TABLES LIKE '%refund%';
SHOW TABLES LIKE '%brand%';
```

## 注意事项

1. **执行前务必备份数据库**
2. 脚本会清空所有商品和订单数据，确认无误后再执行
3. 如果有外键约束，可能需要先删除外键
4. 系统配置的多语言支持需要根据实际情况补充
5. 执行后需要重启后端服务，清除缓存

## 回滚方案

如果执行出错，可以通过备份恢复：
```bash
mysql -uroot -p java_et < backup_java_et_YYYYMMDD_HHMMSS.sql
```

## 后续工作

数据库改造完成后，还需要：
1. 修改后端代码（实体类、Service、Controller）
2. 集成翻译服务（文本翻译、图片翻译）
3. 修改前端代码（多语言切换、询价流程）
4. 配置阿里云OSS（存储翻译后的图片）
5. 测试完整流程
