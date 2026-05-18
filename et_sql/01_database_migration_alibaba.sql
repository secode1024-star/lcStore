-- ============================================
-- 数据库改造SQL脚本 - 电商系统改为多语言询价平台
-- 符合《阿里巴巴Java开发手册（嵩山版）》规范
-- 执行前请备份数据库！
-- ============================================

USE java_et;

-- ============================================
-- 第一部分：清空现有数据（从零开始）
-- ============================================

-- 清空订单相关数据
TRUNCATE TABLE eb_store_order;
TRUNCATE TABLE eb_store_order_info;

-- 清空购物车数据
TRUNCATE TABLE eb_store_cart;

-- 清空商品数据
TRUNCATE TABLE eb_store_product;
TRUNCATE TABLE eb_store_product_attr;
TRUNCATE TABLE eb_store_product_attr_result;
TRUNCATE TABLE eb_store_product_attr_value;
TRUNCATE TABLE eb_store_product_description;

-- 清空分类数据（如果需要重新设计分类体系）
-- TRUNCATE TABLE eb_product_category;

-- ============================================
-- 第二部分：删除不需要的表
-- ============================================

-- 删除支付相关表
DROP TABLE IF EXISTS eb_paypal_record;
DROP TABLE IF EXISTS eb_stripe_record;
DROP TABLE IF EXISTS eb_wechat_pay_record;
DROP TABLE IF EXISTS eb_user_recharge;

-- 删除物流相关表
DROP TABLE IF EXISTS eb_express;
DROP TABLE IF EXISTS eb_order_logistics;

-- 删除退款相关表
DROP TABLE IF EXISTS eb_store_refund_order;

-- 删除优惠券相关表
DROP TABLE IF EXISTS eb_coupon;
DROP TABLE IF EXISTS eb_coupon_user;
DROP TABLE IF EXISTS eb_store_coupon;
DROP TABLE IF EXISTS eb_store_coupon_user;

-- 删除积分会员相关表
DROP TABLE IF EXISTS eb_user_bill;
DROP TABLE IF EXISTS eb_system_user_level;
DROP TABLE IF EXISTS eb_user_level;

-- 删除评价相关表
DROP TABLE IF EXISTS eb_store_product_reply;

-- 删除收藏关注相关表
DROP TABLE IF EXISTS eb_store_product_relation;
DROP TABLE IF EXISTS eb_user_visit_record;

-- 删除品牌相关表
DROP TABLE IF EXISTS eb_product_brand;
DROP TABLE IF EXISTS eb_product_brand_category;

-- 删除商品保障服务表
DROP TABLE IF EXISTS eb_product_guarantee;

-- 删除秒杀、拼团、砍价等营销表
DROP TABLE IF EXISTS eb_store_seckill;
DROP TABLE IF EXISTS eb_store_combination;
DROP TABLE IF EXISTS eb_store_bargain;

-- 删除订单状态表（询价单不需要复杂的状态变更记录）
DROP TABLE IF EXISTS eb_store_order_status;

-- ============================================
-- 第三部分：修改商品表 eb_store_product
-- 阿里规范：字段尽量NOT NULL，小数用DECIMAL，添加注释
-- ============================================

ALTER TABLE eb_store_product
-- 删除不需要的字段
DROP COLUMN IF EXISTS brand_id,
DROP COLUMN IF EXISTS brand_name,
DROP COLUMN IF EXISTS cate_id,
DROP COLUMN IF EXISTS stock,
DROP COLUMN IF EXISTS sales,
DROP COLUMN IF EXISTS ficti,
DROP COLUMN IF EXISTS give_integral,
DROP COLUMN IF EXISTS cost,
DROP COLUMN IF EXISTS vip_price,
DROP COLUMN IF EXISTS postage,
DROP COLUMN IF EXISTS spec_type,
DROP COLUMN IF EXISTS unit_name,

