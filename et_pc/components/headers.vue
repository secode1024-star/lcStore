<template>
  <div class="container">
    <div class="nav">
      <div class="nav_con">
        <div class="left_nav">
          <div class="home">
            <span class="iconfont icon-shouye8"></span>
            <nuxt-link :to="{ path: '/' }" class="home">{{ $t(`page.goodsDetail.home`) }}</nuxt-link>
          </div>
          <div class="collect cursors" @click="AddFavorite()">
            <span class="iconfont icon-shoucang3"></span>
            {{ $t(`page.index.collectSite`) }}
          </div>
        </div>
        <div class="right_nav">
          <nuxt-link :to="{ path: '/users/order_list?orderStatus=1' }" class="orders">{{ $t(`page.user.myOrder`) }}
          </nuxt-link>
          <div class="line"></div>
          <div class="apply" @click="goMerSettled()">
            {{ $t(`page.index.applyFor`) }}
          </div>
        </div>
      </div>

    </div>
    <div class="header" :class="navBarFixed == true ? 'navBarWrap' : ''">
      <div class="header_con">
        <span v-if="$nuxt.$route.path == '/'" class="iconfont icon-more"></span>
        <span v-else class="iconfont icon-more" @mouseenter="show"></span>
        <div class="logo">
          <nuxt-link :to="{ path: '/' }"><img :src="logoUrl" alt=""></nuxt-link>
        </div>
        <div class="input">
          <div class="left_select">
            <input type="text" :placeholder="$t(`page.goodsSearch.placeSearch`)" v-model="search">
          </div>
          <div v-if="hotSearchList.length" class="right_select">
            <div class="keyword" @click="(search = item.title) && submit()" v-for="item in hotSearchList.slice(0, 3)"
              :key="item.id">
              {{ item.title }}
            </div>
            <div class="search" @click="submit">
              <span class="iconfont icon-sousuo"></span>
            </div>
          </div>
        </div>
        <el-dropdown trigger="click" placement="bottom-start">
          <div class="language-selector-btn">
            <span class="globe-icon iconfont icon-yuyanqiehuan"></span>
            <span class="lang-text">{{ getCurrentLanguageName() }}</span>
            <i class="el-icon-arrow-down arrow-icon"></i>
          </div>
          <el-dropdown-menu slot="dropdown" class="language-dropdown-menu">
            <template v-for="(item, index) in langList">
              <el-dropdown-item 
                v-for="(items, idx) in item.intro" 
                :key="idx" 
                @click.native="languagelTab(items)"
                :class="{ 'is-active': isCurrentLanguage(items) }"
              >
                <span class="lang-flag">{{ getLanguageFlag(items) }}</span>
                <span class="lang-name">{{ $t(`userDrawer.language[${idx}].name`) }}</span>
                <i v-if="isCurrentLanguage(items)" class="el-icon-check check-icon"></i>
              </el-dropdown-item>
            </template>
          </el-dropdown-menu>
        </el-dropdown>

        <nuxt-link to="/order/shopping_cart" class="cartNum">
          <div class="car">
            <span class="iconfont icon-gouwuche"></span>
            <span v-if="$store.state.cartNumber" class="num">{{ $store.state.cartNumber }}</span>
          </div>
        </nuxt-link>

        <div class="pic">
          <img :src="$auth.user ? $auth.user.avatar : defaultPic">
        </div>
        <div v-if="!$auth.loggedIn" class="login" @click="longin">{{ $t(`page.users.login.sign`) }}</div>
        <div v-else>
          <el-dropdown>
            <span class="login el-dropdown-link line1">
              {{ $auth.user.nickname }}<i class="el-icon-arrow-down el-icon--right"></i>
            </span>
            <el-dropdown-menu slot="dropdown">
              <div class="userBox acea-row row-middle">
                <div class="avatarPic">
                  <img :src="$auth.user ? $auth.user.avatar : defaultPic">
                </div>
                <div>
                  <div class="nickname">{{ $auth.user.nickname }}</div>
                  <div v-show="$auth.user.phone" class="count">{{ $auth.user.phone }}</div>
                  <div v-show="$auth.user.email" class="count">{{ $auth.user.email }}</div>
                </div>
              </div>
              <el-dropdown-item v-for="(menu, index) in userMenu" :key="menu.id" @click.native="goPage(menu)">
                <div class="dropdownBox" v-show="menu.pc_url && menu.pc_url != ' '">
                  {{ $t(`page.user.mineNav[${index}].name`) }}</div>
              </el-dropdown-item>
              <div class="userInfo">
                <el-divider></el-divider>
              </div>
              <el-dropdown-item v-for="(menu, index) in menus" :key="menu.id" @click.native="goPage(menu)">
                <div class="dropdownBox" v-show="menu.pc_url && menu.pc_url != ' '">{{ translateMenuName(menu.name) }}</div>
              </el-dropdown-item>
              <el-button @click="longOut" class="btn">{{ $t(`page.users.userInfo.logOut`) }}</el-button>
            </el-dropdown-menu>
          </el-dropdown>
        </div>
        <div class="category acea-row" @mouseleave="leave()" v-if="hide">
          <div class="sort">
            <div class="item acea-row row-between-wrapper" :class="index === current ? 'bg-color' : ''"
              v-for="(item, index) in $store.state.productClassify" :key="index" @mouseenter="enter(index)">
              <div class="name line1">{{ getLocalizedName(item) }}</div>
            </div>
          </div>
          <div class="sortCon" @mouseleave="show" v-if="seen && categoryCurrent">
            <div class="erSort">
              <div class="item acea-row row-middle" v-for="(item, index) in categoryCurrent" :key="index">
                <div class="name line1">{{ getLocalizedName(item) }}</div>
                <div class="cateList">
                  <span class="cateItem" @click="goCate(items)" v-for="(items, indexn) in item.childList" :key="indexn">
                    {{ getLocalizedName(items) }}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
