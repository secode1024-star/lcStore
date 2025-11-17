-- 添加品牌名称字段，允许商户手动输入品牌名称
-- 执行时间：2025-11-06

ALTER TABLE `eb_store_product` 
ADD COLUMN `brand_name` VARCHAR(100) NULL DEFAULT NULL COMMENT '品牌名称（自定义输入）' AFTER `brand_id`;

-- 说明：
-- 1. brand_id 和 brand_name 可以同时为空（非必填）
-- 2. 如果选择了品牌下拉，则 brand_id 有值，brand_name 可以从品牌表关联获取
-- 3. 如果手动输入品牌，则 brand_id 为 NULL，brand_name 存储用户输入的值








