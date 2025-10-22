<template>
  <div class="login-count">
    <div class="login-box acea-row">
      <div class="loginPic"><el-image :src="loginPic"></el-image></div>
      <!-- 登录弹窗 -->
      <div class="wrapper-count">
        <span class="closeBtn iconfont icon-guanbi" @click="closeLogin"></span>
        <div class="wrapper" v-show="current === 1 || current === 3">
          <div class="title"><span class="item_title" @click="current = 2">{{$t(`page.users.register.tabNav[0].name`)}}</span><span class="font_red item_title">{{$t(`page.users.register.tabNav[1].name`)}}</span>
          </div>
          <div class="item phone acea-row row-middle">
            <span class="iconfont icon-shouji"></span>
            <div class="tel-container">
              <country-code-selector :countryCode.sync="countryCode">
              </country-code-selector>
            </div>
            <input type="text" :placeholder="$t(`page.users.register.placePhone`)" v-model="phone">
          </div>
          <div v-show="current === 1" class="item pwd acea-row row-middle mb15">
            <span class="iconfont icon-mima"></span>
            <input type="password" :placeholder="$t(`page.users.login.placePasd`)" v-model="password">
          </div>
          <div v-show="current === 3" class="item verificat acea-row row-between row-middle mb15">
            <div class="acea-row row-middle">
              <span class="iconfont icon-yanzhengma"></span>
              <input type="text" :placeholder="$t(`message.login.emptyCaptche`)" v-model="captcha">
            </div>
            <button class="code font-color" :disabled="disabled" :class="disabled === true ? 'on' : ''" @click="code('login')">
              {{ text }}
            </button>
          </div>
          <div class="checkbox-wrapper item_protocol">
            <div v-show="current === 1" class="show_protocol" @click="current = 3">{{$t(`page.users.login.quick`)}}</div>
            <div v-show="current === 3" class="show_protocol" @click="current = 1">{{$t(`page.users.login.pasdLogin`)}}</div>
          </div>
        </div>
        <div class="wrapper" v-show="current === 2" style="margin-bottom: 39px">
          <div class="title"><span class="item_title font_red" @click="current = 2">
            {{ $t(`page.users.userInfo.email`) }}
          </span><span class="item_title" @click="current = 1">{{ $t(`page.users.register.tabNav[1].name`) }}</span>
          </div>
          <div class="item phone acea-row row-middle">
            <span class="iconfont icon-youxiang"></span>
            <input type="text" :placeholder="$t(`page.users.login.placeEmail`)" v-model="email">
          </div>
          <div class="item pwd acea-row row-between row-middle">
            <div class="acea-row row-middle" style="width: 80%">
              <span class="iconfont icon-mima"></span>
              <input type="password" :placeholder="$t(`page.users.login.placePasd`)" v-model="password">
            </div>
            <el-button type="text font_red" @click="emailPassword=true, current=4">{{$t(`page.users.login.forget`)}}</el-button>
          </div>
        </div>

        <div v-show="current < 4">
          <el-button type="primary" @click="submit" class="signIn bg-color mt15">{{$t(`page.users.login.sign`)}}</el-button>
          <el-button @click="current = 6" class="signIn mat20 creat_account mt15">{{$t(`page.users.login.create`)}}</el-button>
          <div v-if="loginInfo.visitorOpen && $store.state.isShowTourists" @click="current = 7" class="tourists mt15">{{$t(`page.users.login.tourists`)}}</div>
          <div class="checkbox-wrapper item_protocol mt15">
            <label class="well-check">
              <input
                type="checkbox"
                name=""
                value=""
                :checked="isAgree"
                @click="isAgree = !isAgree"
              />
              <i class="icon mr50"></i>
              <span style="margin-left: 30px">{{$t(`message.login.agree`)}}</span>
            </label>
            <nuxt-link
              :to="{path:`/middlewares/privacy_agreement`}"
              target="_blank"
              class="show_protocol"
            >《{{$t(`message.login.agreementName`)}}》
            </nuxt-link>
          </div>
          <!-- 第三方登录 -->
          <div class="bottom">
            <span class="sign_type">{{$t(`page.users.login.with`)}}</span>
            <div class="sign_type_list">
              <!-- 原有Twitter按钮已隐藏，使用新的X OAuth 2.0 -->
              <!-- <img src="@/assets/images/twitter.png" @click="twitterGetToken()" v-if="loginInfo.twitterOpen"/> -->
              <img src="@/assets/images/goggle.png" v-google-signin-button="clientId" v-if="loginInfo.googleOpen"/>
              <!-- X (Twitter) OAuth 2.0 登录 - 新版本 -->
              <div class="x-login-btn" @click="xOAuth2Login()" title="使用 X (Twitter) 登录" style="display: inline-block; cursor: pointer; padding: 8px; background: #1DA1F2; border-radius: 4px; margin: 0 5px;">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="white">
                  <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/>
                </svg>
              </div>
            </div>
          </div>
        </div>
        <!--忘记邮箱密码-->
        <div class="wrapper" v-show="emailPassword && current === 4">
          <div class="title">{{$t(`page.users.login.forget`)}}</div>
          <div class="info">{{$t(`page.users.login.resetDesc`)}} </div>
          <div class="item phone acea-row row-middle">
            <span class="iconfont icon-youxiang"></span>
            <input type="text" :placeholder="$t(`page.users.login.placeEmail`)" v-model="email">
          </div>
          <el-button type="primary" :loading="loading" @click="next" class="signIn bg-color mt60">{{$t(`page.users.login.next`)}}</el-button>
          <div class="fastLogin" @click="current = 2">
            <span class="">{{$t(`page.users.login.remember`)}}</span>
            <span class="font-color">{{$t(`page.users.login.sign`)}}</span>
          </div>
        </div>
        <!--修改邮箱密码-->
        <div class="wrapper" v-show="current === 5">
          <div class="title">{{$t(`page.users.login.emailVer`)}}</div>
          <div class="info">{{$t(`page.users.login.verDesc`)}}： <span class="font-color">{{email}}</span></div>
          <div class="item verificat acea-row row-between row-middle">
            <div class="acea-row row-middle">
              <span class="iconfont icon-yanzhengma"></span>
              <input type="text" :placeholder="$t(`page.users.register.placeCode`)" v-model="emailCaptcha">
            </div>
            <button class="code font-color" :disabled="disabled" :class="disabled === true ? 'on' : ''" @click="forgetEmailCode('login')">
              {{ text }}
            </button>
          </div>
          <div class="item pwd acea-row row-middle">
            <span class="iconfont icon-mima"></span>
            <input type="password" :placeholder="$t(`page.users.login.placePasd`)" v-model="newPassword">
          </div>
          <div class="item pwd acea-row row-middle">
            <span class="iconfont icon-mima"></span>
            <input type="password" :placeholder="$t(`page.users.login.Pasdagain`)" v-model="passwordAgain">
          </div>
          <el-button type="primary" @click="editPwd" class="signIn bg-color mt60">{{$t(`page.users.login.submit`)}}</el-button>
        </div>
        <!--注册-->
        <div class="wrapper" v-show="current === 6">
          <div class="tabs">
            <span v-for="(item,index) in tabList" :key="index" :class="{ 'active': active == index}" @click="tab(index)">{{item}}</span>
          </div>
          <div v-if="active===0" class="item acea-row row-middle">
            <span class="iconfont icon-youxiang"></span>
            <input type="text" :placeholder="$t(`page.users.login.placeEmail`)" v-model="email">
          </div>
          <div v-else class="item acea-row row-middle">
            <span class="iconfont icon-shouji"></span>
            <div class="tel-container">
              <country-code-selector :countryCode.sync="countryCode">
              </country-code-selector>
            </div>
            <input type="text" :placeholder="$t(`page.users.register.placePhone`)" v-model="phone">
          </div>
          <div class="item verificat acea-row row-between row-middle">
            <div class="acea-row row-middle">
              <span class="iconfont icon-yanzhengma"></span>
              <input type="text" :placeholder="$t(`page.users.register.placeCode`)" v-model="captcha">
            </div>
            <button class="code font-color" :disabled="disabled" :class="disabled === true ? 'on' : ''" @click="registerCode">
              {{ text }}
            </button>
          </div>
          <div class="item pwd acea-row row-middle mb15">
            <span class="iconfont icon-mima"></span>
            <input type="password" :placeholder="$t(`page.users.login.placePasd`)" v-model="password">
          </div>
          <div class="checkbox-wrapper item_protocol mt15">
            <label class="well-check">
              <input
                type="checkbox"
                name=""
                value=""
                :checked="isAgree"
                @click="isAgree = !isAgree"
              />
              <i class="icon"></i>
              <span style="margin-left: 30px">{{$t(`message.login.agree`)}}</span>
            </label>
            <nuxt-link
              :to="{path:`/middlewares/privacy_agreement`}"
              target="_blank"
              class="show_protocol"
            >《{{$t(`message.login.agreementName`)}}》
            </nuxt-link>
          </div>
          <el-button type="primary" :loading="loading" @click="register" class="signIn bg-color mt60">{{$t(`page.users.register.submit`)}}</el-button>
          <div class="fastLogin">{{$t(`page.users.register.have`)}}<span class="font-color" @click="goLogin">{{$t(`page.users.register.sign`)}}</span></div>
        </div>
        <!--游客登录-->
        <div class="wrapper" v-show="current === 7" style="margin-top: 64px">
          <div class="title">{{$t(`page.users.login.tourists`)}}</div>
          <div class="item acea-row row-middle">
            <span class="iconfont icon-youxiang"></span>
            <input type="text" :placeholder="$t(`page.users.register.placeEmail`)" v-model="email">
          </div>
          <div class="item acea-row row-middle">
            <span class="iconfont icon-shouji"></span>
            <div class="tel-container">
              <country-code-selector :countryCode.sync="countryCode">
              </country-code-selector>
            </div>
            <input type="text" :placeholder="$t(`page.users.register.placePhone`)" v-model="phone">
          </div>
          <el-button type="primary" :loading="loading" @click="touristsRegister" class="signIn bg-color mt60">{{$t(`page.users.login.continue`)}}</el-button>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