-- 新增多语言字段（阿里规范：字段尽量NOT NULL，这里允许NULL因为翻译是异步的）
ADD COLUMN store_name_en VARCHAR(255) DEFAULT '' COMMENT '商品名称-英文' AFTER store_name,
ADD COLUMN store_name_ru VARCHAR(255) DEFAULT '' COMMENT '商品名称-俄语' AFTER store_name_en,
ADD COLUMN store_name_ar VARCHAR(255) DEFAULT '' COMMENT '商品名称-阿拉伯语' AFTER store_name_ru,

ADD COLUMN store_info_en VARCHAR(500) DEFAULT '' COMMENT '商品简介-英文' AFTER store_info,
ADD COLUMN store_info_ru VARCHAR(500) DEFAULT '' COMMENT '商品简介-俄语' AFTER store_info_en,
ADD COLUMN store_info_ar VARCHAR(500) DEFAULT '' COMMENT '商品简介-阿拉伯语' AFTER store_info_ru,

ADD COLUMN keyword_en VARCHAR(255) DEFAULT '' COMMENT '关键字-英文' AFTER keyword,
ADD COLUMN keyword_ru VARCHAR(255) DEFAULT '' COMMENT '关键字-俄语' AFTER keyword_en,
ADD COLUMN keyword_ar VARCHAR(255) DEFAULT '' COMMENT '关键字-阿拉伯语' AFTER keyword_ru,

-- 新增详情图字段（从富文本中分离）
ADD COLUMN detail_images TEXT COMMENT '详情图片URL列表，逗号分隔' AFTER slider_image,
ADD COLUMN detail_images_en TEXT COMMENT '详情图片-英文' AFTER detail_images,
ADD COLUMN detail_images_ru TEXT COMMENT '详情图片-俄语' AFTER detail_images_en,
ADD COLUMN detail_images_ar TEXT COMMENT '详情图片-阿拉伯语' AFTER detail_images_ru,

-- 新增轮播图多语言字段
ADD COLUMN slider_image_en VARCHAR(2000) DEFAULT '' COMMENT '轮播图-英文' AFTER slider_image,
ADD COLUMN slider_image_ru VARCHAR(2000) DEFAULT '' COMMENT '轮播图-俄语' AFTER slider_image_en,
ADD COLUMN slider_image_ar VARCHAR(2000) DEFAULT '' COMMENT '轮播图-阿拉伯语' AFTER slider_image_ru,

-- 新增价格字段（阿里规范：小数使用DECIMAL，禁止FLOAT/DOUBLE）
ADD COLUMN price_usd DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '价格-美元' AFTER price,
ADD COLUMN ot_price_usd DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '原价-美元' AFTER ot_price,

-- 新增审核状态字段（阿里规范：状态字段用TINYINT，添加注释说明每个值的含义）
ADD COLUMN audit_status TINYINT(1) NOT NULL DEFAULT 0 COMMENT '审核状态：0-待审核，1-审核通过，2-审核拒绝' AFTER is_show,
ADD COLUMN audit_remark VARCHAR(500) DEFAULT '' COMMENT '审核备注' AFTER audit_status,
ADD COLUMN audit_time DATETIME DEFAULT NULL COMMENT '审核时间' AFTER audit_remark,

-- 新增翻译状态字段
ADD COLUMN translation_status TINYINT(1) NOT NULL DEFAULT 0 COMMENT '翻译状态：0-未翻译，1-翻译中，2-翻译完成，3-翻译失败' AFTER audit_time,
ADD COLUMN translation_progress INT NOT NULL DEFAULT 0 COMMENT '翻译进度（0-100）' AFTER translation_status,
ADD COLUMN translation_error TEXT COMMENT '翻译错误信息' AFTER translation_progress,
ADD COLUMN last_translation_time DATETIME DEFAULT NULL COMMENT '最后翻译时间' AFTER translation_error;

