-- 添加Google Client Secret配置到系统配置表
-- 这个脚本会添加缺失的Google Client Secret配置项

-- 首先查看当前Google相关配置
SELECT '=== 当前Google配置 ===' as info;
SELECT `id`, `menu_name`, `key`, `value`, `status`, `info`, `config_tab_id`, `type`, `sort`, `required` 
FROM `eb_system_config` 
WHERE `key` LIKE '%google%' 
ORDER BY `sort`;

-- 添加Google Client Secret配置项
INSERT IGNORE INTO `eb_system_config` (
    `menu_name`, 
    `key`, 
    `value`, 
    `status`, 
    `info`, 
    `config_tab_id`, 
    `type`, 
    `sort`, 
    `required`
) VALUES (
    'Google Client Secret', 
    'google_client_secret', 
    '', 
    1, 
    'Google OAuth客户端密钥，从Google API Console获取', 
    1, 
    'input', 
    4, 
    1
);

-- 如果Google Client ID不存在，也添加它
INSERT IGNORE INTO `eb_system_config` (
    `menu_name`, 
    `key`, 
    `value`, 
    `status`, 
    `info`, 
    `config_tab_id`, 
    `type`, 
    `sort`, 
    `required`
) VALUES (
    'Google Client ID', 
    'google_client_id', 
    '720049488693-0jk9qha3fut1rrjqohpb883tou61co2n.apps.googleusercontent.com', 
    1, 
    'Google OAuth客户端ID，从Google API Console获取', 
    1, 
    'input', 
    3, 
    1
);

-- 确保Google开关存在
INSERT IGNORE INTO `eb_system_config` (
    `menu_name`, 
    `key`, 
    `value`, 
    `status`, 
    `info`, 
    `config_tab_id`, 
    `type`, 
    `sort`, 
    `required`
) VALUES (
    'Google登录开关', 
    'google_open', 
    '1', 
    1, 
    'Google登录功能开关', 
    1, 
    'radio', 
    2, 
    1
);

-- 查看添加后的配置
SELECT '=== 添加后的Google配置 ===' as info;
SELECT `id`, `menu_name`, `key`, `value`, `status`, `info`, `config_tab_id`, `type`, `sort`, `required` 
FROM `eb_system_config` 
WHERE `key` LIKE '%google%' 
ORDER BY `sort`;

-- 显示需要手动设置的提示
SELECT '=== 重要提示 ===' as info;
SELECT '请在管理后台手动设置以下配置：' as message;
SELECT '1. Google Client Secret: 从Google API Console获取' as step1;
SELECT '2. Google Client ID: 确认是否正确' as step2;
SELECT '3. Google登录开关: 设置为开启' as step3;