// +----------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2016~2023 https://www.crmeb.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +----------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +----------------------------------------------------------------------
import sendVerifyCode from "@/mixins/SendVerifyCode";
import {Debounce} from '@/utils/validate.js'
import CountryCodeSelector from "~/components/countryCodeSelector.vue";
import GoogleSignInButton from '@/utils/googleSign.js'
import axios from 'axios'
//import countryCodeSelector from 'vue-country-code-selector'
//import countryList from "./countryList.json";
export default {
  name: "loginStatus",
  components: {CountryCodeSelector},
  mixins: [sendVerifyCode],
  directives: {
    GoogleSignInButton
  },
  data() {
    return {
      loginPic: '',
      countryCode: 86,
      tabList:['Email','Phone'],
      current: 2,
      phone: "",
      password: "",
      confirm_pwd: "",
      captcha: "",
      keyCode: "",
      qrCode: '',
      isShow: true,
      disabled: false,
      codeCheck: null,
      isAgree: false,
      isShowCode: false,
      codeVal: "",
      codeUrl: "",
      codeKey: "",
      emailPassword: false,
      email: '',
      // X (Twitter) OAuth 2.0 配置 - 将从后端配置中获取
      X_OAUTH_CONFIG: {
        clientId: '', // 从后端动态获取
        redirectUri: '', // 从后端动态获取
        scope: 'tweet.read users.read',
        responseType: 'code',
        codeChallengeMethod: 'S256'
      },
      active:0,
      loading: false,
      emailCaptcha: '',
      newPassword: '',
      passwordAgain: '',
      loginInfo: {},
      clientId: '' // Google Client ID - 从后端动态获取
    }
  },
  watch: {
    current(n) {
      if (n === 3) {
       // this.loginCode();
      } else if (n === 4) {
        this.account = '';
        this.password = '';
        this.confirm_pwd = '';
        this.captcha = '';
      } else {
        this.clearCodeCheck();
      }
    }
  },
  head() {
    return {}
  },
  beforeMount(){
    this.getLoginPic();
    this.getLoginInfo();
  },
  mounted() {
    window.addEventListener('keydown', this.keyDown);
  },
  destroyed() {
    window.removeEventListener('keydown', this.keyDown, false);
    this.clearCodeCheck();
  },
  methods: {
    getLoginPic() {
      this.$axios.get('/api/pc/login/getLoginPic').then(res => {
        this.loginPic = res.data.loginLeftImage
      })
    },
    /**
     *获取个人中心menus
     * */
    getMenus() {
      this.$axios.get('/api/front/user/menu/user').then(res => {
        this.loginInfo = res.data;
        // Facebook登录已移除
      })
    },
    /**
     * 匿名账号登录
     * */
    touristsRegister:Debounce(function () {
      if (!this.email) return this.$message.error(this.$t(`message.login.emailEmpty`));
      if (!/^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/i.test(this.email))  return this.$message.error(this.$t(`message.login.correctEmail`));
      let userInfo = {
        "countryCode": this.countryCode,
        "email": this.email,
        "phone": this.phone
      };
      this.$auth.loginWith('local3', {data: userInfo}).then(() => {
        this.$message.success(this.$t(`message.login.loginSuccess`));
        this.isShow = false;
        this.closeLogin();
      })
    }),
    /**
     *获取第三方登录的信息和是否开启
     * */
    getLoginInfo() {
      this.$axios.get('/api/front/login/method/info').then(res => {
        console.log('获取登录方式信息:', res.data);
        this.loginInfo = res.data;
        
        // 更新X OAuth 2.0配置 - 使用后端返回的小写字段名
        if (res.data.xoauth2ClientId) {
          this.X_OAUTH_CONFIG.clientId = res.data.xoauth2ClientId;
          console.log('X OAuth 2.0 Client ID已更新:', res.data.xoauth2ClientId);
        }
        if (res.data.xoauth2CallbackUrlPc) {
          this.X_OAUTH_CONFIG.redirectUri = res.data.xoauth2CallbackUrlPc;
          console.log('X OAuth 2.0回调地址已更新:', res.data.xoauth2CallbackUrlPc);
        }
        
        // 更新Google Client ID
        if (res.data.googleClientId) {
          this.clientId = res.data.googleClientId;
          console.log('Google Client ID已更新:', res.data.googleClientId);
        }
        
        // Facebook登录已移除
      }).catch(error => {
        console.error('获取登录方式信息失败:', error);
      });
    },
    twitterGetToken(){
      console.log('点击Twitter登录按钮');
      this.$axios.get('/api/front/login/twitter/request/token?end=pc').then(res=>{
        console.log('Twitter RequestToken获取成功:', res.data);
        this.$cookies.set('twitterToken', res.data)
        window.location.href = res.data.authorizationURL;
      }).catch(error => {
        console.error('Twitter登录请求失败:', error);
        this.$message.error('Twitter登录初始化失败，请检查配置');
      });
    },
    // X (Twitter) OAuth 2.0 登录 - 采用OAuth 1.0的简洁逻辑
    async xOAuth2Login() {
      try {
        console.log('启动X OAuth 2.0登录流程');
        
        // 验证配置是否有效
        if (!this.X_OAUTH_CONFIG.clientId || !this.X_OAUTH_CONFIG.redirectUri) {
          console.error('X OAuth 2.0配置缺失:', this.X_OAUTH_CONFIG);
          this.$message.error('X OAuth 2.0配置缺失，请联系管理员检查后台配置');
          return;
        }
        
        // 生成 PKCE 参数
        const codeVerifier = this.generateCodeVerifier();
        
        let codeChallenge;
        try {
          if (window.crypto && window.crypto.subtle) {
            // HTTPS环境：使用安全的加密API
            codeChallenge = await this.generateCodeChallenge(codeVerifier);
          } else {
            // HTTP环境：使用降级方案
            codeChallenge = this.generateCodeChallengeFallback(codeVerifier);
          }
        } catch (error) {
          console.error('生成code_challenge失败:', error);
          this.$message.error('登录初始化失败');
          return;
        }
        
        // 保存 code_verifier 到Cookie
        this.saveCodeVerifierToCookie(codeVerifier);
        
        // 生成 state 参数
        const state = this.generateRandomString(32);
        sessionStorage.setItem('x_oauth_state', state);
        
        // 构建授权 URL
        const authUrl = this.buildAuthUrl(codeChallenge, state);
        
        // 显示提示信息
        this.$message.info('正在跳转到X授权页面...');
        
        // 短暂延迟后跳转
        setTimeout(() => {
          window.location.href = authUrl;
        }, 500);
        
      } catch (error) {
        console.error('X OAuth 2.0 登录初始化失败:', error);
        this.$message.error('登录初始化失败: ' + error.message);
      }
    },
    // 生成随机字符串用于 code_verifier
    generateCodeVerifier() {
      const charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
      let result = '';
      for (let i = 0; i < 128; i++) {
        result += charset.charAt(Math.floor(Math.random() * charset.length));
      }
      return result;
    },
    // 生成 code_challenge (HTTPS环境)
    async generateCodeChallenge(codeVerifier) {
      const encoder = new TextEncoder();
      const data = encoder.encode(codeVerifier);
      const digest = await window.crypto.subtle.digest('SHA-256', data);
      return btoa(String.fromCharCode(...new Uint8Array(digest)))
        .replace(/\+/g, '-')
        .replace(/\//g, '_')
        .replace(/=/g, '');
    },
    // HTTP环境下的SHA256实现（使用js-sha256库的逻辑）
    generateCodeChallengeFallback(codeVerifier) {
      console.warn('使用HTTP环境下的SHA256实现');
      try {
        // 使用简化的SHA256实现
        const sha256Hash = this.sha256(codeVerifier);
        // 转换为base64url格式
        const base64 = btoa(sha256Hash)
          .replace(/\+/g, '-')
          .replace(/\//g, '_')
          .replace(/=/g, '');
        return base64;
      } catch (error) {
        console.error('SHA256计算失败:', error);
        // 最后的fallback - 使用明文模式（Twitter API在某些情况下支持）
        console.warn('使用明文code_challenge');
        return codeVerifier;
      }
    },
    
    // 简化的SHA256实现（仅用于HTTP环境）
    sha256(message) {
      // 这是一个简化版本，实际项目中建议使用crypto-js或js-sha256库
      function rightRotate(value, amount) {
        return (value >>> amount) | (value << (32 - amount));
      }
      
      // 预处理
      const msgBytes = new TextEncoder().encode(message);
      const msgLength = msgBytes.length;
      const bitLength = msgLength * 8;
      
      // 添加padding
      const paddedLength = Math.ceil((bitLength + 65) / 512) * 64;
      const padded = new Uint8Array(paddedLength);
      padded.set(msgBytes);
      padded[msgLength] = 0x80;
      
      // 添加长度信息
      const lengthView = new DataView(padded.buffer, paddedLength - 8);
      lengthView.setUint32(4, bitLength, false);
      
      // 初始哈希值
      let h = [
        0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
        0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
      ];
      
      // 常量
      const k = [
        0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
        0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
        0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
        0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
        0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
        0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
        0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
        0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
      ];
      
      // 处理每个512位块
      for (let chunk = 0; chunk < padded.length; chunk += 64) {
        const w = new Array(64);
        
        // 复制chunk到w[0..15]
        for (let i = 0; i < 16; i++) {
          w[i] = new DataView(padded.buffer, chunk + i * 4).getUint32(0, false);
        }
        
        // 扩展到w[16..63]
        for (let i = 16; i < 64; i++) {
          const s0 = rightRotate(w[i - 15], 7) ^ rightRotate(w[i - 15], 18) ^ (w[i - 15] >>> 3);
          const s1 = rightRotate(w[i - 2], 17) ^ rightRotate(w[i - 2], 19) ^ (w[i - 2] >>> 10);
          w[i] = (w[i - 16] + s0 + w[i - 7] + s1) >>> 0;
        }
        
        // 初始化工作变量
        let [a, b, c, d, e, f, g, h0] = h;
        
        // 主循环
        for (let i = 0; i < 64; i++) {
          const s1 = rightRotate(e, 6) ^ rightRotate(e, 11) ^ rightRotate(e, 25);
          const ch = (e & f) ^ (~e & g);
          const temp1 = (h0 + s1 + ch + k[i] + w[i]) >>> 0;
          const s0 = rightRotate(a, 2) ^ rightRotate(a, 13) ^ rightRotate(a, 22);
          const maj = (a & b) ^ (a & c) ^ (b & c);
          const temp2 = (s0 + maj) >>> 0;
          
          h0 = g;
          g = f;
          f = e;
          e = (d + temp1) >>> 0;
          d = c;
          c = b;
          b = a;
          a = (temp1 + temp2) >>> 0;
        }
        
        // 添加到哈希值
        h[0] = (h[0] + a) >>> 0;
        h[1] = (h[1] + b) >>> 0;
        h[2] = (h[2] + c) >>> 0;
        h[3] = (h[3] + d) >>> 0;
        h[4] = (h[4] + e) >>> 0;
        h[5] = (h[5] + f) >>> 0;
        h[6] = (h[6] + g) >>> 0;
        h[7] = (h[7] + h0) >>> 0;
      }
      
      // 转换为字节数组
      const hashBytes = new Uint8Array(32);
      for (let i = 0; i < 8; i++) {
        const view = new DataView(hashBytes.buffer, i * 4);
        view.setUint32(0, h[i], false);
      }
      
      // 转换为二进制字符串
      return String.fromCharCode(...hashBytes);
    },
    // 生成随机字符串
    generateRandomString(length) {
      const charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
      let result = '';
      for (let i = 0; i < length; i++) {
        result += charset.charAt(Math.floor(Math.random() * charset.length));
      }
      return result;
    },
    
    
    // 保存 code_verifier 到Cookie
    saveCodeVerifierToCookie(codeVerifier) {
      try {
        // 主要存储: Cookie
        const expireTime = new Date();
        expireTime.setTime(expireTime.getTime() + (7 * 24 * 60 * 60 * 1000)); // 7天
        document.cookie = `x_oauth_code_verifier=${encodeURIComponent(codeVerifier)}; expires=${expireTime.toUTCString()}; path=/; SameSite=Lax`;
      } catch (error) {
        console.warn('保存到Cookie失败:', error);
      }
      
      try {
        // 备份存储: sessionStorage
        sessionStorage.setItem('x_oauth_code_verifier', codeVerifier);
      } catch (error) {
        console.warn('保存到sessionStorage失败:', error);
      }

      try {
        // 备份存储: localStorage
        localStorage.setItem('x_oauth_code_verifier_backup', codeVerifier);
      } catch (error) {
        console.warn('保存到localStorage失败:', error);
      }
    },
    // 构建授权 URL
    buildAuthUrl(codeChallenge, state) {
      const params = new URLSearchParams({
        response_type: this.X_OAUTH_CONFIG.responseType,
        client_id: this.X_OAUTH_CONFIG.clientId,
        redirect_uri: this.X_OAUTH_CONFIG.redirectUri,
        scope: this.X_OAUTH_CONFIG.scope,
        state: state,
        code_challenge: codeChallenge,
        code_challenge_method: this.X_OAUTH_CONFIG.codeChallengeMethod
      });
      
      return `https://twitter.com/i/oauth2/authorize?${params.toString()}`;
    },
    // 🔥 Google登录成功处理 - 简化流程
    OnGoogleAuthSuccess(userData) {
      let that = this;
      console.log('🚀 Google登录成功，获取到用户数据:', userData);
      
      if (!userData) {
        console.error('❌ 未获取到用户数据');
        that.$message.error('Google登录失败：未获取到用户数据');
        return;
      }
      
      // 🔥 移除重复的消息提示，由callback页面统一处理
      
      // 🔥 直接发送用户数据到后端 - 简化流程
      console.log('📤 发送用户数据到后端:', userData);
      
      that.$auth.loginWith('local9', {data: userData}).then(res => {
        console.log('✅ Google后端验证成功:', res);
        that.$message.success('Google登录成功！');
        that.isShow = false;
        that.closeLogin();
      }).catch(error => {
        console.error('❌ Google后端验证失败:', error);
        console.error('❌ 错误响应:', error.response);
        console.error('❌ 错误状态码:', error.response?.status);
        console.error('❌ 错误数据:', error.response?.data);
        
        let errorMsg = 'Google登录失败';
        if (error.response?.data?.message) {
          errorMsg += `: ${error.response.data.message}`;
        } else if (error.response?.status === 404) {
          errorMsg += ': 后端不支持Google登录，请联系管理员';
        } else if (error.message) {
          errorMsg += `: ${error.message}`;
        }
        
        that.$message.error(errorMsg);
      });
    },
    
    // 🔥 Google登录失败处理 - 增强错误信息
    OnGoogleAuthFail(error) {
      console.error('❌ Google登录失败详情:', error);
      console.error('❌ 错误类型:', typeof error);
      console.error('❌ 错误内容:', JSON.stringify(error));
      
      let errorMsg = 'Google登录失败';
      if (error && error.error) {
        errorMsg += `: ${error.error}`;
      } else if (error && typeof error === 'string') {
        errorMsg += `: ${error}`;
      }
      
      this.$message.error(errorMsg + '，请重试');
    },
    goLogin() {
      this.active === 0 ? this.current = 2 : this.current = 1
    },
    // 登录
    submit(){
      if (this.current === 1) {
        this.loginH5();
      } else if (this.current === 2) {
        this.loginEmail();
      } else if (this.current === 3) {
        this.loginMobile();
      }
    },
    tab(index){
      this.active = index;
    },
    next() {
      if (!this.email) return this.$message.error(this.$t(`message.login.emailEmpty`));
      if (!/^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/i.test(this.email)) return this.$message.error(this.$t(`message.login.correctEmail`));
      this.current = 5;
    },
    keyDown(e) {
      if (e.keyCode === 13) {
        if (this.current === 1) {
          this.loginH5();
        } else if (this.current === 2) {
          this.loginEmail();
        } else if (this.current === 3) {
          this.loginMobile();
        }
      }
    },
    /**
     *
     * 邮箱账号登录
     */
    async loginEmail(){
      let that = this;
      if (!that.email) return that.$message.error(this.$t(`message.login.emailEmpty`));
      if (!/^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/i.test(that.email))  return that.$message.error(this.$t(`message.login.correctEmail`));
      if (!that.password) return that.$message.error(this.$t(`message.login.emptyPassword`));
      if (!that.isAgree) return that.$message.error(that.$t(`message.login.agreement`));
      let userInfo = {
        email: that.email,
        password: that.password
      };
      await that.$auth.loginWith('local2', {data: userInfo}).then(() => {
        that.$message.success(that.$t(`message.login.loginSuccess`));
        that.isShow = false;
        this.closeLogin();
      }).catch(err => {
        console.error('登录失败:', err);
        that.$message.error('登录失败，请检查邮箱和密码');
      })
    },
    clearCodeCheck() {
      this.codeCheck && clearInterval(this.codeCheck);
      this.codeCheck = null;
    },
    /**
     *
     * 手机账号登录
     */
    async loginH5() {
      let that = this;
      if (!that.phone) return that.$message.error(that.$t(`message.login.emptyPhone`));
      if (!that.password) return that.$message.error(that.$t(`message.login.emptyPassword`));
      if (!that.isAgree) return that.$message.error(that.$t(`message.login.agreement`));
      let userInfo = {
        countryCode: '+' + that.countryCode,
        password: that.password,
        phone: that.phone
      };
      await that.$auth.loginWith('local', {data: userInfo}).then(() => {
        that.$message.success(that.$t(`message.login.loginSuccess`));
        that.isShow = false;
        this.closeLogin();
      }).catch(err => {
        console.error('登录失败:', err);
        that.$message.error('登录失败，请检查手机号和密码');
      })
    },
    /**
     *
     * 手机验证码登录
     */
    async loginMobile() {
      let that = this;
      if (!that.phone) return that.$message.error(that.$t(`message.login.emptyPhone`));
      if (!that.captcha) return that.$message.error(that.$t(`message.login.emptyCaptche`));
      if (!/^[\w\d]+$/i.test(that.captcha)) return that.$message.error(that.$t(`message.login.correctCaptche`));
      if (!that.isAgree) return that.$message.error(that.$t(`message.login.agreement`));
      let userInfo = {
        phone: that.phone,
        captcha: that.captcha,
        countryCode: '+' + that.countryCode
      };
      await that.$auth.loginWith('local1', {data: userInfo}).then(() => {
        that.$message.success(that.$t(`message.login.loginSuccess`));
        that.isShow = false;
        this.closeLogin();
      }).catch(err => {
        console.error('登录失败:', err);
        that.$message.error('登录失败，请检查手机号和验证码');
      })
    },
    registerCode(){
      this.active === 0 ? this.emailCode() : this.code()
    },
    /**
     *
     * 注册
     */
    async register() {
      let that = this;
      if (!that.captcha) return that.$message.error(that.$t(`message.login.emptyCaptche`));
      if (!/^[\w\d]+$/i.test(that.captcha)) return that.$message.error(that.$t(`message.login.correctCaptche`));
      if (!that.password) return that.$message.error(that.$t(`message.login.emptyPassword`));
      if (!that.isAgree) return that.$message.error(that.$t(`message.login.agreement`));
      if(this.active === 0){
        if (!that.email) return that.$message.error(this.$t(`message.login.emailEmpty`));
        if (!/^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/i.test(that.email))  return that.$message.error(this.$t(`message.login.correctEmail`));
        that.loading = true
        let userInfo = {
          email: that.email,
          captcha: that.captcha,
          password: that.password
        };
        await that.$auth.loginWith('local4', {data: userInfo}).then(res => {
          that.$message.success(that.$t(`message.login.registerSU`));
          that.isShow = false;
          location.reload()
          that.closeLogin();
          that.loading = false;
        }).catch(err => {
          that.loading = false;
        });
      }else{
        if (!that.phone) return that.$message.error(that.$t(`message.login.emptyPhone`));
        this.loading = true
        let userInfo = {
          countryCode: '+' + that.countryCode,
          captcha: that.captcha,
          phone: that.phone,
          password: that.password
        };
        await that.$auth.loginWith('local5', {data: userInfo}).then(res => {
          that.$message.success(that.$t(`message.login.registerSU`));
          that.isShow = false;
          that.closeLogin();
          that.loading = false;
        }).catch(err => {
          that.loading = false;
        });
      }

    },
    /**
     *
     * 忘记密码
     */
    async editPwd() {
      let that = this;
      if (!that.emailCaptcha) return that.$message.error(that.$t(`message.login.emptyCaptche`));
      if (!that.newPassword) return that.$message.error(that.$t(`message.login.emptyPassword`));
      if (!that.passwordAgain) return that.$message.error(that.$t(`message.login.againPassword`));
      if (that.newPassword != that.passwordAgain) return that.$message.error(that.$t(`message.login.diffPassword`));
      await this.$axios.post("/api/front/login/email/reset/password", {
        email: that.email,
        captcha: that.emailCaptcha,
        newPassword: that.newPassword,
        passwordAgain: that.passwordAgain
      }).then(res => {
        that.$message.success(res.message);
        that.current = 2;
      })
    },
    /**
     *
     * 邮箱验证码
     */
    emailCode: Debounce(function () {
      let that = this;
      if (!that.email) return that.$message.error(this.$t(`message.login.emailEmpty`));
      if (!/^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/i.test(that.email))  return that.$message.error(this.$t(`message.login.correctEmail`));
      
      that.$axios.post('/api/front/login/email/captcha', that.email, {
        headers: { 'Content-Type': 'application/json; charset=UTF-8'}
      }).then(res => {
        if(res.code === 200){
          that.$message.success('验证码已发送，请注意查收');
          that.sendCode();
        } else {
          that.$message.error(res.message || 'Failed to send');
        }
      }).catch(err => {
        console.error('邮箱验证码发送失败:', err);
        that.$message.error('发送失败，请重试');
      })
    }),
    /**
     *
     * 手机号验证码
     */
    code: Debounce(function () {
       let that = this;
      if (!that.phone) return that.$message.error(that.$t(`message.login.emptyPhone`));
       let templateParam ={
         phone: that.phone,
         countryCode: '+' + that.countryCode
       }
       var formData = new FormData();
       for (let key in templateParam) {formData.append(key, templateParam[key])}
       this.$axios.post('/api/front/login/sendCode', formData).then(res => {
         that.$message.success(res.message);
         that.sendCode();
       })
     }),
    /**
     *
     * 邮箱忘记密码验证码
     */
    forgetEmailCode: Debounce(function () {
      let that = this;
      if (!that.email) return that.$message.error(this.$t(`message.login.emailEmpty`));
      if (!/^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/i.test(that.email))  return that.$message.error(this.$t(`message.login.correctEmail`));
      
      that.$axios.post('/api/front/login/email/forget/password', that.email, {
        headers: { 'Content-Type': 'application/json; charset=UTF-8'}
      }).then(res => {
        if(res.code === 200){
          that.$message.success('验证码已发送，请注意查收');
          that.sendCode();
        } else {
          that.$message.error(res.message || 'Failed to send');
        }
      }).catch(err => {
        console.error('忘记密码邮件发送失败:', err);
        that.$message.error('发送失败，请重试');
      })
    }),
    
    // Facebook登录已移除
    
    closeLogin() {
      this.$store.commit("isLogin", false);
      // this.$axios.get('/api/front/user/info').then(res => {
      //  console.log(res)
      // })
    }
  }
}
</script>

<style scoped lang="scss">
  .tourists{
    font-size: 14px;
    color: #666666;
    text-align: center;
    cursor: pointer;
  }
  .login-box{
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    padding: 50px 0;
    width: 840px;
  }
  .loginPic{
    width: 335px;
    height: 540px;
    .el-image, el-image{
      width: 100%;
      height: 100%;
    }
  }
  .mt60{
    margin: 50px auto 0 auto;
  }
  .tabs {
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 0;
    font-size: 18px;
    font-family: PingFangSC-Semibold, PingFang SC;
    font-weight: 600;
    color: #333;
    line-height: 25px;
    span:nth-child(1){
      margin-right: 83px;
    }
    span{
      cursor: pointer;
    }
    .active{
      color: #E93323;
      position: relative;
      ::after{
        content: '';
        position: absolute;
        width: 40px;
        height: 3px;
        background-color: #E93323;
        bottom: -20rpx;
        left: 0;
        right: 0;
        margin:auto ;
      }
    }
  }
.login-count {
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, .5);
  position: fixed;
  top: 0;
  left: 0;
  z-index: 100;
}

.wrapper-count {
  position: relative;
  background-color: #fff;
  padding-top: 50px;
  .closeBtn {
    color: #bbb;
    position: absolute;
    top: 20px;
    right: 20px;
    text-align: center;
    font-size: 20px;
    cursor: pointer;
  }
}

.wrapper {
  position: relative;
  width: 505px;
  background-color: #fff;
  text-align: center;
  margin: 0 auto;

  .font_red {
    color: #E93323
  }

  .title {
    font-size: 18px;
    color: #333333;
    position: relative;
    font-weight: bold;

    .item_title {
      cursor: pointer;

      &:first-child {
        margin-right: 70px;
      }
    }

    .iconfont {
      position: absolute;
      top: -71px;
      right: 0;
      font-size: 60px;
      cursor: pointer;
    }
  }

  .info{
    color: #222222;
    font-size: 16px;
    width: 85%;
    text-align: center;
    margin: 20px auto 0;
  }

  .item {
    width: 427px;
    height: 72px;
    line-height: 71px;
    border-bottom: 1px solid #DBDBDB;
    margin: 0 auto;

    &.phone {
      .number {
        width: 65px;
        height: 100%;
        color: #666666;
        border-right: 1px solid #DBDBDB;
      }
      .iconfont {
        font-size: 20px;
      }

      input {
        width: 291px;
      }
    }

    &.pwd {
     //margin-bottom: 15px;

      input {
        width: 291px;
      }
      .iconfont {
        font-size: 20px;
      }
    }

    &.verificat {
      input {
        width: 246px;
      }

      .code {
        line-height: 24px;
        border-radius: 12px;
        border: 1px solid #E93323;
        padding: 0 10px;
        background-color: #fff;
        font-size: 14px;

        img {
          width: 100%;
          height: 100%;
        }

        &.on {
          color: #CCC !important;
        }
      }
    }

    input {
      padding-left: 15px;
      height: 100%;
      border: 0;
      outline: none;
      font-size: 16px;
    }
  }

  .fastLogin {
    margin-top: 20px;
    cursor: pointer;
    color: #666666;
    font-size: 14px;
  }
  .title + .iconfont {
    position: absolute;
    top: 0;
    right: 0;
    font-size: 46px;
    color: #282828;
  }

  &.wxLogin {
    position: relative;
    padding-top: 98px;

    .inner {
      position: absolute;
      top: 34px;
      left: 30px;
      font-size: 20px;
      color: #282828;
    }

    .icon-zhanghaodenglu1 {
      position: absolute;
      top: 0;
      right: 0;
      font-size: 46px;
      color: #282828;
    }
  }

  .wxCode {
    position: relative;
    width: 213px;
    height: 213px;
    padding: 10px;
    margin: 0 auto;

    img {
      display: block;
      width: 100%;
    }

    .iconfont {
      font-size: 22px;
      color: #cbcbcb;
    }

    .iconfont:nth-child(1) {
      position: absolute;
      top: 0;
      left: 0;
    }

    .iconfont:nth-child(2) {
      position: absolute;
      top: 0;
      right: 0;
      transform: rotate(90deg);
    }

    .iconfont:nth-child(3) {
      position: absolute;
      right: 0;
      bottom: 0;
      transform: rotate(180deg);
    }

    .iconfont:nth-child(4) {
      position: absolute;
      bottom: 0;
      left: 0;
      transform: rotate(270deg);
    }
  }

  .tip {
    margin-top: 20px;
    font-size: 16px;
    color: #666;
  }

  .iconfont{
    font-size: 20px;
  }

}

.item_protocol {
  margin: 0 auto 0;
  width: 427px;
  text-align: left;
  font-size: 15px;

  .icon {
    width: 14px;
    height: 14px;
  }

  .show_protocol {
    color: #E93323;
    cursor: pointer;
  }

  .forget_password {
    float: right;
    color: #999999;
    cursor: pointer;

    .icon-wangjimima {
      display: inline-block;
      width: 12px;
      height: 12px;
      line-height: 12px;
      margin-right: 5px;
      position: relative;
      top: 1px;
      text-align: center;
      border: 1px solid #999999;
      border-radius: 100%;
    }
  }
}

.signIn {
  width: 427px;
  text-align: center;
  color: #fff;
  cursor: pointer;
  font-size: 16px;
  display: block;

}
.mt15{
  margin: 15px auto 0 auto !important;
}
.creat_account{
  border: 1px solid #DDDDDD;
  color: #333333 !important;
}
.bottom {
  text-align: center;
  margin-top: 30px;
  .sign_type {
    font-size: 14px;
    font-family: PingFangSC-Regular, PingFang SC;
    font-weight: 400;
    color: #B4B4B4;
    position: relative;
    &::before{
      content: '';
      position: absolute;
      top: 10px;
      left: -50px;
      width: 40px;
      height: 1px;
      background: #ccc;
      opacity: .5;
    }
    &::after{
      content: '';
      position: absolute;
      top: 10px;
      right: -50px;
      width: 40px;
      height: 1px;
      background: #ccc;
      opacity: .5;
    }
  }

  .sign_type_list {
    width: 168px;
    margin: auto;
    display: flex;
    justify-content: space-around;
    align-items: center;
    padding-top: 20px;

    img {
      width: 36px;
      height: 36px;
      cursor: pointer;
      transition: transform 0.2s ease;
      
      &:hover {
        transform: scale(1.1);
      }
    }
    
    // X (Twitter) OAuth 2.0 登录按钮样式
    .x-login-btn {
      width: 36px;
      height: 36px;
      border-radius: 50%;
      background: linear-gradient(135deg, #1da1f2 0%, #0d8bd9 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      transition: all 0.3s ease;
      box-shadow: 0 2px 8px rgba(29, 161, 242, 0.3);
      
      &:hover {
        transform: scale(1.1);
        box-shadow: 0 4px 16px rgba(29, 161, 242, 0.5);
        background: linear-gradient(135deg, #0d8bd9 0%, #1da1f2 100%);
      }
      
      &:active {
        transform: scale(0.95);
      }
      
      svg {
        color: white;
        transition: color 0.2s ease;
      }
      
      &:hover svg {
        color: #ffffff;
      }
    }
  }

}
</style>