-- 修改字段注释和类型（阿里规范：确保字段有明确注释）
ALTER TABLE eb_store_product
MODIFY COLUMN store_name VARCHAR(255) NOT NULL DEFAULT '' COMMENT '商品名称-中文',
MODIFY COLUMN store_info VARCHAR(500) NOT NULL DEFAULT '' COMMENT '商品简介-中文',
MODIFY COLUMN keyword VARCHAR(255) NOT NULL DEFAULT '' COMMENT '关键字-中文',
MODIFY COLUMN slider_image VARCHAR(2000) NOT NULL DEFAULT '' COMMENT '轮播图-中文',
MODIFY COLUMN price DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '价格-人民币',
MODIFY COLUMN ot_price DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '原价-人民币';

-- ============================================
-- 第四部分：修改商品详情表 eb_store_product_description
-- ============================================

ALTER TABLE eb_store_product_description
ADD COLUMN description_en TEXT COMMENT '商品详情-英文' AFTER description,
ADD COLUMN description_ru TEXT COMMENT '商品详情-俄语' AFTER description_en,
ADD COLUMN description_ar TEXT COMMENT '商品详情-阿拉伯语' AFTER description_ru;

ALTER TABLE eb_store_product_description
MODIFY COLUMN description TEXT NOT NULL COMMENT '商品详情-中文';

-- ============================================
-- 第五部分：修改分类表 eb_product_category
-- ============================================

ALTER TABLE eb_product_category
ADD COLUMN name_en VARCHAR(50) NOT NULL DEFAULT '' COMMENT '分类名称-英文' AFTER name,
ADD COLUMN name_ru VARCHAR(50) NOT NULL DEFAULT '' COMMENT '分类名称-俄语' AFTER name_en,
ADD COLUMN name_ar VARCHAR(50) NOT NULL DEFAULT '' COMMENT '分类名称-阿拉伯语' AFTER name_ru,
ADD COLUMN translation_status TINYINT(1) NOT NULL DEFAULT 0 COMMENT '翻译状态：0-未翻译，1-翻译中，2-翻译完成，3-翻译失败' AFTER name_ar,
ADD COLUMN last_translation_time DATETIME DEFAULT NULL COMMENT '最后翻译时间' AFTER translation_status;

ALTER TABLE eb_product_category
MODIFY COLUMN name VARCHAR(50) NOT NULL DEFAULT '' COMMENT '分类名称-中文';

-- ============================================
-- 第六部分：修改订单表为询价单表 eb_store_order
-- ============================================

ALTER TABLE eb_store_order
-- 删除支付相关字段
DROP COLUMN IF EXISTS paid,
DROP COLUMN IF EXISTS pay_time,
DROP COLUMN IF EXISTS pay_type,
DROP COLUMN IF EXISTS pay_price,
DROP COLUMN IF EXISTS pay_postage,
DROP COLUMN IF EXISTS total_postage,

-- 删除优惠券相关字段
DROP COLUMN IF EXISTS coupon_id,
DROP COLUMN IF EXISTS coupon_price,

-- 删除退款相关字段
DROP COLUMN IF EXISTS refund_status,
DROP COLUMN IF EXISTS refund_reason_wap_img,
DROP COLUMN IF EXISTS refund_reason_wap_explain,
DROP COLUMN IF EXISTS refund_reason_time,
DROP COLUMN IF EXISTS refund_reason_wap,
DROP COLUMN IF EXISTS refund_price,

-- 删除物流相关字段
DROP COLUMN IF EXISTS delivery_name,
DROP COLUMN IF EXISTS delivery_code,
DROP COLUMN IF EXISTS delivery_id,
DROP COLUMN IF EXISTS delivery_type,

-- 删除商家相关字段
DROP COLUMN IF EXISTS mer_remark,
DROP COLUMN IF EXISTS is_merchant_del,

-- 删除其他不需要的字段
DROP COLUMN IF EXISTS is_reply,
DROP COLUMN IF EXISTS combination_id,
DROP COLUMN IF EXISTS pink_id,
DROP COLUMN IF EXISTS seckill_id,
DROP COLUMN IF EXISTS bargain_id,

