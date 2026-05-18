# 数据库初始化指南

## 前置要求

1. **MySQL 5.7+** 已安装并启动
2. **Redis 5+** 已安装并启动
3. MySQL root 用户密码为 `root`（或修改脚本中的密码）

## 快速开始

### Windows 系统

双击运行 `init_database.bat` 或在命令行执行：

```cmd
init_database.bat
```

### Linux/Mac 系统

```bash
chmod +x init_database.sh
./init_database.sh
```

## 手动导入步骤

如果自动脚本失败，可以手动执行以下步骤：

### 1. 创建数据库

```sql
CREATE DATABASE IF NOT EXISTS `java_et` 
DEFAULT CHARACTER SET utf8mb4 
DEFAULT COLLATE utf8mb4_general_ci;
```

### 2. 导入主数据库文件

```bash
# Windows (cmd)
mysql -h127.0.0.1 -P3306 -uroot -proot java_et < et_sql\java_et_2026051411204311r2x.sql

# Linux/Mac
mysql -h127.0.0.1 -P3306 -uroot -proot java_et < et_sql/java_et_2026051411204311r2x.sql
```

或使用 MySQL 客户端：

```sql
USE java_et;
SOURCE D:/Code/CodeWork/shizhanpai/liancai/lcStore/et_sql/java_et_2026051411204311r2x.sql;
```

### 3. 执行增量脚本

```bash
# 添加品牌名称字段
mysql -h127.0.0.1 -P3306 -uroot -proot java_et < et_java/sql/add_brand_name_field.sql

# 创建翻译失败记录表
mysql -h127.0.0.1 -P3306 -uroot -proot java_et < et_java/crmeb-service/src/main/resources/sql/translation_failure_record.sql
```

## 使用图形化工具导入

### Navicat

1. 连接到 MySQL
2. 右键 → 新建数据库 → 名称：`java_et`，字符集：`utf8mb4`
3. 右键数据库 → 运行SQL文件
4. 选择 `et_sql/java_et_2026051411204311r2x.sql`
5. 点击开始执行
6. 重复步骤3-5，依次执行增量脚本

### phpMyAdmin

1. 选择或创建数据库 `java_et`
2. 点击"导入"标签
3. 选择文件 `java_et_2026051411204311r2x.sql`
4. 点击执行
5. 重复步骤2-4，依次执行增量脚本

### MySQL Workbench

1. 连接到 MySQL
2. 创建 Schema：`java_et`
3. Server → Data Import
4. 选择 "Import from Self-Contained File"
5. 选择 `java_et_2026051411204311r2x.sql`
6. 目标 Schema 选择 `java_et`
7. 点击 Start Import
8. 使用 SQL Editor 执行增量脚本

## 数据库配置信息

导入完成后，确认以下配置与项目一致：

**文件位置：** `et_java/crmeb-admin/src/main/resources/application-dev.yml`

```yaml
spring:
  datasource:
    url: jdbc:mysql://127.0.0.1:3306/java_et?characterEncoding=utf-8&useSSL=false&serverTimeZone=GMT+8&allowPublicKeyRetrieval=true
    username: root
    password: root
  redis:
    host: 127.0.0.1
    port: 6379
    password:   # 本地开发无密码
    database: 10
```

## 验证导入结果

导入完成后，可以执行以下SQL验证：

```sql
USE java_et;

-- 查看所有表
SHOW TABLES;

-- 查看表数量（应该有100+张表）
SELECT COUNT(*) FROM information_schema.tables 
WHERE table_schema = 'java_et';

-- 检查关键表是否存在
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'java_et' 
AND table_name IN (
    'eb_user',
    'eb_store_product', 
    'eb_store_order',
    'eb_system_config',
    'eb_translation_failure_record'
);
```

## 常见问题

### 1. 连接失败

**错误：** `ERROR 2003 (HY000): Can't connect to MySQL server`

**解决：**
- 检查 MySQL 服务是否启动
- 确认端口 3306 未被占用
- 检查防火墙设置

### 2. 密码错误

**错误：** `ERROR 1045 (28000): Access denied for user 'root'@'localhost'`

**解决：**
- 修改脚本中的 `MYSQL_PASSWORD` 为实际密码
- 或重置 MySQL root 密码

### 3. 导入超时

**错误：** 导入过程中断或超时

**解决：**
- 增加 MySQL 超时设置：
  ```sql
  SET GLOBAL max_allowed_packet=1073741824;
  SET GLOBAL net_read_timeout=3600;
  SET GLOBAL net_write_timeout=3600;
  ```
- 使用命令行导入而非图形化工具

### 4. 字符集问题

**错误：** 中文乱码

**解决：**
- 确保数据库字符集为 `utf8mb4`
- 检查 MySQL 配置文件 `my.ini` 或 `my.cnf`：
  ```ini
  [client]
  default-character-set=utf8mb4
  
  [mysql]
  default-character-set=utf8mb4
  
  [mysqld]
  character-set-server=utf8mb4
  collation-server=utf8mb4_general_ci
  ```

## 下一步

数据库初始化完成后：

1. ✅ 启动 Redis 服务
2. ✅ 修改 `application-dev.yml` 中的 `imagePath` 配置
3. ✅ 启动 Java 后端项目（端口 20008）
4. ✅ 启动前端项目

## 数据库备份

定期备份数据库：

```bash
# 备份
mysqldump -uroot -proot java_et > backup_$(date +%Y%m%d_%H%M%S).sql

# 恢复
mysql -uroot -proot java_et < backup_20260514_112043.sql
```
