/**
 * 修复版Google OAuth 2.0登录实现
 * 基于Google官方文档的标准OAuth 2.0授权码流程
 */

export default {
  /**
   * 初始化Google OAuth登录
   * @param {string} clientId - Google Client ID
   * @param {function} onSuccess - 成功回调
   * @param {function} onError - 错误回调
   * @param {string} redirectUri - 重定向URI（可选，默认使用当前域名+/auth/google/callback）
   */
  initGoogleLogin(clientId, onSuccess, onError, redirectUri = null) {
    if (!clientId) {
      console.error('❌ Google Client ID未配置');
      onError('Google Client ID未配置');
      return;
    }

    // 设置默认重定向URI
    if (!redirectUri) {
      redirectUri = window.location.origin + '/auth/google/callback';
    }

    console.log('🚀 初始化Google OAuth 2.0登录');
    console.log('📋 Client ID:', clientId);
    console.log('📋 Redirect URI:', redirectUri);

    return {
      startLogin: () => this.startOAuthFlow(clientId, redirectUri, onSuccess, onError),
      handleCallback: (urlParams) => this.handleOAuthCallback(urlParams, onSuccess, onError)
    };
  },

  /**
   * 开始OAuth 2.0授权流程
   */
  startOAuthFlow(clientId, redirectUri, onSuccess, onError) {
    try {
      // 生成state参数防止CSRF攻击
      const state = this.generateState();
      
      // 保存状态信息
      const authState = {
        state: state,
        timestamp: Date.now(),
        clientId: clientId,
        redirectUri: redirectUri,
        returnUrl: window.location.href
      };
      
      sessionStorage.setItem('google_oauth_state', JSON.stringify(authState));
      
      // 构建Google OAuth 2.0授权URL
      const authUrl = this.buildAuthUrl(clientId, redirectUri, state);
      
      console.log('🔗 跳转到Google授权页面:', authUrl);
      
      // 跳转到Google授权页面
      window.location.href = authUrl;
      
    } catch (error) {
      console.error('❌ 启动OAuth流程失败:', error);
      onError('启动Google登录失败: ' + error.message);
    }
  },

  /**
   * 构建Google OAuth 2.0授权URL
   */
  buildAuthUrl(clientId, redirectUri, state) {
    const baseUrl = 'https://accounts.google.com/o/oauth2/v2/auth';
    
    const params = new URLSearchParams({
      client_id: clientId,
      response_type: 'code',
      scope: 'openid email profile',
      redirect_uri: redirectUri,
      state: state,
      access_type: 'offline',
      prompt: 'select_account',
      include_granted_scopes: 'true'
    });
    
    return `${baseUrl}?${params.toString()}`;
  },

  /**
   * 处理OAuth回调
   */
  handleOAuthCallback(urlParams, onSuccess, onError) {
    try {
      console.log('🔄 处理Google OAuth回调');
      
      const code = urlParams.get('code');
      const state = urlParams.get('state');
      const error = urlParams.get('error');
      const errorDescription = urlParams.get('error_description');
      
      // 检查是否有错误
      if (error) {
        console.error('❌ Google授权错误:', error, errorDescription);
        onError(errorDescription || error);
        return;
      }
      
      // 检查必要参数
      if (!code || !state) {
        console.error('❌ 缺少必要的回调参数');
        onError('Google授权回调参数不完整');
        return;
      }
      
      // 验证state参数
      if (!this.validateState(state)) {
        console.error('❌ State参数验证失败');
        onError('安全验证失败，请重新登录');
        return;
      }
      
      // 获取保存的状态信息
      const savedState = JSON.parse(sessionStorage.getItem('google_oauth_state'));
      
      // 构建登录数据发送给后端
      const loginData = {
        code: code,
        redirect_uri: savedState.redirectUri,
        client_id: savedState.clientId,
        state: state
      };
      
      console.log('✅ OAuth回调验证成功，发送登录数据给后端');
      onSuccess(loginData);
      
      // 清理状态信息
      sessionStorage.removeItem('google_oauth_state');
      
    } catch (error) {
      console.error('❌ 处理OAuth回调失败:', error);
      onError('处理Google登录回调失败: ' + error.message);
    }
  },

  /**
   * 生成随机state参数
   */
  generateState() {
    const array = new Uint32Array(4);
    window.crypto.getRandomValues(array);
    return Array.from(array, dec => dec.toString(16)).join('');
  },

  /**
   * 验证state参数
   */
  validateState(receivedState) {
    try {
      const savedStateStr = sessionStorage.getItem('google_oauth_state');
      if (!savedStateStr) {
        console.error('❌ 未找到保存的状态信息');
        return false;
      }
      
      const savedState = JSON.parse(savedStateStr);
      
      // 检查state是否匹配
      if (savedState.state !== receivedState) {
        console.error('❌ State参数不匹配');
        return false;
      }
      
      // 检查时间戳（防止重放攻击）
      const now = Date.now();
      const maxAge = 10 * 60 * 1000; // 10分钟
      if (now - savedState.timestamp > maxAge) {
        console.error('❌ 授权请求已过期');
        return false;
      }
      
      return true;
    } catch (error) {
      console.error('❌ State验证异常:', error);
      return false;
    }
  },

  /**
   * 创建Google登录按钮
   */
  createLoginButton(element, clientId, onSuccess, onError, options = {}) {
    const defaultOptions = {
      text: '使用Google登录',
      style: {
        padding: '10px 20px',
        border: '1px solid #dadce0',
        borderRadius: '4px',
        background: 'white',
        cursor: 'pointer',
        fontSize: '14px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        width: '100%',
        transition: 'all 0.3s ease'
      }
    };
    
    const config = { ...defaultOptions, ...options };
    
    // 创建按钮HTML
    element.innerHTML = `
      <button id="google-login-btn" style="${this.styleObjectToString(config.style)}">
        <svg width="18" height="18" viewBox="0 0 18 18" style="margin-right: 8px;">
          <path fill="#4285F4" d="M16.51 8H8.98v3h4.3c-.18 1-.74 1.48-1.6 2.04v2.01h2.6a7.8 7.8 0 0 0 2.38-5.88c0-.57-.05-.66-.15-1.18z"/>
          <path fill="#34A853" d="M8.98 17c2.16 0 3.97-.72 5.3-1.94l-2.6-2.04a4.8 4.8 0 0 1-7.18-2.53H1.83v2.07A8 8 0 0 0 8.98 17z"/>
          <path fill="#FBBC05" d="M4.5 10.49a4.8 4.8 0 0 1 0-3.07V5.35H1.83a8 8 0 0 0 0 7.28l2.67-2.14z"/>
          <path fill="#EA4335" d="M8.98 4.72c1.16 0 2.23.4 3.06 1.2l2.3-2.3A8 8 0 0 0 1.83 5.35L4.5 7.42a4.77 4.77 0 0 1 4.48-2.7z"/>
        </svg>
        ${config.text}
      </button>
    `;
    
    // 添加悬停效果
    const button = element.querySelector('#google-login-btn');
    button.addEventListener('mouseover', () => {
      button.style.boxShadow = '0 2px 4px rgba(0,0,0,0.1)';
    });
    button.addEventListener('mouseout', () => {
      button.style.boxShadow = 'none';
    });
    
    // 绑定点击事件
    button.addEventListener('click', () => {
      const oauth = this.initGoogleLogin(clientId, onSuccess, onError);
      oauth.startLogin();
    });
  },

  /**
   * 将样式对象转换为CSS字符串
   */
  styleObjectToString(styleObj) {
    return Object.entries(styleObj)
      .map(([key, value]) => `${key.replace(/([A-Z])/g, '-$1').toLowerCase()}: ${value}`)
      .join('; ');
  }
};















