-- 为商品表添加多语言字段
ALTER TABLE `eb_store_product` 
ADD COLUMN `store_name_en` varchar(255) DEFAULT NULL COMMENT '商品名称-英文',
ADD COLUMN `store_name_fr` varchar(255) DEFAULT NULL COMMENT '商品名称-法文',
ADD COLUMN `store_name_th` varchar(255) DEFAULT NULL COMMENT '商品名称-泰语',
ADD COLUMN `store_name_lao` varchar(255) DEFAULT NULL COMMENT '商品名称-老挝语',
ADD COLUMN `store_name_ja` varchar(255) DEFAULT NULL COMMENT '商品名称-日语',
ADD COLUMN `store_name_ko` varchar(255) DEFAULT NULL COMMENT '商品名称-韩语',
ADD COLUMN `store_name_ar` varchar(255) DEFAULT NULL COMMENT '商品名称-阿拉伯语',
ADD COLUMN `store_info_en` text DEFAULT NULL COMMENT '商品简介-英文',
ADD COLUMN `store_info_fr` text DEFAULT NULL COMMENT '商品简介-法文',
ADD COLUMN `store_info_th` text DEFAULT NULL COMMENT '商品简介-泰语',
ADD COLUMN `store_info_lao` text DEFAULT NULL COMMENT '商品简介-老挝语',
ADD COLUMN `store_info_ja` text DEFAULT NULL COMMENT '商品简介-日语',
ADD COLUMN `store_info_ko` text DEFAULT NULL COMMENT '商品简介-韩语',
ADD COLUMN `store_info_ar` text DEFAULT NULL COMMENT '商品简介-阿拉伯语';

-- 为分类表添加多语言字段
ALTER TABLE `eb_category` 
ADD COLUMN `cate_name_en` varchar(255) DEFAULT NULL COMMENT '分类名称-英文',
ADD COLUMN `cate_name_fr` varchar(255) DEFAULT NULL COMMENT '分类名称-法文',
ADD COLUMN `cate_name_th` varchar(255) DEFAULT NULL COMMENT '分类名称-泰语',
ADD COLUMN `cate_name_lao` varchar(255) DEFAULT NULL COMMENT '分类名称-老挝语',
ADD COLUMN `cate_name_ja` varchar(255) DEFAULT NULL COMMENT '分类名称-日语',
ADD COLUMN `cate_name_ko` varchar(255) DEFAULT NULL COMMENT '分类名称-韩语',
ADD COLUMN `cate_name_ar` varchar(255) DEFAULT NULL COMMENT '分类名称-阿拉伯语';

-- 为商品属性值表添加多语言字段
ALTER TABLE `eb_store_product_attr_value`
ADD COLUMN `product_name_en` varchar(255) DEFAULT NULL COMMENT '品名-英文',
ADD COLUMN `product_name_fr` varchar(255) DEFAULT NULL COMMENT '品名-法文',
ADD COLUMN `product_name_th` varchar(255) DEFAULT NULL COMMENT '品名-泰语',
ADD COLUMN `product_name_lao` varchar(255) DEFAULT NULL COMMENT '品名-老挝语',
ADD COLUMN `product_name_ja` varchar(255) DEFAULT NULL COMMENT '品名-日语',
ADD COLUMN `product_name_ko` varchar(255) DEFAULT NULL COMMENT '品名-韩语',
ADD COLUMN `product_name_ar` varchar(255) DEFAULT NULL COMMENT '品名-阿拉伯语',
ADD COLUMN `material_en` varchar(255) DEFAULT NULL COMMENT '材质-英文',
ADD COLUMN `material_fr` varchar(255) DEFAULT NULL COMMENT '材质-法文',
ADD COLUMN `material_th` varchar(255) DEFAULT NULL COMMENT '材质-泰语',
ADD COLUMN `material_lao` varchar(255) DEFAULT NULL COMMENT '材质-老挝语',
ADD COLUMN `material_ja` varchar(255) DEFAULT NULL COMMENT '材质-日语',
ADD COLUMN `material_ko` varchar(255) DEFAULT NULL COMMENT '材质-韩语',
ADD COLUMN `material_ar` varchar(255) DEFAULT NULL COMMENT '材质-阿拉伯语';