-- 新增询价相关字段（阿里规范：字段尽量NOT NULL）
ADD COLUMN inquiry_no VARCHAR(32) NOT NULL DEFAULT '' COMMENT '询价单号' AFTER order_id,
ADD COLUMN country VARCHAR(100) NOT NULL DEFAULT '' COMMENT '国家' AFTER user_address,
ADD COLUMN inquiry_status TINYINT(1) NOT NULL DEFAULT 0 COMMENT '询价状态：0-待处理，1-已处理，2-已废弃' AFTER status,
ADD COLUMN process_time DATETIME DEFAULT NULL COMMENT '处理时间' AFTER inquiry_status,
ADD COLUMN user_language VARCHAR(10) NOT NULL DEFAULT 'zh' COMMENT '用户提交时的语言：zh/en/ru/ar' AFTER process_time,

-- 新增联系方式翻译字段（保留原文）
ADD COLUMN real_name_original VARCHAR(50) NOT NULL DEFAULT '' COMMENT '用户姓名-原文' AFTER real_name,
ADD COLUMN user_address_original VARCHAR(500) NOT NULL DEFAULT '' COMMENT '用户地址-原文' AFTER user_address,
ADD COLUMN user_remark_original TEXT COMMENT '用户备注-原文' AFTER mark;

-- 修改字段注释（阿里规范：确保字段有明确注释）
ALTER TABLE eb_store_order
MODIFY COLUMN order_id VARCHAR(32) NOT NULL DEFAULT '' COMMENT '订单号（保留字段名，实际为询价单号）',
MODIFY COLUMN status TINYINT(1) NOT NULL DEFAULT 0 COMMENT '订单状态（保留字段名，实际为询价状态：0-待处理，1-已处理，2-已废弃）',
MODIFY COLUMN real_name VARCHAR(50) NOT NULL DEFAULT '' COMMENT '用户姓名-中文翻译',
MODIFY COLUMN user_address VARCHAR(500) NOT NULL DEFAULT '' COMMENT '用户地址-中文翻译',
MODIFY COLUMN mark TEXT COMMENT '用户备注-中文翻译';

-- 添加索引（阿里规范：索引命名 idx_字段名）
ALTER TABLE eb_store_order
ADD INDEX idx_inquiry_no (inquiry_no),
ADD INDEX idx_inquiry_status (inquiry_status),
ADD INDEX idx_user_language (user_language),
ADD INDEX idx_process_time (process_time);

-- ============================================
-- 第七部分：修改订单详情表 eb_store_order_info
-- ============================================

ALTER TABLE eb_store_order_info
-- 新增商品名称多语言字段
ADD COLUMN product_name_en VARCHAR(255) NOT NULL DEFAULT '' COMMENT '商品名称-英文' AFTER info,
ADD COLUMN product_name_ru VARCHAR(255) NOT NULL DEFAULT '' COMMENT '商品名称-俄语' AFTER product_name_en,
ADD COLUMN product_name_ar VARCHAR(255) NOT NULL DEFAULT '' COMMENT '商品名称-阿拉伯语' AFTER product_name_ru,

-- 新增用户看到的商品名称（用户提交时的语言）
ADD COLUMN product_name_user VARCHAR(255) NOT NULL DEFAULT '' COMMENT '商品名称-用户看到的语言' AFTER product_name_ar,
ADD COLUMN user_language VARCHAR(10) NOT NULL DEFAULT 'zh' COMMENT '用户提交时的语言' AFTER product_name_user;

-- 修改字段注释
ALTER TABLE eb_store_order_info
MODIFY COLUMN info TEXT NOT NULL COMMENT '商品信息快照-中文';

-- ============================================
-- 第八部分：修改购物车表为意向清单表 eb_store_cart
-- ============================================

-- 注意：意向清单只有登录用户可用，uid不能为NULL
ALTER TABLE eb_store_cart
MODIFY COLUMN uid INT(11) NOT NULL COMMENT '用户ID（意向清单仅登录用户可用）';

-- 修改表注释
ALTER TABLE eb_store_cart COMMENT='意向清单表（原购物车表）';