// +----------------------------------------------------------------------
// | 寰球联采 [ 连接全球，共创未来 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2025 https://www.hqlccn.com All rights reserved.
// +----------------------------------------------------------------------
// | 寰球联采全球采购平台
// +----------------------------------------------------------------------
// | Author: 寰球联采开发团队 <admin@hqlccn.com>
// +----------------------------------------------------------------------
// import VueI18n from 'vue-i18n';
// const i18n = new VueI18n();
import { configMap } from '@/utils/validate.js'
export default {
  name: "headers",
  mixins: [],
  data() {
    return {
      logoUrl: '',
      categoryCurrent: [],
      langList: [
        {
          name: '语言',
          current: 1,
          intro: ['zh-CN', 'en', 'fr', 'th', 'ru', 'ko', 'ar', 'ja']
        }
      ],
      menus: [],
      seen: false,
      hide: false,
      navBarFixed: false,
      headerList: [],
      search: "",
      userInfo: {},
      showCode: false,
      hotSearchList: [],
      searchList: [],
      list: [],
      dialogVisible: false,
      current: 1,
      info: '',
      isShow: true,
      appidNum: '',
      hosts: '',
      fromPath: '',
      disabled: false,
      defaultPic: require("../assets/images/morentou.png"),
      cid: null,
      userMenu: [
        {
          id: 111,
          name: this.$t(`page.user.myOrder`),
          pc_url: '/users/order_list'
        },
        {
          id: 222,
          name: this.$t(`page.users.goodsReturn.refundList`),
          pc_url: '/users/refund_list'
        },
        {
          id: 333,
          name: this.$t(`page.users.replyList.navTitle`),
          pc_url: '/users/evaluation_list'
        }
      ]
    }
  },
  computed: configMap(['logoUrl']),
  watch: {
    $route: {
      handler: function (newVal, oldVal) {
        this.search = newVal.query.title ? newVal.query.title : '';
      },
      // 深度观察监听
      deep: true
    }
  },
  head() {
    if (this.$route.path == '/') {
      this.hide = true;
      this.navBarFixed = false;
    } else {
      this.hide = false;
    }
    if (this.$auth.loggedIn) {
      this.getMenus();
      this.carCount();
    }
    return {
      title: this.$store.state.titleCon
    }
  },
  beforeMount() {
    if (this.$auth.loggedIn) {
      this.getMenus();
      this.carCount();
    }
    if (!localStorage.getItem('homeDataPc')) {
      this.getHomeIndex()
    }
    this.getHotSearchList();
    this.$store.dispatch('getProductClassify')
    this.getLogoUrl()
  },
  mounted() {
    window.addEventListener('keydown', this.keyDown);
    this.hosts = location.origin + location.pathname;
    this.fromPath = this.$cookies.get("fromPath");
    window.addEventListener("scroll", this.watchScroll);
  },
  destroyed() {
    window.removeEventListener('keydown', this.keyDown, false);
  },
  methods: {
    /**
     * 翻译菜单名称
     */
    translateMenuName(menuName) {
      // 尝试从语言包中获取翻译
      try {
        const menuItems = this.$t('page.user.menuItems');
        if (menuItems && typeof menuItems === 'object' && menuItems[menuName]) {
          return menuItems[menuName];
        }
      } catch (e) {
        console.log('Translation error in header:', e);
      }
      // 如果翻译不存在，返回原始名称
      return menuName;
    },
    /**
     * 根据当前语言获取分类名称（从数据库读取）
     */
    getLocalizedName(category) {
      if (!category || !category.name) {
        return '';
      }

      // 如果是中文，直接返回原名称
      if (this.$i18n.locale === 'zh-CN') {
        return category.name;
      }

      // 根据语言返回对应的翻译字段
      const langField = this.getLanguageField(this.$i18n.locale);
      
      if (category[langField] && category[langField].trim()) {
        return category[langField];
      }

      // 如果没有翻译，返回原名称
      return category.name;
    },

    /**
     * 获取语言对应的字段名
     */
    getLanguageField(locale) {
      const languageFields = {
        'en': 'nameEn',
        'fr': 'nameFr', 
        'th': 'nameTh',
        'ko': 'nameKo',
        'ja': 'nameJa',
        'ar': 'nameAr'
      };
      return languageFields[locale] || 'name';
    },

    getLogoUrl() {
      try {
        const homeData = localStorage.getItem("homeDataPc");
        if (homeData) {
          const data = JSON.parse(homeData);
          if (data && data.logoUrl) {
            this.logoUrl = data.logoUrl;
          }
        }
      } catch (error) {
        console.warn('获取logoUrl失败:', error);
      }
    },
    getHomeIndex() {
      this.$axios.get("/api/pc/home/index").then(res => {
        localStorage.setItem("homeDataPc", JSON.stringify(res.data));
        // 更新 logoUrl
        if (res.data && res.data.logoUrl) {
          this.logoUrl = res.data.logoUrl;
        }
      })
    },
    carCount() {
      this.$axios.get("/api/front/cart/count?numType=true&type=total").then(res => {
        this.$store.commit('cartNum', res.data.count);
      })
    },
    /**
     * 语言切换
     */
    languagelTab(n) {
      console.log('切换语言:', n);
      
      this.$i18n.locale = n;
      this.$cookies.set('locale', n);
      this.$store.commit('SET_LANG', n);
      
      // 强制更新视图以显示新语言的内容
      this.$forceUpdate();
    },

    /**
     * 获取当前语言名称
     */
    getCurrentLanguageName() {
      const languageNames = {
        'zh-CN': '中文',
        'en': 'English',
        'fr': 'Français',
        'th': 'ไทย',
        'ru': 'Русский',
        'ko': '한국어',
        'ar': 'العربية',
        'ja': '日本語'
      };
      return languageNames[this.$i18n.locale] || '中文';
    },
    /**
     * 获取语言旗帜图标
     */
    getLanguageFlag(langCode) {
      const flags = {
        'zh-CN': '🇨🇳',
        'en': '🇺🇸',
        'fr': '🇫🇷',
        'th': '🇹🇭',
        'ru': '🇷🇺',
        'ko': '🇰🇷',
        'ar': '🇸🇦',
        'ja': '🇯🇵'
      };
      return flags[langCode] || '🌐';
    },
    /**
     * 判断是否为当前语言
     */
    isCurrentLanguage(langCode) {
      return this.$i18n.locale === langCode;
    },
    /**
     *
     * 退出登录
     */
    async longOut() {
      let val = this.$cookies.get('auth.strategy')
      await this.$auth.logout().then(res => {
        this.$message.success('退出登录成功');
        this.$store.commit('cartNum', 0);
        window.localStorage.clear();
        this.$router.replace({
          path: '/'
        })
      })
    },
    // 商品分类
    goCate(items) {
      this.cid = items.id
      this.$router.push({
        path: '/goods/goods_search',
        query: {
          cid: items.id,
          title: this.search ? this.search.trim() : ''
        }
      });
    },
    /**
     *
     * 商户入驻
     */
    goMerSettled() {
      this.$router.push({
        path: `/users/merchant_settled`,
        query: { menuCur: 70 }
      });
    },
    goPage(menu) {
      this.$router.push({
        path: `${menu.pc_url}`,
        query: { menuCur: menu.id }
      });
    },
    /**
     *
     * 获取菜单
     */
    getMenus() {
      this.$axios.get("/api/front/user/menu/user").then(res => {
        this.menus = res.data.routine_my_menus
      })
    },
    longin() {
      this.$store.commit("isLogin", true);
      this.$store.commit("isTourists", false);
    },
    getHotSearchList() {
      this.$axios.get("/api/front/search/keyword").then(res => {
        this.hotSearchList = res.data || [];
      })
    },
    watchScroll() {
      var scrollTop =
        window.pageYOffset ||
        document.documentElement.scrollTop ||
        document.body.scrollTop;

      if ($nuxt.$route.path == '/' && scrollTop > 120) {
        this.navBarFixed = true;
        this.hide = false;
      } else if ($nuxt.$route.path == '/' && scrollTop < 120) {
        this.navBarFixed = false;
        this.hide = true;
      } else if ($nuxt.$route.path !== '/' && scrollTop > 120) {
        this.navBarFixed = true;
      } else if ($nuxt.$route.path !== '/' && scrollTop < 120) {
        this.navBarFixed = false;
      }
    },
    AddFavorite() {
      let url = window.location;
      let title = document.title;
      let ua = navigator.userAgent.toLowerCase();
      if (ua.indexOf("360se") > -1) {
        this.$message(this.$t(`message.tips.browser`));
      }
      else if (ua.indexOf("msie 8") > -1) {
        window.external.AddToFavoritesBar(url, title); //IE8
      }
      else if (document.all) {
        try {
          window.external.addFavorite(url, title);
        } catch (e) {
          this.$message(this.$t(`message.tips.nubrowser`));
        }
      }
      else if (window.sidebar) {

        this.$message(this.$t(`message.tips.nubrowser`));
      }
      else {
        this.$message(this.$t(`message.tips.nubrowser`));
      }
    },
    submit() {
      this.$router.push({
        path: '/goods/goods_search', query: {
          title: this.search ? this.search.trim() : '',
          cid: this.cid
        }
      });
    },
    handleClose() {
      this.dialogVisible = false
    },
    showLogin() {
      this.$store.commit("isLogin", true);
    },
    keyDown(e) {
      // this.submit()
    },
    enter(index) {
      this.seen = true;
      this.hide = true;
      this.current = index;
      this.categoryCurrent = this.$store.state.productClassify[index].childList;
    },
    leave() {
      if ($nuxt.$route.path == '/') {
        this.seen = false;
        this.hide = true
      } else {
        this.seen = false;
      }

    },
    show() {
      this.hide = !this.hide
    }
  }
}
</script>
<style scoped lang="scss">
.userInfo {
  ::v-deep.el-divider--horizontal {
    margin: 10px 0 !important;
  }
}

