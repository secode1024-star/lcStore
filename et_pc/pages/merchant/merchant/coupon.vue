<template>
  <div>
    <div class="coupon wrapper_1200 row-middle">
      <div class="mycoupon-wrapper">
        <div class="main-section">
          <el-tabs v-model="activeName"  @tab-click="store">
            <el-tab-pane style="" :label="$t(`page.users.userCoupon.navList[${0}].name`)" name="1"></el-tab-pane>
            <el-tab-pane :label="$t(`page.users.userCoupon.navList[${1}].name`)" name="2"></el-tab-pane>
          </el-tabs>
          <div v-loading="loading">
            <coupon :couponList="couponList"></coupon>
            <!--<div class="main-bd" v-if="!this.couponList.length"></div>-->
            <div class="empty-box" v-if="couponList.length == 0 && !loading">
              <img src="~/assets/images/noCoupou.png" alt="">
              <p>{{$t(`page.users.userCoupon.empty`)}}</p>
            </div>
          </div>
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
      </div>
    </div>
  <!--</div>-->
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
    auth: false,
    filters: {
      dateFormat(value) {
        if (!value) {
          return;
        }
        return value.split(' ')[0];
      }
    },
    components: {coupon},
    data() {
      return {
        total: 0,
        activeName: '1',
        couponList:[],
        page: 1,
        useType: 1,
        limit: 10,
        loading: false
      }
    },
    async asyncData({app, query}) {
      return {
        merId: query.id
      };
    },
    head() {
      return {
        title: this.$t(`page.store.collar`)
      }
    },
    beforeMount() {
      this.getCouponList()
    },
    methods: {
      bindPageCur(data){
        this.page = data
        this.getCouponList()
      },
      getCouponList() {
        this.loading = true
        let currentPage = { page: this.page, limit: this.limit, useType: this.useType, merId: this.merId};
        this.$axios
          .get("/api/front/coupons",{
            params: currentPage,
          })
          .then(res => {
            this.couponList = res.data.list
            this.total = res.data.total
            this.loading = false
          }).catch(error=>{
          this.loading = false
        })
      },
      store(tab,event) {
        this.useType = tab.name;
        this.getCouponList()
      }
    }
  }
</script>
<style lang="scss" scoped>
  .trader_box{
    margin: 8px 0 16px 0;
  }
  .trader{
    display: inline-block;
    height: 24px;
    line-height: 24px;
    padding: 0 5px;
    text-align: center;
    color: #fff;
    background: #E93323;
    border-radius: 3px;
    margin-right: 3px;
    font-size: 12px;
  }
  .content {
    margin-top: 25px;
  }

  .store-banner {
    width: 1200px;
    height: 130px;
    overflow: hidden;
    img {
      object-fit: none;
      width: 1200px;
      height: 100%;
    }
  }
  .wrapper_1200 {
    margin: 0 auto;
  }
  .goods {
    width: 1200px;
    height: 340px;
    margin: auto;

    img {
      width: 100%;
      height: 100%;
    }
  }
  .coupon {
    margin-top: 20px;

    .main-section{
      ::v-deep.empty-box{
       padding-top: 0;
        padding-bottom: 60px;
      }
      background-color: #fff;
      .list {
        padding: 25px 40px 40px 40px;
        .item {
          width: 300px;
          height: 190px;
          margin: 0 40px 40px 0;
          // background: url("~assets/images/coupon-back1.png") center/cover no-repeat;
          box-shadow: 0 3px 20px rgba(0, 0, 0, 0.08);
          &:nth-child(3n){
            margin-right: 0;
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
            width: 100%;
            padding-left: 14px;
          }
          .text-cont {
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
            margin-top: 27px;
            font-size: 12px;
            height: 50px;
            color: #969696;
            display: flex;
            justify-content: space-between;
            align-items: center;

            .receive {
              width: 60px;
              height: 18px;
              text-align: center;
              margin-right: 15px;
              border-radius: 9px;
              border: 1px solid #FFFFFF;
            }
          }
          .content {
            width: 239px;
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
    }
  }
  ::v-deep .el-rate__item {
    width: 16px;
  }
  ::v-deep .el-tabs__nav {
    height: 60px;
    line-height: 60px;
    margin-left: 30px;
  }
</style>
