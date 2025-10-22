<template>
  <div v-loading="loading"
       :element-loading-text="$t(`message.login.loginLoading`)"
       element-loading-target="document.body"
       class="callback-x-oauth">
  </div>
</template>

<script>
// 采用OAuth 1.0的简洁回调逻辑，使用Nuxt Auth策略
export default {
  name: "callback_x_oauth",
  auth: false,
  data() {
    return {
      loading: true
    }
  },
  beforeMount() {
  },
  mounted() {
    console.log('🔥🔥🔥 X OAuth 2.0 回调页面已加载！🔥🔥🔥');
    console.log('当前URL:', window.location.href);
    console.log('URL搜索参数:', window.location.search);
    
    // 检查是否有authorization code参数
    if (this.$route.query.code && this.$route.query.state) {
      this.xOAuthLogin();
    } else {
      console.error('❌ 缺少必要的OAuth参数');
      this.$message.error('OAuth回调参数不完整');
      // 🔧 修复：缺少参数时也要清除loading状态
      this.loading = false;
      setTimeout(() => this.$router.push('/'), 3000);
    }
    
    this.$nextTick(() => {
      this.$nuxt.$loading.start();
      this.$nuxt.$loading.finish();
    });
  },
  methods: {
    async xOAuthLogin() {
      console.log('🚀 开始处理 X OAuth 2.0 回调');
      
      // 从Cookie获取之前保存的code_verifier
      let codeVerifier = this.getCodeVerifier();
      if (!codeVerifier) {
        console.error('❌ 未找到code_verifier');
        this.$message.error('OAuth验证失败: 缺少必要参数');
        // 🔧 修复：找不到code_verifier时也要清除loading状态
        this.loading = false;
        setTimeout(() => this.$router.push('/'), 1000);
        return;
      }
      
      console.log('✅ 找到code_verifier:', codeVerifier.substring(0, 20) + '...');
      
        // 动态获取配置信息 - 使用后端返回的小写字段名
        const loginMethodInfo = await this.$axios.get('/api/front/login/method/info');
        const clientId = loginMethodInfo.data.xoauth2ClientId;
        const redirectUri = loginMethodInfo.data.xoauth2CallbackUrlPc;
      
      if (!clientId || !redirectUri) {
        throw new Error('OAuth 2.0配置信息缺失，请联系管理员检查后台配置');
      }
      
      // 构建登录数据，使用动态获取的配置
      let userInfo = {
        authorizationCode: this.$route.query.code,
        state: this.$route.query.state,
        codeVerifier: codeVerifier,
        clientId: clientId,
        redirectUri: redirectUri
      };
      
      console.log('📦 使用Nuxt Auth local7策略登录');
      
      // 使用Nuxt Auth的local7策略登录，类似OAuth 1.0的local6策略
      this.$auth.loginWith('local7', {data: userInfo}).then(res => {
        console.log('X OAuth 2.0 登录成功');
        this.$message.success('登录成功！');
        // 🔧 修复：清除loading状态
        this.loading = false;
        // 🔧 修复：等待认证状态完全同步后再跳转，避免竞态条件
        setTimeout(() => {
          this.$router.push({path: "/"});
        }, 1500); // 给足够时间让auth状态同步
      }).catch(error => {
        console.error('X OAuth 2.0 登录失败:', error);
        this.$message.error('登录失败，请重试');
        // 🔧 修复：登录失败时也要清除loading状态
        this.loading = false;
        setTimeout(() => this.$router.push('/'), 2000);
      });
    },
    
    // 从多个位置尝试获取code_verifier
    getCodeVerifier() {
      console.log('🔍 正在搜索code_verifier...');
      
      // 方法1: Cookie（主要存储，参考OAuth 1.0的做法）
      const cookies = document.cookie.split(';');
      for (let cookie of cookies) {
        const [name, value] = cookie.trim().split('=');
        if (name === 'x_oauth_code_verifier') {
          console.log('✅ 从Cookie找到code_verifier');
          return decodeURIComponent(value);
        }
      }
      
      // 方法2: sessionStorage（备份存储）
      let codeVerifier = sessionStorage.getItem('x_oauth_code_verifier');
      if (codeVerifier) {
        console.log('✅ 从sessionStorage找到code_verifier');
        return codeVerifier;
      }
      
      // 方法3: localStorage（备份存储）
      codeVerifier = localStorage.getItem('x_oauth_code_verifier_backup');
      if (codeVerifier) {
        console.log('✅ 从localStorage备份找到code_verifier');
        return codeVerifier;
      }
      
      console.error('❌ 所有位置都未找到code_verifier');
      return null;
    }
  }
}
</script>

<style scoped lang="scss">
.callback-x-oauth {
  width: 100%;
  min-height: 500px;
  background-color: rgba(0, 0, 0, .5);
  position: fixed;
  top: 0;
  left: 0;
  z-index: 100;
}
</style>