-- ============================================
-- 第九部分：修改用户表 eb_user
-- ============================================

ALTER TABLE eb_user
-- 删除电商相关字段
DROP COLUMN IF EXISTS integral,
DROP COLUMN IF EXISTS now_money,
DROP COLUMN IF EXISTS brokerage_price,
DROP COLUMN IF EXISTS pay_count,
DROP COLUMN IF EXISTS spread_uid,
DROP COLUMN IF EXISTS spread_time,
DROP COLUMN IF EXISTS user_type,
DROP COLUMN IF EXISTS is_promoter,
DROP COLUMN IF EXISTS level,
DROP COLUMN IF EXISTS clean_time;

-- 保留基础字段：uid, account, pwd, real_name, phone, birthday, card_id, mark,
-- partner_id, group_id, nickname, avatar, sex, add_time, add_ip, last_time, last_ip, status

-- ============================================
-- 第十部分：修改系统配置表 eb_system_config
-- ============================================

-- 为需要多语言的配置项增加多语言字段
-- 方案：在配置表中为每个需要翻译的配置增加 _en/_ru/_ar 后缀的配置项

-- 新增联系方式配置（如果不存在）
INSERT INTO eb_system_config (menu_name, type, input_type, config_tab_id, parameter, upload_type, required, status, value, info, sort, create_time)
VALUES
('联系邮箱', 'text', 'input', 0, 'contact_email', 0, '', 1, '', '平台联系邮箱', 0, NOW()),
('联系电话', 'text', 'input', 0, 'contact_phone', 0, '', 1, '', '平台联系电话', 0, NOW()),
('联系地址-中文', 'text', 'textarea', 0, 'contact_address_zh', 0, '', 1, '', '平台联系地址-中文', 0, NOW()),
('联系地址-英文', 'text', 'textarea', 0, 'contact_address_en', 0, '', 1, '', '平台联系地址-英文', 0, NOW()),
('联系地址-俄语', 'text', 'textarea', 0, 'contact_address_ru', 0, '', 1, '', '平台联系地址-俄语', 0, NOW()),
('联系地址-阿拉伯语', 'text', 'textarea', 0, 'contact_address_ar', 0, '', 1, '', '平台联系地址-阿拉伯语', 0, NOW())
ON DUPLICATE KEY UPDATE value=value;

-- 为常用系统配置添加多语言版本
INSERT INTO eb_system_config (menu_name, type, input_type, config_tab_id, parameter, upload_type, required, status, value, info, sort, create_time)
VALUES
('网站名称-英文', 'text', 'input', 0, 'site_name_en', 0, '', 1, '', '网站名称-英文', 0, NOW()),
('网站名称-俄语', 'text', 'input', 0, 'site_name_ru', 0, '', 1, '', '网站名称-俄语', 0, NOW()),
('网站名称-阿拉伯语', 'text', 'input', 0, 'site_name_ar', 0, '', 1, '', '网站名称-阿拉伯语', 0, NOW()),
('SEO关键词-英文', 'text', 'textarea', 0, 'site_keywords_en', 0, '', 1, '', 'SEO关键词-英文', 0, NOW()),
('SEO关键词-俄语', 'text', 'textarea', 0, 'site_keywords_ru', 0, '', 1, '', 'SEO关键词-俄语', 0, NOW()),
('SEO关键词-阿拉伯语', 'text', 'textarea', 0, 'site_keywords_ar', 0, '', 1, '', 'SEO关键词-阿拉伯语', 0, NOW()),
('SEO描述-英文', 'text', 'textarea', 0, 'site_description_en', 0, '', 1, '', 'SEO描述-英文', 0, NOW()),
('SEO描述-俄语', 'text', 'textarea', 0, 'site_description_ru', 0, '', 1, '', 'SEO描述-俄语', 0, NOW()),
('SEO描述-阿拉伯语', 'text', 'textarea', 0, 'site_description_ar', 0, '', 1, '', 'SEO描述-阿拉伯语', 0, NOW()),
('页脚版权-英文', 'text', 'textarea', 0, 'footer_copyright_en', 0, '', 1, '', '页脚版权信息-英文', 0, NOW()),
('页脚版权-俄语', 'text', 'textarea', 0, 'footer_copyright_ru', 0, '', 1, '', '页脚版权信息-俄语', 0, NOW()),
('页脚版权-阿拉伯语', 'text', 'textarea', 0, 'footer_copyright_ar', 0, '', 1, '', '页脚版权信息-阿拉伯语', 0, NOW())
ON DUPLICATE KEY UPDATE value=value;

