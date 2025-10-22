<template>
  <div>
    <!--头部-->
    <base-info ref="baseInfo" v-if="checkPermi(['platform:statistics:home:index'])" />
    <!--小方块-->
    <grid-menu class="mb20" />
    <!--用户概览-->
    <user-overview></user-overview>
  </div>
</template>

<script>
import baseInfo from './components/baseInfo';
import gridMenu from './components/gridMenu';
import userOverview from './components/userOverview';
import { checkPermi } from '@/utils/permission'; // 权限判断函数
import { authCertQuery } from '@/api/authInformation';
import Cache from '@/plugins/cache';

export default {
  name: 'Dashboard',
  components: { baseInfo, gridMenu, userOverview },
  data() {
    return {
      authStatus: null,
      authHost: '',
      authQueryStatus: false,
    };
  },
  mounted() {
    // if(window.location.host.indexOf('localhost') == -1){
    // this.authStatus = Cache.local.has('auth-information') ? Cache.local.getJSON('auth-information') : null;
    // let notInformation = Cache.local.has('not-information') ? Cache.local.getJSON('not-information') : null;
    // if(!this.authStatus){
    //   this.getUniq();
    // }
    // }
  },
  methods: {
    checkPermi,
    authInformationQuery() {
      authCertQuery({ host: this.authHost }).then((res) => {
        let oneDay = 24 * 3600 * 1000;
        if (res.data.status == -1 || res.data.status == 2) {
          Cache.local.setItem({ name: 'not-information', value: true, expires: oneDay });
          if (!notInformation) {
            this.$modal
              .confirm(res.data.msg)
              .then(() => {
                this.$router.push({ path: '/maintain/authCRMEB' });
              })
              .catch(() => {});
          }
        } else if (res.data.status == 1) {
          this.$modal.msgSuccess(res.data.msg);
          Cache.local.setItem({ name: 'auth-information', value: true, expires: oneDay * 7 });
        } else if (res.data.status == 3 || res.data.status == 0) {
          this.$modal.msg(res.data.msg);
        }
      });
    },
    getUniq() {
      configGetUniq({ key: 'authHost' }).then((res) => {
        this.authHost = res;
        if (res !== '') {
          this.authInformationQuery();
        } else {
          this.$modal.confirm('您尚未提交授权申请').then(() => {
            this.$router.push({ path: '/maintain/authCRMEB' });
          });
        }
      });
    },
  },
};
</script>
