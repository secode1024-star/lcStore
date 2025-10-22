-- 添加Google Client Secret配置到系统配置表
-- 基于正确的eb_system_config表结构

-- 首先查看当前Google相关配置
SELECT '=== 当前Google配置 ===' as info;
SELECT `id`, `name`, `title`, `value`, `status`, `form_id` 
FROM `eb_system_config` 
WHERE `name` LIKE '%google%' 
ORDER BY `id`;

-- 添加Google Client Secret配置项
INSERT IGNORE INTO `eb_system_config` (
    `name`, 
    `title`, 
    `value`, 
    `status`, 
    `form_id`
) VALUES (
    'google_client_secret', 
    'Google Client Secret', 
    '', 
    0, 
    0
);

-- 确保Google Client ID配置存在
INSERT IGNORE INTO `eb_system_config` (
    `name`, 
    `title`, 
    `value`, 
    `status`, 
    `form_id`
) VALUES (
    'google_client_id', 
    'Google Client ID', 
    '720049488693-0jk9qha3fut1rrjqohpb883tou61co2n.apps.googleusercontent.com', 
    0, 
    0
);

-- 确保Google开关存在
INSERT IGNORE INTO `eb_system_config` (
    `name`, 
    `title`, 
    `value`, 
    `status`, 
    `form_id`
) VALUES (
    'google_open', 
    'Google登录开关', 
    '1', 
    0, 
    0
);

-- 查看添加后的配置
SELECT '=== 添加后的Google配置 ===' as info;
SELECT `id`, `name`, `title`, `value`, `status`, `form_id` 
FROM `eb_system_config` 
WHERE `name` LIKE '%google%' 
ORDER BY `id`;

-- 显示需要手动设置的提示
SELECT '=== 重要提示 ===' as info;
SELECT '请在管理后台手动设置以下配置：' as message;
SELECT '1. Google Client Secret: 从Google API Console获取客户端密钥' as step1;
SELECT '2. Google Client ID: 确认当前值是否正确' as step2;
SELECT '3. Google登录开关: 设置为1（开启）' as step3;
SELECT '4. 重启后端服务以使配置生效' as step4;










