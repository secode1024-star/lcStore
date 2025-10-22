<template>
    <div class="list">
        <div v-for="item in couponList" :key="item.id" class="item acea-row" :class="Number(item.status) > 0 || item.isUse ? 'disabled' : ''" :style="$nuxt.$route.path == '/users/coupon_list' ? 'margin-right: 18px':'margin-right: 40px'">
            <div class="text">
            <div class="label">{{item.useType===1?$t(`page.users.userCoupon.navList[0].name`):$t(`page.users.userCoupon.navList[1].name`)}}</div>
            <div class="text-cont acea-row row-middle">
                <div class="money">
                <span class="sign">{{GLOBAL.shopPayCurrency}}</span><span class="num">{{item.money}}</span>
                </div>
                <div class="info">
                <div>Min Shopping {{ item.minPrice}}</div>
                </div>
            </div>
            <div v-if="item.day" class="content line2">
                {{$t(`page.users.userCoupon.receivedInfo`)+ item.day + $t(`page.users.userCoupon.receivedInfo1`)}}
            </div>
            <div v-else class="content line2">
                {{item.name}}
            </div>
            <div v-if="item.startTime" class="time">
                {{ item.startTime | dateFormat }}~{{ item.endTime | dateFormat }}
            </div>
            <div v-else class="time">
                <div v-if="item.useStartTimeStr"> {{ item.useStartTimeStr | dateFormat }}~{{ item.useEndTimeStr | dateFormat }}</div>
                <div v-else></div>
                <div >
                    <div class="receive" v-if="item.isUse">{{$t(`page.users.userCoupon.received`)}}</div>
                    <div class="receive" v-else @click="receiveCoupon(item)">{{$t(`page.users.userCoupon.receive`)}}</div>
                </div>
            </div>
            </div>
        </div>
    </div>
</template>
<script>
export default {
  name: "coupon",
    props: {
        couponList:{
            type: Array,
            default: function() {
                return [];
            }
        }
    },
    methods: {
        receiveCoupon(item) {
          if (!this.$auth.loggedIn) {
            this.$store.commit("isLogin", true);
          }else{
            this.$axios.post("/api/front/coupon/receive",{
              couponId: item.id
            })
              .then(res => {
                item.isUse = 1;
                this.$message.success(res.message);
              })
          }
        }
    },
};
</script>
<style lang="scss" scoped>
  .list {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    grid-template-rows: auto;
    .item {
      width: 300px;
      height: 190px;
      margin: 0 40px 40px 0;
      background: url("~assets/images/coupon-bg.png") center/cover no-repeat;
      box-shadow: 0 3px 20px rgba(0, 0, 0, 0.06);
      &:nth-child(3n){
          margin-right: 0 !important;
      }
      &.disabled {
        background-image: url("~assets/images/coupon-dis-bg.png");
        .label {
          background-color: rgba(145, 145, 145, 0.1);
          color: #acacac;
        }
        .text-cont {
          color: #d0d0d0;
        }
        .money {
          color: #bfbfbf;
        }
        .name {
          color: #bfbfbf;
        }
      }
      .text {
        width: 100%;
        padding-left: 16px;
      }
      .text-cont {
        width: 100%;
        margin-top: 19px;
        font-size: 14px;
        color: #969696;
      }
      .label {
        width: 75px;
        height: 24px;
        background-color: rgba(233, 51, 35, 0.1);
        font-size: 14px;
        line-height: 24px;
        text-align: center;
        color: #e93323;
        float: right;
      }
      .money {
        margin-right: 14px;
        font-size: 16px;
        color: #e93323;
        font-weight: 900;
        .sign {
          font-size: 20px;
        }
        .num {
          font-size: 36px;
        }
      }
      .info {
        margin-top: 20px;
        flex: 1;
        min-width: 0;
      }
      .name {
        margin-bottom: 6px;
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
        font-size: 16px;
        color: #282828;
        width: 107px;
      }
      .time {
        margin-top: 10px;
        font-size: 12px;
        height: 50px;
        color: #fff;
        display: flex;
        justify-content: space-between;
        align-items: center;

        .receive {
          width: 60px;
          height: 18px;
          text-align: center;
          margin-right: 15px;
          border-radius: 9px;
          color: #fff;
          border: 1px solid #FFFFFF;
          line-height: 17px;
          cursor: pointer;
        }
      }
      .content {
        width: 239px;
        height: 44px;;
        margin-top: 14px;
        font-size: 16px;
        color: #282828;
      }
      .btn {
        width: 52px;
        padding-right: 18px;
        padding-left: 18px;
        font-size: 16px;
        color: #ffffff;
        cursor: pointer;
      }
    }
  }
</style>
