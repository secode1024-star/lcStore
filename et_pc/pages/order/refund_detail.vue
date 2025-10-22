<template>
  <div class="order-detail wrapper_1200">
    <div class="header">
      <nuxt-link to="/">{{$t(`userDrawer.data[0].name`)}}></nuxt-link>
      <nuxt-link :to="{path:'/users',query:{type:0}}">个人中心></nuxt-link>
      <span>{{$t(`page.users.goodsReturn.detal`)}}</span>
    </div>
    <div class="section reject">
      <div class="section-hd">{{refundStatusFilter(orderInfo.refundStatus)}}</div>
      <div class="con">
        {{orderInfo.refundStatus==0 ? $t(`page.users.userReturnList.examineInfo`): orderInfo.refundStatus==1? $t(`page.users.userReturnList.refuseReason`) + orderInfo.refundReason : $t(`page.users.userReturnList.refuseReason2`)}}
      </div>
    </div>
    <div class="section">
      <div class="section-hd">{{$t(`page.users.goodsReturn.information`)}}</div>
      <div class="section-bd">
        <ul>
          <li class="acea-row row-middle">
            <div>{{$t(`page.users.userReturnList.orderId`)}}：</div>
            <div>{{ orderInfo.refundOrderNo }}</div>
          </li>
          <li class="acea-row row-middle">
            <div>{{$t(`page.orderDetails.orderId`)}}：</div>
            <div>{{ orderInfo.merOrderNo }}</div>
          </li>
          <li class="acea-row row-middle">
            <div>{{$t(`page.users.userReturnList.total`)}}：</div>
            <div>{{ orderInfo.refundPrice }}</div>
          </li>
          <li class="acea-row row-middle">
            <div>{{$t(`page.users.goodsReturn.number`)}}：</div>
            <div>{{ orderInfo.totalNum }}</div>
          </li>
          <li class="acea-row row-middle">
            <div>{{$t(`page.orderDetails.orderTime`)}}：</div>
            <div>{{ orderInfo.createTime }}</div>
          </li>
          <li v-if="orderInfo.refundReasonWap" class="acea-row">
            <div>{{$t(`page.orderDetails.returnReason`)}}：</div>
            <div>{{ orderInfo.refundReasonWap }}</div>
          </li>
          <li v-if="orderInfo.refundReasonWapExplain" class="acea-row">
            <div>{{$t(`page.orderDetails.returnMsg`)}}：</div>
            <div>{{ orderInfo.refundReasonWapExplain }}</div>
          </li>
          <li v-if="orderInfo.refundReasonWapImg.length>0" class="acea-row">
            <div>{{$t(`page.orderDetails.returnImg`)}}：</div>
            <div v-for="(itemn, indexn) in refundReasonWapImg" :key="indexn" class="mr10">
                <el-image
                style="width: 100px; height: 100px"
                :src="itemn"
                :preview-src-list="refundReasonWapImg">
              </el-image>
            </div>
          </li>
        </ul>
      </div>
    </div>
    <div class="section">
      <order-goods :cartInfo="cartInfo" :orderInfo="orderInfo"></order-goods>
    </div>
    <div class="section-bd">
      <ul class="cor666">
        <li class="acea-row row-middle">
          <div>{{$t(`page.users.userReturnList.total`)}}：</div>
          <div class="font-color">
            {{GLOBAL.shopPayCurrency}}{{orderInfo.refundPrice}}
          </div>
        </li>
      </ul>
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
  import orderGoods from "@/components/orderGoods";
    export default {
        name: "refund_detail",
      components: { orderGoods },
      async asyncData({ app, query }) {
        let [ orderData ] = await Promise.all([
          app.$axios.get(`/api/front/order/refund/detail/${query.orderNo}`)
        ]);
        return {
          orderInfo: orderData.data,
          cartInfo: orderData.data.orderInfoList,
          refundReasonWapImg: orderData.data.refundReasonWapImg ? orderData.data.refundReasonWapImg.split(',') : []
        };
      },
      head() {
        return {
          title: this.$t(`page.users.goodsReturn.detal`)
        }
      },
      methods: {
        refundStatusFilter(status) {
          const statusMap = {
            0: this.$t(`message.tips.stay`),
            1: this.$t(`message.tips.noadopt`),
            2: this.$t(`page.users.userReturnList.refunding`),
            3: this.$t(`page.users.userReturnList.refunded`)
          }
          return statusMap[status]
        },
      }
    }
