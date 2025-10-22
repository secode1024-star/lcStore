import Vue from 'vue'

export default Vue.directive('google-signin-button', {
  bind: function(el, binding, vnode) {
    CheckComponentMethods()

    // 获取 clientId 和回调方法
    const clientId = binding.value
    const onSuccess = vnode.context.OnGoogleAuthSuccess
    const onFailure = vnode.context.OnGoogleAuthFail

    // 创建 Google 登录按钮配置
    const buttonConfig = {
      type: 'standard', // 或 'icon'，取决于你的设计需求
      shape: 'rectangular', // 或 'circular'
      theme: 'outline', // 或 'filled_blue', 'filled_black'
      size: 'large', // 或 'medium', 'large'
      width: 256,
      text: 'signin_with', // 或 'sign_in_with', 'continue_with'
      logo_alignment: 'center'
    }

    // 为自定义按钮添加点击事件
    el.addEventListener('click', function() {
      // 初始化 Google 登录
      InitializeGoogleLogin(clientId, onSuccess, onFailure, buttonConfig, el)
    })

    // 检查组件方法
    function CheckComponentMethods() {
      if (!vnode.context.OnGoogleAuthSuccess) {
        throw new Error('The method OnGoogleAuthSuccess must be defined on the component')
      }

      if (!vnode.context.OnGoogleAuthFail) {
        throw new Error('The method OnGoogleAuthFail must be defined on the component')
      }
    }
  }
})

// 初始化 Google 登录
function InitializeGoogleLogin(clientId, onSuccess, onFailure, buttonConfig, parentElement) {
  // 检查是否已经存在 Google 身份服务脚本
  if (document.getElementById('google-identity-script')) {
    // 如果脚本已存在，直接初始化 Google 登录配置
    google.accounts.id.initialize({
      client_id: clientId,
      callback: handleCredentialResponse
    })

    // 渲染 Google 登录按钮到指定的父元素
    google.accounts.id.renderButton(
      parentElement,
      buttonConfig
    )

    // 允许自动登录（可选）
    google.accounts.id.prompt()
  } else {
    // 创建 Google 身份服务脚本
    const googleIdentityScript = document.createElement('script')
    googleIdentityScript.id = 'google-identity-script'
    googleIdentityScript.src = 'https://accounts.google.com/gsi/client'
    googleIdentityScript.async = true
    googleIdentityScript.defer = true
    document.head.appendChild(googleIdentityScript)

    // 脚本加载完成后初始化登录
    googleIdentityScript.onload = function() {
      // 初始化 Google 登录配置
      google.accounts.id.initialize({
        client_id: clientId,
        callback: handleCredentialResponse
      })

      // 渲染 Google 登录按钮到指定的父元素
      google.accounts.id.renderButton(
        parentElement,
        buttonConfig
      )

      // 允许自动登录（可选）
      google.accounts.id.prompt()
    }
  }

  // 处理登录回调
  function handleCredentialResponse(response) {
    try {
      // 验证 JWT 令牌（建议在后端进行验证）
      const userCredential = response.credential
      onSuccess(userCredential)
    } catch (error) {
      onFailure(error)
    }
  }
}