.dropdownBox {
  width: 245px;
}

.btn {
  margin: 15px 94px;
}

.userBox {
  padding: 10px 20px 20px 20px;

  .avatarPic {
    width: 52px;
    height: 52px;
    border-radius: 50%;
    overflow: hidden;
    margin-right: 10px;

    img {
      width: 100%;
      height: 100%;
    }
  }

  .nickname {
    font-size: 16px;
    font-family: Arial-BoldMT, Arial;
    font-weight: bold;
    color: #333333;
    margin-bottom: 5px;
  }

  .count {
    font-size: 12px;
    font-family: ArialMT;
    color: #999999;
  }
}

.container {
  width: 100%;
  // position: fixed;
  z-index: 99;

  .nav {
    background: #F4F4F4;

      .nav_con {
        width: 1200px;
        height: 30px;
        margin: 0 auto;
        display: flex;
        justify-content: space-between;
        background: #F4F4F4;
      font-size: 14px;
      font-family: PingFangSC-Regular, PingFang SC;
      font-weight: 400;
      color: #666666;
      line-height: 14px;

      .left_nav {
        display: flex;
        flex-wrap: nowrap;
        align-items: center;

        .icon {
          font-size: 12px;
          background: #8A8A8A;
        }

        .home {
          margin-right: 20px;
          cursor: pointer;
        }
      }

      .right_nav {
        display: flex;
        flex-wrap: nowrap;
        align-items: center;

        .orders {
          margin-right: 10px;
        }

        .line {
          width: 1px;
          height: 10px;
          background: #000000;
          opacity: 0.1;
        }

        .apply {
          margin: 0 10px;
          cursor: pointer;
        }

        .mobile {
          margin-left: 10px;
          cursor: pointer;
        }
      }
    }
  }

  .header {
    width: 100%;
    height: 90px;
    margin: auto;
    background: #FFFFFF;

      .header_con {
        width: 1200px;
        height: 90px;
        margin: 0 auto;
        display: flex;
        justify-content: flex-start;
        align-items: center;
        position: relative;

      .icon-more {
        font-size: 22px;
        color: #000000;
        cursor: pointer;
      }

      .logo {
        width: 112px;
        height: 40px;
        margin: 0 33px 0 40px;

        img {
          width: 112px;
          height: 40px;
        }
      }

      .input {
        width: 750px;
        height: 40px;
        border: 1px solid #E93323;
        border-radius: 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding-left: 20px;

        .left_select {
          input {
            width: 435px;
            outline: none;
            border: 0;
          }
        }

        .right_select {
          display: flex;
          align-items: center;

          .keyword {
            width: 62px;
            height: 16px;
            background: #EEEEEE;
            border-radius: 20px;
            font-size: 12px;
            font-family: ArialMT;
            color: #999999;
            line-height: 16px;
            text-align: center;
            margin-right: 5px;
            cursor: pointer;
          }

          .search {
            width: 60px;
            height: 40px;
            background: #E93323;
            border-radius: 20px;
            text-align: center;
            line-height: 40px;
            color: #fff;
            margin-left: 11px;
            cursor: pointer;
          }
        }
      }

      .code,
      .car {
        width: 34px;
        height: 34px;
        background: #FFFFFF;
        border: 1px solid #999999;
        border-radius: 50%;
        text-align: center;
        line-height: 34px;
        cursor: pointer;
        position: relative;

        .num {
          position: absolute;
          top: -6px;
          left: 21px;
          color: #fff;
          font-size: 12px;
          padding: 2px 5px;
          border-radius: 100px;
          background-color: #E93323;
          display: inline-block;
          font-weight: 800;
          line-height: 14px;
        }
      }

      .language-selector-btn {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 8px 16px;
        margin-left: 24px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 20px;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
        
        &:hover {
          transform: translateY(-2px);
          box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
          background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
        }
        
        .globe-icon {
          font-size: 18px;
          color: #ffffff;
        }
        
        .lang-text {
          font-size: 14px;
          font-weight: 500;
          color: #ffffff;
          white-space: nowrap;
        }
        
        .arrow-icon {
          font-size: 12px;
          color: #ffffff;
          transition: transform 0.3s ease;
        }
        
        &:hover .arrow-icon {
          transform: rotate(180deg);
        }
      }

      .car {
        margin: 0 20px;

        .icon {
          font-size: 16px;
          color: #333;
        }
      }

      .pic {
        width: 30px;
        height: 30px;
        background: #EEEEEE;
        border-radius: 50%;
        margin-right: 10px;
        text-align: center;
        line-height: 30px;
        overflow: hidden;

        img {
          width: 100%;
          height: 100%;
        }
      }

      .login {
        font-size: 14px;
        font-family: Arial-BoldMT, Arial;
        font-weight: normal;
        color: #333333;
        line-height: 14px;
        cursor: pointer;
        width: 90px;
        display: block;
      }

    }
  }
}

