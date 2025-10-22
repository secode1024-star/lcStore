<template>
    <div class="error-page">
      <template v-if="error.statusCode == 404">
        <img src="~assets/images/404.png" alt="" >
        <p class="title">{{$t(`message.tips.error1`)}}</p>
        <span class="small">{{error.message}}</span>
        <!--<span class="small">您可能输错了网址，或该网页已被删除、不存在等</span>-->
      </template>
      <template v-else-if="error.statusCode == 500">
        <img src="~assets/images/500.png" alt="">
        <p class="title">{{$t(`message.tips.error2`)}}</p>
        <p class="small">{{error.message}}</p>
      </template>
      <template v-else-if="error.statusCode == 401">
        <img src="~assets/images/500.png" alt="">
        <p class="title mb30">{{$t(`message.tips.placeLogin`)}}</p>
      </template>
      <template v-else>
        <img src="~assets/images/400.png" alt="">
        <p class="title">{{$t(`message.tips.error3`)}}</p>
        <span class="small">{{$t(`message.tips.error4`)}}</span>
      </template>
      <el-button plain @click="goHome">{{$t(`page.orderPayStatus.backHome`)}}</el-button>
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
      props: ['error'],
      name: "error.vue",
      methods:{
        goHome(){
          this.$router.replace('/')
        }
      }
    }
</script>

<style lang="scss" scoped>
.error-page{
  height: 600px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  .title{
    margin-top: 20px;
    font-size: 24px;
    color: #282828;
  }
  .small{
    margin: 12px 0 24px;
    font-size: 14px;
    color: #969696;
  }
}
</style>
