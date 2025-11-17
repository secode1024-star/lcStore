# API 配置修改记录

## 修改日期
2025-11-05

## 修改目的
将 PC 商城前端从生产环境 API 地址切换到本地开发环境。

## 修改文件
`et_pc/nuxt.config.js`

## 修改内容

### 修改前（生产环境）
```javascript
const VUE_APP_API_URL = "https://api.hqlccn.com"; //通过Nginx反向代理访问
```

### 修改后（开发环境）
```javascript
// 【开发环境配置】本地开发时使用本地后端服务
const VUE_APP_API_URL = "http://192.168.32.1:8001"; //本地开发环境，后端服务端口8001
// 【生产环境配置】部署到服务器时需要改回以下配置
// const VUE_APP_API_URL = "https://api.hqlccn.com"; //通过Nginx反向代理访问
```

**注意：** 如果使用 `localhost`，请改为 `http://localhost:8001`；如果使用局域网 IP，请改为 `http://192.168.32.1:8001`

## 恢复方法

### 部署到服务器时需要恢复生产环境配置

1. 打开文件：`et_pc/nuxt.config.js`

2. 将第1-3行修改为：
```javascript
const VUE_APP_API_URL = "https://api.hqlccn.com"; //通过Nginx反向代理访问
```

3. 删除或注释掉开发环境的配置注释

## 相关服务端口

- **crmeb-front 后端服务端口：** 8001（后端 API 服务）
- **PC 商城前端开发服务器端口：** 8000（前端开发服务器，不是 API 服务）
- **重要：** 前端请求必须指向后端服务端口 8001，不能指向前端服务器端口 8000

## 注意事项

- 修改配置后需要重启前端开发服务器（`npm run dev`）
- 确保后端服务（`crmeb-front.jar`）正在运行在 8001 端口
- 如果使用不同的 IP 地址（如 `192.168.32.1`），请相应修改 `VUE_APP_API_URL`


## 修改日期
2025-11-05

## 修改目的
将 PC 商城前端从生产环境 API 地址切换到本地开发环境。

## 修改文件
`et_pc/nuxt.config.js`

## 修改内容

### 修改前（生产环境）
```javascript
const VUE_APP_API_URL = "https://api.hqlccn.com"; //通过Nginx反向代理访问
```

### 修改后（开发环境）
```javascript
// 【开发环境配置】本地开发时使用本地后端服务
const VUE_APP_API_URL = "http://192.168.32.1:8001"; //本地开发环境，后端服务端口8001
// 【生产环境配置】部署到服务器时需要改回以下配置
// const VUE_APP_API_URL = "https://api.hqlccn.com"; //通过Nginx反向代理访问
```

**注意：** 如果使用 `localhost`，请改为 `http://localhost:8001`；如果使用局域网 IP，请改为 `http://192.168.32.1:8001`

## 恢复方法

### 部署到服务器时需要恢复生产环境配置

1. 打开文件：`et_pc/nuxt.config.js`

2. 将第1-3行修改为：
```javascript
const VUE_APP_API_URL = "https://api.hqlccn.com"; //通过Nginx反向代理访问
```

3. 删除或注释掉开发环境的配置注释

## 相关服务端口

- **crmeb-front 后端服务端口：** 8001（后端 API 服务）
- **PC 商城前端开发服务器端口：** 8000（前端开发服务器，不是 API 服务）
- **重要：** 前端请求必须指向后端服务端口 8001，不能指向前端服务器端口 8000

## 注意事项

- 修改配置后需要重启前端开发服务器（`npm run dev`）
- 确保后端服务（`crmeb-front.jar`）正在运行在 8001 端口
- 如果使用不同的 IP 地址（如 `192.168.32.1`），请相应修改 `VUE_APP_API_URL`


















## 修改日期
2025-11-05

## 修改目的
将 PC 商城前端从生产环境 API 地址切换到本地开发环境。

## 修改文件
`et_pc/nuxt.config.js`

## 修改内容

### 修改前（生产环境）
```javascript
const VUE_APP_API_URL = "https://api.hqlccn.com"; //通过Nginx反向代理访问
```

### 修改后（开发环境）
```javascript
// 【开发环境配置】本地开发时使用本地后端服务
const VUE_APP_API_URL = "http://192.168.32.1:8001"; //本地开发环境，后端服务端口8001
// 【生产环境配置】部署到服务器时需要改回以下配置
// const VUE_APP_API_URL = "https://api.hqlccn.com"; //通过Nginx反向代理访问
```

**注意：** 如果使用 `localhost`，请改为 `http://localhost:8001`；如果使用局域网 IP，请改为 `http://192.168.32.1:8001`

## 恢复方法

### 部署到服务器时需要恢复生产环境配置

1. 打开文件：`et_pc/nuxt.config.js`

2. 将第1-3行修改为：
```javascript
const VUE_APP_API_URL = "https://api.hqlccn.com"; //通过Nginx反向代理访问
```

3. 删除或注释掉开发环境的配置注释

## 相关服务端口

- **crmeb-front 后端服务端口：** 8001（后端 API 服务）
- **PC 商城前端开发服务器端口：** 8000（前端开发服务器，不是 API 服务）
- **重要：** 前端请求必须指向后端服务端口 8001，不能指向前端服务器端口 8000

## 注意事项

- 修改配置后需要重启前端开发服务器（`npm run dev`）
- 确保后端服务（`crmeb-front.jar`）正在运行在 8001 端口
- 如果使用不同的 IP 地址（如 `192.168.32.1`），请相应修改 `VUE_APP_API_URL`


## 修改日期
2025-11-05

## 修改目的
将 PC 商城前端从生产环境 API 地址切换到本地开发环境。

## 修改文件
`et_pc/nuxt.config.js`

## 修改内容

### 修改前（生产环境）
```javascript
const VUE_APP_API_URL = "https://api.hqlccn.com"; //通过Nginx反向代理访问
```

### 修改后（开发环境）
```javascript
// 【开发环境配置】本地开发时使用本地后端服务
const VUE_APP_API_URL = "http://192.168.32.1:8001"; //本地开发环境，后端服务端口8001
// 【生产环境配置】部署到服务器时需要改回以下配置
// const VUE_APP_API_URL = "https://api.hqlccn.com"; //通过Nginx反向代理访问
```

**注意：** 如果使用 `localhost`，请改为 `http://localhost:8001`；如果使用局域网 IP，请改为 `http://192.168.32.1:8001`

## 恢复方法

### 部署到服务器时需要恢复生产环境配置

1. 打开文件：`et_pc/nuxt.config.js`

2. 将第1-3行修改为：
```javascript
const VUE_APP_API_URL = "https://api.hqlccn.com"; //通过Nginx反向代理访问
```

3. 删除或注释掉开发环境的配置注释

## 相关服务端口

- **crmeb-front 后端服务端口：** 8001（后端 API 服务）
- **PC 商城前端开发服务器端口：** 8000（前端开发服务器，不是 API 服务）
- **重要：** 前端请求必须指向后端服务端口 8001，不能指向前端服务器端口 8000

## 注意事项

- 修改配置后需要重启前端开发服务器（`npm run dev`）
- 确保后端服务（`crmeb-front.jar`）正在运行在 8001 端口
- 如果使用不同的 IP 地址（如 `192.168.32.1`），请相应修改 `VUE_APP_API_URL`

























