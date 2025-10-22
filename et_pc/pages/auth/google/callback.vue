<template>
  <div class="google-callback">
    <div v-if="loading" class="loading">
      <div class="spinner"></div>
      <p>正在处理Google登录...</p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'GoogleCallback',
  auth: false,
  data() {
    return {
      loading: true
    };
  },
  mounted() {
    console.log('🚀 Google回调页面已加载');
    console.log('🔍 当前URL:', window.location.href);
    
    // 🔥 防重复处理
    if (window.googleCallbackProcessing) {
      console.warn('⚠️ Google回调已在处理中，直接返回');
      return;
    }
    window.googleCallbackProcessing = true;
    
    // 🔥 设置超时保护，防止页面一直卡住
    this.timeoutId = setTimeout(() => {
      if (this.loading) {
        console.error('⏰ 处理超时，强制跳转到首页');
        this.$message.error('Google登录处理超时，请重试');
        this.loading = false;
        window.googleCallbackProcessing = false;
        window.location.href = '/';
      }
    }, 30000); // 30秒超时
    
    // 延迟处理，确保单次执行
    setTimeout(() => {
      this.handleGoogleCallback();
    }, 300);
  },
  
  beforeDestroy() {
    // 清理超时定时器
    if (this.timeoutId) {
      clearTimeout(this.timeoutId);
    }
  },
  methods: {
    handleGoogleCallback() {
      try {
        console.log('🚀 处理Google OAuth回调');
        
        const urlParams = new URLSearchParams(window.location.search);
        const code = urlParams.get('code');
        const state = urlParams.get('state');
        const error = urlParams.get('error');
        
        console.log('🔍 回调参数:', { 
          code: code ? code.substring(0, 20) + '...' : null, 
          state, 
          error 
        });
        
        if (error) {
          console.error('❌ Google授权错误:', error);
          this.$message.error('Google授权失败: ' + error);
          this.loading = false;
          setTimeout(() => window.location.href = '/', 2000);
          return;
        }
        
        if (code && state) {
          this.handleAuthCode(code, state);
        } else {
          console.error('❌ 缺少必要的授权参数');
          this.$message.error('Google授权参数不完整');
          this.loading = false;
          setTimeout(() => window.location.href = '/', 2000);
        }
        
      } catch (error) {
        console.error('❌ 回调处理失败:', error);
        this.$message.error('回调处理失败: ' + error.message);
        this.loading = false;
        setTimeout(() => window.location.href = '/', 2000);
      }
    },
    
    handleAuthCode(code, state) {
      console.log('🚀 处理Google授权码');
      
      // 验证state参数
      const savedState = sessionStorage.getItem('google_login_state');
      if (!savedState) {
        console.error('❌ 未找到保存的状态信息');
        this.$message.error('安全验证失败：状态丢失');
        this.loading = false;
        setTimeout(() => window.location.href = '/', 2000);
        return;
      }
      
      let parsedState;
      try {
        parsedState = JSON.parse(savedState);
      } catch (e) {
        console.error('❌ 状态信息解析失败:', e);
        this.$message.error('安全验证失败：状态解析错误');
        this.loading = false;
        setTimeout(() => window.location.href = '/', 2000);
        return;
      }
      
      if (parsedState.state !== state) {
        console.error('❌ state参数不匹配');
        this.$message.error('安全验证失败：状态不匹配');
        this.loading = false;
        setTimeout(() => window.location.href = '/', 2000);
        return;
      }
      
      
      // 构建登录数据 - 🔥 后端期望的是字符串格式
      const loginDataObj = {
        code: decodeURIComponent(code),
        redirect_uri: window.location.origin + '/auth/google/callback',
        client_id: parsedState.clientId
      };
      
      // 转换为JSON字符串，因为后端控制器接收的是@RequestBody String
      const loginData = JSON.stringify(loginDataObj);
      
      // 使用Nuxt Auth登录
      this.$auth.loginWith('local9', {data: loginData}).then(res => {
        
        
        if (this.$auth.loggedIn) {
          this.$message.success('Google登录成功！');
          this.loading = false;
          
          // 清理状态
          sessionStorage.removeItem('google_login_state');
          window.googleCallbackProcessing = false;
          if (this.timeoutId) clearTimeout(this.timeoutId);
          
          setTimeout(() => {
            window.location.href = '/?t=' + Date.now();
          }, 1500);
          
        } else {
          if (res && res.data && res.data.code === 200) {
            // 后端返回成功，手动设置登录状态
            if (res.data.data && typeof res.data.data === 'object' && res.data.data.token) {
              try {
                const token = res.data.data.token;
                const user = {
                  id: res.data.data.uid || res.data.data.identity,
                  name: res.data.data.nickname || 'Google用户',
                  email: res.data.data.email,
                  phone: res.data.data.phone,
                  identity: res.data.data.identity,
                  userType: res.data.data.userType
                };
                
                
                // 手动设置Nuxt Auth
                this.$auth.setToken('local9', token);
                this.$auth.setUser(user);
                
                // 设置localStorage
                localStorage.setItem('auth.strategy', 'local9');
                localStorage.setItem('auth.loggedIn', 'true');
                localStorage.setItem('auth.token.local9', token);
                localStorage.setItem('auth.user', JSON.stringify(user));
                
                this.$message.success('Google登录成功！');
                this.loading = false;
                
                // 清理状态
                sessionStorage.removeItem('google_login_state');
                window.googleCallbackProcessing = false;
                if (this.timeoutId) clearTimeout(this.timeoutId);
                
                setTimeout(() => {
                  window.location.href = '/?t=' + Date.now();
                }, 1500);
                
              } catch (e) {
                console.error('❌ 手动设置登录状态失败:', e);
                this.$message.error('登录失败：' + e.message);
                this.loading = false;
                
                // 清理状态
                window.googleCallbackProcessing = false;
                if (this.timeoutId) clearTimeout(this.timeoutId);
                
                setTimeout(() => window.location.href = '/', 2000);
              }
            } else {
              console.error('❌ 后端响应格式异常，缺少token');
              console.error('❌ 响应数据:', res.data.data);
              this.$message.error('登录失败：响应格式异常');
              this.loading = false;
              
              // 清理状态
              window.googleCallbackProcessing = false;
              
              setTimeout(() => window.location.href = '/', 2000);
            }
          } else {
            console.error('❌ 后端验证失败');
            this.$message.error('Google登录验证失败');
            this.loading = false;
            
            // 清理状态
            window.googleCallbackProcessing = false;
            
            setTimeout(() => window.location.href = '/', 2000);
          }
        }
        
      }).catch(error => {
        console.error('❌ 登录请求失败:', error);
        
        // 🔥 详细的错误日志记录
        console.error('错误详情:', {
          message: error?.message,
          response: error?.response,
          responseData: error?.response?.data,
          responseStatus: error?.response?.status,
          stack: error?.stack
        });
        
        let errorMsg = 'Google登录失败';
        try {
          if (error && error.response && error.response.data && error.response.data.message) {
            errorMsg += ': ' + error.response.data.message;
          } else if (error && error.message) {
            errorMsg += ': ' + error.message;
          } else {
            errorMsg += ': 网络或服务器错误';
          }
        } catch (e) {
          console.error('❌ 错误信息解析失败:', e);
          errorMsg += ': 未知错误';
        }
        
        this.$message.error(errorMsg);
        this.loading = false;
        
        // 清理状态
        sessionStorage.removeItem('google_login_state');
        window.googleCallbackProcessing = false;
        if (this.timeoutId) clearTimeout(this.timeoutId);
        
        setTimeout(() => {
          window.location.href = '/';
        }, 2000);
      });
    },
    
    // 🔥 处理直接API调用成功的情况
    handleDirectApiSuccess(userData) {
      try {
        
        const token = userData.token;
        const user = {
          id: userData.uid || userData.identity,
          name: userData.nickname || 'Google用户',
          email: userData.email,
          phone: userData.phone,
          identity: userData.identity,
          userType: userData.userType
        };
        
        
        // 手动设置Nuxt Auth
        this.$auth.setToken('local9', token);
        this.$auth.setUser(user);
        
        // 设置localStorage
        localStorage.setItem('auth.strategy', 'local9');
        localStorage.setItem('auth.loggedIn', 'true');
        localStorage.setItem('auth.token.local9', token);
        localStorage.setItem('auth.user', JSON.stringify(user));
        
        this.$message.success('Google登录成功！');
        this.loading = false;
        
        // 清理状态
        sessionStorage.removeItem('google_login_state');
        window.googleCallbackProcessing = false;
        if (this.timeoutId) clearTimeout(this.timeoutId);
        
        setTimeout(() => {
          window.location.href = '/?t=' + Date.now();
        }, 1500);
        
      } catch (e) {
        console.error('❌ 处理直接API成功响应失败:', e);
        this.$message.error('登录失败：' + e.message);
        this.loading = false;
        
        // 清理状态
        window.googleCallbackProcessing = false;
        if (this.timeoutId) clearTimeout(this.timeoutId);
        
        setTimeout(() => window.location.href = '/', 2000);
      }
    }
  }
}
</script>

<style scoped>
.google-callback {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background-color: #f5f5f5;
}

.loading {
  text-align: center;
  padding: 40px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #3498db;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto 20px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.loading p {
  margin: 0;
  color: #666;
  font-size: 16px;
}
</style>