/**
 * Facebook网页授权登录JS SDK for PC端
 * 🔥 事件监听版本 - 使用Facebook SDK状态事件
 */

// 状态管理
let fbStatus = {
  loaded: false,
  ready: false,
  appId: null
};

const facebookWebLogin = {};

/**
 * 🎯 Facebook SDK加载和初始化 - 事件驱动方式
 */
function setupFacebookSDK(appId) {
  return new Promise((resolve, reject) => {
    console.log('🚀 开始Facebook SDK设置，AppId:', appId);
    
    // 如果已经设置过，直接返回
    if (fbStatus.ready && fbStatus.appId === appId) {
      console.log('✅ Facebook SDK已就绪');
      resolve(true);
      return;
    }
    
    fbStatus.appId = appId;
    
    // 🔥 关键：使用Facebook官方推荐的事件监听方式
    window.fbAsyncInit = function() {
      console.log('🎯 Facebook fbAsyncInit 开始执行');
      
      window.FB.init({
        appId: appId,
        cookie: true,
        xfbml: true,
        version: 'v18.0'
      });
      
      console.log('🎯 Facebook SDK初始化完成，监听auth.statusChange事件');
      
      // 🔥 关键：监听Facebook认证状态变化
      window.FB.Event.subscribe('auth.statusChange', function(response) {
        console.log('📡 Facebook认证状态变化:', response);
        if (!fbStatus.ready) {
          fbStatus.ready = true;
          fbStatus.loaded = true;
          console.log('✅ Facebook SDK通过状态事件确认就绪');
          resolve(true);
        }
      });
      
      // 备用：如果没有状态变化事件，5秒后强制标记为就绪
      setTimeout(() => {
        if (!fbStatus.ready) {
          console.log('⏰ 通过超时强制标记Facebook SDK为就绪');
          fbStatus.ready = true;
          fbStatus.loaded = true;
          resolve(true);
        }
      }, 5000);
    };
    
    // 检查脚本是否已存在
    if (document.getElementById('facebook-jssdk')) {
      console.log('📜 Facebook SDK脚本已存在');
      if (window.FB && window.fbAsyncInit) {
        window.fbAsyncInit();
      }
      return;
    }
    
    // 加载Facebook SDK
    console.log('📥 开始加载Facebook SDK脚本');
    (function(d, s, id) {
      var js, fjs = d.getElementsByTagName(s)[0];
      if (d.getElementById(id)) { return; }
      js = d.createElement(s); js.id = id;
      js.src = "https://connect.facebook.net/en_US/sdk.js";
      js.async = true;
      js.crossOrigin = 'anonymous';
      
      js.onload = function() {
        console.log('📥 Facebook SDK脚本加载完成');
      };
      
      js.onerror = function() {
        console.error('❌ Facebook SDK脚本加载失败');
        reject(false);
      };
      
      fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));
    
    // 总超时保护
    setTimeout(() => {
      if (!fbStatus.ready) {
        console.error('⏰ Facebook SDK设置总超时');
        reject(false);
      }
    }, 15000);
  });
}

/**
 * 🎯 初始化方法
 */
facebookWebLogin.init = async function(appId, callback) {
  console.log('🚀 Facebook初始化请求');
  
  if (typeof window === 'undefined') {
    callback(false);
    return;
  }
  
  try {
    const success = await setupFacebookSDK(appId);
    callback(success);
  } catch (error) {
    console.error('❌ Facebook初始化失败:', error);
    callback(false);
  }
};

/**
 * 🎯 登录方法 - 增强诊断版本
 */
facebookWebLogin.login = function(callback, permissions = {}) {
  console.log('🔑 Facebook登录请求开始');
  console.log('🔍 当前Facebook状态:', fbStatus);
  console.log('🔍 window.FB存在:', !!window.FB);
  
  // 状态检查
  if (!window.FB) {
    console.error('❌ Facebook SDK未加载');
    callback({ status: 'error', error: 'SDK未加载' });
    return;
  }
  
  if (!fbStatus.ready) {
    console.error('❌ Facebook SDK未就绪');
    callback({ status: 'error', error: 'SDK未就绪' });
    return;
  }
  
  // 🔥 详细方法检查
  console.log('🔍 FB.login方法存在:', typeof window.FB.login === 'function');
  console.log('🔍 FB.getLoginStatus方法存在:', typeof window.FB.getLoginStatus === 'function');
  console.log('🔍 FB.api方法存在:', typeof window.FB.api === 'function');
  
  if (typeof window.FB.login !== 'function') {
    console.error('❌ FB.login方法不存在');
    callback({ status: 'error', error: 'FB.login不可用' });
    return;
  }
  
  const options = {
    scope: 'email,public_profile',
    return_scopes: true,
    ...permissions
  };
  
  console.log('🔑 准备执行FB.login，权限:', options);
  console.log('🔑 Facebook App ID:', fbStatus.appId);
  
  try {
    // 🔥 增强错误处理和日志
    console.log('🔍 开始获取Facebook登录状态...');
    
    window.FB.getLoginStatus(function(statusResponse) {
      console.log('🔍 Facebook当前登录状态:', statusResponse);
      console.log('🔍 状态详情:', {
        status: statusResponse.status,
        authResponse: statusResponse.authResponse
      });
      
      console.log('🔑 现在调用FB.login...');
      
      // 🔥 关键：在login调用前再次确认
      if (typeof window.FB.login !== 'function') {
        console.error('❌ 调用前发现FB.login方法消失！');
        callback({ status: 'error', error: 'FB.login方法在调用前消失' });
        return;
      }
      
      window.FB.login(function(response) {
        console.log('📝 Facebook登录响应:', response);
        console.log('📝 响应详情:', {
          status: response.status,
          authResponse: response.authResponse,
          error: response.error
        });
        callback(response);
      }, options);
      
    }, true); // 强制从服务器获取状态
    
  } catch (error) {
    console.error('❌ Facebook登录流程异常:', error);
    console.error('❌ 错误堆栈:', error.stack);
    callback({ status: 'error', error: `登录异常: ${error.message}` });
  }
};

/**
 * 🎯 获取用户信息
 */
facebookWebLogin.getUserInfo = function(callback) {
  if (!window.FB || !fbStatus.ready) {
    callback({ error: 'SDK未就绪' });
    return;
  }
  
  window.FB.api('/me', { fields: 'name,email,picture' }, callback);
};

// 兼容旧版本
facebookWebLogin.asyncLoadJs = facebookWebLogin.init;
facebookWebLogin.loadSDK = facebookWebLogin.init;

export default facebookWebLogin;



