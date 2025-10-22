<template>
  <div ref="tsRoot">
    <client-only>
      <divHeader ref="tsHeader"></divHeader>
    </client-only>
    <divLogin ref="tsLogin" v-if="$store.state.login"></divLogin>
    <nuxt ref="tsNuxt" />
    <divFooter></divFooter>
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
import divHeader from '~/components/headers.vue'
import divFooter from '~/components/footers.vue'
import divLogin from '~/components/login.vue'
export default {
  components: {
    divHeader,
    divFooter,
    divLogin
  },
  mounted() {
    // 🔧 修复：避免在OAuth回调期间立即检查token，防止竞态条件
    if (this.$route.path.includes('/auth/') && this.$route.path.includes('/callback')) {
      console.log('🔄 OAuth回调期间，延迟token验证');
      setTimeout(() => {
        this.getTokenIsExist();
      }, 2000); // 等待OAuth流程完成
    } else {
      this.getTokenIsExist();
    }
  },
  methods: {
    getTokenIsExist() {
      this.$axios.post(`/api/front/login/token/is/exist`).then(res => {
        if (!res.data) {
          let local = this.$cookies.get('auth.strategy');
          this.$cookies.remove(`auth._token.${local}`);
          this.$store.commit("isLogin", false);
        }
      }).catch(() => {
        let local = this.$cookies.get('auth.strategy');
        this.$cookies.remove(`auth._token.${local}`);
        this.$store.commit("isLogin", false);
      });
    }
  }
}
</script>
