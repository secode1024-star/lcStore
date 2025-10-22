import Vue from "vue";

export default Vue.directive("google-signin-button", {
  bind: function (el, binding, vnode) {
    CheckComponentMethods();
    let clientId = binding.value;
    let isLogging = false; // 🔥 防重复点击标志
    
    console.log('🚀 初始化Google简化登录流程');
    
    // 创建Google登录按钮
    createSimpleGoogleButton();

    function createSimpleGoogleButton() {
      console.log('🔄 创建Google登录按钮');
      el.innerHTML = '<button id="google-login-btn" style="padding: 10px 20px; border: 1px solid #dadce0; border-radius: 4px; background: white; cursor: pointer; font-size: 14px; display: flex; align-items: center; justify-content: center; width: 100%; transition: all 0.3s ease;" onmouseover="this.style.boxShadow=\'0 2px 4px rgba(0,0,0,0.1)\'" onmouseout="this.style.boxShadow=\'none\'"><svg width="18" height="18" viewBox="0 0 18 18" style="margin-right: 8px;"><path fill="#4285F4" d="M16.51 8H8.98v3h4.3c-.18 1-.74 1.48-1.6 2.04v2.01h2.6a7.8 7.8 0 0 0 2.38-5.88c0-.57-.05-.66-.15-1.18z"/><path fill="#34A853" d="M8.98 17c2.16 0 3.97-.72 5.3-1.94l-2.6-2.04a4.8 4.8 0 0 1-7.18-2.53H1.83v2.07A8 8 0 0 0 8.98 17z"/><path fill="#FBBC05" d="M4.5 10.49a4.8 4.8 0 0 1 0-3.07V5.35H1.83a8 8 0 0 0 0 7.28l2.67-2.14z"/><path fill="#EA4335" d="M8.98 4.72c1.16 0 2.23.4 3.06 1.2l2.3-2.3A8 8 0 0 0 1.83 5.35L4.5 7.42a4.77 4.77 0 0 1 4.48-2.7z"/></svg>使用Google登录</button>';
      
      el.onclick = function() {
        // 🔥 防重复点击检查
        if (isLogging) {
          console.warn('⚠️ Google登录正在进行中，忽略重复点击');
          if (vnode.context.$message) {
            vnode.context.$message.warning('Google登录正在进行中，请稍候...');
          }
          return;
        }
        
        console.log('🔄 Google登录按钮点击');
        startGoogleLogin();
      };
    }

    function startGoogleLogin() {
      console.log('🚀 开始Google登录流程');
      
      // 🔥 设置登录状态，防止重复点击
      isLogging = true;
      
      // 🔥 更新按钮状态
      const btn = el.querySelector('#google-login-btn');
      if (btn) {
        btn.style.opacity = '0.6';
        btn.style.cursor = 'not-allowed';
        btn.innerHTML = '<div style="display: flex; align-items: center; justify-content: center;"><div style="width: 16px; height: 16px; border: 2px solid #f3f3f3; border-top: 2px solid #3498db; border-radius: 50%; animation: spin 1s linear infinite; margin-right: 8px;"></div>正在跳转到Google...</div>';
        
        // 添加旋转动画
        if (!document.getElementById('google-spinner-style')) {
          const style = document.createElement('style');
          style.id = 'google-spinner-style';
          style.textContent = '@keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }';
          document.head.appendChild(style);
        }
      }
      
      // 🔥 不显示额外的消息提示，避免重复
      
      // 直接使用Google Identity Services的弹窗模式
      try {
        // 构建授权URL - 使用postmessage方式避免redirect_uri配置问题
        const origin = window.location.origin;
        // 🔥 使用Google官方推荐的授权码流程
        const state = Date.now().toString(); // 简单的state参数，防止CSRF
        const redirectUri = `${origin}/auth/google/callback`;
        const authUrl = `https://accounts.google.com/o/oauth2/v2/auth?` +
          `client_id=${clientId}&` +
          `response_type=code&` +
          `scope=openid email profile https://www.googleapis.com/auth/userinfo.email&` +
          `access_type=offline&` +
          `include_granted_scopes=true&` +
          `state=${state}&` +
          `prompt=select_account&` +
          `redirect_uri=${encodeURIComponent(redirectUri)}`;
        
        console.log('🔗 Google授权URL:', authUrl);
        
        // 打开弹窗 - 使用当前窗口避免COOP问题
        console.log('🔗 即将跳转到Google授权页面:', authUrl);
        
        // 保存当前状态，包括state参数用于验证
        sessionStorage.setItem('google_login_state', JSON.stringify({
          timestamp: Date.now(),
          clientId: clientId,
          returnUrl: window.location.href,
          state: state
        }));
        
        // 🔥 延迟跳转，给用户看到状态变化
        setTimeout(() => {
          // 直接跳转到Google授权页面
          window.location.href = authUrl;
        }, 800);
        
      } catch (error) {
        console.error('❌ Google登录启动失败:', error);
        
        // 🔥 重置登录状态
        resetLoginState();
        
        vnode.context.OnGoogleAuthFail('Google登录启动失败: ' + error.message);
      }
    }
    
    // 🔥 重置登录状态函数
    function resetLoginState() {
      isLogging = false;
      const btn = el.querySelector('#google-login-btn');
      if (btn) {
        btn.style.opacity = '1';
        btn.style.cursor = 'pointer';
        btn.innerHTML = '<svg width="18" height="18" viewBox="0 0 18 18" style="margin-right: 8px;"><path fill="#4285F4" d="M16.51 8H8.98v3h4.3c-.18 1-.74 1.48-1.6 2.04v2.01h2.6a7.8 7.8 0 0 0 2.38-5.88c0-.57-.05-.66-.15-1.18z"/><path fill="#34A853" d="M8.98 17c2.16 0 3.97-.72 5.3-1.94l-2.6-2.04a4.8 4.8 0 0 1-7.18-2.53H1.83v2.07A8 8 0 0 0 8.98 17z"/><path fill="#FBBC05" d="M4.5 10.49a4.8 4.8 0 0 1 0-3.07V5.35H1.83a8 8 0 0 0 0 7.28l2.67-2.14z"/><path fill="#EA4335" d="M8.98 4.72c1.16 0 2.23.4 3.06 1.2l2.3-2.3A8 8 0 0 0 1.83 5.35L4.5 7.42a4.77 4.77 0 0 1 4.48-2.7z"/></svg>使用Google登录';
      }
    }
    
    function getUserInfo(accessToken) {
      console.log('🔄 使用access_token获取用户信息');
      
      fetch(`https://www.googleapis.com/oauth2/v2/userinfo?access_token=${accessToken}`)
        .then(response => response.json())
        .then(userInfo => {
          console.log('✅ 获取到用户信息:', userInfo);
          
          // 构造ID Token格式的数据
          const userData = {
            sub: userInfo.id,
            email: userInfo.email,
            email_verified: userInfo.verified_email,
            name: userInfo.name,
            picture: userInfo.picture,
            locale: userInfo.locale
          };
          
          // 将用户数据作为"ID Token"发送给后端
          vnode.context.OnGoogleAuthSuccess(JSON.stringify(userData));
        })
        .catch(error => {
          console.error('❌ 获取用户信息失败:', error);
          vnode.context.OnGoogleAuthFail('获取用户信息失败: ' + error.message);
        });
    }


    function CheckComponentMethods() {
      if (!vnode.context.OnGoogleAuthSuccess) {
        throw new Error(
          "The method OnGoogleAuthSuccess must be defined on the component"
        );
      }

      if (!vnode.context.OnGoogleAuthFail) {
        throw new Error(
          "The method OnGoogleAuthFail must be defined on the component"
        );
      }
    }
  },
});