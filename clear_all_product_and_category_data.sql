-- ============================================
-- 清空所有商品信息和平台商品分类数据
-- 注意：此操作不可逆，请谨慎执行！
-- 此脚本会保留所有平台设置数据（商城配置、应用配置、支付配置等）
-- ============================================

-- 1. 禁用外键检查（避免删除顺序问题）
SET FOREIGN_KEY_CHECKS = 0;

-- 2. 清空商品相关的子表数据（先删除子表，再删除主表）
-- 2.1 商品属性值表
TRUNCATE TABLE `eb_store_product_attr_value`;

-- 2.2 商品属性表
TRUNCATE TABLE `eb_store_product_attr`;

-- 2.3 商品详情表
TRUNCATE TABLE `eb_store_product_description`;

-- 2.4 商品分类关联表
TRUNCATE TABLE `eb_store_product_category`;

-- 2.5 商品关联表（收藏、推荐等）
TRUNCATE TABLE `eb_store_product_relation`;

-- 2.6 商品评价表
TRUNCATE TABLE `eb_store_product_reply`;

-- 2.7 商品优惠券关联表
TRUNCATE TABLE `eb_store_product_coupon`;

-- 2.8 商品日志表
TRUNCATE TABLE `eb_store_product_log`;

-- 2.9 商品规则表
TRUNCATE TABLE `eb_store_product_rule`;

-- 2.10 活动商品关联表
TRUNCATE TABLE `eb_activity_product`;

-- 2.11 商品日统计记录表
TRUNCATE TABLE `eb_product_day_record`;
TRUNCATE TABLE `eb_shopping_product_day_record`;

-- 2.12 品牌分类关联表
TRUNCATE TABLE `eb_product_brand_category`;

-- 2.13 社区笔记商品关联表
TRUNCATE TABLE `eb_community_notes_product`;

-- 3. 清空商品主表
TRUNCATE TABLE `eb_store_product`;

-- 4. 清空平台商品表（如果存在）
TRUNCATE TABLE `eb_product`;


-- 5.2 平台商品分类表
TRUNCATE TABLE `eb_product_category`;

DELETE FROM `eb_category` WHERE `type` = 1;

-- 5.4 社区分类表（如果与商品相关，可根据需要取消注释）
-- TRUNCATE TABLE `eb_community_category`;  -- 如果需要清空社区分类，取消注释

-- 6. 清空商品相关的翻译数据（只删除商品翻译，保留菜单等其他翻译）
-- 6.1 删除商品相关的翻译记录（entity_type包含product的）
DELETE FROM `eb_translation` 
WHERE `entity_type` LIKE '%product%' 
   OR `field_name` IN ('product_name', 'material', 'origin', 'capacity', 'size', 'store_name', 'store_info', 'keyword', 'bar_code', 'brand_name');

-- 6.2 只删除商品相关的翻译缓存（保留菜单等其他翻译缓存）
-- MySQL不支持在DELETE中直接使用子查询，所以使用临时表方式
-- 步骤1：创建临时表，存储商品相关的cache_key
CREATE TEMPORARY TABLE IF NOT EXISTS `temp_product_cache_keys` AS 
SELECT DISTINCT `cache_key` 
FROM `eb_translation` 
WHERE `entity_type` LIKE '%product%' 
   OR `field_name` IN ('product_name', 'material', 'origin', 'capacity', 'size', 'store_name', 'store_info', 'keyword', 'bar_code', 'brand_name');

-- 步骤2：删除这些cache_key对应的翻译缓存
DELETE FROM `eb_translation_cache` 
WHERE `cache_key` IN (SELECT `cache_key` FROM `temp_product_cache_keys`);

-- 步骤3：删除临时表
DROP TEMPORARY TABLE IF EXISTS `temp_product_cache_keys`;

-- 7. 清空品牌表（如果与商品相关）
TRUNCATE TABLE `eb_product_brand`;

-- 8. 清空商品属性选项表
TRUNCATE TABLE `eb_product_attribute_option`;

-- 9. 清空商品属性表
TRUNCATE TABLE `eb_product_attribute`;

-- 10. 清空商品保障表
TRUNCATE TABLE `eb_product_guarantee`;

-- 11. 恢复外键检查
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- 执行完成！
-- 
-- 此脚本已执行以下操作：
-- ✅ 清空所有商品数据（eb_store_product及所有关联子表）
-- ✅ 清空平台商品分类（eb_product_category）
-- ✅ 删除eb_category表中type=1的产品分类
-- ✅ 删除商品相关的翻译数据
-- 
-- 保留的数据：
-- ✅ eb_merchant_category（商户分类表，商户等级、类型等）
-- ✅ eb_category表中type=6的配置分类（平台设置菜单）
-- ✅ eb_category表中type=4的设置分类
-- ✅ eb_system_config（系统配置表，包含商城配置、应用配置等）
-- ✅ eb_system_group（系统分组表）
-- ✅ eb_system_group_data（系统分组数据表）
-- ✅ eb_system_form_temp（系统表单模板表）
-- ✅ eb_group_config（首页配置、轮播图等）
-- ✅ 菜单翻译等其他翻译数据
-- 
-- 注意：Redis中的翻译缓存也需要清理
-- 请在Redis CLI中执行：
-- KEYS translation:cache:*
-- 然后删除所有找到的key（或只删除商品相关的key）
-- ============================================

