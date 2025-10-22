<template>
    <div class="payment_result">
      <el-dialog
        :show-close="false"
        :visible.sync="dialogVisible"
        width="370px">
        <div class="acea-row row-column row-middle">
          <div class="pic"><img :src="status===1 || redirect_status ?require('../../assets/images/paysuccessful.png'):require('../../assets/images/payFailed.png')"></div>
          <div class="status font-color">{{status===1 || redirect_status ? $t(`page.orderPayStatus.success`):$t(`page.orderPayStatus.fail`)}}</div>
          <div class="tips">{{status===1 || redirect_status ? '您的订单将会尽快发货': '订单支付失败，请重新下单'}}</div>
          <el-button type="primary" @click="goList">确定</el-button>
        </div>

      </el-dialog>
    </div>
</template>

<script>
    export default {
        name: "order_sure",
      data() {
          return {
            dialogVisible: true
          }
      },
      async asyncData({ app, query }){
         return {
           status: Number(query.status),
           payerID: query.PayerID,
           token: query.token,
           redirect_status: Boolean(query.redirect_status)
         }
      },
      beforeMount(){
          if(this.payerID)  this.paypalSuccess()

      },
      methods: {
        paypalSuccess() {
          this.$axios.post('/api/front/pay/paypal/success',{
            "payerID": this.payerID,
            "token": this.token
          }).then(res=>{

          });
        },
        goList() {
          if(this.status===1 || this.redirect_status){
            this.$router.push({ path: '/users/order_list?orderStatus=1' });
          }else{
            this.$router.push({ path: '/' });
          }
        }
      }
    }
</script>

<style scoped lang="scss">
  .payment_result{
    ::v-deep.el-dialog__header{
      padding: 0;
    }
    ::v-deep.el-dialog__body{
       padding: 49px 0 43px 0;
    }
    .status{
      font-size: 20px;
      font-family: Arial-BoldMT, Arial;
      font-weight: bold;
    }
    .tips{
      font-size: 16px;
      font-family: ArialMT;
      color: #999999;
      margin: 24px 0;
    }
  }
.pic{
  width: 165px;
  height: 165px;
  margin-bottom: 30px;
  img{
    width: 100%;
    height: 100%;
  }
}
</style>
