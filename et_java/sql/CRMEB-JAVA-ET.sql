/*
Java 外贸版 1.2 版本 sql
平台管理 admin / 000000
商户管理 stivepeim@outlook.com / 000000
移动端 18292417675 / Abc37584
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for eb_activity_product
-- ----------------------------
DROP TABLE IF EXISTS `eb_activity_product`;
CREATE TABLE `eb_activity_product`  (
  `aid` int(11) NOT NULL COMMENT '活动id',
  `pro_id` int(11) NOT NULL COMMENT '商品id',
  `pro_image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '活动商品图片',
  `sort` int(5) NOT NULL DEFAULT 999 COMMENT '排序',
  PRIMARY KEY (`aid`, `pro_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '活动商品关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_activity_product
-- ----------------------------
INSERT INTO `eb_activity_product` VALUES (1, 6, '', 999);
INSERT INTO `eb_activity_product` VALUES (1, 7, '', 999);
INSERT INTO `eb_activity_product` VALUES (1, 8, '', 999);
INSERT INTO `eb_activity_product` VALUES (1, 9, '', 999);
INSERT INTO `eb_activity_product` VALUES (1, 10, '', 999);
INSERT INTO `eb_activity_product` VALUES (2, 6, '', 999);
INSERT INTO `eb_activity_product` VALUES (2, 8, '', 999);
INSERT INTO `eb_activity_product` VALUES (2, 9, '', 999);
INSERT INTO `eb_activity_product` VALUES (2, 10, '', 999);
INSERT INTO `eb_activity_product` VALUES (3, 4, '', 999);
INSERT INTO `eb_activity_product` VALUES (3, 5, '', 999);
INSERT INTO `eb_activity_product` VALUES (3, 6, '', 999);
INSERT INTO `eb_activity_product` VALUES (3, 7, '', 999);
INSERT INTO `eb_activity_product` VALUES (3, 8, '', 999);

-- ----------------------------
-- Table structure for eb_bill
-- ----------------------------
DROP TABLE IF EXISTS `eb_bill`;
CREATE TABLE `eb_bill`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '帐单id',
  `uid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户uid',
  `mer_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户id',
  `link_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '关联id',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '关联订单',
  `pm` int(2) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0 = 支出 1 = 获得',
  `amount` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '金额',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '类型：pay_order-订单支付,refund_order-订单退款',
  `mark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE,
  INDEX `pm`(`pm`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '帐单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_bill
-- ----------------------------

-- ----------------------------
-- Table structure for eb_browse_record
-- ----------------------------
DROP TABLE IF EXISTS `eb_browse_record`;
CREATE TABLE `eb_browse_record`  (
  `uid` int(11) NOT NULL DEFAULT 0 COMMENT '用户id',
  `product_id` int(11) NOT NULL DEFAULT 0 COMMENT '商品id',
  `date` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '日期：年-月-日',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`uid`, `product_id`) USING BTREE,
  INDEX `date`(`date`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '浏览记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_browse_record
-- ----------------------------
INSERT INTO `eb_browse_record` VALUES (6, 7, '2025-04-14', '2025-04-14 17:07:56');
INSERT INTO `eb_browse_record` VALUES (6, 8, '2025-04-14', '2025-04-14 17:09:06');
INSERT INTO `eb_browse_record` VALUES (6, 9, '2025-04-14', '2025-04-14 17:09:23');
INSERT INTO `eb_browse_record` VALUES (6, 10, '2025-04-16', '2025-04-16 11:20:48');
INSERT INTO `eb_browse_record` VALUES (6, 15, '2023-09-26', '2023-09-26 17:01:22');
INSERT INTO `eb_browse_record` VALUES (6, 16, '2023-09-27', '2023-09-27 16:48:06');
INSERT INTO `eb_browse_record` VALUES (6, 20, '2023-09-23', '2023-09-23 16:28:14');
INSERT INTO `eb_browse_record` VALUES (6, 21, '2023-09-23', '2023-09-23 16:15:27');
INSERT INTO `eb_browse_record` VALUES (7, 1, '2023-11-06', '2023-11-06 10:57:06');
INSERT INTO `eb_browse_record` VALUES (7, 4, '2025-04-15', '2025-04-15 16:46:06');
INSERT INTO `eb_browse_record` VALUES (7, 5, '2025-04-15', '2025-04-15 16:46:03');
INSERT INTO `eb_browse_record` VALUES (7, 6, '2025-04-16', '2025-04-16 10:17:32');
INSERT INTO `eb_browse_record` VALUES (7, 7, '2025-04-15', '2025-04-15 16:45:59');
INSERT INTO `eb_browse_record` VALUES (7, 8, '2025-04-15', '2025-04-15 16:45:57');

-- ----------------------------
-- Table structure for eb_category
-- ----------------------------
DROP TABLE IF EXISTS `eb_category`;
CREATE TABLE `eb_category`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父级ID',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '/0/' COMMENT '路径',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分类名称',
  `type` smallint(2) NULL DEFAULT 1 COMMENT '类型，2 附件分类， 4 设置分类，6 配置分类， ',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '地址',
  `extra` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '扩展字段 Jsos格式',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态, 1正常，0失效',
  `sort` int(5) NOT NULL DEFAULT 99999 COMMENT '排序',
  `owner` int(11) NULL DEFAULT -1 COMMENT '分类所属：-1平台，商户id',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `status+pid`(`pid`, `status`) USING BTREE,
  INDEX `id+status+url`(`path`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 854 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '分类表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_category
-- ----------------------------
INSERT INTO `eb_category` VALUES (81, 0, '/0/', '管理端后台配置', 6, 'pcAdmin config', '64', 1, 1, -1, '2020-05-20 10:02:57', '2022-06-10 17:38:16');
INSERT INTO `eb_category` VALUES (93, 81, '/0/81/', '站点配置', 6, '站点配置', '64', 1, 1, -1, '2020-05-21 11:04:20', '2022-04-28 14:20:15');
INSERT INTO `eb_category` VALUES (94, 100, '/0/100/', '客服配置', 6, '云智服', '76', 1, 1, -1, '2020-05-21 11:04:37', '2022-04-28 14:20:15');
INSERT INTO `eb_category` VALUES (95, 0, '/0/', '商城配置', 6, '商城配置', '139', 1, 2, -1, '2020-05-21 11:10:20', '2022-04-28 14:20:15');
INSERT INTO `eb_category` VALUES (96, 95, '/0/95/', '商城基础配置', 6, '商城基础配置', '77', 1, 1, -1, '2020-05-21 11:10:40', '2022-04-28 14:20:15');
INSERT INTO `eb_category` VALUES (100, 0, '/0/', '应用配置', 6, '应用配置', NULL, 1, 1, -1, '2020-05-21 12:31:49', '2022-04-28 14:20:16');
INSERT INTO `eb_category` VALUES (103, 0, '/0/', '支付配置', 6, '支付配置', '140', 1, 1, -1, '2020-05-21 12:33:36', '2022-04-28 14:20:16');
INSERT INTO `eb_category` VALUES (108, 0, '/0/', '文件上传配置', 6, '文件上传配置', NULL, 1, 1, -1, '2020-05-21 12:35:16', '2022-04-28 14:20:16');
INSERT INTO `eb_category` VALUES (109, 108, '/0/108/', '基础配置', 6, '基础配置', '108', 1, 1, -1, '2020-05-21 12:35:28', '2022-04-28 14:20:16');
INSERT INTO `eb_category` VALUES (110, 108, '/0/108/', '阿里云配置', 6, '阿里云配置', '81', 1, 1, -1, '2020-05-21 12:36:01', '2022-04-28 14:20:16');
INSERT INTO `eb_category` VALUES (111, 108, '/0/108/', '七牛云配置', 6, '七牛云配置', '82', 1, 1, -1, '2020-05-21 12:36:12', '2022-04-28 14:20:16');
INSERT INTO `eb_category` VALUES (112, 108, '/0/108/', '腾讯云配置', 6, '腾讯云配置', '83', 1, 1, -1, '2020-05-21 12:36:22', '2022-04-28 14:20:16');
INSERT INTO `eb_category` VALUES (500, 0, '/0/', '第三方接口设置', 6, 'short_letter_switch', NULL, 1, 1, -1, '2020-12-10 10:58:25', '2022-04-28 14:20:16');
INSERT INTO `eb_category` VALUES (501, 500, '/0/500/', '短信配置', 6, 'short_letter_switch', '111', 1, 1, -1, '2020-12-10 10:59:08', '2022-04-28 14:20:16');
INSERT INTO `eb_category` VALUES (503, 500, '/0/500/', '阿里云物流查询', 6, 'logistics_select', '128', 1, 1, -1, '2020-12-10 11:00:51', '2022-04-28 14:20:17');
INSERT INTO `eb_category` VALUES (693, 500, '/0/500/', '小票打印(易联云)', 6, 'yilianyun', '143', 1, 1, -1, '2021-11-27 16:10:47', '2022-04-28 14:20:17');
INSERT INTO `eb_category` VALUES (720, 0, '/0/', '金刚区', 2, 'url', NULL, 0, 3, -1, '2021-12-25 10:33:41', '2022-04-22 12:06:36');
INSERT INTO `eb_category` VALUES (741, 103, '/0/103/', 'Paypal支付', 6, 'Paypal', '147', 1, 1, -1, '2022-01-22 16:14:49', '2022-04-28 14:20:17');
INSERT INTO `eb_category` VALUES (742, 100, '/0/100/', 'Facebook', 6, 'Meta(Facebook)', '144', 1, 1, -1, '2022-01-22 16:17:29', '2022-04-28 14:20:17');
INSERT INTO `eb_category` VALUES (743, 100, '/0/100/', 'Twitter', 6, 'Twitter', '145', 1, 1, -1, '2022-01-22 16:17:55', '2022-04-28 14:20:17');
INSERT INTO `eb_category` VALUES (744, 100, '/0/100/', 'Goggle', 6, 'Goggle', '146', 1, 1, -1, '2022-01-22 16:18:16', '2022-04-28 14:20:17');
INSERT INTO `eb_category` VALUES (745, 100, '/0/100/', '游客', 6, 'visitor', '148', 1, 1, -1, '2022-02-11 18:30:48', '2022-04-28 14:20:17');
INSERT INTO `eb_category` VALUES (752, 100, '/0/100/', '商品复制', 6, '商品复制', '122', 1, 1, -1, '2022-03-31 09:44:40', '2022-04-28 14:20:17');
INSERT INTO `eb_category` VALUES (768, 0, '/0/', 'logo', 2, 'url', NULL, 0, 1, -1, '2022-04-25 12:04:44', '2022-04-28 12:24:52');
INSERT INTO `eb_category` VALUES (772, 0, '/0/', '大图首页', 2, 'url', NULL, 0, 1, -1, '2022-04-29 15:47:11', '2022-04-29 15:47:11');
INSERT INTO `eb_category` VALUES (774, 0, '/0/', '商品图片', 2, 'url', NULL, 0, 1, -1, '2022-05-11 17:28:31', '2022-05-11 17:28:31');
INSERT INTO `eb_category` VALUES (781, 0, '/0/', '商品图片', 2, 'url', NULL, 0, 1, 3, '2022-05-13 16:28:59', '2022-05-13 16:28:59');
INSERT INTO `eb_category` VALUES (782, 0, '/0/', 'Test', 2, 'url', NULL, 0, 1, 3, '2022-05-13 16:31:28', '2022-05-13 16:31:28');
INSERT INTO `eb_category` VALUES (783, 781, '/0/781/', '蔬菜', 2, 'url', NULL, 0, 1, 3, '2022-05-13 16:32:25', '2022-05-13 16:32:25');
INSERT INTO `eb_category` VALUES (787, 95, '/0/95/', 'PC商城配置', 6, 'PC商城配置', '163', 1, 1, -1, '2022-05-23 17:32:35', '2022-05-23 17:40:42');
INSERT INTO `eb_category` VALUES (791, 0, '/0/', '商品分类', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:28:46', '2022-06-06 14:28:46');
INSERT INTO `eb_category` VALUES (792, 791, '/0/791/', 'CONSUMER ELECTRONICS', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:29:11', '2022-06-06 14:29:11');
INSERT INTO `eb_category` VALUES (793, 791, '/0/791/', 'APPAREL & LINGERIE', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:29:28', '2022-06-06 14:29:28');
INSERT INTO `eb_category` VALUES (794, 791, '/0/791/', 'HOME APPLIANCE', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:29:41', '2022-06-06 14:29:41');
INSERT INTO `eb_category` VALUES (795, 791, '/0/791/', 'SPORTS & OUTDOORS', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:29:55', '2022-06-06 14:29:55');
INSERT INTO `eb_category` VALUES (796, 791, '/0/791/', 'HOME & PET SUPPLIES', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:30:08', '2022-06-06 14:30:08');
INSERT INTO `eb_category` VALUES (797, 792, '/0/791/792/', 'Accessories', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:31:01', '2022-06-06 14:31:01');
INSERT INTO `eb_category` VALUES (798, 792, '/0/791/792/', 'Entertainments', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:47:20', '2022-06-06 14:47:20');
INSERT INTO `eb_category` VALUES (799, 792, '/0/791/792/', 'Protectors', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:47:36', '2022-06-06 14:47:36');
INSERT INTO `eb_category` VALUES (800, 792, '/0/791/792/', 'Communication', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:47:48', '2022-06-06 14:47:48');
INSERT INTO `eb_category` VALUES (801, 792, '/0/791/792/', 'Connected health', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:48:01', '2022-06-06 14:48:01');
INSERT INTO `eb_category` VALUES (802, 792, '/0/791/792/', 'Gaming', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:48:15', '2022-06-06 14:48:15');
INSERT INTO `eb_category` VALUES (803, 793, '/0/791/793/', 'Pajamas & socks', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:49:12', '2022-06-06 14:49:12');
INSERT INTO `eb_category` VALUES (804, 793, '/0/791/793/', 'Apparel & accessories', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:49:40', '2022-06-06 14:49:40');
INSERT INTO `eb_category` VALUES (805, 793, '/0/791/793/', 'Bottoms', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:50:08', '2022-06-06 14:50:08');
INSERT INTO `eb_category` VALUES (806, 793, '/0/791/793/', 'Lingerie', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:50:23', '2022-06-06 14:50:23');
INSERT INTO `eb_category` VALUES (807, 793, '/0/791/793/', 'Dress', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:50:36', '2022-06-06 14:50:36');
INSERT INTO `eb_category` VALUES (808, 793, '/0/791/793/', 'T-shirt', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:50:48', '2022-06-06 14:50:48');
INSERT INTO `eb_category` VALUES (809, 794, '/0/791/794/', 'Personal care', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:51:13', '2022-06-06 14:51:13');
INSERT INTO `eb_category` VALUES (810, 794, '/0/791/794/', 'Living room', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:51:28', '2022-06-06 14:51:28');
INSERT INTO `eb_category` VALUES (811, 794, '/0/791/794/', 'Dessert', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:51:41', '2022-06-06 14:51:41');
INSERT INTO `eb_category` VALUES (812, 794, '/0/791/794/', 'Beverage', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:51:55', '2022-06-06 14:51:55');
INSERT INTO `eb_category` VALUES (813, 794, '/0/791/794/', 'Processor', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:52:08', '2022-06-06 14:52:08');
INSERT INTO `eb_category` VALUES (814, 794, '/0/791/794/', 'Top sales', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:52:22', '2022-06-06 14:52:22');
INSERT INTO `eb_category` VALUES (815, 795, '/0/791/795/', 'Water sports', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:52:37', '2022-06-06 14:52:37');
INSERT INTO `eb_category` VALUES (816, 795, '/0/791/795/', 'Yoga suit', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:52:53', '2022-06-06 14:52:53');
INSERT INTO `eb_category` VALUES (817, 795, '/0/791/795/', 'Team Sports', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:53:49', '2022-06-06 14:53:49');
INSERT INTO `eb_category` VALUES (818, 795, '/0/791/795/', 'Outdoor sports', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:54:22', '2022-06-06 14:54:22');
INSERT INTO `eb_category` VALUES (819, 795, '/0/791/795/', 'Fitness & body building', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:54:48', '2022-06-06 14:54:48');
INSERT INTO `eb_category` VALUES (820, 795, '/0/791/795/', 'Top sales SP', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:55:29', '2022-06-06 14:55:29');
INSERT INTO `eb_category` VALUES (821, 796, '/0/791/796/', 'Pet supplies', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:56:59', '2022-06-06 14:56:59');
INSERT INTO `eb_category` VALUES (822, 796, '/0/791/796/', 'Bedding', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:57:31', '2022-06-06 14:57:31');
INSERT INTO `eb_category` VALUES (823, 796, '/0/791/796/', 'Organize', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:57:59', '2022-06-06 14:57:59');
INSERT INTO `eb_category` VALUES (824, 796, '/0/791/796/', 'Cookware', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:58:25', '2022-06-06 14:58:25');
INSERT INTO `eb_category` VALUES (825, 796, '/0/791/796/', 'Yiwu industry hub', 2, 'url', NULL, 0, 1, -1, '2022-06-06 14:59:03', '2022-06-06 14:59:03');
INSERT INTO `eb_category` VALUES (826, 796, '/0/791/796/', 'Top sales HP', 2, 'url', NULL, 0, 1, -1, '2022-06-06 15:02:02', '2022-06-06 15:02:02');
INSERT INTO `eb_category` VALUES (827, 103, '/0/103/', 'Stripe支付', 6, 'Stripe支付', '164', 1, 1, -1, '2022-06-06 17:31:02', '2022-06-06 17:31:10');
INSERT INTO `eb_category` VALUES (828, 0, '/0/', 'Cactray', 2, 'url', NULL, 0, 1, 4, '2022-06-07 10:17:18', '2022-06-07 10:17:18');
INSERT INTO `eb_category` VALUES (829, 0, '/0/', 'Products', 2, 'url', NULL, 0, 1, 4, '2022-06-07 10:24:39', '2022-06-07 10:24:39');
INSERT INTO `eb_category` VALUES (830, 829, '/0/829/', 'musicCap', 2, 'url', NULL, 0, 1, 4, '2022-06-07 10:24:44', '2022-06-07 10:24:44');
INSERT INTO `eb_category` VALUES (831, 834, '/0/834/', 'PC 首页轮播图', 2, 'url', NULL, 0, 1, -1, '2022-06-07 10:49:07', '2022-06-08 09:44:50');
INSERT INTO `eb_category` VALUES (832, 829, '/0/829/', 'miniBag', 2, 'url', NULL, 0, 1, 4, '2022-06-07 12:19:57', '2022-06-07 12:19:57');
INSERT INTO `eb_category` VALUES (833, 829, '/0/829/', 'Backpack', 2, 'url', NULL, 0, 1, 4, '2022-06-07 12:30:44', '2022-06-07 12:30:44');
INSERT INTO `eb_category` VALUES (834, 0, '/0/', 'PC 版面素材', 2, 'url', NULL, 0, 1, -1, '2022-06-08 09:44:34', '2022-06-08 09:44:34');
INSERT INTO `eb_category` VALUES (835, 834, '/0/834/', 'PC 活动banner', 2, 'url', NULL, 0, 1, -1, '2022-06-08 09:45:49', '2022-06-08 09:45:49');
INSERT INTO `eb_category` VALUES (836, 834, '/0/834/', 'PC 店铺街', 2, 'url', NULL, 0, 1, -1, '2022-06-08 09:46:07', '2022-06-08 09:46:07');
INSERT INTO `eb_category` VALUES (837, 829, '/0/829/', 'Durable men', 2, 'url', NULL, 0, 1, 4, '2022-06-08 10:30:31', '2022-06-08 10:30:31');
INSERT INTO `eb_category` VALUES (838, 829, '/0/829/', 'Mens Stainless', 2, 'url', NULL, 0, 1, 4, '2022-06-08 10:36:35', '2022-06-08 10:36:35');
INSERT INTO `eb_category` VALUES (839, 829, '/0/829/', 'Noise Cancelling', 2, 'url', NULL, 0, 1, 4, '2022-06-08 10:48:29', '2022-06-08 10:48:29');
INSERT INTO `eb_category` VALUES (840, 829, '/0/829/', 'Best Sellers In Ear ', 2, 'url', NULL, 0, 1, 4, '2022-06-08 10:51:41', '2022-06-08 10:51:41');
INSERT INTO `eb_category` VALUES (841, 0, '/0/', '店铺素材', 2, 'url', NULL, 0, 1, 4, '2022-06-08 11:07:01', '2022-06-08 11:07:01');
INSERT INTO `eb_category` VALUES (842, 0, '/0/', '推荐竖图', 2, 'url', NULL, 0, 1, -1, '2022-06-08 15:12:10', '2022-06-08 15:12:10');
INSERT INTO `eb_category` VALUES (843, 829, '/0/829/', 'Pool Hi-Gloss', 2, 'url', NULL, 0, 1, 4, '2022-06-08 18:24:43', '2022-06-08 18:24:43');
INSERT INTO `eb_category` VALUES (844, 0, '/0/', '商户背景', 2, 'url', NULL, 0, 1, 2, '2022-06-16 11:41:24', '2022-06-16 11:41:24');
INSERT INTO `eb_category` VALUES (845, 0, '/0/', '门店素材', 2, 'url', NULL, 0, 9, 1, '2022-06-17 17:25:39', '2022-06-17 17:25:39');
INSERT INTO `eb_category` VALUES (846, 0, '/0/', '商品素材', 2, 'url', NULL, 0, 8, 1, '2022-06-17 17:25:51', '2022-06-17 17:25:51');
INSERT INTO `eb_category` VALUES (847, 0, '/0/', '订单状态', 2, 'url', NULL, 0, 1, -1, '2022-06-18 15:38:56', '2022-06-18 15:38:56');
INSERT INTO `eb_category` VALUES (848, 0, '/0/', 'Banner', 2, 'url', NULL, 0, 1, -1, '2022-06-18 15:52:11', '2022-06-18 15:52:11');
INSERT INTO `eb_category` VALUES (849, 0, '/0/', '分类', 2, 'url', NULL, 0, 1, 2, '2022-06-18 18:05:05', '2022-06-18 18:05:05');
INSERT INTO `eb_category` VALUES (850, 0, '/0/', '商品图', 2, 'url', NULL, 0, 1, 15, '2023-08-04 15:14:16', '2023-08-04 15:14:16');
INSERT INTO `eb_category` VALUES (851, 0, '/0/', '个人头像图片', 2, 'url', NULL, 0, 2, 15, '2023-08-04 15:14:29', '2023-08-04 15:14:39');
INSERT INTO `eb_category` VALUES (852, 103, '/0/103/', '微信支付', 6, 'wechatPay', '165', 1, 1, -1, '2023-08-07 09:59:49', '2023-08-07 10:00:20');
INSERT INTO `eb_category` VALUES (853, 0, '/0/', '服饰', 2, 'url', NULL, 0, 1, 22, '2023-08-15 14:53:50', '2023-08-15 14:53:50');

-- ----------------------------
-- Table structure for eb_community_author_concerned
-- ----------------------------
DROP TABLE IF EXISTS `eb_community_author_concerned`;
CREATE TABLE `eb_community_author_concerned`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `author_id` int(11) UNSIGNED NOT NULL COMMENT '作者ID',
  `uid` int(11) UNSIGNED NOT NULL COMMENT '用户ID',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uniq_data`(`author_id`, `uid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 99 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '社区作者关注表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_community_author_concerned
-- ----------------------------
INSERT INTO `eb_community_author_concerned` VALUES (1, 8, 1, '2023-08-09 17:27:50');
INSERT INTO `eb_community_author_concerned` VALUES (2, 1, 5, '2023-12-24 09:47:41');
INSERT INTO `eb_community_author_concerned` VALUES (3, 1, 22, '2024-01-27 10:39:30');
INSERT INTO `eb_community_author_concerned` VALUES (6, 5, 38, '2024-04-07 11:06:16');
INSERT INTO `eb_community_author_concerned` VALUES (8, 15, 116, '2024-10-09 11:28:05');
INSERT INTO `eb_community_author_concerned` VALUES (11, 96, 78, '2024-11-26 17:35:28');
INSERT INTO `eb_community_author_concerned` VALUES (31, 15, 93, '2024-12-20 15:25:35');
INSERT INTO `eb_community_author_concerned` VALUES (57, 104, 140, '2024-12-24 18:43:22');
INSERT INTO `eb_community_author_concerned` VALUES (59, 92, 93, '2024-12-25 10:26:37');
INSERT INTO `eb_community_author_concerned` VALUES (61, 93, 92, '2024-12-25 10:26:47');
INSERT INTO `eb_community_author_concerned` VALUES (63, 15, 104, '2024-12-25 11:42:35');
INSERT INTO `eb_community_author_concerned` VALUES (64, 92, 147, '2024-12-26 17:13:37');
INSERT INTO `eb_community_author_concerned` VALUES (65, 93, 147, '2024-12-26 17:13:38');
INSERT INTO `eb_community_author_concerned` VALUES (66, 8, 93, '2024-12-27 14:49:31');
INSERT INTO `eb_community_author_concerned` VALUES (67, 92, 22, '2024-12-27 16:21:38');
INSERT INTO `eb_community_author_concerned` VALUES (68, 93, 22, '2024-12-27 16:21:38');
INSERT INTO `eb_community_author_concerned` VALUES (69, 96, 22, '2024-12-27 16:21:41');
INSERT INTO `eb_community_author_concerned` VALUES (70, 104, 22, '2024-12-27 16:21:42');
INSERT INTO `eb_community_author_concerned` VALUES (71, 15, 22, '2024-12-27 16:21:44');
INSERT INTO `eb_community_author_concerned` VALUES (72, 8, 22, '2024-12-27 16:21:46');
INSERT INTO `eb_community_author_concerned` VALUES (74, 92, 6, '2025-04-09 10:50:22');
INSERT INTO `eb_community_author_concerned` VALUES (76, 93, 6, '2025-04-09 14:42:01');

-- ----------------------------
-- Table structure for eb_community_category
-- ----------------------------
DROP TABLE IF EXISTS `eb_community_category`;
CREATE TABLE `eb_community_category`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父级ID',
  `name` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '分类名称',
  `is_show` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '是否显示：1-显示，0-不显示',
  `sort` int(6) NOT NULL DEFAULT 0 COMMENT '排序',
  `is_del` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除，0-未删除，1-删除',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '社区分类表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_community_category
-- ----------------------------
INSERT INTO `eb_community_category` VALUES (1, 0, '美食', 1, 0, 0, '2023-08-03 17:26:47', '2023-08-03 17:26:47');
INSERT INTO `eb_community_category` VALUES (2, 0, '旅游', 1, 0, 0, '2023-08-03 17:26:56', '2023-08-03 17:26:56');
INSERT INTO `eb_community_category` VALUES (4, 0, '生活', 1, 1, 0, '2023-08-03 17:27:15', '2023-08-03 17:27:15');
INSERT INTO `eb_community_category` VALUES (5, 0, '团购', 1, 0, 0, '2023-08-07 18:01:26', '2023-08-07 18:01:26');
INSERT INTO `eb_community_category` VALUES (6, 0, '风景', 1, 0, 0, '2024-12-20 11:13:02', '2024-12-20 11:13:02');
INSERT INTO `eb_community_category` VALUES (7, 0, '服装搭配', 1, 0, 0, '2024-12-20 11:13:47', '2024-12-20 11:13:47');
INSERT INTO `eb_community_category` VALUES (8, 0, '探店美食', 1, 0, 0, '2024-12-20 11:13:59', '2024-12-20 11:13:59');

-- ----------------------------
-- Table structure for eb_community_notes
-- ----------------------------
DROP TABLE IF EXISTS `eb_community_notes`;
CREATE TABLE `eb_community_notes`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '标题',
  `type` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '笔记类型：1-图文，2-视频',
  `cover` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '封面',
  `image` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图片',
  `video` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '视频链接',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '笔记正文',
  `category_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '社区分类ID',
  `topic_ids` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '话题ID,英文逗号拼接',
  `uid` int(11) NOT NULL DEFAULT 0 COMMENT '用户ID',
  `star` tinyint(1) NULL DEFAULT 1 COMMENT '星级排序:1-5',
  `audit_status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '审核状态:0-待审核，1-审核通过，2-审核失败，3-平台关闭',
  `refusal` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '拒绝理由',
  `like_num` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '点赞数',
  `reply_num` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '评论数',
  `share_num` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '分享数',
  `views` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '浏览量',
  `sort` int(6) NOT NULL DEFAULT 0 COMMENT '排序',
  `reply_status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '是否开启评论，1-开启，2-关闭，3-平台关闭',
  `is_del` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除，0-未删除，1-删除',
  `operate_time` timestamp NULL DEFAULT NULL COMMENT '操作时间',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_uid`(`uid`) USING BTREE,
  INDEX `idx_front`(`type`, `audit_status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 85 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '社区笔记表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_community_notes
-- ----------------------------
INSERT INTO `eb_community_notes` VALUES (66, '审核审核', 2, 'crmebimage/public/product/2025/04/12/3b7b5c31d03940769c5f6f15597a7788ohf84pw3n9.png', '', 'uploadf/public/product/2025/04/12/7d46f5f6e2b043cd925013cb9ade7341a1ci7t9edf.mp4', '内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容99999999999内容内容内容内容内容内容内容内容9内容内容9999内容', 8, '', 6, 1, 0, NULL, 0, 0, 0, '0', 0, 1, 1, NULL, '2025-04-12 11:12:21', '2025-04-12 11:12:21');
INSERT INTO `eb_community_notes` VALUES (67, '', 1, 'crmebimage/public/product/2025/04/15/60efb5d83a7c40a0b7416dd1a92267d0u8u73glh5j.png', 'crmebimage/public/product/2025/04/15/60efb5d83a7c40a0b7416dd1a92267d0u8u73glh5j.png', '', '123', 4, '', 7, 1, 1, NULL, 0, 0, 0, '0', 0, 1, 1, NULL, '2025-04-15 09:45:53', '2025-04-15 09:45:53');
INSERT INTO `eb_community_notes` VALUES (68, '测试', 1, 'crmebimage/public/product/2025/04/15/70bc5d6f6767467fb847f4f5584fd97atzcsmcakjx.png', 'crmebimage/public/product/2025/04/15/70bc5d6f6767467fb847f4f5584fd97atzcsmcakjx.png,crmebimage/public/product/2025/04/15/ae395a4445114c3a9802e8e997769148dru5dh9776.png', '', '测试', 4, '', 7, 1, 0, NULL, 0, 0, 0, '0', 0, 1, 1, NULL, '2025-04-15 09:52:01', '2025-04-15 09:52:01');
INSERT INTO `eb_community_notes` VALUES (69, '测试', 2, 'crmebimage/public/product/2025/04/15/8697f2345776494d80a92b304fdafd816teovgqv4f.png', '', 'uploadf/public/product/2025/04/15/daced90de47148deab0567e0982a1ccdiwrai1uddw.mp4', '测试', 4, '', 7, 1, 1, NULL, 0, 0, 0, '0', 0, 1, 1, NULL, '2025-04-15 10:06:15', '2025-04-15 10:06:15');
INSERT INTO `eb_community_notes` VALUES (70, '待审核图片', 1, 'crmebimage/public/product/2025/04/15/1ba4440a5b654f39a451c95e5dddbafa69we34ipna.png', 'crmebimage/public/product/2025/04/15/1ba4440a5b654f39a451c95e5dddbafa69we34ipna.png', '', '待审核图片', 4, '', 7, 1, 2, '不能', 0, 0, 0, '0', 0, 2, 0, '2025-04-16 09:22:02', '2025-04-15 10:08:02', '2025-04-15 10:08:02');
INSERT INTO `eb_community_notes` VALUES (71, '待审核视频', 2, 'crmebimage/public/product/2025/04/15/f748c0888dda4918aaae2b0e8c61b17dk6p6p13ojr.png', '', 'uploadf/public/product/2025/04/15/4746bf116a034f24b44634ac4da42a96chvjl4n1zg.mp4', '待审核视频', 8, '', 7, 1, 0, NULL, 0, 0, 0, '0', 0, 1, 0, NULL, '2025-04-15 10:09:12', '2025-04-15 10:09:12');
INSERT INTO `eb_community_notes` VALUES (72, '图片发布', 1, 'crmebimage/public/product/2025/04/15/b1edaa64b38f4f8388f9b15bd01b1423lp0iu7qhzl.png', 'crmebimage/public/product/2025/04/15/b1edaa64b38f4f8388f9b15bd01b1423lp0iu7qhzl.png,crmebimage/public/product/2025/04/15/d1bd39d366964aa4b8b578a6fb6d04c0fh0nmvn3x0.png', '', '图片发布', 4, '', 7, 1, 1, NULL, 2, 2, 0, '0', 0, 1, 0, NULL, '2025-04-15 10:10:00', '2025-04-15 10:40:42');
INSERT INTO `eb_community_notes` VALUES (73, '标题最大值标题最大值标题最大值标题最大值', 1, 'crmebimage/public/product/2025/04/15/a5e149257a124004828f1c5fe5adbbb9o6yvv5k7n2.png', 'crmebimage/public/product/2025/04/15/a5e149257a124004828f1c5fe5adbbb9o6yvv5k7n2.png,crmebimage/public/product/2025/04/15/75657611a7fe47829f2be1e6651e60eegkg6t954s9.png,crmebimage/public/product/2025/04/15/c113083c47ae45ffbe307797ec3f8c506ztqjh6wnc.png,crmebimage/public/product/2025/04/15/7891bd6771c14a4f9d781cfe60cc0e8ad5s0chght6.png,crmebimage/public/product/2025/04/15/252644d85a5944aa8058df59c9edec27n8gzg1pfb1.png,crmebimage/public/product/2025/04/15/324248dcdac440d680e6ea41c3723869ldm6iszfye.png', '', '标题最大值', 1, '7,6,5,4,3', 7, 1, 1, NULL, 0, 2, 0, '0', 0, 1, 0, NULL, '2025-04-15 10:54:31', '2025-04-16 10:56:41');
INSERT INTO `eb_community_notes` VALUES (74, '123', 2, 'crmebimage/public/product/2025/04/15/82df7ed9ca7c49209787d43882f3b34chplo3cdysc.png', '', 'uploadf/public/product/2025/04/15/8f48d50ca39943f9a3ddca232598af4bmxe1ruwl8r.mp4', '123', 4, '', 6, 1, 1, NULL, 1, 0, 0, '0', 0, 1, 1, NULL, '2025-04-15 11:33:12', '2025-04-15 14:49:14');
INSERT INTO `eb_community_notes` VALUES (75, '记录文章次数', 1, 'crmebimage/public/product/2025/04/15/798a6a62252746b882f68099a1927999cdynh1iom2.png', 'crmebimage/public/product/2025/04/15/798a6a62252746b882f68099a1927999cdynh1iom2.png,crmebimage/public/product/2025/04/15/24b56e1cad2f420ea4e8657f0573e3b4ikoz1hpq3g.png', '', '后台文章次数显示', 8, '7', 7, 1, 1, NULL, 1, 2, 0, '0', 0, 1, 0, NULL, '2025-04-15 14:25:40', '2025-04-16 10:45:27');
INSERT INTO `eb_community_notes` VALUES (76, '测试一下', 1, 'crmebimage/public/product/2025/04/15/5045075552484738953632a3422553ff7j44avbrd8.jpg', 'crmebimage/public/product/2025/04/15/5045075552484738953632a3422553ff7j44avbrd8.jpg', '', '测试一下', 8, '', 6, 1, 1, NULL, 0, 1, 0, '0', 0, 1, 1, NULL, '2025-04-15 14:28:14', '2025-04-15 15:23:13');
INSERT INTO `eb_community_notes` VALUES (77, '视频', 2, 'crmebimage/public/product/2025/04/15/c2850bf709084abdb9f68ffc0183b05av6ljmp66wh.png', '', 'uploadf/public/product/2025/04/15/15f5a0822753455fade1628b98820d32x6pzlfayqy.mp4', '字数写多点看有没有展开和收起按钮样式；字数写多点看有没有展开和收起按钮样式；字数写多点看有没有展开和收起按钮样式；字数写多点看有没有展开和收起按钮样式；字数写多点看有没有展开和收起按钮样式；字数写多点看有没有展开和收起按钮样式；字数写多点看有没有展开和收起按钮样式；字数写多点看有没有展开和收起按钮样式；', 7, '3,4,5,6,7', 7, 1, 1, NULL, 1, 4, 0, '0', 0, 1, 0, NULL, '2025-04-15 14:30:59', '2025-04-16 11:20:05');
INSERT INTO `eb_community_notes` VALUES (78, 'zzp测试', 2, 'crmebimage/public/product/2025/04/15/c6a5ca8157cd43ebbe18334a4bf641b2925hkt4b9g.png', '', 'uploadf/public/product/2025/04/15/31823c0134a44120a0f745524c5c46b47qcahbwg81.mp4', 'zzp测试', 4, '7,1', 6, 1, 1, NULL, 0, 0, 0, '0', 0, 2, 0, NULL, '2025-04-15 16:23:02', '2025-04-16 11:20:00');
INSERT INTO `eb_community_notes` VALUES (79, '测下关联商品', 2, 'crmebimage/public/product/2025/04/15/5774ae1ed3514348b0fef1b7a909a9e3iqsrml1tm9.png', '', 'uploadf/public/product/2025/04/15/a76359e27ca54d429a8525d435a940b6c1ryui2dmi.mp4', '测下关联商品', 8, '', 6, 1, 1, NULL, 1, 0, 0, '0', 0, 1, 0, NULL, '2025-04-15 16:39:10', '2025-04-16 11:20:15');
INSERT INTO `eb_community_notes` VALUES (80, '测下多图', 1, 'crmebimage/public/product/2025/04/15/010cfc482a954d0c81c3e8994eb33ac0ojfeu6osgo.jpg', 'crmebimage/public/product/2025/04/15/010cfc482a954d0c81c3e8994eb33ac0ojfeu6osgo.jpg,crmebimage/public/product/2025/04/15/c0c47a27014b440586ecf65cc4310b8flqgwriigy1.jpg,crmebimage/public/product/2025/04/15/399ecce31e7340ff85764617630f054cdnic4l37s9.jpg,crmebimage/public/product/2025/04/15/f04d8c25014d48239c6133a6effe2f3f5gb78cm4yr.png', '', '测下多图', 7, '', 6, 1, 1, NULL, 0, 0, 0, '0', 0, 1, 0, NULL, '2025-04-15 17:07:56', '2025-04-15 17:07:56');
INSERT INTO `eb_community_notes` VALUES (81, '测下审核', 2, 'crmebimage/public/product/2025/04/16/28cdb8e318074a91a5da9ac121af8a2dx556o78ye7.png', '', 'uploadf/public/product/2025/04/16/44bc4daf59114eb7a1bb686e40d55a0bys2rtg5ose.mp4', '测下审核', 11, '', 6, 1, 0, NULL, 0, 0, 0, '0', 0, 1, 0, NULL, '2025-04-16 10:23:58', '2025-04-16 10:23:58');
INSERT INTO `eb_community_notes` VALUES (82, '123', 1, 'crmebimage/public/product/2025/04/16/88decd0e2bc24edc807defa2a601bb2dzbjhodgx6g.png', 'crmebimage/public/product/2025/04/16/88decd0e2bc24edc807defa2a601bb2dzbjhodgx6g.png', '', '123', 11, '', 7, 1, 0, NULL, 0, 0, 0, '0', 0, 1, 0, NULL, '2025-04-16 10:40:30', '2025-04-16 10:40:30');
INSERT INTO `eb_community_notes` VALUES (83, '多个商品', 1, 'crmebimage/public/product/2025/04/16/4a94003a58fd4450b0851dfdc780ed2dn7hcc5qg5y.jpg', 'crmebimage/public/product/2025/04/16/4a94003a58fd4450b0851dfdc780ed2dn7hcc5qg5y.jpg', '', '多个商品', 4, '', 6, 1, 2, '不能', 0, 0, 0, '0', 0, 1, 0, '2025-04-16 11:58:39', '2025-04-16 11:43:10', '2025-04-16 11:43:10');
INSERT INTO `eb_community_notes` VALUES (84, '测下样式', 1, 'crmebimage/public/product/2025/04/16/c23a29543015475ba947939c5990b58669f85ulmlx.png', 'crmebimage/public/product/2025/04/16/c23a29543015475ba947939c5990b58669f85ulmlx.png', '', '测下样式', 11, '', 6, 1, 0, NULL, 0, 0, 0, '0', 0, 1, 0, NULL, '2025-04-16 16:36:16', '2025-04-16 16:36:16');

-- ----------------------------
-- Table structure for eb_community_notes_product
-- ----------------------------
DROP TABLE IF EXISTS `eb_community_notes_product`;
CREATE TABLE `eb_community_notes_product`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `note_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '笔记ID',
  `product_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商品ID',
  `is_pay` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否购买：0-未购买，1-已购买',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_note_id`(`note_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 131 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '社区笔记商品表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_community_notes_product
-- ----------------------------
INSERT INTO `eb_community_notes_product` VALUES (115, 78, 10, 0, '2025-04-15 16:23:02');
INSERT INTO `eb_community_notes_product` VALUES (116, 79, 4, 0, '2025-04-15 16:39:10');
INSERT INTO `eb_community_notes_product` VALUES (117, 79, 5, 0, '2025-04-15 16:39:10');
INSERT INTO `eb_community_notes_product` VALUES (118, 79, 9, 0, '2025-04-15 16:39:10');
INSERT INTO `eb_community_notes_product` VALUES (119, 77, 4, 0, '2025-04-15 16:48:45');
INSERT INTO `eb_community_notes_product` VALUES (120, 77, 5, 0, '2025-04-15 16:48:45');
INSERT INTO `eb_community_notes_product` VALUES (121, 77, 7, 0, '2025-04-15 16:48:45');
INSERT INTO `eb_community_notes_product` VALUES (122, 77, 8, 0, '2025-04-15 16:48:45');
INSERT INTO `eb_community_notes_product` VALUES (123, 77, 9, 0, '2025-04-15 16:48:45');
INSERT INTO `eb_community_notes_product` VALUES (124, 80, 6, 0, '2025-04-15 17:07:56');
INSERT INTO `eb_community_notes_product` VALUES (125, 81, 5, 0, '2025-04-16 10:23:58');
INSERT INTO `eb_community_notes_product` VALUES (126, 81, 9, 0, '2025-04-16 10:23:58');
INSERT INTO `eb_community_notes_product` VALUES (127, 83, 5, 0, '2025-04-16 11:43:10');
INSERT INTO `eb_community_notes_product` VALUES (128, 83, 9, 0, '2025-04-16 11:43:10');
INSERT INTO `eb_community_notes_product` VALUES (129, 83, 8, 0, '2025-04-16 11:43:10');
INSERT INTO `eb_community_notes_product` VALUES (130, 84, 6, 0, '2025-04-16 16:36:16');

-- ----------------------------
-- Table structure for eb_community_notes_relation
-- ----------------------------
DROP TABLE IF EXISTS `eb_community_notes_relation`;
CREATE TABLE `eb_community_notes_relation`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `note_id` int(11) UNSIGNED NOT NULL COMMENT '笔记ID',
  `author_id` int(11) UNSIGNED NOT NULL COMMENT '笔记作者ID',
  `uid` int(11) UNSIGNED NOT NULL COMMENT '用户ID',
  `type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'like' COMMENT '关联类型(收藏(collect）、点赞(like))',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uniq_data`(`note_id`, `uid`) USING BTREE,
  INDEX `idx_author_id`(`author_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 453 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '社区笔记关系表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_community_notes_relation
-- ----------------------------
INSERT INTO `eb_community_notes_relation` VALUES (435, 72, 7, 7, 'like', '2025-04-15 10:13:01');
INSERT INTO `eb_community_notes_relation` VALUES (437, 72, 7, 6, 'like', '2025-04-15 10:33:58');
INSERT INTO `eb_community_notes_relation` VALUES (439, 77, 7, 7, 'like', '2025-04-15 14:48:22');
INSERT INTO `eb_community_notes_relation` VALUES (448, 79, 6, 7, 'like', '2025-04-16 10:31:15');
INSERT INTO `eb_community_notes_relation` VALUES (449, 75, 7, 7, 'like', '2025-04-16 10:45:27');

-- ----------------------------
-- Table structure for eb_community_reply
-- ----------------------------
DROP TABLE IF EXISTS `eb_community_reply`;
CREATE TABLE `eb_community_reply`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '评论类型：1-评论，2-回复',
  `uid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '发言用户ID',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '内容',
  `parent_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '一级评论ID',
  `parent_uid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '一级用户ID',
  `review_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '原评论ID',
  `review_uid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '原评论用户ID',
  `count_start` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '点赞数',
  `count_reply` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '评论数',
  `audit_status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '审核状态:0-待审核，1-审核通过，2-审核失败',
  `refusal` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '拒绝原因',
  `note_id` int(11) NOT NULL DEFAULT 0 COMMENT '笔记id',
  `is_del` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除，0-未删除，1-删除',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_uid`(`uid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 269 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '社区评论表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_community_reply
-- ----------------------------
INSERT INTO `eb_community_reply` VALUES (34, 1, 7, '好好好', 0, 0, 0, 0, 1, 0, 1, '', 13, 0, '2024-01-15 17:13:09', '2024-01-15 17:31:39');
INSERT INTO `eb_community_reply` VALUES (35, 2, 7, '何', 19, 5, 0, 0, 0, 0, 0, '', 13, 0, '2024-01-15 17:13:52', '2024-01-15 17:13:52');
INSERT INTO `eb_community_reply` VALUES (36, 2, 7, '机会', 19, 5, 0, 0, 0, 0, 0, '', 13, 0, '2024-01-15 17:14:22', '2024-01-15 17:14:22');
INSERT INTO `eb_community_reply` VALUES (48, 1, 5, 'ces', 0, 0, 0, 0, 0, 0, 0, '', 13, 0, '2024-01-16 14:51:07', '2024-01-16 14:51:07');
INSERT INTO `eb_community_reply` VALUES (253, 2, 6, '123', 231, 92, 242, 93, 0, 0, 0, '', 46, 1, '2025-04-10 09:22:05', '2025-04-10 16:56:11');
INSERT INTO `eb_community_reply` VALUES (254, 1, 6, '123', 0, 0, 0, 0, 0, 0, 0, '', 56, 1, '2025-04-10 16:02:51', '2025-04-15 09:46:59');
INSERT INTO `eb_community_reply` VALUES (255, 1, 6, '123', 0, 0, 0, 0, 1, 0, 1, '', 60, 1, '2025-04-11 16:31:19', '2025-04-15 09:46:50');
INSERT INTO `eb_community_reply` VALUES (256, 2, 6, '123', 255, 6, 0, 0, 0, 0, 0, '', 60, 1, '2025-04-12 09:25:56', '2025-04-15 09:46:50');
INSERT INTO `eb_community_reply` VALUES (257, 1, 7, '测试生活', 0, 0, 0, 0, 0, 0, 0, '', 72, 0, '2025-04-15 10:10:56', '2025-04-15 10:10:56');
INSERT INTO `eb_community_reply` VALUES (258, 1, 6, '666', 0, 0, 0, 0, 1, 1, 1, '', 72, 0, '2025-04-15 10:27:33', '2025-04-15 10:40:42');
INSERT INTO `eb_community_reply` VALUES (259, 2, 7, '777', 258, 6, 0, 0, 1, 0, 1, '', 72, 0, '2025-04-15 10:40:42', '2025-04-15 14:15:02');
INSERT INTO `eb_community_reply` VALUES (260, 1, 6, '首个评论', 0, 0, 0, 0, 0, 3, 1, '', 77, 0, '2025-04-15 14:37:39', '2025-04-15 14:40:05');
INSERT INTO `eb_community_reply` VALUES (261, 2, 6, '自己给自己回复', 260, 6, 0, 0, 0, 0, 1, '', 77, 0, '2025-04-15 14:38:11', '2025-04-15 14:38:11');
INSERT INTO `eb_community_reply` VALUES (262, 2, 7, '给首个评论回复', 260, 6, 0, 0, 0, 0, 1, '', 77, 0, '2025-04-15 14:38:56', '2025-04-15 14:38:56');
INSERT INTO `eb_community_reply` VALUES (263, 2, 6, '感谢！！！', 260, 6, 262, 7, 0, 0, 1, '', 77, 0, '2025-04-15 14:40:05', '2025-04-15 14:40:05');
INSERT INTO `eb_community_reply` VALUES (264, 1, 6, '123', 0, 0, 0, 0, 0, 0, 1, '', 76, 1, '2025-04-15 15:23:13', '2025-04-15 15:26:41');
INSERT INTO `eb_community_reply` VALUES (265, 1, 6, '23', 0, 0, 0, 0, 0, 0, 1, '', 75, 0, '2025-04-15 16:12:48', '2025-04-15 16:12:48');
INSERT INTO `eb_community_reply` VALUES (266, 1, 6, '23', 0, 0, 0, 0, 1, 0, 1, '', 75, 0, '2025-04-15 16:12:51', '2025-04-15 16:14:47');
INSERT INTO `eb_community_reply` VALUES (267, 1, 7, '11111111', 0, 0, 0, 0, 0, 0, 1, '', 73, 0, '2025-04-16 09:38:11', '2025-04-16 09:38:11');
INSERT INTO `eb_community_reply` VALUES (268, 1, 7, '11111111', 0, 0, 0, 0, 0, 0, 1, '', 73, 0, '2025-04-16 09:38:13', '2025-04-16 09:38:13');

-- ----------------------------
-- Table structure for eb_community_reply_like
-- ----------------------------
DROP TABLE IF EXISTS `eb_community_reply_like`;
CREATE TABLE `eb_community_reply_like`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `note_id` int(11) UNSIGNED NOT NULL COMMENT '笔记ID',
  `reply_id` int(11) UNSIGNED NOT NULL COMMENT '评论ID',
  `uid` int(11) UNSIGNED NOT NULL COMMENT '用户ID',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_data`(`note_id`, `uid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 42 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '社区评论点赞表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_community_reply_like
-- ----------------------------
INSERT INTO `eb_community_reply_like` VALUES (34, 46, 231, 6, '2025-04-10 09:22:13');
INSERT INTO `eb_community_reply_like` VALUES (37, 60, 255, 6, '2025-04-14 11:16:30');
INSERT INTO `eb_community_reply_like` VALUES (39, 72, 258, 6, '2025-04-15 10:34:26');
INSERT INTO `eb_community_reply_like` VALUES (40, 72, 259, 7, '2025-04-15 14:15:02');
INSERT INTO `eb_community_reply_like` VALUES (41, 75, 266, 6, '2025-04-15 16:14:47');

-- ----------------------------
-- Table structure for eb_community_topic
-- ----------------------------
DROP TABLE IF EXISTS `eb_community_topic`;
CREATE TABLE `eb_community_topic`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '话题名称',
  `is_hot` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否推荐：1-推荐，0-不推荐',
  `count_use` int(11) UNSIGNED NULL DEFAULT 0 COMMENT '使用次数',
  `count_view` int(11) UNSIGNED NULL DEFAULT 0 COMMENT '浏览量',
  `sort` int(6) NOT NULL DEFAULT 0 COMMENT '排序',
  `is_del` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除，0-未删除，1-删除',
  `create_type` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '创建类型：1-系统创建，2-用户创建',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '社区话题表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_community_topic
-- ----------------------------
INSERT INTO `eb_community_topic` VALUES (1, '爸爸带娃', 0, 0, 0, 0, 0, 1, '2023-08-03 17:27:26', '2023-08-03 17:27:26');
INSERT INTO `eb_community_topic` VALUES (2, '吃遍陕西', 0, 0, 0, 0, 0, 1, '2023-08-03 17:27:38', '2023-08-03 17:27:38');
INSERT INTO `eb_community_topic` VALUES (3, '西安钟楼', 1, 0, 0, 0, 0, 1, '2023-08-03 17:27:46', '2023-08-03 17:27:46');
INSERT INTO `eb_community_topic` VALUES (4, '西安大雁塔', 1, 0, 0, 0, 0, 1, '2023-08-03 17:27:57', '2023-08-03 17:27:57');
INSERT INTO `eb_community_topic` VALUES (5, '大唐不夜城', 1, 0, 0, 0, 0, 1, '2023-08-03 17:28:04', '2023-08-03 17:28:04');
INSERT INTO `eb_community_topic` VALUES (6, '放牧', 1, 0, 0, 0, 0, 1, '2023-08-03 17:28:11', '2023-08-03 17:28:11');
INSERT INTO `eb_community_topic` VALUES (7, '草原', 1, 0, 0, 0, 0, 1, '2023-08-03 17:28:17', '2023-08-03 17:28:17');

-- ----------------------------
-- Table structure for eb_email_template
-- ----------------------------
DROP TABLE IF EXISTS `eb_email_template`;
CREATE TABLE `eb_email_template`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `subject` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '主题',
  `text` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '邮件正文',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '邮件说明',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '类型',
  `status` tinyint(2) NOT NULL DEFAULT 1 COMMENT '状态',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '邮件模板表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of eb_email_template
-- ----------------------------
INSERT INTO `eb_email_template` VALUES (1, 'This is your Crmeb verificatio', 'Please enter this verification code on Crmeb when prompted {code}', '公共验证码', '验证码', 1, '2022-02-17 10:43:43');
INSERT INTO `eb_email_template` VALUES (2, 'Crmeb pay success', 'you have successfully paid {price} in the foreign trade version of crmeb, the order number is: {orderNo}', '支付成功通知', '通知', 1, '2022-02-17 12:04:22');
INSERT INTO `eb_email_template` VALUES (3, 'Crmeb order deliver', 'Your order {orderNo} has been shipped', '订单发货通知', '通知', 1, '2022-02-17 12:26:39');
INSERT INTO `eb_email_template` VALUES (4, 'Merhcnat audit success', 'Your merchant has been successfully reviewed, login password is : {password}', '商户申请审核成功通知', '通知', 1, '2022-02-17 12:26:39');

-- ----------------------------
-- Table structure for eb_express
-- ----------------------------
DROP TABLE IF EXISTS `eb_express`;
CREATE TABLE `eb_express`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '快递公司id',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '快递公司简称',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '快递公司全称',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序',
  `is_show` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否显示',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否可用',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code`) USING BTREE,
  INDEX `is_show`(`is_show`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 432 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '快递公司表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_express
-- ----------------------------
INSERT INTO `eb_express` VALUES (1, 'JTKD', '捷特快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (2, 'ESHIPPER', 'EShipper', 0, 1, 1);
INSERT INTO `eb_express` VALUES (3, 'APLUSEX', 'Aplus物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (4, 'EXFRESH', '安鲜达', 0, 1, 1);
INSERT INTO `eb_express` VALUES (5, 'XFEX', '信丰快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (6, 'GLS', 'GLS', 0, 1, 1);
INSERT INTO `eb_express` VALUES (7, 'IHGYZ', '韩国邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (8, 'MHKD', '民航快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (9, 'ZY_YJSD', '友家速递(UCS)', 0, 1, 1);
INSERT INTO `eb_express` VALUES (10, 'YIMIDIDA', '壹米滴答', 0, 1, 1);
INSERT INTO `eb_express` VALUES (11, 'ZY_TCM', '通诚美中快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (12, 'ZY_OZF', '欧洲疯', 0, 1, 1);
INSERT INTO `eb_express` VALUES (13, 'FKD', '飞康达', 0, 1, 1);
INSERT INTO `eb_express` VALUES (14, 'YODEL', 'YODEL', 0, 1, 1);
INSERT INTO `eb_express` VALUES (15, 'CJKD', '城际快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (16, 'RDSE', '瑞典邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (17, 'JITU', '极兔速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (18, 'ZY_UCS', 'UCS合众快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (19, 'DHL_EN', 'DHL', 0, 1, 1);
INSERT INTO `eb_express` VALUES (20, 'AAE', 'AAE全球专递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (21, 'IMTNKEMS', '马提尼克EMS', 0, 1, 1);
INSERT INTO `eb_express` VALUES (22, 'ADAPOST', '安达速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (23, 'AJ', '安捷快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (24, 'ICKY', '出口易', 0, 1, 1);
INSERT INTO `eb_express` VALUES (25, 'IQTWL', '全通物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (26, 'SURE', '速尔快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (27, 'AT', '奥地利邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (28, 'IAMYZ', '阿曼邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (29, 'ZY_AG', '爱购转运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (30, 'IAFHYZ', '阿富汗邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (31, 'IMLXYEMS', '马来西亚EMS', 0, 1, 1);
INSERT INTO `eb_express` VALUES (32, 'JYWL', '佳怡物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (33, 'ISTALBYZ', '沙特阿拉伯邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (34, 'DHL', 'DHL', 0, 1, 1);
INSERT INTO `eb_express` VALUES (35, 'ZTE', '众通快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (36, 'BN', '笨鸟国际', 0, 1, 1);
INSERT INTO `eb_express` VALUES (37, 'ZY_BT', '百通物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (38, 'SFWL', '盛丰物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (39, 'IALQDYZ', '奥兰群岛邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (40, 'NEDA', '能达速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (41, 'BR', '巴西邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (42, 'IAEBNYYZ', '阿尔巴尼亚邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (43, 'SFC', '三态速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (44, 'IWLYZ', '文莱邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (45, 'BDT', '八达通', 0, 1, 1);
INSERT INTO `eb_express` VALUES (46, 'ZTO', '中通快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (47, 'ZY_BL', '百利快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (48, 'IGDLPDYZ', '瓜德罗普岛邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (49, 'ZY_BM', '斑马物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (50, 'ZY_BH', '贝海速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (51, 'IZBLTYZ', '直布罗陀邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (52, 'CA', '加拿大邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (53, 'SUNING', '苏宁', 0, 1, 1);
INSERT INTO `eb_express` VALUES (54, 'CG', '程光', 0, 1, 1);
INSERT INTO `eb_express` VALUES (55, 'IALBYZ', '阿鲁巴邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (56, 'BEL', '比利时邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (57, 'ZY_HCYD', '皓晨优递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (58, 'JGSD', '京广速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (59, 'ILTWYZ', '立陶宛邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (60, 'ACS', 'ACS雅仕快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (61, 'HFWL', '汇丰物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (62, 'ZY_CM', '策马转运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (63, 'ZY_EFS', 'EFS POST', 0, 1, 1);
INSERT INTO `eb_express` VALUES (64, 'ZY_XDKD', '迅达快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (65, 'KYSY', '跨越速运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (66, 'FAST', '快捷快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (67, 'DK', '丹麦邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (68, 'ILTWYYZ', '拉脱维亚邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (69, 'ADP', 'ADP Express Tracking', 0, 1, 1);
INSERT INTO `eb_express` VALUES (70, 'APAC', 'APAC', 0, 1, 1);
INSERT INTO `eb_express` VALUES (71, 'IBDLGYZ', '波多黎各邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (72, 'MLWL', '明亮物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (73, 'RFD', '如风达', 0, 1, 1);
INSERT INTO `eb_express` VALUES (74, 'YXKD', '亿翔快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (75, 'IYNYZ', '越南邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (76, 'YTO', '圆通速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (77, 'BILUYOUZHE', '秘鲁邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (78, 'IBLYZ', '巴林邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (79, 'IADLSQDYZ', '安的列斯群岛邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (80, 'IHSKSTYZ', '哈萨克斯坦邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (81, 'IMTNKYZ', '马提尼克邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (82, 'SHT', '世华通物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (83, 'ZY_FD', '飞碟快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (84, 'AJWL', '安捷物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (85, 'AUSTRALIA', 'Australia Post Tracking', 0, 1, 1);
INSERT INTO `eb_express` VALUES (86, 'IELTLYYZ', '厄立特里亚邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (87, 'IASSDYZ', '阿森松岛邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (88, 'YFEX', '越丰物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (89, 'EMS', 'EMS', 0, 1, 1);
INSERT INTO `eb_express` VALUES (90, 'ZTO56', '中通快运(物流)', 0, 1, 1);
INSERT INTO `eb_express` VALUES (91, 'PCA', 'PCA Express', 0, 1, 1);
INSERT INTO `eb_express` VALUES (92, 'ZY_AUSE', '澳世速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (93, 'ITGYZ', '泰国邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (94, 'JIUYE', '九曳供应链', 0, 1, 1);
INSERT INTO `eb_express` VALUES (95, 'JXD', '急先达', 0, 1, 1);
INSERT INTO `eb_express` VALUES (96, 'ZY_FLSD', '风雷速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (97, 'SDWL', '上大物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (98, 'WJWL', '万家物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (99, 'YZPY', '邮政快递包裹', 0, 1, 1);
INSERT INTO `eb_express` VALUES (100, 'IXGLDNYYZ', '新喀里多尼亚邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (101, 'IBLWYYZ', '玻利维亚邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (102, 'ZY_MST', '美速通', 0, 1, 1);
INSERT INTO `eb_express` VALUES (103, 'HYLSD', '好来运快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (104, 'ZY_FX', '风行快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (105, 'ZY_FY', '飞洋快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (106, 'DHLGM', 'DHL Global Mail', 0, 1, 1);
INSERT INTO `eb_express` VALUES (107, 'BHT', 'BHT快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (108, 'ISDYZ', '苏丹邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (109, 'IYMYZ', '也门邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (110, 'STWL', '速腾快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (111, 'ZY_JDZY', '骏达转运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (112, 'GSD', '共速达', 0, 1, 1);
INSERT INTO `eb_express` VALUES (113, 'GD', '冠达', 0, 1, 1);
INSERT INTO `eb_express` VALUES (114, 'JYM', '加运美', 0, 1, 1);
INSERT INTO `eb_express` VALUES (115, 'ZY_FG', '飞鸽快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (116, 'ZY_HC', '皓晨快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (117, 'ZY_AZY', '澳转运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (118, 'IBLNYZ', '黎巴嫩邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (119, 'IMLXYYZ', '马来西亚邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (120, 'ONWAY', '昂威物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (121, 'BCWELT', 'BCWELT', 0, 1, 1);
INSERT INTO `eb_express` VALUES (122, 'ZY_XGX', '新干线快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (123, 'JGWL', '景光物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (124, 'IAJYZ', '埃及邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (125, 'ZY_LPZ', '领跑者快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (126, 'ZY_XIYJ', '西邮寄', 0, 1, 1);
INSERT INTO `eb_express` VALUES (127, 'ZYKD', '众邮快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (128, 'IXLYZ', '希腊邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (129, 'PJKD', '品骏快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (130, 'CSCY', '长沙创一', 0, 1, 1);
INSERT INTO `eb_express` VALUES (131, 'IWZBKSTEMS', '乌兹别克斯坦EMS', 0, 1, 1);
INSERT INTO `eb_express` VALUES (132, 'IBELSYZ', '白俄罗斯邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (133, 'GTO', '国通快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (134, 'ZY_MXZY', '美西转运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (135, 'USPS', 'USPS美国邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (136, 'ZY_YQ', '云骑快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (137, 'IMLQSYZ', '毛里求斯邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (138, 'ZY_SONIC', 'Sonic-Ex速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (139, 'HQSY', '环球速运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (140, 'HXLWL', '华夏龙物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (141, 'AOTSD', '澳天速运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (142, 'CCES', 'CCES快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (143, 'IHSYZ', '黑山邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (144, 'IYLYZ', '伊朗邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (145, 'ZY_HTAO', '360hitao转运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (146, 'ANGUILAYOU', '安圭拉邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (147, 'UPS', 'UPS', 0, 1, 1);
INSERT INTO `eb_express` VALUES (148, 'IASEBYYZ', '埃塞俄比亚邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (149, 'IGSDLJYZ', '哥斯达黎加邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (150, 'IXJPYZ', '新加坡邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (151, 'TNT', 'TNT快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (152, 'IE', '爱尔兰邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (153, 'IYMNYYZ', '亚美尼亚邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (154, 'FEDEX', 'FEDEX联邦(国内件）', 0, 1, 1);
INSERT INTO `eb_express` VALUES (155, 'IYDNXYYZ', '印度尼西亚邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (156, 'ITEQYZ', '土耳其邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (157, 'IAEJLYYZ', '阿尔及利亚邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (158, 'FTD', '富腾达', 0, 1, 1);
INSERT INTO `eb_express` VALUES (159, 'DPD', 'DPD', 0, 1, 1);
INSERT INTO `eb_express` VALUES (160, 'JD', '京东物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (161, 'CITY100', '城市100', 0, 1, 1);
INSERT INTO `eb_express` VALUES (162, 'EMSGJ', 'EMS国际', 0, 1, 1);
INSERT INTO `eb_express` VALUES (163, 'AMAZON', '亚马逊', 0, 1, 1);
INSERT INTO `eb_express` VALUES (164, 'SBWL', '盛邦物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (165, 'IBJLYYZ', '保加利亚邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (166, 'ZY_HXKD', '海星桥快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (167, 'JP', '日本邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (168, 'CDSTKY', '成都善途速运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (169, 'DIANNIAO', '丹鸟快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (170, 'COE', 'COE快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (171, 'IWKLEMS', '乌克兰EMS', 0, 1, 1);
INSERT INTO `eb_express` VALUES (172, 'WXWL', '万象物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (173, 'ZY_XDSY', '信达速运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (174, 'QQYZ', '全球邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (175, 'FASTGO', '速派快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (176, 'IBTD', '宝通达', 0, 1, 1);
INSERT INTO `eb_express` VALUES (177, 'JLDT', '嘉里物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (178, 'XYT', '希优特', 0, 1, 1);
INSERT INTO `eb_express` VALUES (179, 'IWLGYZ', '乌拉圭邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (180, 'LB', '龙邦快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (181, 'PANEX', '泛捷快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (182, 'ZY_MGZY', '美国转运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (183, 'IMXGYZ', '墨西哥邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (184, 'MAXEEDEXPRESS', '澳洲迈速快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (185, 'SAWL', '圣安物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (186, 'ZY_YPW', '云畔网', 0, 1, 1);
INSERT INTO `eb_express` VALUES (187, 'IGDLPDEMS', '瓜德罗普岛EMS', 0, 1, 1);
INSERT INTO `eb_express` VALUES (188, 'DJ56', '东骏快捷', 0, 1, 1);
INSERT INTO `eb_express` VALUES (189, 'ZY_FXSD', '风行速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (190, 'YJWL', '云聚物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (191, 'ISLFKYZ', '斯洛伐克邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (192, 'IBHYZ', '波黑邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (193, 'IBJSTYZ', '巴基斯坦邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (194, 'MB', '民邦快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (195, 'ZY_BDA', '八达网', 0, 1, 1);
INSERT INTO `eb_express` VALUES (196, 'YTKD', '运通快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (197, 'IAGTYZ', '阿根廷邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (198, 'ZY_RDGJ', '润东国际快线', 0, 1, 1);
INSERT INTO `eb_express` VALUES (199, 'ZY_SCS', 'SCS国际物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (200, 'ZY_BYECO', '贝易购', 0, 1, 1);
INSERT INTO `eb_express` VALUES (201, 'IKTEYZ', '卡塔尔邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (202, 'IZLYZ', '智利邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (203, 'ILSBYZ', '卢森堡邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (204, 'ANE', '安能物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (205, 'NF', '南方', 0, 1, 1);
INSERT INTO `eb_express` VALUES (206, 'ILBYYZ', '利比亚邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (207, 'NL', '荷兰邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (208, 'IBYB', '贝邮宝', 0, 1, 1);
INSERT INTO `eb_express` VALUES (209, 'RFEX', '瑞丰速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (210, 'ZY_BEE', '蜜蜂速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (211, 'YFHEX', '原飞航物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (212, 'YUNDX', '运东西', 0, 1, 1);
INSERT INTO `eb_express` VALUES (213, 'ASTEXPRESS', '安世通快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (214, 'EWE', 'EWE', 0, 1, 1);
INSERT INTO `eb_express` VALUES (215, 'INRLYYZ', '尼日利亚邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (216, 'ZY_YSW', '易送网', 0, 1, 1);
INSERT INTO `eb_express` VALUES (217, 'AOL', 'AOL（澳通）', 0, 1, 1);
INSERT INTO `eb_express` VALUES (218, 'IXJPEMS', '新加坡EMS', 0, 1, 1);
INSERT INTO `eb_express` VALUES (219, 'ZY_YSSD', '优晟速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (220, 'HPTEX', '海派通物流公司', 0, 1, 1);
INSERT INTO `eb_express` VALUES (221, 'hq568', '华强物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (222, 'ZY_QQEX', 'QQ-EX', 0, 1, 1);
INSERT INTO `eb_express` VALUES (223, 'IJEJSSTYZ', '吉尔吉斯斯坦邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (224, 'JAD', '捷安达', 0, 1, 1);
INSERT INTO `eb_express` VALUES (225, 'IADLYYZ', '澳大利亚邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (226, 'SWCH', '瑞士邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (227, 'IKNDYYZ', '克罗地亚邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (228, 'IMLGYZ', '摩洛哥邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (229, 'IYSLYZ', '以色列邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (230, 'CTG', '联合运通', 0, 1, 1);
INSERT INTO `eb_express` VALUES (231, 'BUDANYOUZH', '不丹邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (232, 'ZY_HJSD', '豪杰速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (233, 'ZTKY', '中铁快运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (234, 'ITNSYZ', '突尼斯邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (235, 'ZY_HFMZ', '汇丰美中速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (236, 'ITLNDHDBGE', '特立尼达和多巴哥EMS', 0, 1, 1);
INSERT INTO `eb_express` VALUES (237, 'SUBIDA', '速必达物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (238, 'QFKD', '全峰快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (239, 'ZY_BOZ', '败欧洲', 0, 1, 1);
INSERT INTO `eb_express` VALUES (240, 'ZY_HYSD', '海悦速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (241, 'ZY_ZCSD', '至诚速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (242, 'STO', '申通快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (243, 'IBOLYZ', '波兰邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (244, 'IYWWL', '燕文物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (245, 'RRS', '日日顺物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (246, 'IWZBKSTYZ', '乌兹别克斯坦邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (247, 'YUEDANYOUZ', '约旦邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (248, 'ZY_LBZY', '联邦转运FedRoad', 0, 1, 1);
INSERT INTO `eb_express` VALUES (249, 'ARAMEX', 'Aramex', 0, 1, 1);
INSERT INTO `eb_express` VALUES (250, 'ZY_TSZ', '唐三藏转运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (251, 'YXWL', '宇鑫物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (252, 'ZY_QMT', '全美通', 0, 1, 1);
INSERT INTO `eb_express` VALUES (253, 'ZENY', '增益快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (254, 'DPEX', 'DPEX', 0, 1, 1);
INSERT INTO `eb_express` VALUES (255, 'IGLLYZ', '格陵兰邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (256, 'GTONG', '广通', 0, 1, 1);
INSERT INTO `eb_express` VALUES (257, 'FEDEX_GJ', 'FEDEX联邦(国际件）', 0, 1, 1);
INSERT INTO `eb_express` VALUES (258, 'YFSD', '亚风快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (259, 'UAPEX', '全一快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (260, 'ONTRAC', 'ONTRAC', 0, 1, 1);
INSERT INTO `eb_express` VALUES (261, 'GJEYB', '国际e邮宝', 0, 1, 1);
INSERT INTO `eb_express` VALUES (262, 'IXFLWL', '小飞龙物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (263, 'AOMENYZ', '澳门邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (264, 'ZY_AOZ', '爱欧洲', 0, 1, 1);
INSERT INTO `eb_express` VALUES (265, 'ZY_HTKE', '365海淘客', 0, 1, 1);
INSERT INTO `eb_express` VALUES (266, 'HUISEN', '汇森快运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (267, 'QRT', '全日通快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (268, 'SF', '顺丰速运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (269, 'IYGYZ', '英国邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (270, 'LHT', '联昊通速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (271, 'INWYZ', '挪威邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (272, 'ZY_CTM', '赤兔马转运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (273, 'ZY_HXSY', '华兴速运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (274, 'ZY_SDKD', '速达快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (275, 'ZY_RT', '瑞天快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (276, 'ST', '速通物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (277, 'ZY_TN', '滕牛快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (278, 'IMJLGEMS', '孟加拉国EMS', 0, 1, 1);
INSERT INTO `eb_express` VALUES (279, 'D4PX', '递四方速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (280, 'ZY_TM', '天马转运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (281, 'ZY_TJ', '天际快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (282, 'ZHQKD', '汇强快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (283, 'IGJESD', '俄速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (284, 'IBUY8', '爱拜物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (285, 'SXJD', '顺心捷达', 0, 1, 1);
INSERT INTO `eb_express` VALUES (286, 'ZYWL', '中邮物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (287, 'ZY_ST', '上腾快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (288, 'IDFWL', '达方物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (289, 'IELSYZ', '俄罗斯邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (290, 'AYCA', '澳邮专线', 0, 1, 1);
INSERT INTO `eb_express` VALUES (291, 'IDGYZ', '德国邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (292, 'INFYZ', '南非邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (293, 'JJKY', '佳吉快运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (294, 'UC', '优速快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (295, 'IBDYZ', '冰岛邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (296, 'IXLYYZ', '叙利亚邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (297, 'ZY_OEJ', '欧e捷', 0, 1, 1);
INSERT INTO `eb_express` VALUES (298, 'ZY_TPAK', 'TrakPak', 0, 1, 1);
INSERT INTO `eb_express` VALUES (299, 'IKNYYZ', '肯尼亚邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (300, 'ZY_TX', '同心快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (301, 'ZY_TY', '天翼快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (302, 'YDH', '义达国际物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (303, 'HGLL', '黑狗冷链', 0, 1, 1);
INSERT INTO `eb_express` VALUES (304, 'ZY_ESONG', '宜送转运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (305, 'PADTF', '平安达腾飞快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (306, 'GDEMS', '广东邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (307, 'YDT', '易达通', 0, 1, 1);
INSERT INTO `eb_express` VALUES (308, 'IXYLYZ', '匈牙利邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (309, 'YAMA', '日本大和运输(Yamato)', 0, 1, 1);
INSERT INTO `eb_express` VALUES (310, 'ISEWDYZ', '萨尔瓦多邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (311, 'BTWL', '百世快运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (312, 'ADODOXOM', '澳多多国际速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (313, 'ZY_MBZY', '明邦转运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (314, 'IGLBYYZ', '哥伦比亚邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (315, 'IMEDFYZ', '马尔代夫邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (316, 'ZMKMEX', '芝麻开门', 0, 1, 1);
INSERT INTO `eb_express` VALUES (317, 'ZY_TTHT', '天天海淘', 0, 1, 1);
INSERT INTO `eb_express` VALUES (318, 'YD56', '韵达快运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (319, 'ILKKD', '林克快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (320, 'JYKD', '晋越快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (321, 'IHLY', '互联易', 0, 1, 1);
INSERT INTO `eb_express` VALUES (322, 'ZY_WDCS', '文达国际DCS', 0, 1, 1);
INSERT INTO `eb_express` VALUES (323, 'IALYYZ', '阿联酋邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (324, 'ZY_ETD', 'ETD', 0, 1, 1);
INSERT INTO `eb_express` VALUES (325, 'ZY_YQWL', '一柒物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (326, 'SDEZ', '速递e站', 0, 1, 1);
INSERT INTO `eb_express` VALUES (327, 'IKTDWEMS', '科特迪瓦EMS', 0, 1, 1);
INSERT INTO `eb_express` VALUES (328, 'YADEX', '源安达快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (329, 'ZY_XJ', '信捷转运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (330, 'AXD', '安信达快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (331, 'IMEDWYZ', '摩尔多瓦邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (332, 'IXBYYZ', '西班牙邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (333, 'ZY_XF', '先锋快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (334, 'XJ', '新杰物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (335, 'ZY_XC', '星辰快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (336, 'HLWL', '恒路物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (337, 'ZY_TPY', '太平洋快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (338, 'ITSNYYZ', '坦桑尼亚邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (339, 'IKTDWYZ', '科特迪瓦邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (340, 'IJNYZ', '加纳邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (341, 'YD', '韵达速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (342, 'QXT', '全信通', 0, 1, 1);
INSERT INTO `eb_express` VALUES (343, 'ILMNYYZ', '罗马尼亚邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (344, 'IWKLYZ', '乌克兰邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (345, 'XBWL', '新邦物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (346, 'IYDYZ', '印度邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (347, 'ZY_JH', '久禾快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (348, 'ZJS', '宅急送', 0, 1, 1);
INSERT INTO `eb_express` VALUES (349, 'ZY_RTSD', '瑞天速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (350, 'ZY_OZGO', '欧洲GO', 0, 1, 1);
INSERT INTO `eb_express` VALUES (351, 'ZY_JD', '时代转运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (352, 'ZY_TZH', '同舟快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (353, 'MKGJ', '美快国际物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (354, 'IWDMLYZ', '危地马拉邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (355, 'XCWL', '迅驰物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (356, 'ZY_JA', '君安快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (357, 'IPTYYZ', '葡萄牙邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (358, 'IXPSJ', '夏浦世纪', 0, 1, 1);
INSERT INTO `eb_express` VALUES (359, 'ZY_YTUSA', '运淘美国', 0, 1, 1);
INSERT INTO `eb_express` VALUES (360, 'ILZDSDYZ', '列支敦士登邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (361, 'TAIWANYZ', '台湾邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (362, 'ZY_JDKD', '骏达快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (363, 'IYDLYZ', '意大利邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (364, 'DTWL', '大田物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (365, 'ZY_SOHO', 'SOHO苏豪国际', 0, 1, 1);
INSERT INTO `eb_express` VALUES (366, 'IXXLYZ', '新西兰邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (367, 'IJBBWYZ', '津巴布韦邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (368, 'HOAU', '天地华宇', 0, 1, 1);
INSERT INTO `eb_express` VALUES (369, 'HTKY', '百世快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (370, 'ZY_AXO', 'AXO', 0, 1, 1);
INSERT INTO `eb_express` VALUES (371, 'ISEWYYZ', '塞尔维亚邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (372, 'ZY_HDB', '海带宝', 0, 1, 1);
INSERT INTO `eb_express` VALUES (373, 'BFAY', '八方安运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (374, 'GJYZ', '国际邮政包裹', 0, 1, 1);
INSERT INTO `eb_express` VALUES (375, 'BQXHM', '北青小红帽', 0, 1, 1);
INSERT INTO `eb_express` VALUES (376, 'IASBJYZ', '阿塞拜疆邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (377, 'IQQKD', '全球快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (378, 'CNPEX', 'CNPEX中邮快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (379, 'IMQDYZ', '马其顿邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (380, 'ZY_JHT', '金海淘', 0, 1, 1);
INSERT INTO `eb_express` VALUES (381, 'HEMA', '河马动力', 0, 1, 1);
INSERT INTO `eb_express` VALUES (382, 'ANTS', 'ANTS', 0, 1, 1);
INSERT INTO `eb_express` VALUES (383, 'YCWL', '远成物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (384, 'AUEXPRESS', '澳邮中国快运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (385, 'IYTG', '易通关', 0, 1, 1);
INSERT INTO `eb_express` VALUES (386, 'ZY_MJ', '美嘉快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (387, 'DSWL', 'D速物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (388, 'IJPZYZ', '柬埔寨邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (389, 'ZY_TWC', 'TWC转运世界', 0, 1, 1);
INSERT INTO `eb_express` VALUES (390, 'DBL', '德邦', 0, 1, 1);
INSERT INTO `eb_express` VALUES (391, 'IWGDYZ', '乌干达邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (392, 'ZY_LX', '龙象快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (393, 'CJGJ', '长江国际快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (394, 'IAGLYZ', '安哥拉邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (395, 'ISPLSYZ', '塞浦路斯邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (396, 'ISLWNYYZ', '斯洛文尼亚邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (397, 'IBCWNYZ', '博茨瓦纳邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (398, 'HHTT', '天天快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (399, 'ZTWL', '中铁物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (400, 'IASNYYZ', '爱沙尼亚邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (401, 'ZY_MZ', '168 美中快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (402, 'BHGJ', '贝海国际', 0, 1, 1);
INSERT INTO `eb_express` VALUES (403, 'ISNJEYZ', '塞内加尔邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (404, 'SAD', '赛澳递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (405, 'IHHWL', '华翰物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (406, 'IXPWL', '夏浦物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (407, 'ZY_CUL', 'CUL中美速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (408, 'UEQ', 'UEQ Express', 0, 1, 1);
INSERT INTO `eb_express` VALUES (409, 'ZY_DYW', '德运网', 0, 1, 1);
INSERT INTO `eb_express` VALUES (410, 'IBMDYZ', '百慕达邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (411, 'HXWL', '豪翔物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (412, 'IBLSD', '便利速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (413, 'IFTWL', '飞特物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (414, 'UEX', 'UEX', 0, 1, 1);
INSERT INTO `eb_express` VALUES (415, 'SHWL', '盛辉物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (416, 'IJKYZ', '捷克邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (417, 'ZY_LZWL', '量子物流', 0, 1, 1);
INSERT INTO `eb_express` VALUES (418, 'ZY_HTONG', '华通快运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (419, 'ZY_YGKD', '优购快递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (420, 'BFDF', '百福东方', 0, 1, 1);
INSERT INTO `eb_express` VALUES (421, 'WJK', '万家康', 0, 1, 1);
INSERT INTO `eb_express` VALUES (422, 'DHL_GLB', 'DHL全球', 0, 1, 1);
INSERT INTO `eb_express` VALUES (423, 'IMETYZ', '马耳他邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (424, 'GTSD', '高铁速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (425, 'IEGDEYZ', '厄瓜多尔邮政', 0, 1, 1);
INSERT INTO `eb_express` VALUES (426, 'ZY_SFZY', '四方转运', 0, 1, 1);
INSERT INTO `eb_express` VALUES (427, 'ZY_DGHT', '德国海淘之家', 0, 1, 1);
INSERT INTO `eb_express` VALUES (428, 'HOTSCM', '鸿桥供应链', 0, 1, 1);
INSERT INTO `eb_express` VALUES (429, 'AUSEXPRESS', '澳世速递', 0, 1, 1);
INSERT INTO `eb_express` VALUES (430, 'ZY_HTCUN', '海淘村', 0, 1, 1);
INSERT INTO `eb_express` VALUES (431, 'ANXL', '安迅物流', 0, 1, 1);

-- ----------------------------
-- Table structure for eb_group_config
-- ----------------------------
DROP TABLE IF EXISTS `eb_group_config`;
CREATE TABLE `eb_group_config`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `tag` int(3) NOT NULL DEFAULT 0 COMMENT '标签:1-首页banner,2-首页推荐，3-经营理念，4-友情链接, 5-快捷入口，6-商户PC店铺Banner，7-商户PC店铺商品推荐，8-首页底部二维码，9-首页广告,10-后页导航',
  `mer_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户id,0-平台',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '名称',
  `link_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '链接地址',
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图片地址',
  `value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '值',
  `message` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '描述',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '状态:是否显示',
  `sort` int(4) NOT NULL DEFAULT 0 COMMENT '排序',
  `is_del` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `expand` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '拓展字段',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `name`(`name`) USING BTREE,
  INDEX `tag`(`tag`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1690 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '组合配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_group_config
-- ----------------------------
INSERT INTO `eb_group_config` VALUES (7, 2, 0, '智能时代', 'http://www.baidu.com', 'crmebimage/public/product/2023/11/10/4bd754d3d4bf411d86773cc4f7701895vj0x0c85gr.jpg', '1', 'product', 1, 5, 0, '2023-10-18 14:13:13', '2023-10-18 14:13:13', '112,114,118,119,120,150');
INSERT INTO `eb_group_config` VALUES (9, 2, 0, '全屋智能', '', 'crmebimage/public/product/2023/11/10/49dd95e53732477a9a1ea73b5ce5d18ehk9owxattv.jpg', '', 'merchant', 1, 3, 0, '2023-10-18 14:17:16', '2024-12-18 14:21:03', '2');
INSERT INTO `eb_group_config` VALUES (261, 2, 0, '生活家居', '', 'crmebimage/public/product/2023/11/10/35714ed2f16141d6b321c017cc129a063jy4m6dn2g.jpg', '', 'merchant', 1, 4, 0, '2023-11-02 10:31:09', '2024-12-18 14:21:03', '3');
INSERT INTO `eb_group_config` VALUES (1032, 1, 0, '官网', 'https://www.crmeb.com/user/self/?pid=999', 'crmebimage/public/product/2023/11/10/f1e2dcc9d91e4ec5b696a1d7f8b71868f3njj1wjuq.jpg', '', '', 1, 1, 0, '2023-11-29 09:57:30', '2023-11-29 09:57:30', '');
INSERT INTO `eb_group_config` VALUES (1033, 1, 0, '首页', 'https://www.crmeb.com/user/self/?pid=999', 'crmebimage/public/product/2023/11/10/dfe54d00167446b295f9353d4950b7a9fwq1kblybb.jpg', '', '', 1, 2, 0, '2023-11-29 09:57:30', '2023-11-29 09:57:30', '');
INSERT INTO `eb_group_config` VALUES (1052, 3, 0, '品种齐全，购物轻松', '', 'crmebimage/public/product/2023/12/01/7f94d115374e44588faf5232518543daipt0jjd5k5.png', '', '', 1, 1, 1, '2023-12-01 10:39:01', '2023-12-06 14:31:24', '');
INSERT INTO `eb_group_config` VALUES (1053, 3, 0, '天天低价，畅选无忧', '', 'crmebimage/public/product/2023/11/10/93ec9d035eee4d3c8a5cb623d3ed292ed17wsnk50r.jpg', '', '', 1, 2, 1, '2023-12-01 10:39:01', '2023-12-06 14:31:24', '');
INSERT INTO `eb_group_config` VALUES (1054, 3, 0, '多仓直发，极速配送', '', 'crmebimage/public/product/2023/11/10/35fbd51a8c8a4b188a294e1e3fb71b6c60hv8qkbw3.png', '', '', 1, 3, 1, '2023-12-01 10:39:01', '2023-12-06 14:31:24', '');
INSERT INTO `eb_group_config` VALUES (1055, 3, 0, '正品行货，精致服务', '', 'crmebimage/public/product/2023/11/10/be0257ee99184a6887ce0e32eb7ddb158waaphp980.jpg', '', '', 1, 4, 1, '2023-12-01 10:39:01', '2023-12-06 14:31:24', '');
INSERT INTO `eb_group_config` VALUES (1098, 3, 0, '品种齐全，购物轻松', '', 'crmebimage/public/product/2023/12/01/7f94d115374e44588faf5232518543daipt0jjd5k5.png', '', '', 1, 1, 1, '2023-12-06 14:31:24', '2023-12-06 17:51:01', '');
INSERT INTO `eb_group_config` VALUES (1099, 3, 0, '天天低价，畅选无忧', '', 'crmebimage/public/merchant/2023/12/01/63528fc03af447bab925c8c009053bfbeg5ra0hszw.png', '', '', 1, 2, 1, '2023-12-06 14:31:24', '2023-12-06 17:51:01', '');
INSERT INTO `eb_group_config` VALUES (1100, 3, 0, '多仓直发，极速配送', '', 'crmebimage/public/product/2023/12/06/a213baae328b438ea90d0d2d1d4e8c10amkpvxadno.png', '', '', 1, 3, 1, '2023-12-06 14:31:24', '2023-12-06 17:51:01', '');
INSERT INTO `eb_group_config` VALUES (1101, 3, 0, '正品行货，精致服务', '', 'crmebimage/public/product/2023/12/06/b01170f7e3fb446c9549d2a11452d570zo5qr43slh.png', '', '', 1, 4, 1, '2023-12-06 14:31:24', '2023-12-06 17:51:01', '');
INSERT INTO `eb_group_config` VALUES (1102, 5, 0, '账户设置', '', '', '', '', 1, 1, 1, '2023-12-06 15:21:59', '2023-12-06 15:22:35', '[{\"id\":0,\"linkUrl\":\"\",\"name\":\"收货地址\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"个人资料\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"账号密码\",\"sort\":0}]');
INSERT INTO `eb_group_config` VALUES (1103, 5, 0, '活动中心', '', '', '', '', 1, 2, 1, '2023-12-06 15:21:59', '2023-12-06 15:22:35', '[{\"id\":0,\"linkUrl\":\"\",\"name\":\"领券中心\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"限时秒杀\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"品牌好店\",\"sort\":0}]');
INSERT INTO `eb_group_config` VALUES (1104, 5, 0, '账户设置', '', '', '', '', 1, 1, 1, '2023-12-06 15:22:35', '2023-12-06 15:23:29', '[{\"id\":0,\"linkUrl\":\"\",\"name\":\"收货地址\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"个人资料\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"账号密码\",\"sort\":0}]');
INSERT INTO `eb_group_config` VALUES (1105, 5, 0, '活动中心', '', '', '', '', 1, 2, 1, '2023-12-06 15:22:35', '2023-12-06 15:23:29', '[{\"id\":0,\"linkUrl\":\"\",\"name\":\"领券中心\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"限时秒杀\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"品牌好店\",\"sort\":0}]');
INSERT INTO `eb_group_config` VALUES (1106, 5, 0, '商户入驻', '', '', '', '', 1, 3, 1, '2023-12-06 15:22:35', '2023-12-06 15:23:29', '[{\"id\":0,\"linkUrl\":\"\",\"name\":\"商户入驻\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"申请记录\",\"sort\":0}]');
INSERT INTO `eb_group_config` VALUES (1107, 5, 0, '账户设置', '', '', '', '', 1, 1, 1, '2023-12-06 15:23:29', '2023-12-06 17:18:02', '[{\"id\":0,\"linkUrl\":\"\",\"name\":\"收货地址\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"个人资料\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"账号密码\",\"sort\":0}]');
INSERT INTO `eb_group_config` VALUES (1108, 5, 0, '活动中心', '', '', '', '', 1, 2, 1, '2023-12-06 15:23:29', '2023-12-06 17:18:02', '[{\"id\":0,\"linkUrl\":\"\",\"name\":\"领券中心\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"限时秒杀\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"品牌好店\",\"sort\":0}]');
INSERT INTO `eb_group_config` VALUES (1109, 5, 0, '商户入驻', '', '', '', '', 1, 3, 1, '2023-12-06 15:23:29', '2023-12-06 17:18:02', '[{\"id\":0,\"linkUrl\":\"\",\"name\":\"商户入驻\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"申请记录\",\"sort\":0}]');
INSERT INTO `eb_group_config` VALUES (1110, 5, 0, '规则协议', '', '', '', '', 1, 4, 1, '2023-12-06 15:23:29', '2023-12-06 17:18:02', '[{\"id\":0,\"linkUrl\":\"\",\"name\":\"用户协议\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"隐私协议\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"注销协议\",\"sort\":0}]');
INSERT INTO `eb_group_config` VALUES (1111, 5, 0, 'CRMEB', '', '', '', '', 1, 5, 1, '2023-12-06 15:23:29', '2023-12-06 17:18:02', '[{\"id\":0,\"linkUrl\":\"\",\"name\":\"CRMEB官网\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"CRMEB商城\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"CRMEB社区\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"关于CRMEB\",\"sort\":0}]');
INSERT INTO `eb_group_config` VALUES (1112, 8, 0, '联系客服', '', 'crmebimage/public/product/2023/12/06/5209716c0b834b85bdbe73fcda357c817nh6efr61j.png', '', '', 1, 1, 0, '2023-12-06 15:24:04', '2023-12-06 15:24:04', '');
INSERT INTO `eb_group_config` VALUES (1113, 8, 0, '关注我们', '', 'crmebimage/public/product/2023/12/06/a044a77428a849919349b59071a9636f33apxkx580.jpeg', '', '', 1, 2, 0, '2023-12-06 15:24:04', '2023-12-06 15:24:04', '');
INSERT INTO `eb_group_config` VALUES (1127, 5, 0, '账户设置', '', '', '', '', 1, 1, 0, '2023-12-06 17:18:02', '2023-12-06 17:18:02', '[{\"id\":0,\"linkUrl\":\"\",\"name\":\"收货地址\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"个人资料\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"账号密码\",\"sort\":0}]');
INSERT INTO `eb_group_config` VALUES (1128, 5, 0, '活动中心', '', '', '', '', 1, 2, 0, '2023-12-06 17:18:02', '2023-12-06 17:18:02', '[{\"id\":0,\"linkUrl\":\"\",\"name\":\"领券中心\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"限时秒杀\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"品牌好店\",\"sort\":0}]');
INSERT INTO `eb_group_config` VALUES (1129, 5, 0, '商户入驻', '', '', '', '', 1, 3, 0, '2023-12-06 17:18:02', '2023-12-06 17:18:02', '[{\"id\":0,\"linkUrl\":\"\",\"name\":\"商户入驻\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"申请记录\",\"sort\":0}]');
INSERT INTO `eb_group_config` VALUES (1130, 5, 0, '规则协议', '', '', '', '', 1, 4, 0, '2023-12-06 17:18:02', '2023-12-06 17:18:02', '[{\"id\":0,\"linkUrl\":\"\",\"name\":\"用户协议\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"隐私协议\",\"sort\":0},{\"id\":0,\"linkUrl\":\"\",\"name\":\"注销协议\",\"sort\":0}]');
INSERT INTO `eb_group_config` VALUES (1131, 5, 0, 'CRMEB', '', '', '', '', 1, 5, 0, '2023-12-06 17:18:02', '2023-12-06 17:18:02', '');
INSERT INTO `eb_group_config` VALUES (1132, 3, 0, '品种齐全，购物轻松1', '', 'crmebimage/public/product/2023/12/01/7f94d115374e44588faf5232518543daipt0jjd5k5.png', '', '', 1, 1, 1, '2023-12-06 17:51:01', '2024-04-07 16:04:27', '');
INSERT INTO `eb_group_config` VALUES (1133, 3, 0, '天天低价，畅选无忧', '', 'crmebimage/public/merchant/2023/12/01/63528fc03af447bab925c8c009053bfbeg5ra0hszw.png', '', '', 1, 2, 1, '2023-12-06 17:51:01', '2024-04-07 16:04:27', '');
INSERT INTO `eb_group_config` VALUES (1134, 3, 0, '多仓直发，极速配送', '', 'crmebimage/public/product/2023/12/06/a213baae328b438ea90d0d2d1d4e8c10amkpvxadno.png', '', '', 1, 3, 1, '2023-12-06 17:51:01', '2024-04-07 16:04:27', '');
INSERT INTO `eb_group_config` VALUES (1135, 3, 0, '正品行货，精致服务', '', 'crmebimage/public/product/2023/12/06/b01170f7e3fb446c9549d2a11452d570zo5qr43slh.png', '', '', 1, 4, 1, '2023-12-06 17:51:01', '2024-04-07 16:04:27', '');
INSERT INTO `eb_group_config` VALUES (1136, 4, 0, 'CRMEB', 'CRMEB.com', '', '', '', 1, 1, 0, '2023-12-06 17:52:34', '2023-12-06 17:52:34', '');
INSERT INTO `eb_group_config` VALUES (1137, 10, 0, '我的收藏', '', '', '', '', 0, 1, 1, '2023-12-28 17:35:22', '2023-12-28 17:39:06', '');
INSERT INTO `eb_group_config` VALUES (1138, 10, 0, '品牌好店', '/merchant/merchant_street?type=merchant', '', '', '', 1, 1, 1, '2023-12-29 11:29:25', '2023-12-29 17:22:16', '');
INSERT INTO `eb_group_config` VALUES (1139, 10, 0, '限时秒杀', '/activity/seckill_list?type=seckill', '', '', '', 1, 1, 1, '2023-12-29 17:22:16', '2023-12-29 17:22:27', '');
INSERT INTO `eb_group_config` VALUES (1140, 10, 0, '品牌好店', '/merchant/merchant_street?type=merchant', '', '', '', 1, 2, 1, '2023-12-29 17:22:16', '2023-12-29 17:22:27', '');
INSERT INTO `eb_group_config` VALUES (1141, 10, 0, '领券中心', '/activity/coupon_list?type=coupon', '', '', '', 1, 3, 1, '2023-12-29 17:22:16', '2023-12-29 17:22:27', '');
INSERT INTO `eb_group_config` VALUES (1142, 10, 0, '订单中心', '/users/order_list?type=1', '', '', '', 1, 4, 1, '2023-12-29 17:22:16', '2023-12-29 17:22:27', '');
INSERT INTO `eb_group_config` VALUES (1143, 10, 0, '资讯信息', '/activity/information_list?type=information', '', '', '', 1, 5, 1, '2023-12-29 17:22:16', '2023-12-29 17:22:27', '');
INSERT INTO `eb_group_config` VALUES (1144, 10, 0, '限时秒杀', '/activity/seckill_list?type=seckill', '', '', '', 1, 1, 1, '2023-12-29 17:22:27', '2023-12-29 17:35:31', '');
INSERT INTO `eb_group_config` VALUES (1145, 10, 0, '品牌好店', '/merchant/merchant_street?type=merchant', '', '', '', 1, 2, 1, '2023-12-29 17:22:27', '2023-12-29 17:35:31', '');
INSERT INTO `eb_group_config` VALUES (1146, 10, 0, '领券中心', '/activity/coupon_list?type=coupon', '', '', '', 1, 3, 1, '2023-12-29 17:22:27', '2023-12-29 17:35:31', '');
INSERT INTO `eb_group_config` VALUES (1147, 10, 0, '订单中心', '/users/order_list?type=1', '', '', '', 1, 4, 1, '2023-12-29 17:22:27', '2023-12-29 17:35:31', '');
INSERT INTO `eb_group_config` VALUES (1148, 10, 0, '资讯信息', '/activity/information_list?type=information', '', '', '', 1, 5, 1, '2023-12-29 17:22:27', '2023-12-29 17:35:31', '');
INSERT INTO `eb_group_config` VALUES (1149, 10, 0, '限时秒杀', '/activity/seckill_list?type=seckill', '', '', '', 1, 1, 1, '2023-12-29 17:35:31', '2024-01-03 14:24:38', '');
INSERT INTO `eb_group_config` VALUES (1150, 10, 0, '品牌好店', '/merchant/merchant_street?type=merchant', '', '', '', 1, 2, 1, '2023-12-29 17:35:31', '2024-01-03 14:24:38', '');
INSERT INTO `eb_group_config` VALUES (1151, 10, 0, '领券中心', '/activity/coupon_list?type=coupon', '', '', '', 1, 3, 1, '2023-12-29 17:35:31', '2024-01-03 14:24:38', '');
INSERT INTO `eb_group_config` VALUES (1152, 10, 0, '订单中心', '/users/order_list?type=1', '', '', '', 1, 4, 1, '2023-12-29 17:35:31', '2024-01-03 14:24:38', '');
INSERT INTO `eb_group_config` VALUES (1153, 10, 0, '资讯信息', '/activity/information_list?type=information', '', '', '', 1, 5, 1, '2023-12-29 17:35:31', '2024-01-03 14:24:38', '');
INSERT INTO `eb_group_config` VALUES (1154, 10, 0, '我的优惠券', '/users/user_coupon?type=6&name=我的优惠券', '', '', '', 1, 6, 1, '2023-12-29 17:35:31', '2024-01-03 14:24:38', '');
INSERT INTO `eb_group_config` VALUES (1263, 10, 0, '领券中心', '/activity/coupon_list?type=coupon', '', '', '', 1, 10, 1, '2024-01-03 14:46:35', '2024-01-03 14:47:59', '');
INSERT INTO `eb_group_config` VALUES (1273, 10, 0, '收藏', '/users/collect_products?type=3', '', '', '', 1, 10, 1, '2024-01-03 14:47:59', '2024-01-03 15:28:14', '');
INSERT INTO `eb_group_config` VALUES (1294, 10, 0, '限时秒杀', '/activity/seckill_list?type=seckill', '', '', '', 1, 1, 1, '2024-01-03 16:34:46', '2024-01-03 17:14:35', '');
INSERT INTO `eb_group_config` VALUES (1295, 10, 0, '品牌好店', '/merchant/merchant_street?type=merchant', '', '', '', 1, 2, 1, '2024-01-03 16:34:46', '2024-01-03 17:14:35', '');
INSERT INTO `eb_group_config` VALUES (1296, 10, 0, '领券中心', '/activity/coupon_list?type=coupon', '', '', '', 1, 3, 1, '2024-01-03 16:34:46', '2024-01-03 17:14:35', '');
INSERT INTO `eb_group_config` VALUES (1297, 10, 0, '订单中心', '/users/order_list?type=1', '', '', '', 1, 4, 1, '2024-01-03 16:34:46', '2024-01-03 17:14:35', '');
INSERT INTO `eb_group_config` VALUES (1298, 10, 0, '资讯信息', '/activity/information_list?type=information', '', '', '', 1, 5, 1, '2024-01-03 16:34:46', '2024-01-03 17:14:35', '');
INSERT INTO `eb_group_config` VALUES (1299, 10, 0, '我的优惠券', '/users/user_coupon?type=6&name=我的优惠券', '', '', '', 1, 6, 1, '2024-01-03 16:34:46', '2024-01-03 17:14:35', '');
INSERT INTO `eb_group_config` VALUES (1300, 10, 0, '我的足迹', 'https://pc.merchant.crmeb.xbdzz.cn/users/browsing_history?type=8', '', '', '', 1, 7, 1, '2024-01-03 16:34:46', '2024-01-03 17:14:35', '');
INSERT INTO `eb_group_config` VALUES (1301, 10, 0, '我的售后退款', 'https://pc.merchant.crmeb.xbdzz.cn/users/refund_list?type=9&name=%E5%94%AE%E5%90%8E/%E9%80%80%E6%AC%BE', '', '', '', 1, 8, 1, '2024-01-03 16:34:46', '2024-01-03 17:14:35', '');
INSERT INTO `eb_group_config` VALUES (1302, 10, 0, '百度一下', 'http://www.baidu.com/', '', '', '', 1, 9, 1, '2024-01-03 16:34:46', '2024-01-03 17:14:35', '');
INSERT INTO `eb_group_config` VALUES (1303, 10, 0, '公司官网', 'https://www.crmeb.com/', '', '', '', 1, 10, 1, '2024-01-03 16:34:46', '2024-01-03 17:14:35', '');
INSERT INTO `eb_group_config` VALUES (1304, 10, 0, '限时秒杀', '/activity/seckill_list?type=seckill', '', '', '', 1, 1, 1, '2024-01-03 17:14:35', '2024-01-06 15:28:21', '');
INSERT INTO `eb_group_config` VALUES (1305, 10, 0, '品牌好店', '/merchant/merchant_street?type=merchant', '', '', '', 1, 2, 1, '2024-01-03 17:14:35', '2024-01-06 15:28:21', '');
INSERT INTO `eb_group_config` VALUES (1306, 10, 0, '领券中心', '/activity/coupon_list?type=coupon', '', '', '', 1, 3, 1, '2024-01-03 17:14:35', '2024-01-06 15:28:21', '');
INSERT INTO `eb_group_config` VALUES (1307, 10, 0, '订单中心', '/users/order_list?type=1', '', '', '', 1, 4, 1, '2024-01-03 17:14:35', '2024-01-06 15:28:21', '');
INSERT INTO `eb_group_config` VALUES (1308, 10, 0, '资讯信息', '/activity/information_list?type=information', '', '', '', 1, 5, 1, '2024-01-03 17:14:35', '2024-01-06 15:28:21', '');
INSERT INTO `eb_group_config` VALUES (1309, 10, 0, '我的优惠券', '/users/user_coupon?type=6&name=我的优惠券', '', '', '', 1, 6, 1, '2024-01-03 17:14:35', '2024-01-06 15:28:21', '');
INSERT INTO `eb_group_config` VALUES (1310, 10, 0, '我的足迹', 'https://pc.merchant.crmeb.xbdzz.cn/users/browsing_history?type=8', '', '', '', 1, 7, 1, '2024-01-03 17:14:35', '2024-01-06 15:28:21', '');
INSERT INTO `eb_group_config` VALUES (1315, 10, 0, '限时秒杀', '/activity/seckill_list?type=seckill', '', '', '', 1, 1, 1, '2024-01-06 15:28:21', '2024-01-06 15:28:46', '');
INSERT INTO `eb_group_config` VALUES (1316, 10, 0, '品牌好店', '/merchant/merchant_street?type=merchant', '', '', '', 1, 2, 1, '2024-01-06 15:28:21', '2024-01-06 15:28:46', '');
INSERT INTO `eb_group_config` VALUES (1317, 10, 0, '领券中心', '/activity/coupon_list?type=coupon', '', '', '', 1, 3, 1, '2024-01-06 15:28:21', '2024-01-06 15:28:46', '');
INSERT INTO `eb_group_config` VALUES (1318, 10, 0, '订单中心', '/users/order_list?type=1', '', '', '', 1, 4, 1, '2024-01-06 15:28:21', '2024-01-06 15:28:46', '');
INSERT INTO `eb_group_config` VALUES (1319, 10, 0, '资讯信息', '/activity/information_list?type=information', '', '', '', 1, 5, 1, '2024-01-06 15:28:21', '2024-01-06 15:28:46', '');
INSERT INTO `eb_group_config` VALUES (1320, 10, 0, '我的优惠券', '/users/user_coupon?type=6&name=我的优惠券', '', '', '', 0, 6, 1, '2024-01-06 15:28:21', '2024-01-06 15:28:46', '');
INSERT INTO `eb_group_config` VALUES (1321, 10, 0, '我的足迹', 'https://pc.merchant.crmeb.xbdzz.cn/users/browsing_history?type=8', '', '', '', 0, 7, 1, '2024-01-06 15:28:21', '2024-01-06 15:28:46', '');
INSERT INTO `eb_group_config` VALUES (1447, 11, 0, 'memberExclusivePrice', '', 'crmebimage/public/content/2024/06/07/2a8cda2db7d3438390df0315ed2acc3cf3mb0bp80u.png', '会员专享价', '全品类覆盖', 1, 9, 0, '2024-05-14 10:51:59', '2024-05-14 17:27:39', '<p>&nbsp;</p>\n<p>作为我们商城平台的SVIP会员，您将尊享一项独特且极具吸引力的会员权益&mdash;&mdash;<strong>会员专属价</strong>。这一特权将让您在购物过程中感受到前所未有的优惠和尊贵体验。</p>\n<p><strong>1. 独一无二的优惠</strong><br />SVIP会员专享价是我们为您量身定制的独家优惠。与普通用户相比，您将能以更低的价格购买到心仪的商品，无论是热销爆款还是限量新品，都能享受到这一特权带来的惊喜。</p>\n<p><strong>2. 品质与价值的双重保障</strong><br />我们深知您对品质的追求，因此会员专属价所覆盖的商品均经过严格筛选，确保品质上乘。同时，这一价格也是对您尊贵身份的特别回馈，让您在享受优惠的同时，更能感受到我们的诚意与尊重。</p>\n<p><strong>3. 实时更新，优惠不断</strong><br />我们将根据市场需求和商品更新情况，持续更新SVIP会员专享价商品列表。您可以随时关注商城平台，第一时间掌握最新的优惠信息，不错过任何一次购物良机。</p>\n<p><strong>4. 尊贵体验，尽在掌握</strong><br />SVIP会员专享价不仅是一项价格优惠，更是一种尊贵体验的体现。通过这一特权，您将享受到更加便捷、个性化的购物服务，让您的购物之旅更加轻松愉悦。</p>\n<p>总的来说，SVIP会员专享价是我们商城平台为您精心打造的一项独特权益。我们希望通过这一特权，让您在购物过程中感受到更多的优惠和尊贵体验，成为我们商城平台的忠实拥趸。</p>');
INSERT INTO `eb_group_config` VALUES (1448, 11, 0, 'integralDoubling', '3:1', 'crmebimage/public/content/2024/06/07/03a6c7a160704604b1e83d113f985c6ad247sd7aal.png', '积分翻倍', '积分可抵金额用', 1, 3, 0, '2024-05-14 10:52:04', '2024-05-14 17:28:29', '<p>作为我们商城平台的SVIP会员，您将独享一项令人心动的会员权益&mdash;&mdash;<strong>积分翻倍</strong>。这一特权将让您的积分积累速度倍增，使您在购物时能够享受更多优惠和抵扣。</p>\n<p><strong>1. 积分翻倍，优惠加倍</strong><br />SVIP会员在商城平台上的每一次签到和购买商品，都将获得翻倍的积分奖励。这意味着您不仅可以更快地累积积分，还能在未来购物时享受更多的积分抵扣，让您的每一笔消费都更加划算。</p>\n<p><strong>2. 积分当钱花，购物更轻松</strong><br />在商城平台上，积分拥有与现金同等的价值。SVIP会员通过积分翻倍特权累积的积分，可以在购买商品时直接抵扣现金使用。这意味着您的积分将成为一种&ldquo;货币&rdquo;，让您的购物过程更加轻松便捷。</p>\n<p><strong>3. 积分抵扣，购物无门槛</strong><br />SVIP会员在享受积分翻倍特权的同时，还可以享受积分抵扣购物的无门槛优惠。无论是大额商品还是小额商品，您都可以使用积分进行抵扣，无需满足额外的购物条件或门槛。这一特权将让您的购物体验更加自由灵活。</p>\n<p>总的来说，SVIP会员积分翻倍是一项极具吸引力的会员权益。它让您在商城平台上的积分累积速度倍增，让您的购物过程更加优惠和便捷。我们希望通过这一特权，让您在商城平台上享受更多的购物乐趣和实惠。</p>');
INSERT INTO `eb_group_config` VALUES (1449, 11, 0, 'experienceDoubling', '3:1', 'crmebimage/public/content/2024/06/07/af3be0fe09f044ec8ea938d72907fa23dz7zkybbub.png', '经验值翻倍', '等级加速2.0倍', 1, 8, 0, '2024-05-14 10:52:08', '2024-05-14 17:28:43', '<p>作为我们商城平台的SVIP会员，您将独享一项极具吸引力的会员权益&mdash;&mdash;<strong>经验值翻倍</strong>。这一特权将加速您的经验值积累，让您在商城平台上更快地成长，享受更多专属乐趣。</p>\n<p><strong>1. 经验值翻倍，成长加速</strong><br />SVIP会员在商城平台上的每一项活动都将获得双倍的经验值。无论是每日签到还是发布优质的种草内容，您都将获得比普通会员多一倍的经验值。这意味着您可以更快地提升用户等级，享受更多由等级带来的乐趣和成就感。</p>\n<p><strong>2. 轻松积累，畅享特权</strong><br />通过经验值翻倍的特权，您可以更轻松地积累足够的经验值，解锁更多商城平台的独特功能和活动。无论是参与限时抢购、享受专属折扣，还是体验更多个性化的服务，都将因您SVIP会员的身份而变得更加便捷和丰富。</p>\n<p><strong>3. 优质内容，双倍回报</strong><br />作为商城平台的用户，您可以通过发布种草内容来分享您的购物心得和推荐。作为SVIP会员，您的每一条优质种草内容都将获得双倍的经验值回报。这不仅是对您创作内容的认可，更是对您作为商城平台用户的鼓励和回馈。</p>\n<p>总的来说，SVIP会员经验值翻倍是一项极具价值的会员权益。它让您在商城平台上的每一项活动都能获得双倍的经验值回报，加速您的成长和等级提升。我们希望通过这一特权，让您在商城平台上更加畅享购物的乐趣，感受SVIP会员的尊贵与特权。</p>');
INSERT INTO `eb_group_config` VALUES (1450, 11, 0, 'exclusiveCustomer', '', 'crmebimage/public/content/2024/06/07/4726984d096f4cb589d9aa330df7fda3esf2ffvfbd.png', '专属客服', '一对一客服', 1, 0, 0, '2024-05-27 09:35:39', '2024-05-27 09:35:39', '<p>作为我们商城平台的SVIP会员，您将享受到一项尊贵且独特的会员权益&mdash;&mdash;<strong>专属一对一客服</strong>。这一特权将为您提供更加个性化、贴心的购物体验，确保您在商城平台上的每一次购物都能得到及时、专业的服务支持。</p>\n<p><strong>1. 尊贵体验，专属服务</strong><br />SVIP会员将拥有专属的一对一客服，为您提供全程的购物指导和帮助。无论是产品咨询、订单查询、售后服务还是其他任何问题，您的专属客服都将为您提供及时、准确的解答和解决方案。</p>\n<p><strong>2. 快速响应，高效解决</strong><br />与普通客服相比，专属一对一客服将为您提供更加快速、高效的服务。无论您遇到何种问题或需求，您的专属客服都将迅速响应，确保问题得到及时解决，让您的购物过程更加顺畅、无忧。</p>\n<p><strong>3. 个性化服务，满足需求</strong><br />专属一对一客服将深入了解您的购物需求和偏好，为您提供更加个性化的服务。他们将根据您的需求为您推荐合适的商品、制定专属的购物方案，确保您的购物体验更加符合个人期望和品味。</p>\n<p><strong>4. 贴心关怀，全程陪伴</strong><br />在您的购物过程中，专属一对一客服将全程陪伴您左右，为您提供贴心的关怀和支持。他们将关注您的购物进展、及时提醒您关注的活动和优惠信息，确保您不错过任何一次购物机会。</p>\n<p>总的来说，SVIP会员专属一对一客服是一项尊贵且独特的会员权益。它为您提供更加个性化、贴心的购物体验，确保您在商城平台上的每一次购物都能得到及时、专业的服务支持。我们希望通过这一特权，让您在商城平台上享受到更加尊贵、便捷的购物体验。</p>');
INSERT INTO `eb_group_config` VALUES (1454, 12, 0, '0-200', '', '', '0-200', '', 1, 2, 1, '2024-08-24 10:27:44', '2024-08-24 10:27:44', '');
INSERT INTO `eb_group_config` VALUES (1456, 12, 0, '积分区间2', '', '', '101-500', '', 1, 55, 0, '2024-08-24 17:01:48', '2024-08-24 17:01:48', '');
INSERT INTO `eb_group_config` VALUES (1458, 12, 0, '积分区间4', '', '', '1001-2000', '', 1, 22, 0, '2024-08-24 17:05:59', '2024-08-24 17:05:59', '');
INSERT INTO `eb_group_config` VALUES (1468, 12, 0, '积分区间3', '', '', '501-1000', '', 1, 50, 0, '2024-08-26 09:21:46', '2024-08-26 09:21:46', '');
INSERT INTO `eb_group_config` VALUES (1469, 12, 0, '200-300', '', '', '200-300', '', 1, 0, 1, '2024-08-26 09:21:49', '2024-08-26 09:21:49', '');
INSERT INTO `eb_group_config` VALUES (1470, 12, 0, '100-200', '', '', '100-200', '', 1, 0, 1, '2024-08-26 09:21:52', '2024-08-26 09:21:52', '');
INSERT INTO `eb_group_config` VALUES (1682, 13, 0, '', '', 'crmebimage/public/content/2024/12/27/77a62b64f5004547b516f7bf1e490b8epbffekn4dd.png', '', '', 1, 2, 0, '2025-02-27 09:38:31', '2025-02-27 09:38:31', '');
INSERT INTO `eb_group_config` VALUES (1683, 6, 9, '', '', 'crmebimage/public/content/2025/02/11/fe097fe431b84604a003c4b06a836ab7yew6z6pqxu.png', '', '', 0, 1, 1, '2025-03-17 14:07:44', '2025-03-17 14:08:08', '');
INSERT INTO `eb_group_config` VALUES (1684, 6, 9, '', '', 'crmebimage/public/content/2025/02/11/fe097fe431b84604a003c4b06a836ab7yew6z6pqxu.png', '', '', 1, 1, 1, '2025-03-17 14:08:08', '2025-03-17 14:08:41', '');
INSERT INTO `eb_group_config` VALUES (1685, 6, 9, '', '', 'crmebimage/public/content/2025/02/11/fe097fe431b84604a003c4b06a836ab7yew6z6pqxu.png', '', '', 1, 1, 1, '2025-03-17 14:08:41', '2025-03-17 14:08:57', '');
INSERT INTO `eb_group_config` VALUES (1686, 7, 9, '', '', '', '401,397,347', '', 0, 0, 1, '2025-03-17 14:08:41', '2025-03-17 14:08:57', '');
INSERT INTO `eb_group_config` VALUES (1687, 6, 9, '', '', 'crmebimage/public/content/2025/02/11/fe097fe431b84604a003c4b06a836ab7yew6z6pqxu.png', '', '', 1, 1, 0, '2025-03-17 14:08:57', '2025-03-17 14:08:57', '');
INSERT INTO `eb_group_config` VALUES (1688, 6, 9, '', '', 'crmebimage/public/product/2025/03/04/d326752893ec4833a03b14acdf7bb52a0un0hqp0tx.png', '', '', 1, 2, 0, '2025-03-17 14:08:57', '2025-03-17 14:08:57', '');
INSERT INTO `eb_group_config` VALUES (1689, 7, 9, '', '', '', '401,397,347', '', 0, 0, 0, '2025-03-17 14:08:57', '2025-03-17 14:08:57', '');

-- ----------------------------
-- Table structure for eb_marketing_activity
-- ----------------------------
DROP TABLE IF EXISTS `eb_marketing_activity`;
CREATE TABLE `eb_marketing_activity`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '活动ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '活动名称',
  `is_open` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否开启：0-未开启，1-已开启',
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '活动展示类型：1-轮播列表，2-大小格，3-大图模式',
  `sort` int(5) NOT NULL DEFAULT 999 COMMENT '排序',
  `is_del` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0未删除1已删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `banner` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '活动banner',
  `instruction` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '活动简介',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '营销活动表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of eb_marketing_activity
-- ----------------------------
INSERT INTO `eb_marketing_activity` VALUES (1, 'Last Line', 1, 2, 1, 0, '2022-06-18 18:11:09', '2022-06-18 18:11:09', '[\"crmebimage/public/product/2022/06/18/c3ea8f6f85e940f88f539fea2c4df96b72m4w0yacl.png\",\"crmebimage/public/product/2022/06/18/524910ddd9c6482c8c70e1e6029cd18endhup3y4gl.png\",\"crmebimage/public/product/2022/06/18/dce92e38b7564e1abafcd206865dc688ed1tgfx0tt.png\",\"crmebimage/public/product/2022/06/18/a31a093ce2804693b0fbaadef9d5527945a8t1m54h.png\",\"crmebimage/public/product/2022/06/18/d29fb6cc07d94aa0af516075ccc3cca1b7wcnmr38d.png\"]', 'Last Line');
INSERT INTO `eb_marketing_activity` VALUES (2, 'DaXiaoGe', 1, 2, 1, 0, '2022-06-18 18:14:44', '2022-06-18 18:14:44', '[\"crmebimage/public/product/2022/06/18/91ac2a1b069b477dbbac13fea837a785y6chifhvv3.jpg\",\"crmebimage/public/product/2022/06/18/8fc10d9bbec747fc978199e8ba731fe873054yexp7.jpg\",\"crmebimage/public/product/2022/06/18/79e3eb9aaf184975a4079f8cad402e7ena2xzu5urm.jpg\",\"crmebimage/public/product/2022/06/18/c3ea8f6f85e940f88f539fea2c4df96b72m4w0yacl.png\"]', 'DaXiaoGe');
INSERT INTO `eb_marketing_activity` VALUES (3, 'Top List', 1, 1, 1, 0, '2022-06-18 18:15:51', '2022-06-18 18:16:56', '[\"crmebimage/public/product/2022/06/18/115ca3ee301d41a6824365b393f76590kj66zndb4e.png\",\"crmebimage/public/product/2022/06/18/c3ea8f6f85e940f88f539fea2c4df96b72m4w0yacl.png\",\"crmebimage/public/product/2022/06/18/997b9a0d96aa409f86b61e8935212436gazj63iupp.png\",\"crmebimage/public/product/2022/06/18/f293b290922f4ccbab84d70f2880c914sty4qif2eg.png\",\"crmebimage/public/product/2022/06/18/6c48e6761825426d83c4315e139dcc58qdotn3725v.png\"]', 'Top List');

-- ----------------------------
-- Table structure for eb_master_order
-- ----------------------------
DROP TABLE IF EXISTS `eb_master_order`;
CREATE TABLE `eb_master_order`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主订单号',
  `uid` int(11) UNSIGNED NOT NULL COMMENT '用户id',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户邮箱',
  `real_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '收货人姓名',
  `user_phone` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '收货人电话',
  `user_address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '详细地址',
  `total_num` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '订单商品总数',
  `pro_total_price` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '商品总价',
  `total_postage` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '邮费',
  `total_price` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '订单总价',
  `pay_postage` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '支付邮费',
  `pay_price` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '实际支付金额',
  `coupon_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '优惠券id',
  `coupon_price` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '优惠券金额',
  `paid` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '支付状态',
  `pay_time` timestamp NULL DEFAULT NULL COMMENT '支付时间',
  `pay_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '支付方式:paypal',
  `pay_channel` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '支付渠道：pc,mobile',
  `mark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户备注',
  `is_cancel` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否取消',
  `out_trade_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'PAYPAL商户系统内部的订单号,32个字符内、可包含字母, 其他说明见商户订单号',
  `redirect` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '支付重定向地址',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '主订单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_master_order
-- ----------------------------

-- ----------------------------
-- Table structure for eb_merchant
-- ----------------------------
DROP TABLE IF EXISTS `eb_merchant`;
CREATE TABLE `eb_merchant`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '商户ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户名称',
  `category_id` int(11) NOT NULL COMMENT '商户分类ID',
  `type_id` int(11) NOT NULL COMMENT '商户类型ID',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户姓名',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户邮箱',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商户手机号',
  `handling_fee` int(3) NOT NULL COMMENT '手续费(%)',
  `keywords` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商户关键字',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商户地址',
  `is_self` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '是否自营：0-自营，1-非自营',
  `is_recommend` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否推荐:0-不推荐，1-推荐',
  `is_switch` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户开关:0-关闭，1-开启',
  `product_switch` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '商品审核开关:0-关闭，1-开启',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `sort` int(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  `qualification_picture` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '资质图片',
  `back_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商户背景图',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商户头像',
  `street_back_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商户街背景图',
  `intro` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商户简介',
  `create_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户创建类型：admin-管理员创建，apply-商户入驻申请',
  `create_id` int(11) NOT NULL DEFAULT 0 COMMENT '创建商户管理员ID',
  `admin_id` int(11) NOT NULL DEFAULT 0 COMMENT '关联管理账号ID',
  `copy_product_num` int(11) NOT NULL DEFAULT 0 COMMENT '复制商品数量',
  `balance` decimal(12, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '商户余额',
  `star_level` int(2) NOT NULL DEFAULT 4 COMMENT '商户星级1-5',
  `is_del` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `pc_banner` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'pcBanner',
  `pc_back_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'pc背景图',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_merchant
-- ----------------------------
INSERT INTO `eb_merchant` VALUES (2, '大粽子的杂货店', 5, 4, '大粽子', 'stivepeim@outlook.com', '18292417675', 2, '大粽子', '曲江池桥洞', 1, 1, 1, 0, '', 1, '[\"crmebimage/public/product/2022/06/18/7629f5f69e7540619b9ead71d00cd50f0fa68ab9b3.jpg\"]', 'crmebimage/public/operation/2022/06/20/53d232f8b7714e6a8322cb513e7a59d18udnr8q24c.jpg', 'crmebimage/public/store/2022/06/18/98c914267cad4e4d83f08bbb1b57ffaap525x1w2u7.png', 'crmebimage/public/operation/2022/06/20/d69b8bb418c74e1f9497a54fa10ddbdd1uxlu7sm61.jpg', '杂货铺，也就是想要啥有啥', 'admin', 3, 21, 56, 0.00, 4, 0, '2022-06-16 11:30:04', '2023-05-19 12:13:59', '[\"crmebimage/public/operation/2022/06/20/82f27cd31c8f437c83e1426b04cd95a88vzp1tlcj9.jpg\",\"crmebimage/public/operation/2022/06/20/e981ae8cc8e94c56987be5f22cda3d8b7ahfm8qfby.jpg\",\"crmebimage/public/operation/2022/06/20/81657874c2984c5cbffc5f6e4ccb81ackl6jglnp9f.jpg\",\"crmebimage/public/operation/2022/06/20/4a20fe1498bd438180d962eb5a5d0718tlljyy1kq6.jpg\"]', 'crmebimage/public/operation/2022/06/20/d69b8bb418c74e1f9497a54fa10ddbdd1uxlu7sm61.jpg');

-- ----------------------------
-- Table structure for eb_merchant_apply
-- ----------------------------
DROP TABLE IF EXISTS `eb_merchant_apply`;
CREATE TABLE `eb_merchant_apply`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '申请ID',
  `uid` int(11) NOT NULL COMMENT '申请用户ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户名称',
  `category_id` int(11) NOT NULL COMMENT '商户分类ID',
  `type_id` int(11) NOT NULL COMMENT '商户类型ID',
  `account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商户账号',
  `password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '登录密码',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户姓名',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户邮箱',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商户手机号',
  `handling_fee` int(3) NOT NULL COMMENT '手续费(%)',
  `keywords` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商户关键字',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商户地址',
  `is_self` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '是否自营：0-自营，1-非自营',
  `is_recommend` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否推荐:0-不推荐，1-推荐',
  `audit_status` int(2) UNSIGNED NOT NULL DEFAULT 1 COMMENT '审核状态：1-待审核，2-审核通过，3-审核拒绝',
  `denial_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '拒绝原因',
  `auditor_id` int(11) NOT NULL DEFAULT 0 COMMENT '审核员ID',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `qualification_picture` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '资质图片',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商户申请表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_merchant_apply
-- ----------------------------

-- ----------------------------
-- Table structure for eb_merchant_bill
-- ----------------------------
DROP TABLE IF EXISTS `eb_merchant_bill`;
CREATE TABLE `eb_merchant_bill`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '帐单id',
  `pid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父级id（平台流水id）',
  `uid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户uid',
  `mer_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户id',
  `link_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '关联id',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '关联订单',
  `pm` int(2) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0 = 支出 1 = 获得',
  `amount` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '金额',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '类型：pay_order-订单支付,refund_order-订单退款',
  `mark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE,
  INDEX `mer_id`(`mer_id`) USING BTREE,
  INDEX `pid`(`pid`) USING BTREE,
  INDEX `pm`(`pm`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商户帐单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_merchant_bill
-- ----------------------------

-- ----------------------------
-- Table structure for eb_merchant_category
-- ----------------------------
DROP TABLE IF EXISTS `eb_merchant_category`;
CREATE TABLE `eb_merchant_category`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分类名称',
  `handling_fee` int(3) NOT NULL COMMENT '手续费(%)',
  `is_del` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商户分类表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_merchant_category
-- ----------------------------
INSERT INTO `eb_merchant_category` VALUES (1, '贵重珠宝、首饰零售', 3, 0, '2022-03-09 09:39:52', '2022-03-09 09:39:52');
INSERT INTO `eb_merchant_category` VALUES (2, '玻璃器皿和水晶饰品店', 2, 0, '2022-03-09 09:46:07', '2022-03-09 09:46:07');
INSERT INTO `eb_merchant_category` VALUES (3, '古玩复制店', 1, 0, '2022-03-09 09:50:59', '2022-03-09 09:50:59');
INSERT INTO `eb_merchant_category` VALUES (4, '工艺美术商店', 3, 0, '2022-03-10 14:23:14', '2022-03-10 14:23:14');
INSERT INTO `eb_merchant_category` VALUES (5, '奢侈品零售', 2, 0, '2022-04-22 09:59:53', '2022-04-22 09:59:53');
INSERT INTO `eb_merchant_category` VALUES (6, '男女及儿童制服和服装', 3, 0, '2022-04-22 09:58:14', '2022-04-22 09:58:14');

-- ----------------------------
-- Table structure for eb_merchant_daily_statement
-- ----------------------------
DROP TABLE IF EXISTS `eb_merchant_daily_statement`;
CREATE TABLE `eb_merchant_daily_statement`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '帐单id',
  `mer_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户id',
  `order_income_amount` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '订单收入金额',
  `order_pay_amount` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '订单支付总金额',
  `order_num` int(10) NOT NULL DEFAULT 0 COMMENT '订单支付笔数',
  `handling_fee` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '平台手续费',
  `payout_amount` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '支出总金额',
  `payout_num` int(10) NOT NULL DEFAULT 0 COMMENT '支出笔数',
  `refund_amount` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '平台退款金额',
  `refund_num` int(10) NOT NULL DEFAULT 0 COMMENT '退款笔数',
  `income_expenditure` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '商户日收支',
  `data_date` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '日期：年-月-日',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `data_date`(`data_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商户日帐单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_merchant_daily_statement
-- ----------------------------
INSERT INTO `eb_merchant_daily_statement` VALUES (1, 2, 0.00, 0.00, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, '2025-04-03');
INSERT INTO `eb_merchant_daily_statement` VALUES (2, 2, 0.00, 0.00, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, '2025-04-06');
INSERT INTO `eb_merchant_daily_statement` VALUES (3, 2, 0.00, 0.00, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, '2025-04-07');
INSERT INTO `eb_merchant_daily_statement` VALUES (4, 2, 0.00, 0.00, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, '2025-04-08');
INSERT INTO `eb_merchant_daily_statement` VALUES (5, 2, 0.00, 0.00, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, '2025-04-09');
INSERT INTO `eb_merchant_daily_statement` VALUES (6, 2, 0.00, 0.00, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, '2025-04-10');
INSERT INTO `eb_merchant_daily_statement` VALUES (7, 2, 0.00, 0.00, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, '2025-04-11');
INSERT INTO `eb_merchant_daily_statement` VALUES (8, 2, 0.00, 0.00, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, '2025-04-12');
INSERT INTO `eb_merchant_daily_statement` VALUES (9, 2, 0.00, 0.00, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, '2025-04-13');
INSERT INTO `eb_merchant_daily_statement` VALUES (10, 2, 0.00, 0.00, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, '2025-04-14');
INSERT INTO `eb_merchant_daily_statement` VALUES (11, 2, 0.00, 0.00, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, '2025-04-15');
INSERT INTO `eb_merchant_daily_statement` VALUES (12, 2, 0.00, 0.00, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, '2025-04-16');
INSERT INTO `eb_merchant_daily_statement` VALUES (13, 2, 0.00, 0.00, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, '2025-04-21');
INSERT INTO `eb_merchant_daily_statement` VALUES (14, 2, 0.00, 0.00, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, '2025-04-22');

-- ----------------------------
-- Table structure for eb_merchant_info
-- ----------------------------
DROP TABLE IF EXISTS `eb_merchant_info`;
CREATE TABLE `eb_merchant_info`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '商户信息ID',
  `mer_id` int(11) NOT NULL COMMENT '商户ID',
  `transfer_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'bank' COMMENT '转账类型:bank-银行卡',
  `transfer_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '转账姓名',
  `transfer_bank` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '转账银行',
  `transfer_bank_card` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '转账银行卡号',
  `alert_stock` int(5) NOT NULL DEFAULT 0 COMMENT '警戒库存',
  `service_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '客服类型：H5-H5链接、phone-电话、message-Message,email-邮箱',
  `service_link` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '客服H5链接',
  `service_phone` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '客服电话',
  `service_message` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '客服Message',
  `service_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '客服邮箱',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `mer_id`(`mer_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_merchant_info
-- ----------------------------
INSERT INTO `eb_merchant_info` VALUES (2, 2, 'bank', '大粽子', '中国银行', '611086532836485358437', 0, 'phone', '', '18292417675', 'peim_stive', 'stivepeim@outlook.com', '2022-06-16 11:30:04', '2022-06-16 11:44:14');

-- ----------------------------
-- Table structure for eb_merchant_month_statement
-- ----------------------------
DROP TABLE IF EXISTS `eb_merchant_month_statement`;
CREATE TABLE `eb_merchant_month_statement`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '帐单id',
  `mer_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户id',
  `order_income_amount` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '订单收入金额',
  `order_pay_amount` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '订单支付总金额',
  `order_num` int(10) NOT NULL DEFAULT 0 COMMENT '订单支付笔数',
  `handling_fee` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '平台手续费',
  `payout_amount` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '支出总金额',
  `payout_num` int(10) NOT NULL DEFAULT 0 COMMENT '支出笔数',
  `refund_amount` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '平台退款金额',
  `refund_num` int(10) NOT NULL DEFAULT 0 COMMENT '退款笔数',
  `income_expenditure` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '商户月收支',
  `data_date` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '日期：年-月',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `data_date`(`data_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商户月帐单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_merchant_month_statement
-- ----------------------------
INSERT INTO `eb_merchant_month_statement` VALUES (2, 2, 0.00, 0.00, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, '2022-06');

-- ----------------------------
-- Table structure for eb_merchant_type
-- ----------------------------
DROP TABLE IF EXISTS `eb_merchant_type`;
CREATE TABLE `eb_merchant_type`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型名称',
  `info` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型要求说明',
  `is_del` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商户类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_merchant_type
-- ----------------------------
INSERT INTO `eb_merchant_type` VALUES (1, '官方旗舰店', '官方有效营业执照与联系人工作证、身份证1', 0, '2022-03-10 15:13:23', '2022-03-10 15:13:23');
INSERT INTO `eb_merchant_type` VALUES (2, '厂家直营店', '厂家营业执照与联系人工作证、身份证', 0, '2022-03-10 15:13:53', '2022-03-10 15:13:53');
INSERT INTO `eb_merchant_type` VALUES (3, '专卖店', '官方有效营业执照与联系人工作证、身份证122222', 0, '2022-03-10 20:08:18', '2022-03-10 20:08:18');
INSERT INTO `eb_merchant_type` VALUES (4, '旗舰店', '营业执照、安全卫生许可证', 0, '2022-05-11 12:12:19', '2022-05-11 12:12:19');
INSERT INTO `eb_merchant_type` VALUES (5, '加工厂', '联系人方式', 1, '2022-05-11 12:14:13', '2022-05-11 12:14:13');

-- ----------------------------
-- Table structure for eb_order_detail
-- ----------------------------
DROP TABLE IF EXISTS `eb_order_detail`;
CREATE TABLE `eb_order_detail`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `mer_id` int(11) UNSIGNED NOT NULL COMMENT '商户ID',
  `uid` int(11) UNSIGNED NOT NULL COMMENT '用户id',
  `product_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商品ID',
  `product_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商品名称',
  `image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商品图片',
  `attr_value_id` int(11) NOT NULL COMMENT '商品规格值 ID',
  `sku` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商品sku',
  `price` decimal(8, 2) UNSIGNED NOT NULL COMMENT '商品单价',
  `vip_price` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '会员价格',
  `pay_price` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '实际支付金额',
  `pay_num` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '购买数量',
  `weight` decimal(8, 2) UNSIGNED NOT NULL COMMENT '重量',
  `volume` decimal(8, 2) UNSIGNED NOT NULL COMMENT '体积',
  `is_reply` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否评价，0-未评价，1-已评价',
  `is_receipt` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否收货，0-未收货，1-已收货',
  `sub_brokerage_type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '分佣类型:0-不参与分佣，1-单独分佣，2-默认分佣',
  `brokerage` int(3) NOT NULL DEFAULT 0 COMMENT '一级返佣比例',
  `brokerage_two` int(3) NOT NULL DEFAULT 0 COMMENT '二级返佣比例',
  `freight_fee` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '运费金额',
  `coupon_price` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '优惠券金额',
  `use_integral` int(11) NOT NULL DEFAULT 0 COMMENT '使用积分',
  `integral_price` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '积分抵扣金额',
  `gain_integral` int(11) NOT NULL DEFAULT 0 COMMENT '赠送积分',
  `product_type` int(2) NOT NULL DEFAULT 0 COMMENT '基础类型：0=普通商品,1-积分商品,2-虚拟商品,4=视频号,5-云盘商品,6-卡密商品',
  `first_brokerage_fee` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '一级返佣金额',
  `second_brokerage_fee` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '二级返佣金额',
  `delivery_num` int(11) NOT NULL DEFAULT 0 COMMENT '发货数量',
  `apply_refund_num` int(11) NOT NULL DEFAULT 0 COMMENT '申请退款数量',
  `refund_num` int(11) NOT NULL DEFAULT 0 COMMENT '退款数量',
  `refund_price` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '退款金额',
  `refund_use_integral` int(11) NOT NULL DEFAULT 0 COMMENT '退使用积分',
  `refund_integral_price` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '退款积分抵扣金额',
  `refund_gain_integral` int(11) NOT NULL DEFAULT 0 COMMENT '退赠送积分',
  `refund_first_brokerage_fee` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '退一级返佣金额',
  `refund_second_brokerage_fee` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '退二级返佣金额',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `mer_coupon_price` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '商户优惠券金额',
  `plat_coupon_price` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '平台优惠券金额',
  `refund_plat_coupon_price` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '退还平台优惠券金额',
  `refund_freight_fee` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '退运费金额',
  `expand` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '拓展文本，例云盘链接',
  `card_secret_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '卡密ID字符串',
  `is_svip` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否svip订单',
  `is_paid_member_product` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否付费会员商品',
  `product_marketing_type` int(2) NOT NULL DEFAULT 0 COMMENT '营销类型：0=基础商品,1=秒杀,2=拼团',
  `redeem_integral` int(8) NOT NULL DEFAULT 0 COMMENT '兑换积分',
  `pro_refund_switch` tinyint(1) NULL DEFAULT 1 COMMENT '商品是否支持退款',
  `group_buy_activity_id` int(11) NOT NULL DEFAULT 0 COMMENT '拼团活动id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no`(`order_no`) USING BTREE,
  INDEX `mer_id`(`mer_id`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4703 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单详情表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for eb_order_logistics
-- ----------------------------
DROP TABLE IF EXISTS `eb_order_logistics`;
CREATE TABLE `eb_order_logistics`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_no` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单编号',
  `exp_no` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '快递单号',
  `exp_code` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '快递公司编号',
  `exp_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '快递公司名称',
  `courier` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '快递员 或 快递站(没有则为空)',
  `courier_phone` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '快递员电话 (没有则为空)',
  `track_time` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '最后的轨迹时间',
  `logistics_info` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '快递物流轨迹（JSON）AcceptStation-快递中转站，终点站，AcceptTime-事件时间',
  `state` int(2) NULL DEFAULT 0 COMMENT '物流状态：-1：单号或快递公司代码错误, 0：暂无轨迹， 1：快递收件(揽件)，2：在途中,3：签收,4：问题件 5.疑难件 6.退件签收',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `reason` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '提示信息',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '快递记录表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of eb_order_logistics
-- ----------------------------

-- ----------------------------
-- Table structure for eb_platform_daily_statement
-- ----------------------------
DROP TABLE IF EXISTS `eb_platform_daily_statement`;
CREATE TABLE `eb_platform_daily_statement`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '帐单id',
  `order_pay_amount` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '订单支付总金额',
  `total_order_num` int(10) NOT NULL DEFAULT 0 COMMENT '总订单支付笔数',
  `merchant_order_num` int(10) NOT NULL DEFAULT 0 COMMENT '分订单支付笔数',
  `handling_fee` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '日手续费收入',
  `payout_amount` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '支出总金额',
  `payout_num` int(10) NOT NULL DEFAULT 0 COMMENT '支出笔数',
  `merchant_transfer_amount` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '商户分账金额',
  `merchant_transfer_num` int(10) NOT NULL DEFAULT 0 COMMENT '商户分账笔数',
  `refund_amount` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '平台退款金额',
  `refund_num` int(10) NOT NULL DEFAULT 0 COMMENT '退款笔数',
  `income_expenditure` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '平台日收支',
  `data_date` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '日期：年-月-日',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `data_date`(`data_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '平台日帐单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_platform_daily_statement
-- ----------------------------
INSERT INTO `eb_platform_daily_statement` VALUES (1, 0.00, 0, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, 0, 0.00, '2022-06-16');
INSERT INTO `eb_platform_daily_statement` VALUES (2, 0.00, 0, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, 0, 0.00, '2022-06-17');
INSERT INTO `eb_platform_daily_statement` VALUES (3, 0.00, 0, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, 0, 0.00, '2022-06-18');
INSERT INTO `eb_platform_daily_statement` VALUES (4, 0.00, 0, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, 0, 0.00, '2022-06-19');
INSERT INTO `eb_platform_daily_statement` VALUES (5, 0.00, 0, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, 0, 0.00, '2022-06-20');
INSERT INTO `eb_platform_daily_statement` VALUES (6, 0.00, 0, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, 0, 0.00, '2025-04-03');
INSERT INTO `eb_platform_daily_statement` VALUES (7, 0.00, 0, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, 0, 0.00, '2025-04-06');
INSERT INTO `eb_platform_daily_statement` VALUES (8, 0.00, 0, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, 0, 0.00, '2025-04-07');
INSERT INTO `eb_platform_daily_statement` VALUES (9, 0.00, 0, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, 0, 0.00, '2025-04-08');
INSERT INTO `eb_platform_daily_statement` VALUES (10, 0.00, 0, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, 0, 0.00, '2025-04-09');
INSERT INTO `eb_platform_daily_statement` VALUES (11, 0.00, 0, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, 0, 0.00, '2025-04-10');
INSERT INTO `eb_platform_daily_statement` VALUES (12, 0.00, 0, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, 0, 0.00, '2025-04-11');
INSERT INTO `eb_platform_daily_statement` VALUES (13, 0.00, 0, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, 0, 0.00, '2025-04-12');
INSERT INTO `eb_platform_daily_statement` VALUES (14, 0.00, 0, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, 0, 0.00, '2025-04-13');
INSERT INTO `eb_platform_daily_statement` VALUES (15, 0.00, 0, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, 0, 0.00, '2025-04-14');
INSERT INTO `eb_platform_daily_statement` VALUES (16, 0.00, 0, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, 0, 0.00, '2025-04-15');
INSERT INTO `eb_platform_daily_statement` VALUES (17, 0.00, 0, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, 0, 0.00, '2025-04-16');
INSERT INTO `eb_platform_daily_statement` VALUES (18, 0.00, 0, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, 0, 0.00, '2025-04-21');
INSERT INTO `eb_platform_daily_statement` VALUES (19, 0.00, 0, 0, 0.00, 0.00, 0, 0.00, 0, 0.00, 0, 0.00, '2025-04-22');

-- ----------------------------
-- Table structure for eb_platform_month_statement
-- ----------------------------
DROP TABLE IF EXISTS `eb_platform_month_statement`;
CREATE TABLE `eb_platform_month_statement`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '帐单id',
  `order_pay_amount` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '订单支付总金额',
  `total_order_num` int(10) NOT NULL DEFAULT 0 COMMENT '总订单支付笔数',
  `merchant_order_num` int(10) NOT NULL DEFAULT 0 COMMENT '分订单支付笔数',
  `handling_fee` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '月手续费收入',
  `payout_amount` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '支出总金额',
  `payout_num` int(10) NOT NULL DEFAULT 0 COMMENT '支出笔数',
  `merchant_transfer_amount` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '商户分账金额',
  `merchant_transfer_num` int(10) NOT NULL DEFAULT 0 COMMENT '商户分账笔数',
  `refund_amount` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '平台退款金额',
  `refund_num` int(10) NOT NULL DEFAULT 0 COMMENT '退款笔数',
  `income_expenditure` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '平台月收支',
  `data_date` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '日期：年-月',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `data_date`(`data_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '平台月帐单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_platform_month_statement
-- ----------------------------

-- ----------------------------
-- Table structure for eb_product_brand
-- ----------------------------
DROP TABLE IF EXISTS `eb_product_brand`;
CREATE TABLE `eb_product_brand`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '名称',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'icon',
  `sort` int(5) NOT NULL DEFAULT 999 COMMENT '排序',
  `is_show` tinyint(1) NOT NULL DEFAULT 1 COMMENT '显示状态',
  `is_del` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '是否删除',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品品牌表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_product_brand
-- ----------------------------
INSERT INTO `eb_product_brand` VALUES (1, 'PORTS', 'crmebimage/public/store/2022/06/18/a535246301f44d3f8d511ac3e2dbe34454i3ti6t57.jpeg', 1, 1, 1, '2022-06-15 14:13:12', '2022-06-18 16:48:26');
INSERT INTO `eb_product_brand` VALUES (2, 'cake', 'crmebimage/public/store/2022/06/18/b153883e27dc47c9a13b8fa77f50b8a8ytr7zhk933.png', 1, 1, 0, '2022-06-18 15:10:38', '2022-06-18 15:10:38');
INSERT INTO `eb_product_brand` VALUES (3, 'LAUREN Ralph Lauren', 'crmebimage/public/store/2022/06/18/2b621f5bfc2248b7976b065ffb26c3e8wv5kovrs0m.jpg', 1, 1, 0, '2022-06-18 17:20:18', '2022-06-18 17:20:18');

-- ----------------------------
-- Table structure for eb_product_brand_category
-- ----------------------------
DROP TABLE IF EXISTS `eb_product_brand_category`;
CREATE TABLE `eb_product_brand_category`  (
  `bid` int(11) NOT NULL COMMENT '品牌id',
  `cid` int(11) NOT NULL COMMENT '分类id',
  PRIMARY KEY (`bid`, `cid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品品牌分类关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_product_brand_category
-- ----------------------------
INSERT INTO `eb_product_brand_category` VALUES (2, 23);
INSERT INTO `eb_product_brand_category` VALUES (2, 24);
INSERT INTO `eb_product_brand_category` VALUES (2, 26);
INSERT INTO `eb_product_brand_category` VALUES (2, 27);
INSERT INTO `eb_product_brand_category` VALUES (2, 29);
INSERT INTO `eb_product_brand_category` VALUES (2, 30);
INSERT INTO `eb_product_brand_category` VALUES (2, 32);
INSERT INTO `eb_product_brand_category` VALUES (2, 33);
INSERT INTO `eb_product_brand_category` VALUES (2, 35);
INSERT INTO `eb_product_brand_category` VALUES (2, 36);
INSERT INTO `eb_product_brand_category` VALUES (2, 38);
INSERT INTO `eb_product_brand_category` VALUES (2, 39);
INSERT INTO `eb_product_brand_category` VALUES (2, 82);
INSERT INTO `eb_product_brand_category` VALUES (2, 83);
INSERT INTO `eb_product_brand_category` VALUES (2, 84);
INSERT INTO `eb_product_brand_category` VALUES (2, 85);
INSERT INTO `eb_product_brand_category` VALUES (2, 86);
INSERT INTO `eb_product_brand_category` VALUES (2, 87);
INSERT INTO `eb_product_brand_category` VALUES (3, 97);

-- ----------------------------
-- Table structure for eb_product_category
-- ----------------------------
DROP TABLE IF EXISTS `eb_product_category`;
CREATE TABLE `eb_product_category`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父级ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '名称',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'icon',
  `level` int(2) NOT NULL DEFAULT 1 COMMENT '级别:1，2，3',
  `sort` int(5) NOT NULL DEFAULT 999 COMMENT '排序',
  `is_show` tinyint(1) NOT NULL DEFAULT 1 COMMENT '显示状态',
  `is_del` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '是否删除',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 98 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品分类表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_product_category
-- ----------------------------
INSERT INTO `eb_product_category` VALUES (20, 0, 'HOME PET', 'crmebimage/public/product/2022/06/18/791b3949677845cbb726160a10f29185j4j6vtpg2f.png', 1, 1, 1, 0, '2022-06-06 15:14:14', '2022-06-18 16:21:04');
INSERT INTO `eb_product_category` VALUES (21, 20, 'Pet supp', 'crmebimage/public/product/2022/06/18/89f34c76bff9437a822f4dbe55cc8906xjrr5dqdb8.png', 2, 1, 1, 0, '2022-06-06 15:14:39', '2022-06-18 16:21:47');
INSERT INTO `eb_product_category` VALUES (22, 20, 'Supplies', 'crmebimage/public/store/2022/06/06/db5055588c774c43a0b34c2bb8cda881nhlfc8and0.png', 2, 1, 1, 1, '2022-06-06 15:15:13', '2022-06-06 15:15:13');
INSERT INTO `eb_product_category` VALUES (23, 21, 'Pet s', 'crmebimage/public/product/2022/06/18/89f34c76bff9437a822f4dbe55cc8906xjrr5dqdb8.png', 3, 1, 1, 0, '2022-06-06 15:16:24', '2022-06-18 16:21:29');
INSERT INTO `eb_product_category` VALUES (24, 21, 'Supplies', 'crmebimage/public/product/2022/06/18/8eeb59b0137b41799b24d6319a10fbccrnp2v5ly1d.png', 3, 1, 1, 0, '2022-06-06 15:16:51', '2022-06-18 16:22:11');
INSERT INTO `eb_product_category` VALUES (25, 20, 'Bedding', 'crmebimage/public/product/2022/06/18/256625d2bf3a4c6092b4fe66764a2e28oxkm006stx.jpg', 2, 1, 1, 0, '2022-06-06 15:17:21', '2022-06-18 16:23:41');
INSERT INTO `eb_product_category` VALUES (26, 25, 'Beddings', 'crmebimage/public/product/2022/06/18/256625d2bf3a4c6092b4fe66764a2e28oxkm006stx.jpg', 3, 1, 1, 0, '2022-06-06 15:17:55', '2022-06-18 16:23:52');
INSERT INTO `eb_product_category` VALUES (27, 25, 'Pillow', 'crmebimage/public/product/2022/06/18/49940e8a977f42f7b55e3925f9955da8340kd104n8.jpg', 3, 1, 1, 0, '2022-06-06 15:18:36', '2022-06-18 16:24:10');
INSERT INTO `eb_product_category` VALUES (28, 20, 'Organize', 'crmebimage/public/product/2022/06/18/cf85ef8fa16344a982a2077fcf8fd8c9w96h34lbjn.jpg', 2, 1, 1, 0, '2022-06-06 15:19:24', '2022-06-18 16:25:44');
INSERT INTO `eb_product_category` VALUES (29, 28, 'C Organi', 'crmebimage/public/product/2022/06/18/cf85ef8fa16344a982a2077fcf8fd8c9w96h34lbjn.jpg', 3, 1, 1, 0, '2022-06-06 15:19:52', '2022-06-18 16:25:58');
INSERT INTO `eb_product_category` VALUES (30, 28, 'M Organi', 'crmebimage/public/product/2022/06/18/0e40a97d8b0c47fbb9f2dd83274dd33db1c2kk71q7.jpg', 3, 1, 1, 0, '2022-06-06 15:20:19', '2022-06-18 16:26:17');
INSERT INTO `eb_product_category` VALUES (31, 20, 'Cookware', 'crmebimage/public/product/2022/06/18/e3be2b2e4b9443e4bda60a0d811367e5t1d4kft06j.jpg', 2, 1, 1, 0, '2022-06-06 15:20:47', '2022-06-18 16:27:27');
INSERT INTO `eb_product_category` VALUES (32, 31, 'Pan', 'crmebimage/public/product/2022/06/18/e3be2b2e4b9443e4bda60a0d811367e5t1d4kft06j.jpg', 3, 1, 1, 0, '2022-06-06 15:21:26', '2022-06-18 16:27:50');
INSERT INTO `eb_product_category` VALUES (33, 31, 'Plate', 'crmebimage/public/product/2022/06/18/a5fb7d2e4e1a46fdb3c273a901089507497u3lglzw.jpg', 3, 1, 1, 0, '2022-06-06 15:22:21', '2022-06-18 16:28:02');
INSERT INTO `eb_product_category` VALUES (34, 20, 'Yiwu ind', 'crmebimage/public/product/2022/06/18/a0bc21996af64d1ea1fcca907f026c35plk82xme1p.jpg', 2, 1, 1, 0, '2022-06-06 15:22:48', '2022-06-18 16:30:32');
INSERT INTO `eb_product_category` VALUES (35, 34, 'small co', 'crmebimage/public/product/2022/06/18/a0bc21996af64d1ea1fcca907f026c35plk82xme1p.jpg', 3, 1, 1, 0, '2022-06-06 15:23:19', '2022-06-18 16:30:42');
INSERT INTO `eb_product_category` VALUES (36, 34, 'Commonly', 'crmebimage/public/product/2022/06/18/7311574d9e434fa594d64b891756199dea0i8mb1ha.jpg', 3, 1, 1, 0, '2022-06-06 15:23:49', '2022-06-18 16:30:58');
INSERT INTO `eb_product_category` VALUES (37, 20, 'Pet Top', 'crmebimage/public/product/2022/06/18/e79c2e164e9d455093c70cfb2dbfc85ezku22wmraq.jpg', 2, 1, 1, 0, '2022-06-06 15:24:27', '2022-06-18 16:31:34');
INSERT INTO `eb_product_category` VALUES (38, 37, 'Top Sale', 'crmebimage/public/product/2022/06/18/e79c2e164e9d455093c70cfb2dbfc85ezku22wmraq.jpg', 3, 1, 1, 0, '2022-06-06 15:24:57', '2022-06-18 16:31:44');
INSERT INTO `eb_product_category` VALUES (39, 37, 'Used', 'crmebimage/public/product/2022/06/18/8bcb2eb92dc948859c326f89df32283epfxcr2zc3r.jpg', 3, 1, 1, 0, '2022-06-06 15:25:24', '2022-06-18 16:31:59');
INSERT INTO `eb_product_category` VALUES (40, 0, 'OUTDOORS', 'crmebimage/public/product/2022/06/18/59a74fa47497499e87f419fa2af4b48b6urr56beba.png', 1, 1, 1, 0, '2022-06-06 15:37:27', '2022-06-18 16:34:01');
INSERT INTO `eb_product_category` VALUES (41, 40, 'WaterSpo', 'crmebimage/public/product/2022/06/18/dce92e38b7564e1abafcd206865dc688ed1tgfx0tt.png', 2, 1, 1, 0, '2022-06-06 15:38:13', '2022-06-18 16:34:24');
INSERT INTO `eb_product_category` VALUES (42, 41, 'Swimming', 'crmebimage/public/product/2022/06/18/dce92e38b7564e1abafcd206865dc688ed1tgfx0tt.png', 3, 1, 1, 0, '2022-06-06 15:38:46', '2022-06-18 16:34:35');
INSERT INTO `eb_product_category` VALUES (43, 41, 'diving', 'crmebimage/public/product/2022/06/18/c895ed62a6f74427a99c090574f53550h9c9lcdfhf.png', 3, 1, 1, 0, '2022-06-06 15:39:11', '2022-06-18 16:34:51');
INSERT INTO `eb_product_category` VALUES (44, 40, 'Yoga sui', 'crmebimage/public/product/2022/06/18/997b9a0d96aa409f86b61e8935212436gazj63iupp.png', 2, 1, 1, 0, '2022-06-06 15:39:33', '2022-06-18 16:36:26');
INSERT INTO `eb_product_category` VALUES (45, 44, 'Yoga Pan', 'crmebimage/public/product/2022/06/18/524910ddd9c6482c8c70e1e6029cd18endhup3y4gl.png', 3, 1, 1, 0, '2022-06-06 15:40:14', '2022-06-18 16:36:52');
INSERT INTO `eb_product_category` VALUES (46, 44, 'Yoga', 'crmebimage/public/product/2022/06/18/997b9a0d96aa409f86b61e8935212436gazj63iupp.png', 3, 1, 1, 0, '2022-06-06 15:40:38', '2022-06-18 16:37:01');
INSERT INTO `eb_product_category` VALUES (47, 40, 'Team Spo', 'crmebimage/public/product/2022/06/18/34c0cd755bfb4c0da2d7ed0261905edcp4n01l30w7.png', 2, 1, 1, 0, '2022-06-06 15:41:02', '2022-06-18 16:38:37');
INSERT INTO `eb_product_category` VALUES (48, 47, 'Ball', 'crmebimage/public/product/2022/06/18/34c0cd755bfb4c0da2d7ed0261905edcp4n01l30w7.png', 3, 1, 1, 0, '2022-06-06 15:41:19', '2022-06-18 16:38:54');
INSERT INTO `eb_product_category` VALUES (49, 47, 'Badminto', 'crmebimage/public/product/2022/06/18/0c41763dac274e29b45cd273338a2b52yzb0cwj0c0.png', 3, 1, 1, 0, '2022-06-06 15:41:50', '2022-06-18 16:39:05');
INSERT INTO `eb_product_category` VALUES (50, 40, 'Out door', 'crmebimage/public/product/2022/06/18/13c7420d36f742ac880d501aba30dd7cnab51hroks.png', 2, 1, 1, 0, '2022-06-06 15:42:42', '2022-06-18 16:39:29');
INSERT INTO `eb_product_category` VALUES (51, 50, 'Mountain', 'crmebimage/public/product/2022/06/18/13c7420d36f742ac880d501aba30dd7cnab51hroks.png', 3, 1, 1, 0, '2022-06-06 15:43:13', '2022-06-18 16:39:39');
INSERT INTO `eb_product_category` VALUES (52, 50, 'lighting', 'crmebimage/public/product/2022/06/18/1aef8b8b35254ab98f6b5a4b69436c6368eoz7c4ce.png', 3, 1, 1, 0, '2022-06-06 15:43:42', '2022-06-18 16:39:52');
INSERT INTO `eb_product_category` VALUES (53, 40, 'Fitness ', 'crmebimage/public/product/2022/06/18/4ad28d4d84534aa1be84b6fe9f782e64gffx0tqq2k.jpg', 2, 1, 1, 0, '2022-06-06 15:45:52', '2022-06-18 16:40:22');
INSERT INTO `eb_product_category` VALUES (54, 53, 'Body bui', 'crmebimage/public/product/2022/06/18/3e05b25d8cce4072aac085ac486b3da5yz4enhu7ak.png', 3, 1, 1, 0, '2022-06-06 15:46:25', '2022-06-18 16:40:28');
INSERT INTO `eb_product_category` VALUES (55, 53, 'Bbuildin', 'crmebimage/public/product/2022/06/18/4ad28d4d84534aa1be84b6fe9f782e64gffx0tqq2k.jpg', 3, 1, 1, 0, '2022-06-06 15:47:29', '2022-06-18 16:40:34');
INSERT INTO `eb_product_category` VALUES (56, 40, 'B TopSal', 'crmebimage/public/product/2022/06/18/c3ea8f6f85e940f88f539fea2c4df96b72m4w0yacl.png', 2, 1, 1, 0, '2022-06-06 15:47:53', '2022-06-18 16:40:48');
INSERT INTO `eb_product_category` VALUES (57, 56, 'BuildBod', 'crmebimage/public/product/2022/06/18/115ca3ee301d41a6824365b393f76590kj66zndb4e.png', 3, 1, 1, 0, '2022-06-06 15:48:44', '2022-06-18 16:40:53');
INSERT INTO `eb_product_category` VALUES (58, 56, 'Body Spo', 'crmebimage/public/product/2022/06/18/c3ea8f6f85e940f88f539fea2c4df96b72m4w0yacl.png', 3, 1, 1, 0, '2022-06-06 15:49:10', '2022-06-18 16:40:58');
INSERT INTO `eb_product_category` VALUES (59, 0, 'APPLIANC', 'crmebimage/public/product/2022/06/18/392a8673e6064d519ff3e7ed572380866nlt52z8oy.png', 1, 1, 1, 0, '2022-06-06 15:55:22', '2022-06-18 16:41:22');
INSERT INTO `eb_product_category` VALUES (60, 59, 'Man', 'crmebimage/public/store/2022/06/06/37ea8a4c43594c3bb63f2431751512209u7xitvn3p.png', 3, 1, 1, 1, '2022-06-06 15:56:11', '2022-06-06 15:57:25');
INSERT INTO `eb_product_category` VALUES (61, 59, 'Women', 'crmebimage/public/store/2022/06/06/9e80289a8b98406aa4cf3f2cf7254f5eprehjsazud.png', 3, 1, 1, 1, '2022-06-06 15:56:39', '2022-06-06 15:57:52');
INSERT INTO `eb_product_category` VALUES (62, 59, 'Personal', 'crmebimage/public/product/2022/06/18/f2b3d7340ffa43348733805175f4569avbr0xw892q.png', 2, 1, 1, 0, '2022-06-06 15:57:15', '2022-06-18 16:41:51');
INSERT INTO `eb_product_category` VALUES (63, 62, 'Man', 'crmebimage/public/product/2022/06/18/f2b3d7340ffa43348733805175f4569avbr0xw892q.png', 3, 1, 1, 0, '2022-06-06 16:09:42', '2022-06-18 16:42:06');
INSERT INTO `eb_product_category` VALUES (64, 62, 'Women', 'crmebimage/public/product/2022/06/18/39bd35f345404f2e923ab9e1aaea55355fjx89v8go.png', 3, 1, 1, 0, '2022-06-06 16:10:01', '2022-06-18 16:42:22');
INSERT INTO `eb_product_category` VALUES (65, 59, 'LivingRo', 'crmebimage/public/product/2022/06/18/4130adc7bbf249409222d3075952a1f4plk9tsdqvu.png', 2, 1, 1, 0, '2022-06-06 16:13:36', '2022-06-18 16:44:31');
INSERT INTO `eb_product_category` VALUES (66, 65, 'Living', 'crmebimage/public/product/2022/06/18/4130adc7bbf249409222d3075952a1f4plk9tsdqvu.png', 3, 1, 1, 0, '2022-06-06 16:13:50', '2022-06-18 16:44:42');
INSERT INTO `eb_product_category` VALUES (67, 65, 'Room', 'crmebimage/public/product/2022/06/18/6c48e6761825426d83c4315e139dcc58qdotn3725v.png', 3, 1, 1, 0, '2022-06-06 16:14:07', '2022-06-18 16:44:53');
INSERT INTO `eb_product_category` VALUES (68, 59, 'Dessert', 'crmebimage/public/product/2022/06/18/b2d497f822b545da99af8b8f761d8e96sdzercwxj3.png', 2, 1, 1, 0, '2022-06-06 16:14:30', '2022-06-18 16:45:56');
INSERT INTO `eb_product_category` VALUES (69, 68, 'breakfas', 'crmebimage/public/product/2022/06/18/b2d497f822b545da99af8b8f761d8e96sdzercwxj3.png', 3, 1, 1, 0, '2022-06-06 16:16:56', '2022-06-18 16:46:15');
INSERT INTO `eb_product_category` VALUES (70, 68, 'Baking', 'crmebimage/public/product/2022/06/18/02172a55fb74426d803185375a97e04fhldonwcwwv.png', 3, 1, 1, 0, '2022-06-06 16:17:24', '2022-06-18 16:46:29');
INSERT INTO `eb_product_category` VALUES (71, 59, 'Beverage', 'crmebimage/public/product/2022/06/18/556bf5fd0fc348c99873b018d9053e0ee4wmp526hf.png', 2, 1, 1, 0, '2022-06-06 16:17:48', '2022-06-18 16:46:57');
INSERT INTO `eb_product_category` VALUES (72, 71, 'drink', 'crmebimage/public/product/2022/06/18/556bf5fd0fc348c99873b018d9053e0ee4wmp526hf.png', 3, 1, 1, 0, '2022-06-06 16:18:17', '2022-06-18 16:47:11');
INSERT INTO `eb_product_category` VALUES (73, 71, 'Coffice', 'crmebimage/public/product/2022/06/18/be452292b38245bc9b65decbaaf2aa53sthba80p26.png', 3, 1, 1, 0, '2022-06-06 16:18:37', '2022-06-18 16:47:20');
INSERT INTO `eb_product_category` VALUES (74, 71, 'fruit ju', 'crmebimage/public/product/2022/06/18/77bd47e6e1da4b1092c12e6efe6f947fr5wc98pn1z.png', 3, 1, 1, 0, '2022-06-06 16:19:09', '2022-06-18 16:47:32');
INSERT INTO `eb_product_category` VALUES (75, 68, 'Noodle s', 'crmebimage/public/product/2022/06/18/f293b290922f4ccbab84d70f2880c914sty4qif2eg.png', 3, 1, 1, 0, '2022-06-06 16:20:10', '2022-06-18 16:46:39');
INSERT INTO `eb_product_category` VALUES (76, 65, 'QueChao', 'crmebimage/public/product/2022/06/18/6c814b9b8c864263a39baab06173c741l2zl3u87gc.png', 3, 1, 1, 0, '2022-06-06 16:20:36', '2022-06-18 16:45:07');
INSERT INTO `eb_product_category` VALUES (77, 62, 'Fried', 'crmebimage/public/product/2022/06/18/d0eb461e6c7c43cb910fb9db89d37c3buk9j6bsscl.png', 3, 1, 1, 0, '2022-06-06 16:20:58', '2022-06-18 16:42:44');
INSERT INTO `eb_product_category` VALUES (78, 62, 'Flat Mic', 'crmebimage/public/product/2022/06/18/86b4489ccdad406595bb57cece8424406plwrosd7r.jpg', 3, 1, 1, 0, '2022-06-06 16:57:16', '2022-06-18 16:43:31');
INSERT INTO `eb_product_category` VALUES (79, 62, 'Insuranc', 'crmebimage/public/product/2022/06/18/334e9846f761457d92a60292a3230065s15w09qylg.jpg', 3, 1, 1, 0, '2022-06-06 16:57:48', '2022-06-18 16:43:53');
INSERT INTO `eb_product_category` VALUES (80, 62, 'flip flo', 'crmebimage/public/product/2022/06/18/5f4ab802d2e64c9d9f68cf165362dbe8y4z2012h4y.jpg', 3, 1, 1, 0, '2022-06-06 16:58:14', '2022-06-18 16:44:11');
INSERT INTO `eb_product_category` VALUES (81, 65, 'Live Man', 'crmebimage/public/product/2022/06/18/f2b3d7340ffa43348733805175f4569avbr0xw892q.png', 3, 1, 1, 0, '2022-06-06 16:59:29', '2022-06-18 16:45:25');
INSERT INTO `eb_product_category` VALUES (82, 21, 'warm', 'crmebimage/public/product/2022/06/18/8eeb59b0137b41799b24d6319a10fbccrnp2v5ly1d.png', 3, 1, 1, 0, '2022-06-06 18:22:18', '2022-06-18 16:23:09');
INSERT INTO `eb_product_category` VALUES (83, 25, 'Can live', 'crmebimage/public/product/2022/06/18/460731c735d947849fe30ca4f38c3131waoa5ek011.jpg', 3, 1, 1, 0, '2022-06-06 18:22:57', '2022-06-18 16:24:51');
INSERT INTO `eb_product_category` VALUES (84, 28, 'Swimwear', 'crmebimage/public/product/2022/06/18/c3ea8f6f85e940f88f539fea2c4df96b72m4w0yacl.png', 3, 1, 1, 0, '2022-06-06 18:25:13', '2022-06-18 16:27:04');
INSERT INTO `eb_product_category` VALUES (85, 31, 'Headgear', 'crmebimage/public/product/2022/06/18/b87f1fd44b764a3a8c2fbddb39a5fc11cm4e9h2utd.png', 3, 1, 1, 0, '2022-06-06 18:26:23', '2022-06-18 16:30:10');
INSERT INTO `eb_product_category` VALUES (86, 34, 'Smart de', 'crmebimage/public/product/2022/06/18/71b8a93bdecf46cfa56f57e2246f4fb3usgiba3jdw.jpg', 3, 1, 1, 0, '2022-06-06 18:27:21', '2022-06-18 16:31:12');
INSERT INTO `eb_product_category` VALUES (87, 37, 'Damp pan', 'crmebimage/public/product/2022/06/18/79e3eb9aaf184975a4079f8cad402e7ena2xzu5urm.jpg', 3, 1, 1, 0, '2022-06-06 18:31:27', '2022-06-18 16:33:03');
INSERT INTO `eb_product_category` VALUES (88, 41, 'full dre', 'crmebimage/public/product/2022/06/18/c3ea8f6f85e940f88f539fea2c4df96b72m4w0yacl.png', 3, 1, 1, 0, '2022-06-06 18:49:30', '2022-06-18 16:36:05');
INSERT INTO `eb_product_category` VALUES (89, 44, 'charge', 'crmebimage/public/product/2022/06/18/b67d01a813b347ae9372292e7d4eabebq1k95rrknm.jpg', 3, 1, 1, 0, '2022-06-06 18:50:30', '2022-06-18 16:38:17');
INSERT INTO `eb_product_category` VALUES (90, 15, '绿植', 'crmebimage/public/store/2022/06/09/1f21080415b140819ab3b67c650d7e16i2kwh1e63s.jpg', 2, 1, 1, 1, '2022-06-09 19:11:04', '2022-06-09 19:11:04');
INSERT INTO `eb_product_category` VALUES (91, 90, '小型绿植', 'crmebimage/public/store/2022/06/09/5c6f148882724f90aa16871d5e51f481a2j9qflbyj.jpg', 3, 1, 1, 1, '2022-06-09 19:11:48', '2022-06-09 19:11:48');
INSERT INTO `eb_product_category` VALUES (92, 5, '背带裤', NULL, 3, 1, 1, 1, '2022-06-15 11:51:18', '2022-06-15 11:51:18');
INSERT INTO `eb_product_category` VALUES (93, 0, 'Clothin', 'crmebimage/public/product/2022/06/18/664b4b33c955462b940c00d0d9ff776bxxvh0hmx6b.png', 1, 1, 1, 1, '2022-06-18 17:15:06', '2022-06-18 17:15:06');
INSERT INTO `eb_product_category` VALUES (94, 93, 'Dresses', 'crmebimage/public/product/2022/06/18/dea767f91a574b7d963c693efe8a5b96tfvwzez0gt.png', 2, 1, 1, 1, '2022-06-18 17:15:30', '2022-06-18 17:15:30');
INSERT INTO `eb_product_category` VALUES (95, 0, 'Apparel', 'crmebimage/public/product/2022/06/18/664b4b33c955462b940c00d0d9ff776bxxvh0hmx6b.png', 1, 1, 1, 0, '2022-06-18 17:18:33', '2022-06-18 17:18:33');
INSERT INTO `eb_product_category` VALUES (96, 95, 'Clothin', 'crmebimage/public/product/2022/06/18/d0d07f3a6f4246c3ac106519b5118b96aksli1vamn.png', 2, 1, 1, 0, '2022-06-18 17:19:02', '2022-06-18 17:19:02');
INSERT INTO `eb_product_category` VALUES (97, 96, 'Dresses', 'crmebimage/public/product/2022/06/18/dea767f91a574b7d963c693efe8a5b96tfvwzez0gt.png', 3, 1, 1, 0, '2022-06-18 17:19:25', '2022-06-18 17:19:25');

-- ----------------------------
-- Table structure for eb_product_day_record
-- ----------------------------
DROP TABLE IF EXISTS `eb_product_day_record`;
CREATE TABLE `eb_product_day_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '日期',
  `product_id` int(11) NULL DEFAULT 0 COMMENT '商品id',
  `mer_id` int(11) NULL DEFAULT 0 COMMENT '商户id',
  `page_view` int(11) NULL DEFAULT 0 COMMENT '浏览量',
  `collect_num` int(11) NULL DEFAULT 0 COMMENT '收藏量',
  `add_cart_num` int(11) NULL DEFAULT 0 COMMENT '加购件数',
  `order_product_num` int(11) NULL DEFAULT 0 COMMENT '下单商品数（销售件数）',
  `order_success_product_fee` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '销售额',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `date`(`date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 144 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品日记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_product_day_record
-- ----------------------------

-- ----------------------------
-- Table structure for eb_product_guarantee
-- ----------------------------
DROP TABLE IF EXISTS `eb_product_guarantee`;
CREATE TABLE `eb_product_guarantee`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '保障条款名称',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '图标',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '条款内容',
  `sort` int(5) NOT NULL DEFAULT 999 COMMENT '排序',
  `is_show` tinyint(1) NOT NULL DEFAULT 1 COMMENT '显示状态',
  `is_del` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '是否删除',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品保障服务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_product_guarantee
-- ----------------------------
INSERT INTO `eb_product_guarantee` VALUES (1, '正品保证', 'https://api.beta.adminwm.java.crmeb.net/crmebimage/public/store/2022/04/19/2908ddf602cd4e8b93294a814e27640d31exoy3jje.png', '该商品均为原厂正品，有防伪标识与唯一追溯码，100%保证正品。', 1, 1, 0, '2022-03-14 12:43:10', '2022-04-19 18:40:39');
INSERT INTO `eb_product_guarantee` VALUES (2, '假一赔四', 'crmebimage/public/content/2022/02/24/b25359cf27f249a088177a941fe87d06y26vcveqad.jpg', '正品保障，用户通过专柜验证为假货，将以正品同等价格的4倍金额或四件正品商品赔偿用户。', 1, 1, 0, '2022-03-14 12:49:31', '2022-03-14 12:49:31');
INSERT INTO `eb_product_guarantee` VALUES (3, '7天无理由退款', 'crmebimage/public/product/2022/04/24/6af1a9cbf54f40bfb909c63091a73b5b7f1t2rupfy.png', '在不影响二次销售的情况下，支持7天无理由退款', 5, 1, 0, '2022-04-28 16:17:38', '2022-05-16 09:28:04');
INSERT INTO `eb_product_guarantee` VALUES (4, '24-hour delivery', 'crmebimage/public/product/2022/04/24/ac9d87fa007745959959b80434011e83ct186vcn6r.png', '24-hour delivery', 6, 1, 0, '2022-04-28 16:19:11', '2022-04-28 16:19:11');

-- ----------------------------
-- Table structure for eb_schedule_job
-- ----------------------------
DROP TABLE IF EXISTS `eb_schedule_job`;
CREATE TABLE `eb_schedule_job`  (
  `job_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '任务id',
  `bean_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'spring bean名称',
  `method_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '方法名',
  `params` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '参数',
  `cron_expression` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'cron表达式',
  `status` tinyint(4) NULL DEFAULT NULL COMMENT '任务状态  0：正常  1：暂停',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `is_delte` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '是否删除',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`job_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '定时任务' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_schedule_job
-- ----------------------------
INSERT INTO `eb_schedule_job` VALUES (1, 'CouponOverdueTask', 'couponOverdue', '', '0 */1 * * * ?', 0, '优惠券过期处理', 0, '2021-12-01 10:55:06');
INSERT INTO `eb_schedule_job` VALUES (2, 'OrderAutoCancelTask', 'autoCancel', '', '0 */1 * * * ?', 0, '系统自动取消未支付订单', 0, '2021-12-01 10:55:06');
INSERT INTO `eb_schedule_job` VALUES (3, 'OrderCancelTask', 'userCancel', '', '0 */1 * * * ?', 0, '用户取消订单处理', 0, '2021-12-01 10:55:06');
INSERT INTO `eb_schedule_job` VALUES (4, 'OrderPaySuccessTask', 'orderPayAfter', '', '0 */1 * * * ?', 0, '订单支付成功后置处理', 0, '2021-12-01 10:55:07');
INSERT INTO `eb_schedule_job` VALUES (5, 'OrderRefundTask', 'orderRefund', '', '0 */1 * * * ?', 0, '订单退款处理', 0, '2021-12-01 10:55:07');
INSERT INTO `eb_schedule_job` VALUES (6, 'StatisticsTask', 'statistics', '', '0 0 0 */1 * ?', 0, '统计定时任务', 0, '2021-12-01 10:55:07');
INSERT INTO `eb_schedule_job` VALUES (7, 'AutoDeleteLogTask', 'autoDeleteLog', '', '0 0 0 */1 * ?', 0, '自动删除不需要的历史日志', 0, '2022-01-05 15:03:18');
INSERT INTO `eb_schedule_job` VALUES (8, 'OrderAutoReceivingTask', 'autoReceiving', '', '0 0 0 */1 * ?', 0, '自动收货', 0, '2022-01-05 15:03:18');
INSERT INTO `eb_schedule_job` VALUES (9, 'StatementTask', 'dailyStatement', '', '0 0 0 */1 * ?', 0, '每日帐单定时任务', 0, '2022-04-07 20:46:10');
INSERT INTO `eb_schedule_job` VALUES (10, 'StatementTask', 'monthStatement', '', '0 0 2 1 * ?', 0, '每月帐单定时任务', 0, '2022-04-08 11:06:29');

-- ----------------------------
-- Table structure for eb_schedule_job_log
-- ----------------------------
DROP TABLE IF EXISTS `eb_schedule_job_log`;
CREATE TABLE `eb_schedule_job_log`  (
  `log_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '任务日志id',
  `job_id` int(11) NOT NULL COMMENT '任务id',
  `bean_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'spring bean名称',
  `method_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '方法名',
  `params` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '参数',
  `status` tinyint(4) NOT NULL COMMENT '任务状态    0：成功    1：失败',
  `error` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '失败信息',
  `times` int(11) NOT NULL COMMENT '耗时(单位：毫秒)',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 66179 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '定时任务日志' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_schedule_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for eb_sensitive_method_log
-- ----------------------------
DROP TABLE IF EXISTS `eb_sensitive_method_log`;
CREATE TABLE `eb_sensitive_method_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `admin_id` int(11) NOT NULL COMMENT '管理员id',
  `mer_id` int(11) NOT NULL DEFAULT 0 COMMENT '店铺id，平台为0',
  `admin_account` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '管理员账号',
  `description` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '接口描述',
  `method_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '业务类型',
  `method` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求方式',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求URL',
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '主机地址',
  `request_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求参数',
  `result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int(1) NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '错误消息',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '敏感操作日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_sensitive_method_log
-- ----------------------------
INSERT INTO `eb_sensitive_method_log` VALUES (1, 21, 2, 'stivepeim@outlook.com', '下架商品', '修改', 'com.zbkj.admin.controller.merchant.MerchantProductController.offShell()', 'GET', '/api/admin/merchant/product/offShell/10', '113.132.64.198', '{id=10}', '{\"code\":200,\"message\":\"操作成功\"}', 0, '', '2022-06-20 16:23:39');
INSERT INTO `eb_sensitive_method_log` VALUES (2, 21, 2, 'stivepeim@outlook.com', '上架商品', '修改', 'com.zbkj.admin.controller.merchant.MerchantProductController.putOn()', 'GET', '/api/admin/merchant/product/putOnShell/10', '8.218.3.137', '{id=10}', '{\"code\":200,\"message\":\"操作成功\"}', 0, '', '2022-06-20 16:30:16');

-- ----------------------------
-- Table structure for eb_shopping_product_day_record
-- ----------------------------
DROP TABLE IF EXISTS `eb_shopping_product_day_record`;
CREATE TABLE `eb_shopping_product_day_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '日期',
  `add_product_num` int(11) NULL DEFAULT NULL COMMENT '新增商品数量',
  `page_view` int(11) NULL DEFAULT NULL COMMENT '浏览量',
  `collect_num` int(11) NULL DEFAULT NULL COMMENT '收藏量',
  `add_cart_num` int(11) NULL DEFAULT NULL COMMENT '加购件数',
  `order_product_num` int(11) NULL DEFAULT NULL COMMENT '下单商品数',
  `order_success_product_num` int(11) NULL DEFAULT NULL COMMENT '交易成功商品数',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `date`(`date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商城商品日记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_shopping_product_day_record
-- ----------------------------
INSERT INTO `eb_shopping_product_day_record` VALUES (1, '2025-04-02', 0, 0, 0, 0, 0, 0);
INSERT INTO `eb_shopping_product_day_record` VALUES (2, '2025-04-06', 0, 0, 0, 0, 0, 0);
INSERT INTO `eb_shopping_product_day_record` VALUES (3, '2025-04-07', 0, 0, 0, 0, 0, 0);
INSERT INTO `eb_shopping_product_day_record` VALUES (4, '2025-04-08', 0, 0, 0, 0, 0, 0);
INSERT INTO `eb_shopping_product_day_record` VALUES (5, '2025-04-09', 0, 0, 0, 0, 0, 0);
INSERT INTO `eb_shopping_product_day_record` VALUES (6, '2025-04-10', 0, 0, 1, 0, 0, 0);
INSERT INTO `eb_shopping_product_day_record` VALUES (7, '2025-04-11', 0, 0, 1, 0, 0, 0);
INSERT INTO `eb_shopping_product_day_record` VALUES (8, '2025-04-12', 0, 0, 1, 0, 0, 0);
INSERT INTO `eb_shopping_product_day_record` VALUES (9, '2025-04-13', 0, 0, 0, 0, 0, 0);
INSERT INTO `eb_shopping_product_day_record` VALUES (10, '2025-04-14', 0, 10, 0, 0, 0, 0);
INSERT INTO `eb_shopping_product_day_record` VALUES (11, '2025-04-15', 0, 0, 0, 0, 0, 0);
INSERT INTO `eb_shopping_product_day_record` VALUES (12, '2025-04-20', 0, 0, 0, 0, 0, 0);
INSERT INTO `eb_shopping_product_day_record` VALUES (13, '2025-04-21', 0, 0, 0, 0, 0, 0);

-- ----------------------------
-- Table structure for eb_sms_record
-- ----------------------------
DROP TABLE IF EXISTS `eb_sms_record`;
CREATE TABLE `eb_sms_record`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '短信发送记录编号',
  `uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '短信平台账号',
  `phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '接受短信的手机号',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '短信内容',
  `add_ip` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '添加记录ip',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `template` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '短信模板ID',
  `resultcode` int(6) UNSIGNED NULL DEFAULT NULL COMMENT '状态码 100=成功,130=失败,131=空号,132=停机,133=关机,134=无状态',
  `record_id` int(11) UNSIGNED NULL DEFAULT NULL COMMENT '发送记录id',
  `memo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '短信平台返回信息',
  `country_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '国标区号',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '请求状态码',
  `message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '状态码的描述',
  `biz_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '发送回执ID。可根据发送回执ID在接口QuerySendDetails中查询具体的发送状态。',
  `ali_request_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '请求ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '短信发送记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_sms_record
-- ----------------------------

-- ----------------------------
-- Table structure for eb_sms_template
-- ----------------------------
DROP TABLE IF EXISTS `eb_sms_template`;
CREATE TABLE `eb_sms_template`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `temp_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '短信模板id',
  `temp_type` tinyint(2) NOT NULL DEFAULT 1 COMMENT '模板类型:1-国内，2-国际/港澳台',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '模板说明',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '类型',
  `temp_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '模板编号',
  `status` tinyint(2) NOT NULL DEFAULT 1 COMMENT '状态',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '短息内容',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '短信模板表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of eb_sms_template
-- ----------------------------
INSERT INTO `eb_sms_template` VALUES (1, 'SMS_234157184', 1, '通用验证码', '验证码', '', 1, 'crmeb：您的验证码是 ${codeNo} ，请勿分享。', '2021-12-09 19:31:13');
INSERT INTO `eb_sms_template` VALUES (2, 'SMS_234157186', 1, '发货提醒', '通知', '', 1, 'CRMEB：您的订单 ${orderNo} 已发货', '2021-12-09 20:49:44');
INSERT INTO `eb_sms_template` VALUES (3, 'SMS_234157188', 1, '支付成功', '通知', '', 1, 'CRMEB：您在crmeb外贸版成功支付${price}，订单号为：${orderNo}', '2021-12-09 19:33:38');
INSERT INTO `eb_sms_template` VALUES (4, 'SMS_234157041', 2, '通用验证码', '验证码', '', 1, 'crmeb: your verification code is ${codeNo} , please do not share.', '2021-12-09 21:07:49');
INSERT INTO `eb_sms_template` VALUES (5, 'SMS_234142007', 2, '发货提醒', '通知', '', 1, 'CRMEB: Your order ${orderNo} has been shipped', '2021-12-09 20:33:31');
INSERT INTO `eb_sms_template` VALUES (6, 'SMS_234152022', 2, '支付成功', '通知', '', 1, 'crmeb reminder: you have successfully paid ${price} in the foreign trade version of crmeb, the order number is: ${orderNo}', '2021-12-09 21:12:05');

-- ----------------------------
-- Table structure for eb_store_cart
-- ----------------------------
DROP TABLE IF EXISTS `eb_store_cart`;
CREATE TABLE `eb_store_cart`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '购物车表ID',
  `uid` int(10) UNSIGNED NOT NULL COMMENT '用户ID',
  `mer_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户Id',
  `product_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商品ID',
  `product_attr_unique` int(10) NOT NULL DEFAULT 0 COMMENT '商品属性',
  `cart_num` smallint(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商品数量',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '购物车状态',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`uid`) USING BTREE,
  INDEX `search_id`(`id`, `uid`, `mer_id`, `status`) USING BTREE,
  INDEX `product_id`(`product_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '购物车表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of eb_store_cart
-- ----------------------------
INSERT INTO `eb_store_cart` VALUES (1, 6, 2, 6, 47, 1, 1, '2025-04-14 17:08:36', '2025-04-14 17:08:36');

-- ----------------------------
-- Table structure for eb_store_coupon
-- ----------------------------
DROP TABLE IF EXISTS `eb_store_coupon`;
CREATE TABLE `eb_store_coupon`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '优惠券表ID',
  `mer_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户ID',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '优惠券名称',
  `money` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '兑换的优惠券面值',
  `is_limited` tinyint(1) NULL DEFAULT 0 COMMENT '是否限量, 默认0 不限量， 1限量',
  `total` int(11) NOT NULL DEFAULT 0 COMMENT '发放总数',
  `last_total` int(11) NULL DEFAULT 0 COMMENT '剩余数量',
  `use_type` tinyint(2) NOT NULL DEFAULT 1 COMMENT '使用类型 1-商家券, 2-商品券, 3-平台券',
  `primary_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '所属商品id',
  `min_price` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '最低消费，0代表不限制',
  `receive_start_time` timestamp NOT NULL COMMENT '可领取开始时间',
  `receive_end_time` timestamp NULL DEFAULT NULL COMMENT '可领取结束时间',
  `is_fixed_time` tinyint(1) NULL DEFAULT 0 COMMENT '是否固定使用时间, 默认0 否， 1是',
  `use_start_time` timestamp NULL DEFAULT NULL COMMENT '可使用时间范围 开始时间',
  `use_end_time` timestamp NULL DEFAULT NULL COMMENT '可使用时间范围 结束时间',
  `day` int(4) NULL DEFAULT 0 COMMENT '天数',
  `type` tinyint(2) NOT NULL DEFAULT 1 COMMENT '优惠券类型 1 手动领取, 2 新人券, 3 赠送券',
  `sort` int(11) UNSIGNED NOT NULL DEFAULT 1 COMMENT '排序',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态（0：关闭，1：开启）',
  `is_del` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除 状态（0：否，1：是）',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `mer_id`(`mer_id`) USING BTREE,
  INDEX `is_del`(`is_del`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '优惠券表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_store_coupon
-- ----------------------------
INSERT INTO `eb_store_coupon` VALUES (1, 1, '满10减1', 1.00, 0, 0, 0, 1, '', 10.00, '2022-06-15 14:28:55', NULL, 0, NULL, NULL, 10, 1, 9, 1, 0, '2022-06-15 14:28:55', '2022-06-15 14:28:55');

-- ----------------------------
-- Table structure for eb_store_coupon_user
-- ----------------------------
DROP TABLE IF EXISTS `eb_store_coupon_user`;
CREATE TABLE `eb_store_coupon_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `coupon_id` int(11) NOT NULL COMMENT '优惠券id',
  `mer_id` int(11) NOT NULL DEFAULT 0 COMMENT '店铺id，平台为0',
  `uid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户id',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '优惠券名称',
  `use_type` tinyint(2) NOT NULL DEFAULT 1 COMMENT '使用类型 1-商家券, 2-商品券, 3-平台券',
  `primary_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '所属商品id',
  `money` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '优惠券的面值',
  `min_price` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '最低消费多少金额可用优惠券',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'send' COMMENT '获取方式，send后台发放, get-用户领取',
  `start_time` timestamp NULL DEFAULT NULL COMMENT '开始使用时间',
  `end_time` timestamp NULL DEFAULT NULL COMMENT '过期时间',
  `use_time` timestamp NULL DEFAULT NULL COMMENT '使用时间',
  `status` tinyint(2) NOT NULL DEFAULT 0 COMMENT '状态（0：未使用，1：已使用, 2:已失效）',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `mer_id`(`mer_id`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE,
  INDEX `status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户优惠券表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_store_coupon_user
-- ----------------------------

-- ----------------------------
-- Table structure for eb_store_order
-- ----------------------------
DROP TABLE IF EXISTS `eb_store_order`;
CREATE TABLE `eb_store_order`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户订单号',
  `master_order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主订单号',
  `mer_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户ID',
  `uid` int(11) UNSIGNED NOT NULL COMMENT '用户id',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '邮箱',
  `real_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '收货人姓名',
  `user_phone` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '收货人电话',
  `user_address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '收货人详细地址',
  `total_num` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '订单商品总数',
  `pro_total_price` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '商品总价',
  `total_postage` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '邮费',
  `total_price` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '订单总价',
  `pay_price` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '实际支付金额',
  `pay_postage` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '支付邮费',
  `coupon_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '优惠券id',
  `coupon_price` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '优惠券金额',
  `paid` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '支付状态',
  `pay_time` timestamp NULL DEFAULT NULL COMMENT '支付时间',
  `pay_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '支付方式:paypal',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '订单状态（0：待发货,1：待收货,2：已收货,3：已完成，9：已取消）',
  `refund_status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '退款状态：0 未退款 1 申请中 2 退款中 3 已退款',
  `is_reply` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否评价，0-未评价，1-已评价',
  `delivery_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '快递公司名称',
  `delivery_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '快递公司简称',
  `delivery_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '快递单号',
  `user_remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户备注',
  `mer_remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商户备注',
  `platform_remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '平台备注',
  `is_merchant_del` tinyint(1) NULL DEFAULT 0 COMMENT '商户是否删除',
  `is_user_del` tinyint(1) NULL DEFAULT 0 COMMENT '用户是否删除',
  `is_user_cancel` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否用户取消',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `master_order_no`(`master_order_no`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE,
  INDEX `mer_id`(`mer_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商户订单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_store_order
-- ----------------------------

-- ----------------------------
-- Table structure for eb_store_order_info
-- ----------------------------
DROP TABLE IF EXISTS `eb_store_order_info`;
CREATE TABLE `eb_store_order_info`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `mer_order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户订单号',
  `mer_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户ID',
  `product_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商品ID',
  `product_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商品名称',
  `image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商品图片',
  `attr_value_id` int(11) NOT NULL COMMENT '商品规格值 ID',
  `sku` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商品sku',
  `price` decimal(8, 2) UNSIGNED NOT NULL COMMENT '商品价格',
  `pay_num` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '购买数量',
  `weight` decimal(8, 2) UNSIGNED NOT NULL COMMENT '重量',
  `volume` decimal(8, 2) UNSIGNED NOT NULL COMMENT '体积',
  `is_reply` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否评价，0-未评价，1-已评价',
  `is_receipt` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否收货，0-未收货，1-已收货',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `mer_order_no`(`mer_order_no`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商户订单详情表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_store_order_info
-- ----------------------------

-- ----------------------------
-- Table structure for eb_store_order_profit_sharing
-- ----------------------------
DROP TABLE IF EXISTS `eb_store_order_profit_sharing`;
CREATE TABLE `eb_store_order_profit_sharing`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分账id',
  `mer_order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户订单号',
  `mer_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户ID',
  `profit_sharing_price` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '分账金额',
  `profit_sharing_mer_price` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '分账给商户金额',
  `profit_sharing_time` timestamp NULL DEFAULT NULL COMMENT '分账时间',
  `profit_sharing_refund` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '退款金额',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0:未分账 1:已分账 2:已退款',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `mer_order_no`(`mer_order_no`) USING BTREE,
  INDEX `mer_id`(`mer_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单分账表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_store_order_profit_sharing
-- ----------------------------

-- ----------------------------
-- Table structure for eb_store_order_refund_status
-- ----------------------------
DROP TABLE IF EXISTS `eb_store_order_refund_status`;
CREATE TABLE `eb_store_order_refund_status`  (
  `refund_order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '退款订单号',
  `change_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作类型：apply-申请退款，fail-决绝退款，refund-退款',
  `change_message` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作备注',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  INDEX `refund_order_no`(`refund_order_no`) USING BTREE,
  INDEX `change_type`(`change_type`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单退款操作记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_store_order_refund_status
-- ----------------------------

-- ----------------------------
-- Table structure for eb_store_order_status
-- ----------------------------
DROP TABLE IF EXISTS `eb_store_order_status`;
CREATE TABLE `eb_store_order_status`  (
  `mer_order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户订单号',
  `change_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作类型：create-订单生成，cancel-订单取消，pay-支付，express-发货，receipt-收货，complete-完成,refund-退款',
  `change_message` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作备注',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  INDEX `mer_order_no`(`mer_order_no`) USING BTREE,
  INDEX `change_type`(`change_type`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单操作记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_store_order_status
-- ----------------------------

-- ----------------------------
-- Table structure for eb_store_product
-- ----------------------------
DROP TABLE IF EXISTS `eb_store_product`;
CREATE TABLE `eb_store_product`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '商品id',
  `mer_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户Id',
  `image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品图片',
  `flat_pattern` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '展示图',
  `slider_image` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '轮播图',
  `store_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品名称',
  `store_info` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品简介',
  `keyword` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '关键字',
  `cate_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商户分类id(逗号拼接)',
  `brand_id` int(11) NOT NULL DEFAULT 0 COMMENT '品牌id',
  `category_id` int(11) NOT NULL DEFAULT 0 COMMENT '平台分类id',
  `guarantee_ids` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '保障服务ids(英文逗号拼接)',
  `price` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '商品价格',
  `vip_price` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '会员价格',
  `ot_price` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '市场价',
  `postage` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '邮费',
  `unit_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '单位名',
  `sales` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '销量',
  `stock` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '库存',
  `give_integral` int(11) NOT NULL DEFAULT 0 COMMENT '获得积分',
  `cost` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '成本价',
  `ficti` int(11) NULL DEFAULT 0 COMMENT '虚拟销量',
  `browse` int(11) NULL DEFAULT 0 COMMENT '浏览量',
  `sort` smallint(11) NOT NULL DEFAULT 0 COMMENT '排序',
  `rank` smallint(11) NOT NULL DEFAULT 0 COMMENT '总后台排序',
  `spec_type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '规格 0单 1多',
  `is_recycle` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否回收站',
  `is_show` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态（0：未上架，1：上架）',
  `is_forced` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否强制下架，0-否，1-是',
  `audit_status` int(2) UNSIGNED NOT NULL DEFAULT 1 COMMENT '审核状态：0-待审核，1-审核成功，2-审核拒绝',
  `reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '拒绝原因',
  `is_del` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of eb_store_product
-- ----------------------------
INSERT INTO `eb_store_product` VALUES (4, 2, 'crmebimage/public/content/2022/06/18/ec7d5ac111b74237b61cd080f13c53ee1igvpmmg6f.png', '', '[\"crmebimage/public/content/2022/06/18/1497de9478b14f4e99b52b7f089827963a7jbfep86.jpg\",\"crmebimage/public/content/2022/06/18/47b779fb10424c1d8b4dfc415386cc24go3tsrof3z.jpg\",\"crmebimage/public/content/2022/06/18/ec7d5ac111b74237b61cd080f13c53ee1igvpmmg6f.png\",\"crmebimage/public/content/2022/06/18/53fb1d2323634291ad699c8d3abbfcb4hthhqrj5s4.jpg\",\"crmebimage/public/content/2022/06/18/5d77a6e0346744faad9cf5cad8c86294rf94ydusrf.jpg\"]', 'sokany 122 Hot selling non-stick waffle maker Home waffle maker mini pancake machine for children common', 'sokany 122 Hot selling non-stick waffle maker Home waffle maker mini pancake machine for children common', 'cake', '4', 2, 30, '3', 9.99, 0.00, 13.99, 6.00, 'kg', 0, 10, 0, 5.99, 0, 5, 1, 0, 0, 0, 1, 0, 1, '', 0, '2022-06-18 15:22:52', '2025-04-15 16:46:04');
INSERT INTO `eb_store_product` VALUES (5, 2, 'crmebimage/public/content/2022/06/18/1c1d6d6d13e04b73951715b9addd675dxb0wl0litt.jpg', '', '[\"crmebimage/public/content/2022/06/18/1c1d6d6d13e04b73951715b9addd675dxb0wl0litt.jpg\",\"crmebimage/public/content/2022/06/18/2c500367798d4254afd424a3481f6ca4hlmjyk6b2s.jpg\",\"crmebimage/public/content/2022/06/18/cb89e089bea24c49a63d7b7a50f12793ruixp9am8n.jpg\",\"crmebimage/public/content/2022/06/18/d4d15af3f376477e82270072fab9272ag6hvs9efnq.jpg\",\"crmebimage/public/content/2022/06/18/bee5e6e174344246a22d51f3ba7c9befwkvijd70t6.jpg\"]', 'Crepe Off-the-Shoulder Dress', 'The LAUREN Ralph Lauren® Crepe Off-The-Shoulder Dress looks adorable and stylish. It offers the perfect look for a fun night out.', 'Dresses', '1,2', 3, 97, '4,3,1,2', 124.00, 0.00, 165.00, 1.00, 'strip', 0, 1500, 0, 200.00, 0, 3, 99, 0, 1, 0, 1, 0, 1, '', 0, '2022-06-18 17:29:05', '2025-04-15 16:46:02');
INSERT INTO `eb_store_product` VALUES (6, 2, 'crmebimage/public/content/2022/06/18/0d99fd5bd89e45a7a73559f7ffb0da15mfjbqbmejy.jpg', '', '[\"crmebimage/public/content/2022/06/18/0d99fd5bd89e45a7a73559f7ffb0da15mfjbqbmejy.jpg\",\"crmebimage/public/content/2022/06/18/40d470010d4e4f9f8b04e0d22fb9c80fpmu92j3p7y.jpg\",\"crmebimage/public/content/2022/06/18/3951deb637da460fb57edf00e6669cd6obk7hazakn.jpg\",\"crmebimage/public/content/2022/06/18/f91e8b39378d415fbf6ef73afe5db778i93yiwhgtn.jpg\"]', 'Foiled Jersey Cocktail Dress', 'Exhibit an adorable and dainty look wearing the LAUREN Ralph Lauren® Foiled Jersey Cocktail Dress.\n', 'Dress', '1,2', 3, 97, '4,3,1,2', 130.00, 0.00, 175.00, 1.00, 'strip', 0, 400, 0, 100.00, 0, 26, 99, 0, 1, 0, 1, 0, 1, '', 0, '2022-06-18 17:43:49', '2025-04-16 16:52:46');
INSERT INTO `eb_store_product` VALUES (7, 2, 'crmebimage/public/content/2022/06/18/54b13d109caa4880a984e022271669c5xl1gcmc4ye.jpg', '', '[\"crmebimage/public/content/2022/06/18/54b13d109caa4880a984e022271669c5xl1gcmc4ye.jpg\",\"crmebimage/public/content/2022/06/18/5fb28aac023945648658b2ee10713a28ys6ekff7iy.jpg\",\"crmebimage/public/content/2022/06/18/1f55a4f592c84b92b7481682f0bf50dfv0skn4t6vb.jpg\",\"crmebimage/public/content/2022/06/18/b30fe9e1bda54437880cc6cb1014de183z0aom39wu.jpg\"]', 'Ruffle-Trim Chiffon Dress', 'Have a romantic appeal wearing the cute and stylish LAUREN Ralph Lauren® Ruffle-Trim Chiffon Dress.', 'Dress', '1,2', 3, 97, '4,1,3,2', 145.00, 0.00, 195.00, 1.00, 'strip', 0, 600, 0, 100.00, 0, 4, 99, 0, 1, 0, 1, 0, 1, '', 0, '2022-06-18 17:47:18', '2025-04-15 16:45:57');
INSERT INTO `eb_store_product` VALUES (8, 2, 'crmebimage/public/content/2022/06/18/682a2309187e4012a5e21766dd6d863a5qsp7t24aj.jpg', '', '[\"crmebimage/public/content/2022/06/18/682a2309187e4012a5e21766dd6d863a5qsp7t24aj.jpg\",\"crmebimage/public/content/2022/06/18/0b795f3d96904397a9f59e6d81edb02d6buesnfw1h.jpg\",\"crmebimage/public/content/2022/06/18/4db62bf9e57444788d31af6ef369eeeapxmvgdkr50.jpg\"]', 'Cotton Eyelet Midi Dress', 'LAUREN Ralph Lauren® Cotton Eyelet Midi Dress is s classic pick to wear on any casual day!', 'Dress', '1,2', 3, 97, '4,3,1,2', 245.00, 0.00, 300.00, 1.00, 'strip', 0, 200, 0, 200.00, 0, 7, 100, 0, 0, 0, 1, 0, 1, '', 0, '2022-06-18 17:52:55', '2025-04-16 10:35:07');
INSERT INTO `eb_store_product` VALUES (9, 2, 'crmebimage/public/content/2022/06/18/eaa186578c994fc2ba79956f6b8a8384dk2e308nus.jpg', '', '[\"crmebimage/public/content/2022/06/18/eaa186578c994fc2ba79956f6b8a8384dk2e308nus.jpg\",\"crmebimage/public/content/2022/06/18/2b866d80688c41ee9c2e802c4644d93dvuq79bza7q.jpg\",\"crmebimage/public/content/2022/06/18/5f16f53a10464bf8b81de1c1a9e3c1fea2bi5y2u1s.jpg\",\"crmebimage/public/content/2022/06/18/6b7a785e4e9b4447a63c42d5f8c762183t972ze4pg.jpg\"]', 'Cotton Eyelet Midi Dress', 'LAUREN Ralph Lauren® Cotton Eyelet Midi Dress is s classic pick to wear on any casual day!', 'Dress', '1,2', 3, 97, '4,3,1,2', 245.00, 0.00, 300.00, 1.00, 'strip', 0, 900, 0, 200.00, 0, 3, 99, 0, 1, 0, 1, 0, 1, '', 0, '2022-06-18 18:00:11', '2025-04-15 16:45:52');
INSERT INTO `eb_store_product` VALUES (10, 2, 'crmebimage/public/store/2022/06/18/98c914267cad4e4d83f08bbb1b57ffaap525x1w2u7.png', '', '[\"crmebimage/public/store/2022/06/18/98c914267cad4e4d83f08bbb1b57ffaap525x1w2u7.png\"]', 'Zhen Tou', 'Zhen Tou', 'Zhen Tou', '7', 2, 26, '3,1,2', 0.50, 0.00, 2.00, 1.00, 'S', 0, 999, 0, 1.00, 0, 14, 1, 0, 0, 0, 1, 0, 1, '', 0, '2022-06-18 18:07:02', '2025-04-16 11:20:47');
INSERT INTO `eb_store_product` VALUES (11, 2, 'crmebimage/public/content/2022/06/18/b9a0f136b58243e58bc938c6ff3e57aes7rz0y0g8f.jpg', '', '[\"crmebimage/public/content/2022/06/18/b9a0f136b58243e58bc938c6ff3e57aes7rz0y0g8f.jpg\",\"crmebimage/public/content/2022/06/18/8de2d2fb27f547cb8ff23b639c5f4bafa6jmpzx9zw.jpg\",\"crmebimage/public/content/2022/06/18/8d941ced90064eb094dce282a94e1bcafd95xw515z.jpg\"]', '022 New Foldable 3 in 1 Portable Mobile Phone 15W Magnetic Qi Wireless Charger White TYPE-C', '2022 New Foldable 3 in 1 Portable Mobile Phone 15W Magnetic Qi Wireless Charger White TYPE-C', '2022 New Foldable', '6', 2, 23, '3', 16.93, 0.00, 18.00, 1.00, 'Pieces', 0, 666, 0, 6.00, 0, 0, 1, 0, 0, 0, 0, 0, 1, '', 0, '2022-06-18 19:51:04', '2025-04-14 16:57:56');
INSERT INTO `eb_store_product` VALUES (12, 2, 'crmebimage/public/content/2022/06/18/4bc7d0814fff4155bd2d8a1c20ef209bdpgnr6jncg.jpg', '', '[\"crmebimage/public/content/2022/06/18/fa404430a3464ac1932c15cf8efcc3ac3v0ok05c33.jpg\",\"crmebimage/public/content/2022/06/18/4bc7d0814fff4155bd2d8a1c20ef209bdpgnr6jncg.jpg\"]', '2022 summer new American retro lapel short-sleeved shirt men\'s loose all-match design niche shirt White L', '2022 summer new American retro lapel short-sleeved shirt men\'s loose all-match design niche shirt White L', '2022 summer new American', '4', 2, 23, '3,1', 7.25, 0.00, 9.25, 1.00, 'Pieces', 0, 789, 0, 2.25, 0, 0, 1, 0, 0, 0, 0, 0, 1, '', 0, '2022-06-18 19:55:47', '2025-04-14 16:58:00');
INSERT INTO `eb_store_product` VALUES (13, 2, 'crmebimage/public/content/2022/06/18/7b5634bed37c4e0a8db0505797ea47bezxto1e48jr.jpg', '', '[\"crmebimage/public/content/2022/06/18/7b5634bed37c4e0a8db0505797ea47bezxto1e48jr.jpg\"]', 'Eco Friendly Home Restaurant Black Walnut Wood Wooden Irregular Sushi Fruit Snack Tea Coffee Serving Tray Natural 60x17x2.5cm', 'Eco Friendly Home Restaurant Black Walnut Wood Wooden Irregular Sushi Fruit Snack Tea Coffee Serving Tray Natural 60x17x2.5cm', 'Black Walnut Wood Wooden', '4,5', 2, 23, '3,1', 15.54, 0.00, 16.54, 1.00, 'pices', 0, 845, 0, 5.54, 0, 0, 1, 0, 0, 0, 0, 0, 1, '', 0, '2022-06-18 19:58:51', '2025-04-14 16:58:04');
INSERT INTO `eb_store_product` VALUES (14, 2, 'crmebimage/public/content/2022/06/18/154713b5a1d04d98b47f0b6602e0dfe61xhxn12658.jpg', '', '[\"crmebimage/public/content/2022/06/18/154713b5a1d04d98b47f0b6602e0dfe61xhxn12658.jpg\",\"crmebimage/public/content/2022/06/18/936cbb1e7f4548d2b7d4b7e51dcce066b1uy2qi1qp.jpg\"]', 'Customized 4.5 Inch Creative Ceramic Mortar Mashed Mini Auxiliary Food Grinder Manual Ceramic Grinding Bowl Red', 'Customized 4.5 Inch Creative Ceramic Mortar Mashed Mini Auxiliary Food Grinder Manual Ceramic Grinding Bowl Red', ' Manual Ceramic Grinding Bowl Red', '4', 2, 23, '3,1', 27.00, 0.00, 45.00, 1.00, 'pices', 0, 56, 0, 7.00, 0, 0, 1, 0, 0, 0, 0, 0, 1, '', 0, '2022-06-18 21:01:01', '2025-04-14 16:58:13');

-- ----------------------------
-- Table structure for eb_store_product_attr
-- ----------------------------
DROP TABLE IF EXISTS `eb_store_product_attr`;
CREATE TABLE `eb_store_product_attr`  (
  `id` mediumint(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `product_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商品ID',
  `attr_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '属性名',
  `attr_values` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '属性值',
  `type` tinyint(1) NULL DEFAULT 0 COMMENT '活动类型 0=商品，1=秒杀，2=砍价，3=拼团',
  `is_del` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除,0-否，1-是',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `store_id`(`product_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品属性表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of eb_store_product_attr
-- ----------------------------
INSERT INTO `eb_store_product_attr` VALUES (1, 1, '颜色', 'PINK BLACK,BLUE BLACK', 0, 1);
INSERT INTO `eb_store_product_attr` VALUES (2, 1, '尺码', '2,4,6,8,10', 0, 1);
INSERT INTO `eb_store_product_attr` VALUES (3, 2, '尺码', '2,4,6,8,10', 0, 1);
INSERT INTO `eb_store_product_attr` VALUES (4, 3, '尺码', '2,4,6,8,10', 0, 1);
INSERT INTO `eb_store_product_attr` VALUES (5, 1, '颜色', 'PINK BLACK,BLUE BLACK', 0, 0);
INSERT INTO `eb_store_product_attr` VALUES (6, 1, '尺码', '2,4,6,8,10', 0, 0);
INSERT INTO `eb_store_product_attr` VALUES (7, 2, '尺码', '2,4,6,8,10', 0, 0);
INSERT INTO `eb_store_product_attr` VALUES (8, 3, '尺码', '2,4,6,8,10', 0, 0);
INSERT INTO `eb_store_product_attr` VALUES (9, 4, '规格', '默认', 0, 0);
INSERT INTO `eb_store_product_attr` VALUES (10, 5, '尺码', '2,4,6,8,10', 0, 0);
INSERT INTO `eb_store_product_attr` VALUES (11, 6, '尺码', '6,8', 0, 0);
INSERT INTO `eb_store_product_attr` VALUES (12, 7, '尺码', '6,8,10', 0, 0);
INSERT INTO `eb_store_product_attr` VALUES (13, 8, '规格', '默认', 0, 0);
INSERT INTO `eb_store_product_attr` VALUES (14, 9, '尺码', '6,8,10', 0, 0);
INSERT INTO `eb_store_product_attr` VALUES (15, 10, '规格', '默认', 0, 0);
INSERT INTO `eb_store_product_attr` VALUES (16, 11, '规格', '默认', 0, 0);
INSERT INTO `eb_store_product_attr` VALUES (17, 12, '规格', '默认', 0, 0);
INSERT INTO `eb_store_product_attr` VALUES (18, 13, '规格', '默认', 0, 0);
INSERT INTO `eb_store_product_attr` VALUES (19, 14, '规格', '默认', 0, 0);

-- ----------------------------
-- Table structure for eb_store_product_attr_value
-- ----------------------------
DROP TABLE IF EXISTS `eb_store_product_attr_value`;
CREATE TABLE `eb_store_product_attr_value`  (
  `id` mediumint(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `product_id` int(10) UNSIGNED NOT NULL COMMENT '商品ID',
  `sku` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商品属性索引值 (attr_value|attr_value[|....])',
  `stock` int(10) UNSIGNED NOT NULL COMMENT '属性对应的库存',
  `sales` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '销量',
  `price` decimal(8, 2) UNSIGNED NOT NULL COMMENT '属性金额',
  `image` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片',
  `cost` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '成本价',
  `bar_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品条码',
  `ot_price` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '原价',
  `weight` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '重量',
  `volume` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '体积',
  `brokerage` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '一级返佣',
  `brokerage_two` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '二级返佣',
  `type` tinyint(1) NULL DEFAULT 0 COMMENT '活动类型 0=商品，1=秒杀，2=砍价，3=拼团',
  `quota` int(11) NULL DEFAULT NULL COMMENT '活动限购数量',
  `quota_show` int(11) NULL DEFAULT NULL COMMENT '活动限购数量显示',
  `attr_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT 'attr_values 创建更新时的属性对应',
  `is_del` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除,0-否，1-是',
  `version` int(11) NULL DEFAULT 0 COMMENT '并发版本控制',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `unique`(`sku`) USING BTREE,
  INDEX `store_id`(`product_id`, `sku`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品属性值表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_store_product_attr_value
-- ----------------------------
INSERT INTO `eb_store_product_attr_value` VALUES (1, 1, 'PINK BLACK,2', 200, 0, 10.00, 'crmebimage/public/content/2022/06/15/04e98f868fb54e9583d27fd8ce498c36l89odc7kg3.png', 1000.00, '', 200.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"颜色\":\"PINK BLACK\",\"尺码\":\"2\"}', 1, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (2, 1, 'PINK BLACK,4', 200, 0, 10.00, 'crmebimage/public/content/2022/06/15/04e98f868fb54e9583d27fd8ce498c36l89odc7kg3.png', 1000.00, '', 200.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"颜色\":\"PINK BLACK\",\"尺码\":\"4\"}', 1, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (3, 1, 'PINK BLACK,6', 200, 0, 10.00, 'crmebimage/public/content/2022/06/15/04e98f868fb54e9583d27fd8ce498c36l89odc7kg3.png', 1000.00, '', 200.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"颜色\":\"PINK BLACK\",\"尺码\":\"6\"}', 1, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (4, 1, 'PINK BLACK,8', 200, 0, 10.00, 'crmebimage/public/content/2022/06/15/04e98f868fb54e9583d27fd8ce498c36l89odc7kg3.png', 1000.00, '', 200.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"颜色\":\"PINK BLACK\",\"尺码\":\"8\"}', 1, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (5, 1, 'PINK BLACK,10', 200, 0, 10.00, 'crmebimage/public/content/2022/06/15/04e98f868fb54e9583d27fd8ce498c36l89odc7kg3.png', 1000.00, '', 200.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"颜色\":\"PINK BLACK\",\"尺码\":\"10\"}', 1, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (6, 1, 'BLUE BLACK,2', 200, 0, 10.00, 'crmebimage/public/content/2022/06/15/89c1c42a46454e6ba5df5002d33bd0d5oshxikkd9y.png', 1000.00, '', 200.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"颜色\":\"BLUE BLACK\",\"尺码\":\"2\"}', 1, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (7, 1, 'BLUE BLACK,4', 200, 0, 10.00, 'crmebimage/public/content/2022/06/15/89c1c42a46454e6ba5df5002d33bd0d5oshxikkd9y.png', 1000.00, '', 200.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"颜色\":\"BLUE BLACK\",\"尺码\":\"4\"}', 1, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (8, 1, 'BLUE BLACK,6', 200, 0, 10.00, 'crmebimage/public/content/2022/06/15/89c1c42a46454e6ba5df5002d33bd0d5oshxikkd9y.png', 1000.00, '', 200.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"颜色\":\"BLUE BLACK\",\"尺码\":\"6\"}', 1, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (9, 1, 'BLUE BLACK,8', 200, 0, 10.00, 'crmebimage/public/content/2022/06/15/89c1c42a46454e6ba5df5002d33bd0d5oshxikkd9y.png', 1000.00, '', 200.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"颜色\":\"BLUE BLACK\",\"尺码\":\"8\"}', 1, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (10, 1, 'BLUE BLACK,10', 200, 0, 10.00, 'crmebimage/public/content/2022/06/15/89c1c42a46454e6ba5df5002d33bd0d5oshxikkd9y.png', 1000.00, '', 200.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"颜色\":\"BLUE BLACK\",\"尺码\":\"10\"}', 1, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (11, 2, '2', 200, 0, 13.00, 'crmebimage/public/content/2022/06/15/d882a15eaf154dc1a98890791c7ccf08i3p7n6xzi2.jpg', 1000.00, '', 300.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"2\"}', 1, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (12, 2, '4', 200, 0, 13.00, 'crmebimage/public/content/2022/06/15/d882a15eaf154dc1a98890791c7ccf08i3p7n6xzi2.jpg', 1000.00, '', 300.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"4\"}', 1, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (13, 2, '6', 200, 0, 13.00, 'crmebimage/public/content/2022/06/15/d882a15eaf154dc1a98890791c7ccf08i3p7n6xzi2.jpg', 1000.00, '', 300.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"6\"}', 1, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (14, 2, '8', 200, 0, 13.00, 'crmebimage/public/content/2022/06/15/d882a15eaf154dc1a98890791c7ccf08i3p7n6xzi2.jpg', 1000.00, '', 300.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"8\"}', 1, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (15, 2, '10', 200, 0, 13.00, 'crmebimage/public/content/2022/06/15/d882a15eaf154dc1a98890791c7ccf08i3p7n6xzi2.jpg', 1000.00, '', 300.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"10\"}', 1, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (16, 3, '2', 200, 0, 20.00, 'crmebimage/public/maintain/2022/05/12/6c79ade3e6f54c74a0061d2da9ab7154qrg46klfgd.jpg', 1000.00, '', 450.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"2\"}', 1, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (17, 3, '4', 200, 0, 20.00, 'crmebimage/public/maintain/2022/05/12/6c79ade3e6f54c74a0061d2da9ab7154qrg46klfgd.jpg', 1000.00, '', 450.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"4\"}', 1, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (18, 3, '6', 200, 0, 20.00, 'crmebimage/public/maintain/2022/05/12/6c79ade3e6f54c74a0061d2da9ab7154qrg46klfgd.jpg', 1000.00, '', 450.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"6\"}', 1, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (19, 3, '8', 200, 0, 20.00, 'crmebimage/public/maintain/2022/05/12/6c79ade3e6f54c74a0061d2da9ab7154qrg46klfgd.jpg', 1000.00, '', 450.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"8\"}', 1, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (20, 3, '10', 200, 0, 20.00, 'crmebimage/public/maintain/2022/05/12/6c79ade3e6f54c74a0061d2da9ab7154qrg46klfgd.jpg', 1000.00, '', 450.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"10\"}', 1, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (21, 1, 'PINK BLACK,2', 200, 0, 10.00, 'crmebimage/public/maintain/2022/06/17/7bcc601a43e34a2683ef5f9184ab339e29ft5yscwd.png', 1000.00, '', 200.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"颜色\":\"PINK BLACK\",\"尺码\":\"2\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (22, 1, 'PINK BLACK,4', 200, 0, 10.00, 'crmebimage/public/maintain/2022/06/17/7bcc601a43e34a2683ef5f9184ab339e29ft5yscwd.png', 1000.00, '', 200.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"颜色\":\"PINK BLACK\",\"尺码\":\"4\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (23, 1, 'PINK BLACK,6', 200, 0, 10.00, 'crmebimage/public/maintain/2022/06/17/7bcc601a43e34a2683ef5f9184ab339e29ft5yscwd.png', 1000.00, '', 200.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"颜色\":\"PINK BLACK\",\"尺码\":\"6\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (24, 1, 'PINK BLACK,8', 200, 0, 10.00, 'crmebimage/public/maintain/2022/06/17/7bcc601a43e34a2683ef5f9184ab339e29ft5yscwd.png', 1000.00, '', 200.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"颜色\":\"PINK BLACK\",\"尺码\":\"8\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (25, 1, 'PINK BLACK,10', 200, 0, 10.00, 'crmebimage/public/maintain/2022/06/17/7bcc601a43e34a2683ef5f9184ab339e29ft5yscwd.png', 1000.00, '', 200.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"颜色\":\"PINK BLACK\",\"尺码\":\"10\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (26, 1, 'BLUE BLACK,2', 200, 0, 10.00, 'crmebimage/public/maintain/2022/06/17/6adadd9603b84ce2bbde6e116d7081f386qlbtjn1q.png', 1000.00, '', 200.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"颜色\":\"BLUE BLACK\",\"尺码\":\"2\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (27, 1, 'BLUE BLACK,4', 200, 0, 10.00, 'crmebimage/public/maintain/2022/06/17/6adadd9603b84ce2bbde6e116d7081f386qlbtjn1q.png', 1000.00, '', 200.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"颜色\":\"BLUE BLACK\",\"尺码\":\"4\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (28, 1, 'BLUE BLACK,6', 200, 0, 10.00, 'crmebimage/public/maintain/2022/06/17/6adadd9603b84ce2bbde6e116d7081f386qlbtjn1q.png', 1000.00, '', 200.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"颜色\":\"BLUE BLACK\",\"尺码\":\"6\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (29, 1, 'BLUE BLACK,8', 200, 0, 10.00, 'crmebimage/public/maintain/2022/06/17/6adadd9603b84ce2bbde6e116d7081f386qlbtjn1q.png', 1000.00, '', 200.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"颜色\":\"BLUE BLACK\",\"尺码\":\"8\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (30, 1, 'BLUE BLACK,10', 200, 0, 10.00, 'crmebimage/public/maintain/2022/06/17/6adadd9603b84ce2bbde6e116d7081f386qlbtjn1q.png', 1000.00, '', 200.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"颜色\":\"BLUE BLACK\",\"尺码\":\"10\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (31, 2, '2', 200, 0, 13.00, 'crmebimage/public/maintain/2022/06/17/16951358e91648039cf36fc17c6d5cecpk6v5ags1f.jpg', 1000.00, '', 300.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"2\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (32, 2, '4', 200, 0, 13.00, 'crmebimage/public/maintain/2022/06/17/16951358e91648039cf36fc17c6d5cecpk6v5ags1f.jpg', 1000.00, '', 300.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"4\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (33, 2, '6', 200, 0, 13.00, 'crmebimage/public/maintain/2022/06/17/16951358e91648039cf36fc17c6d5cecpk6v5ags1f.jpg', 1000.00, '', 300.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"6\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (34, 2, '8', 200, 0, 13.00, 'crmebimage/public/maintain/2022/06/17/16951358e91648039cf36fc17c6d5cecpk6v5ags1f.jpg', 1000.00, '', 300.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"8\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (35, 2, '10', 200, 0, 13.00, 'crmebimage/public/maintain/2022/06/17/16951358e91648039cf36fc17c6d5cecpk6v5ags1f.jpg', 1000.00, '', 300.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"10\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (36, 3, '2', 200, 0, 20.00, 'crmebimage/public/maintain/2022/06/17/3dc9a7972a6b4a93bacb949f60aeaa924n7z4b7ehi.jpg', 1000.00, '', 450.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"2\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (37, 3, '4', 200, 0, 20.00, 'crmebimage/public/maintain/2022/06/17/3dc9a7972a6b4a93bacb949f60aeaa924n7z4b7ehi.jpg', 1000.00, '', 450.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"4\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (38, 3, '6', 200, 0, 20.00, 'crmebimage/public/maintain/2022/06/17/3dc9a7972a6b4a93bacb949f60aeaa924n7z4b7ehi.jpg', 1000.00, '', 450.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"6\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (39, 3, '8', 200, 0, 20.00, 'crmebimage/public/maintain/2022/06/17/3dc9a7972a6b4a93bacb949f60aeaa924n7z4b7ehi.jpg', 1000.00, '', 450.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"8\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (40, 3, '10', 200, 0, 20.00, 'crmebimage/public/maintain/2022/06/17/3dc9a7972a6b4a93bacb949f60aeaa924n7z4b7ehi.jpg', 1000.00, '', 450.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"10\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (41, 4, '默认', 10, 0, 9.99, 'crmebimage/public/content/2022/06/18/ec7d5ac111b74237b61cd080f13c53ee1igvpmmg6f.png', 5.99, '', 13.99, 20.00, 60.00, 0.00, 0.00, 0, 0, 0, '{\"规格\":\"默认\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (42, 5, '2', 300, 0, 124.00, 'crmebimage/public/content/2022/06/18/1c1d6d6d13e04b73951715b9addd675dxb0wl0litt.jpg', 200.00, '', 165.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"2\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (43, 5, '4', 300, 0, 124.00, 'crmebimage/public/content/2022/06/18/1c1d6d6d13e04b73951715b9addd675dxb0wl0litt.jpg', 200.00, '', 165.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"4\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (44, 5, '6', 300, 0, 124.00, 'crmebimage/public/content/2022/06/18/1c1d6d6d13e04b73951715b9addd675dxb0wl0litt.jpg', 200.00, '', 165.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"6\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (45, 5, '8', 300, 0, 124.00, 'crmebimage/public/content/2022/06/18/1c1d6d6d13e04b73951715b9addd675dxb0wl0litt.jpg', 200.00, '', 165.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"8\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (46, 5, '10', 300, 0, 124.00, 'crmebimage/public/content/2022/06/18/1c1d6d6d13e04b73951715b9addd675dxb0wl0litt.jpg', 200.00, '', 165.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"10\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (47, 6, '6', 200, 0, 130.00, 'crmebimage/public/content/2022/06/18/0d99fd5bd89e45a7a73559f7ffb0da15mfjbqbmejy.jpg', 100.00, '', 175.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"6\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (48, 6, '8', 200, 0, 130.00, 'crmebimage/public/content/2022/06/18/0d99fd5bd89e45a7a73559f7ffb0da15mfjbqbmejy.jpg', 100.00, '', 175.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"8\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (49, 7, '6', 200, 0, 145.00, 'crmebimage/public/content/2022/06/18/54b13d109caa4880a984e022271669c5xl1gcmc4ye.jpg', 100.00, '', 195.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"6\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (50, 7, '8', 200, 0, 145.00, 'crmebimage/public/content/2022/06/18/54b13d109caa4880a984e022271669c5xl1gcmc4ye.jpg', 100.00, '', 195.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"8\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (51, 7, '10', 200, 0, 145.00, 'crmebimage/public/content/2022/06/18/54b13d109caa4880a984e022271669c5xl1gcmc4ye.jpg', 100.00, '', 195.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"10\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (52, 8, '默认', 200, 0, 245.00, 'crmebimage/public/content/2022/06/18/682a2309187e4012a5e21766dd6d863a5qsp7t24aj.jpg', 200.00, '', 300.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"规格\":\"默认\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (53, 9, '6', 300, 0, 245.00, 'crmebimage/public/content/2022/06/18/eaa186578c994fc2ba79956f6b8a8384dk2e308nus.jpg', 200.00, '', 300.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"6\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (54, 9, '8', 300, 0, 245.00, 'crmebimage/public/content/2022/06/18/eaa186578c994fc2ba79956f6b8a8384dk2e308nus.jpg', 200.00, '', 300.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"8\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (55, 9, '10', 300, 0, 245.00, 'crmebimage/public/content/2022/06/18/eaa186578c994fc2ba79956f6b8a8384dk2e308nus.jpg', 200.00, '', 300.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"尺码\":\"10\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (56, 10, '默认', 999, 0, 0.50, 'crmebimage/public/store/2022/06/18/98c914267cad4e4d83f08bbb1b57ffaap525x1w2u7.png', 1.00, '', 2.00, 1.00, 1.00, 0.00, 0.00, 0, 0, 0, '{\"规格\":\"默认\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (57, 11, '默认', 666, 0, 16.93, 'crmebimage/public/content/2022/06/18/b9a0f136b58243e58bc938c6ff3e57aes7rz0y0g8f.jpg', 6.00, '', 18.00, 0.50, 0.00, 0.00, 0.00, 0, 0, 0, '{\"规格\":\"默认\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (58, 12, '默认', 789, 0, 7.25, 'crmebimage/public/content/2022/06/18/4bc7d0814fff4155bd2d8a1c20ef209bdpgnr6jncg.jpg', 2.25, '', 9.25, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"规格\":\"默认\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (59, 13, '默认', 845, 0, 15.54, 'crmebimage/public/content/2022/06/18/7b5634bed37c4e0a8db0505797ea47bezxto1e48jr.jpg', 5.54, '', 16.54, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"规格\":\"默认\"}', 0, 0);
INSERT INTO `eb_store_product_attr_value` VALUES (60, 14, '默认', 56, 0, 27.00, 'crmebimage/public/content/2022/06/18/154713b5a1d04d98b47f0b6602e0dfe61xhxn12658.jpg', 7.00, '', 45.00, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, '{\"规格\":\"默认\"}', 0, 0);

-- ----------------------------
-- Table structure for eb_store_product_category
-- ----------------------------
DROP TABLE IF EXISTS `eb_store_product_category`;
CREATE TABLE `eb_store_product_category`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mer_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户Id',
  `pid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父级ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '名称',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'icon',
  `sort` int(5) NOT NULL DEFAULT 999 COMMENT '排序',
  `is_show` tinyint(1) NOT NULL DEFAULT 1 COMMENT '显示状态',
  `is_del` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '是否删除',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商户商品分类表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_store_product_category
-- ----------------------------
INSERT INTO `eb_store_product_category` VALUES (1, 1, 0, ' 服饰内衣', NULL, 1, 1, 0, '2022-06-15 11:48:03', '2022-06-15 11:48:03');
INSERT INTO `eb_store_product_category` VALUES (2, 1, 1, '连衣裙', NULL, 1, 1, 0, '2022-06-15 11:48:13', '2022-06-15 11:48:13');
INSERT INTO `eb_store_product_category` VALUES (3, 1, 1, '运动背心', NULL, 1, 1, 0, '2022-06-17 17:44:52', '2022-06-17 17:44:52');
INSERT INTO `eb_store_product_category` VALUES (4, 3, 0, 'Sandwich', 'crmebimage/public/content/2022/06/18/53fb1d2323634291ad699c8d3abbfcb4hthhqrj5s4.jpg', 1, 1, 0, '2022-06-18 15:05:20', '2022-06-18 15:05:20');
INSERT INTO `eb_store_product_category` VALUES (5, 3, 0, 'electric', 'crmebimage/public/content/2022/06/18/5d77a6e0346744faad9cf5cad8c86294rf94ydusrf.jpg', 1, 1, 0, '2022-06-18 15:05:41', '2022-06-18 15:05:41');
INSERT INTO `eb_store_product_category` VALUES (6, 3, 5, 'cake', 'crmebimage/public/content/2022/06/18/ec7d5ac111b74237b61cd080f13c53ee1igvpmmg6f.png', 1, 1, 0, '2022-06-18 15:06:05', '2022-06-18 15:06:05');
INSERT INTO `eb_store_product_category` VALUES (7, 2, 0, 'Modern', 'crmebimage/public/store/2022/06/18/98c914267cad4e4d83f08bbb1b57ffaap525x1w2u7.png', 1, 1, 0, '2022-06-18 18:05:40', '2022-06-18 18:05:40');
INSERT INTO `eb_store_product_category` VALUES (8, 2, 7, 'Pillow', 'crmebimage/public/store/2022/06/18/98c914267cad4e4d83f08bbb1b57ffaap525x1w2u7.png', 1, 1, 0, '2022-06-20 16:27:14', '2022-06-20 16:27:14');

-- ----------------------------
-- Table structure for eb_store_product_coupon
-- ----------------------------
DROP TABLE IF EXISTS `eb_store_product_coupon`;
CREATE TABLE `eb_store_product_coupon`  (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `product_id` int(10) NOT NULL DEFAULT 0 COMMENT '商品id',
  `issue_coupon_id` int(10) NOT NULL DEFAULT 0 COMMENT '优惠劵id',
  `add_time` int(10) NOT NULL DEFAULT 0 COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品优惠券表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of eb_store_product_coupon
-- ----------------------------

-- ----------------------------
-- Table structure for eb_store_product_description
-- ----------------------------
DROP TABLE IF EXISTS `eb_store_product_description`;
CREATE TABLE `eb_store_product_description`  (
  `product_id` int(11) NOT NULL DEFAULT 0 COMMENT '商品ID',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商品详情',
  `type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '商品类型',
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `product_id`(`product_id`, `type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品描述表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of eb_store_product_description
-- ----------------------------
INSERT INTO `eb_store_product_description` VALUES (1, '<p><img class=\"wscnph\" src=\"crmebimage/public/maintain/2022/06/17/5619ef4031434955aba0af0a4fa3037coznklnzk1k.jpg\" /></p>', 0, 4);
INSERT INTO `eb_store_product_description` VALUES (2, '<p><img class=\"wscnph\" src=\"crmebimage/public/maintain/2022/06/17/d9f904ddbce341ba9cdb3d0827feef5fswhz8w8oef.jpg\" /></p>', 0, 5);
INSERT INTO `eb_store_product_description` VALUES (3, '<p><img class=\"wscnph\" src=\"crmebimage/public/maintain/2022/06/17/5b4c7b8ef24d41b494480675a915a2e2hyo0trk8et.jpg\" /><img class=\"wscnph\" src=\"crmebimage/public/maintain/2022/06/17/c5de48d783c840fdb08be567974c781aoiv8w9cmpy.jpg\" /></p>', 0, 6);
INSERT INTO `eb_store_product_description` VALUES (4, '<p><img src=\"https://img20.360buyimg.com/pop/jfs/t1/218448/6/18392/549164/628ddb23E7d1ce16c/38997fb2fc20ea45.jpg\" /></p>\n<p><img src=\"https://img13.360buyimg.com/pop/jfs/t1/85232/23/25981/555977/628ddb31E0c4e0155/aaad0c7464354cfc.jpg\" /></p>', 0, 7);
INSERT INTO `eb_store_product_description` VALUES (5, '<p><img class=\"wscnph\" src=\"crmebimage/public/content/2022/06/18/fe7dc9d546734d2b870e16e36f4814326h3fy8ol7m.jpg\" /></p>\n<ul>\n<li class=\"J6-z\">The LAUREN Ralph Lauren&reg; Crepe Off-The-Shoulder Dress looks adorable and stylish. It offers the perfect look for a fun night out.</li>\n<li>Slim fit.</li>\n<li>Above-the-knee length design.</li>\n<li>Off-the-shoulder neckline.</li>\n<li>Knotted draped design on the waist.</li>\n<li>Hook-and-eye and zippered back closure.</li>\n<li>89% polyester, 11% elastane.</li>\n<li>Machine wash, lay flat to dry.</li>\n<li>Imported.</li>\n<li>Product measurements were taken using size 4. Please note that measurements may vary by size.</li>\n<li>Measurements:\n<ul>\n<li>Length: 37&nbsp;<sup>1</sup>&frasl;<sub>2</sub>&nbsp;in</li>\n</ul>\n</li>\n</ul>', 0, 8);
INSERT INTO `eb_store_product_description` VALUES (6, '<div class=\"Q6-z\"><a class=\"oo-z\" title=\"LAUREN Ralph Lauren\" href=\"https://www.zappos.com/b/lauren-ralph-lauren/brand/358\" data-track-action=\"Product-Page\" data-track-label=\"Tabs\" data-track-value=\"Brand-Logo\"><img class=\"fk-z gk-z\" src=\"https://www.zappos.com/boutiques/3178/lauren-ralph-lauren_head_060915.jpg\" alt=\"LAUREN Ralph Lauren\" /></a></div>\n<ul>\n<li class=\"J6-z\">Exhibit an adorable and dainty look wearing the LAUREN Ralph Lauren&reg; Foiled Jersey Cocktail Dress.</li>\n<li>Surplice neckline and flutter sleeves.</li>\n<li>Zipper detailing with hook-and-eye closure on the back.</li>\n<li>Hem hits the knee.</li>\n<li>Pull-on style.</li>\n<li>95% polyester, 5% elastane.</li>\n<li>Hand wash.</li>\n<li>Imported.</li>\n</ul>', 0, 9);
INSERT INTO `eb_store_product_description` VALUES (7, '<div class=\"Q6-z\"><a class=\"oo-z\" title=\"LAUREN Ralph Lauren\" href=\"https://www.zappos.com/b/lauren-ralph-lauren/brand/358\" data-track-action=\"Product-Page\" data-track-label=\"Tabs\" data-track-value=\"Brand-Logo\"><img class=\"fk-z gk-z\" src=\"https://www.zappos.com/boutiques/3178/lauren-ralph-lauren_head_060915.jpg\" alt=\"LAUREN Ralph Lauren\" /></a></div>\n<ul>\n<li class=\"J6-z\">Have a romantic appeal wearing the cute and stylish LAUREN Ralph Lauren&reg; Ruffle-Trim Chiffon Dress.</li>\n<li>Surplice neckline with flutter sleeves.</li>\n<li>Threaded belt loops.</li>\n<li>Comes with a buckled belt.</li>\n<li>Cascading ruffles down the skirt.</li>\n<li>Threaded belt loops.</li>\n<li>Fully lined except for the sleeves.</li>\n<li>Ruffled hemline.</li>\n<li>Zippered with hook-and-eye closure.</li>\n<li>100% polyester.</li>\n<li>Machine wash, tumble dry.</li>\n<li>Imported.</li>\n<li>Measurements:\n<ul>\n<li>Length: 39 in</li>\n</ul>\n</li>\n<li>Length: 39 in</li>\n<li>Product measurements were taken using size 4. Please note that measurements may vary by size.</li>\n<li>Measurements:<br />Length: 39 in.</li>\n</ul>', 0, 10);
INSERT INTO `eb_store_product_description` VALUES (8, '<div class=\"Q6-z\"><a class=\"oo-z\" title=\"LAUREN Ralph Lauren\" href=\"https://www.zappos.com/e/ralph-lauren\" data-track-action=\"Product-Page\" data-track-label=\"Tabs\" data-track-value=\"Brand-Logo\"><img class=\"fk-z gk-z\" src=\"https://www.zappos.com/boutiques/3178/lauren-ralph-lauren_head_060915.jpg\" alt=\"LAUREN Ralph Lauren\" /></a></div>\n<ul>\n<li class=\"J6-z\">LAUREN Ralph Lauren&reg; Cotton Eyelet Midi Dress is s classic pick to wear on any casual day!</li>\n<li>V-surplice neckline.</li>\n<li>Short flowy sleeves.</li>\n<li>Tie-waist closure.</li>\n<li>Eyelets pattern allover.</li>\n<li>Falls below the knees.</li>\n<li>100% cotton.</li>\n<li>Hand wash.</li>\n<li>Imported.</li>\n</ul>', 0, 11);
INSERT INTO `eb_store_product_description` VALUES (9, '<div class=\"Q6-z\"><a class=\"oo-z\" title=\"LAUREN Ralph Lauren\" href=\"https://www.zappos.com/b/lauren-ralph-lauren/brand/358\" data-track-action=\"Product-Page\" data-track-label=\"Tabs\" data-track-value=\"Brand-Logo\"><img class=\"fk-z gk-z\" src=\"https://www.zappos.com/boutiques/3178/lauren-ralph-lauren_head_060915.jpg\" alt=\"LAUREN Ralph Lauren\" /></a></div>\n<ul>\n<li class=\"J6-z\">LAUREN Ralph Lauren&reg; Cotton Eyelet Midi Dress is s classic pick to wear on any casual day!</li>\n<li>V-surplice neckline.</li>\n<li>Short flowy sleeves.</li>\n<li>Tie-waist closure.</li>\n<li>Eyelets pattern allover.</li>\n<li>Falls below the knees.</li>\n<li>100% cotton.</li>\n<li>Hand wash.</li>\n<li>Imported.</li>\n</ul>', 0, 12);
INSERT INTO `eb_store_product_description` VALUES (10, '<p><img class=\"wscnph\" src=\"crmebimage/public/store/2022/06/18/98c914267cad4e4d83f08bbb1b57ffaap525x1w2u7.png\" /></p>', 0, 14);
INSERT INTO `eb_store_product_description` VALUES (11, '<div class=\"spec-card-container  \">\n<div class=\"spec-card-title\">Product Description</div>\n<div class=\"spec-card-content\">\n<div>\n<div>\n<ul>\n<li>Place of Origin: Guangdong, China</li>\n<li>Warranty: 12 Months</li>\n<li>Output Power: 15W</li>\n<li>Multi-function integrated: with Magnets</li>\n<li>Use: Smart Watch, Earphone, mobile phone</li>\n<li>Size: 247*74.5*8.5mm</li>\n<li>Charging distance: 0-8mm</li>\n<li>Material: ABS+Silicone</li>\n<li>Model Number: AD-WC15</li>\n<li>Weight: 105g</li>\n<li>MOQ: 1 Pcs</li>\n<li>Brand Name:Quantum Preferred&nbsp;</li>\n<li>Input: 9V/2A, 9V/3A, 9v-2a</li>\n<li>Product name: Magnetic 3 in 1 Wireless Charger</li>\n<li>Output: 9V/1.67A, 9V/1.2A, 5V/1A, 5W/7.5W/10W/15W</li>\n<li>Private Mold: Yes</li>\n<li>Charging Efficiency: 80%</li>\n</ul>\n</div>\n<div><img src=\"//img30.360buyimg.com/pop/s750x1449_jfs/t1/129778/10/23784/763583/62a41301E6882649b/ed0d7c750c92cd6a.jpg\" /><img src=\"//img13.360buyimg.com/pop/s750x1449_jfs/t1/133841/5/23348/545999/62a41302Eef249f96/220c01c2c73562af.jpg\" /><img src=\"//img30.360buyimg.com/pop/s750x1449_jfs/t1/196450/23/25213/816760/62a41304E692b25ca/7b2cead63696b2ee.jpg\" /><img src=\"//img10.360buyimg.com/pop/s750x1449_jfs/t1/207218/27/20825/790354/62a4130cEcd25a789/851679ea77117666.jpg\" /><img src=\"//img30.360buyimg.com/pop/s750x1449_jfs/t1/115206/35/27264/527454/62a41311E8ca6ab4d/be1d12e6dcdf1ffe.jpg\" /><img src=\"//img11.360buyimg.com/pop/s750x1449_jfs/t1/183784/31/25528/322747/62a41313Ee73dc0d1/42f93ab2d93f4dd1.jpg\" /><img src=\"//img20.360buyimg.com/pop/s750x879_jfs/t1/167694/16/24802/489152/62a41318E00b68353/d12e6e3814aa4803.jpg\" /></div>\n</div>\n</div>\n</div>', 0, 15);
INSERT INTO `eb_store_product_description` VALUES (12, '<div class=\"spec-card-content\"><img src=\"//img10.360buyimg.com/pop/jfs/t1/202254/35/23285/283366/628c8e50E7b2ff5ed/b1b8781d367c70a8.jpg\" alt=\"\" width=\"800\" height=\"800\" /></div>', 0, 16);
INSERT INTO `eb_store_product_description` VALUES (13, '<div class=\"spec-card-content\"><img src=\"//img10.360buyimg.com/pop/jfs/t1/51487/12/17798/492583/6284664bE789d11a1/cad977be45cfed08.jpg\" alt=\"\" width=\"750\" height=\"1063\" /><br />\n<table border=\"1\">\n<tbody>\n<tr>\n<td>Product Name</td>\n<td>Serving Tray</td>\n</tr>\n<tr>\n<td>Material</td>\n<td>Black Walnut Wood</td>\n</tr>\n<tr>\n<td>Size</td>\n<td>60x17x2.5cm</td>\n</tr>\n<tr>\n<td>Color</td>\n<td>Natural</td>\n</tr>\n<tr>\n<td>Logo</td>\n<td>Custom</td>\n</tr>\n</tbody>\n</table>\n<img src=\"//img10.360buyimg.com/pop/jfs/t1/213589/4/18565/585286/628466e7Ee4165892/def7eae12b0ce19e.jpg\" alt=\"\" width=\"750\" height=\"750\" /><img src=\"//img10.360buyimg.com/pop/jfs/t1/108003/17/29412/640352/628467f4E88e0f9ff/b38b306c852900b7.jpg\" alt=\"\" width=\"750\" height=\"750\" /><img src=\"//img10.360buyimg.com/pop/jfs/t1/212394/29/19006/488903/62846800Edfbc90fd/93b44332d73b21b3.jpg\" alt=\"\" width=\"750\" height=\"750\" /><img src=\"//img10.360buyimg.com/pop/jfs/t1/194970/25/24228/462999/62846814E02a4728d/a50d3692e971baa6.jpg\" alt=\"\" width=\"750\" height=\"750\" /><img src=\"//img10.360buyimg.com/pop/jfs/t1/128355/15/21985/170266/62846880Efab3792b/8be0be2668894f93.jpg\" alt=\"\" width=\"750\" height=\"750\" /><img src=\"//img10.360buyimg.com/pop/jfs/t1/217878/40/18546/417167/62846890E4f1845f0/773143db13b1aab2.jpg\" alt=\"\" width=\"750\" height=\"1704\" /><img src=\"//img10.360buyimg.com/pop/jfs/t1/20924/10/16012/847591/62846898E1a1e7b8a/f8624843510ed32d.jpg\" alt=\"\" width=\"750\" height=\"2238\" /><img src=\"//img10.360buyimg.com/pop/jfs/t1/85350/6/28964/730450/6284689fEa0440ff4/0325416548050102.jpg\" alt=\"\" width=\"750\" height=\"1930\" />Q1. What is your terms of packing? A: Generally, we pack our goods in inner box and brown cartons. If you have legally registered patent, we can pack the goods in your branded boxes after getting your authorization letters. Q2. What is your terms of payment? A: T/T 30% as deposit, and 70% before delivery. Well show you the photos of the products and packages before you pay the balance. Q3. What is your terms of delivery? A: EXW, FOB, CFR, CIF,DDU Q4. How about your delivery time? A: Generally, it will take 45 to 75 days after receiving your advance payment. The specific delivery time depends on the items and the quantity of your order. Q5. Can you produce according to the samples? A: Yes, we can produce by your samples or technical drawings. We can build the molds and fixtures. Q6. What is your sample policy? A: We can supply the sample if we have ready parts in stock, but the customers have to pay the sample cost and the courier cost. Q7: How do you make our business long-term and good relationship? A:1. We keep good quality and competitive price to ensure our customers benefit ; 2. We respect every customer as our friend and we sincerely do business and make friends with them, no matter where they come from.</div>', 0, 17);
INSERT INTO `eb_store_product_description` VALUES (14, '<div class=\"spec-card-content\">\n<div>\n<ul>\n<li>pattern:solid color</li>\n<li>Product Category:Bowl</li>\n<li>color:red, green, blue, grey</li>\n<li>Material:porcelain</li>\n<li>Custom processing:Yes</li>\n<li>Item number:DF1052</li>\n<li>Micro-wave oven:available</li>\n<li>Applicable scene:hotel, meals, coffee, tea</li>\n<li>Surface Technology:overglaze</li>\n</ul>\n<img src=\"//img20.360buyimg.com/pop/jfs/t1/211742/11/19132/500566/62898dbeEc6c83ad6/d177dc1f2efab36b.jpg\" /></div>\n<div><img src=\"//img20.360buyimg.com/pop/jfs/t1/119965/6/21988/318967/62898dbfE5d93a8d3/c666473d2092077a.jpg\" /> <img src=\"//img30.360buyimg.com/pop/jfs/t1/180051/33/25134/355097/62898dc0Eca63abf4/dcc9091dc2596497.jpg\" /> <img src=\"//img14.360buyimg.com/pop/jfs/t1/56601/18/18438/330012/62898dbfE440aaad3/601593ce8996b1e0.jpg\" /> <img src=\"//img11.360buyimg.com/pop/jfs/t1/116071/14/26085/456507/62898dbeE51b91817/41e726017424c250.jpg\" /></div>\n</div>', 0, 18);

-- ----------------------------
-- Table structure for eb_store_product_log
-- ----------------------------
DROP TABLE IF EXISTS `eb_store_product_log`;
CREATE TABLE `eb_store_product_log`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '统计ID',
  `type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型visit,cart,order,pay,collect,refund',
  `product_id` int(11) NOT NULL DEFAULT 0 COMMENT '商品ID',
  `uid` int(11) NOT NULL DEFAULT 0 COMMENT '用户ID',
  `visit_num` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否浏览',
  `cart_num` int(11) NOT NULL DEFAULT 0 COMMENT '加入购物车数量',
  `order_num` int(11) NOT NULL DEFAULT 0 COMMENT '下单数量',
  `pay_num` int(11) NOT NULL DEFAULT 0 COMMENT '支付数量',
  `pay_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '支付金额',
  `cost_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '商品成本价',
  `pay_uid` int(11) NOT NULL DEFAULT 0 COMMENT '支付用户ID',
  `refund_num` int(11) NOT NULL DEFAULT 0 COMMENT '退款数量',
  `refund_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '退款金额',
  `collect_num` tinyint(1) NOT NULL DEFAULT 0 COMMENT '收藏',
  `add_time` bigint(14) NOT NULL DEFAULT 0 COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_store_product_log
-- ----------------------------

-- ----------------------------
-- Table structure for eb_store_product_relation
-- ----------------------------
DROP TABLE IF EXISTS `eb_store_product_relation`;
CREATE TABLE `eb_store_product_relation`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `uid` int(10) UNSIGNED NOT NULL COMMENT '用户ID',
  `product_id` int(10) UNSIGNED NOT NULL COMMENT '商品ID',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型(收藏(collect）、点赞(like))',
  `category` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '某种类型的商品(普通商品、秒杀商品)',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uid`(`uid`, `product_id`, `type`, `category`) USING BTREE,
  INDEX `type`(`type`) USING BTREE,
  INDEX `category`(`category`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品点赞和收藏表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_store_product_relation
-- ----------------------------
INSERT INTO `eb_store_product_relation` VALUES (2, 6, 6, 'collect', 'product', '2025-04-11 11:37:47', '2025-04-11 11:37:47');
INSERT INTO `eb_store_product_relation` VALUES (3, 6, 10, 'collect', 'product', '2025-04-12 09:09:52', '2025-04-12 09:09:52');

-- ----------------------------
-- Table structure for eb_store_product_reply
-- ----------------------------
DROP TABLE IF EXISTS `eb_store_product_reply`;
CREATE TABLE `eb_store_product_reply`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `uid` int(11) NOT NULL DEFAULT 0 COMMENT '用户ID',
  `mer_id` int(11) NOT NULL DEFAULT 0 COMMENT '店铺id',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商户订单编号',
  `order_info_id` int(11) NOT NULL DEFAULT 0 COMMENT '订单详情id',
  `product_id` int(11) NOT NULL COMMENT '商品id',
  `attr_value_id` int(11) NOT NULL COMMENT '商品规格属性id',
  `sku` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品规格属性值,多个,号隔开',
  `star` tinyint(1) NOT NULL DEFAULT 5 COMMENT '星级',
  `comment` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '评论内容',
  `pics` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '评论图片',
  `merchant_reply_content` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '管理员回复内容',
  `merchant_reply_time` timestamp NULL DEFAULT NULL COMMENT '管理员回复时间',
  `is_del` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0未删除1已删除',
  `is_reply` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0未回复1已回复',
  `nickname` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户名称',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户头像',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no`(`order_no`) USING BTREE,
  INDEX `order_info_id`(`order_info_id`) USING BTREE,
  INDEX `product_id`(`product_id`) USING BTREE,
  INDEX `star`(`star`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '评论表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of eb_store_product_reply
-- ----------------------------

-- ----------------------------
-- Table structure for eb_store_product_rule
-- ----------------------------
DROP TABLE IF EXISTS `eb_store_product_rule`;
CREATE TABLE `eb_store_product_rule`  (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `mer_id` int(11) NOT NULL DEFAULT 0 COMMENT '店铺id，平台为0',
  `rule_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '规格名称',
  `rule_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '规格值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品规则值(规格)表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of eb_store_product_rule
-- ----------------------------
INSERT INTO `eb_store_product_rule` VALUES (1, 1, '连衣裙', '[{\"value\":\"颜色\",\"detail\":[\"PINK BLACK\",\"BLUE BLACK\"],\"inputVisible\":false},{\"value\":\"尺码\",\"detail\":[\"2\",\"4\",\"6\",\"8\",\"10\"],\"inputVisible\":false}]');
INSERT INTO `eb_store_product_rule` VALUES (2, 1, '尺码', '[{\"value\":\"尺码\",\"detail\":[\"2\",\"4\",\"6\",\"8\",\"10\"],\"inputVisible\":false}]');

-- ----------------------------
-- Table structure for eb_store_refund_order
-- ----------------------------
DROP TABLE IF EXISTS `eb_store_refund_order`;
CREATE TABLE `eb_store_refund_order`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `refund_order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '退款订单号',
  `mer_order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户订单号',
  `master_order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主订单号',
  `mer_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户ID',
  `uid` int(11) UNSIGNED NOT NULL COMMENT '用户id',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '邮箱',
  `real_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '收货人姓名',
  `user_phone` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '收货人电话',
  `user_address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '收货人详细地址',
  `total_num` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '订单商品总数',
  `refund_reason_wap` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '退款原因',
  `refund_reason_wap_img` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '退款图片',
  `refund_reason_wap_explain` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '退款用户说明',
  `refund_status` tinyint(2) UNSIGNED NOT NULL DEFAULT 0 COMMENT '退款状态：0:待审核 1:审核未通过 2：退款中 3:已退款',
  `refund_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '拒绝退款说明',
  `refund_price` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '退款金额',
  `refund_time` timestamp NULL DEFAULT NULL COMMENT '退款时间',
  `mer_remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商户备注',
  `platform_remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '平台备注',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `mer_order_no`(`mer_order_no`) USING BTREE,
  INDEX `mer_id`(`mer_id`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商户退款订单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_store_refund_order
-- ----------------------------

-- ----------------------------
-- Table structure for eb_stripe_callback
-- ----------------------------
DROP TABLE IF EXISTS `eb_stripe_callback`;
CREATE TABLE `eb_stripe_callback`  (
  `id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'ID',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '事件类型',
  `data_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'ID',
  `data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '内容',
  `created` bigint(50) NULL DEFAULT NULL COMMENT '创建日期',
  `response_status` int(10) NULL DEFAULT NULL COMMENT '响应状态',
  `response_des` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '响应描述',
  `request` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '全部内容',
  `add_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`, `data_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'Stripe回调表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_stripe_callback
-- ----------------------------

-- ----------------------------
-- Table structure for eb_system_admin
-- ----------------------------
DROP TABLE IF EXISTS `eb_system_admin`;
CREATE TABLE `eb_system_admin`  (
  `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '后台管理员表ID',
  `account` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '后台管理员账号',
  `pwd` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '后台管理员密码',
  `real_name` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '后台管理员姓名',
  `roles` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '后台管理员权限(menus_id)',
  `last_ip` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '后台管理员最后一次登录ip',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '后台管理员最后一次登录时间',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '后台管理员添加时间',
  `login_count` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '登录次数',
  `level` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT '后台管理员级别',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '后台管理员状态 1有效0无效',
  `is_del` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除：1-删除',
  `phone` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号码',
  `is_sms` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '是否接收短信',
  `type` int(2) NOT NULL DEFAULT 1 COMMENT '管理员类型：1= 平台超管, 2=商户超管, 3=系统管理员，4=商户管理员',
  `mer_id` int(11) NOT NULL DEFAULT 0 COMMENT '商户id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `account`(`account`) USING BTREE,
  INDEX `status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '后台管理员表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_system_admin
-- ----------------------------
INSERT INTO `eb_system_admin` VALUES (1, 'admin', '4NupqARy6N4=', '超级管理员', '1', '218.252.169.226', '2025-04-16 16:09:39', '2021-07-16 09:59:12', 1074, 1, 1, 0, '18292417675', 0, 1, 0);
INSERT INTO `eb_system_admin` VALUES (3, 'demo', '7iIl3H5zCinwrYbrxAR7cQ==', '演示账号', '4', '192.168.31.157', '2025-04-03 16:42:39', '2021-06-09 11:21:42', 900, 1, 1, 0, '18888888888', 0, 3, 0);
INSERT INTO `eb_system_admin` VALUES (21, 'stivepeim@outlook.com', '33HNiLCcUC0=', '大粽子的杂货店', '2', '124.116.164.34', '2023-08-18 18:03:04', '2022-06-16 11:30:04', 524, 1, 1, 0, NULL, 0, 2, 2);

-- ----------------------------
-- Table structure for eb_system_attachment
-- ----------------------------
DROP TABLE IF EXISTS `eb_system_attachment`;
CREATE TABLE `eb_system_attachment`  (
  `att_id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '附件名称',
  `att_dir` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '附件路径',
  `satt_dir` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '压缩图片路径',
  `att_size` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '附件大小',
  `att_type` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '附件类型',
  `pid` int(10) NOT NULL DEFAULT 0 COMMENT '分类ID0编辑器,1商品图片,2拼团图片,3砍价图片,4秒杀图片,5文章图片,6组合数据图， 7前台用户',
  `image_type` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '图片上传类型 1本地 2七牛云 3OSS 4COS ',
  `owner` int(11) NULL DEFAULT -1 COMMENT '资源归属方',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`att_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 367 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '附件管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_system_attachment
-- ----------------------------

-- ----------------------------
-- Table structure for eb_system_config
-- ----------------------------
DROP TABLE IF EXISTS `eb_system_config`;
CREATE TABLE `eb_system_config`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '配置id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '字段名称',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '字段提示文字',
  `form_id` int(10) NULL DEFAULT 0 COMMENT '表单id',
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '值',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '是否隐藏',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `status+name`(`name`) USING BTREE,
  INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8796 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_system_config
-- ----------------------------
INSERT INTO `eb_system_config` VALUES (177, 'close_system', '', 0, '0', 0, '2020-05-14 15:20:25', '2020-05-14 16:37:47');
INSERT INTO `eb_system_config` VALUES (195, 'store_postage', '', 0, '0', 0, '2020-05-14 15:20:25', '2020-05-14 16:37:47');
INSERT INTO `eb_system_config` VALUES (202, 'main_business', '', 0, ' IT\\u79d1\\u6280 \\u4e92\\u8054\\u7f51|\\u7535\\u5b50\\u5546\\u52a1', 0, '2020-05-14 15:20:25', '2020-05-14 16:37:47');
INSERT INTO `eb_system_config` VALUES (203, 'vice_business', '', 0, 'IT\\u79d1\\u6280 IT\\u8f6f\\u4ef6\\u4e0e\\u670d\\u52a1 ', 0, '2020-05-14 15:20:25', '2020-05-14 16:37:47');
INSERT INTO `eb_system_config` VALUES (204, 'store_brokerage_rate_1', '', 0, '80', 0, '2020-05-14 15:20:25', '2020-07-14 16:44:50');
INSERT INTO `eb_system_config` VALUES (205, 'user_extract_min_price', '', 0, '1', 0, '2020-05-14 15:20:25', '2020-05-14 16:37:47');
INSERT INTO `eb_system_config` VALUES (206, 'sx_sign_min_int', '', 0, '1', 0, '2020-05-14 15:20:25', '2020-05-14 16:37:47');
INSERT INTO `eb_system_config` VALUES (207, 'sx_sign_max_int', '', 0, '5', 0, '2020-05-14 15:20:25', '2020-05-14 16:37:47');
INSERT INTO `eb_system_config` VALUES (218, 'store_brokerage_rate_2', '', 0, '60', 0, '2020-05-14 15:20:25', '2020-07-14 16:44:54');
INSERT INTO `eb_system_config` VALUES (219, 'store_brokerage_status', 'store_brokerage_status', 0, '1', 0, '2020-05-14 15:20:25', '2020-08-05 17:42:38');
INSERT INTO `eb_system_config` VALUES (227, 'user_extract_bank', '', 0, '中国银行\n建设银行\n农业银行', 0, '2020-05-14 15:20:25', '2020-06-09 17:43:00');
INSERT INTO `eb_system_config` VALUES (228, 'fast_number', '', 0, '10', 0, '2020-05-14 15:20:25', '2020-05-14 16:37:47');
INSERT INTO `eb_system_config` VALUES (229, 'bast_number', '', 0, '10', 0, '2020-05-14 15:20:25', '2020-05-14 16:37:47');
INSERT INTO `eb_system_config` VALUES (230, 'first_number', '', 0, '10', 0, '2020-05-14 15:20:25', '2020-05-14 16:37:47');
INSERT INTO `eb_system_config` VALUES (234, 'accessKey', '', 0, '111111', 0, '2020-05-14 15:20:25', '2025-04-23 14:31:52');
INSERT INTO `eb_system_config` VALUES (235, 'secretKey', '', 0, '111111', 0, '2020-05-14 15:20:25', '2025-04-23 14:32:01');
INSERT INTO `eb_system_config` VALUES (236, 'storage_name', '', 0, '111111', 0, '2020-05-14 15:20:25', '2025-04-23 14:39:34');
INSERT INTO `eb_system_config` VALUES (242, 'storage_region', '', 0, '111111', 0, '2020-05-14 15:20:25', '2025-04-23 14:39:38');
INSERT INTO `eb_system_config` VALUES (245, 'system_delivery_time', '', 0, '1', 0, '2020-05-14 15:20:25', '2020-05-14 16:37:47');
INSERT INTO `eb_system_config` VALUES (254, 'cache_config', '', 0, '86400', 0, '2020-05-14 15:20:25', '2020-05-14 16:37:47');
INSERT INTO `eb_system_config` VALUES (262, 'confirmTakeOverSwitch', '', 0, '0', 0, '2020-05-14 15:20:25', '2020-06-17 09:34:31');
INSERT INTO `eb_system_config` VALUES (269, 'extract_time', '', 0, '0', 0, '2020-05-14 15:20:25', '2020-05-14 16:37:47');
INSERT INTO `eb_system_config` VALUES (270, 'store_brokerage_price', '', 0, '1', 0, '2020-05-14 15:20:25', '2020-05-14 16:37:47');
INSERT INTO `eb_system_config` VALUES (272, 'promotion_number', '', 0, '3', 0, '2020-05-14 15:20:25', '2020-05-14 16:37:47');
INSERT INTO `eb_system_config` VALUES (645, 'importProductTB', '', 0, 'https://api03.6bqb.com/taobao/detail', 0, '2020-06-05 14:35:08', '2020-09-08 12:15:01');
INSERT INTO `eb_system_config` VALUES (646, 'importProductJD', '', 0, 'https://api03.6bqb.com/jd/detail', 0, '2020-06-05 14:35:34', '2020-09-08 12:15:08');
INSERT INTO `eb_system_config` VALUES (647, 'importProductSN', '', 0, 'https://api03.6bqb.com/suning/detail', 0, '2020-06-05 14:35:41', '2020-09-08 12:14:59');
INSERT INTO `eb_system_config` VALUES (648, 'importProductPDD', '', 0, 'https://api03.6bqb.com/pdd/detail', 0, '2020-06-05 14:36:20', '2020-09-08 12:15:04');
INSERT INTO `eb_system_config` VALUES (649, 'importProductTM', '', 0, 'https://api03.6bqb.com/tmall/detail', 0, '2020-06-09 14:24:32', '2020-09-08 12:14:57');
INSERT INTO `eb_system_config` VALUES (657, 'sms_account', '', 0, '111111', 0, '2020-06-16 12:17:29', '2025-04-23 14:32:11');
INSERT INTO `eb_system_config` VALUES (658, 'sms_token', '', 0, '111111', 0, '2020-06-16 12:17:35', '2025-04-23 14:32:15');
INSERT INTO `eb_system_config` VALUES (988, 'integralRatio', 'integralRatio', 0, '0', 0, '2020-07-08 15:21:59', '2020-08-10 21:27:45');
INSERT INTO `eb_system_config` VALUES (989, 'balance_func_status', 'balance_func_status', 0, '1', 0, '2020-07-09 10:09:33', '2020-07-14 19:02:16');
INSERT INTO `eb_system_config` VALUES (991, 'brokerage_func_status', 'brokerage_func_status', 0, '1', 0, '2020-07-21 10:42:36', '2020-07-21 10:42:36');
INSERT INTO `eb_system_config` VALUES (992, 'store_brokerage_ratio', 'store_brokerage_ratio', 0, '10', 0, '2020-07-21 10:45:10', '2020-12-18 11:34:26');
INSERT INTO `eb_system_config` VALUES (993, 'store_brokerage_two', 'store_brokerage_two', 0, '5', 0, '2020-07-21 10:45:41', '2020-07-21 10:45:41');
INSERT INTO `eb_system_config` VALUES (994, 'brokerage_bindind', 'brokerage_bindind', 0, '0', 0, '2020-07-21 15:29:25', '2020-07-21 15:29:25');
INSERT INTO `eb_system_config` VALUES (3172, 'config_export_temp_id', 'config_export_temp_id', 0, '111111', 0, '2020-12-10 14:50:34', '2025-04-23 14:38:52');
INSERT INTO `eb_system_config` VALUES (3173, 'config_export_id', 'config_export_id', 0, '111111', 0, '2020-12-10 14:50:45', '2025-04-23 14:38:55');
INSERT INTO `eb_system_config` VALUES (3174, 'config_export_com', 'config_export_com', 0, '111111', 0, '2020-12-10 14:52:57', '2025-04-23 14:39:01');
INSERT INTO `eb_system_config` VALUES (4053, 'config_export_open', 'config_export_open', 129, '1', 0, '2021-02-04 11:21:21', '2021-02-04 11:21:21');
INSERT INTO `eb_system_config` VALUES (4054, 'config_export_to_name', 'config_export_to_name', 129, '111111', 0, '2021-02-04 11:21:21', '2025-04-23 14:39:04');
INSERT INTO `eb_system_config` VALUES (4055, 'config_export_to_tel', 'config_export_to_tel', 129, '111111', 0, '2021-02-04 11:21:21', '2025-04-23 14:39:09');
INSERT INTO `eb_system_config` VALUES (4056, 'config_export_to_address', 'config_export_to_address', 129, '111111', 0, '2021-02-04 11:21:21', '2025-04-23 14:39:14');
INSERT INTO `eb_system_config` VALUES (4057, 'config_export_siid', 'config_export_siid', 129, '1111', 0, '2021-02-04 11:21:21', '2021-02-04 11:21:21');
INSERT INTO `eb_system_config` VALUES (4410, 'bastInfo', 'bastInfo', 133, 'asda sd', 0, '2021-02-23 14:58:53', '2021-02-23 14:58:53');
INSERT INTO `eb_system_config` VALUES (4411, 'firstInfo', 'firstInfo', 133, '1', 0, '2021-02-23 14:58:53', '2021-02-23 14:58:53');
INSERT INTO `eb_system_config` VALUES (4412, 'salesInfo', 'salesInfo', 133, '1', 0, '2021-02-23 14:58:53', '2021-02-23 14:58:53');
INSERT INTO `eb_system_config` VALUES (4413, 'hotInfo', 'hotInfo', 133, '1', 0, '2021-02-23 14:58:53', '2021-02-23 14:58:53');
INSERT INTO `eb_system_config` VALUES (5916, 'change_color_config', 'change_color_config', 0, '4', 0, '2021-07-16 09:55:24', '2021-07-17 09:14:44');
INSERT INTO `eb_system_config` VALUES (6081, 'category_page_config', 'category_page_config', 0, '4', 0, '2021-08-12 15:57:49', '2021-08-13 11:05:11');
INSERT INTO `eb_system_config` VALUES (6082, 'is_show_category', 'is_show_category', 0, 'true', 0, '2021-08-12 15:59:56', '2021-08-13 11:05:14');
INSERT INTO `eb_system_config` VALUES (6216, 'store_brokerage_quota', 'store_brokerage_quota', 0, '10', 0, '2021-07-16 09:55:24', '2021-07-16 09:55:24');
INSERT INTO `eb_system_config` VALUES (6217, 'store_brokerage_is_bubble', 'store_brokerage_is_bubble', 0, '1', 0, '2021-08-18 11:57:17', '2021-08-18 12:23:14');
INSERT INTO `eb_system_config` VALUES (6582, 'txUploadUrl', 'txUploadUrl', 83, '111111', 0, '2021-08-23 14:54:05', '2025-04-23 14:38:23');
INSERT INTO `eb_system_config` VALUES (6583, 'txAccessKey', 'txAccessKey', 83, '1111', 0, '2021-08-23 14:54:05', '2021-08-23 14:54:05');
INSERT INTO `eb_system_config` VALUES (6584, 'txSecretKey', 'txSecretKey', 83, '1111', 0, '2021-08-23 14:54:06', '2021-08-23 14:54:06');
INSERT INTO `eb_system_config` VALUES (6585, 'txStorageName', 'txStorageName', 83, '1111', 0, '2021-08-23 14:54:06', '2025-04-23 14:38:11');
INSERT INTO `eb_system_config` VALUES (6586, 'txStorageRegion', 'txStorageRegion', 83, '1111', 0, '2021-08-23 14:54:06', '2025-04-23 14:38:14');
INSERT INTO `eb_system_config` VALUES (6670, 'qnUploadUrl', 'qnUploadUrl', 82, '111111', 0, '2021-08-23 18:01:03', '2025-04-23 14:33:09');
INSERT INTO `eb_system_config` VALUES (6671, 'qnAccessKey', 'qnAccessKey', 82, '1111', 0, '2021-08-23 18:01:03', '2021-08-23 18:01:03');
INSERT INTO `eb_system_config` VALUES (6672, 'qnSecretKey', 'qnSecretKey', 82, '1111', 0, '2021-08-23 18:01:03', '2021-08-23 18:01:03');
INSERT INTO `eb_system_config` VALUES (6673, 'qnStorageName', 'qnStorageName', 82, 'crmeb-pro', 0, '2021-08-23 18:01:03', '2021-08-23 18:01:03');
INSERT INTO `eb_system_config` VALUES (6674, 'qnStorageRegion', 'qnStorageRegion', 82, 'huabei', 0, '2021-08-23 18:01:03', '2021-08-23 18:01:03');
INSERT INTO `eb_system_config` VALUES (6814, 'alUploadUrl', 'alUploadUrl', 81, '1111', 0, '2021-08-23 19:29:48', '2021-08-23 19:29:48');
INSERT INTO `eb_system_config` VALUES (6815, 'alAccessKey', 'alAccessKey', 81, '1111', 0, '2021-08-23 19:29:48', '2021-08-23 19:29:48');
INSERT INTO `eb_system_config` VALUES (6816, 'alSecretKey', 'alSecretKey', 81, '1111', 0, '2021-08-23 19:29:48', '2021-08-23 19:29:48');
INSERT INTO `eb_system_config` VALUES (6817, 'alStorageName', 'alStorageName', 81, '1111', 0, '2021-08-23 19:29:48', '2025-04-23 14:38:03');
INSERT INTO `eb_system_config` VALUES (6818, 'alStorageRegion', 'alStorageRegion', 81, '111111', 0, '2021-08-23 19:29:48', '2025-04-23 14:38:00');
INSERT INTO `eb_system_config` VALUES (7178, 'homePageSaleListStyle', '', 0, '1', 0, '2021-10-28 09:27:31', '2021-10-28 09:27:31');
INSERT INTO `eb_system_config` VALUES (7885, 'google_client_id', 'google_client_id', 146, '111111', 0, '2022-02-11 18:06:17', '2025-04-23 14:33:41');
INSERT INTO `eb_system_config` VALUES (7886, 'google_open', 'google_open', 146, '\'1\'', 0, '2022-02-11 18:06:17', '2022-02-11 18:06:17');
INSERT INTO `eb_system_config` VALUES (7900, 'twitter_consumer_key', 'twitter_consumer_key', 145, '111111', 0, '2022-02-11 18:26:45', '2025-04-23 14:33:44');
INSERT INTO `eb_system_config` VALUES (7901, 'twitter_consumer_secret', 'twitter_consumer_secret', 145, '111111', 0, '2022-02-11 18:26:45', '2025-04-23 14:33:47');
INSERT INTO `eb_system_config` VALUES (7902, 'twitter_open', 'twitter_open', 145, '\'1\'', 0, '2022-02-11 18:26:45', '2022-02-11 18:26:45');
INSERT INTO `eb_system_config` VALUES (7974, 'aliyun_sms_key_id', 'aliyun_sms_key_id', 111, '111111', 0, '2022-02-16 11:35:10', '2025-04-23 14:33:54');
INSERT INTO `eb_system_config` VALUES (7975, 'aliyun_sms_key_secret', 'aliyun_sms_key_secret', 111, '111111', 0, '2022-02-16 11:35:10', '2025-04-23 14:33:59');
INSERT INTO `eb_system_config` VALUES (7976, 'aliyun_sms_sign_name', 'aliyun_sms_sign_name', 111, 'CRMEB外贸版', 0, '2022-02-16 11:35:10', '2022-02-16 11:35:10');
INSERT INTO `eb_system_config` VALUES (7977, 'sms_code_expire', 'sms_code_expire', 111, '3', 0, '2022-02-16 11:35:10', '2022-02-16 11:35:10');
INSERT INTO `eb_system_config` VALUES (8094, 'importProductToken', 'importProductToken', 122, '111111', 0, '2022-03-31 09:52:46', '2025-04-23 14:34:16');
INSERT INTO `eb_system_config` VALUES (8095, 'id', 'id', 122, '122', 0, '2022-03-31 09:52:46', '2022-03-31 09:52:46');
INSERT INTO `eb_system_config` VALUES (8096, 'guaranteed_amount', 'guaranteed_amount', 0, '5', 0, '2022-04-06 18:08:46', '2022-04-06 18:08:46');
INSERT INTO `eb_system_config` VALUES (8097, 'transfer_min_amount', 'transfer_min_amount', 0, '2', 0, '2022-04-06 18:09:00', '2022-04-06 18:09:00');
INSERT INTO `eb_system_config` VALUES (8098, 'transfer_max_amount', 'transfer_max_amount', 0, '3', 0, '2022-04-06 18:09:12', '2022-04-06 18:09:12');
INSERT INTO `eb_system_config` VALUES (8099, 'balance_freeze_day', 'balance_freeze_day', 0, '0', 0, '2022-04-06 18:09:19', '2022-04-06 18:09:19');
INSERT INTO `eb_system_config` VALUES (8167, 'ylyprint_app_id', 'ylyprint_app_id', 143, '111111', 0, '2022-04-25 10:52:34', '2025-04-23 14:37:48');
INSERT INTO `eb_system_config` VALUES (8168, 'ylyprint_app_secret', 'ylyprint_app_secret', 143, '1111', 0, '2022-04-25 10:52:34', '2022-04-25 10:52:34');
INSERT INTO `eb_system_config` VALUES (8169, 'ylyprint_app_machine_code', 'ylyprint_app_machine_code', 143, '111111', 0, '2022-04-25 10:52:34', '2025-04-23 14:37:46');
INSERT INTO `eb_system_config` VALUES (8170, 'ylyprint_app_machine_msign', 'ylyprint_app_machine_msign', 143, '1111', 0, '2022-04-25 10:52:34', '2022-04-25 10:52:34');
INSERT INTO `eb_system_config` VALUES (8171, 'ylyprint_auto_status', 'ylyprint_auto_status', 143, '\'0\'', 0, '2022-04-25 10:52:34', '2022-04-25 10:52:34');
INSERT INTO `eb_system_config` VALUES (8172, 'ylyprint_status', 'ylyprint_status', 143, '\'0\'', 0, '2022-04-25 10:52:34', '2022-04-25 10:52:34');
INSERT INTO `eb_system_config` VALUES (8173, 'id', 'id', 143, '143', 0, '2022-04-25 10:52:34', '2022-04-25 10:52:34');
INSERT INTO `eb_system_config` VALUES (8300, 'index_banner_type', 'index_banner_type', 0, '1', 0, '2022-05-10 14:43:56', '2022-05-10 15:16:11');
INSERT INTO `eb_system_config` VALUES (8301, 'merSettlementAgreement', '', 0, '<h2>1.本协议的订立</h2>\n<p class=\"cont\">在本网站依据《商城网站用户注册协议》登记注册，且符合本网站 商家入驻标准的用户（以下简称\"商家\"），在同意本协议全部条款后，方有资格使用\"本商城商家在线入驻系统\"（以下简称\"入驻系统\"）申请入驻。一经商家点击\"同意以上协议，下一步\"按键， 即意味着商家同意与本网站签订本协议并同意受本协议约束。</p>\n<h2>2.入驻系统使用说明</h2>\n<p class=\"cont\">2.1 商家通过入驻系统提出入驻申请，并按照要求填写商家信息、提供商家资质资料后，由本网站审核并与有合作意向的商家联系协商合作相关事宜，经双方协商一致线下签订书面《开放平台 供应商合作运营协议》（以下简称\"运营协议\"），且商家按照\"运营协议\"约定支付相应平台使用费及保证金等必要费用后，商家正式入驻本网站。本网站将为入驻商家开通商家后 台系统，商家可通过商家后台系统在本网站运营自己的入驻店铺。</p>\n<p class=\"cont\">2.2 商家以及本网站通过入驻系统做出的申请、资料提交及确认等各类沟通，仅为双方合作的意向以及本网站对商家资格审核的必备程序，除遵守本协议各项约定外，对双方不产生法律约束力。 双方间最终合作事宜及运营规则均以\"运营协议\"的约定及商家后台系统公示的各项规则为准。</p>\n<h2>3.商家权利义务</h2>\n<p>用户使用\"商城商家在线入驻系统\"前请认真阅读并理解本协议内容，本协议内容中以加粗方式显著标识的条款，请用户着重阅读、慎重考虑。</p>\n<h2>1.本协议的订立</h2>\n<p class=\"cont\">在本网站依据《商城网站用户注册协议》登记注册，且符合本网站商家入驻标准的用户（以下简称\"商家\"），在同意本协议全部条款后，方有资格使用\"商城商家在线入驻系统\"（以下简称\"入驻系统\"） 申请入驻。一经商家点击\"同意以上协议，下一步\"按键，即意味着商家同意与本网站签订本协议并同意受本协议约束。</p>\n<h2>2.入驻系统使用说明</h2>\n<p class=\"cont\">2.1 商家通过入驻系统提出入驻申请，并按照要求填写商家信息、提供商家资质资料后，由本网站审核并与有合作意向的商家联系协商合作相关事宜，经双方协商一致线下签订书面《开放平台供应商合作运营协议》 （以下简称\"运营协议\"），且商家按照\"运营协议\"约定支付相应平台使用费及保证金等必要费用后，商家正式入驻本网站。本网站将为入驻商家开通商家后台系统，商家可通过商家后台系统在本网站运营自己的入驻店铺。</p>\n<p class=\"cont\">2.2 商家以及本网站通过入驻系统做出的申请、资料提交及确认等各类沟通，仅为双方合作的意向以及本网站对商家资格审核的必备程序，除遵守本协议各项约定外，对双方不产生法律约束力。双方间最终合作事宜及 运营规则均以\"运营协议\"的约定及商家后台系统公示的各项规则为准。</p>\n<h2>3.商家权利义务</h2>\n<p class=\"cont\">用户使用\"商城商家在线入驻系统\"前请认真阅读并理解本协议内容，本协议内容中以加粗方式显著标识的条款，请用户着重阅读、慎重考虑。</p>\n<p>&nbsp;</p>', 0, '2022-05-10 16:58:22', '2022-05-10 16:59:12');
INSERT INTO `eb_system_config` VALUES (8477, 'facebook_appid', 'facebook_appid', 144, '111111', 0, '2022-06-09 11:11:36', '2025-04-23 14:34:33');
INSERT INTO `eb_system_config` VALUES (8478, 'facebook_open', 'facebook_open', 144, '\'0\'', 0, '2022-06-09 11:11:36', '2022-06-09 11:11:36');
INSERT INTO `eb_system_config` VALUES (8479, 'id', 'id', 144, '144', 0, '2022-06-09 11:11:36', '2022-06-09 11:11:36');
INSERT INTO `eb_system_config` VALUES (8559, 'stripe_api_key', 'stripe_api_key', 164, '111111', 0, '2022-06-10 14:14:28', '2025-04-23 14:34:38');
INSERT INTO `eb_system_config` VALUES (8560, 'stripe_switch', 'stripe_switch', 164, '\'1\'', 0, '2022-06-10 14:14:29', '2022-06-10 14:14:29');
INSERT INTO `eb_system_config` VALUES (8561, 'id', 'id', 164, '164', 0, '2022-06-10 14:14:29', '2022-06-10 14:14:29');
INSERT INTO `eb_system_config` VALUES (8574, 'visitor_open', 'visitor_open', 148, '\'1\'', 0, '2022-06-13 17:50:07', '2022-06-13 17:50:07');
INSERT INTO `eb_system_config` VALUES (8575, 'id', 'id', 148, '148', 0, '2022-06-13 17:50:07', '2022-06-13 17:50:07');
INSERT INTO `eb_system_config` VALUES (8576, 'merLoginAgreement', '', 0, '<div class=\"lake-content\">\n<p id=\"ue25c0da6\" class=\"ne-p\"><span class=\"ne-text\">欢迎您使用我们的商城平台服务！在您开始使用之前，请仔细阅读以下条款。当您使用我们的服务时，即表示您已阅读、理解并同意遵守本协议的所有内容。如果您不同意本协议的任何条款，请停止使用我们的服务。</span></p>\n<p id=\"u8d6859dc\" class=\"ne-p\"><strong><span class=\"ne-text\">1.账号注册与使用</span></strong></p>\n<p id=\"u3d103219\" class=\"ne-p\"><span class=\"ne-text\">1.1 您需要注册一个账号才能使用我们的服务。注册时需要提供真实、准确、完整的个人信息，并确保及时更新这些信息。</span></p>\n<p id=\"ud9c8eb44\" class=\"ne-p\"><span class=\"ne-text\">1.2 您的账号仅供您个人使用，不得转让、出借或授权给他人使用。</span></p>\n<p id=\"u1d8c453d\" class=\"ne-p\"><span class=\"ne-text\">1.3 您应当妥善保管您的账号和密码，不得将其泄露给他人，否则由此产生的责任由您承担。</span></p>\n<p id=\"u2def0fab\" class=\"ne-p\"><strong><span class=\"ne-text\">2.用户权利和义务</span></strong></p>\n<p id=\"u32027283\" class=\"ne-p\"><span class=\"ne-text\">2.1 您有权根据我们的规定使用我们提供的服务，包括浏览商品、下单购买商品等。</span></p>\n<p id=\"u02c02799\" class=\"ne-p\"><span class=\"ne-text\">2.2 您应当遵守国家法律法规、社会公共道德，不得利用我们的服务从事任何违法、侵权或损害他人利益的行为。</span></p>\n<p id=\"u6de2ecbd\" class=\"ne-p\"><span class=\"ne-text\">2.3 您应当尊重其他用户的权利和合法利益，不得干扰、损害其他用户的正常使用。</span></p>\n<p id=\"uca777ef1\" class=\"ne-p\"><strong><span class=\"ne-text\">3.平台服务</span></strong></p>\n<p id=\"uf81d4c86\" class=\"ne-p\"><span class=\"ne-text\">3.1 我们将竭尽所能为您提供安全、稳定、高效的服务，但不对服务的及时性、安全性、准确性做任何承诺。</span></p>\n<p id=\"u30f284ce\" class=\"ne-p\"><span class=\"ne-text\">3.2 我们有权根据业务发展和法律法规的变化，调整、改进或终止部分或全部服务，并将在平台上进行公告。</span></p>\n<p id=\"uc14386d0\" class=\"ne-p\"><strong><span class=\"ne-text\">4.用户信息保护</span></strong></p>\n<p id=\"u7c04202e\" class=\"ne-p\"><span class=\"ne-text\">4.1 我们将严格保护您的个人信息安全，未经您的授权，不会向第三方披露或提供您的个人信息。</span></p>\n<p id=\"u7e12caa4\" class=\"ne-p\"><span class=\"ne-text\">4.2 我们将采取合理的技术和管理措施保护您的个人信息，防止数据的泄露、损毁或丢失。</span></p>\n<p id=\"u0e1e4f08\" class=\"ne-p\"><strong><span class=\"ne-text\">5.责任限制</span></strong></p>\n<p id=\"u00f530bc\" class=\"ne-p\"><span class=\"ne-text\">5.1 您理解并同意，我们对以下情形不承担责任：</span></p>\n<p id=\"u9c36daec\" class=\"ne-p\"><span class=\"ne-text\"> （1）由于不可抗力因素导致的服务中断或终止；</span></p>\n<p id=\"u65288763\" class=\"ne-p\"><span class=\"ne-text\"> （2）您的操作不当或违反本协议的规定而造成的任何损失；</span></p>\n<p id=\"u811c6d3f\" class=\"ne-p\"><span class=\"ne-text\"> （3）第三方对您的侵权行为。</span></p>\n<p id=\"u331009b1\" class=\"ne-p\"><strong><span class=\"ne-text\">6.协议的解除和修改</span></strong></p>\n<p id=\"ufab703ec\" class=\"ne-p\"><span class=\"ne-text\">6.1 我们有权根据实际情况对本协议进行修改，并在平台上进行公告。修改后的协议一经公布即生效，您继续使用我们的服务即表示您同意接受修改后的协议。</span></p>\n<p id=\"u4f650b72\" class=\"ne-p\"><span class=\"ne-text\">6.2 如果您不同意修改后的协议内容，您有权停止使用我们的服务。</span></p>\n<p id=\"uc31780b7\" class=\"ne-p\"><strong><span class=\"ne-text\">7.法律适用和争议解决</span></strong></p>\n<p id=\"u3c7570dd\" class=\"ne-p\"><span class=\"ne-text\">本协议的签订、生效、履行和解释适用中国法律。因本协议引起的争议，双方应友好协商解决；协商不成的，应提交有管辖权的法院解决。</span></p>\n<p id=\"ufd9958e0\" class=\"ne-p\"><strong><span class=\"ne-text\">8.其他</span></strong></p>\n<p id=\"u268136b1\" class=\"ne-p\"><span class=\"ne-text\">8.1 如果本协议的任何条款因任何原因被视为无效或不可执行，该条款应被视为与协议其他部分分离，不影响其他条款的效力和可执行性。</span></p>\n<p id=\"u93d91e9f\" class=\"ne-p\"><span class=\"ne-text\">8.2 本协议自您注册账号之日起生效。</span></p>\n</div>', 0, '2022-06-14 10:51:42', '2022-06-14 10:51:42');
INSERT INTO `eb_system_config` VALUES (8583, 'consumer_h5_url', 'consumer_h5_url', 76, '111111', 0, '2022-06-14 21:03:06', '2025-04-23 14:35:26');
INSERT INTO `eb_system_config` VALUES (8584, 'consumer_hotline', 'consumer_hotline', 76, '18888888888', 0, '2022-06-14 21:03:06', '2022-06-14 21:03:06');
INSERT INTO `eb_system_config` VALUES (8585, 'consumer_message', 'consumer_message', 76, '111111', 0, '2022-06-14 21:03:06', '2025-04-23 14:35:16');
INSERT INTO `eb_system_config` VALUES (8586, 'consumer_email', 'consumer_email', 76, '111111', 0, '2022-06-14 21:03:07', '2025-04-23 14:35:07');
INSERT INTO `eb_system_config` VALUES (8587, 'consumer_type', 'consumer_type', 76, 'hotline', 0, '2022-06-14 21:03:07', '2022-06-14 21:03:07');
INSERT INTO `eb_system_config` VALUES (8588, 'id', 'id', 76, '76', 0, '2022-06-14 21:03:07', '2022-06-14 21:03:07');
INSERT INTO `eb_system_config` VALUES (8589, 'logistics_app_key', 'logistics_app_key', 128, '111111', 0, '2022-06-15 11:34:51', '2025-04-23 14:35:33');
INSERT INTO `eb_system_config` VALUES (8590, 'logistics_app_secret', 'logistics_app_secret', 128, '111111', 0, '2022-06-15 11:34:51', '2025-04-23 14:35:36');
INSERT INTO `eb_system_config` VALUES (8591, 'id', 'id', 128, '128', 0, '2022-06-15 11:34:51', '2022-06-15 11:34:51');
INSERT INTO `eb_system_config` VALUES (8662, 'stor_reason', 'stor_reason', 77, '收货地址填错了 \n与描述不符 \n信息填错了\n重新拍 \n收到商品损坏了 \n未按预定时间发货 其它原因', 0, '2022-06-18 14:49:39', '2022-06-18 14:49:39');
INSERT INTO `eb_system_config` VALUES (8663, 'mobile_top_logo', 'mobile_top_logo', 77, 'crmebimage/public/product/2022/06/17/474a2d745b094151b7d9d46ed692ac9ek3970ns7g4.png', 0, '2022-06-18 14:49:39', '2022-06-18 14:49:39');
INSERT INTO `eb_system_config` VALUES (8664, 'mobile_login_logo', 'mobile_login_logo', 77, 'crmebimage/public/product/2022/06/17/5b29ba0909b6431abd4a741611a6d9a11eoxhe1g0v.png', 0, '2022-06-18 14:49:39', '2022-06-18 14:49:39');
INSERT INTO `eb_system_config` VALUES (8665, 'h5_avatar', 'h5_avatar', 77, 'crmebimage/public/product/2022/06/18/657314edfc124a75a2788f8dbc32c396xx77jduaq7.jpg', 0, '2022-06-18 14:49:39', '2022-06-18 14:49:39');
INSERT INTO `eb_system_config` VALUES (8666, 'order_cancel_time', 'order_cancel_time', 77, '2', 0, '2022-06-18 14:49:39', '2022-06-18 14:49:39');
INSERT INTO `eb_system_config` VALUES (8667, 'site_name', 'site_name', 77, 'CRMEB JAVA 外贸 多商户', 0, '2022-06-18 14:49:39', '2022-06-18 14:49:39');
INSERT INTO `eb_system_config` VALUES (8668, 'seo_title', 'seo_title', 77, 'CRMEB JAVA 外贸 多商户', 0, '2022-06-18 14:49:39', '2022-06-18 14:49:39');
INSERT INTO `eb_system_config` VALUES (8669, 'news_slides_limit', 'news_slides_limit', 77, '3', 0, '2022-06-18 14:49:39', '2022-06-18 14:49:39');
INSERT INTO `eb_system_config` VALUES (8670, 'id', 'id', 77, '77', 0, '2022-06-18 14:49:39', '2022-06-18 14:49:39');
INSERT INTO `eb_system_config` VALUES (8676, 'site_logo_lefttop', 'site_logo_lefttop', 64, 'crmebimage/public/product/2022/06/17/818293a5b095496287dbcf59a18b0b9e1ozzowfx5a.png', 0, '2022-06-18 15:04:50', '2022-06-18 15:04:50');
INSERT INTO `eb_system_config` VALUES (8677, 'site_logo_square', 'site_logo_square', 64, 'crmebimage/public/product/2022/06/17/5b29ba0909b6431abd4a741611a6d9a11eoxhe1g0v.png', 0, '2022-06-18 15:04:50', '2022-06-18 15:04:50');
INSERT INTO `eb_system_config` VALUES (8678, 'site_logo_login', 'site_logo_login', 64, 'crmebimage/public/product/2022/06/17/9b6f9eeb611d46019fc75d50d22d14f8qo1nybufk7.png', 0, '2022-06-18 15:04:50', '2022-06-18 15:04:50');
INSERT INTO `eb_system_config` VALUES (8679, 'admin_login_bg_pic', 'admin_login_bg_pic', 64, 'crmebimage/public/product/2022/06/18/2b813c5b0a614694ab2b1bba017d6c4cpb909hu07o.jpg', 0, '2022-06-18 15:04:50', '2022-06-18 15:04:50');
INSERT INTO `eb_system_config` VALUES (8680, 'id', 'id', 64, '64', 0, '2022-06-18 15:04:50', '2022-06-18 15:04:50');
INSERT INTO `eb_system_config` VALUES (8681, 'pc_home_recommend_image', 'pc_home_recommend_image', 163, 'crmebimage/public/product/2022/06/18/1dc61934d1de4dfb9e5434bb4262297cryuyctycp3.png', 0, '2022-06-18 18:01:47', '2022-06-18 18:01:47');
INSERT INTO `eb_system_config` VALUES (8682, 'pc_shop_street_header_image', 'pc_shop_street_header_image', 163, 'crmebimage/public/product/2022/06/18/8dced0fe59a04e0db43e83148571c97a1rzfulbszq.png', 0, '2022-06-18 18:01:47', '2022-06-18 18:01:47');
INSERT INTO `eb_system_config` VALUES (8683, 'pc_top_logo', 'pc_top_logo', 163, 'crmebimage/public/product/2022/06/17/9b6f9eeb611d46019fc75d50d22d14f8qo1nybufk7.png', 0, '2022-06-18 18:01:47', '2022-06-18 18:01:47');
INSERT INTO `eb_system_config` VALUES (8684, 'pc_login_left_image', 'pc_login_left_image', 163, 'crmebimage/public/product/2022/06/18/3e88a5e85d674e1f8d8283c96c7dfc6a1wajapbutf.png', 0, '2022-06-18 18:01:47', '2022-06-18 18:01:47');
INSERT INTO `eb_system_config` VALUES (8685, 'id', 'id', 163, '163', 0, '2022-06-18 18:01:47', '2022-06-18 18:01:47');
INSERT INTO `eb_system_config` VALUES (8751, 'shop_pay_currency', '', 0, '{\"country\":\" 中国大陆\",\"currency\":\"人民币\",\"symbol\":\"¥\",\"ID\":\"53\"}', 0, '2023-08-10 14:50:34', '2023-08-10 14:50:34');
INSERT INTO `eb_system_config` VALUES (8780, 'localUploadUrl', 'localUploadUrl', 108, '111111', 0, '2025-04-09 09:19:25', '2025-04-23 14:36:50');
INSERT INTO `eb_system_config` VALUES (8781, 'image_ext_str', 'image_ext_str', 108, 'jpg,jpeg,gif,png,bmp,PNG,JPG,mp4,webp', 0, '2025-04-09 09:19:25', '2025-04-09 09:19:25');
INSERT INTO `eb_system_config` VALUES (8782, 'image_max_size', 'image_max_size', 108, '10', 0, '2025-04-09 09:19:25', '2025-04-09 09:19:25');
INSERT INTO `eb_system_config` VALUES (8783, 'file_ext_str', 'file_ext_str', 108, 'zip,doc,docx,xls,xlsx,pdf,mp3,wma,wav,amr,mp4', 0, '2025-04-09 09:19:25', '2025-04-09 09:19:25');
INSERT INTO `eb_system_config` VALUES (8784, 'file_max_size', 'file_max_size', 108, '20', 0, '2025-04-09 09:19:25', '2025-04-09 09:19:25');
INSERT INTO `eb_system_config` VALUES (8785, 'uploadType', 'uploadType', 108, '1', 0, '2025-04-09 09:19:25', '2025-04-09 09:19:25');
INSERT INTO `eb_system_config` VALUES (8786, 'file_is_save', 'file_is_save', 108, '1', 0, '2025-04-09 09:19:26', '2025-04-09 09:19:26');
INSERT INTO `eb_system_config` VALUES (8787, 'communityImageTextAuditSwitch', '', 0, '1', 0, '2025-04-09 14:17:59', '2025-04-09 14:17:59');
INSERT INTO `eb_system_config` VALUES (8788, 'communityShortVideoAuditSwitch', '', 0, '1', 0, '2025-04-09 14:17:59', '2025-04-09 14:17:59');
INSERT INTO `eb_system_config` VALUES (8789, 'communityReplyAuditSwitch', '', 0, '0', 0, '2025-04-09 14:17:59', '2025-04-09 14:17:59');
INSERT INTO `eb_system_config` VALUES (8790, 'communityReplySwitch', '', 0, '1', 0, '2025-04-09 14:17:59', '2025-04-09 14:17:59');
INSERT INTO `eb_system_config` VALUES (8791, 'paypal_client_id', 'paypal_client_id', 147, '111111', 0, '2025-04-09 14:57:27', '2025-04-23 14:37:03');
INSERT INTO `eb_system_config` VALUES (8792, 'paypal_client_secret', 'paypal_client_secret', 147, '111111', 0, '2025-04-09 14:57:27', '2025-04-23 14:37:11');
INSERT INTO `eb_system_config` VALUES (8793, 'paypal_mode', 'paypal_mode', 147, 'sandbox', 0, '2025-04-09 14:57:27', '2025-04-09 14:57:27');
INSERT INTO `eb_system_config` VALUES (8794, 'paypal_switch', 'paypal_switch', 147, '\'0\'', 0, '2025-04-09 14:57:28', '2025-04-09 14:57:28');
INSERT INTO `eb_system_config` VALUES (8795, 'bottom_navigation_is_custom', '', 0, '1', 0, '2025-04-15 09:14:35', '2025-04-15 09:14:35');

-- ----------------------------
-- Table structure for eb_system_form_temp
-- ----------------------------
DROP TABLE IF EXISTS `eb_system_form_temp`;
CREATE TABLE `eb_system_form_temp`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '表单模板id',
  `name` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '表单名称',
  `info` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '表单简介',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '表单内容',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 170 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '表单模板' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_system_form_temp
-- ----------------------------
INSERT INTO `eb_system_form_temp` VALUES (64, '基础配置', '系统设置-基础配置', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":300,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"左上角菜单logo(236x64)\",\"tag\":\"self-upload\",\"tagIcon\":\"upload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":null,\"required\":true,\"span\":24,\"showTip\":false,\"buttonText\":\"点击上传\",\"regList\":[],\"changeTag\":true,\"fileSize\":2,\"sizeUnit\":\"MB\",\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":124,\"renderKey\":1595658064081,\"tips\":false},\"__slot__\":{\"list-type\":true},\"action\":\"https://jsonplaceholder.typicode.com/posts/\",\"disabled\":true,\"accept\":\"\",\"name\":\"file\",\"auto-upload\":true,\"list-type\":\"picture-card\",\"multiple\":false,\"__vModel__\":\"site_logo_lefttop\"},{\"__config__\":{\"label\":\"左上角缩回菜单logo(164x164)\",\"tag\":\"self-upload\",\"tagIcon\":\"upload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":null,\"required\":true,\"span\":24,\"showTip\":false,\"buttonText\":\"点击上传\",\"regList\":[],\"changeTag\":true,\"fileSize\":2,\"sizeUnit\":\"MB\",\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":127,\"renderKey\":1595658695317,\"tips\":false},\"__slot__\":{\"list-type\":true},\"action\":\"https://jsonplaceholder.typicode.com/posts/\",\"disabled\":true,\"accept\":\"\",\"name\":\"file\",\"auto-upload\":true,\"list-type\":\"text\",\"multiple\":false,\"__vModel__\":\"site_logo_square\"},{\"__config__\":{\"label\":\"登录页logo(164x164)\",\"tag\":\"self-upload\",\"tagIcon\":\"upload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":null,\"required\":true,\"span\":24,\"showTip\":false,\"buttonText\":\"点击上传\",\"regList\":[],\"changeTag\":true,\"fileSize\":2,\"sizeUnit\":\"MB\",\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":101,\"renderKey\":1612510257294,\"tips\":false},\"__slot__\":{\"list-type\":true},\"action\":\"https://jsonplaceholder.typicode.com/posts/\",\"disabled\":true,\"accept\":\"\",\"name\":\"file\",\"auto-upload\":true,\"list-type\":\"picture-card\",\"multiple\":false,\"__vModel__\":\"site_logo_login\"},{\"__config__\":{\"label\":\"登录页背景图(1920x1080)\",\"tag\":\"self-upload\",\"tagIcon\":\"upload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":null,\"required\":true,\"span\":24,\"showTip\":false,\"buttonText\":\"点击上传\",\"regList\":[],\"changeTag\":true,\"fileSize\":2,\"sizeUnit\":\"MB\",\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":152,\"renderKey\":1596017451389,\"tips\":false},\"__slot__\":{\"list-type\":true},\"action\":\"https://jsonplaceholder.typicode.com/posts/\",\"disabled\":true,\"accept\":\"\",\"name\":\"file\",\"auto-upload\":true,\"list-type\":\"text\",\"multiple\":false,\"__vModel__\":\"admin_login_bg_pic\"}]}', '2020-05-15 17:20:10', '2022-04-14 16:13:11');
INSERT INTO `eb_system_form_temp` VALUES (72, '上传文件配置-基础配置', '上传文件配置-基础配置', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":130,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"layout\":\"rowFormItem\",\"tagIcon\":\"row\",\"label\":\"行容器\",\"layoutTree\":true,\"children\":[],\"document\":\"https://element.eleme.cn/#/zh-CN/component/layout\",\"formId\":101,\"span\":24,\"renderKey\":1592474288129,\"componentName\":\"row101\",\"gutter\":15},\"type\":\"default\",\"justify\":\"start\",\"align\":\"top\"}]}', '2020-05-19 17:10:40', '2020-06-18 17:58:09');
INSERT INTO `eb_system_form_temp` VALUES (76, '客服配置', '客服配置', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":120,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"客服H5链接\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":101,\"renderKey\":1599641784700,\"tips\":true,\"tipsIsLink\":true,\"tipsLink\":\"http://help.crmeb.net/crmeb_java/2322225\",\"tipsDesc\":\"点击查看详细\"},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入客服H5链接客服H5链接\",\"style\":{\"width\":\"80%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"consumer_h5_url\"},{\"__config__\":{\"label\":\"客服电话\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"info\":false,\"desc\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":102,\"renderKey\":1634805887754,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入客服电话客服电话\",\"style\":{\"width\":\"80%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"consumer_hotline\"},{\"__config__\":{\"label\":\"Message\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":104,\"renderKey\":1644477701613},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入Message客服链接\",\"style\":{\"width\":\"80%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"consumer_message\"},{\"__config__\":{\"label\":\"客服邮箱\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":105,\"renderKey\":1644477803104},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入客服邮箱\",\"style\":{\"width\":\"95%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"consumer_email\"},{\"__config__\":{\"label\":\"客服方式\",\"showLabel\":true,\"labelWidth\":null,\"tag\":\"el-select\",\"tagIcon\":\"select\",\"layout\":\"colFormItem\",\"span\":24,\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/select\",\"formId\":102,\"renderKey\":1644477979588},\"__slot__\":{\"options\":[{\"label\":\"云智服\",\"value\":\"h5\"},{\"label\":\"电话\",\"value\":\"hotline\"},{\"label\":\"Message\",\"value\":\"message\"},{\"label\":\"邮件\",\"value\":\"email\"}]},\"placeholder\":\"请选择客服方式\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"disabled\":false,\"filterable\":false,\"multiple\":false,\"__vModel__\":\"consumer_type\"}]}', '2020-05-21 11:07:21', '2022-02-11 18:11:30');
INSERT INTO `eb_system_form_temp` VALUES (77, '商城基础配置', '商城配置-商城基础配置', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":300,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"退货理由\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-input\",\"tagIcon\":\"textarea\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"formId\":103,\"renderKey\":1644890538190},\"type\":\"textarea\",\"placeholder\":\"请填写退货理由退货理由退货理由\",\"autosize\":{\"minRows\":4,\"maxRows\":4},\"style\":{\"width\":\"95%\"},\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"stor_reason\"},{\"__config__\":{\"label\":\"移动端顶部logo图标(127*45)\",\"tag\":\"self-upload\",\"tagIcon\":\"upload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":300,\"required\":true,\"span\":24,\"showTip\":false,\"buttonText\":\"点击上传\",\"regList\":[],\"changeTag\":true,\"fileSize\":2,\"sizeUnit\":\"MB\",\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":124,\"renderKey\":1595659136385,\"tips\":false},\"__slot__\":{\"list-type\":true},\"action\":\"https://jsonplaceholder.typicode.com/posts/\",\"disabled\":true,\"accept\":\"\",\"name\":\"file\",\"auto-upload\":true,\"list-type\":\"text\",\"multiple\":false,\"__vModel__\":\"mobile_top_logo\"},{\"__config__\":{\"label\":\"移动端登录页logo(90x90)\",\"tag\":\"self-upload\",\"tagIcon\":\"upload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":300,\"required\":true,\"span\":24,\"showTip\":false,\"buttonText\":\"点击上传\",\"regList\":[],\"changeTag\":true,\"fileSize\":2,\"sizeUnit\":\"MB\",\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":102,\"renderKey\":1629094835969,\"tips\":false},\"__slot__\":{\"list-type\":true},\"action\":\"https://jsonplaceholder.typicode.com/posts/\",\"disabled\":true,\"accept\":\"\",\"name\":\"file\",\"auto-upload\":true,\"list-type\":\"text\",\"multiple\":false,\"__vModel__\":\"mobile_login_logo\"},{\"__config__\":{\"label\":\"用户H5默认头像\",\"tag\":\"self-upload\",\"tagIcon\":\"selfUpload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":300,\"required\":false,\"span\":24,\"showTip\":false,\"buttonText\":\"点击上传\",\"regList\":[],\"changeTag\":true,\"fileSize\":2,\"sizeUnit\":\"MB\",\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":103,\"renderKey\":1644568256196,\"tips\":false},\"__slot__\":{\"list-type\":true},\"action\":\"https://jsonplaceholder.typicode.com/posts/\",\"disabled\":true,\"accept\":\"\",\"name\":\"file\",\"auto-upload\":true,\"list-type\":\"text\",\"multiple\":false,\"__vModel__\":\"h5_avatar\"},{\"__config__\":{\"label\":\"普通商品未支付取消订单时间(单位:小时)\",\"showLabel\":true,\"changeTag\":true,\"labelWidth\":300,\"tag\":\"el-input-number\",\"tagIcon\":\"number\",\"span\":24,\"layout\":\"colFormItem\",\"required\":true,\"regList\":[],\"document\":\"https://element.eleme.cn/#/zh-CN/component/input-number\",\"formId\":105,\"renderKey\":1590032096481,\"defaultValue\":2,\"tips\":false},\"placeholder\":\"普通商品未支付取消订单时间(单位:小时)\",\"step\":1,\"step-strictly\":false,\"controls-position\":\"\",\"disabled\":false,\"__vModel__\":\"order_cancel_time\",\"max\":99999,\"min\":0,\"precision\":0},{\"__config__\":{\"label\":\"网站名称\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":101,\"renderKey\":1629086692739,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入网站名称\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"site_name\"},{\"__config__\":{\"label\":\"SEO标题\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":102,\"renderKey\":1629087874359,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入SEO标题\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"seo_title\"},{\"__config__\":{\"label\":\"新闻幻灯片数量上限\",\"showLabel\":true,\"changeTag\":true,\"labelWidth\":null,\"tag\":\"el-input-number\",\"tagIcon\":\"number\",\"span\":24,\"layout\":\"colFormItem\",\"required\":true,\"regList\":[],\"document\":\"https://element.eleme.cn/#/zh-CN/component/input-number\",\"formId\":101,\"renderKey\":1629087608122,\"defaultValue\":1,\"tips\":false},\"placeholder\":\"新闻幻灯片数量上限新闻幻灯片数量上限新闻幻灯片数量上限新闻幻灯片数量上限新闻幻灯片数量上限\",\"step\":1,\"step-strictly\":false,\"controls-position\":\"\",\"disabled\":false,\"__vModel__\":\"news_slides_limit\",\"min\":1,\"max\":3}]}', '2020-05-16 10:19:37', '2022-05-16 16:34:29');
INSERT INTO `eb_system_form_temp` VALUES (81, '阿里云配置', '阿里云配置', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":150,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"空间域名 Domain\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":101,\"renderKey\":1590041796581,\"tips\":true,\"tipsIsLink\":true,\"tipsLink\":\"https://doc.crmeb.com/web/java/crmeb_java/701\",\"tipsDesc\":\"地址怎么配置？\",\"defaultValue\":\"http://yourdomain\"},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入单行文本空间域名 Domain空间域名 Domain\",\"style\":{\"width\":\"80%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"alUploadUrl\"},{\"__config__\":{\"label\":\"accessKey\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":102,\"renderKey\":1590041835433,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入单行文本accessKey\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"alAccessKey\"},{\"__config__\":{\"label\":\"secretKey\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":103,\"renderKey\":1590041835651,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入单行文本secretKey\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"alSecretKey\"},{\"__config__\":{\"label\":\"存储空间名称\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":104,\"renderKey\":1590041835857,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入单行文本存储空间名称\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"alStorageName\"},{\"__config__\":{\"label\":\"所属地域\",\"showLabel\":true,\"labelWidth\":null,\"tag\":\"el-select\",\"tagIcon\":\"select\",\"layout\":\"colFormItem\",\"span\":24,\"required\":true,\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/select\",\"formId\":101,\"renderKey\":1629717898666,\"tips\":false},\"__slot__\":{\"options\":[{\"label\":\"华北2（北京）｜oss-cn-beijing.aliyuncs.com\",\"value\":\"oss-cn-beijing.aliyuncs.com\"},{\"label\":\"华北 3（张家口）｜oss-cn-zhangjiakou.aliyuncs.com\",\"value\":\"oss-cn-zhangjiakou.aliyuncs.com\"},{\"label\":\"华东1（杭州）｜oss-cn-hangzhou.aliyuncs.com\",\"value\":\"oss-cn-hangzhou.aliyuncs.com\"},{\"label\":\"华东2（上海）｜oss-cn-shanghai.aliyuncs.com\",\"value\":\"oss-cn-shanghai.aliyuncs.com\"},{\"label\":\"华北1（青岛）｜oss-cn-qingdao.aliyuncs.com\",\"value\":\"oss-cn-qingdao.aliyuncs.com\"},{\"label\":\"华北5（呼和浩特）｜oss-cn-huhehaote.aliyuncs.com\",\"value\":\"oss-cn-huhehaote.aliyuncs.com\"},{\"label\":\"华北6（乌兰察布）｜oss-cn-wulanchabu.aliyuncs.com\",\"value\":\"oss-cn-wulanchabu.aliyuncs.com\"},{\"label\":\"华南1（深圳）｜oss-cn-shenzhen.aliyuncs.com\",\"value\":\"oss-cn-shenzhen.aliyuncs.com\"},{\"label\":\"华南2（河源）｜oss-cn-heyuan.aliyuncs.com\",\"value\":\"oss-cn-heyuan.aliyuncs.com\"},{\"label\":\"华南3（广州）｜oss-cn-guangzhou.aliyuncs.com\",\"value\":\"oss-cn-guangzhou.aliyuncs.com\"},{\"label\":\"西南1（成都）｜oss-cn-chengdu.aliyuncs.com\",\"value\":\"oss-cn-chengdu.aliyuncs.com\"},{\"label\":\"华南2（河源）｜oss-cn-heyuan.aliyuncs.com\",\"value\":\"oss-cn-heyuan.aliyuncs.com\"},{\"label\":\"华南3（广州）｜oss-cn-guangzhou.aliyuncs.com\",\"value\":\"oss-cn-guangzhou.aliyuncs.com\"},{\"label\":\"西南1（成都）｜oss-cn-chengdu.aliyuncs.com\",\"value\":\"oss-cn-chengdu.aliyuncs.com\"},{\"label\":\"中国（香港）｜oss-cn-hongkong.aliyuncs.com\",\"value\":\"oss-cn-hongkong.aliyuncs.com\"},{\"label\":\"美国西部1（硅谷）｜oss-us-west-1.aliyuncs.com\",\"value\":\"oss-us-west-1.aliyuncs.com\"},{\"label\":\"美国东部1（弗吉尼亚）｜oss-us-east-1.aliyuncs.com\",\"value\":\"oss-us-east-1.aliyuncs.com\"},{\"label\":\"亚太东南1（新加坡）｜oss-ap-southeast-1.aliyuncs.com\",\"value\":\"oss-ap-southeast-1.aliyuncs.com\"},{\"label\":\"亚太东南2（悉尼）｜oss-ap-southeast-2.aliyuncs.com\",\"value\":\"oss-ap-southeast-2.aliyuncs.com\"},{\"label\":\"亚太东南3（吉隆坡）｜oss-ap-southeast-3.aliyuncs.com\",\"value\":\"oss-ap-southeast-3.aliyuncs.com\"},{\"label\":\"亚太东南5（雅加达）｜oss-ap-southeast-5.aliyuncs.com\",\"value\":\"oss-ap-southeast-5.aliyuncs.com\"},{\"label\":\"亚太东北1（日本）｜oss-ap-northeast-1.aliyuncs.com\",\"value\":\"oss-ap-northeast-1.aliyuncs.com\"},{\"label\":\"亚太南部1（孟买）｜oss-ap-south-1.aliyuncs.com\",\"value\":\"oss-ap-south-1.aliyuncs.com\"},{\"label\":\"欧洲中部1（法兰克福）｜oss-eu-central-1.aliyuncs.com\",\"value\":\"oss-eu-central-1.aliyuncs.com\"},{\"label\":\"英国（伦敦）｜oss-eu-west-1.aliyuncs.com\",\"value\":\"oss-eu-west-1.aliyuncs.com\"},{\"label\":\"中东东部1（迪拜）｜oss-me-east-1.aliyuncs.com\",\"value\":\"oss-me-east-1.aliyuncs.com\"}]},\"placeholder\":\"请选择下拉选择所属地域所属地域所属地域所属地域\",\"style\":{\"width\":\"100%\"},\"clearable\":false,\"disabled\":false,\"filterable\":false,\"multiple\":false,\"__vModel__\":\"alStorageRegion\"}]}', '2020-05-21 14:18:12', '2021-12-24 11:11:12');
INSERT INTO `eb_system_form_temp` VALUES (82, '七牛云配置', '七牛云配置', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":150,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"空间域名 Domain\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":101,\"renderKey\":1590041796581,\"tips\":true,\"tipsIsLink\":true,\"tipsLink\":\"http://help.crmeb.net/crmeb_java/2102105\",\"tipsDesc\":\"点击查看详细\"},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入单行文本空间域名 Domain\",\"style\":{\"width\":\"80%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"qnUploadUrl\"},{\"__config__\":{\"label\":\"accessKey\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":102,\"renderKey\":1590041835433,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入单行文本accessKey\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"qnAccessKey\"},{\"__config__\":{\"label\":\"qnSecretKey\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":103,\"renderKey\":1590041835651,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入单行文本qnSecretKey\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"qnSecretKey\"},{\"__config__\":{\"label\":\"存储空间名称\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":104,\"renderKey\":1590041835857,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入单行文本存储空间名称\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"qnStorageName\"},{\"__config__\":{\"label\":\"所属地域\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":105,\"renderKey\":1590041836043,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入单行文本所属地域\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"qnStorageRegion\"}]}', '2020-05-21 14:18:29', '2021-11-02 16:53:27');
INSERT INTO `eb_system_form_temp` VALUES (83, '腾讯云配置', '腾讯云配置', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":150,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"空间域名 Domain\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":101,\"renderKey\":1590041796581,\"tips\":true,\"tipsIsLink\":true,\"tipsLink\":\"http://help.crmeb.net/crmeb_java/2102106\",\"tipsDesc\":\"点击查看详细\"},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入单行文本空间域名 Domain\",\"style\":{\"width\":\"80%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"txUploadUrl\"},{\"__config__\":{\"label\":\"accessKey\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":102,\"renderKey\":1590041835433,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入单行文本accessKeyaccessKeyaccessKeyaccessKey\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"txAccessKey\"},{\"__config__\":{\"label\":\"secretKey\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":103,\"renderKey\":1590041835651,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入单行文本secretKey\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"txSecretKey\"},{\"__config__\":{\"label\":\"存储空间名称\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":104,\"renderKey\":1590041835857,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入单行文本存储空间名称\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"txStorageName\"},{\"__config__\":{\"label\":\"所属地域\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":105,\"renderKey\":1590041836043,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入单行文本所属地域\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"txStorageRegion\"}]}', '2020-05-21 14:18:46', '2021-11-02 16:52:54');
INSERT INTO `eb_system_form_temp` VALUES (89, '个人中心菜单', '个人中心菜单', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"菜单名\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"name\",\"placeholder\":\"请输入菜单名菜单名菜单名菜单名菜单名菜单名菜单名\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":11,\"show-word-limit\":true,\"readonly\":false,\"disabled\":false},{\"__config__\":{\"label\":\"图标(48*48)\",\"tag\":\"self-upload\",\"tagIcon\":\"selfUpload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":null,\"required\":true,\"span\":24,\"showTip\":false,\"buttonText\":\"点击上传\",\"regList\":[],\"changeTag\":true,\"fileSize\":2,\"sizeUnit\":\"MB\",\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":105,\"renderKey\":1596072707659,\"tips\":false},\"__slot__\":{\"list-type\":true},\"action\":\"https://jsonplaceholder.typicode.com/posts/\",\"disabled\":true,\"accept\":\"\",\"name\":\"file\",\"auto-upload\":true,\"list-type\":\"text\",\"multiple\":false,\"__vModel__\":\"pic\"},{\"__config__\":{\"label\":\"h5端链接\",\"showLabel\":true,\"labelWidth\":null,\"tag\":\"el-select\",\"tagIcon\":\"select\",\"layout\":\"colFormItem\",\"span\":24,\"required\":true,\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/select\",\"formId\":142,\"renderKey\":1591060899296,\"tips\":false},\"__slot__\":{\"options\":[{\"label\":\"地址管理\",\"value\":\"/pages/users/user_address_list/index\"},{\"label\":\"会员中心\",\"value\":\"/pages/users/user_vip/index\"},{\"label\":\"砍价记录\",\"value\":\"/pages/activity/bargain/index\"},{\"label\":\"推广中心\",\"value\":\"/pages/users/user_spread_user/index\"},{\"label\":\"我的余额\",\"value\":\"/pages/users/user_money/index\"},{\"label\":\"我的收藏\",\"value\":\"/pages/users/user_goods_collection/index\"},{\"label\":\"优惠券\",\"value\":\"/pages/users/user_coupon/index\"},{\"label\":\"后台订单管理\",\"value\":\"/pages/admin/order/index\"},{\"label\":\"联系客服\",\"value\":\"/pages/service/index\"},{\"label\":\"订单核销\",\"value\":\"/pages/admin/order_cancellation/index\"}]},\"placeholder\":\"请选择h5端链接\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"disabled\":false,\"filterable\":true,\"multiple\":false,\"__vModel__\":\"url\"},{\"__config__\":{\"label\":\"PC端链接\",\"showLabel\":true,\"labelWidth\":null,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"layout\":\"colFormItem\",\"span\":24,\"required\":true,\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"formId\":140,\"renderKey\":1591064071606,\"tips\":false},\"__slot__\":{\"options\":[{\"label\":\"地址管理\",\"value\":\"/pages/users/user_address_list/index\"},{\"label\":\"会员中心\",\"value\":\"/pages/users/user_vip/index\"},{\"label\":\"砍价记录\",\"value\":\"/pages/activity/bargain/index\"},{\"label\":\"推广中心\",\"value\":\"/pages/users/user_spread_user/index\"},{\"label\":\"我的余额\",\"value\":\"/pages/users/user_money/index\"},{\"label\":\"我的收藏\",\"value\":\"/pages/users/user_goods_collection/index\"},{\"label\":\"优惠券\",\"value\":\"/pages/users/user_coupon/index\"},{\"label\":\"后台订单管理\",\"value\":\"/pages/admin/order/index\"},{\"label\":\"联系客服\",\"value\":\"https://yzf.qq.com/xv/web/static/chat/index.html?sign=37ef9b97db2656c32340cde61ce2b56a2176efe72ac7ed421c77607b5c816611ec4775a17c7605b33df1ffe1d22a4ce7464dd07b\"},{\"label\":\"订单核销\",\"value\":\"/pages/admin/order_cancellation/index\"}]},\"placeholder\":\"请输入PC端链接\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"pc_url\"}]}', '2020-06-02 09:24:19', '2022-06-02 12:00:34');
INSERT INTO `eb_system_form_temp` VALUES (90, '个人中心轮播图', '个人中心轮播图', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":120,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"图片(690x138)\",\"tag\":\"self-upload\",\"tagIcon\":\"selfUpload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":null,\"required\":true,\"span\":24,\"showTip\":false,\"buttonText\":\"点击上传\",\"regList\":[],\"changeTag\":true,\"fileSize\":2,\"sizeUnit\":\"MB\",\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":102,\"renderKey\":1597289113769,\"tips\":false},\"__slot__\":{\"list-type\":true},\"action\":\"https://jsonplaceholder.typicode.com/posts/\",\"disabled\":true,\"accept\":\"\",\"name\":\"file\",\"auto-upload\":true,\"list-type\":\"text\",\"multiple\":false,\"__vModel__\":\"pic\"},{\"__config__\":{\"label\":\"跳转链接\",\"labelWidth\":120,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":140,\"renderKey\":1591064520353,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入跳转跳转链接跳转链接\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"url\"}]}', '2020-06-02 10:24:06', '2021-12-22 16:18:44');
INSERT INTO `eb_system_form_temp` VALUES (95, '首页banner滚动图', '首页banner滚动图', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"标题\",\"labelWidth\":130,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"name\",\"placeholder\":\"请输入标题标题标题标题\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"\",\"show-word-limit\":true,\"readonly\":false,\"disabled\":false},{\"__config__\":{\"label\":\"跳转链接\",\"labelWidth\":130,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":101,\"renderKey\":1591065625767,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"url\",\"placeholder\":\"请输入跳转链接\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"\",\"show-word-limit\":true,\"readonly\":false,\"disabled\":false},{\"__config__\":{\"label\":\"图片(750 x 375)\",\"tag\":\"self-upload\",\"tagIcon\":\"selfUpload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":130,\"required\":true,\"span\":24,\"showTip\":false,\"buttonText\":\"点击上传\",\"regList\":[],\"changeTag\":true,\"fileSize\":2,\"sizeUnit\":\"MB\",\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":102,\"renderKey\":1597286491734,\"tips\":false,\"tipsDesc\":\"\"},\"__slot__\":{\"list-type\":true},\"action\":\"https://jsonplaceholder.typicode.com/posts/\",\"disabled\":true,\"accept\":\"\",\"name\":\"file\",\"auto-upload\":true,\"list-type\":\"text\",\"multiple\":false,\"__vModel__\":\"pic\"}]}', '2020-06-02 10:41:29', '2021-12-22 16:06:49');
INSERT INTO `eb_system_form_temp` VALUES (96, '导航模块', '导航模块', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":120,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"标题\",\"labelWidth\":120,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"name\",\"placeholder\":\"请输入标题标题标题标题标题标题\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"\",\"show-word-limit\":true,\"readonly\":false,\"disabled\":false},{\"__config__\":{\"label\":\"图片(90x90)\",\"tag\":\"self-upload\",\"tagIcon\":\"selfUpload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":null,\"required\":true,\"span\":24,\"showTip\":false,\"buttonText\":\"点击上传\",\"regList\":[],\"changeTag\":true,\"fileSize\":2,\"sizeUnit\":\"MB\",\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":101,\"renderKey\":1597287354047,\"tips\":false},\"__slot__\":{\"list-type\":true},\"action\":\"https://jsonplaceholder.typicode.com/posts/\",\"disabled\":true,\"accept\":\"\",\"name\":\"file\",\"auto-upload\":true,\"list-type\":\"text\",\"multiple\":false,\"__vModel__\":\"pic\"},{\"__config__\":{\"label\":\"跳转链接\",\"showLabel\":true,\"labelWidth\":null,\"tag\":\"el-select\",\"tagIcon\":\"select\",\"layout\":\"colFormItem\",\"span\":24,\"required\":true,\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/select\",\"formId\":102,\"renderKey\":1591080591082,\"tips\":false},\"__slot__\":{\"options\":[{\"label\":\"商城首页\",\"value\":\"/pages/index/index\"},{\"label\":\"个人推广\",\"value\":\"/pages/user_spread_user/index\"},{\"label\":\"优惠券\",\"value\":\"/pages/users/user_get_coupon/index\"},{\"label\":\"个人中心\",\"value\":\"/pages/user/user\"},{\"label\":\"秒杀列表\",\"value\":\"/pages/activity/goods_seckill/index\"},{\"label\":\"拼团列表页\",\"value\":\"/pages/activity/goods_combination/index\"},{\"label\":\"砍价列表\",\"value\":\"/pages/activity/goods_bargain/index\"},{\"label\":\"分类页面\",\"value\":\"/pages/goods_cate/goods_cate\"},{\"label\":\"地址列表\",\"value\":\"/pages/users/user_address_list/index\"},{\"label\":\"提现页面\",\"value\":\"/pages/user_cash/index\"},{\"label\":\"推广统计\",\"value\":\"/pages/promoter-list/index\"},{\"label\":\"账户金额\",\"value\":\"/pages/users/user_goods_collection/index\"},{\"label\":\"推广二维码页面\",\"value\":\"/pages/promotion-card/promotion-card\"},{\"label\":\"购物车页面\",\"value\":\"/pages/order_addcart/order_addcart\"},{\"label\":\"订单列表页面\",\"value\":\"/pages/users/order_list/index\"},{\"label\":\"文章列表页\",\"value\":\"/pages/news_list/index\"},{\"label\":\"我要签到\",\"value\":\"/pages/users/user_sgin/index\"},{\"label\":\"我的收藏\",\"value\":\"/pages/users/user_goods_collection/index\"}]},\"placeholder\":\"请选择跳转链接\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"disabled\":false,\"filterable\":true,\"multiple\":false,\"__vModel__\":\"url\"},{\"__config__\":{\"label\":\"底部菜单\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-radio-group\",\"tagIcon\":\"radio\",\"changeTag\":true,\"layout\":\"colFormItem\",\"span\":24,\"optionType\":\"default\",\"regList\":[],\"required\":true,\"border\":false,\"document\":\"https://element.eleme.cn/#/zh-CN/component/radio\",\"formId\":103,\"renderKey\":1591080806108,\"defaultValue\":1,\"tips\":false},\"__slot__\":{\"options\":[{\"label\":\"是\",\"value\":1},{\"label\":\"否\",\"value\":2}]},\"style\":{},\"size\":\"medium\",\"disabled\":false,\"__vModel__\":\"show\"}]}', '2020-06-02 10:41:29', '2021-12-22 16:20:21');
INSERT INTO `eb_system_form_temp` VALUES (97, '首页滚动新闻', '首页滚动新闻', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"滚动文字\",\"labelWidth\":120,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[]},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"info\",\"placeholder\":\"请输入滚动文字滚动文字\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"\",\"show-word-limit\":true,\"readonly\":false,\"disabled\":false},{\"__config__\":{\"label\":\"跳转链接\",\"showLabel\":true,\"labelWidth\":120,\"tag\":\"el-select\",\"tagIcon\":\"select\",\"layout\":\"colFormItem\",\"span\":24,\"required\":true,\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/select\",\"formId\":102,\"renderKey\":1591080591082},\"__slot__\":{\"options\":[{\"label\":\"商城首页\",\"value\":\"/pages/index/index\"},{\"label\":\"个人推广\",\"value\":\"/pages/user_spread_user/index\"},{\"label\":\"优惠券\",\"value\":\"/pages/users/user_get_coupon/index\"},{\"label\":\"个人中心\",\"value\":\"/pages/user/user\"},{\"label\":\"秒杀列表\",\"value\":\"/pages/activity/goods_seckill/index\"},{\"label\":\"拼团列表页\",\"value\":\"/pages/activity/goods_combination/index\"},{\"label\":\"砍价列表\",\"value\":\"/pages/activity/goods_bargain/index\"},{\"label\":\"分类页面\",\"value\":\"/pages/goods_cate/goods_cate\"},{\"label\":\"地址列表\",\"value\":\"/pages/users/user_address_list/index\"},{\"label\":\"提现页面\",\"value\":\"/pages/user_cash/index\"},{\"label\":\"推广统计\",\"value\":\"/pages/promoter-list/index\"},{\"label\":\"账户金额\",\"value\":\"/pages/users/user_goods_collection/index\"},{\"label\":\"推广二维码页面\",\"value\":\"/pages/promotion-card/promotion-card\"},{\"label\":\"购物车页面\",\"value\":\"/pages/order_addcart/order_addcart\"},{\"label\":\"订单列表页面\",\"value\":\"/pages/users/order_list/index\"},{\"label\":\"文章列表页\",\"value\":\"/pages/news_list/index\"}]},\"placeholder\":\"请选择跳转链接\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"disabled\":false,\"filterable\":true,\"multiple\":false,\"__vModel__\":\"url\"},{\"__config__\":{\"label\":\"底部菜单\",\"labelWidth\":120,\"showLabel\":true,\"tag\":\"el-radio-group\",\"tagIcon\":\"radio\",\"changeTag\":true,\"layout\":\"colFormItem\",\"span\":24,\"optionType\":\"default\",\"regList\":[],\"required\":true,\"border\":false,\"document\":\"https://element.eleme.cn/#/zh-CN/component/radio\",\"formId\":103,\"renderKey\":1591080806108,\"defaultValue\":1},\"__slot__\":{\"options\":[{\"label\":\"是\",\"value\":1},{\"label\":\"否\",\"value\":2}]},\"style\":{},\"size\":\"medium\",\"disabled\":false,\"__vModel__\":\"show\"}]}', '2020-06-02 10:41:29', '2020-08-13 10:35:02');
INSERT INTO `eb_system_form_temp` VALUES (98, '首页活动区域图片', '首页活动区域图片', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"图片(710*280)\",\"tag\":\"self-upload\",\"tagIcon\":\"selfUpload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":130,\"required\":true,\"span\":24,\"showTip\":false,\"buttonText\":\"点击上传\",\"regList\":[],\"changeTag\":true,\"fileSize\":2,\"sizeUnit\":\"MB\",\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":102,\"renderKey\":1597286612904},\"__slot__\":{\"list-type\":true},\"action\":\"https://jsonplaceholder.typicode.com/posts/\",\"disabled\":true,\"accept\":\"\",\"name\":\"file\",\"auto-upload\":true,\"list-type\":\"text\",\"multiple\":false,\"__vModel__\":\"image\"},{\"__config__\":{\"label\":\"标题\",\"labelWidth\":130,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[]},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"title\",\"placeholder\":\"请输入标题标题标题\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"\",\"show-word-limit\":true,\"readonly\":false,\"disabled\":false},{\"__config__\":{\"label\":\"简介\",\"labelWidth\":130,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":101,\"renderKey\":1591081196107},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"info\",\"placeholder\":\"请输入简介\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"\",\"show-word-limit\":true,\"readonly\":false,\"disabled\":false},{\"__config__\":{\"label\":\"跳转链接\",\"showLabel\":true,\"labelWidth\":130,\"tag\":\"el-select\",\"tagIcon\":\"select\",\"layout\":\"colFormItem\",\"span\":24,\"required\":true,\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/select\",\"formId\":102,\"renderKey\":1591080591082},\"__slot__\":{\"options\":[{\"label\":\"秒杀列表\",\"value\":\"/pages/activity/goods_seckill/index\"},{\"label\":\"拼团列表页\",\"value\":\"/pages/activity/goods_combination/index\"},{\"label\":\"砍价列表\",\"value\":\"/pages/activity/goods_bargain/index\"}]},\"placeholder\":\"请选择跳转链接\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"disabled\":false,\"filterable\":true,\"multiple\":false,\"__vModel__\":\"link\"}]}', '2020-06-02 10:41:29', '2020-08-13 10:44:02');
INSERT INTO `eb_system_form_temp` VALUES (99, '首页超值爆款', '首页超值爆款', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"图片(710*280)\",\"tag\":\"self-upload\",\"tagIcon\":\"selfUpload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":130,\"required\":true,\"span\":24,\"showTip\":false,\"buttonText\":\"点击上传\",\"regList\":[],\"changeTag\":true,\"fileSize\":2,\"sizeUnit\":\"MB\",\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":101,\"renderKey\":1597286019454,\"tips\":false},\"__slot__\":{\"list-type\":true},\"action\":\"https://jsonplaceholder.typicode.com/posts/\",\"disabled\":true,\"accept\":\"\",\"name\":\"file\",\"auto-upload\":true,\"list-type\":\"text\",\"multiple\":false,\"__vModel__\":\"pic\"},{\"__config__\":{\"label\":\"标题\",\"labelWidth\":130,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"name\",\"placeholder\":\"请输入标题标题标题\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"\",\"show-word-limit\":true,\"readonly\":false,\"disabled\":false},{\"__config__\":{\"label\":\"简介\",\"labelWidth\":130,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":101,\"renderKey\":1591081196107,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"info\",\"placeholder\":\"请输入简介简介\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"\",\"show-word-limit\":true,\"readonly\":false,\"disabled\":false},{\"__config__\":{\"label\":\"类型\",\"showLabel\":true,\"labelWidth\":130,\"tag\":\"el-select\",\"tagIcon\":\"select\",\"layout\":\"colFormItem\",\"span\":24,\"required\":true,\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/select\",\"formId\":102,\"renderKey\":1591080591082,\"tips\":false},\"__slot__\":{\"options\":[{\"label\":\"精品推荐\",\"value\":1},{\"label\":\"热门榜单\",\"value\":2},{\"label\":\"首发新品\",\"value\":3},{\"label\":\"促销单品\",\"value\":4}]},\"placeholder\":\"请选择类型\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"disabled\":false,\"filterable\":true,\"multiple\":false,\"__vModel__\":\"type\"}]}', '2020-06-02 10:41:29', '2021-12-23 16:00:42');
INSERT INTO `eb_system_form_temp` VALUES (100, '首页文字配置', '首页文字配置', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"快速选择简介\",\"labelWidth\":120,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[]},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"fast_info\",\"placeholder\":\"请输入快速选择简介\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"\",\"show-word-limit\":true,\"readonly\":false,\"disabled\":false},{\"__config__\":{\"label\":\"精品推荐简介\",\"labelWidth\":120,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":101,\"renderKey\":1591081579041},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"bast_info\",\"placeholder\":\"请输入精品推荐简介\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"\",\"show-word-limit\":true,\"readonly\":false,\"disabled\":false},{\"__config__\":{\"label\":\"首发新品简介\",\"labelWidth\":120,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":102,\"renderKey\":1591081598503},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"first_info\",\"placeholder\":\"请输入首发新品简介\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"\",\"show-word-limit\":true,\"readonly\":false,\"disabled\":false},{\"__config__\":{\"label\":\"促销单品简介\",\"labelWidth\":120,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":103,\"renderKey\":1591081599048},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"sales_info\",\"placeholder\":\"请输入促销单品简介\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"\",\"show-word-limit\":true,\"readonly\":false,\"disabled\":false}]}', '2020-06-02 15:07:11', '2020-06-02 15:07:11');
INSERT INTO `eb_system_form_temp` VALUES (101, '首页精品推荐benner图', '首页精品推荐benner图', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"图片\",\"tag\":\"self-upload\",\"tagIcon\":\"selfUpload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":null,\"required\":true,\"span\":24,\"showTip\":false,\"buttonText\":\"点击上传\",\"regList\":[],\"changeTag\":true,\"fileSize\":2,\"sizeUnit\":\"MB\",\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":101,\"renderKey\":1597285983911},\"__slot__\":{\"list-type\":true},\"action\":\"https://jsonplaceholder.typicode.com/posts/\",\"disabled\":true,\"accept\":\"\",\"name\":\"file\",\"auto-upload\":true,\"list-type\":\"text\",\"multiple\":false,\"__vModel__\":\"img\"},{\"__config__\":{\"label\":\"描述\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":102,\"renderKey\":1591083877308},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入描述\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"comment\"},{\"__config__\":{\"label\":\"跳转链接\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":103,\"renderKey\":1591083894228},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入跳转链接\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"link\"}]}', '2020-06-02 15:45:01', '2020-08-13 10:33:18');
INSERT INTO `eb_system_form_temp` VALUES (102, '热门搜索', '热门搜索', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"标签\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[]},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"title\",\"placeholder\":\"请输入标签\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":11,\"show-word-limit\":true,\"readonly\":false,\"disabled\":false}]}', '2020-06-03 11:34:29', '2020-06-03 11:34:29');
INSERT INTO `eb_system_form_temp` VALUES (105, '模板消息', '模板消息', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"模板编号\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[]},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"tempKey\",\"placeholder\":\"请输入模板编号\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"\",\"show-word-limit\":true,\"readonly\":false,\"disabled\":false},{\"__config__\":{\"label\":\"模板ID\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":106,\"renderKey\":1592281492122},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入模板ID\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"tempId\"},{\"__config__\":{\"label\":\"模板名\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":105,\"renderKey\":1592281490129},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入模板名\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"name\"},{\"__config__\":{\"label\":\"回复内容\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-input\",\"tagIcon\":\"textarea\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"formId\":104,\"renderKey\":1592281487212},\"type\":\"textarea\",\"placeholder\":\"请输入回复内容\",\"autosize\":{\"minRows\":4,\"maxRows\":4},\"style\":{\"width\":\"100%\"},\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"content\"},{\"__config__\":{\"label\":\"状态\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-radio-group\",\"tagIcon\":\"radio\",\"changeTag\":true,\"layout\":\"colFormItem\",\"span\":24,\"optionType\":\"default\",\"regList\":[],\"required\":true,\"border\":false,\"document\":\"https://element.eleme.cn/#/zh-CN/component/radio\",\"formId\":109,\"renderKey\":1592289933100,\"defaultValue\":0},\"__slot__\":{\"options\":[{\"label\":\"开启\",\"value\":1},{\"label\":\"关闭\",\"value\":0}]},\"style\":{},\"size\":\"medium\",\"disabled\":false,\"__vModel__\":\"status\"}]}', '2020-06-16 12:28:38', '2020-12-04 16:49:38');
INSERT INTO `eb_system_form_temp` VALUES (106, '拒绝退款', '拒绝退款', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"退款单号\",\"labelWidth\":120,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"refundOrderNo\",\"placeholder\":\"请输入拒绝退款单号退款单号\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"\",\"show-word-limit\":true,\"readonly\":true,\"disabled\":false},{\"__config__\":{\"label\":\"不退款原因\",\"labelWidth\":120,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"textarea\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":112,\"renderKey\":1592451273684,\"tips\":false},\"type\":\"textarea\",\"placeholder\":\"请输入不退款原因\",\"autosize\":{\"minRows\":4,\"maxRows\":4},\"style\":{\"width\":\"100%\"},\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"reason\"}]}', '2020-06-18 11:36:28', '2022-03-30 16:03:23');
INSERT INTO `eb_system_form_temp` VALUES (107, '立即退款', '立即退款', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"退款单号\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"orderId\",\"placeholder\":\"请输入退款单号退款单号退款单号退款单号退款单号\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"\",\"show-word-limit\":true,\"readonly\":true,\"disabled\":false},{\"__config__\":{\"label\":\"退款金额\",\"showLabel\":true,\"changeTag\":true,\"labelWidth\":null,\"tag\":\"el-input-number\",\"tagIcon\":\"number\",\"span\":24,\"layout\":\"colFormItem\",\"required\":true,\"regList\":[],\"document\":\"https://element.eleme.cn/#/zh-CN/component/input-number\",\"formId\":110,\"renderKey\":1592452495718,\"tips\":false},\"placeholder\":\"退款金额\",\"step\":1,\"step-strictly\":false,\"controls-position\":\"\",\"disabled\":true,\"__vModel__\":\"amount\",\"min\":0}]}', '2020-06-18 11:57:03', '2022-02-25 17:59:46');
INSERT INTO `eb_system_form_temp` VALUES (108, '文件上传-基础配置', '文件上传-本地配置', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"本地图片域名\",\"labelWidth\":270,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":101,\"renderKey\":1592476026393,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入本地图片域名\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"localUploadUrl\"},{\"__config__\":{\"label\":\"允许上传图片后缀\",\"labelWidth\":270,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":103,\"renderKey\":1598344152903,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"允许上传图片后缀，多个英文逗号分割允许上传图片后缀\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"image_ext_str\"},{\"__config__\":{\"label\":\"允许上传最大图片(单位 M，最大值50 )\",\"labelWidth\":270,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input-number\",\"tagIcon\":\"number\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input-number\",\"regList\":[],\"formId\":104,\"renderKey\":1598344206314,\"tips\":false},\"placeholder\":\"单位 M允许上传最大图片(单位 M，最大值50 )\",\"step\":1,\"step-strictly\":false,\"controls-position\":\"\",\"disabled\":false,\"__vModel__\":\"image_max_size\",\"min\":1,\"max\":50},{\"__config__\":{\"label\":\"允许上传文件后缀\",\"labelWidth\":270,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":106,\"renderKey\":1598344273484,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"，多个英文逗号分割\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"file_ext_str\"},{\"__config__\":{\"label\":\"允许上传最大文件(单位 M，最大值500 )\",\"labelWidth\":270,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input-number\",\"tagIcon\":\"number\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input-number\",\"regList\":[],\"formId\":107,\"renderKey\":1598344275586,\"tips\":false},\"placeholder\":\"单位 M允许上传最大文件(单位 M，最大值500 )\",\"step\":1,\"step-strictly\":false,\"controls-position\":\"\",\"disabled\":false,\"__vModel__\":\"file_max_size\",\"min\":1,\"max\":500},{\"__config__\":{\"label\":\"文件存储\",\"showLabel\":true,\"labelWidth\":270,\"tag\":\"el-select\",\"tagIcon\":\"select\",\"layout\":\"colFormItem\",\"span\":24,\"required\":true,\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/select\",\"formId\":102,\"renderKey\":1599545811870,\"defaultValue\":1,\"tips\":false},\"__slot__\":{\"options\":[{\"label\":\"本地\",\"value\":1},{\"label\":\"七牛云\",\"value\":2},{\"label\":\"阿里云\",\"value\":3},{\"label\":\"腾讯云\",\"value\":4}]},\"placeholder\":\"请选择文件存储文件存储\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"disabled\":false,\"filterable\":true,\"multiple\":false,\"__vModel__\":\"uploadType\"},{\"__config__\":{\"label\":\"文件是否保存本地（云存储）\",\"labelWidth\":270,\"showLabel\":true,\"tag\":\"el-radio-group\",\"tagIcon\":\"radio\",\"changeTag\":true,\"layout\":\"colFormItem\",\"span\":24,\"optionType\":\"default\",\"regList\":[],\"required\":true,\"border\":false,\"document\":\"https://element.eleme.cn/#/zh-CN/component/radio\",\"formId\":102,\"renderKey\":1629358181244,\"defaultValue\":1,\"tips\":false},\"__slot__\":{\"options\":[{\"label\":\"保存\",\"value\":1},{\"label\":\"不保存\",\"value\":0}]},\"style\":{},\"size\":\"medium\",\"disabled\":false,\"__vModel__\":\"file_is_save\"}]}', '2020-06-18 18:28:13', '2021-12-09 14:33:45');
INSERT INTO `eb_system_form_temp` VALUES (110, '短信模板消息', '短信模板消息', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"模板名称\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":140,\"renderKey\":1595402251597},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入模板名称\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"title\"},{\"__config__\":{\"label\":\"模板内容\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-input\",\"tagIcon\":\"textarea\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"formId\":141,\"renderKey\":1595402320867,\"defaultValue\":\"您的验证码是：{$code}，有效期为{$time}分钟。如非本人操作，可不用理会。模板中的{$code}和{$time}需要替换成对应的变量，请开发者知晓。修改此项无效！\"},\"type\":\"textarea\",\"placeholder\":\"请输入模板内容\",\"autosize\":{\"minRows\":4},\"style\":{\"width\":\"100%\"},\"maxlength\":null,\"show-word-limit\":true,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"content\"},{\"__config__\":{\"label\":\"模板类型\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-radio-group\",\"tagIcon\":\"radio\",\"changeTag\":true,\"layout\":\"colFormItem\",\"span\":24,\"optionType\":\"default\",\"regList\":[],\"required\":true,\"border\":false,\"document\":\"https://element.eleme.cn/#/zh-CN/component/radio\",\"formId\":142,\"renderKey\":1595402411016,\"defaultValue\":1},\"__slot__\":{\"options\":[{\"label\":\"验证码\",\"value\":1},{\"label\":\"通知\",\"value\":2},{\"label\":\"推广\",\"value\":3}]},\"style\":{},\"size\":\"medium\",\"disabled\":false,\"__vModel__\":\"type\"}]}', '2020-07-22 15:21:26', '2020-12-01 11:56:33');
INSERT INTO `eb_system_form_temp` VALUES (111, '短信设置', '短信设置', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":300,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":16,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"阿里云短信Key Id\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":16,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":101,\"renderKey\":1644982308964},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入阿里云短信Key Id\",\"style\":{\"width\":\"95%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"aliyun_sms_key_id\"},{\"__config__\":{\"label\":\"阿里云短信Key Secret\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":16,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":102,\"renderKey\":1644982309985},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入阿里云短信Key Secret\",\"style\":{\"width\":\"95%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"aliyun_sms_key_secret\"},{\"__config__\":{\"label\":\"阿里云短信通用签名\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":16,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":103,\"renderKey\":1644982314862},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入阿里云短信通用签名\",\"style\":{\"width\":\"95%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"aliyun_sms_sign_name\"},{\"__config__\":{\"label\":\"验证码有效时间 (分钟)\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input-number\",\"tagIcon\":\"number\",\"required\":true,\"layout\":\"colFormItem\",\"span\":16,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input-number\",\"regList\":[],\"formId\":103,\"renderKey\":1598497111542,\"defaultValue\":1,\"tips\":false},\"placeholder\":\"请输入验证码有效时间 (分钟)\",\"step\":1,\"step-strictly\":true,\"controls-position\":\"\",\"disabled\":false,\"__vModel__\":\"sms_code_expire\",\"min\":1}]}', '2020-07-22 17:00:03', '2022-02-16 11:34:32');
INSERT INTO `eb_system_form_temp` VALUES (114, '后台登录页轮播图', '后台登录页轮播图', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":130,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"轮播图(286x420)\",\"tag\":\"self-upload\",\"tagIcon\":\"upload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":null,\"required\":true,\"span\":24,\"showTip\":false,\"buttonText\":\"点击上传\",\"regList\":[],\"changeTag\":true,\"fileSize\":2,\"sizeUnit\":\"MB\",\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":101,\"renderKey\":1596017879033,\"tips\":false},\"__slot__\":{\"list-type\":true},\"action\":\"https://jsonplaceholder.typicode.com/posts/\",\"disabled\":true,\"accept\":\"\",\"name\":\"file\",\"auto-upload\":true,\"list-type\":\"text\",\"multiple\":false,\"__vModel__\":\"pic\"}]}', '2020-07-29 18:15:46', '2021-12-22 16:23:15');
INSERT INTO `eb_system_form_temp` VALUES (115, '订单详情状态图', '订单详情状态图', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"订单状态\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"orderStatus\",\"placeholder\":\"0=未支付,1=待发货,2=待收货,3=待评价,4=已完成订单状态订单状态订单状态\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"\",\"show-word-limit\":true,\"readonly\":false,\"disabled\":false},{\"__config__\":{\"label\":\"透明动图\",\"tag\":\"self-upload\",\"tagIcon\":\"selfUpload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":null,\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"span\":24,\"showTip\":false,\"buttonText\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":101,\"renderKey\":1640163223626},\"__slot__\":{\"list-type\":true},\"disabled\":true,\"accept\":\"image\",\"name\":\"file\",\"multiple\":false,\"__vModel__\":\"image\"}]}', '2020-07-29 19:40:23', '2021-12-22 17:29:12');
INSERT INTO `eb_system_form_temp` VALUES (122, '99api', '99api', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"ApiKey\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":101,\"renderKey\":1599538285999,\"tips\":true,\"tipsDesc\":\"点击查看详细\",\"tipsIsLink\":true,\"tipsLink\":\"http://help.crmeb.net/crmeb_java/2103903\"},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入ApiKey\",\"style\":{\"width\":\"80%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"importProductToken\"}]}', '2020-09-08 12:17:06', '2021-11-02 16:40:49');
INSERT INTO `eb_system_form_temp` VALUES (125, '银行卡提现申请', '银行卡提现申请', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"姓名\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"defaultValue\":\"\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"realName\",\"placeholder\":\"请输入姓名\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"15\",\"show-word-limit\":true,\"readonly\":false,\"disabled\":false},{\"__config__\":{\"label\":\"提现金额\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":101,\"renderKey\":1603703481683,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入提现金额\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":true,\"disabled\":false,\"__vModel__\":\"extractPrice\"},{\"__config__\":{\"label\":\"银行卡号\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":102,\"renderKey\":1603703520389,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入银行卡号\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"bankCode\"},{\"__config__\":{\"label\":\"开户行\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":103,\"renderKey\":1603703557229,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入开户行\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"bankName\"},{\"__config__\":{\"label\":\"备注\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-input\",\"tagIcon\":\"textarea\",\"required\":false,\"layout\":\"colFormItem\",\"span\":24,\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"formId\":104,\"renderKey\":1603703559381,\"tips\":false},\"type\":\"textarea\",\"placeholder\":\"请输入备注\",\"autosize\":{\"minRows\":4,\"maxRows\":4},\"style\":{\"width\":\"100%\"},\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"mark\"}]}', '2020-10-26 17:14:21', '2021-10-30 11:46:11');
INSERT INTO `eb_system_form_temp` VALUES (128, '物流查询', '物流查询', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"物流App Key\",\"labelWidth\":150,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":101,\"renderKey\":1607574358258,\"tips\":false,\"tipsDesc\":\"购买链接\",\"tipsIsLink\":false,\"tipsLink\":\"https://market.aliyun.com/products/57126001/cmapi021863.html?userCode=dligum2z快递查询密钥\"},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"清输入物流App Key\",\"style\":{\"width\":\"80%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"logistics_app_key\"},{\"__config__\":{\"label\":\"物流App Secret\",\"labelWidth\":150,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":101,\"renderKey\":1644992391177},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入物流App Secret\",\"style\":{\"width\":\"80%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"logistics_app_secret\"}]}', '2020-12-10 12:11:38', '2022-02-16 14:21:44');
INSERT INTO `eb_system_form_temp` VALUES (129, '电子面单', '电子面单', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"电子面单是否开启\",\"labelWidth\":150,\"showLabel\":true,\"tag\":\"el-radio-group\",\"tagIcon\":\"radio\",\"changeTag\":true,\"layout\":\"colFormItem\",\"span\":24,\"optionType\":\"default\",\"regList\":[],\"required\":true,\"border\":false,\"document\":\"https://element.eleme.cn/#/zh-CN/component/radio\",\"formId\":101,\"renderKey\":1607573397849,\"defaultValue\":1,\"tips\":true,\"tipsIsLink\":true,\"tipsLink\":\"http://help.crmeb.net/crmeb_java/2098999\",\"tipsDesc\":\"点击查看详细\"},\"__slot__\":{\"options\":[{\"label\":\"打开\",\"value\":1},{\"label\":\"关闭\",\"value\":2}]},\"style\":{},\"size\":\"medium\",\"disabled\":false,\"__vModel__\":\"config_export_open\"},{\"__config__\":{\"label\":\"发货人姓名\",\"labelWidth\":150,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":101,\"renderKey\":1607573602374,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"快递面单发货人姓名\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"el-icon-warning-outline\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"config_export_to_name\"},{\"__config__\":{\"label\":\"发货人电话\",\"labelWidth\":150,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":103,\"renderKey\":1607573608679,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"快递面单发货人电话\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"config_export_to_tel\"},{\"__config__\":{\"label\":\"发货人详细地址\",\"labelWidth\":150,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":104,\"renderKey\":1607573609130,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"快递面单发货人详细地址\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"config_export_to_address\"},{\"__config__\":{\"label\":\"电子面单打印机编号\",\"labelWidth\":150,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":105,\"renderKey\":1607573609617,\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请购买快递100电子面单打印机，淘宝地址：https://m.tb.cn/h.437NvI0 官网：https://www.kuaidi100.com/cloud/print/cloudprinterSecond.shtml\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"el-icon-warning-outline\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"config_export_siid\"}]}', '2020-12-10 12:18:18', '2021-11-02 16:55:15');
INSERT INTO `eb_system_form_temp` VALUES (130, '充值退款', '充值退款', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"编号\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":102,\"renderKey\":1608271559043},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入编号\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":true,\"__vModel__\":\"id\"},{\"__config__\":{\"label\":\"退款单号\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[]},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"orderId\",\"placeholder\":\"请输入退款单号退款单号退款单号\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"\",\"show-word-limit\":true,\"readonly\":true,\"disabled\":false},{\"__config__\":{\"label\":\"状态\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-radio-group\",\"tagIcon\":\"radio\",\"changeTag\":true,\"layout\":\"colFormItem\",\"span\":24,\"optionType\":\"default\",\"regList\":[],\"required\":true,\"border\":false,\"document\":\"https://element.eleme.cn/#/zh-CN/component/radio\",\"formId\":101,\"renderKey\":1608263757741,\"defaultValue\":1},\"__slot__\":{\"options\":[{\"label\":\"本金+赠送\",\"value\":2},{\"label\":\"仅本金\",\"value\":1}]},\"style\":{},\"size\":\"medium\",\"disabled\":false,\"__vModel__\":\"type\"}]}', '2020-12-18 11:56:49', '2020-12-18 14:49:17');
INSERT INTO `eb_system_form_temp` VALUES (133, '首页配置', '首页配置', '{\"formRef\":\"stivepeimEdited\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":140,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"精品推荐简介\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-input\",\"tagIcon\":\"textarea\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"formId\":103,\"renderKey\":1591148546642},\"type\":\"textarea\",\"placeholder\":\"请输入精品推荐简介\",\"autosize\":{\"minRows\":4,\"maxRows\":4},\"style\":{\"width\":\"100%\"},\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"bastInfo\"},{\"__config__\":{\"label\":\"首发新品简介\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-input\",\"tagIcon\":\"textarea\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"formId\":104,\"renderKey\":1591148566944},\"type\":\"textarea\",\"placeholder\":\"请输入首发新品简介\",\"autosize\":{\"minRows\":4,\"maxRows\":4},\"style\":{\"width\":\"100%\"},\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"firstInfo\"},{\"__config__\":{\"label\":\"促销单品简介\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-input\",\"tagIcon\":\"textarea\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"formId\":105,\"renderKey\":1591148567412},\"type\":\"textarea\",\"placeholder\":\"请输入促销单品简介\",\"autosize\":{\"minRows\":4,\"maxRows\":4},\"style\":{\"width\":\"100%\"},\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"salesInfo\"},{\"__config__\":{\"label\":\"热门推荐简介\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-input\",\"tagIcon\":\"textarea\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"formId\":102,\"renderKey\":1597821020375},\"type\":\"textarea\",\"placeholder\":\"请输入热门推荐简介\",\"autosize\":{\"minRows\":4,\"maxRows\":4},\"style\":{\"width\":\"100%\"},\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"hotInfo\"}]}', '2021-02-06 11:19:43', '2021-02-06 11:19:43');
INSERT INTO `eb_system_form_temp` VALUES (139, '商城配置', '商城配置', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"Api地址【支付回调】\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[]},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"api_url\",\"placeholder\":\"webSiet网站地址Api地址【支付回调】Api地址【支付回调】\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"\",\"show-word-limit\":true,\"readonly\":false,\"disabled\":false},{\"__config__\":{\"label\":\"主页左上角logo[后台]\",\"tag\":\"self-upload\",\"tagIcon\":\"upload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":null,\"required\":true,\"span\":24,\"showTip\":false,\"buttonText\":\"点击上传\",\"regList\":[],\"changeTag\":true,\"fileSize\":2,\"sizeUnit\":\"MB\",\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":124,\"renderKey\":1595658064081},\"__slot__\":{\"list-type\":true},\"action\":\"https://jsonplaceholder.typicode.com/posts/\",\"disabled\":true,\"accept\":\"\",\"name\":\"file\",\"auto-upload\":true,\"list-type\":\"picture-card\",\"multiple\":false,\"__vModel__\":\"site_logo_lefttop\"},{\"__config__\":{\"label\":\"主页左上角缩回菜单logo[后台]\",\"tag\":\"self-upload\",\"tagIcon\":\"upload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":null,\"required\":true,\"span\":24,\"showTip\":false,\"buttonText\":\"点击上传\",\"regList\":[],\"changeTag\":true,\"fileSize\":2,\"sizeUnit\":\"MB\",\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":127,\"renderKey\":1595658695317},\"__slot__\":{\"list-type\":true},\"action\":\"https://jsonplaceholder.typicode.com/posts/\",\"disabled\":true,\"accept\":\"\",\"name\":\"file\",\"auto-upload\":true,\"list-type\":\"text\",\"multiple\":false,\"__vModel__\":\"site_logo_square\"},{\"__config__\":{\"label\":\"登录页logo[后台]\",\"tag\":\"self-upload\",\"tagIcon\":\"upload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":null,\"required\":true,\"span\":24,\"showTip\":false,\"buttonText\":\"点击上传\",\"regList\":[],\"changeTag\":true,\"fileSize\":2,\"sizeUnit\":\"MB\",\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":101,\"renderKey\":1612510257294},\"__slot__\":{\"list-type\":true},\"action\":\"https://jsonplaceholder.typicode.com/posts/\",\"disabled\":true,\"accept\":\"\",\"name\":\"file\",\"auto-upload\":true,\"list-type\":\"picture-card\",\"multiple\":false,\"__vModel__\":\"site_logo_login\"},{\"__config__\":{\"label\":\"登录页背景图\",\"tag\":\"self-upload\",\"tagIcon\":\"upload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":null,\"required\":true,\"span\":24,\"showTip\":false,\"buttonText\":\"点击上传\",\"regList\":[],\"changeTag\":true,\"fileSize\":2,\"sizeUnit\":\"MB\",\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":152,\"renderKey\":1596017451389},\"__slot__\":{\"list-type\":true},\"action\":\"https://jsonplaceholder.typicode.com/posts/\",\"disabled\":true,\"accept\":\"\",\"name\":\"file\",\"auto-upload\":true,\"list-type\":\"text\",\"multiple\":false,\"__vModel__\":\"admin_login_bg_pic\"}]}', '2021-08-19 15:15:38', '2021-08-19 15:15:38');
INSERT INTO `eb_system_form_temp` VALUES (140, '导航下拉菜单', '导航下拉菜单', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"标题\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[{\"pattern\":\"/^1(3|4|5|7|8|9)\\\\d{9}$/\",\"message\":\"手机号格式错误\"}],\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"select_nav_name\",\"placeholder\":\"请输入标题标题标题\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"el-icon-mobile\",\"suffix-icon\":\"\",\"maxlength\":11,\"show-word-limit\":true,\"readonly\":false,\"disabled\":false}]}', '2021-09-08 10:45:37', '2021-10-29 18:36:06');
INSERT INTO `eb_system_form_temp` VALUES (143, '易联云打印设置', '易联云打印设置', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"易联云应用ID\",\"labelWidth\":180,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"tips\":true,\"tipsDesc\":\"易联云 官网获取\"},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"ylyprint_app_id\",\"placeholder\":\"请输入易联云应用ID易联云应用ID易联云应用ID易联云应用ID易联云应用ID易联云应用ID易联云应用ID易联云应用ID\",\"style\":{\"width\":\"97%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":11,\"show-word-limit\":true,\"readonly\":false,\"disabled\":false},{\"__config__\":{\"label\":\"易联云应用密钥\",\"labelWidth\":180,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"tips\":false,\"formId\":101,\"renderKey\":1638000310366},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"ylyprint_app_secret\",\"placeholder\":\"请输入易联云应用密钥\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"\",\"show-word-limit\":true,\"readonly\":false,\"disabled\":false},{\"__config__\":{\"label\":\"易联云打印机设备码\",\"labelWidth\":180,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"tips\":false,\"formId\":102,\"renderKey\":1638000357901},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"ylyprint_app_machine_code\",\"placeholder\":\"请输入易联云打印机设备码\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"\",\"show-word-limit\":true,\"readonly\":false,\"disabled\":false},{\"__config__\":{\"label\":\"易联云打印机设备密钥\",\"labelWidth\":180,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"tips\":false,\"formId\":103,\"renderKey\":1638000464706},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"ylyprint_app_machine_msign\",\"placeholder\":\"请输入易联云打印机设备密钥\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"\",\"show-word-limit\":true,\"readonly\":false,\"disabled\":false},{\"__config__\":{\"label\":\"支付成功自动打印开关\",\"tag\":\"el-switch\",\"tagIcon\":\"switch\",\"defaultValue\":\"\'0\'\",\"span\":24,\"showLabel\":true,\"labelWidth\":180,\"layout\":\"colFormItem\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/switch\",\"formId\":101,\"renderKey\":1638002536348},\"style\":{},\"disabled\":false,\"active-text\":\"\",\"inactive-text\":\"\",\"active-color\":null,\"inactive-color\":null,\"active-value\":\"\'1\'\",\"inactive-value\":\"\'0\'\",\"__vModel__\":\"ylyprint_auto_status\"},{\"__config__\":{\"label\":\"打印开关\",\"tag\":\"el-switch\",\"tagIcon\":\"switch\",\"defaultValue\":\"\'1\'\",\"span\":24,\"showLabel\":true,\"labelWidth\":180,\"layout\":\"colFormItem\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/switch\",\"formId\":102,\"renderKey\":1638156858490},\"style\":{},\"disabled\":false,\"active-text\":\"\",\"inactive-text\":\"\",\"active-color\":null,\"inactive-color\":null,\"active-value\":\"\'1\'\",\"inactive-value\":\"\'0\'\",\"__vModel__\":\"ylyprint_status\"}]}', '2021-11-27 16:09:51', '2021-12-10 12:17:01');
INSERT INTO `eb_system_form_temp` VALUES (144, 'Meta(Facebook)', 'Meta(Facebook)', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":140,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"Facebook APPID\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"facebook_appid\",\"placeholder\":\"请输入Facebook APPID\",\"style\":{\"width\":\"95%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"\",\"show-word-limit\":true,\"readonly\":false,\"disabled\":false},{\"__config__\":{\"label\":\"开启\",\"tag\":\"el-switch\",\"tagIcon\":\"switch\",\"defaultValue\":\"\'0\'\",\"span\":24,\"showLabel\":true,\"labelWidth\":null,\"layout\":\"colFormItem\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/switch\",\"formId\":102,\"renderKey\":1642837619938},\"style\":{},\"disabled\":false,\"active-text\":\"\",\"inactive-text\":\"\",\"active-color\":null,\"inactive-color\":null,\"active-value\":\"\'1\'\",\"inactive-value\":\"\'0\'\",\"__vModel__\":\"facebook_open\"}]}', '2022-01-22 15:48:59', '2022-02-11 18:08:19');
INSERT INTO `eb_system_form_temp` VALUES (145, 'Twitter(推特)', 'Twitter(推特)', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":180,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"Consumer Key\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"twitter_consumer_key\",\"placeholder\":\"请输入Twitter开发者平台申请的Consumer KeyConsumer Key\",\"style\":{\"width\":\"90%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"\",\"show-word-limit\":true,\"readonly\":false,\"disabled\":false},{\"__config__\":{\"label\":\"Consumer Secret\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":101,\"renderKey\":1642837917797},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入Twitter开发者平台申请的Consumer SecretConsumer SecretConsumer Secret\",\"style\":{\"width\":\"90%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"twitter_consumer_secret\"},{\"__config__\":{\"label\":\"PC Login Callback\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":101,\"renderKey\":1704509741132},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入Twitter开发者平台申请的LRUPC Login Callback PC Login CallbackPC Login Callback\",\"style\":{\"width\":\"90%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"twitter_pc_callback_url\"},{\"__config__\":{\"label\":\"H5 Login Callback\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":102,\"renderKey\":1704509741874},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入Twitter开发者平台申请的H5 Login CallbackH5 Login CallbackH5 Login Callback\",\"style\":{\"width\":\"90%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"twitter_h5_callback_url\"},{\"__config__\":{\"label\":\"开启\",\"tag\":\"el-switch\",\"tagIcon\":\"switch\",\"defaultValue\":\"\'0\'\",\"span\":24,\"showLabel\":true,\"labelWidth\":null,\"layout\":\"colFormItem\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/switch\",\"formId\":102,\"renderKey\":1642838172360},\"style\":{},\"disabled\":false,\"active-text\":\"\",\"inactive-text\":\"\",\"active-color\":null,\"inactive-color\":null,\"active-value\":\"\'1\'\",\"inactive-value\":\"\'0\'\",\"__vModel__\":\"twitter_open\"}]}', '2022-01-22 15:57:16', '2022-02-11 17:15:18');
INSERT INTO `eb_system_form_temp` VALUES (146, 'Goggle(谷歌)', 'Goggle(谷歌)', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":200,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"Google Client Id\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":101,\"renderKey\":1642838694372},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入Google Client Id\",\"style\":{\"width\":\"95%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"google_client_id\"},{\"__config__\":{\"label\":\"开启\",\"tag\":\"el-switch\",\"tagIcon\":\"switch\",\"defaultValue\":\"\'0\'\",\"span\":24,\"showLabel\":true,\"labelWidth\":null,\"layout\":\"colFormItem\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/switch\",\"formId\":102,\"renderKey\":1642838744686},\"style\":{},\"disabled\":false,\"active-text\":\"\",\"inactive-text\":\"\",\"active-color\":null,\"inactive-color\":null,\"active-value\":\"\'1\'\",\"inactive-value\":\"\'0\'\",\"__vModel__\":\"google_open\"}]}', '2022-01-22 16:06:18', '2022-02-11 17:29:32');
INSERT INTO `eb_system_form_temp` VALUES (147, 'Paypal支付', 'Paypal支付', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":120,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"Client Id\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":101,\"renderKey\":1642838898948},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入Client IdClient Id\",\"style\":{\"width\":\"95%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"paypal_client_id\"},{\"__config__\":{\"label\":\"Client Secret\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":102,\"renderKey\":1642839088119},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入Client SecretClient SecretClient SecretClient Secret\",\"style\":{\"width\":\"95%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"paypal_client_secret\"},{\"__config__\":{\"label\":\"mode\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-radio-group\",\"tagIcon\":\"radio\",\"changeTag\":true,\"layout\":\"colFormItem\",\"span\":24,\"optionType\":\"default\",\"regList\":[],\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"border\":false,\"document\":\"https://element.eleme.cn/#/zh-CN/component/radio\",\"formId\":102,\"renderKey\":1644980867602,\"defaultValue\":\"sandbox\"},\"__slot__\":{\"options\":[{\"label\":\"sandbox\",\"value\":\"sandbox\"},{\"label\":\"live\",\"value\":\"live\"}]},\"style\":{},\"size\":\"medium\",\"disabled\":false,\"__vModel__\":\"paypal_mode\"},{\"__config__\":{\"label\":\"Paypal开关\",\"tag\":\"el-switch\",\"tagIcon\":\"switch\",\"defaultValue\":\"\'0\'\",\"span\":24,\"showLabel\":true,\"labelWidth\":null,\"layout\":\"colFormItem\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/switch\",\"formId\":102,\"renderKey\":1654507345321},\"style\":{},\"disabled\":false,\"active-text\":\"\",\"inactive-text\":\"\",\"active-color\":null,\"inactive-color\":null,\"active-value\":\"\'1\'\",\"inactive-value\":\"\'0\'\",\"__vModel__\":\"paypal_switch\"}]}', '2022-01-22 16:12:48', '2022-06-09 11:18:27');
INSERT INTO `eb_system_form_temp` VALUES (148, '匿名下单', '匿名下单', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"匿名下单\",\"tag\":\"el-switch\",\"tagIcon\":\"switch\",\"defaultValue\":\"\'0\'\",\"span\":24,\"showLabel\":true,\"labelWidth\":null,\"layout\":\"colFormItem\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/switch\",\"formId\":101,\"renderKey\":1644575380561},\"style\":{},\"disabled\":false,\"active-text\":\"\",\"inactive-text\":\"\",\"active-color\":null,\"inactive-color\":null,\"active-value\":\"\'1\'\",\"inactive-value\":\"\'0\'\",\"__vModel__\":\"visitor_open\"}]}', '2022-02-11 18:30:13', '2022-06-09 11:16:22');
INSERT INTO `eb_system_form_temp` VALUES (151, '商户分类', '商户分类', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"分类名称\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"name\",\"placeholder\":\"请输入分类名称\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"el-icon-mobile\",\"suffix-icon\":\"\",\"maxlength\":11,\"show-word-limit\":true,\"readonly\":false,\"disabled\":false},{\"__config__\":{\"label\":\"手续费(%)\",\"showLabel\":true,\"changeTag\":true,\"labelWidth\":null,\"tag\":\"el-input-number\",\"tagIcon\":\"number\",\"span\":24,\"layout\":\"colFormItem\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"regList\":[],\"document\":\"https://element.eleme.cn/#/zh-CN/component/input-number\",\"formId\":101,\"renderKey\":1646879946357,\"defaultValue\":0},\"placeholder\":\"手续费(%)\",\"step\":1,\"step-strictly\":true,\"controls-position\":\"\",\"disabled\":false,\"__vModel__\":\"handlingFee\",\"min\":0,\"max\":100}]}', '2022-03-10 10:40:08', '2022-05-13 18:55:01');
INSERT INTO `eb_system_form_temp` VALUES (152, '店铺类型', '店铺类型', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":110,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":18,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"店铺类型\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":18,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":101,\"renderKey\":1646895171066},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入店铺类型\",\"style\":{\"width\":\"95%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"name\"},{\"__config__\":{\"label\":\"店铺类型要求\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-input\",\"tagIcon\":\"textarea\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":18,\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"formId\":104,\"renderKey\":1646895357761},\"type\":\"textarea\",\"placeholder\":\"请输入店铺类型要求\",\"autosize\":{\"minRows\":4,\"maxRows\":4},\"style\":{\"width\":\"95%\"},\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"info\"}]}', '2022-03-10 14:57:59', '2022-04-27 14:52:52');
INSERT INTO `eb_system_form_temp` VALUES (153, '修改商户密码', '修改商户密码', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"密码\",\"showLabel\":true,\"labelWidth\":null,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"password\",\"layout\":\"colFormItem\",\"span\":24,\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"regList\":[],\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"formId\":114,\"renderKey\":1646986639692,\"defaultValue\":\"\"},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入密码\",\"show-password\":true,\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"newPassword\"},{\"__config__\":{\"label\":\"确认密码\",\"showLabel\":true,\"labelWidth\":null,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"password\",\"layout\":\"colFormItem\",\"span\":24,\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"regList\":[],\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"formId\":113,\"renderKey\":1646986633094,\"defaultValue\":\"\"},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入确认密码\",\"show-password\":true,\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"passwordAgain\"}]}', '2022-03-11 16:18:33', '2022-03-11 16:18:33');
INSERT INTO `eb_system_form_temp` VALUES (154, '修改复制商品数量', '修改复制商品数量', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":10,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"复制次数\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":false,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":10,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":101,\"renderKey\":1646991510381},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入复制次数\",\"style\":{\"width\":\"95%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":true,\"__vModel__\":\"copyProductNum\"},{\"__config__\":{\"label\":\"修改类型\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-radio-group\",\"tagIcon\":\"radio\",\"changeTag\":true,\"layout\":\"colFormItem\",\"span\":24,\"optionType\":\"default\",\"regList\":[],\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"border\":false,\"document\":\"https://element.eleme.cn/#/zh-CN/component/radio\",\"formId\":102,\"renderKey\":1646991528364,\"defaultValue\":\"add\"},\"__slot__\":{\"options\":[{\"label\":\"增加\",\"value\":\"add\"},{\"label\":\"减少\",\"value\":\"sub\"}]},\"style\":{},\"size\":\"medium\",\"disabled\":false,\"__vModel__\":\"type\"},{\"__config__\":{\"label\":\"修改数量\",\"showLabel\":true,\"changeTag\":true,\"labelWidth\":null,\"tag\":\"el-input-number\",\"tagIcon\":\"number\",\"span\":24,\"layout\":\"colFormItem\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"regList\":[],\"document\":\"https://element.eleme.cn/#/zh-CN/component/input-number\",\"formId\":103,\"renderKey\":1646991546233},\"placeholder\":\"修改数量\",\"step\":1,\"step-strictly\":false,\"controls-position\":\"\",\"disabled\":false,\"__vModel__\":\"num\",\"min\":0,\"max\":9999}]}', '2022-03-11 17:41:18', '2022-05-14 15:36:00');
INSERT INTO `eb_system_form_temp` VALUES (155, '添加服务条款', '添加服务条款', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":110,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"服务条款\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":101,\"renderKey\":1647230988327},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入服务条款\",\"style\":{\"width\":\"95%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"name\"},{\"__config__\":{\"label\":\"服务内容描述\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-input\",\"tagIcon\":\"textarea\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"formId\":102,\"renderKey\":1647231011480},\"type\":\"textarea\",\"placeholder\":\"请输入服务内容描述\",\"autosize\":{\"minRows\":4,\"maxRows\":4},\"style\":{\"width\":\"95%\"},\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"content\"},{\"__config__\":{\"label\":\"服务条款图标(100*100px)\",\"tag\":\"self-upload\",\"tagIcon\":\"selfUpload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":null,\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"span\":24,\"showTip\":false,\"buttonText\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":103,\"renderKey\":1647231714586},\"__slot__\":{\"list-type\":true},\"disabled\":true,\"accept\":\"image\",\"name\":\"file\",\"multiple\":false,\"__vModel__\":\"icon\"},{\"__config__\":{\"label\":\"排序\",\"showLabel\":true,\"changeTag\":true,\"labelWidth\":null,\"tag\":\"el-input-number\",\"tagIcon\":\"number\",\"span\":24,\"layout\":\"colFormItem\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"regList\":[],\"document\":\"https://element.eleme.cn/#/zh-CN/component/input-number\",\"formId\":104,\"renderKey\":1647231749284,\"defaultValue\":0},\"placeholder\":\"排序\",\"step\":1,\"step-strictly\":false,\"controls-position\":\"\",\"disabled\":false,\"__vModel__\":\"sort\",\"min\":0,\"max\":99999}]}', '2022-03-14 12:23:03', '2022-05-17 15:55:23');
INSERT INTO `eb_system_form_temp` VALUES (156, '虚拟销量', '虚拟销量', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":120,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":10,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"现有虚拟销量\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":false,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":10,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":105,\"renderKey\":1647489084443,\"defaultValue\":\"\"},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入现有虚拟销量\",\"style\":{\"width\":\"95%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":true,\"__vModel__\":\"ficti\"},{\"__config__\":{\"label\":\"修改类型\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-radio-group\",\"tagIcon\":\"radio\",\"changeTag\":true,\"layout\":\"colFormItem\",\"span\":24,\"optionType\":\"default\",\"regList\":[],\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"border\":false,\"document\":\"https://element.eleme.cn/#/zh-CN/component/radio\",\"formId\":102,\"renderKey\":1647317130950,\"defaultValue\":\"add\"},\"__slot__\":{\"options\":[{\"label\":\"增加\",\"value\":\"add\"},{\"label\":\"减少\",\"value\":\"sub\"}]},\"style\":{},\"size\":\"medium\",\"disabled\":false,\"__vModel__\":\"type\"},{\"__config__\":{\"label\":\"修改虚拟销量数\",\"showLabel\":true,\"changeTag\":true,\"labelWidth\":null,\"tag\":\"el-input-number\",\"tagIcon\":\"number\",\"span\":24,\"layout\":\"colFormItem\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"regList\":[],\"document\":\"https://element.eleme.cn/#/zh-CN/component/input-number\",\"formId\":101,\"renderKey\":1647317126714,\"defaultValue\":0},\"placeholder\":\"修改虚拟销量数\",\"step\":1,\"step-strictly\":false,\"controls-position\":\"\",\"disabled\":false,\"__vModel__\":\"num\",\"min\":0,\"max\":99999}]}', '2022-03-15 12:07:54', '2022-05-17 15:18:01');
INSERT INTO `eb_system_form_temp` VALUES (157, '店铺配置', '店铺配置', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":150,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\" 商户     主头像     （90*90 px）\",\"tag\":\"self-upload\",\"tagIcon\":\"selfUpload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":null,\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"span\":24,\"showTip\":false,\"buttonText\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":114,\"renderKey\":1650619545531},\"__slot__\":{\"list-type\":true},\"disabled\":true,\"accept\":\"image\",\"name\":\"file\",\"multiple\":false,\"__vModel__\":\"avatar\"},{\"__config__\":{\"label\":\" 移动端商户背景图（375*180 px）\",\"tag\":\"self-upload\",\"tagIcon\":\"selfUpload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":null,\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"span\":24,\"showTip\":false,\"buttonText\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":116,\"renderKey\":1650619559395},\"__slot__\":{\"list-type\":true},\"disabled\":true,\"accept\":\"image\",\"name\":\"file\",\"multiple\":false,\"__vModel__\":\"backImage\"},{\"__config__\":{\"label\":\"移动端商户街背景图（355*78 px）\",\"tag\":\"self-upload\",\"tagIcon\":\"selfUpload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":null,\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"span\":24,\"showTip\":false,\"buttonText\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":115,\"renderKey\":1650619557080},\"__slot__\":{\"list-type\":true},\"disabled\":true,\"accept\":\"image\",\"name\":\"file\",\"multiple\":false,\"__vModel__\":\"streetBackImage\"},{\"__config__\":{\"label\":\"pc端 商户背景图 （1200 *180 px）\",\"tag\":\"self-upload\",\"tagIcon\":\"selfUpload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":null,\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"span\":24,\"showTip\":false,\"buttonText\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":101,\"renderKey\":1654743072224},\"__slot__\":{\"list-type\":true},\"disabled\":true,\"accept\":\"image\",\"name\":\"file\",\"multiple\":false,\"__vModel__\":\"pcBackImage\"},{\"__config__\":{\"label\":\"pc端 商户轮播图 （1200*340 px）\",\"tag\":\"self-upload\",\"tagIcon\":\"selfUpload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":null,\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"span\":24,\"showTip\":false,\"buttonText\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":102,\"renderKey\":1654745345193},\"__slot__\":{\"list-type\":true},\"disabled\":true,\"accept\":\"image\",\"name\":\"file\",\"multiple\":true,\"__vModel__\":\"pcBanner\"},{\"__config__\":{\"label\":\"商户地址\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":111,\"renderKey\":1649237041964},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入商户地址\",\"style\":{\"width\":\"40%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"address\"},{\"__config__\":{\"label\":\"商户简介\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":112,\"renderKey\":1649237091405},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入商户简介\",\"style\":{\"width\":\"40%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"intro\"},{\"__config__\":{\"label\":\"商户关键字\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":false,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":113,\"renderKey\":1649237128115},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入商户关键字\",\"style\":{\"width\":\"40%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"keywords\"},{\"__config__\":{\"label\":\"商户电话\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":117,\"renderKey\":1650619756125},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入商户电话\",\"style\":{\"width\":\"40%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"phone\"},{\"__config__\":{\"label\":\"警戒库存\",\"showLabel\":true,\"changeTag\":true,\"labelWidth\":null,\"tag\":\"el-input-number\",\"tagIcon\":\"number\",\"span\":24,\"layout\":\"colFormItem\",\"required\":true,\"tips\":true,\"tipsDesc\":\"设置商品的警戒库存\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"regList\":[],\"document\":\"https://element.eleme.cn/#/zh-CN/component/input-number\",\"formId\":103,\"renderKey\":1648454702884,\"defaultValue\":0},\"placeholder\":\"警戒库存\",\"step\":1,\"step-strictly\":false,\"controls-position\":\"\",\"disabled\":false,\"__vModel__\":\"alertStock\"},{\"__config__\":{\"label\":\"客服方式\",\"showLabel\":true,\"labelWidth\":null,\"tag\":\"el-select\",\"tagIcon\":\"select\",\"layout\":\"colFormItem\",\"span\":24,\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/select\",\"formId\":102,\"renderKey\":1648455695237,\"defaultValue\":\"云智服\"},\"__slot__\":{\"options\":[{\"label\":\"云智服\",\"value\":\"H5\"},{\"label\":\"电话\",\"value\":\"phone\"},{\"label\":\"Message\",\"value\":\"message\"},{\"label\":\"邮件\",\"value\":\"email\"}]},\"placeholder\":\"请选择客服方式客服方式\",\"style\":{\"width\":\"40%\"},\"clearable\":true,\"disabled\":false,\"filterable\":false,\"multiple\":false,\"__vModel__\":\"serviceType\"},{\"__config__\":{\"label\":\"客服H5链接\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":false,\"tips\":false,\"tipsDesc\":\"点击查看详细\",\"tipsIsLink\":true,\"tipsLink\":\"http://help.crmeb.net/crmeb_java/2322225\",\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":103,\"renderKey\":1648455799280},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入客服H5链接\",\"style\":{\"width\":\"40%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"serviceLink\"},{\"__config__\":{\"label\":\"客服电话\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[{\"pattern\":\"/^[^\\\\u4e00-\\\\u9fa5]+$/\",\"message\":\"请输入正确的客服电话\"}],\"formId\":104,\"renderKey\":1648455812417,\"defaultValue\":\"\"},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入客服电话\",\"style\":{\"width\":\"40%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"servicePhone\"},{\"__config__\":{\"label\":\"Message\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":105,\"renderKey\":1648455834488},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入Message\",\"style\":{\"width\":\"40%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"serviceMessage\"},{\"__config__\":{\"label\":\"客服邮箱\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":false,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[{\"pattern\":\"/^([a-zA-Z\\\\d])(\\\\w|\\\\-)+@[a-zA-Z\\\\d]+\\\\.[a-zA-Z]{2,4}$/\",\"message\":\"请输入正确的邮箱地址\"}],\"formId\":106,\"renderKey\":1648455843696,\"defaultValue\":\"588888888888\"},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入客服邮箱\",\"style\":{\"width\":\"40%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"serviceEmail\"}]}', '2022-03-28 16:16:02', '2022-06-09 11:30:37');
INSERT INTO `eb_system_form_temp` VALUES (158, '转账信息', '转账信息', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":24,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"转账类型\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-radio-group\",\"tagIcon\":\"radio\",\"changeTag\":true,\"layout\":\"colFormItem\",\"span\":24,\"optionType\":\"default\",\"regList\":[],\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"border\":false,\"document\":\"https://element.eleme.cn/#/zh-CN/component/radio\",\"formId\":101,\"renderKey\":1649246410301,\"defaultValue\":\"bank\"},\"__slot__\":{\"options\":[{\"label\":\"银行卡\",\"value\":\"bank\"}]},\"style\":{},\"size\":\"medium\",\"disabled\":false,\"__vModel__\":\"transferType\"},{\"__config__\":{\"label\":\"姓名\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":102,\"renderKey\":1649246483051},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入姓名\",\"style\":{\"width\":\"50%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"transferName\"},{\"__config__\":{\"label\":\"开户银行\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":103,\"renderKey\":1649246483883},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入开户银行\",\"style\":{\"width\":\"50%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"transferBank\"},{\"__config__\":{\"label\":\"银行卡号\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":104,\"renderKey\":1649246604188},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入银行卡号\",\"style\":{\"width\":\"50%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"30\",\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"transferBankCard\"}]}', '2022-04-06 20:05:17', '2022-05-14 10:45:31');
INSERT INTO `eb_system_form_temp` VALUES (159, '转账设置', '转账设置', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":200,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"商户保证金额\",\"showLabel\":true,\"changeTag\":true,\"labelWidth\":null,\"tag\":\"el-input-number\",\"tagIcon\":\"number\",\"span\":24,\"layout\":\"colFormItem\",\"required\":true,\"tips\":true,\"tipsDesc\":\"指商户的余额至少大于该金额部分，才可以转账，设置为0时默认商户余额可以全部转账\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"regList\":[],\"document\":\"https://element.eleme.cn/#/zh-CN/component/input-number\",\"formId\":101,\"renderKey\":1649381945392,\"defaultValue\":999999},\"placeholder\":\"商户保证金额\",\"step\":1,\"step-strictly\":false,\"controls-position\":\"\",\"disabled\":false,\"__vModel__\":\"guaranteedAmount\",\"min\":0,\"precision\":2,\"max\":999999},{\"__config__\":{\"label\":\"商户每笔最小转账额度\",\"showLabel\":true,\"changeTag\":true,\"labelWidth\":null,\"tag\":\"el-input-number\",\"tagIcon\":\"number\",\"span\":24,\"layout\":\"colFormItem\",\"required\":true,\"tips\":true,\"tipsDesc\":\"指商户的每次申请转账最小的金额；设置为0时默认不限制最小额度\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"regList\":[],\"document\":\"https://element.eleme.cn/#/zh-CN/component/input-number\",\"formId\":102,\"renderKey\":1649381946440},\"placeholder\":\"商户每笔最小转账额度\",\"step\":1,\"step-strictly\":false,\"controls-position\":\"\",\"disabled\":false,\"__vModel__\":\"transferMinAmount\",\"min\":0,\"precision\":2,\"max\":999999},{\"__config__\":{\"label\":\"商户每笔最高转账额度\",\"showLabel\":true,\"changeTag\":true,\"labelWidth\":null,\"tag\":\"el-input-number\",\"tagIcon\":\"number\",\"span\":24,\"layout\":\"colFormItem\",\"required\":true,\"tips\":true,\"tipsDesc\":\"商户每次转账申请的最高额度，设置0时默认不限制\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"regList\":[],\"document\":\"https://element.eleme.cn/#/zh-CN/component/input-number\",\"formId\":103,\"renderKey\":1649381946840},\"placeholder\":\"商户每笔最高转账额度\",\"step\":1,\"step-strictly\":false,\"controls-position\":\"\",\"disabled\":false,\"__vModel__\":\"transferMaxAmount\",\"min\":0,\"precision\":2,\"max\":999999}]}', '2022-04-08 09:47:17', '2022-05-14 10:45:18');
INSERT INTO `eb_system_form_temp` VALUES (160, '商品排序', '商品排序', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"排序\",\"showLabel\":true,\"changeTag\":true,\"labelWidth\":null,\"tag\":\"el-input-number\",\"tagIcon\":\"number\",\"span\":24,\"layout\":\"colFormItem\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"regList\":[],\"document\":\"https://element.eleme.cn/#/zh-CN/component/input-number\",\"formId\":101,\"renderKey\":1650787971375,\"defaultValue\":0},\"placeholder\":\"排序\",\"step\":1,\"step-strictly\":false,\"controls-position\":\"\",\"disabled\":false,\"__vModel__\":\"rank\",\"min\":0,\"max\":9999}]}', '2022-04-24 16:13:32', '2022-04-24 16:13:32');
INSERT INTO `eb_system_form_temp` VALUES (161, '店铺街', '店铺街', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"封面图\",\"tag\":\"self-upload\",\"tagIcon\":\"selfUpload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":null,\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"span\":24,\"showTip\":false,\"buttonText\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":101,\"renderKey\":1651730633716},\"__slot__\":{\"list-type\":true},\"disabled\":true,\"accept\":\"image\",\"name\":\"file\",\"multiple\":false,\"__vModel__\":\"pic\"}]}', '2022-05-05 14:04:37', '2022-05-05 18:32:43');
INSERT INTO `eb_system_form_temp` VALUES (162, 'PC首页Banner', 'PC首页Banner', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"PC首页Banner\",\"tag\":\"self-upload\",\"tagIcon\":\"selfUpload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":150,\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"span\":24,\"showTip\":false,\"buttonText\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":101,\"renderKey\":1653297265618},\"__slot__\":{\"list-type\":true},\"disabled\":true,\"accept\":\"image\",\"name\":\"file\",\"multiple\":false,\"__vModel__\":\"pic\"}]}', '2022-05-23 17:19:00', '2022-05-23 17:23:21');
INSERT INTO `eb_system_form_temp` VALUES (163, 'PC商城配置', 'PC商城配置', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"首页推荐商品竖图\",\"tag\":\"self-upload\",\"tagIcon\":\"selfUpload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":200,\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"span\":24,\"showTip\":false,\"buttonText\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":101,\"renderKey\":1653298547907},\"__slot__\":{\"list-type\":true},\"disabled\":true,\"accept\":\"image\",\"name\":\"file\",\"multiple\":false,\"__vModel__\":\"pc_home_recommend_image\"},{\"__config__\":{\"label\":\"店铺街头图\",\"tag\":\"self-upload\",\"tagIcon\":\"selfUpload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":200,\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"span\":24,\"showTip\":false,\"buttonText\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":101,\"renderKey\":1653299373101},\"__slot__\":{\"list-type\":true},\"disabled\":true,\"accept\":\"image\",\"name\":\"file\",\"multiple\":false,\"__vModel__\":\"pc_shop_street_header_image\"},{\"__config__\":{\"label\":\"顶部logo图标\",\"tag\":\"self-upload\",\"tagIcon\":\"selfUpload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":200,\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"span\":24,\"showTip\":false,\"buttonText\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":101,\"renderKey\":1653299856936},\"__slot__\":{\"list-type\":true},\"disabled\":true,\"accept\":\"image\",\"name\":\"file\",\"multiple\":false,\"__vModel__\":\"pc_top_logo\"},{\"__config__\":{\"label\":\"PC登录页左侧展示图\",\"tag\":\"self-upload\",\"tagIcon\":\"selfUpload\",\"layout\":\"colFormItem\",\"defaultValue\":null,\"showLabel\":true,\"labelWidth\":200,\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"span\":24,\"showTip\":false,\"buttonText\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/upload\",\"formId\":101,\"renderKey\":1653300230954},\"__slot__\":{\"list-type\":true},\"disabled\":true,\"accept\":\"image\",\"name\":\"file\",\"multiple\":false,\"__vModel__\":\"pc_login_left_image\"}]}', '2022-05-23 17:40:09', '2022-06-10 10:27:17');
INSERT INTO `eb_system_form_temp` VALUES (164, 'Stripe支付', 'Stripe支付', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"apiKey\",\"labelWidth\":120,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"tips\":false},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"__vModel__\":\"stripe_api_key\",\"placeholder\":\"请输入apiKeyapiKey\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"el-icon-mobile\",\"suffix-icon\":\"\",\"maxlength\":\"255\",\"show-word-limit\":true,\"readonly\":false,\"disabled\":false},{\"__config__\":{\"label\":\"Stripe开关\",\"tag\":\"el-switch\",\"tagIcon\":\"switch\",\"defaultValue\":\"\'0\'\",\"span\":24,\"showLabel\":true,\"labelWidth\":120,\"layout\":\"colFormItem\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/switch\",\"formId\":103,\"renderKey\":1654507754350},\"style\":{},\"disabled\":false,\"active-text\":\"\",\"inactive-text\":\"\",\"active-color\":null,\"inactive-color\":null,\"active-value\":\"\'1\'\",\"inactive-value\":\"\'0\'\",\"__vModel__\":\"stripe_switch\"}]}', '2022-06-06 17:30:37', '2022-06-09 11:16:50');
INSERT INTO `eb_system_form_temp` VALUES (165, '微信支付', '微信支付', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"微信支付开关\",\"tag\":\"el-switch\",\"tagIcon\":\"switch\",\"defaultValue\":\"\'0\'\",\"span\":24,\"showLabel\":true,\"labelWidth\":150,\"layout\":\"colFormItem\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/switch\",\"formId\":101,\"renderKey\":1691373475708},\"style\":{},\"disabled\":false,\"active-text\":\"\",\"inactive-text\":\"\",\"active-color\":null,\"inactive-color\":null,\"active-value\":\"\'1\'\",\"inactive-value\":\"\'0\'\",\"__vModel__\":\"wechat_pay_switch\"}]}', '2023-08-07 09:59:04', '2023-08-07 09:59:04');
INSERT INTO `eb_system_form_temp` VALUES (166, 'communityClassification', '社区分类创建编辑', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"分类名称：\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":102,\"renderKey\":1743670499864},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入分类名称\",\"style\":{\"width\":\"95%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":null,\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"name\"},{\"__config__\":{\"label\":\"是否显示\",\"tag\":\"el-switch\",\"tagIcon\":\"switch\",\"defaultValue\":1,\"span\":24,\"showLabel\":true,\"labelWidth\":null,\"layout\":\"colFormItem\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"regList\":[],\"changeTag\":true,\"document\":\"https://element.eleme.cn/#/zh-CN/component/switch\",\"formId\":101,\"renderKey\":1743670445850},\"style\":{},\"disabled\":false,\"active-text\":\"\",\"inactive-text\":\"\",\"active-color\":null,\"inactive-color\":null,\"active-value\":1,\"inactive-value\":0,\"__vModel__\":\"isShow\"},{\"__config__\":{\"label\":\"排序：\",\"showLabel\":true,\"changeTag\":true,\"labelWidth\":null,\"tag\":\"el-input-number\",\"tagIcon\":\"number\",\"span\":24,\"layout\":\"colFormItem\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"regList\":[],\"document\":\"https://element.eleme.cn/#/zh-CN/component/input-number\",\"formId\":103,\"renderKey\":1743670563213},\"placeholder\":\"排序\",\"step\":1,\"step-strictly\":false,\"controls-position\":\"\",\"disabled\":false,\"__vModel__\":\"sort\"}]}', '2025-04-03 16:56:35', '2025-04-16 14:44:40');
INSERT INTO `eb_system_form_temp` VALUES (167, 'communityTopics', '社区话题新增编辑', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"small\",\"labelPosition\":\"right\",\"labelWidth\":100,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"话题名称：\",\"labelWidth\":null,\"showLabel\":true,\"changeTag\":true,\"tag\":\"el-input\",\"tagIcon\":\"input\",\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"layout\":\"colFormItem\",\"span\":24,\"document\":\"https://element.eleme.cn/#/zh-CN/component/input\",\"regList\":[],\"formId\":101,\"renderKey\":1678248608433},\"__slot__\":{\"prepend\":\"\",\"append\":\"\"},\"placeholder\":\"请输入话题名称\",\"style\":{\"width\":\"100%\"},\"clearable\":true,\"prefix-icon\":\"\",\"suffix-icon\":\"\",\"maxlength\":\"10\",\"show-word-limit\":false,\"readonly\":false,\"disabled\":false,\"__vModel__\":\"name\"}]}', '2025-04-03 17:00:22', '2025-04-15 16:00:34');
INSERT INTO `eb_system_form_temp` VALUES (168, 'communityConfig', '社区配置', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":120,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"图文审核：\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-radio-group\",\"tagIcon\":\"radio\",\"changeTag\":true,\"layout\":\"colFormItem\",\"span\":24,\"optionType\":\"default\",\"regList\":[],\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"border\":false,\"document\":\"https://element.eleme.cn/#/zh-CN/component/radio\",\"formId\":101,\"renderKey\":1744172414477,\"defaultValue\":0},\"__slot__\":{\"options\":[{\"label\":\"开启\",\"value\":1},{\"label\":\"关闭\",\"value\":0}]},\"style\":{},\"size\":\"medium\",\"disabled\":false,\"__vModel__\":\"communityImageTextAuditSwitch\"},{\"__config__\":{\"label\":\"短视频审核：\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-radio-group\",\"tagIcon\":\"radio\",\"changeTag\":true,\"layout\":\"colFormItem\",\"span\":24,\"optionType\":\"default\",\"regList\":[],\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"border\":false,\"document\":\"https://element.eleme.cn/#/zh-CN/component/radio\",\"formId\":102,\"renderKey\":1744172414844,\"defaultValue\":0},\"__slot__\":{\"options\":[{\"label\":\"开启\",\"value\":1},{\"label\":\"关闭\",\"value\":0}]},\"style\":{},\"size\":\"medium\",\"disabled\":false,\"__vModel__\":\"communityShortVideoAuditSwitch\"},{\"__config__\":{\"label\":\"社区评论：\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-radio-group\",\"tagIcon\":\"radio\",\"changeTag\":true,\"layout\":\"colFormItem\",\"span\":24,\"optionType\":\"default\",\"regList\":[],\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"border\":false,\"document\":\"https://element.eleme.cn/#/zh-CN/component/radio\",\"formId\":103,\"renderKey\":1744172415138,\"defaultValue\":1},\"__slot__\":{\"options\":[{\"label\":\"开启\",\"value\":1},{\"label\":\"关闭\",\"value\":0}]},\"style\":{},\"size\":\"medium\",\"disabled\":false,\"__vModel__\":\"communityReplySwitch\"},{\"__config__\":{\"label\":\"评论审核：\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-radio-group\",\"tagIcon\":\"radio\",\"changeTag\":true,\"layout\":\"colFormItem\",\"span\":24,\"optionType\":\"default\",\"regList\":[],\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"border\":false,\"document\":\"https://element.eleme.cn/#/zh-CN/component/radio\",\"formId\":104,\"renderKey\":1744172415401,\"defaultValue\":0},\"__slot__\":{\"options\":[{\"label\":\"开启\",\"value\":1},{\"label\":\"关闭\",\"value\":0}]},\"style\":{},\"size\":\"medium\",\"disabled\":false,\"__vModel__\":\"communityReplyAuditSwitch\"}]}', '2025-04-09 14:09:29', '2025-04-09 14:17:25');
INSERT INTO `eb_system_form_temp` VALUES (169, 'communityConfig', '社区配置', '{\"formRef\":\"elForm\",\"formModel\":\"formData\",\"size\":\"medium\",\"labelPosition\":\"right\",\"labelWidth\":120,\"formRules\":\"rules\",\"gutter\":15,\"disabled\":false,\"span\":24,\"formBtns\":true,\"fields\":[{\"__config__\":{\"label\":\"图文审核：\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-radio-group\",\"tagIcon\":\"radio\",\"changeTag\":true,\"layout\":\"colFormItem\",\"span\":24,\"optionType\":\"default\",\"regList\":[],\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"border\":false,\"document\":\"https://element.eleme.cn/#/zh-CN/component/radio\",\"formId\":101,\"renderKey\":1744172414477,\"defaultValue\":0},\"__slot__\":{\"options\":[{\"label\":\"选项一\",\"value\":1},{\"label\":\"选项二\",\"value\":0}]},\"style\":{},\"size\":\"medium\",\"disabled\":false,\"__vModel__\":\"communityImageTextAuditSwitch\"},{\"__config__\":{\"label\":\"短视频审核：\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-radio-group\",\"tagIcon\":\"radio\",\"changeTag\":true,\"layout\":\"colFormItem\",\"span\":24,\"optionType\":\"default\",\"regList\":[],\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"border\":false,\"document\":\"https://element.eleme.cn/#/zh-CN/component/radio\",\"formId\":102,\"renderKey\":1744172414844,\"defaultValue\":0},\"__slot__\":{\"options\":[{\"label\":\"选项一\",\"value\":1},{\"label\":\"选项二\",\"value\":0}]},\"style\":{},\"size\":\"medium\",\"disabled\":false,\"__vModel__\":\"communityShortVideoAuditSwitch\"},{\"__config__\":{\"label\":\"社区评论：\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-radio-group\",\"tagIcon\":\"radio\",\"changeTag\":true,\"layout\":\"colFormItem\",\"span\":24,\"optionType\":\"default\",\"regList\":[],\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"border\":false,\"document\":\"https://element.eleme.cn/#/zh-CN/component/radio\",\"formId\":103,\"renderKey\":1744172415138,\"defaultValue\":1},\"__slot__\":{\"options\":[{\"label\":\"选项一\",\"value\":1},{\"label\":\"选项二\",\"value\":0}]},\"style\":{},\"size\":\"medium\",\"disabled\":false,\"__vModel__\":\"communityShortVideoAuditSwitch\"},{\"__config__\":{\"label\":\"评论审核：\",\"labelWidth\":null,\"showLabel\":true,\"tag\":\"el-radio-group\",\"tagIcon\":\"radio\",\"changeTag\":true,\"layout\":\"colFormItem\",\"span\":24,\"optionType\":\"default\",\"regList\":[],\"required\":true,\"tips\":false,\"tipsDesc\":\"\",\"tipsIsLink\":false,\"tipsLink\":\"\",\"border\":false,\"document\":\"https://element.eleme.cn/#/zh-CN/component/radio\",\"formId\":104,\"renderKey\":1744172415401,\"defaultValue\":0},\"__slot__\":{\"options\":[{\"label\":\"选项一\",\"value\":1},{\"label\":\"选项二\",\"value\":0}]},\"style\":{},\"size\":\"medium\",\"disabled\":false,\"__vModel__\":\"communityReplyAuditSwitch\"}]}', '2025-04-09 14:09:29', '2025-04-09 14:09:29');

-- ----------------------------
-- Table structure for eb_system_group
-- ----------------------------
DROP TABLE IF EXISTS `eb_system_group`;
CREATE TABLE `eb_system_group`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '组合数据ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '数据组名称',
  `info` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '简介',
  `form_id` int(11) NOT NULL DEFAULT 0 COMMENT 'form 表单 id',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '组合数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_system_group
-- ----------------------------
INSERT INTO `eb_system_group` VALUES (1, '移动端_首页中部推荐banner图', '移动端_首页中部推荐banner图', 95, '2020-05-15 10:38:22', '2021-02-24 18:24:35');
INSERT INTO `eb_system_group` VALUES (2, '移动端_首页banner滚动图', '移动端_首页banner滚动图', 95, '2020-05-15 10:38:22', '2021-02-24 18:24:06');
INSERT INTO `eb_system_group` VALUES (3, '移动端_订单详情状态图', '移动端_订单详情状态图', 115, '2020-05-15 10:38:22', '2021-02-24 18:23:25');
INSERT INTO `eb_system_group` VALUES (4, '移动端_个人中心功能菜单', '移动端_个人中心功能菜单', 89, '2020-05-15 10:38:22', '2021-02-24 18:22:22');
INSERT INTO `eb_system_group` VALUES (5, '移动端_个人中心轮播图', '移动端_个人中心轮播图', 90, '2020-06-02 10:25:03', '2021-02-24 17:38:12');
INSERT INTO `eb_system_group` VALUES (6, '移动端_首页导航', '移动端_首页导航', 96, '2020-06-02 14:54:41', '2021-02-24 17:37:59');
INSERT INTO `eb_system_group` VALUES (7, '移动端_首页滚动新闻_二期配置', '移动端_首页滚动新闻_二期配置', 97, '2020-06-02 18:00:47', '2021-02-24 18:08:45');
INSERT INTO `eb_system_group` VALUES (8, '移动端_热门搜索', '移动端_热门搜索', 102, '2020-06-03 11:34:42', '2021-02-24 16:43:36');
INSERT INTO `eb_system_group` VALUES (9, '平台管理端_登录页轮播图', '平台管理端_登录页轮播图', 114, '2020-07-29 18:16:11', '2022-05-07 16:37:53');
INSERT INTO `eb_system_group` VALUES (10, '移动端_店铺街', '移动端_店铺街、商品排行入口', 161, '2022-05-05 14:05:35', '2022-05-05 14:05:35');
INSERT INTO `eb_system_group` VALUES (11, 'PC_首页_Banner', 'PC_首页_Banner', 162, '2022-05-23 17:19:39', '2022-05-23 17:19:39');

-- ----------------------------
-- Table structure for eb_system_group_data
-- ----------------------------
DROP TABLE IF EXISTS `eb_system_group_data`;
CREATE TABLE `eb_system_group_data`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '组合数据详情ID',
  `gid` int(11) NOT NULL DEFAULT 0 COMMENT '对应的数据组id',
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '数据组对应的数据值（json数据）',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '数据排序',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态（1：开启；2：关闭；）',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 581 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '组合数据详情表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_system_group_data
-- ----------------------------
INSERT INTO `eb_system_group_data` VALUES (1, 1, '{\"fields\":[{\"name\":\"name\",\"title\":\"name\",\"value\":\"精品推荐\"},{\"name\":\"url\",\"title\":\"url\",\"value\":\"#\"},{\"name\":\"pic\",\"title\":\"pic\",\"value\":\"crmebimage/public/product/2022/06/18/df6214011a2f4683b1b5feab362f0d882pneycevbh.jpg\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"1\"}],\"id\":95,\"sort\":1,\"status\":true}', 1, 1, '2020-08-13 12:34:52', '2022-06-18 15:46:23');
INSERT INTO `eb_system_group_data` VALUES (2, 1, '{\"fields\":[{\"name\":\"name\",\"title\":\"name\",\"value\":\"BANNER\"},{\"name\":\"url\",\"title\":\"url\",\"value\":\"#\"},{\"name\":\"pic\",\"title\":\"pic\",\"value\":\"crmebimage/public/product/2022/06/18/b2d29d1bf4394e24985ce5fa3770b2f2uqqytv1paq.jpg\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"2\"}],\"id\":95,\"sort\":2,\"status\":true}', 2, 1, '2020-08-13 12:41:15', '2022-06-18 15:47:10');
INSERT INTO `eb_system_group_data` VALUES (3, 1, '{\"fields\":[{\"name\":\"name\",\"title\":\"name\",\"value\":\"广告\"},{\"name\":\"url\",\"title\":\"url\",\"value\":\"#\"},{\"name\":\"pic\",\"title\":\"pic\",\"value\":\"crmebimage/public/product/2022/06/18/825310b0a5ad4abf9a8484c616e992c9m4jdeyzrz6.jpg\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"3\"}],\"id\":95,\"sort\":1,\"status\":true}', 1, 1, '2021-06-03 12:20:13', '2022-06-18 15:47:05');
INSERT INTO `eb_system_group_data` VALUES (8, 3, '{\"fields\":[{\"name\":\"orderStatus\",\"title\":\"orderStatus\",\"value\":\"0\"},{\"name\":\"image\",\"title\":\"image\",\"value\":\"crmebimage/public/product/2022/06/18/8d3e31140c6d4f9683edbd2d333e462fl3td6skp2w.gif\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"8\"}],\"id\":115,\"sort\":1,\"status\":true}', 1, 1, '2020-07-29 19:59:14', '2022-06-18 15:39:04');
INSERT INTO `eb_system_group_data` VALUES (9, 3, '{\"fields\":[{\"name\":\"orderStatus\",\"title\":\"orderStatus\",\"value\":\"1\"},{\"name\":\"image\",\"title\":\"image\",\"value\":\"crmebimage/public/product/2022/06/18/8d3e31140c6d4f9683edbd2d333e462fl3td6skp2w.gif\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"9\"}],\"id\":115,\"sort\":1,\"status\":true}', 1, 1, '2020-07-29 19:59:29', '2022-06-18 15:39:52');
INSERT INTO `eb_system_group_data` VALUES (10, 3, '{\"fields\":[{\"name\":\"orderStatus\",\"title\":\"orderStatus\",\"value\":\"2\"},{\"name\":\"image\",\"title\":\"image\",\"value\":\"crmebimage/public/product/2022/06/18/895816ec51c14563b679f02d729d210b2tdhub0hsb.gif\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"10\"}],\"id\":115,\"sort\":1,\"status\":true}', 1, 1, '2020-07-29 19:59:47', '2022-06-18 15:40:05');
INSERT INTO `eb_system_group_data` VALUES (11, 3, '{\"fields\":[{\"name\":\"orderStatus\",\"title\":\"orderStatus\",\"value\":\"3\"},{\"name\":\"image\",\"title\":\"image\",\"value\":\"crmebimage/public/product/2022/06/18/ff8278c17aef444db2556eec57d602a6p8l777730y.gif\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"11\"}],\"id\":115,\"sort\":1,\"status\":true}', 1, 1, '2020-07-29 20:00:02', '2022-06-18 15:40:37');
INSERT INTO `eb_system_group_data` VALUES (12, 3, '{\"fields\":[{\"name\":\"orderStatus\",\"title\":\"orderStatus\",\"value\":\"4\"},{\"name\":\"image\",\"title\":\"image\",\"value\":\"crmebimage/public/product/2022/06/18/ff8278c17aef444db2556eec57d602a6p8l777730y.gif\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"12\"}],\"id\":115,\"sort\":1,\"status\":true}', 1, 1, '2020-07-29 20:00:14', '2022-06-18 15:40:56');
INSERT INTO `eb_system_group_data` VALUES (26, 7, '{\"id\":97,\"sort\":0,\"fields\":[{\"name\":\"show\",\"title\":\"show\",\"value\":\"1\"},{\"name\":\"url\",\"title\":\"url\",\"value\":\"/pages/news_details/index?id=10\"},{\"name\":\"info\",\"title\":\"info\",\"value\":\"CRMEB电商系统Java版正式发布！\"}],\"status\":true}', 0, 1, '2021-12-17 15:47:11', '2021-12-17 15:47:11');
INSERT INTO `eb_system_group_data` VALUES (27, 7, '{\"id\":97,\"sort\":1,\"fields\":[{\"name\":\"show\",\"title\":\"show\",\"value\":\"1\"},{\"name\":\"url\",\"title\":\"url\",\"value\":\"/pages/news_details/index?id=11\"},{\"name\":\"info\",\"title\":\"info\",\"value\":\"这是美好的一天\"}],\"status\":true}', 1, 1, '2021-12-17 15:47:11', '2021-12-17 15:47:11');
INSERT INTO `eb_system_group_data` VALUES (28, 8, '{\"fields\":[{\"name\":\"title\",\"title\":\"title\",\"value\":\"键盘\"}],\"id\":102,\"sort\":1,\"status\":true}', 1, 1, '2020-06-03 11:34:54', '2021-11-02 14:38:13');
INSERT INTO `eb_system_group_data` VALUES (29, 8, '{\"fields\":[{\"name\":\"title\",\"title\":\"title\",\"value\":\"鞋子\"}],\"id\":102,\"sort\":2,\"status\":true}', 2, 1, '2020-06-03 11:35:00', '2020-06-03 11:35:00');
INSERT INTO `eb_system_group_data` VALUES (30, 8, '{\"fields\":[{\"name\":\"title\",\"title\":\"title\",\"value\":\"男装\"}],\"id\":102,\"sort\":3,\"status\":true}', 3, 1, '2020-06-03 11:35:07', '2021-11-02 14:39:53');
INSERT INTO `eb_system_group_data` VALUES (31, 8, '{\"fields\":[{\"name\":\"title\",\"title\":\"title\",\"value\":\"MacBook\"}],\"id\":102,\"sort\":4,\"status\":true}', 4, 1, '2020-06-03 11:35:29', '2021-11-02 14:40:03');
INSERT INTO `eb_system_group_data` VALUES (32, 8, '{\"fields\":[{\"name\":\"title\",\"title\":\"title\",\"value\":\"茶叶\"}],\"id\":102,\"sort\":0,\"status\":true}', 0, 1, '2021-02-07 12:18:07', '2021-11-02 14:39:03');
INSERT INTO `eb_system_group_data` VALUES (34, 10, '{\"fields\":[{\"name\":\"pic\",\"title\":\"pic\",\"value\":\"crmebimage/public/product/2022/06/18/b5eea8de3dc844ca80c47fd44171e23dg52k1el1ze.gif\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"34\"}],\"id\":161,\"sort\":1,\"status\":true}', 1, 1, '2022-05-05 18:39:01', '2022-06-18 15:09:40');
INSERT INTO `eb_system_group_data` VALUES (35, 10, '{\"fields\":[{\"name\":\"pic\",\"title\":\"pic\",\"value\":\"crmebimage/public/product/2022/06/18/2ba89f51e47f40279081815258ca4a4dpy5w3x8v51.jpg\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"35\"}],\"id\":161,\"sort\":1,\"status\":true}', 1, 1, '2022-05-05 18:39:01', '2022-06-18 15:09:47');
INSERT INTO `eb_system_group_data` VALUES (47, 5, '{\"fields\":[{\"name\":\"pic\",\"title\":\"pic\",\"value\":\"crmebimage/public/product/2022/06/18/df6214011a2f4683b1b5feab362f0d882pneycevbh.jpg\"},{\"name\":\"url\",\"title\":\"url\",\"value\":\"www.crmeb.com\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"47\"}],\"id\":90,\"sort\":1,\"status\":true}', 1, 1, '2022-05-13 16:46:07', '2022-06-18 15:32:22');
INSERT INTO `eb_system_group_data` VALUES (48, 5, '{\"fields\":[{\"name\":\"pic\",\"title\":\"pic\",\"value\":\"crmebimage/public/product/2022/06/18/7caee6176c4f44e4baea64206c59f6274ywzmc143e.jpg\"},{\"name\":\"url\",\"title\":\"url\",\"value\":\"www.crmeb.com\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"48\"}],\"id\":90,\"sort\":1,\"status\":true}', 1, 1, '2022-05-13 16:46:07', '2022-06-18 15:32:30');
INSERT INTO `eb_system_group_data` VALUES (58, 2, '{\"fields\":[{\"name\":\"name\",\"title\":\"name\",\"value\":\"pro\"},{\"name\":\"url\",\"title\":\"url\",\"value\":\"/pages/goods_details/index?id=9\"},{\"name\":\"pic\",\"title\":\"pic\",\"value\":\"crmebimage/public/product/2022/06/18/d11be7f78a014558924a31874a50617at9bfdsqy0v.jpg\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"58\"}],\"id\":95,\"sort\":1,\"status\":true}', 1, 1, '2022-05-16 15:28:46', '2022-06-18 15:42:17');
INSERT INTO `eb_system_group_data` VALUES (59, 2, '{\"fields\":[{\"name\":\"name\",\"title\":\"name\",\"value\":\"123\"},{\"name\":\"url\",\"title\":\"url\",\"value\":\"/pages/goods_details/index?id=6\"},{\"name\":\"pic\",\"title\":\"pic\",\"value\":\"crmebimage/public/product/2022/06/18/4248cfea71c040c1bf5a3a6a75f8c6381hujr27fou.jpg\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"59\"}],\"id\":95,\"sort\":1,\"status\":true}', 1, 1, '2022-05-16 15:28:46', '2022-06-18 15:42:25');
INSERT INTO `eb_system_group_data` VALUES (60, 2, '{\"fields\":[{\"name\":\"name\",\"title\":\"name\",\"value\":\"123\"},{\"name\":\"url\",\"title\":\"url\",\"value\":\"/pages/goods_details/index?id=16\"},{\"name\":\"pic\",\"title\":\"pic\",\"value\":\"crmebimage/public/product/2022/06/18/b29d82deb7c443ca88795c3d341b6887h43udf7n4v.jpg\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"60\"}],\"id\":95,\"sort\":2,\"status\":false}', 2, 0, '2022-05-16 15:28:46', '2022-06-18 15:42:32');
INSERT INTO `eb_system_group_data` VALUES (61, 2, '{\"fields\":[{\"name\":\"name\",\"title\":\"name\",\"value\":\"456\"},{\"name\":\"url\",\"title\":\"url\",\"value\":\"/pages/goods_details/index?id=4\"},{\"name\":\"pic\",\"title\":\"pic\",\"value\":\"crmebimage/public/product/2022/06/18/b1475f2ded8a4e23adb74d5cb3e08544k4rtv1sef4.jpg\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"61\"}],\"id\":95,\"sort\":3,\"status\":true}', 3, 1, '2022-05-16 15:28:46', '2022-06-18 15:42:38');
INSERT INTO `eb_system_group_data` VALUES (65, 4, '{\"fields\":[{\"name\":\"name\",\"title\":\"name\",\"value\":\"My profile\"},{\"name\":\"pic\",\"title\":\"pic\",\"value\":\"crmebimage/public/product/2022/06/18/7d034a06a3404bf8b24ec82143e99017fpmlsx0om1.png\"},{\"name\":\"url\",\"title\":\"url\",\"value\":\"/pages/users/user_info/index\"},{\"name\":\"pc_url\",\"title\":\"pc_url\",\"value\":\"/users/user_info\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"65\"}],\"id\":89,\"sort\":1,\"status\":true}', 1, 1, '2022-06-06 10:40:53', '2022-06-18 15:36:23');
INSERT INTO `eb_system_group_data` VALUES (66, 4, '{\"fields\":[{\"name\":\"name\",\"title\":\"name\",\"value\":\"Address Information\"},{\"name\":\"pic\",\"title\":\"pic\",\"value\":\"crmebimage/public/product/2022/06/18/a1a67a5c7cd74f44959f2bba2a9492e63bznmbr6zw.png\"},{\"name\":\"url\",\"title\":\"url\",\"value\":\"/pages/users/user_address_list/index\"},{\"name\":\"pc_url\",\"title\":\"pc_url\",\"value\":\"/users/address_list\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"66\"}],\"id\":89,\"sort\":1,\"status\":true}', 1, 1, '2022-06-06 10:40:53', '2022-06-18 15:36:31');
INSERT INTO `eb_system_group_data` VALUES (67, 4, '{\"fields\":[{\"name\":\"name\",\"title\":\"name\",\"value\":\"My favorite\"},{\"name\":\"pic\",\"title\":\"pic\",\"value\":\"crmebimage/public/product/2022/06/18/477ed879ac184774b41f296db9bcc6d0uc9cw3qcjv.png\"},{\"name\":\"url\",\"title\":\"url\",\"value\":\"/pages/users/user_goods_collection/index\"},{\"name\":\"pc_url\",\"title\":\"pc_url\",\"value\":\"/users/collection_list\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"67\"}],\"id\":89,\"sort\":2,\"status\":true}', 2, 1, '2022-06-06 10:40:53', '2022-06-18 15:36:43');
INSERT INTO `eb_system_group_data` VALUES (68, 4, '{\"fields\":[{\"name\":\"name\",\"title\":\"name\",\"value\":\"Coupons\"},{\"name\":\"pic\",\"title\":\"pic\",\"value\":\"crmebimage/public/product/2022/06/18/96e9ecdd289d405ca9f7df66f8d4c667qqn1r1zsph.png\"},{\"name\":\"url\",\"title\":\"url\",\"value\":\"/pages/users/user_coupon/index\"},{\"name\":\"pc_url\",\"title\":\"pc_url\",\"value\":\"/users/coupon_list\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"68\"}],\"id\":89,\"sort\":3,\"status\":true}', 3, 1, '2022-06-06 10:40:53', '2022-06-18 15:37:05');
INSERT INTO `eb_system_group_data` VALUES (69, 4, '{\"fields\":[{\"name\":\"name\",\"title\":\"name\",\"value\":\"follow merchant\"},{\"name\":\"pic\",\"title\":\"pic\",\"value\":\"crmebimage/public/product/2022/06/18/1d4ca008abcd4470b98a4b1e2920f98b6k6s1os89z.jpg\"},{\"name\":\"url\",\"title\":\"url\",\"value\":\"/pages/users/user_merchant_collection/index\"},{\"name\":\"pc_url\",\"title\":\"pc_url\",\"value\":\" \"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"69\"}],\"id\":89,\"sort\":4,\"status\":true}', 4, 1, '2022-06-06 10:40:53', '2022-06-18 15:37:16');
INSERT INTO `eb_system_group_data` VALUES (70, 4, '{\"fields\":[{\"name\":\"name\",\"title\":\"name\",\"value\":\"apply\"},{\"name\":\"pic\",\"title\":\"pic\",\"value\":\"crmebimage/public/product/2022/06/18/d29434234e6d41b5bacfddab9bbf2a0d19vikgbtad.png\"},{\"name\":\"url\",\"title\":\"url\",\"value\":\"/pages/merchant/settled/index\"},{\"name\":\"pc_url\",\"title\":\"pc_url\",\"value\":\"/users/merchant_settled\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"70\"}],\"id\":89,\"sort\":5,\"status\":true}', 5, 1, '2022-06-06 10:40:53', '2022-06-18 15:37:24');
INSERT INTO `eb_system_group_data` VALUES (71, 4, '{\"fields\":[{\"name\":\"name\",\"title\":\"name\",\"value\":\"Application record\"},{\"name\":\"pic\",\"title\":\"pic\",\"value\":\"crmebimage/public/product/2022/06/18/10de6d79d68d492eac7cd67af833baeczrhu8jcg82.png\"},{\"name\":\"url\",\"title\":\"url\",\"value\":\"/pages/merchant/application_record/index\"},{\"name\":\"pc_url\",\"title\":\"pc_url\",\"value\":\"/users/application_record\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"71\"}],\"id\":89,\"sort\":6,\"status\":true}', 6, 1, '2022-06-06 10:40:53', '2022-06-18 15:37:33');
INSERT INTO `eb_system_group_data` VALUES (99, 6, '{\"fields\":[{\"name\":\"name\",\"title\":\"name\",\"value\":\"Category\"},{\"name\":\"pic\",\"title\":\"pic\",\"value\":\"crmebimage/public/product/2022/06/18/5687d37941fa467a9b474a46b150e3f80bq8cnzyal.png\"},{\"name\":\"url\",\"title\":\"url\",\"value\":\"/pages/goods_cate/index\"},{\"name\":\"show\",\"title\":\"show\",\"value\":\"1\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"99\"}],\"id\":96,\"sort\":1,\"status\":true}', 1, 1, '2022-06-10 10:44:48', '2022-06-18 15:27:26');
INSERT INTO `eb_system_group_data` VALUES (100, 6, '{\"fields\":[{\"name\":\"name\",\"title\":\"name\",\"value\":\"Favorite\"},{\"name\":\"pic\",\"title\":\"pic\",\"value\":\"crmebimage/public/product/2022/06/18/89674707e3834933b4d4b623fea09ed1jjiea34l4l.png\"},{\"name\":\"url\",\"title\":\"url\",\"value\":\"/pages/users/user_goods_collection/index\"},{\"name\":\"show\",\"title\":\"show\",\"value\":\"2\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"100\"}],\"id\":96,\"sort\":1,\"status\":true}', 1, 1, '2022-06-10 10:44:48', '2022-06-18 15:27:37');
INSERT INTO `eb_system_group_data` VALUES (101, 6, '{\"fields\":[{\"name\":\"name\",\"title\":\"name\",\"value\":\"Address\"},{\"name\":\"pic\",\"title\":\"pic\",\"value\":\"crmebimage/public/product/2022/06/18/17dfd6211f5f4bc09631e9990299f96818527sqfe2.png\"},{\"name\":\"url\",\"title\":\"url\",\"value\":\"/pages/users/user_address_list/index\"},{\"name\":\"show\",\"title\":\"show\",\"value\":\"2\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"101\"}],\"id\":96,\"sort\":2,\"status\":true}', 2, 1, '2022-06-10 10:44:48', '2022-06-18 15:27:51');
INSERT INTO `eb_system_group_data` VALUES (102, 6, '{\"fields\":[{\"name\":\"name\",\"title\":\"name\",\"value\":\"Order\"},{\"name\":\"pic\",\"title\":\"pic\",\"value\":\"crmebimage/public/product/2022/06/18/865c4d1385534806b99db13766bb0977sgyi097jso.png\"},{\"name\":\"url\",\"title\":\"url\",\"value\":\"/pages/users/order_list/index\"},{\"name\":\"show\",\"title\":\"show\",\"value\":\"2\"},{\"name\":\"id\",\"title\":\"id\",\"value\":\"102\"}],\"id\":96,\"sort\":3,\"status\":true}', 3, 1, '2022-06-10 10:44:48', '2022-06-18 15:28:00');
INSERT INTO `eb_system_group_data` VALUES (104, 11, '{\"fields\":[{\"name\":\"pic\",\"title\":\"pic\",\"value\":\"crmebimage/public/product/2022/06/18/21f102999ad04afab46ef8ded3dff5cdtq5fdrdyrs.png\"},{\"name\":\"id\",\"title\":\"id\"}],\"id\":162,\"sort\":1,\"status\":true}', 1, 1, '2022-06-18 15:07:18', '2022-06-18 15:07:18');
INSERT INTO `eb_system_group_data` VALUES (105, 9, '{\"fields\":[{\"name\":\"pic\",\"title\":\"pic\",\"value\":\"crmebimage/public/product/2022/06/17/ee50e78ebb9344dd9ecafd94e45e61660ugjjm32z5.png\"},{\"name\":\"id\",\"title\":\"id\"}],\"id\":114,\"sort\":1,\"status\":true}', 1, 1, '2022-06-18 15:07:43', '2022-06-18 15:07:43');
INSERT INTO `eb_system_group_data` VALUES (576, 14, '{\"id\":57,\"sort\":0,\"fields\":[{\"name\":\"name\",\"title\":\"name\",\"value\":\"首页\"},{\"name\":\"link\",\"title\":\"link\",\"value\":\"/pages/index/index\"},{\"name\":\"unchecked\",\"title\":\"unchecked\",\"value\":\"crmebimage/public/content/2023/08/09/482fd9aa66444da6a2d384c205b5fb4dmncfp7bqan.png\"},{\"name\":\"checked\",\"title\":\"checked\",\"value\":\"crmebimage/public/content/2023/08/09/cc1dffc929864a9daeb3cc89e0023068ikcfhefjzq.png\"}],\"status\":true}', 0, 1, '2025-04-15 09:29:01', '2025-04-15 09:29:01');
INSERT INTO `eb_system_group_data` VALUES (577, 14, '{\"id\":57,\"sort\":1,\"fields\":[{\"name\":\"name\",\"title\":\"name\",\"value\":\"商品分类\"},{\"name\":\"link\",\"title\":\"link\",\"value\":\"/pages/goods_cate/index\"},{\"name\":\"unchecked\",\"title\":\"unchecked\",\"value\":\"crmebimage/public/content/2023/08/09/b3d03dc9ced24cca8979e6665bbd05desxr37idzrx.png\"},{\"name\":\"checked\",\"title\":\"checked\",\"value\":\"crmebimage/public/content/2023/08/09/66e0cb9b03aa4303a18144b3e64bf119p76mssng6w.png\"}],\"status\":true}', 1, 1, '2025-04-15 09:29:01', '2025-04-15 09:29:01');
INSERT INTO `eb_system_group_data` VALUES (578, 14, '{\"id\":57,\"sort\":2,\"fields\":[{\"name\":\"name\",\"title\":\"name\",\"value\":\"逛逛\"},{\"name\":\"link\",\"title\":\"link\",\"value\":\"/pages/discover_index/index\"},{\"name\":\"unchecked\",\"title\":\"unchecked\",\"value\":\"crmebimage/public/content/2023/08/09/175e1b35b08d49c293975f98ef9a25e1mma4erkx2e.png\"},{\"name\":\"checked\",\"title\":\"checked\",\"value\":\"crmebimage/public/content/2023/08/09/58c3c6b5f4d04316ae3b8320e68e0b01wfgstekfpp.png\"}],\"status\":true}', 2, 1, '2025-04-15 09:29:01', '2025-04-15 09:29:01');
INSERT INTO `eb_system_group_data` VALUES (579, 14, '{\"id\":57,\"sort\":3,\"fields\":[{\"name\":\"name\",\"title\":\"name\",\"value\":\"购物车\"},{\"name\":\"link\",\"title\":\"link\",\"value\":\"/pages/order_addcart/order_addcart\"},{\"name\":\"unchecked\",\"title\":\"unchecked\",\"value\":\"crmebimage/public/content/2023/08/09/bd747d916c304191a446246442dddc7dnygnb6v095.png\"},{\"name\":\"checked\",\"title\":\"checked\",\"value\":\"crmebimage/public/content/2023/08/09/0764ed2d44e24717ad1ae9b05cdd7d5ec3y2o4ie1p.png\"}],\"status\":true}', 3, 1, '2025-04-15 09:29:01', '2025-04-15 09:29:01');
INSERT INTO `eb_system_group_data` VALUES (580, 14, '{\"id\":57,\"sort\":4,\"fields\":[{\"name\":\"name\",\"title\":\"name\",\"value\":\"我的\"},{\"name\":\"link\",\"title\":\"link\",\"value\":\"/pages/user/index\"},{\"name\":\"unchecked\",\"title\":\"unchecked\",\"value\":\"crmebimage/public/content/2023/08/09/44b599d8605f40dea853bc5598b0a0c1ekyj4wfj2d.png\"},{\"name\":\"checked\",\"title\":\"checked\",\"value\":\"crmebimage/public/content/2023/08/09/e17fc4e9669047fa9e5a41e4622931b6ld6ufelvze.png\"}],\"status\":true}', 4, 1, '2025-04-15 09:29:01', '2025-04-15 09:29:01');

-- ----------------------------
-- Table structure for eb_system_menu
-- ----------------------------
DROP TABLE IF EXISTS `eb_system_menu`;
CREATE TABLE `eb_system_menu`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父级ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '名称',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'icon',
  `perms` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '权限标识',
  `component` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '组件路径',
  `menu_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'M' COMMENT '类型，M-目录，C-菜单，A-按钮',
  `sort` int(5) NOT NULL DEFAULT 99999 COMMENT '排序',
  `is_show` tinyint(1) NOT NULL DEFAULT 1 COMMENT '显示状态',
  `is_delte` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '是否删除',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `type` int(11) NOT NULL COMMENT '系统菜单类型：3-平台,4-商户',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 417 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统菜单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_system_menu
-- ----------------------------
INSERT INTO `eb_system_menu` VALUES (1, 0, '运营', 'menu', NULL, '/dashboard', 'M', 9999, 1, 0, '2021-11-16 12:11:17', '2022-04-19 23:36:33', 3);
INSERT INTO `eb_system_menu` VALUES (2, 0, '商品', 's-goods', NULL, '/store', 'M', 9996, 1, 0, '2021-11-16 12:11:17', '2022-04-19 23:52:31', 3);
INSERT INTO `eb_system_menu` VALUES (3, 0, '订单', 's-order', NULL, '/order', 'M', 9997, 1, 0, '2021-11-16 12:11:17', '2022-04-19 23:52:28', 3);
INSERT INTO `eb_system_menu` VALUES (4, 0, '用户', 'user-solid', NULL, '/user', 'M', 9995, 1, 0, '2021-11-16 12:11:17', '2022-04-19 23:52:49', 3);
INSERT INTO `eb_system_menu` VALUES (5, 0, '财务', 's-finance', NULL, '/financial', 'M', 9994, 1, 0, '2021-11-16 12:11:18', '2022-04-19 23:52:59', 3);
INSERT INTO `eb_system_menu` VALUES (6, 0, '设置', 's-tools', NULL, '/operation', 'M', 9993, 1, 0, '2021-11-16 12:11:18', '2022-04-19 23:53:03', 3);
INSERT INTO `eb_system_menu` VALUES (7, 0, '维护', 's-open', NULL, '/maintain', 'M', 9996, 1, 0, '2021-11-16 12:11:18', '2025-04-03 11:02:45', 3);
INSERT INTO `eb_system_menu` VALUES (8, 2, '商品分类', NULL, '', '/store/sort', 'C', 10, 1, 0, '2021-11-16 12:19:02', '2022-04-19 23:36:39', 3);
INSERT INTO `eb_system_menu` VALUES (9, 14, '库存变动', NULL, '', 'api/admin/store/product/stock', 'A', 1, 1, 0, '2021-11-16 15:55:00', '2022-04-19 23:36:46', 3);
INSERT INTO `eb_system_menu` VALUES (10, 14, '虚拟销量', NULL, '', 'api/admin/store/product/ficti', 'A', 1, 1, 0, '2021-11-16 15:55:00', '2022-04-19 23:36:46', 3);
INSERT INTO `eb_system_menu` VALUES (11, 32, '订单更新', NULL, '', 'api/admin/store/order/update', 'A', 1, 1, 1, '2021-11-16 15:58:16', '2022-04-19 23:36:46', 3);
INSERT INTO `eb_system_menu` VALUES (12, 171, '领取记录', NULL, 'merchant:coupon:user:page:list', '/marketing/coupon/record', 'C', 10, 1, 1, '2021-11-16 16:48:47', '2022-04-24 14:33:15', 4);
INSERT INTO `eb_system_menu` VALUES (13, 12, '领取优惠券', NULL, '', 'api/admin/marketing/coupon/user/receive', 'A', 1, 1, 1, '2021-11-16 16:50:02', '2022-04-20 09:42:19', 3);
INSERT INTO `eb_system_menu` VALUES (14, 6, '管理权限', NULL, '', '/operation/roleManager', 'M', 10, 1, 0, '2021-11-16 17:23:37', '2022-04-19 23:55:25', 3);
INSERT INTO `eb_system_menu` VALUES (15, 6, '页面管理', NULL, '', '/operation/design', 'M', 10, 1, 0, '2021-11-16 17:23:37', '2022-04-19 23:55:26', 3);
INSERT INTO `eb_system_menu` VALUES (16, 14, '角色管理', NULL, 'platform:admin:role:list', '/operation//roleManager/identityManager', 'C', 10, 1, 0, '2021-11-16 17:30:23', '2022-04-19 23:36:39', 3);
INSERT INTO `eb_system_menu` VALUES (17, 14, '管理员列表', NULL, 'platform:admin:list', '/operation//roleManager/adminList', 'C', 10, 1, 0, '2021-11-16 17:30:23', '2022-04-19 23:36:39', 3);
INSERT INTO `eb_system_menu` VALUES (18, 14, '权限规则', NULL, '', '/operation//roleManager/promiseRules', 'C', 10, 1, 0, '2021-11-16 17:30:23', '2022-04-20 00:29:51', 3);
INSERT INTO `eb_system_menu` VALUES (19, 15, '一键换色', NULL, '', '/operation/design/theme', 'C', 10, 1, 0, '2021-11-16 17:30:23', '2022-04-19 23:36:39', 3);
INSERT INTO `eb_system_menu` VALUES (20, 15, '页面设计', NULL, 'platform:page:layout:index', '/operation/design/viewDesign', 'C', 10, 1, 0, '2021-11-16 17:30:23', '2022-04-19 23:36:39', 3);
INSERT INTO `eb_system_menu` VALUES (21, 16, '身份添加', NULL, 'platform:admin:role:save', 'api/admin/system/role/save', 'A', 1, 1, 1, '2021-11-16 17:35:42', '2022-04-19 23:36:46', 3);
INSERT INTO `eb_system_menu` VALUES (22, 16, '身份删除', NULL, 'platform:admin:role:delete', '', 'A', 1, 1, 1, '2021-11-16 17:35:42', '2022-04-19 23:36:46', 3);
INSERT INTO `eb_system_menu` VALUES (23, 16, '身份修改', NULL, 'platform:admin:role:update', '', 'A', 1, 1, 1, '2021-11-16 17:35:43', '2022-04-19 23:36:46', 3);
INSERT INTO `eb_system_menu` VALUES (24, 17, '管理员添加', NULL, 'platform:admin:save', '', 'A', 1, 1, 0, '2021-11-16 17:35:43', '2022-05-10 17:12:01', 3);
INSERT INTO `eb_system_menu` VALUES (25, 17, '管理员修改', NULL, 'platform:admin:update', '', 'A', 1, 1, 0, '2021-11-16 17:35:43', '2022-04-19 23:36:46', 3);
INSERT INTO `eb_system_menu` VALUES (26, 17, '管理员删除', NULL, 'platform:admin:delete', '', 'A', 1, 1, 0, '2021-11-16 17:35:43', '2022-04-19 23:36:46', 3);
INSERT INTO `eb_system_menu` VALUES (27, 17, '管理员状态更新', NULL, 'platform:admin:update:status', '', 'A', 1, 1, 0, '2021-11-16 17:35:43', '2022-04-19 23:36:46', 3);
INSERT INTO `eb_system_menu` VALUES (28, 16, '权限新增', NULL, 'platform:admin:role:save', NULL, 'A', 1, 1, 0, '2021-11-16 17:35:43', '2022-04-20 00:30:00', 3);
INSERT INTO `eb_system_menu` VALUES (29, 16, '权限删除', NULL, 'platform:admin:role:delete', NULL, 'A', 1, 1, 0, '2021-11-16 17:35:43', '2022-04-20 00:30:00', 3);
INSERT INTO `eb_system_menu` VALUES (30, 16, '权限更新', NULL, 'platform:admin:role:update', NULL, 'A', 1, 1, 0, '2021-11-16 17:35:43', '2022-04-20 00:30:00', 3);
INSERT INTO `eb_system_menu` VALUES (31, 16, '更新权限状态', NULL, 'platform:admin:role:update:status', NULL, 'A', 1, 1, 1, '2021-11-16 17:35:43', '2022-04-20 00:30:00', 3);
INSERT INTO `eb_system_menu` VALUES (32, 7, '素材管理', NULL, 'platform:attachment:list', '/maintain/picture', 'C', 10, 1, 0, '2021-11-16 17:38:38', '2022-04-19 23:36:39', 3);
INSERT INTO `eb_system_menu` VALUES (33, 7, '开发配置', NULL, '', '/maintain//devconfiguration', 'M', 10, 1, 0, '2021-11-16 17:38:38', '2022-04-19 23:55:30', 3);
INSERT INTO `eb_system_menu` VALUES (34, 7, '申请授权', NULL, '', '/maintain/authCRMEB', 'C', 10, 1, 0, '2021-11-16 17:38:38', '2022-04-19 23:36:39', 3);
INSERT INTO `eb_system_menu` VALUES (35, 7, '物流设置', NULL, '', '/maintain/logistics', 'M', 10, 1, 0, '2021-11-16 17:38:38', '2022-04-19 23:55:31', 3);
INSERT INTO `eb_system_menu` VALUES (36, 32, '删除素材', NULL, 'platform:attachment:delete', 'api/admin/system/attachment/delete', 'A', 1, 1, 0, '2021-11-16 17:41:33', '2022-04-20 00:01:26', 3);
INSERT INTO `eb_system_menu` VALUES (37, 33, '配置分类', NULL, '', '/maintain/devconfiguration/configCategory', 'C', 10, 1, 0, '2021-11-16 17:41:33', '2022-04-19 23:58:29', 3);
INSERT INTO `eb_system_menu` VALUES (38, 33, '组合数据', NULL, 'platform:config:group:list', '/maintain/devconfiguration/combineddata', 'C', 10, 1, 0, '2021-11-16 17:41:33', '2022-04-19 23:58:29', 3);
INSERT INTO `eb_system_menu` VALUES (39, 33, '表单配置', NULL, 'platform:config:form:list', '/maintain/devconfiguration/formConfig', 'C', 10, 1, 0, '2021-11-16 17:41:33', '2022-04-19 23:58:29', 3);
INSERT INTO `eb_system_menu` VALUES (40, 38, '数据组添加', NULL, 'platform:config:group:save', '', 'A', 1, 1, 0, '2021-11-16 17:44:35', '2022-05-05 14:56:44', 3);
INSERT INTO `eb_system_menu` VALUES (41, 38, '数据组修改', NULL, 'platform:config:group:update', '', 'A', 1, 1, 0, '2021-11-16 17:44:35', '2022-05-05 14:56:56', 3);
INSERT INTO `eb_system_menu` VALUES (42, 38, '数据组删除', NULL, 'platform:config:group:delete', '', 'A', 1, 1, 0, '2021-11-16 17:44:35', '2022-05-05 14:57:05', 3);
INSERT INTO `eb_system_menu` VALUES (43, 38, '组合数据添加', NULL, 'platform:config:group:data:save', '', 'A', 1, 1, 0, '2021-11-16 17:44:35', '2022-05-05 14:57:19', 3);
INSERT INTO `eb_system_menu` VALUES (44, 38, '组合数据修改', NULL, 'platform:config:group:data:update', '', 'A', 1, 1, 0, '2021-11-16 17:44:35', '2022-05-05 14:57:28', 3);
INSERT INTO `eb_system_menu` VALUES (45, 38, '组合数据删除', NULL, 'platform:config:group:data:delete', '', 'A', 1, 1, 0, '2021-11-16 17:44:35', '2022-05-05 14:57:37', 3);
INSERT INTO `eb_system_menu` VALUES (46, 39, '表单添加', NULL, 'platform:config:form:save', '', 'A', 1, 1, 0, '2021-11-16 17:44:35', '2022-04-20 00:33:16', 3);
INSERT INTO `eb_system_menu` VALUES (47, 39, '表单修改', NULL, 'platform:config:form:update', '', 'A', 1, 1, 0, '2021-11-16 17:44:35', '2022-04-20 00:33:16', 3);
INSERT INTO `eb_system_menu` VALUES (48, 1, '控制台', '', '', '/dashboard', 'C', 10, 1, 0, '2021-11-30 14:13:37', '2022-04-19 23:36:39', 3);
INSERT INTO `eb_system_menu` VALUES (49, 1, '用户统计', '', '', '/statuser', 'C', 10, 1, 1, '2021-11-30 14:14:10', '2022-04-19 23:36:39', 3);
INSERT INTO `eb_system_menu` VALUES (50, 1, '交易统计', '', '', '/transaction', 'C', 10, 1, 1, '2021-11-30 14:14:34', '2022-04-19 23:36:39', 3);
INSERT INTO `eb_system_menu` VALUES (51, 1, '商品统计', '', '', '/product', 'C', 10, 1, 1, '2021-11-30 14:17:46', '2022-04-19 23:36:39', 3);
INSERT INTO `eb_system_menu` VALUES (52, 38, '组合数据详情', '', 'platform:config:group:data:info', '', 'A', 1, 1, 0, '2021-12-02 11:35:48', '2022-05-05 14:57:46', 3);
INSERT INTO `eb_system_menu` VALUES (53, 0, '登录管理', NULL, NULL, NULL, 'M', 9991, 0, 0, '2021-12-03 16:31:43', '2022-04-19 23:53:10', 3);
INSERT INTO `eb_system_menu` VALUES (54, 16, '角色详情', NULL, 'platform:admin:role:info', NULL, 'A', 1, 1, 0, '2021-12-03 16:39:41', '2022-04-20 00:27:02', 3);
INSERT INTO `eb_system_menu` VALUES (55, 48, '首页数据', '', 'platform:statistics:home:index', '', 'A', 1, 1, 0, '2021-12-03 16:51:09', '2022-04-20 16:21:26', 3);
INSERT INTO `eb_system_menu` VALUES (56, 48, '用户曲线图', '', 'admin:statistics:home:chart:user', '', 'A', 1, 1, 1, '2021-12-03 16:51:29', '2022-04-19 23:43:35', 3);
INSERT INTO `eb_system_menu` VALUES (57, 48, '用户购买统计', '', 'admin:statistics:home:chart:user:buy', '', 'A', 1, 1, 1, '2021-12-03 16:51:59', '2022-04-19 23:43:35', 3);
INSERT INTO `eb_system_menu` VALUES (58, 48, '30天订单量趋势', '', 'admin:statistics:home:chart:order', '', 'A', 1, 1, 1, '2021-12-03 16:52:47', '2022-04-19 23:43:35', 3);
INSERT INTO `eb_system_menu` VALUES (59, 48, '周订单量趋势', '', 'admin:statistics:home:chart:order:week', '', 'A', 1, 1, 1, '2021-12-03 16:53:00', '2022-04-19 23:43:35', 3);
INSERT INTO `eb_system_menu` VALUES (60, 48, '月订单量趋势', '', 'admin:statistics:home:chart:order:month', '', 'A', 1, 1, 1, '2021-12-03 16:53:16', '2022-04-19 23:43:35', 3);
INSERT INTO `eb_system_menu` VALUES (61, 48, '年订单量趋势', '', 'admin:statistics:home:chart:order:year', '', 'A', 1, 1, 1, '2021-12-03 16:53:36', '2022-04-19 23:43:35', 3);
INSERT INTO `eb_system_menu` VALUES (62, 0, '分类服务(素材/设置/文章)', '', '', '', 'M', 9990, 0, 0, '2021-12-03 17:15:29', '2022-04-19 23:53:14', 3);
INSERT INTO `eb_system_menu` VALUES (63, 62, '分类列表', '', 'platform:category:list', '', 'A', 1, 1, 0, '2021-12-03 17:16:12', '2022-04-20 00:10:52', 3);
INSERT INTO `eb_system_menu` VALUES (64, 62, '新增分类', '', 'platform:category:save', '', 'A', 1, 1, 0, '2021-12-03 17:16:35', '2022-04-20 00:10:52', 3);
INSERT INTO `eb_system_menu` VALUES (65, 62, '删除分类', '', 'platform:category:delete', '', 'A', 1, 1, 0, '2021-12-03 17:16:52', '2022-04-20 00:10:52', 3);
INSERT INTO `eb_system_menu` VALUES (66, 62, '修改分类', '', 'platform:category:update', '', 'A', 1, 1, 0, '2021-12-03 17:17:11', '2022-04-20 00:10:52', 3);
INSERT INTO `eb_system_menu` VALUES (67, 62, '分类详情', '', 'platform:category:info', '', 'A', 1, 1, 0, '2021-12-03 17:17:35', '2022-04-20 00:10:52', 3);
INSERT INTO `eb_system_menu` VALUES (68, 62, '分类tree列表', '', 'platform:category:list:tree', '', 'A', 1, 1, 0, '2021-12-03 17:18:06', '2022-04-20 00:10:52', 3);
INSERT INTO `eb_system_menu` VALUES (69, 62, '根据id集合获取分类列表', '', 'platform:category:list:ids', '', 'A', 1, 1, 0, '2021-12-03 17:18:23', '2022-04-20 00:10:52', 3);
INSERT INTO `eb_system_menu` VALUES (70, 62, '更改分类状态', '', 'platform:category:update:status', '', 'A', 1, 1, 0, '2021-12-03 17:18:38', '2022-04-20 00:10:52', 3);
INSERT INTO `eb_system_menu` VALUES (71, 38, '分页组合数据详情', '', 'platform:config:group:data:list', '', 'A', 1, 1, 0, '2021-12-03 17:39:37', '2022-05-05 14:57:59', 3);
INSERT INTO `eb_system_menu` VALUES (72, 32, '订单操作记录列表', '', 'merchant:order:status:list', '', 'A', 1, 1, 0, '2021-12-06 09:45:04', '2022-04-19 23:36:46', 3);
INSERT INTO `eb_system_menu` VALUES (73, 16, '角色详情', '', 'platform:admin:role:info', '', 'A', 1, 1, 1, '2021-12-06 10:50:32', '2022-04-19 23:36:46', 3);
INSERT INTO `eb_system_menu` VALUES (74, 16, '修改角色状态', '', 'platform:admin:role:update:status', '', 'A', 1, 1, 0, '2021-12-06 10:51:09', '2022-04-19 23:36:46', 3);
INSERT INTO `eb_system_menu` VALUES (75, 17, '管理员详情', '', 'platform:admin:info', '', 'A', 1, 1, 0, '2021-12-06 11:04:41', '2022-04-19 23:36:46', 3);
INSERT INTO `eb_system_menu` VALUES (76, 87, '表单模板详情', '', 'platform:config:form:info', '', 'A', 1, 1, 0, '2021-12-07 09:33:10', '2022-04-20 00:11:53', 3);
INSERT INTO `eb_system_menu` VALUES (77, 360, '整体保存表单数据', '', 'platform:config:save:form', '', 'A', 1, 1, 0, '2021-12-07 09:35:50', '2022-04-22 17:04:13', 3);
INSERT INTO `eb_system_menu` VALUES (78, 48, '经营数据', '', 'platform:statistics:home:operating:data', '', 'A', 1, 1, 0, '2021-12-07 11:41:07', '2022-04-20 16:22:09', 3);
INSERT INTO `eb_system_menu` VALUES (79, 20, '页面布局首页保存', '', 'platform:page:layout:save', '', 'A', 1, 1, 0, '2021-12-07 15:36:08', '2022-05-05 14:59:02', 3);
INSERT INTO `eb_system_menu` VALUES (80, 20, '页面布局首页banner保存', '', 'platform:page:layout:index:banner:save', '', 'A', 1, 1, 0, '2021-12-07 15:36:45', '2022-05-05 14:59:10', 3);
INSERT INTO `eb_system_menu` VALUES (81, 20, '页面布局首页menu保存', '', 'platform:page:layout:index:menu:save', '', 'A', 1, 1, 0, '2021-12-07 15:37:13', '2022-05-05 14:59:20', 3);
INSERT INTO `eb_system_menu` VALUES (82, 20, '页面首页新闻保存', '', 'platform:page:layout:index:news:save', '', 'A', 1, 1, 0, '2021-12-07 15:37:38', '2022-05-05 14:59:29', 3);
INSERT INTO `eb_system_menu` VALUES (83, 20, '页面用户中心导航保存', '', 'platform:page:layout:user:menu:save', '', 'A', 1, 1, 0, '2021-12-07 15:38:32', '2022-05-05 14:59:37', 3);
INSERT INTO `eb_system_menu` VALUES (84, 20, '页面用户中心商品table保存', '', 'platform:page:layout:index:table:save', '', 'A', 1, 1, 0, '2021-12-07 15:38:57', '2022-05-05 14:59:46', 3);
INSERT INTO `eb_system_menu` VALUES (85, 20, '分类页配置保存', '', 'platform:page:layout:category:config:save', '', 'A', 1, 1, 0, '2021-12-07 15:39:29', '2022-05-05 15:00:13', 3);
INSERT INTO `eb_system_menu` VALUES (86, 20, '获取分类页配置', '', 'platform:page:layout:category:config', '', 'A', 1, 1, 0, '2021-12-08 10:25:27', '2022-05-05 15:00:38', 3);
INSERT INTO `eb_system_menu` VALUES (87, 0, '公共服务', '', '', '', 'M', 9989, 0, 0, '2021-12-08 18:56:36', '2022-04-19 23:53:26', 3);
INSERT INTO `eb_system_menu` VALUES (88, 87, '根据key存储', '', 'platform:config:saveuniq', '', 'A', 1, 1, 0, '2021-12-08 18:57:26', '2022-04-20 00:11:53', 3);
INSERT INTO `eb_system_menu` VALUES (89, 87, '根据key获取', '', 'platform:config:getuniq', '', 'A', 1, 1, 0, '2021-12-08 18:58:55', '2022-04-20 00:11:54', 3);
INSERT INTO `eb_system_menu` VALUES (90, 32, '修改图片分组', '', 'platform:attachment:move', '', 'A', 1, 1, 0, '2021-12-10 15:38:24', '2022-04-20 00:01:32', 3);
INSERT INTO `eb_system_menu` VALUES (91, 87, '检测表单name是否存在', '', 'platform:config:check', '', 'A', 1, 1, 0, '2021-12-13 10:30:58', '2022-04-20 00:11:54', 3);
INSERT INTO `eb_system_menu` VALUES (92, 87, '根据key获取配置', '', 'platform:config:get', '', 'A', 1, 1, 0, '2021-12-13 10:31:24', '2022-04-20 00:11:54', 3);
INSERT INTO `eb_system_menu` VALUES (93, 87, '更新配置信息', '', 'platform:config:update', '', 'A', 1, 1, 0, '2021-12-13 10:31:44', '2022-04-20 00:11:54', 3);
INSERT INTO `eb_system_menu` VALUES (94, 87, '组合数据详情', '', 'platform:config:group:info', '', 'A', 1, 1, 0, '2021-12-13 10:32:28', '2022-04-20 00:11:54', 3);
INSERT INTO `eb_system_menu` VALUES (95, 287, '消息通知', '', 'platform:system:notification:list', '/operation/notification', 'C', 10, 1, 0, '2022-02-10 09:58:00', '2022-04-20 00:03:34', 3);
INSERT INTO `eb_system_menu` VALUES (96, 95, '通知详情', '', 'platform:system:notification:detail', '', 'A', 1, 1, 0, '2022-02-10 10:03:42', '2022-04-20 00:04:37', 3);
INSERT INTO `eb_system_menu` VALUES (97, 95, '修改通知', '', 'platform:system:notification:update', '', 'A', 1, 1, 0, '2022-02-10 10:04:27', '2022-04-20 00:04:37', 3);
INSERT INTO `eb_system_menu` VALUES (98, 95, '发送短信开关', '', 'platform:system:notification:sms:switch', '', 'A', 1, 1, 0, '2022-02-17 15:18:09', '2022-04-20 00:04:37', 3);
INSERT INTO `eb_system_menu` VALUES (99, 95, '发送邮件开关', '', 'platform:system:notification:email:switch', '', 'A', 1, 1, 0, '2022-02-17 15:20:18', '2022-04-20 00:04:37', 3);
INSERT INTO `eb_system_menu` VALUES (100, 95, '海外短信开关', '', 'platform:system:notification:oversea:sms:switch', '', 'A', 1, 1, 0, '2022-02-17 15:21:34', '2022-04-20 00:04:37', 3);
INSERT INTO `eb_system_menu` VALUES (101, 53, '平台端登出', '', 'platform:logout', NULL, 'A', 1, 1, 0, '2022-03-03 16:12:33', '2022-04-20 00:19:27', 3);
INSERT INTO `eb_system_menu` VALUES (102, 53, '平台端获取用户详情', '', 'platform:login:user:info', NULL, 'A', 1, 1, 0, '2022-03-03 16:14:10', '2022-04-20 00:19:53', 3);
INSERT INTO `eb_system_menu` VALUES (103, 53, '平台端获取管理员可访问目录', '', 'platform:login:menus', NULL, 'A', 1, 1, 0, '2022-03-03 16:14:56', '2022-04-20 00:19:53', 3);
INSERT INTO `eb_system_menu` VALUES (104, 162, '商户分类分页列表', '', 'platform:merchant:category:list', NULL, 'A', 1, 1, 0, '2022-03-03 17:09:51', '2022-04-20 00:21:11', 3);
INSERT INTO `eb_system_menu` VALUES (105, 162, '添加商户分类', '', 'platform:merchant:category:add', NULL, 'A', 1, 1, 0, '2022-03-03 17:10:02', '2022-04-20 00:21:11', 3);
INSERT INTO `eb_system_menu` VALUES (106, 162, '编辑商户分类', '', 'platform:merchant:category:update', NULL, 'A', 1, 1, 0, '2022-03-03 17:10:06', '2022-04-20 00:21:12', 3);
INSERT INTO `eb_system_menu` VALUES (107, 162, '删除商户分类', '', 'platform:merchant:category:delete', NULL, 'A', 1, 1, 0, '2022-03-03 17:11:04', '2022-04-20 00:21:12', 3);
INSERT INTO `eb_system_menu` VALUES (108, 162, '获取全部商户分类列表', '', 'platform:merchant:category:all', NULL, 'A', 1, 1, 0, '2022-03-03 17:11:08', '2022-04-20 00:21:12', 3);
INSERT INTO `eb_system_menu` VALUES (109, 166, '商户类型分页列表', '', 'platform:merchant:type:list', NULL, 'A', 1, 1, 1, '2022-03-03 17:11:14', '2022-04-20 00:23:12', 3);
INSERT INTO `eb_system_menu` VALUES (110, 166, '添加商户类型', '', 'platform:merchant:type:add', NULL, 'A', 1, 1, 0, '2022-03-03 17:11:15', '2022-04-20 00:23:12', 3);
INSERT INTO `eb_system_menu` VALUES (111, 166, '编辑类型类型', '', 'platform:merchant:type:update', NULL, 'A', 1, 1, 0, '2022-03-03 17:11:23', '2022-04-20 00:23:12', 3);
INSERT INTO `eb_system_menu` VALUES (112, 166, '删除商户类型', '', 'platform:merchant:type:delete', NULL, 'A', 1, 1, 0, '2022-03-03 17:27:04', '2022-04-20 00:23:12', 3);
INSERT INTO `eb_system_menu` VALUES (113, 166, '获取全部商户类型列表', '', 'platform:merchant:type:all', NULL, 'A', 1, 1, 0, '2022-03-03 17:27:54', '2022-04-20 00:23:12', 3);
INSERT INTO `eb_system_menu` VALUES (114, 18, '平台端菜单列表', '', 'platform:menu:list', NULL, 'A', 1, 1, 0, '2022-03-07 11:15:00', '2022-04-20 00:30:48', 3);
INSERT INTO `eb_system_menu` VALUES (115, 18, '新增菜单', NULL, 'platform:menu:add', NULL, 'A', 1, 1, 0, '2022-03-07 11:15:41', '2022-04-20 00:30:48', 3);
INSERT INTO `eb_system_menu` VALUES (116, 18, '删除菜单', NULL, 'platform:menu:delete', NULL, 'A', 1, 1, 0, '2022-03-07 11:15:58', '2022-04-20 00:30:48', 3);
INSERT INTO `eb_system_menu` VALUES (117, 18, '修改菜单', NULL, 'platform:menu:update', NULL, 'A', 1, 1, 0, '2022-03-07 11:16:15', '2022-04-20 00:30:48', 3);
INSERT INTO `eb_system_menu` VALUES (118, 18, '菜单详情', NULL, 'platform:menu:info', NULL, 'A', 1, 1, 0, '2022-03-07 11:16:24', '2022-04-20 00:30:48', 3);
INSERT INTO `eb_system_menu` VALUES (119, 18, '修改菜单显示状态', NULL, 'platform:menu:show:status', NULL, 'A', 1, 1, 0, '2022-03-07 11:16:34', '2022-04-20 00:30:48', 3);
INSERT INTO `eb_system_menu` VALUES (120, 18, '菜单缓存树', NULL, 'platform:menu:cache:tree', NULL, 'A', 1, 1, 0, '2022-03-07 11:16:45', '2022-04-20 00:30:48', 3);
INSERT INTO `eb_system_menu` VALUES (121, 350, '菜单缓存树', NULL, 'merchant:menu:cache:tree', NULL, 'A', 1, 1, 0, '2022-03-07 11:17:18', '2022-04-21 01:00:52', 4);
INSERT INTO `eb_system_menu` VALUES (122, 350, '登出', NULL, 'merchant:logout', NULL, 'A', 1, 1, 0, '2022-03-07 11:17:23', '2022-04-21 01:00:01', 4);
INSERT INTO `eb_system_menu` VALUES (123, 180, '获取登录用户详情', NULL, 'merchant:login:user:info', NULL, 'A', 1, 1, 0, '2022-03-07 11:17:38', '2022-04-20 09:51:27', 4);
INSERT INTO `eb_system_menu` VALUES (124, 350, '获取管理员可访问目录', NULL, 'merchant:login:menus', NULL, 'A', 1, 1, 0, '2022-03-07 11:17:46', '2022-04-21 01:00:10', 4);
INSERT INTO `eb_system_menu` VALUES (125, 165, '商户入驻分页列表', NULL, 'platform:merchant:apply:page:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:10', '2022-04-20 00:32:11', 3);
INSERT INTO `eb_system_menu` VALUES (126, 165, '审核', NULL, 'platform:merchant:apply:audit', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:17', '2022-04-20 00:36:24', 3);
INSERT INTO `eb_system_menu` VALUES (127, 165, '备注', NULL, 'platform:merchant:apply:remark', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:36:24', 3);
INSERT INTO `eb_system_menu` VALUES (128, 163, '商户分页列表', NULL, 'platform:merchant:page:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:37:42', 3);
INSERT INTO `eb_system_menu` VALUES (129, 163, '添加商户', NULL, 'platform:merchant:add', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:37:42', 3);
INSERT INTO `eb_system_menu` VALUES (130, 163, '编辑商户', NULL, 'platform:merchant:update', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-05-14 14:35:25', 3);
INSERT INTO `eb_system_menu` VALUES (131, 163, '修改商户密码', NULL, 'platform:merchant:update:password', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:37:42', 3);
INSERT INTO `eb_system_menu` VALUES (132, 163, '修改复制商品数量', NULL, 'platform:merchant:copy:prodcut:num', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:39:34', 3);
INSERT INTO `eb_system_menu` VALUES (133, 163, '商户详情', NULL, 'platform:merchant:detail', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:37:43', 3);
INSERT INTO `eb_system_menu` VALUES (134, 163, '推荐开关', NULL, 'platform:merchant:recommend:switch', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:39:44', 3);
INSERT INTO `eb_system_menu` VALUES (135, 163, '关闭商户', NULL, 'platform:merchant:close', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:37:43', 3);
INSERT INTO `eb_system_menu` VALUES (136, 163, '开启商户', NULL, 'platform:merchant:open', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:37:43', 3);
INSERT INTO `eb_system_menu` VALUES (137, 164, '平台端商户菜单列表', NULL, 'platform:merchant:menu:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:38:23', 3);
INSERT INTO `eb_system_menu` VALUES (138, 164, '新增菜单', NULL, 'platform:merchant:menu:add', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:38:23', 3);
INSERT INTO `eb_system_menu` VALUES (139, 164, '删除菜单', NULL, 'platform:merchant:menu:delete', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:38:23', 3);
INSERT INTO `eb_system_menu` VALUES (140, 164, '修改菜单', NULL, 'platform:merchant:menu:update', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:38:23', 3);
INSERT INTO `eb_system_menu` VALUES (141, 164, '菜单详情', NULL, 'platform:merchant:menu:info', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:38:23', 3);
INSERT INTO `eb_system_menu` VALUES (142, 164, '修改菜单显示状态', NULL, 'platform:merchant:menu:show:status', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:38:23', 3);
INSERT INTO `eb_system_menu` VALUES (143, 8, '平台端商品分类列表', NULL, 'platform:product:category:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:40:29', 3);
INSERT INTO `eb_system_menu` VALUES (144, 8, '新增分类', NULL, 'platform:product:category:add', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:40:45', 3);
INSERT INTO `eb_system_menu` VALUES (145, 8, '删除分类', NULL, 'platform:product:category:delete', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:40:45', 3);
INSERT INTO `eb_system_menu` VALUES (146, 8, '修改分类', NULL, 'platform:product:category:update', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:40:45', 3);
INSERT INTO `eb_system_menu` VALUES (147, 8, '修改分类显示状态', NULL, 'platform:product:category:show:status', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:40:45', 3);
INSERT INTO `eb_system_menu` VALUES (148, 8, '分类缓存树', NULL, 'platform:product:category:cache:tree', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:40:45', 3);
INSERT INTO `eb_system_menu` VALUES (149, 167, '平台端商品品牌分页列表', NULL, 'platform:product:brand:list', NULL, 'A', 1, 1, 1, '2022-03-07 17:26:31', '2022-04-20 00:41:53', 3);
INSERT INTO `eb_system_menu` VALUES (150, 167, '新增品牌', NULL, 'platform:product:brand:add', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:41:53', 3);
INSERT INTO `eb_system_menu` VALUES (151, 167, '删除品牌', NULL, 'platform:product:brand:delete', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:41:53', 3);
INSERT INTO `eb_system_menu` VALUES (152, 167, '修改品牌', NULL, 'platform:product:brand:update', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:41:53', 3);
INSERT INTO `eb_system_menu` VALUES (153, 167, '修改品牌显示状态', NULL, 'platform:product:brand:show:status', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:41:53', 3);
INSERT INTO `eb_system_menu` VALUES (154, 167, '品牌缓存列表(全部)', NULL, 'platform:product:brand:cache:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:41:54', 3);
INSERT INTO `eb_system_menu` VALUES (155, 160, '平台端商品保障服务列表', NULL, 'platform:product:guarantee:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:42:45', 3);
INSERT INTO `eb_system_menu` VALUES (156, 160, '新增保障服务', NULL, 'platform:product:guarantee:add', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:42:45', 3);
INSERT INTO `eb_system_menu` VALUES (157, 160, '删除保障服务', NULL, 'platform:product:guarantee:delete', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:42:45', 3);
INSERT INTO `eb_system_menu` VALUES (158, 160, '修改保障服务', NULL, 'platform:product:guarantee:update', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:42:46', 3);
INSERT INTO `eb_system_menu` VALUES (159, 160, '修改保障服务显示状态', NULL, 'platform:product:guarantee:show:status', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:42:46', 3);
INSERT INTO `eb_system_menu` VALUES (160, 2, '保障服务', '', 'platform:product:guarantee:list', '/store/guarantee', 'C', 10, 1, 0, '2022-03-14 10:16:06', '2022-04-19 23:36:39', 3);
INSERT INTO `eb_system_menu` VALUES (161, 0, '商户', 's-shop', '', '/merchant', 'M', 9998, 1, 0, '2022-03-14 12:57:51', '2022-04-19 23:52:20', 3);
INSERT INTO `eb_system_menu` VALUES (162, 161, '商户分类', '', '', '/merchant/classify', 'C', 10, 1, 0, '2022-03-14 12:59:57', '2022-04-20 00:05:30', 3);
INSERT INTO `eb_system_menu` VALUES (163, 161, '商户列表', '', '', '/merchant/list', 'C', 10, 1, 0, '2022-03-14 13:01:10', '2022-04-20 00:05:31', 3);
INSERT INTO `eb_system_menu` VALUES (164, 161, '商户菜单管理', '', '', '/merchant/system', 'C', 10, 1, 0, '2022-03-14 13:02:12', '2022-04-20 00:05:31', 3);
INSERT INTO `eb_system_menu` VALUES (165, 161, '商户入驻申请', '', '', '/merchant/application', 'C', 10, 1, 0, '2022-03-14 13:02:55', '2022-04-20 00:05:31', 3);
INSERT INTO `eb_system_menu` VALUES (166, 161, '店铺类型', '', 'platform:merchant:type:list', '/merchant/type', 'C', 10, 1, 0, '2022-03-14 13:03:39', '2022-04-27 15:27:00', 3);
INSERT INTO `eb_system_menu` VALUES (167, 2, '品牌列表', '', 'platform:product:brand:list', '/store/brand', 'C', 10, 1, 0, '2022-03-14 13:14:50', '2022-04-20 11:06:15', 3);
INSERT INTO `eb_system_menu` VALUES (168, 166, '店铺类型', '', '', '/merchant/type/list', 'C', 10, 1, 1, '2022-03-14 16:45:26', '2022-04-20 00:07:19', 3);
INSERT INTO `eb_system_menu` VALUES (169, 166, '店铺类型说明', '', '', '/merchant/type/desc', 'C', 10, 1, 1, '2022-03-14 16:45:53', '2022-04-20 00:07:19', 3);
INSERT INTO `eb_system_menu` VALUES (170, 0, '首页', 's-grid', '', '/dashboard', 'M', 9999, 1, 0, '2022-03-14 17:02:46', '2022-04-24 10:50:50', 4);
INSERT INTO `eb_system_menu` VALUES (171, 0, '商品', 's-goods', '', '/product', 'M', 9999, 1, 0, '2022-03-14 17:05:29', '2022-04-19 23:36:33', 4);
INSERT INTO `eb_system_menu` VALUES (172, 171, '商品列表', '', '', '/product/list', 'C', 10, 1, 0, '2022-03-14 17:24:41', '2022-04-20 09:24:53', 4);
INSERT INTO `eb_system_menu` VALUES (173, 171, '商品分类', '', '', '/product/classify', 'C', 10, 1, 0, '2022-03-14 17:25:39', '2022-04-20 09:24:53', 4);
INSERT INTO `eb_system_menu` VALUES (174, 171, '商品规格', '', '', '/product/attr', 'C', 10, 1, 0, '2022-03-14 17:26:06', '2022-04-20 09:24:53', 4);
INSERT INTO `eb_system_menu` VALUES (175, 171, '商品评价', '', '', '/product/reviews', 'C', 10, 1, 0, '2022-03-14 17:26:33', '2022-04-20 09:24:53', 4);
INSERT INTO `eb_system_menu` VALUES (176, 0, '订单', 's-order', '', '/order', 'M', 9999, 1, 0, '2022-03-14 17:27:37', '2022-04-19 23:36:33', 4);
INSERT INTO `eb_system_menu` VALUES (177, 171, '商品分类', '', '', '/product/classify', 'C', 10, 1, 1, '2022-03-14 17:30:13', '2022-04-20 09:24:53', 4);
INSERT INTO `eb_system_menu` VALUES (178, 176, '订单管理', '', '', '/order/list', 'C', 10, 1, 0, '2022-03-14 17:33:00', '2022-04-20 09:25:02', 4);
INSERT INTO `eb_system_menu` VALUES (179, 176, '退款单', '', '', '/order/refund', 'C', 10, 1, 0, '2022-03-14 17:33:13', '2022-04-20 09:25:02', 4);
INSERT INTO `eb_system_menu` VALUES (180, 0, '用户', 'user-solid', '', '/user', 'M', 9999, 1, 0, '2022-03-14 17:33:47', '2022-04-19 23:36:33', 4);
INSERT INTO `eb_system_menu` VALUES (181, 180, '用户标签', '', '', '/user/label', 'C', 10, 1, 1, '2022-03-14 17:35:22', '2022-04-20 00:13:29', 4);
INSERT INTO `eb_system_menu` VALUES (182, 180, '用户列表', '', '', '/user/index', 'C', 10, 1, 0, '2022-03-14 17:36:23', '2022-04-20 00:13:29', 4);
INSERT INTO `eb_system_menu` VALUES (183, 0, '财务', 's-finance', '', '/accounts', 'M', 9999, 1, 0, '2022-03-14 18:30:51', '2022-04-19 23:36:33', 4);
INSERT INTO `eb_system_menu` VALUES (184, 183, '财务对账', '', '', '/accounts/reconciliation', 'C', 10, 1, 1, '2022-03-14 18:53:06', '2022-04-20 09:25:16', 4);
INSERT INTO `eb_system_menu` VALUES (185, 183, '资金流水', '', '', '/accounts/capitalFlow', 'C', 10, 1, 0, '2022-03-14 18:53:26', '2022-04-20 09:25:16', 4);
INSERT INTO `eb_system_menu` VALUES (186, 183, '转账记录 ', '', '', '/accounts/transManagement', 'C', 10, 1, 0, '2022-03-14 18:53:48', '2022-04-20 09:25:17', 4);
INSERT INTO `eb_system_menu` VALUES (187, 183, '账单管理', '', '', '/accounts/statement', 'C', 10, 1, 0, '2022-03-14 18:55:22', '2022-04-20 09:25:17', 4);
INSERT INTO `eb_system_menu` VALUES (188, 2, '商品列表', NULL, 'platform:product:page:list', '/store/list', 'C', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 11:04:59', 3);
INSERT INTO `eb_system_menu` VALUES (189, 188, '平台端商品审核', NULL, 'platform:product:audit', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:45:32', 3);
INSERT INTO `eb_system_menu` VALUES (190, 188, '平台端强制下架商品', NULL, 'platform:product:force:down', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:45:32', 3);
INSERT INTO `eb_system_menu` VALUES (191, 188, '平台端虚拟销量', NULL, 'platform:product:virtual:sales', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:47:13', 3);
INSERT INTO `eb_system_menu` VALUES (192, 188, '平台端商品详情', NULL, 'platform:product:info', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:45:33', 3);
INSERT INTO `eb_system_menu` VALUES (193, 171, '商户端品牌分页列表', NULL, 'merchant:product:brand:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 10:11:09', 4);
INSERT INTO `eb_system_menu` VALUES (194, 171, '品牌缓存列表(全部)', NULL, 'merchant:product:brand:cache:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 10:11:09', 4);
INSERT INTO `eb_system_menu` VALUES (195, 171, '商户端平台商品分类缓存树', NULL, 'merchant:product:category:cache:tree', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:45:43', 4);
INSERT INTO `eb_system_menu` VALUES (196, 172, '商户端商品分页列表', NULL, 'merchant:product:page:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:46:03', 4);
INSERT INTO `eb_system_menu` VALUES (197, 172, '商户端新增商品', NULL, 'merchant:product:save', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:46:03', 4);
INSERT INTO `eb_system_menu` VALUES (198, 172, '商户端删除商品', NULL, 'merchant:product:delete', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:46:03', 4);
INSERT INTO `eb_system_menu` VALUES (199, 172, '商户端恢复商品', NULL, 'merchant:product:restore', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:46:03', 4);
INSERT INTO `eb_system_menu` VALUES (200, 172, '商户端商品修改', NULL, 'merchant:product:update', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:46:03', 4);
INSERT INTO `eb_system_menu` VALUES (201, 172, '商户端商品详情', NULL, 'merchant:product:info', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:46:03', 4);
INSERT INTO `eb_system_menu` VALUES (202, 172, '商户端商品表头数量', NULL, 'merchant:product:tabs:headers', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:46:04', 4);
INSERT INTO `eb_system_menu` VALUES (203, 172, '商户端商品上架', NULL, 'merchant:product:up', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:46:04', 4);
INSERT INTO `eb_system_menu` VALUES (204, 172, '商户端商品下架', NULL, 'merchant:product:down', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:46:04', 4);
INSERT INTO `eb_system_menu` VALUES (205, 172, '商户端导入99Api商品', NULL, 'merchant:product:import:product', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:46:04', 4);
INSERT INTO `eb_system_menu` VALUES (206, 171, '商户端保障服务列表', NULL, 'merchant:product:guarantee:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 10:11:25', 4);
INSERT INTO `eb_system_menu` VALUES (207, 173, '商户端商户商品分类列表', NULL, 'merchant:store:product:category:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:46:19', 4);
INSERT INTO `eb_system_menu` VALUES (208, 173, '商户端商户商品新增分类', NULL, 'merchant:store:product:category:add', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:46:19', 4);
INSERT INTO `eb_system_menu` VALUES (209, 173, '商户端商户商品删除分类', NULL, 'merchant:store:product:category:delete', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:46:19', 4);
INSERT INTO `eb_system_menu` VALUES (210, 173, '商户端商户商品修改分类', NULL, 'merchant:store:product:category:update', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:46:19', 4);
INSERT INTO `eb_system_menu` VALUES (211, 173, '商户端商户商品修改分类显示状态', NULL, 'merchant:store:product:category:show:status', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:46:19', 4);
INSERT INTO `eb_system_menu` VALUES (212, 173, '商户端商户商品分类缓存树', NULL, 'merchant:store:product:category:cache:tree', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:46:19', 4);
INSERT INTO `eb_system_menu` VALUES (213, 178, '商户端订单分页列表', NULL, 'merchant:order:page:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:49:51', 4);
INSERT INTO `eb_system_menu` VALUES (214, 213, '获取订单各状态数量', NULL, 'merchant:order:status:num', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:50:00', 4);
INSERT INTO `eb_system_menu` VALUES (215, 213, '商户端订单删除', NULL, 'merchant:order:delete', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:50:11', 4);
INSERT INTO `eb_system_menu` VALUES (216, 213, '商户端备注订单', NULL, 'merchant:order:mark', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:50:11', 4);
INSERT INTO `eb_system_menu` VALUES (217, 213, '商户端订单详情', NULL, 'merchant:order:info', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:50:11', 4);
INSERT INTO `eb_system_menu` VALUES (218, 213, '商户端订单发货', NULL, 'merchant:order:send', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:50:11', 4);
INSERT INTO `eb_system_menu` VALUES (219, 213, '商户端订单物流详情', NULL, 'merchant:order:logistics:info', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:50:11', 4);
INSERT INTO `eb_system_menu` VALUES (220, 3, '订单列表', NULL, 'platform:order:page:list', '/order/list', 'C', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 11:25:58', 3);
INSERT INTO `eb_system_menu` VALUES (221, 220, '平台端获取订单各状态数量', NULL, 'platform:order:status:num', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:49:21', 3);
INSERT INTO `eb_system_menu` VALUES (222, 220, '平台端备注', NULL, 'platform:order:mark', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:50:00', 3);
INSERT INTO `eb_system_menu` VALUES (223, 220, '平台端订单详情', NULL, 'platform:order:info', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:49:21', 3);
INSERT INTO `eb_system_menu` VALUES (224, 179, '商户端退款订单分页列表', NULL, 'merchant:refund:order:page:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:50:30', 4);
INSERT INTO `eb_system_menu` VALUES (225, 179, '商户端获取退款订单各状态数量', NULL, 'merchant:refund:order:status:num', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:50:30', 4);
INSERT INTO `eb_system_menu` VALUES (226, 179, '商户备注退款订单', NULL, 'merchant:refund:order:mark', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:50:30', 4);
INSERT INTO `eb_system_menu` VALUES (227, 179, '商户端订单退款', NULL, 'merchant:refund:order:refund', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:50:30', 4);
INSERT INTO `eb_system_menu` VALUES (228, 179, '商户端拒绝退款', NULL, 'merchant:refund:order:refund:refuse', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-06-13 14:44:21', 4);
INSERT INTO `eb_system_menu` VALUES (229, 3, '退款单', NULL, 'platform:refund:order:page:list', '/order/refund', 'C', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 11:28:06', 3);
INSERT INTO `eb_system_menu` VALUES (230, 229, '平台端获取退款订单各状态数量', NULL, 'platform:refund:order:status:num', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:49:29', 3);
INSERT INTO `eb_system_menu` VALUES (231, 229, '平台备注退款订单', NULL, 'platform:refund:order:mark', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:49:29', 3);
INSERT INTO `eb_system_menu` VALUES (232, 0, '设置', 's-tools', '', '/operation', 'M', 9999, 1, 0, '2022-03-26 11:29:43', '2022-04-19 23:36:33', 4);
INSERT INTO `eb_system_menu` VALUES (233, 346, '查询表单模板信息', NULL, 'admin:system:form:info', NULL, 'A', 1, 0, 0, '2022-03-26 11:57:15', '2022-04-21 01:01:03', 4);
INSERT INTO `eb_system_menu` VALUES (234, 174, '商户端商品规则值(规格)分页列表', NULL, 'merchant:product:rule:page:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:46:31', 4);
INSERT INTO `eb_system_menu` VALUES (235, 174, '商户端商品规则值(规格)新增', NULL, 'merchant:product:rule:save', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:46:31', 4);
INSERT INTO `eb_system_menu` VALUES (236, 174, '商户端商品规则值(规格)删除', NULL, 'merchant:product:rule:delete', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:46:31', 4);
INSERT INTO `eb_system_menu` VALUES (237, 174, '商户端商品规则值(规格)修改', NULL, 'merchant:product:rule:update', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:46:32', 4);
INSERT INTO `eb_system_menu` VALUES (238, 174, '商户端商品规则值(规格)详情', NULL, 'merchant:product:rule:info', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:46:32', 4);
INSERT INTO `eb_system_menu` VALUES (239, 232, '商户基本设置', '', '', '/operation/modifyStoreInfo', 'C', 10, 1, 0, '2022-03-26 17:19:23', '2022-04-20 09:25:30', 4);
INSERT INTO `eb_system_menu` VALUES (240, 366, '角色管理', '', '', '/operation/roleManager/identityManager', 'C', 10, 1, 0, '2022-03-26 17:21:03', '2022-04-24 16:02:20', 4);
INSERT INTO `eb_system_menu` VALUES (241, 232, '商城设置', '', '', '/operation/mallConfiguration', 'C', 10, 0, 0, '2022-03-26 17:43:18', '2022-04-20 09:25:30', 4);
INSERT INTO `eb_system_menu` VALUES (242, 248, '商户端优惠券分页列表', NULL, 'merchant:coupon:page:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:54:09', 4);
INSERT INTO `eb_system_menu` VALUES (243, 248, '商户端新增优惠券', NULL, 'merchant:coupon:save', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:54:09', 4);
INSERT INTO `eb_system_menu` VALUES (244, 248, '商户端修改优惠券状态', NULL, 'merchant:coupon:update:status', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:54:09', 4);
INSERT INTO `eb_system_menu` VALUES (245, 248, '商户端优惠券详情', NULL, 'merchant:coupon:info', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:54:09', 4);
INSERT INTO `eb_system_menu` VALUES (246, 248, '商户端删除优惠券', NULL, 'merchant:coupon:delete', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:54:09', 4);
INSERT INTO `eb_system_menu` VALUES (247, 0, '优惠券', 's-ticket', '', '/coupon', 'M', 10, 1, 0, '2022-03-28 11:10:10', '2022-04-24 15:49:36', 4);
INSERT INTO `eb_system_menu` VALUES (248, 247, '优惠券列表', '', '', '/coupon/list', 'C', 10, 1, 0, '2022-03-28 11:12:30', '2022-04-24 15:49:24', 4);
INSERT INTO `eb_system_menu` VALUES (249, 247, '领取记录', '', 'merchant:coupon:user:page:list', '/coupon/record', 'C', 10, 1, 0, '2022-03-28 11:13:42', '2022-05-05 12:06:03', 4);
INSERT INTO `eb_system_menu` VALUES (250, 284, '素材管理', '', '', '/maintain/picture', 'C', 10, 1, 0, '2022-03-28 15:58:34', '2022-04-20 09:27:27', 4);
INSERT INTO `eb_system_menu` VALUES (251, 285, '物流公司', '', '', '/maintain/logistics/companyList', 'C', 10, 1, 1, '2022-03-28 18:14:31', '2022-04-20 09:28:02', 4);
INSERT INTO `eb_system_menu` VALUES (252, 232, '数据导出', '', '', '/operation/export', 'C', 10, 1, 1, '2022-03-28 18:26:12', '2022-04-20 09:28:52', 4);
INSERT INTO `eb_system_menu` VALUES (253, 2, '商品评论', NULL, 'platform:product:reply:list', '/store/comment', 'C', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 11:12:28', 3);
INSERT INTO `eb_system_menu` VALUES (254, 253, '平台端删除评论', NULL, 'platform:product:reply:delete', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:46:16', 3);
INSERT INTO `eb_system_menu` VALUES (255, 175, '商户端商品评论分页列表', NULL, 'merchant:product:reply:page:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:46:40', 4);
INSERT INTO `eb_system_menu` VALUES (256, 255, '商户端虚拟评论', NULL, 'merchant:product:reply:virtual', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 10:08:28', 4);
INSERT INTO `eb_system_menu` VALUES (257, 255, '商户端删除评论', NULL, 'merchant:product:reply:delete', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 10:08:28', 4);
INSERT INTO `eb_system_menu` VALUES (258, 255, '商户端回复评论', NULL, 'merchant:product:reply:comment', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 10:08:28', 4);
INSERT INTO `eb_system_menu` VALUES (259, 3, '退款单', '', '', '/order/refund', 'C', 10, 1, 1, '2022-03-30 16:16:12', '2022-04-20 10:31:54', 3);
INSERT INTO `eb_system_menu` VALUES (260, 282, '平台端活动分页列表', NULL, 'platform:activity:page:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:51:00', 3);
INSERT INTO `eb_system_menu` VALUES (261, 282, '平台端添加活动', NULL, 'platform:activity:add', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:51:00', 3);
INSERT INTO `eb_system_menu` VALUES (262, 282, '平台备删除活动', NULL, 'platform:activity:delete', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:51:00', 3);
INSERT INTO `eb_system_menu` VALUES (263, 282, '平台端编辑活动', NULL, 'platform:activity:update', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:51:00', 3);
INSERT INTO `eb_system_menu` VALUES (264, 282, '平台备活动详情', NULL, 'platform:activity:info', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:51:00', 3);
INSERT INTO `eb_system_menu` VALUES (265, 282, '平台端活动开关', NULL, 'platform:activity:switch', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:51:00', 3);
INSERT INTO `eb_system_menu` VALUES (266, 4, '用户列表', NULL, 'platform:user:page:list', '/user/index', 'C', 10, 1, 0, '2022-03-07 17:26:31', '2022-04-21 22:03:29', 3);
INSERT INTO `eb_system_menu` VALUES (267, 266, '平台端修改用户信息', NULL, 'platform:user:update', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-21 22:05:07', 3);
INSERT INTO `eb_system_menu` VALUES (268, 266, '平台用户详情', NULL, 'platform:user:info', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-21 22:05:18', 3);
INSERT INTO `eb_system_menu` VALUES (269, 266, '平台端获取用户消费记录', NULL, 'platform:user:expenses:record', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-21 22:05:29', 3);
INSERT INTO `eb_system_menu` VALUES (270, 266, '平台端获取用户持有优惠券', NULL, 'platform:user:have:coupons', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-21 22:05:38', 3);
INSERT INTO `eb_system_menu` VALUES (271, 266, '平台端用户详情页Top数据', NULL, 'platform:user:topdetail', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-21 22:05:47', 3);
INSERT INTO `eb_system_menu` VALUES (272, 4, '平台端用户分配分组', NULL, 'platform:user:group', NULL, 'A', 1, 1, 1, '2022-03-07 17:26:31', '2022-04-20 00:53:09', 3);
INSERT INTO `eb_system_menu` VALUES (273, 266, '平台端用户分配标签', NULL, 'platform:user:tag', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-21 22:06:05', 3);
INSERT INTO `eb_system_menu` VALUES (274, 182, '商户端用户分页列表', NULL, 'merchant:user:page:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:51:03', 4);
INSERT INTO `eb_system_menu` VALUES (275, 176, '商户端查询全部物流公司', NULL, 'merchant:express:all', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-05-05 12:01:44', 4);
INSERT INTO `eb_system_menu` VALUES (276, 35, '平台端物流公司分页列表', NULL, 'platform:express:page:list', NULL, 'A', 1, 1, 1, '2022-03-07 17:26:31', '2022-04-20 00:54:02', 3);
INSERT INTO `eb_system_menu` VALUES (277, 369, '平台端物流公司修改显示状态', NULL, 'platform:express:update:show', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-05-11 11:07:24', 3);
INSERT INTO `eb_system_menu` VALUES (278, 373, '平台端敏感操作日志分页列表', NULL, 'platform:log:sensitive:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-05-09 15:35:03', 3);
INSERT INTO `eb_system_menu` VALUES (279, 284, '商户端敏感操作日志分页列表', NULL, 'merchant:log:sensitive:list', NULL, 'A', 1, 1, 1, '2022-03-07 17:26:31', '2022-04-20 10:14:16', 4);
INSERT INTO `eb_system_menu` VALUES (280, 20, '页面用户中心banner保存', NULL, 'platform:page:layout:user:banner:save', NULL, 'A', 1, 1, 0, '2022-03-31 18:55:02', '2022-05-05 15:00:28', 3);
INSERT INTO `eb_system_menu` VALUES (281, 288, '平台端短信发送记录', NULL, 'platform:sms:recored', NULL, 'A', 1, 1, 0, '2022-03-31 19:17:38', '2022-04-20 00:55:28', 3);
INSERT INTO `eb_system_menu` VALUES (282, 0, '活动', 's-data', '', '/activity', 'M', 9988, 1, 0, '2022-03-31 19:34:18', '2022-04-19 23:53:36', 3);
INSERT INTO `eb_system_menu` VALUES (283, 282, '活动列表', '', '', '/activity/list', 'C', 10, 1, 0, '2022-03-31 19:35:21', '2022-04-20 00:08:03', 3);
INSERT INTO `eb_system_menu` VALUES (284, 0, '维护', 's-open', '', '/maintain', 'M', 9999, 1, 0, '2022-04-01 09:18:45', '2022-04-19 23:36:33', 4);
INSERT INTO `eb_system_menu` VALUES (285, 232, '物流设置', '', '', '/maintain/logistics', 'C', 10, 1, 1, '2022-04-01 09:23:05', '2022-04-20 09:27:56', 4);
INSERT INTO `eb_system_menu` VALUES (286, 284, '敏感操作日志', '', 'merchant:log:sensitive:list', '/maintain/sensitiveLog', 'C', 10, 1, 0, '2022-04-01 09:23:52', '2022-04-21 01:05:41', 4);
INSERT INTO `eb_system_menu` VALUES (287, 0, '通知', 'message-solid', '', '', 'M', 9987, 1, 0, '2022-04-01 17:08:47', '2022-04-19 23:53:46', 3);
INSERT INTO `eb_system_menu` VALUES (288, 287, '短信记录', '', '', '/operation/messageRecord', 'C', 10, 1, 0, '2022-04-01 17:10:30', '2022-04-20 00:03:34', 3);
INSERT INTO `eb_system_menu` VALUES (289, 315, '平台端资金流水分页列表', NULL, 'platform:finance:monitor:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:56:04', 3);
INSERT INTO `eb_system_menu` VALUES (290, 315, '平台端资金流水详情', NULL, 'platform:finance:monitor:info', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:56:04', 3);
INSERT INTO `eb_system_menu` VALUES (291, 185, '商户端资金流水分页列表', NULL, 'merchant:finance:monitor:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:52:15', 4);
INSERT INTO `eb_system_menu` VALUES (292, 239, '商户端商户基础信息', NULL, 'merchant:base:info', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 10:04:43', 4);
INSERT INTO `eb_system_menu` VALUES (293, 239, '商户端商户配置信息', NULL, 'merchant:config:info', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 10:04:43', 4);
INSERT INTO `eb_system_menu` VALUES (294, 186, '商户端商户转账信息', NULL, 'merchant:transfer:info', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:52:29', 4);
INSERT INTO `eb_system_menu` VALUES (295, 239, '商户端商户配置信息编辑', NULL, 'merchant:config:info:edit', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 10:04:43', 4);
INSERT INTO `eb_system_menu` VALUES (296, 186, '商户端商户转账信息编辑', NULL, 'merchant:transfer:info:edit', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:52:29', 4);
INSERT INTO `eb_system_menu` VALUES (297, 239, '商户端商户开关', NULL, 'merchant:switch:update', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 10:04:43', 4);
INSERT INTO `eb_system_menu` VALUES (298, 32, '图片上传', '', 'platform:upload:image', '', 'A', 1, 1, 0, '2022-04-06 17:13:36', '2022-04-20 00:01:33', 3);
INSERT INTO `eb_system_menu` VALUES (299, 32, '文件上传', '', 'platform:upload:file', '', 'A', 1, 1, 0, '2022-04-06 17:14:12', '2022-04-20 00:01:35', 3);
INSERT INTO `eb_system_menu` VALUES (300, 250, '素材列表', '', 'merchant:attachment:list', '', 'A', 1, 1, 0, '2022-04-06 19:45:21', '2022-04-20 09:55:00', 4);
INSERT INTO `eb_system_menu` VALUES (301, 250, '素材删除', '', 'merchant:attachment:delete', '', 'A', 1, 1, 0, '2022-04-06 19:45:45', '2022-04-20 09:55:00', 4);
INSERT INTO `eb_system_menu` VALUES (302, 250, '移动素材', '', 'merchant:attachment:move', '', 'A', 1, 1, 0, '2022-04-06 19:46:08', '2022-04-20 09:55:00', 4);
INSERT INTO `eb_system_menu` VALUES (303, 186, '商户端获取转账申请基础信息', NULL, 'merchant:finance:transfer:base:info', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:52:30', 4);
INSERT INTO `eb_system_menu` VALUES (304, 186, '商户端转账申请', NULL, 'merchant:finance:transfer:apply', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:52:30', 4);
INSERT INTO `eb_system_menu` VALUES (305, 186, '商户端转账记录分页列表', NULL, 'merchant:finance:transfer:record:page:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:52:30', 4);
INSERT INTO `eb_system_menu` VALUES (306, 186, '商户端转账记录详情', NULL, 'merchant:finance:transfer:record:info', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:52:30', 4);
INSERT INTO `eb_system_menu` VALUES (307, 326, '平台端获取转账设置', NULL, 'platform:finance:transfer:config', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:56:44', 3);
INSERT INTO `eb_system_menu` VALUES (308, 326, '平台端编辑转账设置', NULL, 'platform:finance:transfer:config:edit', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:56:44', 3);
INSERT INTO `eb_system_menu` VALUES (309, 325, '平台端转账记录分页列表', NULL, 'platform:finance:transfer:record:page:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:57:34', 3);
INSERT INTO `eb_system_menu` VALUES (310, 325, '平台端转账记录详情', NULL, 'platform:finance:transfer:record:info', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:57:34', 3);
INSERT INTO `eb_system_menu` VALUES (311, 325, '平台端转账审核', NULL, 'platform:finance:transfer:audit', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:57:34', 3);
INSERT INTO `eb_system_menu` VALUES (312, 325, '平台端转账凭证', NULL, 'platform:finance:transfer:proof', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:57:34', 3);
INSERT INTO `eb_system_menu` VALUES (313, 325, '平台端转账备注', NULL, 'platform:finance:transfer:remark', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:57:35', 3);
INSERT INTO `eb_system_menu` VALUES (314, 266, '平台端用户分配标签', NULL, 'platform:user:tag', NULL, 'A', 1, 1, 1, '2022-03-07 17:26:31', '2022-04-21 22:06:19', 3);
INSERT INTO `eb_system_menu` VALUES (315, 5, '资金流水', '', '', '/financial/capitalFlow', 'C', 10, 1, 0, '2022-04-07 16:44:24', '2022-04-19 23:36:39', 3);
INSERT INTO `eb_system_menu` VALUES (316, 0, '基础分类(素材/设置/文章)', '', '', '', 'M', 9999, 0, 1, '2022-04-07 16:44:28', '2022-04-19 23:36:33', 4);
INSERT INTO `eb_system_menu` VALUES (317, 351, '分类列表', '', 'merchant:category:list', '', 'A', 1, 1, 0, '2022-04-07 16:45:03', '2022-04-21 01:02:32', 4);
INSERT INTO `eb_system_menu` VALUES (318, 351, '分类新增', '', 'merchant:category:save', '', 'A', 1, 1, 0, '2022-04-07 16:45:26', '2022-04-21 01:02:41', 4);
INSERT INTO `eb_system_menu` VALUES (319, 351, '分类删除', '', 'merchant:category:delete', '', 'A', 1, 1, 0, '2022-04-07 16:46:09', '2022-04-21 01:03:00', 4);
INSERT INTO `eb_system_menu` VALUES (320, 351, '修改分类', '', 'merchant:category:update', '', 'A', 1, 1, 0, '2022-04-07 16:46:41', '2022-04-21 01:02:47', 4);
INSERT INTO `eb_system_menu` VALUES (321, 351, '分类详情', '', 'merchant:category:info', '', 'A', 1, 1, 0, '2022-04-07 16:46:59', '2022-04-21 01:02:54', 4);
INSERT INTO `eb_system_menu` VALUES (322, 351, '分类tree', '', 'merchant:category:list:tree', '', 'A', 1, 1, 0, '2022-04-07 16:47:19', '2022-04-21 01:03:12', 4);
INSERT INTO `eb_system_menu` VALUES (323, 351, '分类ids', '', 'merchant:category:list:ids', '', 'A', 1, 1, 0, '2022-04-07 16:47:38', '2022-04-21 01:03:07', 4);
INSERT INTO `eb_system_menu` VALUES (324, 351, '分类状态修改', '', 'merchant:category:update:status', '', 'A', 1, 1, 0, '2022-04-07 16:48:04', '2022-04-21 01:03:18', 4);
INSERT INTO `eb_system_menu` VALUES (325, 5, '转账记录', '', '', '/financial/transferRecord', 'C', 10, 1, 0, '2022-04-07 18:10:21', '2022-04-19 23:36:39', 3);
INSERT INTO `eb_system_menu` VALUES (326, 5, '转账设置', '', '', '/financial/setting', 'C', 10, 1, 0, '2022-04-07 18:12:20', '2022-04-19 23:36:39', 3);
INSERT INTO `eb_system_menu` VALUES (327, 240, '角色列表', '', 'merchant:admin:role:list', '', 'A', 1, 1, 0, '2022-04-07 20:40:35', '2022-04-21 01:03:43', 4);
INSERT INTO `eb_system_menu` VALUES (328, 240, '创建角色', '', 'merchant:admin:role:save', '', 'A', 1, 1, 0, '2022-04-07 20:41:06', '2022-04-21 01:03:52', 4);
INSERT INTO `eb_system_menu` VALUES (329, 240, '删除角色', '', 'merchant:admin:role:delete', '', 'A', 1, 1, 0, '2022-04-07 20:41:33', '2022-04-21 01:03:57', 4);
INSERT INTO `eb_system_menu` VALUES (330, 240, '更新角色', '', 'merchant:admin:role:update', '', 'A', 1, 1, 0, '2022-04-07 20:41:54', '2022-04-21 01:04:03', 4);
INSERT INTO `eb_system_menu` VALUES (331, 240, '角色详情', '', 'merchant:admin:role:info', '', 'A', 1, 1, 0, '2022-04-07 20:42:15', '2022-04-21 01:04:08', 4);
INSERT INTO `eb_system_menu` VALUES (332, 240, '修改角色状态', '', 'merchant:admin:role:update:status', '', 'A', 1, 1, 0, '2022-04-07 20:42:42', '2022-04-21 01:04:14', 4);
INSERT INTO `eb_system_menu` VALUES (333, 183, '商户端日帐单管理分页列表', '', 'merchant:finance:daily:statement:page:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:53:04', 4);
INSERT INTO `eb_system_menu` VALUES (334, 183, '商户端月帐单管理分页列表', '', 'merchant:finance:month:statement:page:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 09:53:04', 4);
INSERT INTO `eb_system_menu` VALUES (335, 5, '平台端日帐单管理分页列表', '', 'platform:finance:daily:statement:page:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:59:29', 3);
INSERT INTO `eb_system_menu` VALUES (336, 5, '平台端月帐单管理分页列表', '', 'platform:finance:month:statement:page:list', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-20 00:59:29', 3);
INSERT INTO `eb_system_menu` VALUES (337, 5, '账单管理', '', '', '/financial/statement', 'C', 10, 1, 0, '2022-04-08 19:25:19', '2022-04-19 23:36:39', 3);
INSERT INTO `eb_system_menu` VALUES (338, 346, '文件上传', '', 'merchant:upload:file', '', 'A', 1, 1, 0, '2022-04-09 11:09:52', '2022-04-21 01:04:21', 4);
INSERT INTO `eb_system_menu` VALUES (339, 346, '图片上传', '', 'merchant:upload:image', '', 'A', 1, 1, 0, '2022-04-09 11:10:34', '2022-04-21 01:04:27', 4);
INSERT INTO `eb_system_menu` VALUES (340, 0, '表单组件', '', '', '', 'M', 9999, 0, 1, '2022-04-12 10:58:22', '2022-04-19 23:36:33', 4);
INSERT INTO `eb_system_menu` VALUES (341, 346, '表单组件详情', '', 'merchant:config:form:info', '', 'A', 1, 1, 0, '2022-04-12 10:58:48', '2022-04-21 01:05:56', 4);
INSERT INTO `eb_system_menu` VALUES (342, 87, '加载表单配置详情', '', 'platform:config:info', '', 'A', 1, 1, 0, '2022-04-12 14:26:15', '2022-04-20 00:11:54', 3);
INSERT INTO `eb_system_menu` VALUES (343, 87, '加载表单配置详情', '', 'platform:config:info', '', 'A', 1, 1, 0, '2022-04-12 14:26:16', '2022-04-20 00:11:54', 3);
INSERT INTO `eb_system_menu` VALUES (344, 188, '修改商品后台排序', NULL, 'platform:product:update:rank', NULL, 'A', 1, 1, 0, '2022-04-13 16:22:43', '2022-04-20 00:45:33', 3);
INSERT INTO `eb_system_menu` VALUES (345, 163, '商户分页列表表头数量', NULL, 'platform:merchant:list:header:num', NULL, 'A', 1, 1, 0, '2022-03-07 17:26:31', '2022-04-22 17:02:48', 3);
INSERT INTO `eb_system_menu` VALUES (346, 0, '公共', '', '', '', 'M', 8888, 0, 0, '2022-04-20 12:16:30', '2022-04-21 00:59:32', 4);
INSERT INTO `eb_system_menu` VALUES (347, 346, '获取公共配置1', '', 'merchant:config:get', '', 'A', 0, 1, 0, '2022-04-20 12:17:05', '2022-04-20 12:17:05', 4);
INSERT INTO `eb_system_menu` VALUES (348, 346, '获取公共配置2', '', 'merchant:config:getuniq', '', 'A', 0, 1, 0, '2022-04-20 12:17:31', '2022-04-20 12:17:31', 4);
INSERT INTO `eb_system_menu` VALUES (349, 48, '用户渠道数据', '', 'platform:statistics:home:user:channel', '', 'A', 1, 1, 0, '2022-04-20 16:22:39', '2022-04-20 16:22:39', 3);
INSERT INTO `eb_system_menu` VALUES (350, 0, '登录管理', '', '', '', 'M', 8888, 0, 0, '2022-04-21 00:50:52', '2022-04-21 00:59:17', 4);
INSERT INTO `eb_system_menu` VALUES (351, 0, '基础分类(素材/设置/文章)', '', '', '', 'M', 8888, 0, 0, '2022-04-21 01:02:22', '2022-04-21 01:05:01', 4);
INSERT INTO `eb_system_menu` VALUES (352, 170, '首页数据', '', 'merchant:statistics:home:index', '', 'A', 0, 1, 0, '2022-04-21 01:06:43', '2022-04-21 01:06:43', 4);
INSERT INTO `eb_system_menu` VALUES (353, 170, '经营数据', '', 'merchant:statistics:home:operating:data', '', 'A', 0, 1, 0, '2022-04-21 01:07:06', '2022-04-21 01:07:06', 4);
INSERT INTO `eb_system_menu` VALUES (354, 4, '用户标签', '', 'platform:user:tag:list', '/user/label', 'C', 10, 1, 0, '2022-04-21 22:03:11', '2022-04-22 10:05:34', 3);
INSERT INTO `eb_system_menu` VALUES (355, 354, '新增用户标签', '', 'platform:user:tag:save', '', 'A', 1, 1, 0, '2022-04-21 22:04:01', '2022-04-21 22:04:01', 3);
INSERT INTO `eb_system_menu` VALUES (356, 354, '删除用户标签', '', 'platform:user:tag:delete', '', 'A', 1, 1, 0, '2022-04-21 22:04:16', '2022-05-14 17:59:25', 3);
INSERT INTO `eb_system_menu` VALUES (357, 354, '修改用户标签', '', 'platform:user:tag:update', '', 'A', 1, 1, 0, '2022-04-21 22:04:31', '2022-04-21 22:04:31', 3);
INSERT INTO `eb_system_menu` VALUES (358, 354, '用户标签全部列表', '', 'platform:user:tag:all:list', '', 'A', 1, 1, 0, '2022-04-21 22:04:47', '2022-04-21 22:04:47', 3);
INSERT INTO `eb_system_menu` VALUES (359, 0, 'test', '', '', '/product/classify?id=1', 'C', 0, 1, 1, '2022-04-22 10:56:39', '2022-04-22 10:58:21', 4);
INSERT INTO `eb_system_menu` VALUES (360, 6, '平台设置', '', 'platform:config:info', '/operation/setting', 'C', 11, 1, 0, '2022-04-22 17:03:59', '2022-04-22 17:04:22', 3);
INSERT INTO `eb_system_menu` VALUES (361, 53, '修改登录用户信息', '', 'platform:login:admin:update', '', 'A', 1, 1, 0, '2022-04-24 10:31:28', '2022-04-24 10:31:53', 3);
INSERT INTO `eb_system_menu` VALUES (362, 350, '修改登录用户信息', '', 'merchant:login:admin:update', '', 'A', 1, 1, 0, '2022-04-24 10:37:32', '2022-04-24 10:37:48', 4);
INSERT INTO `eb_system_menu` VALUES (363, 247, '商品可用优惠券列表', '', 'merchant:coupon:product:usable:list', '', 'A', 1, 1, 0, '2022-04-24 14:36:41', '2022-04-24 14:36:41', 4);
INSERT INTO `eb_system_menu` VALUES (364, 0, '优惠券', 's-ticket', '', '/coupon', 'M', 0, 1, 1, '2022-04-24 15:47:24', '2022-04-24 15:47:24', 4);
INSERT INTO `eb_system_menu` VALUES (365, 366, '管理员列表', '', 'merchant:admin:list', '/operation/roleManager/adminList', 'C', 0, 1, 0, '2022-04-24 15:59:06', '2022-05-05 10:12:09', 4);
INSERT INTO `eb_system_menu` VALUES (366, 232, '管理权限', '', '', '/operation/roleManager', 'C', 0, 1, 0, '2022-04-24 16:01:28', '2022-04-24 16:01:28', 4);
INSERT INTO `eb_system_menu` VALUES (367, 166, '入驻协议', '', '', '/merchant/type/accord', 'C', 1, 1, 0, '2022-04-27 15:19:36', '2022-05-09 15:19:05', 3);
INSERT INTO `eb_system_menu` VALUES (368, 166, '店铺类型', '', '', '/merchant/type/list', 'C', 1, 1, 0, '2022-04-27 15:26:16', '2022-04-27 15:28:01', 3);
INSERT INTO `eb_system_menu` VALUES (369, 35, '物流公司', '', 'platform:express:page:list', '/maintain/logistics/companyList', 'C', 0, 1, 0, '2022-05-05 10:30:21', '2022-05-11 11:05:35', 3);
INSERT INTO `eb_system_menu` VALUES (370, 20, '页面首页排行入口保存', '', 'platform:page:layout:index:ranking:save', '', 'A', 1, 1, 0, '2022-05-05 15:01:21', '2022-05-05 15:01:21', 3);
INSERT INTO `eb_system_menu` VALUES (371, 188, '商品表头数量', '', 'platform:product:tabs:headers', '', 'A', 1, 1, 0, '2022-05-06 15:06:26', '2022-05-06 15:06:26', 3);
INSERT INTO `eb_system_menu` VALUES (372, 3, '平台端订单物流详情', '', 'platform:order:logistics:info', '', 'A', 0, 1, 0, '2022-05-07 15:40:33', '2022-05-07 15:40:33', 3);
INSERT INTO `eb_system_menu` VALUES (373, 7, '敏感操作日志', '', '', '/maintain/sensitiveLog', 'C', 0, 1, 0, '2022-05-09 15:34:50', '2022-05-09 15:36:58', 3);
INSERT INTO `eb_system_menu` VALUES (374, 365, '新增后台管理员', '', 'merchant:admin:save', '', 'A', 0, 1, 0, '2022-05-11 15:30:05', '2022-05-11 15:30:05', 4);
INSERT INTO `eb_system_menu` VALUES (375, 365, '删除后台管理员', '', 'merchant:admin:delete', '', 'A', 0, 1, 0, '2022-05-11 15:30:29', '2022-05-11 15:30:29', 4);
INSERT INTO `eb_system_menu` VALUES (376, 365, '修改后台管理员', '', 'merchant:admin:update', '', 'A', 0, 1, 0, '2022-05-11 15:30:45', '2022-05-11 15:30:45', 4);
INSERT INTO `eb_system_menu` VALUES (377, 365, '后台管理员详情', '', 'merchant:admin:info', '', 'A', 0, 1, 0, '2022-05-11 15:31:04', '2022-05-11 15:31:04', 4);
INSERT INTO `eb_system_menu` VALUES (378, 365, '修改后台管理员状态', '', 'merchant:admin:update:status', '', 'A', 0, 1, 0, '2022-05-11 15:31:18', '2022-05-11 15:31:18', 4);
INSERT INTO `eb_system_menu` VALUES (379, 350, '商户端获取用户详情', '', 'merchant:login:user:info', '', 'A', 0, 1, 0, '2022-05-16 15:54:43', '2022-05-16 15:54:43', 4);
INSERT INTO `eb_system_menu` VALUES (380, 6, '协议管理', '', '', '/operation/agreement', 'C', 1, 1, 0, '2022-06-13 10:10:52', '2022-06-13 10:11:16', 3);
INSERT INTO `eb_system_menu` VALUES (381, 20, '底部导航获取', '', 'platform:page:layout:bottom:navigation', '', 'A', 1, 1, 0, '2023-08-08 12:04:03', '2023-08-08 12:04:03', 3);
INSERT INTO `eb_system_menu` VALUES (382, 20, '底部导航保存', '', 'platform:page:layout:bottom:navigation:save', '', 'A', 1, 1, 0, '2023-08-08 12:04:26', '2023-08-08 12:04:26', 3);
INSERT INTO `eb_system_menu` VALUES (383, 173, '平台端商品分类列表', '', 'merchant:product:category:cache:tree', '', 'A', 1, 1, 0, '2023-08-10 18:31:43', '2023-08-10 18:31:43', 4);
INSERT INTO `eb_system_menu` VALUES (384, 368, '店铺类型分页列表', '', 'platform:merchant:type:list', '', 'A', 1, 1, 0, '2023-08-12 15:31:46', '2023-08-12 15:31:46', 3);
INSERT INTO `eb_system_menu` VALUES (385, 0, '营销', 's-marketing', '', '/marketing', 'M', 9996, 1, 0, '2025-04-03 11:02:12', '2025-04-03 11:02:59', 3);
INSERT INTO `eb_system_menu` VALUES (386, 385, '种草社区', '', '', '/marketing/community', 'M', 1, 1, 0, '2025-04-03 11:03:36', '2025-04-03 11:03:36', 3);
INSERT INTO `eb_system_menu` VALUES (387, 386, '社区内容', '', '', '/marketing/community/content', 'C', 1, 1, 0, '2025-04-03 11:04:22', '2025-04-03 11:04:22', 3);
INSERT INTO `eb_system_menu` VALUES (388, 387, '社区笔记分页列表', '', 'platform:community:note:page:list', '', 'A', 1, 1, 0, '2025-04-03 11:26:11', '2025-04-03 11:26:11', 3);
INSERT INTO `eb_system_menu` VALUES (389, 387, '社区笔记详情', '', 'platform:community:note:detail', '', 'A', 1, 1, 0, '2025-04-03 11:26:33', '2025-04-03 11:31:29', 3);
INSERT INTO `eb_system_menu` VALUES (390, 387, '社区笔记审核', '', 'platform:community:note:audit', '', 'A', 1, 1, 0, '2025-04-03 11:26:54', '2025-04-03 11:26:54', 3);
INSERT INTO `eb_system_menu` VALUES (391, 387, '社区笔记强制下架', '', 'platform:community:note:forced:down', '', 'A', 1, 1, 0, '2025-04-03 11:27:23', '2025-04-03 11:27:23', 3);
INSERT INTO `eb_system_menu` VALUES (392, 387, '社区笔记强制下架', '', 'platform:community:note:forced:down', '', 'A', 1, 1, 1, '2025-04-03 11:27:23', '2025-04-03 11:27:23', 3);
INSERT INTO `eb_system_menu` VALUES (393, 387, '社区笔记删除', '', 'platform:community:note:delete', '', 'A', 1, 1, 0, '2025-04-03 11:28:20', '2025-04-03 11:28:20', 3);
INSERT INTO `eb_system_menu` VALUES (394, 387, '社区笔记分类批量修改', '', 'platform:community:note:category:batch:update', '', 'A', 1, 1, 0, '2025-04-03 11:28:49', '2025-04-03 11:28:49', 3);
INSERT INTO `eb_system_menu` VALUES (395, 387, '社区笔记推荐星级编辑', '', 'platform:community:note:star:update', '', 'A', 1, 1, 0, '2025-04-03 11:29:11', '2025-04-03 11:29:11', 3);
INSERT INTO `eb_system_menu` VALUES (396, 387, '社区笔记评论强制关闭开关', '', 'platform:community:note:repley:force:off:switch', '', 'A', 1, 1, 0, '2025-04-03 11:29:31', '2025-04-03 11:29:31', 3);
INSERT INTO `eb_system_menu` VALUES (397, 386, '社区分类', '', '', '/marketing/community/classification', 'C', 1, 1, 0, '2025-04-03 14:28:05', '2025-04-03 14:28:05', 3);
INSERT INTO `eb_system_menu` VALUES (398, 397, '社区分类分页列表', '', 'platform:community:category:page:list', '', 'A', 1, 1, 0, '2025-04-03 14:28:28', '2025-04-03 14:28:28', 3);
INSERT INTO `eb_system_menu` VALUES (399, 397, '添加社区分类', '', 'platform:community:category:add', '', 'A', 1, 1, 0, '2025-04-03 14:28:52', '2025-04-03 14:28:52', 3);
INSERT INTO `eb_system_menu` VALUES (400, 397, '编辑社区分类', '', 'platform:community:category:update', '', 'A', 1, 1, 0, '2025-04-03 14:29:15', '2025-04-03 14:29:15', 3);
INSERT INTO `eb_system_menu` VALUES (401, 397, '删除社区分类', '', 'platform:community:category:delete', '', 'A', 1, 1, 0, '2025-04-03 14:29:32', '2025-04-03 14:29:32', 3);
INSERT INTO `eb_system_menu` VALUES (402, 397, '社区分类显示开关', '', 'platform:community:category:show:switch', '', 'A', 1, 1, 0, '2025-04-03 14:29:49', '2025-04-03 14:29:49', 3);
INSERT INTO `eb_system_menu` VALUES (403, 386, '社区话题', '', '', '/marketing/community/topics', 'C', 1, 1, 0, '2025-04-03 14:30:24', '2025-04-03 14:30:24', 3);
INSERT INTO `eb_system_menu` VALUES (404, 403, '社区话题分页列表', '', 'platform:community:topic:page:list', '', 'A', 1, 1, 0, '2025-04-03 14:30:43', '2025-04-03 14:30:43', 3);
INSERT INTO `eb_system_menu` VALUES (405, 403, '添加社区话题', '', 'platform:community:topic:add', '', 'A', 1, 1, 0, '2025-04-03 14:31:03', '2025-04-03 14:31:03', 3);
INSERT INTO `eb_system_menu` VALUES (406, 403, '编辑社区话题', '', 'platform:community:topic:update', '', 'A', 1, 1, 0, '2025-04-03 14:31:20', '2025-04-03 14:31:20', 3);
INSERT INTO `eb_system_menu` VALUES (407, 403, '删除社区话题', '', 'platform:community:topic:delete', '', 'A', 1, 1, 0, '2025-04-03 14:31:37', '2025-04-03 14:31:37', 3);
INSERT INTO `eb_system_menu` VALUES (408, 403, '社区话题开启/关闭推荐', '', 'platform:community:topic:recommend:switch', '', 'A', 1, 1, 0, '2025-04-03 14:31:52', '2025-04-03 14:31:52', 3);
INSERT INTO `eb_system_menu` VALUES (409, 386, '社区评论', '', '', '/marketing/community/comments', 'C', 1, 1, 0, '2025-04-03 14:32:19', '2025-04-03 14:32:19', 3);
INSERT INTO `eb_system_menu` VALUES (410, 409, '社区评论分页列表', '', 'platform:community:reply:page:list', '', 'A', 1, 1, 0, '2025-04-03 14:32:41', '2025-04-03 14:32:41', 3);
INSERT INTO `eb_system_menu` VALUES (411, 409, '社区评论审核', '', 'platform:community:reply:audit', '', 'A', 1, 1, 0, '2025-04-03 14:33:01', '2025-04-03 14:33:01', 3);
INSERT INTO `eb_system_menu` VALUES (412, 409, '社区评论删除', '', 'platform:community:reply:delete', '', 'A', 1, 1, 0, '2025-04-03 14:33:33', '2025-04-03 14:33:33', 3);
INSERT INTO `eb_system_menu` VALUES (413, 409, '社区评论-文章分页列表', '', 'platform:community:reply:note:page:list', '', 'A', 1, 1, 0, '2025-04-03 14:33:49', '2025-04-03 14:33:49', 3);
INSERT INTO `eb_system_menu` VALUES (414, 386, '社区配置', '', '', '/marketing/community/config', 'C', 1, 1, 0, '2025-04-03 14:34:23', '2025-04-03 14:34:23', 3);
INSERT INTO `eb_system_menu` VALUES (415, 414, '获取社区配置', '', 'platform:community:get:config', '', 'A', 1, 1, 0, '2025-04-03 14:34:41', '2025-04-03 14:34:41', 3);
INSERT INTO `eb_system_menu` VALUES (416, 414, '更新社区配置', '', 'platform:community:update:config', '', 'A', 1, 1, 0, '2025-04-03 14:34:58', '2025-04-03 14:34:58', 3);

-- ----------------------------
-- Table structure for eb_system_notification
-- ----------------------------
DROP TABLE IF EXISTS `eb_system_notification`;
CREATE TABLE `eb_system_notification`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `mark` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标识',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '通知类型',
  `description` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '通知场景说明',
  `is_sms` tinyint(2) NOT NULL DEFAULT 0 COMMENT '发送短信（0：不存在，1：开启，2：关闭）',
  `sms_id` int(11) NOT NULL DEFAULT 0 COMMENT '短信模板id',
  `is_oversea_sms` tinyint(2) NOT NULL DEFAULT 0 COMMENT '发送海外短信（0：不存在，1：开启，2：关闭）',
  `oversea_sms_id` int(11) NOT NULL DEFAULT 0 COMMENT '海外短信模板id',
  `is_email` tinyint(2) NOT NULL DEFAULT 0 COMMENT '发送邮箱（0：不存在，1：开启，2：关闭）',
  `email_id` int(11) NOT NULL DEFAULT 0 COMMENT '邮箱模板id',
  `send_type` tinyint(2) NOT NULL DEFAULT 1 COMMENT '发送类型（1：用户，2：管理员）',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `mark`(`mark`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '通知设置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_system_notification
-- ----------------------------
INSERT INTO `eb_system_notification` VALUES (1, 'PaySuccess', '订单支付成功通知', '订单支付成功通知', 1, 3, 1, 6, 1, 2, 1, '2022-02-15 16:39:45');
INSERT INTO `eb_system_notification` VALUES (2, 'DeliverGoods', '订单发货通知', '订单发货通知', 1, 2, 1, 5, 1, 3, 1, '2022-02-15 16:43:41');
INSERT INTO `eb_system_notification` VALUES (3, 'Captcha', '通用验证码', '公共验证码', 1, 1, 1, 4, 1, 1, 1, '2022-02-15 16:45:16');
INSERT INTO `eb_system_notification` VALUES (4, 'merchantAuditSuccess', '商户审核成功通知', '商户审核成功通知', 0, 0, 0, 0, 1, 4, 1, '2022-04-20 14:56:56');

-- ----------------------------
-- Table structure for eb_system_role
-- ----------------------------
DROP TABLE IF EXISTS `eb_system_role`;
CREATE TABLE `eb_system_role`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '身份管理id',
  `role_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '身份管理名称',
  `rules` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '身份管理权限(menus_id)',
  `level` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `type` int(11) NOT NULL DEFAULT 0 COMMENT '管理员类型：1= 平台超管, 2=商户超管, 3=系统管理员，4=商户管理员',
  `mer_id` int(11) NOT NULL DEFAULT 0 COMMENT '商户id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '身份管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_system_role
-- ----------------------------
INSERT INTO `eb_system_role` VALUES (1, '超级管理员', '', 0, 1, '2020-04-18 11:19:25', '2022-04-08 20:54:33', 1, 0);
INSERT INTO `eb_system_role` VALUES (2, '商户超级管理员', '', 0, 1, '2022-03-04 10:03:54', '2022-04-08 20:54:39', 2, 0);
INSERT INTO `eb_system_role` VALUES (4, '管理员', '', 0, 1, '2022-05-11 09:32:21', '2022-05-11 09:32:21', 3, 0);

-- ----------------------------
-- Table structure for eb_system_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `eb_system_role_menu`;
CREATE TABLE `eb_system_role_menu`  (
  `rid` int(11) NOT NULL COMMENT '角色id',
  `menu_id` int(11) NOT NULL COMMENT '权限id',
  PRIMARY KEY (`rid`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_system_role_menu
-- ----------------------------
INSERT INTO `eb_system_role_menu` VALUES (1, 1);
INSERT INTO `eb_system_role_menu` VALUES (1, 2);
INSERT INTO `eb_system_role_menu` VALUES (1, 3);
INSERT INTO `eb_system_role_menu` VALUES (1, 4);
INSERT INTO `eb_system_role_menu` VALUES (1, 5);
INSERT INTO `eb_system_role_menu` VALUES (1, 6);
INSERT INTO `eb_system_role_menu` VALUES (1, 7);
INSERT INTO `eb_system_role_menu` VALUES (1, 8);
INSERT INTO `eb_system_role_menu` VALUES (1, 9);
INSERT INTO `eb_system_role_menu` VALUES (1, 10);
INSERT INTO `eb_system_role_menu` VALUES (1, 13);
INSERT INTO `eb_system_role_menu` VALUES (1, 14);
INSERT INTO `eb_system_role_menu` VALUES (1, 15);
INSERT INTO `eb_system_role_menu` VALUES (1, 16);
INSERT INTO `eb_system_role_menu` VALUES (1, 17);
INSERT INTO `eb_system_role_menu` VALUES (1, 18);
INSERT INTO `eb_system_role_menu` VALUES (1, 19);
INSERT INTO `eb_system_role_menu` VALUES (1, 20);
INSERT INTO `eb_system_role_menu` VALUES (1, 24);
INSERT INTO `eb_system_role_menu` VALUES (1, 25);
INSERT INTO `eb_system_role_menu` VALUES (1, 26);
INSERT INTO `eb_system_role_menu` VALUES (1, 27);
INSERT INTO `eb_system_role_menu` VALUES (1, 28);
INSERT INTO `eb_system_role_menu` VALUES (1, 29);
INSERT INTO `eb_system_role_menu` VALUES (1, 30);
INSERT INTO `eb_system_role_menu` VALUES (1, 32);
INSERT INTO `eb_system_role_menu` VALUES (1, 33);
INSERT INTO `eb_system_role_menu` VALUES (1, 34);
INSERT INTO `eb_system_role_menu` VALUES (1, 35);
INSERT INTO `eb_system_role_menu` VALUES (1, 36);
INSERT INTO `eb_system_role_menu` VALUES (1, 37);
INSERT INTO `eb_system_role_menu` VALUES (1, 38);
INSERT INTO `eb_system_role_menu` VALUES (1, 39);
INSERT INTO `eb_system_role_menu` VALUES (1, 40);
INSERT INTO `eb_system_role_menu` VALUES (1, 41);
INSERT INTO `eb_system_role_menu` VALUES (1, 42);
INSERT INTO `eb_system_role_menu` VALUES (1, 43);
INSERT INTO `eb_system_role_menu` VALUES (1, 44);
INSERT INTO `eb_system_role_menu` VALUES (1, 45);
INSERT INTO `eb_system_role_menu` VALUES (1, 46);
INSERT INTO `eb_system_role_menu` VALUES (1, 47);
INSERT INTO `eb_system_role_menu` VALUES (1, 48);
INSERT INTO `eb_system_role_menu` VALUES (1, 52);
INSERT INTO `eb_system_role_menu` VALUES (1, 53);
INSERT INTO `eb_system_role_menu` VALUES (1, 54);
INSERT INTO `eb_system_role_menu` VALUES (1, 55);
INSERT INTO `eb_system_role_menu` VALUES (1, 62);
INSERT INTO `eb_system_role_menu` VALUES (1, 63);
INSERT INTO `eb_system_role_menu` VALUES (1, 64);
INSERT INTO `eb_system_role_menu` VALUES (1, 65);
INSERT INTO `eb_system_role_menu` VALUES (1, 66);
INSERT INTO `eb_system_role_menu` VALUES (1, 67);
INSERT INTO `eb_system_role_menu` VALUES (1, 68);
INSERT INTO `eb_system_role_menu` VALUES (1, 69);
INSERT INTO `eb_system_role_menu` VALUES (1, 70);
INSERT INTO `eb_system_role_menu` VALUES (1, 71);
INSERT INTO `eb_system_role_menu` VALUES (1, 72);
INSERT INTO `eb_system_role_menu` VALUES (1, 74);
INSERT INTO `eb_system_role_menu` VALUES (1, 75);
INSERT INTO `eb_system_role_menu` VALUES (1, 76);
INSERT INTO `eb_system_role_menu` VALUES (1, 77);
INSERT INTO `eb_system_role_menu` VALUES (1, 78);
INSERT INTO `eb_system_role_menu` VALUES (1, 79);
INSERT INTO `eb_system_role_menu` VALUES (1, 80);
INSERT INTO `eb_system_role_menu` VALUES (1, 81);
INSERT INTO `eb_system_role_menu` VALUES (1, 82);
INSERT INTO `eb_system_role_menu` VALUES (1, 83);
INSERT INTO `eb_system_role_menu` VALUES (1, 84);
INSERT INTO `eb_system_role_menu` VALUES (1, 85);
INSERT INTO `eb_system_role_menu` VALUES (1, 86);
INSERT INTO `eb_system_role_menu` VALUES (1, 87);
INSERT INTO `eb_system_role_menu` VALUES (1, 88);
INSERT INTO `eb_system_role_menu` VALUES (1, 89);
INSERT INTO `eb_system_role_menu` VALUES (1, 90);
INSERT INTO `eb_system_role_menu` VALUES (1, 91);
INSERT INTO `eb_system_role_menu` VALUES (1, 92);
INSERT INTO `eb_system_role_menu` VALUES (1, 93);
INSERT INTO `eb_system_role_menu` VALUES (1, 94);
INSERT INTO `eb_system_role_menu` VALUES (1, 95);
INSERT INTO `eb_system_role_menu` VALUES (1, 96);
INSERT INTO `eb_system_role_menu` VALUES (1, 97);
INSERT INTO `eb_system_role_menu` VALUES (1, 98);
INSERT INTO `eb_system_role_menu` VALUES (1, 99);
INSERT INTO `eb_system_role_menu` VALUES (1, 100);
INSERT INTO `eb_system_role_menu` VALUES (1, 101);
INSERT INTO `eb_system_role_menu` VALUES (1, 102);
INSERT INTO `eb_system_role_menu` VALUES (1, 103);
INSERT INTO `eb_system_role_menu` VALUES (1, 104);
INSERT INTO `eb_system_role_menu` VALUES (1, 105);
INSERT INTO `eb_system_role_menu` VALUES (1, 106);
INSERT INTO `eb_system_role_menu` VALUES (1, 107);
INSERT INTO `eb_system_role_menu` VALUES (1, 108);
INSERT INTO `eb_system_role_menu` VALUES (1, 110);
INSERT INTO `eb_system_role_menu` VALUES (1, 111);
INSERT INTO `eb_system_role_menu` VALUES (1, 112);
INSERT INTO `eb_system_role_menu` VALUES (1, 113);
INSERT INTO `eb_system_role_menu` VALUES (1, 114);
INSERT INTO `eb_system_role_menu` VALUES (1, 115);
INSERT INTO `eb_system_role_menu` VALUES (1, 116);
INSERT INTO `eb_system_role_menu` VALUES (1, 117);
INSERT INTO `eb_system_role_menu` VALUES (1, 118);
INSERT INTO `eb_system_role_menu` VALUES (1, 119);
INSERT INTO `eb_system_role_menu` VALUES (1, 120);
INSERT INTO `eb_system_role_menu` VALUES (1, 125);
INSERT INTO `eb_system_role_menu` VALUES (1, 126);
INSERT INTO `eb_system_role_menu` VALUES (1, 127);
INSERT INTO `eb_system_role_menu` VALUES (1, 128);
INSERT INTO `eb_system_role_menu` VALUES (1, 129);
INSERT INTO `eb_system_role_menu` VALUES (1, 130);
INSERT INTO `eb_system_role_menu` VALUES (1, 131);
INSERT INTO `eb_system_role_menu` VALUES (1, 132);
INSERT INTO `eb_system_role_menu` VALUES (1, 133);
INSERT INTO `eb_system_role_menu` VALUES (1, 134);
INSERT INTO `eb_system_role_menu` VALUES (1, 135);
INSERT INTO `eb_system_role_menu` VALUES (1, 136);
INSERT INTO `eb_system_role_menu` VALUES (1, 137);
INSERT INTO `eb_system_role_menu` VALUES (1, 138);
INSERT INTO `eb_system_role_menu` VALUES (1, 139);
INSERT INTO `eb_system_role_menu` VALUES (1, 140);
INSERT INTO `eb_system_role_menu` VALUES (1, 141);
INSERT INTO `eb_system_role_menu` VALUES (1, 142);
INSERT INTO `eb_system_role_menu` VALUES (1, 143);
INSERT INTO `eb_system_role_menu` VALUES (1, 144);
INSERT INTO `eb_system_role_menu` VALUES (1, 145);
INSERT INTO `eb_system_role_menu` VALUES (1, 146);
INSERT INTO `eb_system_role_menu` VALUES (1, 147);
INSERT INTO `eb_system_role_menu` VALUES (1, 148);
INSERT INTO `eb_system_role_menu` VALUES (1, 150);
INSERT INTO `eb_system_role_menu` VALUES (1, 151);
INSERT INTO `eb_system_role_menu` VALUES (1, 152);
INSERT INTO `eb_system_role_menu` VALUES (1, 153);
INSERT INTO `eb_system_role_menu` VALUES (1, 154);
INSERT INTO `eb_system_role_menu` VALUES (1, 155);
INSERT INTO `eb_system_role_menu` VALUES (1, 156);
INSERT INTO `eb_system_role_menu` VALUES (1, 157);
INSERT INTO `eb_system_role_menu` VALUES (1, 158);
INSERT INTO `eb_system_role_menu` VALUES (1, 159);
INSERT INTO `eb_system_role_menu` VALUES (1, 160);
INSERT INTO `eb_system_role_menu` VALUES (1, 161);
INSERT INTO `eb_system_role_menu` VALUES (1, 162);
INSERT INTO `eb_system_role_menu` VALUES (1, 163);
INSERT INTO `eb_system_role_menu` VALUES (1, 164);
INSERT INTO `eb_system_role_menu` VALUES (1, 165);
INSERT INTO `eb_system_role_menu` VALUES (1, 166);
INSERT INTO `eb_system_role_menu` VALUES (1, 167);
INSERT INTO `eb_system_role_menu` VALUES (1, 188);
INSERT INTO `eb_system_role_menu` VALUES (1, 189);
INSERT INTO `eb_system_role_menu` VALUES (1, 190);
INSERT INTO `eb_system_role_menu` VALUES (1, 191);
INSERT INTO `eb_system_role_menu` VALUES (1, 192);
INSERT INTO `eb_system_role_menu` VALUES (1, 220);
INSERT INTO `eb_system_role_menu` VALUES (1, 221);
INSERT INTO `eb_system_role_menu` VALUES (1, 222);
INSERT INTO `eb_system_role_menu` VALUES (1, 223);
INSERT INTO `eb_system_role_menu` VALUES (1, 229);
INSERT INTO `eb_system_role_menu` VALUES (1, 230);
INSERT INTO `eb_system_role_menu` VALUES (1, 231);
INSERT INTO `eb_system_role_menu` VALUES (1, 253);
INSERT INTO `eb_system_role_menu` VALUES (1, 254);
INSERT INTO `eb_system_role_menu` VALUES (1, 260);
INSERT INTO `eb_system_role_menu` VALUES (1, 261);
INSERT INTO `eb_system_role_menu` VALUES (1, 262);
INSERT INTO `eb_system_role_menu` VALUES (1, 263);
INSERT INTO `eb_system_role_menu` VALUES (1, 264);
INSERT INTO `eb_system_role_menu` VALUES (1, 265);
INSERT INTO `eb_system_role_menu` VALUES (1, 266);
INSERT INTO `eb_system_role_menu` VALUES (1, 267);
INSERT INTO `eb_system_role_menu` VALUES (1, 268);
INSERT INTO `eb_system_role_menu` VALUES (1, 269);
INSERT INTO `eb_system_role_menu` VALUES (1, 270);
INSERT INTO `eb_system_role_menu` VALUES (1, 271);
INSERT INTO `eb_system_role_menu` VALUES (1, 273);
INSERT INTO `eb_system_role_menu` VALUES (1, 277);
INSERT INTO `eb_system_role_menu` VALUES (1, 278);
INSERT INTO `eb_system_role_menu` VALUES (1, 280);
INSERT INTO `eb_system_role_menu` VALUES (1, 281);
INSERT INTO `eb_system_role_menu` VALUES (1, 282);
INSERT INTO `eb_system_role_menu` VALUES (1, 283);
INSERT INTO `eb_system_role_menu` VALUES (1, 287);
INSERT INTO `eb_system_role_menu` VALUES (1, 288);
INSERT INTO `eb_system_role_menu` VALUES (1, 289);
INSERT INTO `eb_system_role_menu` VALUES (1, 290);
INSERT INTO `eb_system_role_menu` VALUES (1, 298);
INSERT INTO `eb_system_role_menu` VALUES (1, 299);
INSERT INTO `eb_system_role_menu` VALUES (1, 307);
INSERT INTO `eb_system_role_menu` VALUES (1, 308);
INSERT INTO `eb_system_role_menu` VALUES (1, 309);
INSERT INTO `eb_system_role_menu` VALUES (1, 310);
INSERT INTO `eb_system_role_menu` VALUES (1, 311);
INSERT INTO `eb_system_role_menu` VALUES (1, 312);
INSERT INTO `eb_system_role_menu` VALUES (1, 313);
INSERT INTO `eb_system_role_menu` VALUES (1, 315);
INSERT INTO `eb_system_role_menu` VALUES (1, 325);
INSERT INTO `eb_system_role_menu` VALUES (1, 326);
INSERT INTO `eb_system_role_menu` VALUES (1, 335);
INSERT INTO `eb_system_role_menu` VALUES (1, 336);
INSERT INTO `eb_system_role_menu` VALUES (1, 337);
INSERT INTO `eb_system_role_menu` VALUES (1, 342);
INSERT INTO `eb_system_role_menu` VALUES (1, 343);
INSERT INTO `eb_system_role_menu` VALUES (1, 344);
INSERT INTO `eb_system_role_menu` VALUES (1, 345);
INSERT INTO `eb_system_role_menu` VALUES (1, 349);
INSERT INTO `eb_system_role_menu` VALUES (1, 354);
INSERT INTO `eb_system_role_menu` VALUES (1, 355);
INSERT INTO `eb_system_role_menu` VALUES (1, 356);
INSERT INTO `eb_system_role_menu` VALUES (1, 357);
INSERT INTO `eb_system_role_menu` VALUES (1, 358);
INSERT INTO `eb_system_role_menu` VALUES (1, 360);
INSERT INTO `eb_system_role_menu` VALUES (1, 361);
INSERT INTO `eb_system_role_menu` VALUES (1, 367);
INSERT INTO `eb_system_role_menu` VALUES (1, 368);
INSERT INTO `eb_system_role_menu` VALUES (1, 369);
INSERT INTO `eb_system_role_menu` VALUES (1, 370);
INSERT INTO `eb_system_role_menu` VALUES (1, 371);
INSERT INTO `eb_system_role_menu` VALUES (1, 372);
INSERT INTO `eb_system_role_menu` VALUES (1, 373);
INSERT INTO `eb_system_role_menu` VALUES (1, 380);
INSERT INTO `eb_system_role_menu` VALUES (1, 385);
INSERT INTO `eb_system_role_menu` VALUES (1, 386);
INSERT INTO `eb_system_role_menu` VALUES (1, 387);
INSERT INTO `eb_system_role_menu` VALUES (1, 388);
INSERT INTO `eb_system_role_menu` VALUES (1, 389);
INSERT INTO `eb_system_role_menu` VALUES (1, 390);
INSERT INTO `eb_system_role_menu` VALUES (1, 391);
INSERT INTO `eb_system_role_menu` VALUES (1, 393);
INSERT INTO `eb_system_role_menu` VALUES (1, 394);
INSERT INTO `eb_system_role_menu` VALUES (1, 395);
INSERT INTO `eb_system_role_menu` VALUES (1, 396);
INSERT INTO `eb_system_role_menu` VALUES (1, 397);
INSERT INTO `eb_system_role_menu` VALUES (1, 398);
INSERT INTO `eb_system_role_menu` VALUES (1, 399);
INSERT INTO `eb_system_role_menu` VALUES (1, 400);
INSERT INTO `eb_system_role_menu` VALUES (1, 401);
INSERT INTO `eb_system_role_menu` VALUES (1, 402);
INSERT INTO `eb_system_role_menu` VALUES (1, 403);
INSERT INTO `eb_system_role_menu` VALUES (1, 404);
INSERT INTO `eb_system_role_menu` VALUES (1, 405);
INSERT INTO `eb_system_role_menu` VALUES (1, 406);
INSERT INTO `eb_system_role_menu` VALUES (1, 407);
INSERT INTO `eb_system_role_menu` VALUES (1, 408);
INSERT INTO `eb_system_role_menu` VALUES (1, 409);
INSERT INTO `eb_system_role_menu` VALUES (1, 410);
INSERT INTO `eb_system_role_menu` VALUES (1, 411);
INSERT INTO `eb_system_role_menu` VALUES (1, 412);
INSERT INTO `eb_system_role_menu` VALUES (1, 413);
INSERT INTO `eb_system_role_menu` VALUES (1, 414);
INSERT INTO `eb_system_role_menu` VALUES (1, 415);
INSERT INTO `eb_system_role_menu` VALUES (1, 416);
INSERT INTO `eb_system_role_menu` VALUES (2, 121);
INSERT INTO `eb_system_role_menu` VALUES (2, 122);
INSERT INTO `eb_system_role_menu` VALUES (2, 123);
INSERT INTO `eb_system_role_menu` VALUES (2, 124);
INSERT INTO `eb_system_role_menu` VALUES (2, 170);
INSERT INTO `eb_system_role_menu` VALUES (2, 171);
INSERT INTO `eb_system_role_menu` VALUES (2, 172);
INSERT INTO `eb_system_role_menu` VALUES (2, 173);
INSERT INTO `eb_system_role_menu` VALUES (2, 174);
INSERT INTO `eb_system_role_menu` VALUES (2, 175);
INSERT INTO `eb_system_role_menu` VALUES (2, 176);
INSERT INTO `eb_system_role_menu` VALUES (2, 178);
INSERT INTO `eb_system_role_menu` VALUES (2, 179);
INSERT INTO `eb_system_role_menu` VALUES (2, 180);
INSERT INTO `eb_system_role_menu` VALUES (2, 182);
INSERT INTO `eb_system_role_menu` VALUES (2, 183);
INSERT INTO `eb_system_role_menu` VALUES (2, 185);
INSERT INTO `eb_system_role_menu` VALUES (2, 186);
INSERT INTO `eb_system_role_menu` VALUES (2, 187);
INSERT INTO `eb_system_role_menu` VALUES (2, 193);
INSERT INTO `eb_system_role_menu` VALUES (2, 194);
INSERT INTO `eb_system_role_menu` VALUES (2, 195);
INSERT INTO `eb_system_role_menu` VALUES (2, 196);
INSERT INTO `eb_system_role_menu` VALUES (2, 197);
INSERT INTO `eb_system_role_menu` VALUES (2, 198);
INSERT INTO `eb_system_role_menu` VALUES (2, 199);
INSERT INTO `eb_system_role_menu` VALUES (2, 200);
INSERT INTO `eb_system_role_menu` VALUES (2, 201);
INSERT INTO `eb_system_role_menu` VALUES (2, 202);
INSERT INTO `eb_system_role_menu` VALUES (2, 203);
INSERT INTO `eb_system_role_menu` VALUES (2, 204);
INSERT INTO `eb_system_role_menu` VALUES (2, 205);
INSERT INTO `eb_system_role_menu` VALUES (2, 206);
INSERT INTO `eb_system_role_menu` VALUES (2, 207);
INSERT INTO `eb_system_role_menu` VALUES (2, 208);
INSERT INTO `eb_system_role_menu` VALUES (2, 209);
INSERT INTO `eb_system_role_menu` VALUES (2, 210);
INSERT INTO `eb_system_role_menu` VALUES (2, 211);
INSERT INTO `eb_system_role_menu` VALUES (2, 212);
INSERT INTO `eb_system_role_menu` VALUES (2, 213);
INSERT INTO `eb_system_role_menu` VALUES (2, 214);
INSERT INTO `eb_system_role_menu` VALUES (2, 215);
INSERT INTO `eb_system_role_menu` VALUES (2, 216);
INSERT INTO `eb_system_role_menu` VALUES (2, 217);
INSERT INTO `eb_system_role_menu` VALUES (2, 218);
INSERT INTO `eb_system_role_menu` VALUES (2, 219);
INSERT INTO `eb_system_role_menu` VALUES (2, 224);
INSERT INTO `eb_system_role_menu` VALUES (2, 225);
INSERT INTO `eb_system_role_menu` VALUES (2, 226);
INSERT INTO `eb_system_role_menu` VALUES (2, 227);
INSERT INTO `eb_system_role_menu` VALUES (2, 228);
INSERT INTO `eb_system_role_menu` VALUES (2, 232);
INSERT INTO `eb_system_role_menu` VALUES (2, 233);
INSERT INTO `eb_system_role_menu` VALUES (2, 234);
INSERT INTO `eb_system_role_menu` VALUES (2, 235);
INSERT INTO `eb_system_role_menu` VALUES (2, 236);
INSERT INTO `eb_system_role_menu` VALUES (2, 237);
INSERT INTO `eb_system_role_menu` VALUES (2, 238);
INSERT INTO `eb_system_role_menu` VALUES (2, 239);
INSERT INTO `eb_system_role_menu` VALUES (2, 240);
INSERT INTO `eb_system_role_menu` VALUES (2, 241);
INSERT INTO `eb_system_role_menu` VALUES (2, 242);
INSERT INTO `eb_system_role_menu` VALUES (2, 243);
INSERT INTO `eb_system_role_menu` VALUES (2, 244);
INSERT INTO `eb_system_role_menu` VALUES (2, 245);
INSERT INTO `eb_system_role_menu` VALUES (2, 246);
INSERT INTO `eb_system_role_menu` VALUES (2, 247);
INSERT INTO `eb_system_role_menu` VALUES (2, 248);
INSERT INTO `eb_system_role_menu` VALUES (2, 249);
INSERT INTO `eb_system_role_menu` VALUES (2, 250);
INSERT INTO `eb_system_role_menu` VALUES (2, 255);
INSERT INTO `eb_system_role_menu` VALUES (2, 256);
INSERT INTO `eb_system_role_menu` VALUES (2, 257);
INSERT INTO `eb_system_role_menu` VALUES (2, 258);
INSERT INTO `eb_system_role_menu` VALUES (2, 274);
INSERT INTO `eb_system_role_menu` VALUES (2, 275);
INSERT INTO `eb_system_role_menu` VALUES (2, 284);
INSERT INTO `eb_system_role_menu` VALUES (2, 286);
INSERT INTO `eb_system_role_menu` VALUES (2, 291);
INSERT INTO `eb_system_role_menu` VALUES (2, 292);
INSERT INTO `eb_system_role_menu` VALUES (2, 293);
INSERT INTO `eb_system_role_menu` VALUES (2, 294);
INSERT INTO `eb_system_role_menu` VALUES (2, 295);
INSERT INTO `eb_system_role_menu` VALUES (2, 296);
INSERT INTO `eb_system_role_menu` VALUES (2, 297);
INSERT INTO `eb_system_role_menu` VALUES (2, 300);
INSERT INTO `eb_system_role_menu` VALUES (2, 301);
INSERT INTO `eb_system_role_menu` VALUES (2, 302);
INSERT INTO `eb_system_role_menu` VALUES (2, 303);
INSERT INTO `eb_system_role_menu` VALUES (2, 304);
INSERT INTO `eb_system_role_menu` VALUES (2, 305);
INSERT INTO `eb_system_role_menu` VALUES (2, 306);
INSERT INTO `eb_system_role_menu` VALUES (2, 317);
INSERT INTO `eb_system_role_menu` VALUES (2, 318);
INSERT INTO `eb_system_role_menu` VALUES (2, 319);
INSERT INTO `eb_system_role_menu` VALUES (2, 320);
INSERT INTO `eb_system_role_menu` VALUES (2, 321);
INSERT INTO `eb_system_role_menu` VALUES (2, 322);
INSERT INTO `eb_system_role_menu` VALUES (2, 323);
INSERT INTO `eb_system_role_menu` VALUES (2, 324);
INSERT INTO `eb_system_role_menu` VALUES (2, 327);
INSERT INTO `eb_system_role_menu` VALUES (2, 328);
INSERT INTO `eb_system_role_menu` VALUES (2, 329);
INSERT INTO `eb_system_role_menu` VALUES (2, 330);
INSERT INTO `eb_system_role_menu` VALUES (2, 331);
INSERT INTO `eb_system_role_menu` VALUES (2, 332);
INSERT INTO `eb_system_role_menu` VALUES (2, 333);
INSERT INTO `eb_system_role_menu` VALUES (2, 334);
INSERT INTO `eb_system_role_menu` VALUES (2, 338);
INSERT INTO `eb_system_role_menu` VALUES (2, 339);
INSERT INTO `eb_system_role_menu` VALUES (2, 341);
INSERT INTO `eb_system_role_menu` VALUES (2, 346);
INSERT INTO `eb_system_role_menu` VALUES (2, 347);
INSERT INTO `eb_system_role_menu` VALUES (2, 348);
INSERT INTO `eb_system_role_menu` VALUES (2, 350);
INSERT INTO `eb_system_role_menu` VALUES (2, 351);
INSERT INTO `eb_system_role_menu` VALUES (2, 352);
INSERT INTO `eb_system_role_menu` VALUES (2, 353);
INSERT INTO `eb_system_role_menu` VALUES (2, 362);
INSERT INTO `eb_system_role_menu` VALUES (2, 363);
INSERT INTO `eb_system_role_menu` VALUES (2, 365);
INSERT INTO `eb_system_role_menu` VALUES (2, 366);
INSERT INTO `eb_system_role_menu` VALUES (2, 374);
INSERT INTO `eb_system_role_menu` VALUES (2, 375);
INSERT INTO `eb_system_role_menu` VALUES (2, 376);
INSERT INTO `eb_system_role_menu` VALUES (2, 377);
INSERT INTO `eb_system_role_menu` VALUES (2, 378);
INSERT INTO `eb_system_role_menu` VALUES (2, 379);
INSERT INTO `eb_system_role_menu` VALUES (4, 1);
INSERT INTO `eb_system_role_menu` VALUES (4, 2);
INSERT INTO `eb_system_role_menu` VALUES (4, 3);
INSERT INTO `eb_system_role_menu` VALUES (4, 4);
INSERT INTO `eb_system_role_menu` VALUES (4, 5);
INSERT INTO `eb_system_role_menu` VALUES (4, 6);
INSERT INTO `eb_system_role_menu` VALUES (4, 7);
INSERT INTO `eb_system_role_menu` VALUES (4, 8);
INSERT INTO `eb_system_role_menu` VALUES (4, 9);
INSERT INTO `eb_system_role_menu` VALUES (4, 10);
INSERT INTO `eb_system_role_menu` VALUES (4, 14);
INSERT INTO `eb_system_role_menu` VALUES (4, 15);
INSERT INTO `eb_system_role_menu` VALUES (4, 16);
INSERT INTO `eb_system_role_menu` VALUES (4, 17);
INSERT INTO `eb_system_role_menu` VALUES (4, 18);
INSERT INTO `eb_system_role_menu` VALUES (4, 19);
INSERT INTO `eb_system_role_menu` VALUES (4, 20);
INSERT INTO `eb_system_role_menu` VALUES (4, 24);
INSERT INTO `eb_system_role_menu` VALUES (4, 25);
INSERT INTO `eb_system_role_menu` VALUES (4, 26);
INSERT INTO `eb_system_role_menu` VALUES (4, 27);
INSERT INTO `eb_system_role_menu` VALUES (4, 28);
INSERT INTO `eb_system_role_menu` VALUES (4, 29);
INSERT INTO `eb_system_role_menu` VALUES (4, 30);
INSERT INTO `eb_system_role_menu` VALUES (4, 32);
INSERT INTO `eb_system_role_menu` VALUES (4, 33);
INSERT INTO `eb_system_role_menu` VALUES (4, 34);
INSERT INTO `eb_system_role_menu` VALUES (4, 35);
INSERT INTO `eb_system_role_menu` VALUES (4, 36);
INSERT INTO `eb_system_role_menu` VALUES (4, 37);
INSERT INTO `eb_system_role_menu` VALUES (4, 38);
INSERT INTO `eb_system_role_menu` VALUES (4, 39);
INSERT INTO `eb_system_role_menu` VALUES (4, 40);
INSERT INTO `eb_system_role_menu` VALUES (4, 41);
INSERT INTO `eb_system_role_menu` VALUES (4, 42);
INSERT INTO `eb_system_role_menu` VALUES (4, 43);
INSERT INTO `eb_system_role_menu` VALUES (4, 44);
INSERT INTO `eb_system_role_menu` VALUES (4, 45);
INSERT INTO `eb_system_role_menu` VALUES (4, 46);
INSERT INTO `eb_system_role_menu` VALUES (4, 47);
INSERT INTO `eb_system_role_menu` VALUES (4, 48);
INSERT INTO `eb_system_role_menu` VALUES (4, 52);
INSERT INTO `eb_system_role_menu` VALUES (4, 53);
INSERT INTO `eb_system_role_menu` VALUES (4, 54);
INSERT INTO `eb_system_role_menu` VALUES (4, 55);
INSERT INTO `eb_system_role_menu` VALUES (4, 62);
INSERT INTO `eb_system_role_menu` VALUES (4, 63);
INSERT INTO `eb_system_role_menu` VALUES (4, 64);
INSERT INTO `eb_system_role_menu` VALUES (4, 65);
INSERT INTO `eb_system_role_menu` VALUES (4, 66);
INSERT INTO `eb_system_role_menu` VALUES (4, 67);
INSERT INTO `eb_system_role_menu` VALUES (4, 68);
INSERT INTO `eb_system_role_menu` VALUES (4, 69);
INSERT INTO `eb_system_role_menu` VALUES (4, 70);
INSERT INTO `eb_system_role_menu` VALUES (4, 71);
INSERT INTO `eb_system_role_menu` VALUES (4, 72);
INSERT INTO `eb_system_role_menu` VALUES (4, 74);
INSERT INTO `eb_system_role_menu` VALUES (4, 75);
INSERT INTO `eb_system_role_menu` VALUES (4, 76);
INSERT INTO `eb_system_role_menu` VALUES (4, 77);
INSERT INTO `eb_system_role_menu` VALUES (4, 78);
INSERT INTO `eb_system_role_menu` VALUES (4, 79);
INSERT INTO `eb_system_role_menu` VALUES (4, 80);
INSERT INTO `eb_system_role_menu` VALUES (4, 81);
INSERT INTO `eb_system_role_menu` VALUES (4, 82);
INSERT INTO `eb_system_role_menu` VALUES (4, 83);
INSERT INTO `eb_system_role_menu` VALUES (4, 84);
INSERT INTO `eb_system_role_menu` VALUES (4, 85);
INSERT INTO `eb_system_role_menu` VALUES (4, 86);
INSERT INTO `eb_system_role_menu` VALUES (4, 87);
INSERT INTO `eb_system_role_menu` VALUES (4, 88);
INSERT INTO `eb_system_role_menu` VALUES (4, 89);
INSERT INTO `eb_system_role_menu` VALUES (4, 90);
INSERT INTO `eb_system_role_menu` VALUES (4, 91);
INSERT INTO `eb_system_role_menu` VALUES (4, 92);
INSERT INTO `eb_system_role_menu` VALUES (4, 93);
INSERT INTO `eb_system_role_menu` VALUES (4, 94);
INSERT INTO `eb_system_role_menu` VALUES (4, 95);
INSERT INTO `eb_system_role_menu` VALUES (4, 96);
INSERT INTO `eb_system_role_menu` VALUES (4, 97);
INSERT INTO `eb_system_role_menu` VALUES (4, 98);
INSERT INTO `eb_system_role_menu` VALUES (4, 99);
INSERT INTO `eb_system_role_menu` VALUES (4, 100);
INSERT INTO `eb_system_role_menu` VALUES (4, 101);
INSERT INTO `eb_system_role_menu` VALUES (4, 102);
INSERT INTO `eb_system_role_menu` VALUES (4, 103);
INSERT INTO `eb_system_role_menu` VALUES (4, 104);
INSERT INTO `eb_system_role_menu` VALUES (4, 105);
INSERT INTO `eb_system_role_menu` VALUES (4, 106);
INSERT INTO `eb_system_role_menu` VALUES (4, 107);
INSERT INTO `eb_system_role_menu` VALUES (4, 108);
INSERT INTO `eb_system_role_menu` VALUES (4, 110);
INSERT INTO `eb_system_role_menu` VALUES (4, 111);
INSERT INTO `eb_system_role_menu` VALUES (4, 112);
INSERT INTO `eb_system_role_menu` VALUES (4, 113);
INSERT INTO `eb_system_role_menu` VALUES (4, 114);
INSERT INTO `eb_system_role_menu` VALUES (4, 115);
INSERT INTO `eb_system_role_menu` VALUES (4, 116);
INSERT INTO `eb_system_role_menu` VALUES (4, 117);
INSERT INTO `eb_system_role_menu` VALUES (4, 118);
INSERT INTO `eb_system_role_menu` VALUES (4, 119);
INSERT INTO `eb_system_role_menu` VALUES (4, 120);
INSERT INTO `eb_system_role_menu` VALUES (4, 125);
INSERT INTO `eb_system_role_menu` VALUES (4, 126);
INSERT INTO `eb_system_role_menu` VALUES (4, 127);
INSERT INTO `eb_system_role_menu` VALUES (4, 128);
INSERT INTO `eb_system_role_menu` VALUES (4, 129);
INSERT INTO `eb_system_role_menu` VALUES (4, 130);
INSERT INTO `eb_system_role_menu` VALUES (4, 131);
INSERT INTO `eb_system_role_menu` VALUES (4, 132);
INSERT INTO `eb_system_role_menu` VALUES (4, 133);
INSERT INTO `eb_system_role_menu` VALUES (4, 134);
INSERT INTO `eb_system_role_menu` VALUES (4, 135);
INSERT INTO `eb_system_role_menu` VALUES (4, 136);
INSERT INTO `eb_system_role_menu` VALUES (4, 137);
INSERT INTO `eb_system_role_menu` VALUES (4, 138);
INSERT INTO `eb_system_role_menu` VALUES (4, 139);
INSERT INTO `eb_system_role_menu` VALUES (4, 140);
INSERT INTO `eb_system_role_menu` VALUES (4, 141);
INSERT INTO `eb_system_role_menu` VALUES (4, 142);
INSERT INTO `eb_system_role_menu` VALUES (4, 143);
INSERT INTO `eb_system_role_menu` VALUES (4, 144);
INSERT INTO `eb_system_role_menu` VALUES (4, 145);
INSERT INTO `eb_system_role_menu` VALUES (4, 146);
INSERT INTO `eb_system_role_menu` VALUES (4, 147);
INSERT INTO `eb_system_role_menu` VALUES (4, 148);
INSERT INTO `eb_system_role_menu` VALUES (4, 150);
INSERT INTO `eb_system_role_menu` VALUES (4, 151);
INSERT INTO `eb_system_role_menu` VALUES (4, 152);
INSERT INTO `eb_system_role_menu` VALUES (4, 153);
INSERT INTO `eb_system_role_menu` VALUES (4, 154);
INSERT INTO `eb_system_role_menu` VALUES (4, 155);
INSERT INTO `eb_system_role_menu` VALUES (4, 156);
INSERT INTO `eb_system_role_menu` VALUES (4, 157);
INSERT INTO `eb_system_role_menu` VALUES (4, 158);
INSERT INTO `eb_system_role_menu` VALUES (4, 159);
INSERT INTO `eb_system_role_menu` VALUES (4, 160);
INSERT INTO `eb_system_role_menu` VALUES (4, 161);
INSERT INTO `eb_system_role_menu` VALUES (4, 162);
INSERT INTO `eb_system_role_menu` VALUES (4, 163);
INSERT INTO `eb_system_role_menu` VALUES (4, 164);
INSERT INTO `eb_system_role_menu` VALUES (4, 165);
INSERT INTO `eb_system_role_menu` VALUES (4, 166);
INSERT INTO `eb_system_role_menu` VALUES (4, 167);
INSERT INTO `eb_system_role_menu` VALUES (4, 188);
INSERT INTO `eb_system_role_menu` VALUES (4, 189);
INSERT INTO `eb_system_role_menu` VALUES (4, 190);
INSERT INTO `eb_system_role_menu` VALUES (4, 191);
INSERT INTO `eb_system_role_menu` VALUES (4, 192);
INSERT INTO `eb_system_role_menu` VALUES (4, 220);
INSERT INTO `eb_system_role_menu` VALUES (4, 221);
INSERT INTO `eb_system_role_menu` VALUES (4, 222);
INSERT INTO `eb_system_role_menu` VALUES (4, 223);
INSERT INTO `eb_system_role_menu` VALUES (4, 229);
INSERT INTO `eb_system_role_menu` VALUES (4, 230);
INSERT INTO `eb_system_role_menu` VALUES (4, 231);
INSERT INTO `eb_system_role_menu` VALUES (4, 253);
INSERT INTO `eb_system_role_menu` VALUES (4, 254);
INSERT INTO `eb_system_role_menu` VALUES (4, 260);
INSERT INTO `eb_system_role_menu` VALUES (4, 261);
INSERT INTO `eb_system_role_menu` VALUES (4, 262);
INSERT INTO `eb_system_role_menu` VALUES (4, 263);
INSERT INTO `eb_system_role_menu` VALUES (4, 264);
INSERT INTO `eb_system_role_menu` VALUES (4, 265);
INSERT INTO `eb_system_role_menu` VALUES (4, 266);
INSERT INTO `eb_system_role_menu` VALUES (4, 267);
INSERT INTO `eb_system_role_menu` VALUES (4, 268);
INSERT INTO `eb_system_role_menu` VALUES (4, 269);
INSERT INTO `eb_system_role_menu` VALUES (4, 270);
INSERT INTO `eb_system_role_menu` VALUES (4, 271);
INSERT INTO `eb_system_role_menu` VALUES (4, 273);
INSERT INTO `eb_system_role_menu` VALUES (4, 277);
INSERT INTO `eb_system_role_menu` VALUES (4, 278);
INSERT INTO `eb_system_role_menu` VALUES (4, 280);
INSERT INTO `eb_system_role_menu` VALUES (4, 281);
INSERT INTO `eb_system_role_menu` VALUES (4, 282);
INSERT INTO `eb_system_role_menu` VALUES (4, 283);
INSERT INTO `eb_system_role_menu` VALUES (4, 287);
INSERT INTO `eb_system_role_menu` VALUES (4, 288);
INSERT INTO `eb_system_role_menu` VALUES (4, 289);
INSERT INTO `eb_system_role_menu` VALUES (4, 290);
INSERT INTO `eb_system_role_menu` VALUES (4, 298);
INSERT INTO `eb_system_role_menu` VALUES (4, 299);
INSERT INTO `eb_system_role_menu` VALUES (4, 307);
INSERT INTO `eb_system_role_menu` VALUES (4, 308);
INSERT INTO `eb_system_role_menu` VALUES (4, 309);
INSERT INTO `eb_system_role_menu` VALUES (4, 310);
INSERT INTO `eb_system_role_menu` VALUES (4, 311);
INSERT INTO `eb_system_role_menu` VALUES (4, 312);
INSERT INTO `eb_system_role_menu` VALUES (4, 313);
INSERT INTO `eb_system_role_menu` VALUES (4, 315);
INSERT INTO `eb_system_role_menu` VALUES (4, 325);
INSERT INTO `eb_system_role_menu` VALUES (4, 326);
INSERT INTO `eb_system_role_menu` VALUES (4, 335);
INSERT INTO `eb_system_role_menu` VALUES (4, 336);
INSERT INTO `eb_system_role_menu` VALUES (4, 337);
INSERT INTO `eb_system_role_menu` VALUES (4, 342);
INSERT INTO `eb_system_role_menu` VALUES (4, 343);
INSERT INTO `eb_system_role_menu` VALUES (4, 344);
INSERT INTO `eb_system_role_menu` VALUES (4, 345);
INSERT INTO `eb_system_role_menu` VALUES (4, 349);
INSERT INTO `eb_system_role_menu` VALUES (4, 354);
INSERT INTO `eb_system_role_menu` VALUES (4, 355);
INSERT INTO `eb_system_role_menu` VALUES (4, 356);
INSERT INTO `eb_system_role_menu` VALUES (4, 357);
INSERT INTO `eb_system_role_menu` VALUES (4, 358);
INSERT INTO `eb_system_role_menu` VALUES (4, 360);
INSERT INTO `eb_system_role_menu` VALUES (4, 361);
INSERT INTO `eb_system_role_menu` VALUES (4, 367);
INSERT INTO `eb_system_role_menu` VALUES (4, 369);
INSERT INTO `eb_system_role_menu` VALUES (4, 370);
INSERT INTO `eb_system_role_menu` VALUES (4, 371);
INSERT INTO `eb_system_role_menu` VALUES (4, 372);
INSERT INTO `eb_system_role_menu` VALUES (4, 373);
INSERT INTO `eb_system_role_menu` VALUES (4, 385);
INSERT INTO `eb_system_role_menu` VALUES (4, 386);
INSERT INTO `eb_system_role_menu` VALUES (4, 387);
INSERT INTO `eb_system_role_menu` VALUES (4, 388);
INSERT INTO `eb_system_role_menu` VALUES (4, 389);
INSERT INTO `eb_system_role_menu` VALUES (4, 390);
INSERT INTO `eb_system_role_menu` VALUES (4, 391);
INSERT INTO `eb_system_role_menu` VALUES (4, 393);
INSERT INTO `eb_system_role_menu` VALUES (4, 394);
INSERT INTO `eb_system_role_menu` VALUES (4, 395);
INSERT INTO `eb_system_role_menu` VALUES (4, 396);
INSERT INTO `eb_system_role_menu` VALUES (4, 397);
INSERT INTO `eb_system_role_menu` VALUES (4, 398);
INSERT INTO `eb_system_role_menu` VALUES (4, 399);
INSERT INTO `eb_system_role_menu` VALUES (4, 400);
INSERT INTO `eb_system_role_menu` VALUES (4, 401);
INSERT INTO `eb_system_role_menu` VALUES (4, 402);
INSERT INTO `eb_system_role_menu` VALUES (4, 403);
INSERT INTO `eb_system_role_menu` VALUES (4, 404);
INSERT INTO `eb_system_role_menu` VALUES (4, 405);
INSERT INTO `eb_system_role_menu` VALUES (4, 406);
INSERT INTO `eb_system_role_menu` VALUES (4, 407);
INSERT INTO `eb_system_role_menu` VALUES (4, 408);
INSERT INTO `eb_system_role_menu` VALUES (4, 409);
INSERT INTO `eb_system_role_menu` VALUES (4, 410);
INSERT INTO `eb_system_role_menu` VALUES (4, 411);
INSERT INTO `eb_system_role_menu` VALUES (4, 412);
INSERT INTO `eb_system_role_menu` VALUES (4, 413);
INSERT INTO `eb_system_role_menu` VALUES (4, 414);
INSERT INTO `eb_system_role_menu` VALUES (4, 415);
INSERT INTO `eb_system_role_menu` VALUES (4, 416);

-- ----------------------------
-- Table structure for eb_system_user_level
-- ----------------------------
DROP TABLE IF EXISTS `eb_system_user_level`;
CREATE TABLE `eb_system_user_level`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '会员名称',
  `experience` int(11) NOT NULL DEFAULT 0 COMMENT '达到多少升级经验',
  `is_show` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否显示 1=显示,0=隐藏',
  `grade` int(11) NOT NULL DEFAULT 0 COMMENT '会员等级',
  `discount` int(4) NOT NULL DEFAULT 100 COMMENT '享受折扣',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '会员图标',
  `is_del` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除.1=删除,0=未删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `back_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户等级背景图',
  `back_color` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户等级文字背景色',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '普通会员等级' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_system_user_level
-- ----------------------------
INSERT INTO `eb_system_user_level` VALUES (1, '普通', 0, 1, 0, 100, 'crmebimage/public/user/2023/03/29/15d5558858174719b7926e162ed46778agn0ci3xdy.png', 0, '2023-03-29 10:49:17', '2025-02-20 17:14:34', 'crmebimage/public/user/2023/03/29/eecedbca7b544ca4b595c99be8d28056kyulwjenq2.png', '#0E1C44');
INSERT INTO `eb_system_user_level` VALUES (2, '黑铁', 300, 1, 1, 0, 'crmebimage/public/user/2023/03/29/bee8cb1683cc408ca980cf07367dc186e4yelus4ar.png', 0, '2023-04-21 12:04:45', '2025-02-21 17:14:02', 'crmebimage/public/user/2023/03/29/9889be26e54e468181c250b4224337235colm0sghb.png', '#456F79');
INSERT INTO `eb_system_user_level` VALUES (3, '黄铜', 1000, 1, 2, 0, 'crmebimage/public/user/2023/03/29/221f2e90f4a24b468e6db3a698a88f98inj85utl1b.png', 0, '2023-04-20 17:26:41', '2024-01-11 11:16:08', 'crmebimage/public/user/2023/03/29/4dcf62a5652b4bdb8e3f2b91897884d2b14ax3plyd.png', '#345T45');
INSERT INTO `eb_system_user_level` VALUES (4, '白银', 5000, 1, 3, 100, 'crmebimage/public/user/2023/03/29/8c03ba14900d4fcda66ead6e15e80f27t41oa8q5nt.png', 0, '2022-11-03 10:55:45', '2023-04-15 15:01:04', 'crmebimage/public/user/2023/03/29/3d4cebaddf104786913deaf66e72bace10ptq092zw.png', '#406F79');
INSERT INTO `eb_system_user_level` VALUES (5, '黄金', 9000, 1, 4, 100, 'crmebimage/public/user/2023/03/29/d0a85bfe60184956b6b10c1c45f32143wd9fdw3lwa.png', 0, '2022-11-03 10:56:04', '2023-04-15 15:00:53', 'crmebimage/public/user/2023/03/29/ba4cce3d4b304be880502a9e64a909990f3givavt3.png', '#4F3E96');
INSERT INTO `eb_system_user_level` VALUES (6, '白金', 15000, 1, 5, 100, 'crmebimage/public/user/2023/03/29/bcb0a788fe5f437f9d5eabb3bcc74e2atvchcnyo0y.png', 0, '2023-02-09 15:28:40', '2023-04-15 15:00:43', 'crmebimage/public/user/2023/03/29/fe89a68806b7447d992e7b7143ef5850wwqtlpz9nu.png', '#801B43');

-- ----------------------------
-- Table structure for eb_trading_day_record
-- ----------------------------
DROP TABLE IF EXISTS `eb_trading_day_record`;
CREATE TABLE `eb_trading_day_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '日期',
  `product_order_num` int(11) NULL DEFAULT NULL COMMENT '订单数量',
  `product_order_pay_num` int(11) NULL DEFAULT NULL COMMENT '订单支付数量',
  `product_order_pay_fee` decimal(8, 2) NULL DEFAULT NULL COMMENT '订单支付金额',
  `product_order_refund_num` int(11) NULL DEFAULT NULL COMMENT '订单退款数量',
  `product_order_refund_fee` decimal(8, 2) NULL DEFAULT NULL COMMENT '订单退款金额',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `date`(`date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商城交易日记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_trading_day_record
-- ----------------------------
INSERT INTO `eb_trading_day_record` VALUES (1, '2025-04-02', 0, 0, 0.00, 0, 0.00);
INSERT INTO `eb_trading_day_record` VALUES (2, '2025-04-06', 0, 0, 0.00, 0, 0.00);
INSERT INTO `eb_trading_day_record` VALUES (3, '2025-04-07', 0, 0, 0.00, 0, 0.00);
INSERT INTO `eb_trading_day_record` VALUES (4, '2025-04-08', 0, 0, 0.00, 0, 0.00);
INSERT INTO `eb_trading_day_record` VALUES (5, '2025-04-09', 0, 0, 0.00, 0, 0.00);
INSERT INTO `eb_trading_day_record` VALUES (6, '2025-04-10', 0, 0, 0.00, 0, 0.00);
INSERT INTO `eb_trading_day_record` VALUES (7, '2025-04-11', 0, 0, 0.00, 0, 0.00);
INSERT INTO `eb_trading_day_record` VALUES (8, '2025-04-12', 0, 0, 0.00, 0, 0.00);
INSERT INTO `eb_trading_day_record` VALUES (9, '2025-04-13', 0, 0, 0.00, 0, 0.00);
INSERT INTO `eb_trading_day_record` VALUES (10, '2025-04-14', 0, 0, 0.00, 0, 0.00);
INSERT INTO `eb_trading_day_record` VALUES (11, '2025-04-15', 0, 0, 0.00, 0, 0.00);
INSERT INTO `eb_trading_day_record` VALUES (12, '2025-04-20', 0, 0, 0.00, 0, 0.00);
INSERT INTO `eb_trading_day_record` VALUES (13, '2025-04-21', 0, 0, 0.00, 0, 0.00);

-- ----------------------------
-- Table structure for eb_transfer_record
-- ----------------------------
DROP TABLE IF EXISTS `eb_transfer_record`;
CREATE TABLE `eb_transfer_record`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '转账id',
  `mer_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户id',
  `amount` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '金额',
  `transfer_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'bank' COMMENT '转账类型:bank-银行卡',
  `transfer_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '转账姓名',
  `transfer_bank` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '转账银行',
  `transfer_bank_card` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '转账银行卡号',
  `transfer_status` int(2) UNSIGNED NOT NULL DEFAULT 0 COMMENT '转账状态：0-未到账，1-已到账',
  `transfer_proof` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '转账凭证',
  `transfer_time` timestamp NULL DEFAULT NULL COMMENT '转账时间',
  `audit_status` int(2) UNSIGNED NOT NULL DEFAULT 0 COMMENT '审核状态：0-待审核，1-通过审核，2-审核失败',
  `refusal_reason` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '拒绝原因',
  `audit_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '审核员id',
  `audit_time` timestamp NULL DEFAULT NULL COMMENT '审核时间',
  `mark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商户备注',
  `platform_mark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '平台备注',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `mer_id`(`mer_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '转账记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_transfer_record
-- ----------------------------

-- ----------------------------
-- Table structure for eb_user
-- ----------------------------
DROP TABLE IF EXISTS `eb_user`;
CREATE TABLE `eb_user`  (
  `uid` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `account` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户账号',
  `pwd` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户密码',
  `real_name` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '真实姓名',
  `birthday` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '生日',
  `card_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '身份证号码',
  `tag_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标签id,英文逗号分隔',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户昵称',
  `avatar` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户头像',
  `phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '手机号码',
  `country` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'CN' COMMENT '国家，中国CN，其他OTHER',
  `province` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '省份',
  `city` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '城市',
  `district` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '区',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '详细地址',
  `sex` tinyint(2) NOT NULL DEFAULT 1 COMMENT '性别，0未知，1男，2女，3保密',
  `integral` int(11) NOT NULL DEFAULT 0 COMMENT '用户积分',
  `experience` int(11) NOT NULL DEFAULT 0 COMMENT '用户经验',
  `now_money` decimal(16, 2) NOT NULL DEFAULT 0.00 COMMENT '用户余额',
  `brokerage_price` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '佣金金额',
  `level` tinyint(2) NOT NULL DEFAULT 0 COMMENT '等级',
  `sign_num` int(11) NOT NULL DEFAULT 0 COMMENT '连续签到天数',
  `is_wechat_public` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否关联公众号',
  `is_wechat_routine` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否关联小程序',
  `pay_count` int(11) NOT NULL DEFAULT 0 COMMENT '用户购买次数',
  `is_promoter` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否为推广员',
  `promoter_time` timestamp NULL DEFAULT NULL COMMENT '成为分销员时间',
  `spread_uid` int(10) NOT NULL DEFAULT 0 COMMENT '上级推广员id',
  `spread_time` timestamp NULL DEFAULT NULL COMMENT '绑定上级推广员时间',
  `spread_count` int(11) NOT NULL DEFAULT 0 COMMENT '下级人数',
  `register_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '注册类型：public-公众号，mini-小程序，H5-H5,iosWx-微信ios，androidWx-微信安卓，ios-ios',
  `add_ip` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '创建ip',
  `last_ip` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '最后一次登录ip',
  `last_login_time` timestamp NULL DEFAULT NULL COMMENT '最后一次登录时间',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1为正常，0为禁止',
  `mark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_logoff` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否注销',
  `logoff_time` timestamp NULL DEFAULT NULL COMMENT '注销时间',
  `is_wechat_ios` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否关联微信ios',
  `is_wechat_android` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否关联微信android',
  `is_binding_ios` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否关联ios',
  `signature` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户签名',
  `is_paid_member` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否付费会员',
  `paid_member_expiration_time` datetime NULL DEFAULT NULL COMMENT '付费会员到期时间',
  `is_permanent_paid_member` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否永久付费会员',
  `partner_id` int(11) NULL DEFAULT NULL COMMENT '合伙人id',
  `group_id` int(11) NULL DEFAULT NULL COMMENT '用户分组id',
  `user_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `addres` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `adminid` int(11) NULL DEFAULT NULL,
  `login_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `clean_time` datetime NULL DEFAULT NULL,
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `subscribe` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `identity` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `country_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`uid`) USING BTREE,
  INDEX `spreaduid`(`spread_uid`) USING BTREE,
  INDEX `status`(`status`) USING BTREE,
  INDEX `is_promoter`(`is_promoter`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 167 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_user
-- ----------------------------
INSERT INTO `eb_user` VALUES (6, '18292417675', '7QVgS8P8/hyU1//Y16+72A==', '', '', '', '', 'cherry', 'crmebimage/public/maintain/2025/04/10/ffa44ca1639d4fdab03f71f4e494ea8f2l5dli9u5k.png', '18292417675', 'CN', '', '', '', '', 0, 0, 0, 99040.60, 0.00, 1, 0, 0, 0, 36, 0, '2023-09-22 15:37:46', 0, NULL, 0, 'H5', '', '', '2025-04-16 17:04:09', 1, '', '2023-08-03 15:40:13', '2025-04-15 15:47:42', 0, '2023-11-03 15:01:21', 0, 0, 0, '1231211133', 0, NULL, 0, NULL, NULL, 'phone', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '+86');
INSERT INTO `eb_user` VALUES (7, '19142405862', '1x5VSCLZa1qgz84T8EXfeA==', '', '', '', '', '鸡肉味嘎嘣脆o', 'crmebimage/public/maintain/2025/04/10/387280ddc7134ae7b86c9f1dd394bfaep1fpky5109.jpg', '19142405862', 'CN', '', '', '', '', 0, 290, 0, 9717.15, 0.00, 1, 0, 1, 1, 22, 0, NULL, 0, '2024-10-16 16:25:45', 0, 'H5', '', '', '2025-04-16 09:06:40', 1, '', '2023-08-03 15:41:04', '2025-04-15 10:37:34', 0, '2024-10-16 16:28:24', 0, 0, 0, '', 0, NULL, 0, NULL, NULL, 'phone', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '+86');

-- ----------------------------
-- Table structure for eb_user_address
-- ----------------------------
DROP TABLE IF EXISTS `eb_user_address`;
CREATE TABLE `eb_user_address`  (
  `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户地址id',
  `uid` int(10) UNSIGNED NOT NULL COMMENT '用户id',
  `real_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '收货人姓名',
  `phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '收货人电话',
  `province` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '收货人所在省',
  `city` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '收货人所在市',
  `city_id` int(11) NOT NULL DEFAULT 0 COMMENT '城市id',
  `district` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '收货人所在区',
  `detail` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '收货人详细地址',
  `post_code` int(10) NOT NULL DEFAULT 0 COMMENT '邮编',
  `longitude` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '经度',
  `latitude` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '纬度',
  `is_default` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否默认',
  `is_del` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `country` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '国家',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '邮箱',
  `country_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '国标区号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE,
  INDEX `is_default`(`is_default`) USING BTREE,
  INDEX `is_del`(`is_del`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户地址表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_user_address
-- ----------------------------

-- ----------------------------
-- Table structure for eb_user_bill
-- ----------------------------
DROP TABLE IF EXISTS `eb_user_bill`;
CREATE TABLE `eb_user_bill`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户账单id',
  `uid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户uid',
  `link_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '关联id',
  `pm` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0 = 支出 1 = 获得',
  `title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '账单标题',
  `category` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '明细种类',
  `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '明细类型',
  `number` decimal(8, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '明细数字',
  `balance` decimal(16, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '剩余',
  `mark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '0 = 带确定 1 = 有效 -1 = 无效',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `openid`(`uid`) USING BTREE,
  INDEX `status`(`status`) USING BTREE,
  INDEX `add_time`(`create_time`) USING BTREE,
  INDEX `pm`(`pm`) USING BTREE,
  INDEX `type`(`category`, `type`, `link_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户账单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_user_bill
-- ----------------------------

-- ----------------------------
-- Table structure for eb_user_experience_record
-- ----------------------------
DROP TABLE IF EXISTS `eb_user_experience_record`;
CREATE TABLE `eb_user_experience_record`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '记录id',
  `uid` int(10) NOT NULL DEFAULT 0 COMMENT '用户uid',
  `link_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '关联id-orderNo,(sign,system默认为0）',
  `link_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'order' COMMENT '关联类型（order,sign,system）',
  `type` int(1) NOT NULL DEFAULT 1 COMMENT '类型：1-增加，2-扣减',
  `title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标题',
  `experience` int(11) NOT NULL DEFAULT 0 COMMENT '经验',
  `balance` int(11) NOT NULL DEFAULT 0 COMMENT '剩余',
  `mark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1-成功（保留字段）',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE,
  INDEX `type`(`type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 171 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户经验记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_user_experience_record
-- ----------------------------

-- ----------------------------
-- Table structure for eb_user_group
-- ----------------------------
DROP TABLE IF EXISTS `eb_user_group`;
CREATE TABLE `eb_user_group`  (
  `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `group_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户分组名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户分组表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_user_group
-- ----------------------------
INSERT INTO `eb_user_group` VALUES (1, '初级会员');
INSERT INTO `eb_user_group` VALUES (2, '中级会员');
INSERT INTO `eb_user_group` VALUES (3, '高级会员');

-- ----------------------------
-- Table structure for eb_user_level
-- ----------------------------
DROP TABLE IF EXISTS `eb_user_level`;
CREATE TABLE `eb_user_level`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL DEFAULT 0 COMMENT '用户uid',
  `level_id` int(11) NOT NULL DEFAULT 0 COMMENT '等级vip',
  `grade` int(11) NOT NULL DEFAULT 0 COMMENT '会员等级',
  `discount` int(4) NOT NULL DEFAULT 100 COMMENT '享受折扣',
  `mark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `expired_time` timestamp NULL DEFAULT NULL COMMENT '过期时间',
  `is_del` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除,0=未删除,1=删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `id`(`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 171 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户等级记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_user_level
-- ----------------------------

-- ----------------------------
-- Table structure for eb_user_merchant_collect
-- ----------------------------
DROP TABLE IF EXISTS `eb_user_merchant_collect`;
CREATE TABLE `eb_user_merchant_collect`  (
  `uid` int(11) NOT NULL COMMENT '用户ID',
  `mer_id` int(11) NOT NULL COMMENT '商户ID',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`uid`, `mer_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户商户收藏表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_user_merchant_collect
-- ----------------------------
INSERT INTO `eb_user_merchant_collect` VALUES (6, 2, '2025-04-10 16:37:09');

-- ----------------------------
-- Table structure for eb_user_tag
-- ----------------------------
DROP TABLE IF EXISTS `eb_user_tag`;
CREATE TABLE `eb_user_tag`  (
  `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标签名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '标签管理' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_user_tag
-- ----------------------------
INSERT INTO `eb_user_tag` VALUES (1, '中级');
INSERT INTO `eb_user_tag` VALUES (2, '高级');
INSERT INTO `eb_user_tag` VALUES (3, '黄金');
INSERT INTO `eb_user_tag` VALUES (4, '超级');
INSERT INTO `eb_user_tag` VALUES (5, '钻石');

-- ----------------------------
-- Table structure for eb_user_visit_record
-- ----------------------------
DROP TABLE IF EXISTS `eb_user_visit_record`;
CREATE TABLE `eb_user_visit_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '日期',
  `uid` int(11) NULL DEFAULT NULL COMMENT '用户uid',
  `visit_type` int(2) NULL DEFAULT NULL COMMENT '访问类型',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `date`(`date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 599 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户访问记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eb_user_visit_record
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `TRIGGER_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `BLOB_DATA` blob NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  CONSTRAINT `QRTZ_BLOB_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `CALENDAR_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `CALENDAR` blob NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `CALENDAR_NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `TRIGGER_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `CRON_EXPRESSION` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `TIME_ZONE_ID` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  CONSTRAINT `QRTZ_CRON_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------
INSERT INTO `qrtz_cron_triggers` VALUES ('quartzScheduler', 'TASK_1', 'DEFAULT', '0 */1 * * * ?', 'Asia/Shanghai');
INSERT INTO `qrtz_cron_triggers` VALUES ('quartzScheduler', 'TASK_10', 'DEFAULT', '0 0 2 1 * ?', 'Asia/Shanghai');
INSERT INTO `qrtz_cron_triggers` VALUES ('quartzScheduler', 'TASK_2', 'DEFAULT', '0 */1 * * * ?', 'Asia/Shanghai');
INSERT INTO `qrtz_cron_triggers` VALUES ('quartzScheduler', 'TASK_3', 'DEFAULT', '0 */1 * * * ?', 'Asia/Shanghai');
INSERT INTO `qrtz_cron_triggers` VALUES ('quartzScheduler', 'TASK_4', 'DEFAULT', '0 */1 * * * ?', 'Asia/Shanghai');
INSERT INTO `qrtz_cron_triggers` VALUES ('quartzScheduler', 'TASK_5', 'DEFAULT', '0 */1 * * * ?', 'Asia/Shanghai');
INSERT INTO `qrtz_cron_triggers` VALUES ('quartzScheduler', 'TASK_6', 'DEFAULT', '0 0 0 */1 * ?', 'Asia/Shanghai');
INSERT INTO `qrtz_cron_triggers` VALUES ('quartzScheduler', 'TASK_7', 'DEFAULT', '0 0 0 */1 * ?', 'Asia/Shanghai');
INSERT INTO `qrtz_cron_triggers` VALUES ('quartzScheduler', 'TASK_8', 'DEFAULT', '0 0 0 */1 * ?', 'Asia/Shanghai');
INSERT INTO `qrtz_cron_triggers` VALUES ('quartzScheduler', 'TASK_9', 'DEFAULT', '0 0 0 */1 * ?', 'Asia/Shanghai');

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ENTRY_ID` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `TRIGGER_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `INSTANCE_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `FIRED_TIME` bigint(13) NOT NULL,
  `SCHED_TIME` bigint(13) NOT NULL,
  `PRIORITY` int(11) NOT NULL,
  `STATE` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `JOB_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `JOB_GROUP` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `IS_NONCONCURRENT` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `REQUESTS_RECOVERY` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`, `ENTRY_ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `JOB_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `JOB_GROUP` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `DESCRIPTION` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `JOB_CLASS_NAME` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `IS_DURABLE` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `IS_NONCONCURRENT` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `IS_UPDATE_DATA` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `REQUESTS_RECOVERY` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `JOB_DATA` blob NULL,
  PRIMARY KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------
INSERT INTO `qrtz_job_details` VALUES ('quartzScheduler', 'TASK_1', 'DEFAULT', NULL, 'com.zbkj.admin.quartz.QuartzJob', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000D4A4F425F504152414D5F4B455973720020636F6D2E7A626B6A2E61646D696E2E6D6F64656C2E5363686564756C654A6F6200000000000000010200094C00086265616E4E616D657400124C6A6176612F6C616E672F537472696E673B4C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C000E63726F6E45787072657373696F6E71007E00094C0007697344656C74657400134C6A6176612F6C616E672F426F6F6C65616E3B4C00056A6F6249647400134C6A6176612F6C616E672F496E74656765723B4C000A6D6574686F644E616D6571007E00094C0006706172616D7371007E00094C000672656D61726B71007E00094C000673746174757371007E000C7870740011436F75706F6E4F7665726475655461736B7372000E6A6176612E7574696C2E44617465686A81014B597419030000787077080000017D73EAC7107874000D30202A2F31202A202A202A203F737200116A6176612E6C616E672E426F6F6C65616ECD207280D59CFAEE0200015A000576616C7565787000737200116A6176612E6C616E672E496E746567657212E2A0A4F781873802000149000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000174000D636F75706F6E4F766572647565740000740015E4BC98E683A0E588B8E8BF87E69C9FE5A484E790867371007E0014000000007800);
INSERT INTO `qrtz_job_details` VALUES ('quartzScheduler', 'TASK_10', 'DEFAULT', NULL, 'com.zbkj.admin.quartz.QuartzJob', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000D4A4F425F504152414D5F4B455973720020636F6D2E7A626B6A2E61646D696E2E6D6F64656C2E5363686564756C654A6F6200000000000000010200094C00086265616E4E616D657400124C6A6176612F6C616E672F537472696E673B4C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C000E63726F6E45787072657373696F6E71007E00094C0007697344656C74657400134C6A6176612F6C616E672F426F6F6C65616E3B4C00056A6F6249647400134C6A6176612F6C616E672F496E74656765723B4C000A6D6574686F644E616D6571007E00094C0006706172616D7371007E00094C000672656D61726B71007E00094C000673746174757371007E000C787074000D53746174656D656E745461736B7372000E6A6176612E7574696C2E44617465686A81014B5974190300007870770800000180072333087874000B30203020322031202A203F737200116A6176612E6C616E672E426F6F6C65616ECD207280D59CFAEE0200015A000576616C7565787000737200116A6176612E6C616E672E496E746567657212E2A0A4F781873802000149000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000A74000E6D6F6E746853746174656D656E74740000740018E6AF8FE69C88E5B890E58D95E5AE9AE697B6E4BBBBE58AA17371007E0014000000007800);
INSERT INTO `qrtz_job_details` VALUES ('quartzScheduler', 'TASK_2', 'DEFAULT', NULL, 'com.zbkj.admin.quartz.QuartzJob', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000D4A4F425F504152414D5F4B455973720020636F6D2E7A626B6A2E61646D696E2E6D6F64656C2E5363686564756C654A6F6200000000000000010200094C00086265616E4E616D657400124C6A6176612F6C616E672F537472696E673B4C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C000E63726F6E45787072657373696F6E71007E00094C0007697344656C74657400134C6A6176612F6C616E672F426F6F6C65616E3B4C00056A6F6249647400134C6A6176612F6C616E672F496E74656765723B4C000A6D6574686F644E616D6571007E00094C0006706172616D7371007E00094C000672656D61726B71007E00094C000673746174757371007E000C78707400134F726465724175746F43616E63656C5461736B7372000E6A6176612E7574696C2E44617465686A81014B597419030000787077080000017D73EAC7107874000D30202A2F31202A202A202A203F737200116A6176612E6C616E672E426F6F6C65616ECD207280D59CFAEE0200015A000576616C7565787000737200116A6176612E6C616E672E496E746567657212E2A0A4F781873802000149000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000274000A6175746F43616E63656C740000740021E7B3BBE7BB9FE887AAE58AA8E58F96E6B688E69CAAE694AFE4BB98E8AEA2E58D957371007E0014000000007800);
INSERT INTO `qrtz_job_details` VALUES ('quartzScheduler', 'TASK_3', 'DEFAULT', NULL, 'com.zbkj.admin.quartz.QuartzJob', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000D4A4F425F504152414D5F4B455973720020636F6D2E7A626B6A2E61646D696E2E6D6F64656C2E5363686564756C654A6F6200000000000000010200094C00086265616E4E616D657400124C6A6176612F6C616E672F537472696E673B4C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C000E63726F6E45787072657373696F6E71007E00094C0007697344656C74657400134C6A6176612F6C616E672F426F6F6C65616E3B4C00056A6F6249647400134C6A6176612F6C616E672F496E74656765723B4C000A6D6574686F644E616D6571007E00094C0006706172616D7371007E00094C000672656D61726B71007E00094C000673746174757371007E000C787074000F4F7264657243616E63656C5461736B7372000E6A6176612E7574696C2E44617465686A81014B597419030000787077080000017D73EAC7107874000D30202A2F31202A202A202A203F737200116A6176612E6C616E672E426F6F6C65616ECD207280D59CFAEE0200015A000576616C7565787000737200116A6176612E6C616E672E496E746567657212E2A0A4F781873802000149000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000374000A7573657243616E63656C740000740018E794A8E688B7E58F96E6B688E8AEA2E58D95E5A484E790867371007E0014000000007800);
INSERT INTO `qrtz_job_details` VALUES ('quartzScheduler', 'TASK_4', 'DEFAULT', NULL, 'com.zbkj.admin.quartz.QuartzJob', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000D4A4F425F504152414D5F4B455973720020636F6D2E7A626B6A2E61646D696E2E6D6F64656C2E5363686564756C654A6F6200000000000000010200094C00086265616E4E616D657400124C6A6176612F6C616E672F537472696E673B4C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C000E63726F6E45787072657373696F6E71007E00094C0007697344656C74657400134C6A6176612F6C616E672F426F6F6C65616E3B4C00056A6F6249647400134C6A6176612F6C616E672F496E74656765723B4C000A6D6574686F644E616D6571007E00094C0006706172616D7371007E00094C000672656D61726B71007E00094C000673746174757371007E000C78707400134F72646572506179537563636573735461736B7372000E6A6176612E7574696C2E44617465686A81014B597419030000787077080000017D73EACAF87874000D30202A2F31202A202A202A203F737200116A6176612E6C616E672E426F6F6C65616ECD207280D59CFAEE0200015A000576616C7565787000737200116A6176612E6C616E672E496E746567657212E2A0A4F781873802000149000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000474000D6F72646572506179416674657274000074001EE8AEA2E58D95E694AFE4BB98E68890E58A9FE5908EE7BDAEE5A484E790867371007E0014000000007800);
INSERT INTO `qrtz_job_details` VALUES ('quartzScheduler', 'TASK_5', 'DEFAULT', NULL, 'com.zbkj.admin.quartz.QuartzJob', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000D4A4F425F504152414D5F4B455973720020636F6D2E7A626B6A2E61646D696E2E6D6F64656C2E5363686564756C654A6F6200000000000000010200094C00086265616E4E616D657400124C6A6176612F6C616E672F537472696E673B4C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C000E63726F6E45787072657373696F6E71007E00094C0007697344656C74657400134C6A6176612F6C616E672F426F6F6C65616E3B4C00056A6F6249647400134C6A6176612F6C616E672F496E74656765723B4C000A6D6574686F644E616D6571007E00094C0006706172616D7371007E00094C000672656D61726B71007E00094C000673746174757371007E000C787074000F4F72646572526566756E645461736B7372000E6A6176612E7574696C2E44617465686A81014B597419030000787077080000017D73EACAF87874000D30202A2F31202A202A202A203F737200116A6176612E6C616E672E426F6F6C65616ECD207280D59CFAEE0200015A000576616C7565787000737200116A6176612E6C616E672E496E746567657212E2A0A4F781873802000149000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000574000B6F72646572526566756E64740000740012E8AEA2E58D95E98080E6ACBEE5A484E790867371007E0014000000007800);
INSERT INTO `qrtz_job_details` VALUES ('quartzScheduler', 'TASK_6', 'DEFAULT', NULL, 'com.zbkj.admin.quartz.QuartzJob', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000D4A4F425F504152414D5F4B455973720020636F6D2E7A626B6A2E61646D696E2E6D6F64656C2E5363686564756C654A6F6200000000000000010200094C00086265616E4E616D657400124C6A6176612F6C616E672F537472696E673B4C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C000E63726F6E45787072657373696F6E71007E00094C0007697344656C74657400134C6A6176612F6C616E672F426F6F6C65616E3B4C00056A6F6249647400134C6A6176612F6C616E672F496E74656765723B4C000A6D6574686F644E616D6571007E00094C0006706172616D7371007E00094C000672656D61726B71007E00094C000673746174757371007E000C787074000E537461746973746963735461736B7372000E6A6176612E7574696C2E44617465686A81014B597419030000787077080000017D73EACAF87874000D3020302030202A2F31202A203F737200116A6176612E6C616E672E426F6F6C65616ECD207280D59CFAEE0200015A000576616C7565787000737200116A6176612E6C616E672E496E746567657212E2A0A4F781873802000149000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000674000A73746174697374696373740000740012E7BB9FE8AEA1E5AE9AE697B6E4BBBBE58AA17371007E0014000000007800);
INSERT INTO `qrtz_job_details` VALUES ('quartzScheduler', 'TASK_7', 'DEFAULT', NULL, 'com.zbkj.admin.quartz.QuartzJob', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000D4A4F425F504152414D5F4B455973720020636F6D2E7A626B6A2E61646D696E2E6D6F64656C2E5363686564756C654A6F6200000000000000010200094C00086265616E4E616D657400124C6A6176612F6C616E672F537472696E673B4C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C000E63726F6E45787072657373696F6E71007E00094C0007697344656C74657400134C6A6176612F6C616E672F426F6F6C65616E3B4C00056A6F6249647400134C6A6176612F6C616E672F496E74656765723B4C000A6D6574686F644E616D6571007E00094C0006706172616D7371007E00094C000672656D61726B71007E00094C000673746174757371007E000C78707400114175746F44656C6574654C6F675461736B7372000E6A6176612E7574696C2E44617465686A81014B597419030000787077080000017E290C96F07874000D3020302030202A2F31202A203F737200116A6176612E6C616E672E426F6F6C65616ECD207280D59CFAEE0200015A000576616C7565787000737200116A6176612E6C616E672E496E746567657212E2A0A4F781873802000149000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000774000D6175746F44656C6574654C6F67740000740024E887AAE58AA8E588A0E999A4E4B88DE99C80E8A681E79A84E58E86E58FB2E697A5E5BF977371007E0014000000007800);
INSERT INTO `qrtz_job_details` VALUES ('quartzScheduler', 'TASK_8', 'DEFAULT', NULL, 'com.zbkj.admin.quartz.QuartzJob', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000D4A4F425F504152414D5F4B455973720020636F6D2E7A626B6A2E61646D696E2E6D6F64656C2E5363686564756C654A6F6200000000000000010200094C00086265616E4E616D657400124C6A6176612F6C616E672F537472696E673B4C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C000E63726F6E45787072657373696F6E71007E00094C0007697344656C74657400134C6A6176612F6C616E672F426F6F6C65616E3B4C00056A6F6249647400134C6A6176612F6C616E672F496E74656765723B4C000A6D6574686F644E616D6571007E00094C0006706172616D7371007E00094C000672656D61726B71007E00094C000673746174757371007E000C78707400164F726465724175746F526563656976696E675461736B7372000E6A6176612E7574696C2E44617465686A81014B597419030000787077080000017E290C96F07874000D3020302030202A2F31202A203F737200116A6176612E6C616E672E426F6F6C65616ECD207280D59CFAEE0200015A000576616C7565787000737200116A6176612E6C616E672E496E746567657212E2A0A4F781873802000149000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000874000D6175746F526563656976696E6774000074000CE887AAE58AA8E694B6E8B4A77371007E0014000000007800);
INSERT INTO `qrtz_job_details` VALUES ('quartzScheduler', 'TASK_9', 'DEFAULT', NULL, 'com.zbkj.admin.quartz.QuartzJob', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000D4A4F425F504152414D5F4B455973720020636F6D2E7A626B6A2E61646D696E2E6D6F64656C2E5363686564756C654A6F6200000000000000010200094C00086265616E4E616D657400124C6A6176612F6C616E672F537472696E673B4C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C000E63726F6E45787072657373696F6E71007E00094C0007697344656C74657400134C6A6176612F6C616E672F426F6F6C65616E3B4C00056A6F6249647400134C6A6176612F6C616E672F496E74656765723B4C000A6D6574686F644E616D6571007E00094C0006706172616D7371007E00094C000672656D61726B71007E00094C000673746174757371007E000C787074000D53746174656D656E745461736B7372000E6A6176612E7574696C2E44617465686A81014B5974190300007870770800000180040F8E507874000D3020302030202A2F31202A203F737200116A6176612E6C616E672E426F6F6C65616ECD207280D59CFAEE0200015A000576616C7565787000737200116A6176612E6C616E672E496E746567657212E2A0A4F781873802000149000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000974000E6461696C7953746174656D656E74740000740018E6AF8FE697A5E5B890E58D95E5AE9AE697B6E4BBBBE58AA17371007E0014000000007800);

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `LOCK_NAME` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `LOCK_NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------
INSERT INTO `qrtz_locks` VALUES ('quartzScheduler', 'TRIGGER_ACCESS');

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_GROUP`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `INSTANCE_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `LAST_CHECKIN_TIME` bigint(13) NOT NULL,
  `CHECKIN_INTERVAL` bigint(13) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `INSTANCE_NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `TRIGGER_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `REPEAT_COUNT` bigint(7) NOT NULL,
  `REPEAT_INTERVAL` bigint(12) NOT NULL,
  `TIMES_TRIGGERED` bigint(10) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  CONSTRAINT `QRTZ_SIMPLE_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `TRIGGER_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `STR_PROP_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `STR_PROP_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `STR_PROP_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `INT_PROP_1` int(11) NULL DEFAULT NULL,
  `INT_PROP_2` int(11) NULL DEFAULT NULL,
  `LONG_PROP_1` bigint(20) NULL DEFAULT NULL,
  `LONG_PROP_2` bigint(20) NULL DEFAULT NULL,
  `DEC_PROP_1` decimal(13, 4) NULL DEFAULT NULL,
  `DEC_PROP_2` decimal(13, 4) NULL DEFAULT NULL,
  `BOOL_PROP_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `BOOL_PROP_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  CONSTRAINT `QRTZ_SIMPROP_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `TRIGGER_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `JOB_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `JOB_GROUP` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `DESCRIPTION` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `NEXT_FIRE_TIME` bigint(13) NULL DEFAULT NULL,
  `PREV_FIRE_TIME` bigint(13) NULL DEFAULT NULL,
  `PRIORITY` int(11) NULL DEFAULT NULL,
  `TRIGGER_STATE` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `TRIGGER_TYPE` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `START_TIME` bigint(13) NOT NULL,
  `END_TIME` bigint(13) NULL DEFAULT NULL,
  `CALENDAR_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `MISFIRE_INSTR` smallint(2) NULL DEFAULT NULL,
  `JOB_DATA` blob NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  INDEX `SCHED_NAME`(`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) USING BTREE,
  CONSTRAINT `QRTZ_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) REFERENCES `qrtz_job_details` (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------
INSERT INTO `qrtz_triggers` VALUES ('quartzScheduler', 'TASK_1', 'DEFAULT', 'TASK_1', 'DEFAULT', NULL, 1745285580000, 1745285520000, 5, 'WAITING', 'CRON', 1743556943000, 0, NULL, 1, '');
INSERT INTO `qrtz_triggers` VALUES ('quartzScheduler', 'TASK_10', 'DEFAULT', 'TASK_10', 'DEFAULT', NULL, 1746036000000, -1, 5, 'WAITING', 'CRON', 1743556947000, 0, NULL, 1, '');
INSERT INTO `qrtz_triggers` VALUES ('quartzScheduler', 'TASK_2', 'DEFAULT', 'TASK_2', 'DEFAULT', NULL, 1745285580000, 1745285520000, 5, 'WAITING', 'CRON', 1743556944000, 0, NULL, 1, '');
INSERT INTO `qrtz_triggers` VALUES ('quartzScheduler', 'TASK_3', 'DEFAULT', 'TASK_3', 'DEFAULT', NULL, 1745285580000, 1745285520000, 5, 'WAITING', 'CRON', 1743556944000, 0, NULL, 1, '');
INSERT INTO `qrtz_triggers` VALUES ('quartzScheduler', 'TASK_4', 'DEFAULT', 'TASK_4', 'DEFAULT', NULL, 1745285580000, 1745285520000, 5, 'WAITING', 'CRON', 1743556945000, 0, NULL, 1, '');
INSERT INTO `qrtz_triggers` VALUES ('quartzScheduler', 'TASK_5', 'DEFAULT', 'TASK_5', 'DEFAULT', NULL, 1745285580000, 1745285520000, 5, 'WAITING', 'CRON', 1743556945000, 0, NULL, 1, '');
INSERT INTO `qrtz_triggers` VALUES ('quartzScheduler', 'TASK_6', 'DEFAULT', 'TASK_6', 'DEFAULT', NULL, 1745337600000, 1745284167221, 5, 'WAITING', 'CRON', 1743556946000, 0, NULL, 1, '');
INSERT INTO `qrtz_triggers` VALUES ('quartzScheduler', 'TASK_7', 'DEFAULT', 'TASK_7', 'DEFAULT', NULL, 1745337600000, 1745284167493, 5, 'WAITING', 'CRON', 1743556946000, 0, NULL, 1, '');
INSERT INTO `qrtz_triggers` VALUES ('quartzScheduler', 'TASK_8', 'DEFAULT', 'TASK_8', 'DEFAULT', NULL, 1745337600000, 1745284167761, 5, 'WAITING', 'CRON', 1743556946000, 0, NULL, 1, '');
INSERT INTO `qrtz_triggers` VALUES ('quartzScheduler', 'TASK_9', 'DEFAULT', 'TASK_9', 'DEFAULT', NULL, 1745337600000, 1745284168035, 5, 'WAITING', 'CRON', 1743556947000, 0, NULL, 1, '');

SET FOREIGN_KEY_CHECKS = 1;