.navBarWrap {
  position: fixed;
  top: 0;
  z-index: 999;
}

.category {
  position: absolute;
  top: 90px;
  left: 0;
  z-index: 9;
}

.sort {
  width: 208px;
  height: 480px;
  background-color: rgba(0, 0, 0, 0.6);
  color: #fff;
  padding: 14px 0;

  .item {
    height: 39px;
    padding: 0 21px;

    .name {
      width: 150px;
      cursor: pointer;
    }

    .iconfont {
      font-size: 10px;
    }
  }
}

.sortCon {
  width: 772px;
  height: auto;
  background-color: #fff;
  box-shadow: 5px 1px 10px rgba(0, 0, 0, 0.2);
  border: 1px solid #f2f2f2;
  border-left: 0;
  border-right: 0;
  padding: 0 5px 20px 20px;

  .title {
    padding-bottom: 8px;
    border-bottom: 1px solid #f1f1f1;

    .font-color {
      padding-bottom: 8px;
      font-size: 16px;
      border-bottom: 2px solid #e93323;
    }
  }

  .erSort {
    min-height: 480px;

    .item {
      margin-top: 23px;
      width: 100%;
      max-height: 100px;
      border-width: 1px;
      border-style: none none solid none;
      border-color: #eee;
      cursor: pointer;

      .name {
        color: #333333;
        font-size: 14px;
        width: 100%;
        font-family: Arial-BoldMT, Arial;

        &:hover {
          color: #e93323;
        }
      }

      .item-child {
        margin: 12px 30px 10px 0;
        font-size: 14px;
        color: #333333;
        font-family: ArialMT;
      }

      .pictrue {
        width: 50px;
        height: 50px;

        img {
          width: 100%;
          height: 100%;
        }
      }
    }

    .cateList {
      margin: 12px 30px 10px 0;
      font-size: 14px;
      color: #333333;
      font-family: ArialMT;

      .cateItem {
        text-align: center;
        padding: 0 20px;
        display: inline-block;
        cursor: pointer;

        &:hover {
          color: #e93323;
        }
      }
    }
  }
}

// 语言下拉菜单样式
::v-deep .language-dropdown-menu {
  margin-top: 8px !important;
  padding: 8px 0;
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
  border: 1px solid #e4e7ed;
  min-width: 200px;
  
  .el-dropdown-menu__item {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 20px;
    font-size: 14px;
    transition: all 0.2s ease;
    
    &:hover {
      background: linear-gradient(90deg, #f5f7fa 0%, #e8eef5 100%);
      color: #667eea;
    }
    
    &.is-active {
      background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
      color: #ffffff;
      font-weight: 500;
      
      .lang-flag {
        transform: scale(1.2);
      }
      
      .check-icon {
        margin-left: auto;
        font-size: 16px;
        color: #ffffff;
      }
    }
    
    .lang-flag {
      font-size: 20px;
      display: inline-block;
      transition: transform 0.2s ease;
    }
    
    .lang-name {
      flex: 1;
    }
    
    .check-icon {
      margin-left: auto;
      font-size: 16px;
      color: #67c23a;
    }
  }
}
</style>