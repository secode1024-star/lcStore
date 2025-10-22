-- 清空订单数据的SQL脚本
-- 注意：此操作会删除所有订单相关数据，请谨慎使用！

-- 1. 首先备份重要数据（可选）
-- CREATE TABLE eb_store_order_backup AS SELECT * FROM eb_store_order;
-- CREATE TABLE eb_master_order_backup AS SELECT * FROM eb_master_order;

-- 2. 删除订单相关数据（按依赖关系顺序删除）

-- 删除订单状态记录
DELETE FROM eb_store_order_status;

-- 删除订单商品详情
DELETE FROM eb_store_order_info;

-- 删除子订单
DELETE FROM eb_store_order;

-- 删除主订单
DELETE FROM eb_master_order;

-- 删除订单日志（如果存在）
DELETE FROM eb_store_order_log;

-- 删除退款订单（如果需要）
DELETE FROM eb_refund_order;

-- 3. 重置自增ID（可选，让订单号重新从1开始）
ALTER TABLE eb_store_order AUTO_INCREMENT = 1;
ALTER TABLE eb_master_order AUTO_INCREMENT = 1;
ALTER TABLE eb_store_order_status AUTO_INCREMENT = 1;
ALTER TABLE eb_store_order_info AUTO_INCREMENT = 1;

-- 4. 验证删除结果
SELECT 'eb_store_order' as table_name, COUNT(*) as count FROM eb_store_order
UNION ALL
SELECT 'eb_master_order' as table_name, COUNT(*) as count FROM eb_master_order
UNION ALL
SELECT 'eb_store_order_status' as table_name, COUNT(*) as count FROM eb_store_order_status
UNION ALL
SELECT 'eb_store_order_info' as table_name, COUNT(*) as count FROM eb_store_order_info;
