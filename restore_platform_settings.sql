-- ============================================
-- 恢复平台设置数据
-- 注意：如果这些表的数据被误删，需要从备份恢复
-- 如果没有备份，可以尝试重新初始化
-- ============================================

-- 1. 首先检查平台设置相关表的数据情况
SELECT 'eb_system_config 表数据量' AS table_name, COUNT(*) AS record_count FROM `eb_system_config`
UNION ALL
SELECT 'eb_system_group 表数据量', COUNT(*) FROM `eb_system_group`
UNION ALL
SELECT 'eb_system_group_data 表数据量', COUNT(*) FROM `eb_system_group_data`
UNION ALL
SELECT 'eb_system_form_temp 表数据量', COUNT(*) FROM `eb_system_form_temp`
UNION ALL
SELECT 'eb_category 表数据量(type=6)', COUNT(*) FROM `eb_category` WHERE `type` = 6;

-- ============================================
-- 2. 检查平台设置分类数据（type=6 是平台设置分类）
-- ============================================
SELECT 
    id, name, pid, type, status, sort, path
FROM `eb_category`
WHERE `type` = 6
ORDER BY sort, id;

-- ============================================
-- 3. 检查系统表单模板（平台设置的表单模板）
-- ============================================
SELECT 
    id, name, info, content, create_time
FROM `eb_system_form_temp`
WHERE name LIKE '%平台%' OR name LIKE '%设置%' OR name LIKE '%币种%'
ORDER BY id;

-- ============================================
-- 4. 检查系统配置数据（根据form_id关联）
-- ============================================
SELECT 
    sc.id, sc.name, sc.title, sc.form_id, sc.value, sc.status, sft.name AS form_name
FROM `eb_system_config` sc
LEFT JOIN `eb_system_form_temp` sft ON sc.form_id = sft.id
WHERE sft.name LIKE '%平台%' OR sft.name LIKE '%设置%' OR sft.name LIKE '%币种%'
   OR sc.name LIKE '%currency%' OR sc.name LIKE '%币种%'
ORDER BY sc.form_id, sc.id;

-- ============================================
-- 5. 如果eb_category表中type=6的数据被删除，需要恢复平台设置分类
-- 注意：请根据实际情况调整id、pid、path等字段的值
-- ============================================
-- 检查是否已有平台设置分类
SELECT COUNT(*) AS platform_category_count 
FROM `eb_category` 
WHERE `type` = 6 AND (name LIKE '%平台%' OR name LIKE '%设置%');

-- 如果没有数据，可以尝试插入（请根据实际情况调整）
-- INSERT INTO `eb_category` (`name`, `pid`, `type`, `status`, `sort`, `path`, `create_time`, `update_time`) VALUES
-- ('平台设置', 0, 6, 1, 1, '/0/', NOW(), NOW());

-- ============================================
-- 6. 如果eb_system_form_temp表被清空，需要恢复表单模板
-- 注意：表单模板的content字段是JSON格式，包含表单配置
-- 这里只提供示例，实际需要完整的表单配置JSON
-- ============================================
-- 检查币种配置表单模板是否存在
SELECT * FROM `eb_system_form_temp` WHERE name LIKE '%币种%' OR name LIKE '%currency%';

-- 如果没有，可以尝试插入（需要完整的表单配置JSON）
-- INSERT INTO `eb_system_form_temp` (`name`, `info`, `content`, `create_time`, `update_time`) VALUES
-- ('币种配置', '平台币种配置', '{"form": [...]}', NOW(), NOW());

-- ============================================
-- 7. 如果eb_system_config表被清空，需要恢复配置数据
-- 注意：币种配置的key通常是 'shop_pay_currency'
-- ============================================
-- 检查币种配置是否存在
SELECT * FROM `eb_system_config` WHERE name = 'shop_pay_currency' OR name LIKE '%currency%';

-- 如果没有，可以尝试插入（需要先有对应的form_id）
-- INSERT INTO `eb_system_config` (`name`, `title`, `form_id`, `value`, `status`, `create_time`, `update_time`) VALUES
-- ('shop_pay_currency', '商城支付币种', 1, 'USD', 1, NOW(), NOW());

-- ============================================
-- 8. 重要提示：
-- 1. 如果这些表的数据被删除，最好的恢复方式是从数据库备份恢复
-- 2. 如果没有备份，需要联系系统管理员或查看系统初始化脚本
-- 3. 平台设置的数据通常包括：
--    - 币种配置 (shop_pay_currency)
--    - 首页轮播图配置 (通过eb_group_config表，tag=1)
--    - 系统参数配置 (通过eb_system_config表)
--    - 其他平台级配置
-- 4. 如果eb_category表中type=6的数据被删除，平台设置菜单会无法显示
-- 5. 如果eb_system_form_temp表中的表单模板被删除，平台设置页面会无法加载表单
-- 6. 如果eb_system_config表中的配置数据被删除，配置值会丢失
-- ============================================

-- 9. 查看eb_group_config表中的首页配置（tag=1是首页banner）
SELECT * FROM `eb_group_config` WHERE tag = 1 AND mer_id = 0 ORDER BY sort;

-- 10. 如果首页配置被删除，可以尝试恢复（需要根据实际情况调整）
-- INSERT INTO `eb_group_config` (`tag`, `mer_id`, `name`, `link_url`, `image_url`, `value`, `message`, `status`, `sort`, `is_del`, `create_time`, `update_time`) VALUES
-- (1, 0, '首页Banner1', '', '', '', '', 1, 1, 0, NOW(), NOW());

-- ============================================
-- 11. 如果确认需要恢复，请先备份当前数据，然后执行恢复操作
-- 建议：先执行查询语句确认哪些数据丢失，然后从备份恢复
-- ============================================

