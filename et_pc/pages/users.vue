<template>
  <div class="user-wrapper wrapper_1200">
    <div class="router-tips">
      <nuxt-link to="/">{{$t(`page.store.index`)}}></nuxt-link>
      <nuxt-link :to="{path:'/users'}">{{$t(`page.users.userInfo.personalCenter`)}}</nuxt-link>
    </div>
    <div class="content acea-row">
      <div class="left-box">
        <div class="left-box">
          <div class="user-menu">
            <div @click="goPage(menu,index)" class="menu-item" v-for="(menu,index) in userMenu" :key="menu.id"
                 :class="{active:menuCur == menu.id}">
              <span v-show="menu.pc_url&&menu.pc_url!=' '">{{$t(`page.user.mineNav[${index}].name`)}}</span>
            </div>
            <el-divider></el-divider>
            <div @click="goPage(menu,index)" class="menu-item" v-for="(menu,index) in menus" :key="menu.id"
                 :class="{active:menuCur == menu.id}">
              <span v-show="menu.pc_url&&menu.pc_url!=' '">{{translateMenuName(menu.name)}}</span>
            </div>
          </div>
        </div>
      </div>
      <div class="right-box">
        <NuxtChild/>
      </div>
    </div>
    <FloatWindow></FloatWindow>
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
  export default {
    name: "user",
    auth: "guest",
    data() {
      return {
        userInfo: {},
        indexCur: 111,
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
    async asyncData({app, query, error}) {
      try {
        let data = await app.$axios.get(
          "/api/front/user/menu/user"
        );
        return {
          menuCur: query.menuCur || 111,
          menus: data.data.routine_my_menus
        };
      }
      catch (e) {
        error({statusCode: 401, msg: typeof e === 'string' ? e : '系统繁忙'});
      }
    },
    watch: {
      $route: {
        handler: function (val, oldVal) {
          this.menuCur = val.query.menuCur || 111;
        },
        // 深度观察监听
        deep: true
      },
    },
    head() {
      return {
        title: ""
      }
    },
    methods: {
      /**
       * 翻译菜单名称
       */
      translateMenuName(menuName) {
        // 尝试从语言包中获取翻译
        try {
          const menuItems = this.$t('page.user.menuItems');
          console.log('Current locale:', this.$i18n.locale);
          console.log('Menu name:', menuName);
          console.log('Menu items:', menuItems);
          
          if (menuItems && typeof menuItems === 'object' && menuItems[menuName]) {
            console.log('Found translation:', menuItems[menuName]);
            return menuItems[menuName];
          }
        } catch (e) {
          console.log('Translation error:', e);
        }
        
        // 如果翻译不存在，返回原始名称
        console.log('No translation found, returning original:', menuName);
        return menuName;
      },
      goPage(menu, index) {
        this.menuCur = menu.id
        this.$router.push({
          path: `${menu.pc_url}`,
          query: {menuCur: menu.id}
        });
      }
    }
  }
</script>
<style lang="scss" scoped>
  .user-wrapper {
    .left-box {
      width: 210px;
      .user-info {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 170px;
        background: #fff;
        color: #282828;
        font-size: 14px;
        .name {
          margin-top: 10px;
          padding: 0 15px;
        }
      }
      .user-menu {
        padding: 30px 0;
        background: #fff;
        ::v-deep.el-divider--horizontal{
          margin: 35px 0 !important;
        }
        .menu-item {
          display: block;
          margin-bottom: 38px;
          color: #333333;
          cursor: pointer;
          font-size: 14px;
          padding-left: 20px;
          &.active {
            color: #E93323;
            background: url("~assets/images/left-icon.png") no-repeat left center;
          }
        }
      }
    }
    .right-box {
      width: 975px;
      min-height: 730px;
      margin-left: 15px;
      padding-bottom: 30px;
    }
  }

  .router-tips {
    height: 40px;
    line-height: 40px;
    font-size: 14px;
    color: #333;
    a {
      color: #333;
    }
    span {
      color: #999999;
    }
  }
</style>