</script>

<style lang="scss" scoped>
  .con{
    font-size: 14px;
    color: #fff;
    margin-top: 16px;
  }
  .order-detail {
    .header {
      height: 60px;
      line-height: 60px;
      color: #999999;
      background-color: unset;
      .home {
        color: #282828;
      }
    }

    > div {
      background-color: #ffffff;

      &.order-number {
        li {
          div {
            &:nth-child(2) {
              flex: none;
            }
          }

          a {
            margin-left: 30px;
            font-size: 16px;
            color: #236fe9;

            .iconfont {
              font-size: 12px;
            }
          }
        }
      }

      ~ div {
        margin-top: 14px;
      }

      > div {
        ~ div {
          border-top: 1px dashed #cecece;
        }
      }

      &.process {
        margin-top: 0;
        div {
          border-top: none;

          &.section-hd {
            padding: 26px 22px 0;
          }

          ul {
            padding: 27px 0 94px;

            &::after {
              content: "";
              display: block;
              height: 0;
              clear: both;
              visibility: hidden;
            }
          }
          li {
            position: relative;
            float: left;
            margin-top: 0;
            margin-left: 222px;
            &:first-child {
              margin-left: 111px;
            }
            .line {
              position: absolute;
              top: 50%;
              left: 16px;
              width: 226px;
              height: 4px;
              background: #c7c7c7;
              transform: translateY(-50%);
            }
            .iconfont {
              position: relative;
              width: auto;
              font-size: 18px;
              line-height: 1;
              color: #c7c7c7;
              + .iconfont {
                position: absolute;
                top: 50%;
                left: 50%;
                display: none;
                width: 40px;
                height: 40px;
                border: 4px solid #e93323;
                border-radius: 50%;
                background: #ffffff;
                transform: translate(-50%, -50%);
                font-size: 20px;
                line-height: 32px;
                text-align: center;
                color: #e93323;
              }
            }
            .arrow {
              position: absolute;
              top: 50%;
              left: 100%;
              display: none;
              width: 80px;
              height: 16px;
              background: #e93323;
              transform: translateY(-50%);
              &::after {
                content: "";
                position: absolute;
                top: 0;
                left: 100%;
                border-width: 8px;
                border-style: solid;
                border-color: transparent transparent transparent #e93323;
              }
            }
            .info {
              position: absolute;
              top: 42px;
              left: 50%;
              transform: translateX(-50%);
              font-size: 14px;
              text-align: center;
              color: #9a9a9a;
              width: 100px;
              div {
                &:first-child {
                  margin-bottom: 4px;
                  font-size: 16px;
                  color: #282828;
                }
              }
            }
            &.past {
              .line {
                background: rgba(233, 51, 35, 0.6);
              }
              .iconfont {
                color: #e93323;
              }
            }
            &.now {
              .info {
                div {
                  &:first-child {
                    color: #e93323;
                  }
                }
              }

              .iconfont {
                + .iconfont {
                  display: block;
                }
              }

              .arrow {
                display: block;
              }
            }
          }
        }
      }

      &.reject {
        position: relative;
        padding: 30px;
        background: #666666;
        overflow: hidden;
        margin-top: 0;

        .iconfont {
          position: absolute;
          top: -20px;
          right: 28px;
          font-size: 72px;
          color: #818181;
          opacity: .6;
        }
        .red-color{
          color: #E93323;
          opacity: .6;
        }
        div {
          border-top: none;

          &.section-hd {
            padding: 0;
            color: #ffffff;
          }

          ul {
            padding: 0;
            margin-top: 8px;
            font-size: 14px;
            color: #ffffff;
          }
        }
      }

      &.reason {
        padding: 26px 22px;

        div {
          border-top: none;

          &.section-hd {
            padding: 0;
            .iconfont {
              margin-right: 8px;
            }
          }

          ul {
            padding: 0;
            margin-top: 15px;
            color: #7e7e7e;
          }
        }
      }
    }
    .section-hd {
      padding: 20px 30px;
      font-size: 16px;
      color: #666666;
      position: relative;
      .qrcode{
        box-shadow: 0px 3px 16px rgba(0, 0, 0, 0.08);
        background: #fff;
        position: absolute;
        right: 0;
        top: 30px;
        z-index: 10;
        display: none;
        padding: 6px;
        img{
          width: 100%;
          display: block !important;
        }
      }

      .orderBnt{
        color: #E93323;
        font-size: 18px;
        position: absolute;
        right: 20px;
        top: 20px;
        cursor: pointer;
        &:hover{
          .qrcode{
            display: block;
          }
        }
        .iconfont{
          font-size: 20px;
        }
      }
    }
    .red-txt{
      color: #E93323;
      line-height: 50px;
      padding: 0 22px;
    }
    .section-bd {
      ul {
        padding: 30px;
        font-size: 14px;
        color: #333;
        ~ ul {
          border-top: 1px dashed #cecece;
        }
      }
      li {
        .time {
          margin-left: 10px;
        }
        ~ li {
          margin-top: 20px;
        }


        &.coupon {
          span {
            ~ span {
              margin-left: 18px;
            }
          }
        }
      }
      .money {
        color: #e93323;
        b {
          font-weight: normal;
          font-size: 22px;
        }
      }
      .goods {
        .info {
          font-size: 12px;
          color: #aaa;
          margin-top: 4px;
        }
        li {
          position: relative;
          ~ li {
            margin-top: 22px;
          }
          > div {
            .img-box {
              width: 86px;
              height: 86px;
              overflow: hidden;
              margin-right: 26px;
              position: relative;
              span {
                display: block;
                width: 100%;
                text-align: center;
                font-size: 12px;
                line-height: 18px;
                background: rgba(0,0,0,.5);
                position: absolute;
                left: 0;
                bottom: 0;
                color: #fff;
              }
              img {
                display: block;
                width: 100%;
                height: 100%;
              }
            }
            del {
              margin-left: 12px;
              font-size: 14px;
              color: #919191;
            }

          }
          .money_count{
            margin-top: 4px;
            color: #b1b1b1;
          }
          .store-box{
            width: 700px;
            .name{
              max-width: 500px;
            }
          }
          .presell_num{
            color: #b1b1b1;
          }
        }
        .develity_date{
          color: #FD6523;
          font-size: 12px;
        }
      }
      .total {
        padding: 28px 22px;
        .footerState {
          cursor: pointer;
        }
        .service {
          width: 114px;
          height: 40px;
          margin-left: 18px;
          background: #e93323;
          color: #fff;
          font-size: 16px;
          text-align: center;
          line-height: 40px;
          cursor: pointer;
        }
        div {
          &:first-child {
            width: auto;
          }
          &:last-child {
            flex: none;
            div {
              padding-right: 30px;
              padding-left: 30px;
              ~ div {
                border-left: 1px solid #cecece;
              }
            }
            .orderBnt {
              height: 36px;
              background: #FFFFFF;
              border-radius: 4px;
              border: 1px solid #999999;
              padding: 0 20px;
              background: none;
              outline: none;
              font-size: 14px;
              line-height: 36px;
              text-align: center;
              color: #666666;
              cursor: pointer;
              ~ .orderBnt {
                margin-left: 18px;
              }
              &.on {
                border-color:  #e93323;
                background: #e93323;
                color: #ffffff;

              }
            }
          }
        }
      }
    }
  }
  .evaluate_btn {
    margin-left: 15px;
  }
</style>
