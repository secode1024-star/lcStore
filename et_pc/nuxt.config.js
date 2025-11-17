const VUE_APP_API_URL = "https://api.hqlccn.com"; //通过Nginx反向代理访问
//const MODE = "universal"; //服务器渲染模式 (需要独立部署) 打包命令 npm run build
const MODE = "spa"; //单页面形式渲染模式 (打包后将 dist目录覆盖到 public/pc 目录下) 打包命令: npm run generate

//(上方配置,不做独立部署无需修改)
module.exports = {
  env: {
    BASE_URL: VUE_APP_API_URL,
  },
  mode: MODE,
  // Global page headers: https://go.nuxtjs.dev/config-head
  head: {
    title: "寰球联采",
    htmlAttrs: {
      lang: "en",
    },
    meta: [
      { charset: "utf-8" },
      {
        hid: "description",
        name: "description",
        content:
          "寰球联采全球采购平台，专注于连接全球优质供应商与采购商，提供一站式国际贸易服务。",
      },
      {
        hid: "keywords",
        name: "keywords",
        content:
          "寰球联采,全球采购,国际贸易,B2B平台,跨境电商,供应商管理,采购平台,全球供应链,国际商务,贸易服务,工业采购,原材料采购,消费品采购,多语言平台",
      },
      { name: "viewport", content: "width=device-width, initial-scale=1" },
      {
        hid: "http-equiv",
        "http-equiv": "X-UA-Compatible",
        content: "IE=edge",
      },
      { name: "format-detection", content: "telephone=no" },
    ],
    link: [{ rel: "icon", type: "image/png", href: "/favicon.ico" }],
    script: [
      { src: "https://js.stripe.com/v3/" },
      { 
        src: "https://connect.facebook.net/en_US/sdk.js",
        async: true,
        defer: true 
      }
    ],
  },
  loading: { color: "#e93323" },
  // Global CSS: https://go.nuxtjs.dev/config-css
  css: [
    { src: "@/assets/iconfont/iconfont.css", ssr: false },
    "@/assets/css/index.scss",
    { src: "element-ui/lib/theme-chalk/index.css", ssr: false },
    { src: "swiper/dist/css/swiper.css" },
  ],

  // Plugins to run before rendering page: https://go.nuxtjs.dev/config-plugins
  plugins: [
    "@/plugins/axios",
    "@/plugins/i18n.js",
    { src: "@/plugins/vue-swiper.js", ssr: false },
    { src: "@/plugins/element-ui", ssr: false },
    { src: "@/plugins/utils.js", ssr: true },
    { src: "@/plugins/vue-clipboard.js", ssr: true },
    { src: "@/plugins/filter.js", ssr: true },
    { src: "@/plugins/component.js", ssr: true },
    { src: "@/plugins/categoryTranslation.js", ssr: false },
  ],

  // Auto import components: https://go.nuxtjs.dev/config-components
  components: true,

  // Modules for dev and build (recommended): https://go.nuxtjs.dev/config-modules
  buildModules: [],

  // Modules: https://go.nuxtjs.dev/config-modules
  modules: [
    "@nuxtjs/axios",
    "@nuxtjs/auth",
    "cookie-universal-nuxt",
    "nuxt-sass-resources-loader",
    // 'stripe'
  ],
  router: {
    middleware: ["auth"],
    //默认为history可更改为hash
    mode: "history",
    extendRoutes(routes, resolve) {
      // 为X OAuth回调页面禁用auth中间件
      routes.forEach(route => {
        if (route.path === '/auth/x/callback') {
          route.meta = route.meta || {};
          route.meta.auth = false;
        }
      });
    }
  },
  //local 手机密码登录，
  //local1 手机号验证码登录,
  //local2 邮箱登录
  //local6 twitter登录 (OAuth 1.0)
  //local7 X OAuth 2.0登录
  //local8 Facebook登录
  auth: {
    strategies: {
      local: {
        _scheme: "local",
        endpoints: {
          login: {
            url: "/api/front/login/mobile/password",
            method: "post",
            propertyName: "token",
          },
          logout: {
            url: "/api/front/login/logout",
            method: "get",
          },
          user: {
            url: "/api/front/user/info",
            method: "get",
            propertyName: false,
          },
        },
      },
      local1: {
        _scheme: "local",
        token: {
          property: "token",
          name: "X-Access-Token",
          type: false,
        },

        endpoints: {
          login: {
            url: "/api/front/login/mobile/captcha",
            method: "post",
            propertyName: "token",
          },
          logout: {
            url: "/api/front/login/logout",
            method: "get",
          },
          user: {
            url: "/api/front/user/info",
            method: "get",
            propertyName: false,
          },
        },
      },
      local2: {
        _scheme: "local",
        endpoints: {
          login: {
            url: "/api/front/login/email",
            method: "post",
            propertyName: "token",
          },
          logout: {
            url: "/api/front/login/logout",
            method: "get",
          },
          user: {
            url: "/api/front/user/info",
            method: "get",
            propertyName: false,
          },
        },
      },
      local3: {
        _scheme: "local",
        endpoints: {
          login: {
            url: "/api/front/login/register/visitor",
            method: "post",
            propertyName: "token",
          },
          logout: {
            url: "/api/front/login/logout",
            method: "get",
          },
          user: {
            url: "/api/front/user/info",
            method: "get",
            propertyName: false,
          },
        },
      },
      local4: {
        _scheme: "local",
        endpoints: {
          login: {
            url: "/api/front/login/register/email",
            method: "post",
            propertyName: "token",
          },
          logout: {
            url: "/api/front/login/logout",
            method: "get",
          },
          user: {
            url: "/api/front/user/info",
            method: "get",
            propertyName: false,
          },
        },
      },
      local5: {
        _scheme: "local",
        endpoints: {
          login: {
            url: "/api/front/login/register/mobile",
            method: "post",
            propertyName: "token",
          },
          logout: {
            url: "/api/front/login/logout",
            method: "get",
          },
          user: {
            url: "/api/front/user/info",
            method: "get",
            propertyName: false,
          },
        },
      },
      local6: {
        _scheme: "local",
        endpoints: {
          login: {
            url: "/api/front/login/twitter",
            method: "post",
            propertyName: "token",
          },
          logout: {
            url: "/api/front/login/logout",
            method: "get",
          },
          user: {
            url: "/api/front/user/info",
            method: "get",
            propertyName: false,
          },
        },
      },
      local7: {
        _scheme: "local",
        endpoints: {
          login: {
            url: "/api/front/login/x-oauth",
            method: "post",
            propertyName: "token",
          },
          logout: {
            url: "/api/front/login/logout",
            method: "get",
          },
          user: {
            url: "/api/front/user/info",
            method: "get",
            propertyName: false,
          },
        },
      },
      local8: {
        _scheme: "local",
        endpoints: {
          login: {
            url: "/api/front/login/facebook",
            method: "post",
            propertyName: "token",
          },
          logout: {
            url: "/api/front/login/logout",
            method: "get",
          },
          user: {
            url: "/api/front/user/info",
            method: "get",
            propertyName: false,
          },
        },
      },
      local9: {
        _scheme: "local",
        token: {
          property: "token",  // 🔥 修复：token直接在根级别
          name: "Authori-zation",  // 🔥 修复：使用后端期望的header名称
          type: "TOKEN_USER:",  // 🔥 修复：添加后端期望的token前缀
        },
        endpoints: {
          login: {
            url: "/api/front/login/google",
            method: "post",
            propertyName: "token",  // 🔥 修复：token直接在根级别
            headers: {
              'Content-Type': 'application/json'  // 🔥 修复：设置正确的Content-Type
            }
          },
          logout: {
            url: "/api/front/login/logout",
            method: "get",
          },
          user: {
            url: "/api/front/user/info",
            method: "get",
            propertyName: false,
          },
        },
      },
    },
    redirect: {
      login: "/",
      logout: "/",
      callback: "/",
      home: false,
    },
    cookie: {
      options: {
        maxAge: 60 * 60 * 24 * 7,
      },
    },
    localStorage: false,
  },

  axios: {
    baseURL: VUE_APP_API_URL,
    proxyHeaders: false,
    credentials: false,
    debug: `${process.env.NODE_ENV}` !== "production",
  },

  // Build Configuration: https://go.nuxtjs.dev/config-build
  build: {
    publicPath: "/pc/",
    publicPathFolder: MODE === "spa" ? "/" : "",
    /*
     ** You can extend webpack config here
     */
    extend(config, ctx) {
      config.module.rules.push({
        test: /\.(wav)(\?.*)?$/,
        loader: "file-loader",
      });
    },
    babel: {
      plugins: [
        [
          "component",
          {
            libraryName: "element-ui",
            styleLibraryName: "theme-chalk",
          },
        ],
      ],
    },
  },
  vendor: ["element-ui", "vue-i18n"],

  server: {
    port: 8000,
    host: "0.0.0.0", // default: localhost
  },
};

