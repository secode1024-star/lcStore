<template>
  <div class="test-container">
    <h1>移动端自动跳转测试页面</h1>
    
    <div class="section">
      <h2>当前设备信息</h2>
      <div class="info-item">
        <strong>User Agent:</strong>
        <p>{{ deviceInfo.userAgent }}</p>
      </div>
      <div class="info-item">
        <strong>屏幕宽度:</strong>
        <p>{{ deviceInfo.screenWidth }}px</p>
      </div>
      <div class="info-item">
        <strong>屏幕高度:</strong>
        <p>{{ deviceInfo.screenHeight }}px</p>
      </div>
      <div class="info-item">
        <strong>是否触摸设备:</strong>
        <p>{{ deviceInfo.isTouchDevice ? '是' : '否' }}</p>
      </div>
      <div class="info-item">
        <strong>检测结果:</strong>
        <p :class="deviceInfo.isMobile ? 'mobile' : 'desktop'">
          {{ deviceInfo.isMobile ? '移动设备 📱' : 'PC设备 💻' }}
        </p>
      </div>
    </div>

    <div class="section">
      <h2>配置信息</h2>
      <div class="info-item">
        <strong>自动跳转状态:</strong>
        <p>{{ config.enableRedirect ? '已启用 ✅' : '已禁用 ❌' }}</p>
      </div>
      <div class="info-item">
        <strong>H5 URL:</strong>
        <p>{{ config.h5Url }}</p>
      </div>
      <div class="info-item">
        <strong>强制PC版本:</strong>
        <p>{{ config.forcePcVersion ? '是 ✅' : '否 ❌' }}</p>
      </div>
    </div>

    <div class="section">
      <h2>操作</h2>
      <button @click="toggleForcePc" class="btn">
        {{ config.forcePcVersion ? '取消强制PC版本' : '强制使用PC版本' }}
      </button>
      <button @click="testRedirect" class="btn btn-primary">
        测试跳转
      </button>
      <button @click="clearStorage" class="btn btn-warning">
        清除存储
      </button>
      <button @click="goHome" class="btn btn-success">
        返回首页测试
      </button>
    </div>

    <div class="section">
      <h2>使用说明</h2>
      <ol>
        <li>使用Chrome DevTools的设备模拟功能测试移动设备</li>
        <li>点击"测试跳转"按钮查看是否会跳转到H5版本</li>
        <li>点击"强制使用PC版本"可以阻止自动跳转</li>
        <li>点击"返回首页测试"会跳转到首页，触发自动检测</li>
      </ol>
    </div>
  </div>
</template>

<script>
export default {
  name: 'MobileRedirectTest',
  data() {
    return {
      deviceInfo: {
        userAgent: '',
        screenWidth: 0,
        screenHeight: 0,
        isTouchDevice: false,
        isMobile: false
      },
      config: {
        enableRedirect: false,
        h5Url: '',
        forcePcVersion: false
      }
    }
  },
  mounted() {
    this.detectDevice();
    this.loadConfig();
  },
  methods: {
    detectDevice() {
      const userAgent = navigator.userAgent || navigator.vendor || window.opera;
      const mobileRegex = /android|webos|iphone|ipad|ipod|blackberry|iemobile|opera mini|mobile|tablet/i;
      const isMobileScreen = window.innerWidth < 768;
      const isTouchDevice = 'ontouchstart' in window || navigator.maxTouchPoints > 0;
      const isMobile = mobileRegex.test(userAgent) || (isMobileScreen && isTouchDevice);

      this.deviceInfo = {
        userAgent: userAgent,
        screenWidth: window.innerWidth,
        screenHeight: window.innerHeight,
        isTouchDevice: isTouchDevice,
        isMobile: isMobile
      };
    },
    loadConfig() {
      this.config = {
        enableRedirect: process.env.ENABLE_MOBILE_REDIRECT !== 'false',
        h5Url: process.env.H5_URL || '/h5',
        forcePcVersion: sessionStorage.getItem('force_pc_version') === 'true'
      };
    },
    toggleForcePc() {
      const newValue = !this.config.forcePcVersion;
      if (newValue) {
        sessionStorage.setItem('force_pc_version', 'true');
        this.$message.success('已设置强制使用PC版本');
      } else {
        sessionStorage.removeItem('force_pc_version');
        this.$message.success('已取消强制PC版本');
      }
      this.config.forcePcVersion = newValue;
    },
    testRedirect() {
      if (!this.config.enableRedirect) {
        this.$message.warning('自动跳转功能已禁用');
        return;
      }
      
      if (this.config.forcePcVersion) {
        this.$message.warning('已设置强制PC版本，不会跳转');
        return;
      }

      if (this.deviceInfo.isMobile) {
        this.$message.success('检测到移动设备，即将跳转...');
        setTimeout(() => {
          window.location.href = this.config.h5Url;
        }, 1000);
      } else {
        this.$message.info('当前是PC设备，不会跳转');
      }
    },
    clearStorage() {
      sessionStorage.clear();
      localStorage.clear();
      this.$message.success('已清除所有存储');
      this.loadConfig();
    },
    goHome() {
      this.$router.push('/');
    }
  }
}
</script>

<style scoped>
.test-container {
  max-width: 1200px;
  margin: 50px auto;
  padding: 20px;
  font-family: Arial, sans-serif;
}

h1 {
  color: #333;
  text-align: center;
  margin-bottom: 40px;
}

h2 {
  color: #666;
  border-bottom: 2px solid #e93323;
  padding-bottom: 10px;
  margin-bottom: 20px;
}

.section {
  background: #fff;
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 30px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.info-item {
  margin-bottom: 15px;
  padding: 10px;
  background: #f9f9f9;
  border-radius: 4px;
}

.info-item strong {
  display: block;
  color: #333;
  margin-bottom: 5px;
}

.info-item p {
  margin: 0;
  color: #666;
  word-break: break-all;
}

.mobile {
  color: #e93323;
  font-weight: bold;
  font-size: 18px;
}

.desktop {
  color: #4CAF50;
  font-weight: bold;
  font-size: 18px;
}

.btn {
  padding: 12px 24px;
  margin: 10px 10px 10px 0;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 16px;
  background: #666;
  color: white;
  transition: all 0.3s;
}

.btn:hover {
  opacity: 0.8;
  transform: translateY(-2px);
}

.btn-primary {
  background: #e93323;
}

.btn-warning {
  background: #ff9800;
}

.btn-success {
  background: #4CAF50;
}

ol {
  padding-left: 20px;
}

ol li {
  margin-bottom: 10px;
  color: #666;
  line-height: 1.6;
}
</style>