-- TODO: 实施时需要查询现有配置表，确认还有哪些配置需要多语言支持
-- 查询语句：SELECT * FROM eb_system_config WHERE status=1 ORDER BY sort;

-- ============================================
-- 第十一部分：修改翻译记录表 eb_translation
-- ============================================

ALTER TABLE eb_translation
ADD COLUMN token_count INT NOT NULL DEFAULT 0 COMMENT 'Token消耗数量' AFTER translated_text,
ADD COLUMN cost DECIMAL(10,4) NOT NULL DEFAULT 0.0000 COMMENT '翻译成本（美元）' AFTER token_count,
ADD COLUMN model_name VARCHAR(50) NOT NULL DEFAULT '' COMMENT '使用的模型名称' AFTER cost;

-- ============================================
-- 第十二部分：创建图片翻译记录表
-- 阿里规范：
-- 1. 主键id使用BIGINT UNSIGNED
-- 2. 必备字段：id, create_time, update_time
-- 3. 字段尽量NOT NULL
-- 4. 索引命名：idx_字段名
-- ============================================

CREATE TABLE IF NOT EXISTS eb_product_image_translation (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    product_id INT(11) NOT NULL COMMENT '商品ID',
    image_type VARCHAR(20) NOT NULL DEFAULT '' COMMENT '图片类型：slider-轮播图，detail-详情图',
    original_url VARCHAR(500) NOT NULL DEFAULT '' COMMENT '原始图片URL',
    image_index INT NOT NULL DEFAULT 0 COMMENT '图片索引（轮播图顺序）',

    zh_url VARCHAR(500) NOT NULL DEFAULT '' COMMENT '中文图片URL',
    en_url VARCHAR(500) NOT NULL DEFAULT '' COMMENT '英文图片URL',
    ru_url VARCHAR(500) NOT NULL DEFAULT '' COMMENT '俄语图片URL',
    ar_url VARCHAR(500) NOT NULL DEFAULT '' COMMENT '阿拉伯语图片URL',

    translation_status TINYINT(1) NOT NULL DEFAULT 0 COMMENT '翻译状态：0-未翻译，1-翻译中，2-翻译完成，3-翻译失败',
    error_message TEXT COMMENT '错误信息',

    mer_id INT(11) NOT NULL COMMENT '商家ID',
    is_active TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否有效：1-有效，0-失效（商品重新上传图片后旧记录失效）',

    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    PRIMARY KEY (id),
    INDEX idx_product_id (product_id),
    INDEX idx_image_type (image_type),
    INDEX idx_translation_status (translation_status),
    INDEX idx_mer_id (mer_id),
    INDEX idx_is_active (is_active),
    INDEX idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品图片翻译记录表';

-- ============================================
-- 第十三部分：优化索引
-- 阿里规范：索引命名 idx_字段名，联合索引 idx_字段1_字段2
-- ============================================

-- 商品表索引优化
ALTER TABLE eb_store_product
ADD INDEX idx_audit_status (audit_status),
ADD INDEX idx_translation_status (translation_status),
ADD INDEX idx_category_id_audit_status_is_show (category_id, audit_status, is_show);

-- 分类表索引优化
ALTER TABLE eb_product_category
ADD INDEX idx_translation_status (translation_status);

-- ============================================
-- 执行完成
-- ============================================

SELECT '数据库改造完成！符合阿里巴巴Java开发手册规范' AS message;
