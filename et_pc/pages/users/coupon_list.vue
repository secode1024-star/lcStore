<template>
    <div class="mycoupon-wrapper">
      <div class="user-com-tab">
        <span class="item" :class="{on:tabCur == 'usable'}" @click="tabCur= 'usable'">{{$t(`page.users.userCoupon.available`)}}</span>
        <span class="item" :class="{on:tabCur == 'unusable'}" @click="tabCur= 'unusable'">{{$t(`page.users.userCoupon.expired`)}}</span>
      </div>
      <div class="main-section" v-loading="loading">
        <div class="main-bd">
          <div  class="list acea-row">
            <coupon :couponList="couponList"></coupon>
          </div>
          <div class="pages-box" v-if="total > 0">
            <el-pagination
              background
              layout="prev, pager, next"
              @current-change="bindPageCur"
              :pageSize="limit"
              :total="total">
            </el-pagination>
          </div>
          <div class="empty-box" v-if="couponList.length == 0 && !loading">
            <img src="~/assets/images/noCoupou.png" alt="">
            <p>{{$t(`page.users.userCoupon.empty`)}}</p>
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
import coupon from "@/components/coupon";
    export default {
      name: "myCoupon",
      auth: "guest",
      components: {coupon},
      data(){
        return {
          tabCur: 'usable',
          list:[],
          couponList:[],
          loading: false,
          page: 1,
          limit: 9,
          total: 0,
        }
      },
      watch:{
        tabCur(nVal,oVal){
          this.page = 1;
          this.list = [];
          this.couponList = [];
          this.getCouponList()
        }
      },
      head() {
        return {
          title: this.$t(`page.users.userCoupon.navTitle`)
        }
      },
      filters: {
        timeYMD: function (value) {
          if(value){
            var newDate=/\d{4}-\d{1,2}-\d{1,2}/g.exec(value)
            return newDate[0]
          }
        }
	    },
      beforeMount() {
        this.getCouponList()
      },
      methods:{
        getCouponList() {
          let that = this;
          that.loading = true;
          that.couponList = []
          
          that.$axios
            .get("/api/front/coupon/list",{
                params:{
                    type: this.tabCur,
                    page: this.page,
                    limit: this.limit
                }
            }).then(res => {
                that.couponList = res.data.list
                that.total = res.data.total
                that.page = res.data.pages
                that.loading = false;
            }).catch(err => {
              that.$message.error(err);
            });
        },
        goStore(item){
          if(item.status==0){
            this.$router.push({ path: `/goods_coupon?id=${item.coupon_id}`});
          }
        },
        bindPageCur(data){
          this.page = data
          this.getCouponList()
        },
      }
    }
</script>

<style lang="scss" scoped>
.main-section{
  margin-top: 30px;
  .list {
    .item {
      width: 300px;
      height: 130px;
      margin-right: 15px;
      margin-bottom: 15px;
      background: url("~assets/images/coupon-back1.png") center/cover no-repeat;
      box-shadow: 0 3px 20px rgba(0, 0, 0, 0.08);
      &.svip{
        background-image: url("~assets/images/vipCouB.png");
        .label {
          background-color: #FEE2B6;
          color: #863C0D;
        }
        .money {
          color: #863C0D;
        }
        .btn{
          color: #863C0D;
        }
      }
      &.disabled {
        background-image: url("~assets/images/coupon-back2.png");
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
        .time {
          color: #d0d0d0;
        }
      }
      .text {
        flex: 1;
        padding-left: 14px;
      }
      .text-cont {
        margin-top: 14px;
        font-size: 14px;
        color: #969696;
      }
      .label {
        width: 62px;
        height: 24px;
        background-color: rgba(233, 51, 35, 0.1);
        font-size: 14px;
        line-height: 24px;
        text-align: center;
        color: #e93323;
      }
      .money {
        margin-right: 14px;
        font-size: 16px;
        color: #e93323;
        .num {
          font-weight: bold;
          font-size: 32px;
        }
      }
      .info {
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
        margin-top: 14px;
        font-size: 12px;
        color: #969696;
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
}
.user-com-tab span{
  padding: 0 8px;
}

</style>
