-- 为商品规格添加品名、材质(成分)和装箱数量字段
-- 执行时间: 2025-10-10

-- 为 eb_store_product_attr_value 表添加新字段
ALTER TABLE `eb_store_product_attr_value` 
ADD COLUMN `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '品名' AFTER `volume`,
ADD COLUMN `material` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '材质(成分)' AFTER `product_name`,
ADD COLUMN `pack_quantity` int(11) NOT NULL DEFAULT 0 COMMENT '装箱数量' AFTER `material`;

-- 查看表结构确认修改
DESCRIBE `eb_store_product_attr_value`;

-- 更新现有数据的默认值（可选）
-- UPDATE `eb_store_product_attr_value` SET 
--   `product_name` = '默认品名',
--   `material` = '待填写',
--   `pack_quantity` = 1
-- WHERE `product_name` = '' OR `material` = '' OR `pack_quantity` = 0;
















