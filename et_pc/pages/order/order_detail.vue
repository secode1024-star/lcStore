<template>
  <div>
    <div class="order-detail wrapper_1200">
      <div class="header">
        <nuxt-link to="/">{{$t(`userDrawer.data[0].name`)}}></nuxt-link>
        <nuxt-link :to="{path:'/users/order_list',query:{menuCur:111}}">个人中心></nuxt-link>
        <span>{{$t(`page.orderDetails.navTitle`)}}</span>
      </div>
      <!--流程-->
      <div class="section process mb15">
        <div class="section-hd presell-hd">
          <div v-show="orderStatus===0" class='state'>{{$t(`page.user.orderStatus[0].name`)}}</div>
          <div class='state'>{{orderStatusFilter(orderInfo.status)}}</div>
        </div>
        <div class="stepsBox">
          <el-steps :active="activeStatus" align-center>
            <el-step :title="$t(`page.user.orderStatus[0].name`)">
              <i class="iconfont icon-daifukuan1" slot="icon"></i>
            </el-step>
            <el-step :title="$t(`page.user.orderStatus[1].name`)" >
              <i class="iconfont icon-daifahuo1" slot="icon"></i>
            </el-step>
            <el-step :title="$t(`page.user.orderStatus[2].name`)" >
              <i class="iconfont icon-daishouhuo1" slot="icon"></i>
            </el-step>
            <el-step :title="$t(`page.user.orderStatus[5].name`)" >
              <i class="iconfont icon-wancheng" slot="icon"></i>
            </el-step>
          </el-steps>
        </div>
      </div>
      <!--订单信息-->
      <div class="section mb15">
        <div class="section-hd">订单信息</div>
        <div class="section-bd">
          <ul>
            <li class="acea-row row-middle">
              <div>{{$t(`page.orderDetails.orderId`)}}：</div>
              <div>{{isGoodsReturn?orderInfo.merOrderNo:orderInfo.orderNo}}</div>
            </li>
            <li class="acea-row row-middle">
              <div>{{$t(`page.orderDetails.orderTime`)}}：</div>
              <div>{{ orderInfo.createTime }}</div>
            </li>
            <li v-if="orderInfo.refundTime" class="acea-row row-middle">
              <div>{{$t(`page.orderDetails.refundTime`)}}：</div>
              <div>{{ orderInfo.refundTime }}</div>
            </li>
            <li v-if="!isGoodsReturn" class="acea-row row-middle">
              <div>{{$t(`page.orderDetails.payStatus`)}}：</div>
              <div>{{orderInfo.paid?$t(`page.orderDetails.payTrue`):$t(`page.orderDetails.payFalse`)}}</div>
            </li>
            <li v-if="!isGoodsReturn" class="acea-row row-middle">
              <div>{{$t(`page.orderDetails.payType`)}}：</div>
              <div>{{orderInfo.payType}}</div>
            </li>
            <li v-if="orderInfo.userRemark" class="acea-row">
              <div>{{$t(`page.orderDetails.message`)}}：</div>
              <div>{{ orderInfo.userRemark }}</div>
            </li>
            <li v-if="!isGoodsReturn" class="acea-row row-middle">
              <div>{{$t(`page.orderDetails.actualPayment`)}}：</div>
              <div class="money">{{GLOBAL.shopPayCurrency}}{{orderInfo.payPrice}}</div>
            </li>
            <li v-else class="acea-row row-middle">
              <div>{{$t(`page.users.userReturnList.total`)}}：</div>
              <div class="money">{{GLOBAL.shopPayCurrency}}{{orderInfo.refundPrice}}</div>
            </li>
          </ul>
        </div>
      </div>
      <!--收货信息-->
      <div class="section mb15">
        <div class="section-hd">收货信息</div>
        <div class="section-bd">
          <ul>
            <li class="acea-row row-middle">
              <div>收货人：</div>
              <div>{{ orderInfo.realName }}</div>
            </li>
            <li class="acea-row row-middle">
              <div>联系电话：</div>
              <div>{{ orderInfo.userPhone }}</div>
            </li>
            <li class="acea-row">
              <div>收货地址：</div>
              <div>{{ orderInfo.userAddress }}</div>
            </li>
          </ul>
        </div>
      </div>
      <!--物流信息-->
      <div v-if="Number(orderInfo.status) > 0" class="section mb15">
        <el-collapse>
          <el-collapse-item :title="$t(`page.users.logistics.expName`) + '：' + expressInfo.expName + '     ' + $t(`page.users.logistics.expNo`)+'：'+expressInfo.expNo" name="1" :disabled="expressList.length===0">
            <div class='logisticsCon'>
              <div class='item' v-for="(item,index) in expressList" :key="index">
                <div class='iconfont icon-a-bianzu2 circular' :class='index === 0 ? "on":""'>
                </div>
                <div class='text' :class='index===0 ? "on-font on":""'>
                  <div>{{item.AcceptStation}}</div>
                  <div class='data' :class='index===0 ? "on-font on":""'>{{item.AcceptTime}}</div>
                </div>
              </div>
            </div>
          </el-collapse-item>
        </el-collapse>
      </div>
      <!--商品信息-->
      <div class="section orderInfo_pro">
        <template v-if="orderStatus===0">
          <div v-for="(item, index) in orderInfo.orderList" :key="item.id">
            <order-goods :cartInfo="item.orderInfoList" :orderInfo="item"></order-goods>
          </div>
        </template>
        <template v-else>
          <order-goods :cartInfo="cartInfo" :orderInfo="orderInfo"></order-goods>
        </template>
        <div class="line_box">
          <div class="lines"></div>
        </div>
        <div class="section-bd order_price">
          <ul class="cor666 p30">
            <li v-if="!isGoodsReturn" class="acea-row row-middle">
              <div>{{$t(`page.orderDetails.allPrice`)}}：</div>
              <div>
                {{GLOBAL.shopPayCurrency}}{{orderInfo.proTotalPrice}}
              </div>
            </li>
            <li v-if="orderInfo.couponId" class="acea-row row-middle coupon">
              <div>{{$t(`page.orderDetails.coupon`)}}：</div>
              <div>
                <span>-{{GLOBAL.shopPayCurrency}}{{orderInfo.couponPrice}}</span>
              </div>
            </li>
            <li class="acea-row row-middle coupon" v-if="orderInfo.payPostage > 0">
              <div>{{$t(`page.orderDetails.freight`)}}： </div>
              <div>
                <span>{{GLOBAL.shopPayCurrency}}{{orderInfo.payPostage}}</span>
              </div>
            </li>
          </ul>
          <ul class="total cor666">
            <li class="acea-row row-middle row-between">
              <div>
                {{orderInfo.totalNum}} {{$t(`page.users.orderList.item`)}}，{{$t(`page.users.orderList.totalPay`)}}：<span class="money"
              >{{GLOBAL.shopPayCurrency}}<b>{{orderInfo.payPrice}}</b></span
              >
              </div>
              <div class="footerState acea-row row-middle">
                <div class="orderBnt" v-if="orderInfo.paid === true && orderInfo.refundStatus === 0" @click="refund(orderInfo.orderNo)">
                  {{$t(`page.orderDetails.refund`)}}
                </div>
                <div
                  class="orderBnt"
                  v-if="!orderInfo.paid"
                  @click="cancelOrder(orderInfo.orderNo)"
                >
                  {{$t(`page.orderDetails.cancelOrder`)}}
                </div>
                <div
                  class="orderBnt"
                  :class="{
                  on: !orderInfo.paid
                }"
                  v-if="!orderInfo.paid"
                  @click="goPays(orderInfo)"
                >
                  {{$t(`page.orderDetails.nowPay`)}}
                </div>
                <div
                  class="orderBnt"
                  :class="{
                  on: orderInfo.status === 1
                }"
                  v-if="orderInfo.status==1"
                  @click="confirmOrder"
                >
                  {{$t(`page.orderDetails.confirm`)}}
                </div>
                <div
                  class="orderBnt"
                  v-if="orderInfo.status==3"
                  @click="delOrder(orderInfo.orderNo)"
                >
                  {{$t(`page.orderDetails.delete`)}}
                </div>
                <div class="orderBnt"
                     v-if="orderInfo.status==3 " @click="goOrderConfirm">
                  {{$t(`page.orderDetails.again`)}}
                </div>
              </div>
            </li>
          </ul>
        </div>
      </div>
    </div>
    <!-- 微信支付弹窗 -->
    <el-dialog
      :close-on-click-modal="false"
      :visible.sync="dialogVisibleQrcode"
      width="380px"
      :title="$t(`page.users.orderConfirm.payment`)"
      center
      :show-close="false"
      :before-close="handleCloseQrcode">
      <div  v-loading="loadingQrcode" class="payQrcode">
        <div id="payQrcode"></div>
      </div>
      <span slot="footer" class="dialog-footer">
          <el-button size="small" @click="handleCloseQrcode">{{$t(`page.users.orderConfirm.paymentResultsNo`)}}</el-button>
          <el-button size="small" type="primary" @click="getPaymentStatus">{{$t(`page.users.orderConfirm.paymentResults`)}}</el-button>
        </span>
    </el-dialog>
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
  // +----------------------------------------------------------------------
  import {Message, MessageBox} from "element-ui";
  import { goShopDetail, cancelOrders, delOrders, goPay } from '@/utils/order.js';
  import orderGoods from "@/components/orderGoods";
  import { Debounce } from '@/utils/validate.js'
  import QRcode from 'qrcodejs2';
  export default {
    auth: "guest",
    data() {
      return {
        activeStatus:1,
        expressInfo: {},
        isReturen: false,
        chatPopShow: false,
        isGoodsReturn: false, //是否为退款订单
        orderData: {},
        goodsNum: 0,
        refundNum: [],
        cartInfo: [],
        expressList: [],
        orderInfo: {},
        dialogVisibleQrcode: false, //微信支付弹窗
        loadingQrcode: false //微信支付弹窗加载
      };
    },
    components: { orderGoods },
    async asyncData({ app, query }) {
      return {
        orderStatus: Number(query.orderStatus),
        orderNo: query.orderNo,
      };
    },
    head() {
      return {
        title: this.$t(`page.orderDetails.navTitle`)
      }
    },
    beforeMount() {
      if(this.orderStatus===0 ){
        this.getOrderMasterInfo();
      }else{
        this.getOrderInfo();
        this.getExpress();
      }
    },
    methods: {
      /**  获取待支付订单详细信息，主订单 */
      getOrderMasterInfo() {
        this.$axios.get(`/api/front/order/master/detail/${this.orderNo}`).then(res => {
          this.orderInfo = res.data;
          this.cartInfo =  res.data.orderList;
          this.activeStatus = 1;
        }).catch(err => {
          that.loading = false;
        })
      },
      /**  获取待支付订单详细信息，分订单 state */
      getOrderInfo() {
        this.$axios.get(`/api/front/order/detail/${this.orderNo}`).then(res => {
          this.orderInfo = res.data
          this.cartInfo =  res.data.orderInfoList
          switch (res.data.status) {
            case 0:
              this.activeStatus = 2;
              break;
            case 1:
              this.activeStatus = 3;
              break;
            default:
              this.activeStatus = 4;
          }
        }).catch(err => {
          this.loading = false;
        })
      },
      orderStatusFilter(status) {
        const statusMap = {
          0: this.$t(`page.user.orderStatus[1].name`),
          1: this.$t(`page.user.orderStatus[2].name`),
          2: this.$t(`page.user.orderStatus[6].name`),
          3: this.$t(`page.user.orderStatus[5].name`)
        }
        return statusMap[status]
      },
      /**  申请退款 */
      refund: Debounce(function (orderNo) {
        this.$router.push({
          path: "/users/refund_confirm",
          query: {
            orderNo: orderNo
          }
        });
        }),
      chatShow(mer_id) {
        if(this.$auth.loggedIn){
          this.mer_id = mer_id;
          this.chatPopShow = true;
        }else{
          this.$store.commit("isLogin", true);
        }
      },
      //物流信息
      getExpress() {
        this.$axios.get(`/api/front/order/express/${this.orderNo}`).then(res => {
          this.expressInfo = res.data
          if(res.data && res.data.logisticsInfo){
            let express = JSON.parse(res.data.logisticsInfo);
            this.$set(this, 'expressList', express.reverse());
          }
        });
      },
      // 取消订单
      cancelOrder: Debounce(function (orderNo) {
          cancelOrders(this, orderNo).then(() => {
            this.$router.replace({path:'/users/order_list'});
          });
        }
      ),
      //去支付
      goPays: Debounce(function (item) {
        // 显示提示对话框，暂不支持线上支付
        this.$message({
          message: this.$t('pay.paymentDisabled'),
          type: 'warning',
          duration: 3000
        });
      }),
      //预览二维码
      getQRcode(redirect) {
        document.getElementById('payQrcode').innerHTML = '';
        new QRcode('payQrcode', { width: 135, height: 135, text: redirect });
        this.loadingQrcode = false;
      },
      //获取微信支付结果
      getPaymentStatus(){
        this.loadingQrcode = true;
        this.$axios.get(`/api/front/pay/query/wechat/pay/result/${this.orderNo}`).then(res => {
          this.handleCloseQrcode();
          this.loadingQrcode = false;
          this.$router.push({ path: '/users/order_list?orderStatus=0' });
        }).catch(err => {
          this.handleCloseQrcode();
          this.loadingQrcode = false;
          this.$router.push({ path: '/users/order_list?orderStatus=0' });
        })
      },
      //关闭微信支付弹窗
      handleCloseQrcode(){
        this.dialogVisibleQrcode = false;
      },
      //确认收货
      confirmOrder: Debounce(function () {
        MessageBox.confirm(
          this.$t(`page.orderDetails.confirmInfo`),
          this.$t(`page.orderDetails.confirm`)
        ).then(res => {
          this.$axios
            .post(`/api/front/order/take/${this.orderNo}`
            )
            .then(data => {
              Message.success(this.$t(`message.login.operationSU`));
              if(this.orderStatus===0){
                this.getOrderMasterInfo();
              }else{
                this.getOrderInfo();
              }
            });
        });
      }),
      //删除订单
      delOrder:Debounce(function(index, orderNo){
        this.settingIndex = index
        delOrders(this, orderNo).then(() => {
          this.$router.replace({path:'/users/order_list'});
        });
      }),
      //  再次购买
      goOrderConfirm: Debounce(function () {
        let storeCartListRequest = []
        this.cartInfo.map(item => {
          storeCartListRequest.push({
            productId: parseFloat(item.productId),
            productAttrUnique: item.attrValueId,
            cartNum: parseFloat(item.payNum)
          })
        })
        this.$axios.post('/api/front/cart/save',storeCartListRequest).then(res => {
         this.$router.replace({path:'/order/shopping_cart'});
        })
      }),
    }
  };
</script>
<style lang="scss" scoped>
  .payQrcode{
    margin: auto;
    width: 135px;
    height: 135px;
  }
  .p30{
    padding: 0 30px 24px 30px;
  }
  .line_box{
    border: none !important;
    padding: 0 30px;
    .lines{
      border-top: 2px dashed #cecece;
    }
  }
  .stepsBox{
    padding-bottom: 40px;
    border: none !important;
    ::v-deep.el-step__icon.is-text{
      border: none !important;
    }
    .iconfont{
      font-size: 30px;
    }
    ::v-deep.el-step__line{
      width: 220px;
      margin-left: 40px;
      /*border: 2px dashed #E93323;*/
      /*background: none;*/
      /*height: auto;*/
    }
  }
  .cor666{
    color: #666666 !important;
  }
  .logisticsCon{
    background-color: #FFFBFB;
    padding: 30px;
    .item .text.on {
      border-left-color: #f8c1bd;
    }
    .item .text.on-font {
      color: #333333;
    }
    .item .text {
      font-size: 14px;
      color: #999999;
      border-left: 1px solid #e6e6e6;
      padding: 0 0 60px 38px;
    }
    .item {
      padding: 0 40px;
      position: relative;
      .circular.on {
        color: #E93323;
      }
      .circular {
        position: absolute;
        top: -7px;
        left: 32px;
        color: #CCCCCC;

        .text.on-font {
          color: red;
        }
        .text .data.on-font {
          color: red;
        }
        .text {
          font-size: 26px;
          color: #666;
          width: 615px;
          border-left: 1px solid #e6e6e6;
          padding: 0 0 60px 38px;
        }
        .text.on {
          border-left-color: #f8c1bd;
        }
        .data {
          font-size: 24px;
          color: #999;
          margin-top: 1rpx;
          .time {
            margin-left: 15px;
          }
        }
      }
    }

  }
  .orderInfo_pro{
    ::v-deep .order > .list >.cartCount{
      margin-bottom: 0 !important;
    }
  }
  .section{
    ::v-deep.el-collapse, :v-deep.el-collapse-item__header{
      border: none !important;
      /*height: 60px;*/
      /*line-height: 60px;*/
    }
    ::v-deep.el-collapse-item__header.is-active ,::v-deep.el-collapse-item__wrap,::v-deep.el-collapse-item__header{
      padding: 0 30px;
      border: none;
    }
  }
  .order-detail {
    .header {
      color: #999999;
      font-size: 14px;
      background-color: unset;
      padding: 15px 0;
      .home {
        color: #282828;
      }
    }
    > div {
      background-color: #ffffff;
      .process {
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
                font-weight: bold;
                font-size: 22px;
                left: -3px;
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
      }
      > div {
        ~ div {
          border-top: 2px dashed #cecece;
        }
      }
      .presell-hd {
        div{
        }
      }

      &.reject {
        position: relative;
        padding: 30px 22px;
        background: #666666;
        overflow: hidden;
        margin-top: 0;
        .iconfont {
          position: absolute;
          top: -20px;
          right: 28px;
          font-size: 112px;
          color: #818181;
        }
        div {
          border-top: none;
          &.section-hd {
            padding: 0;
            font-weight: bold;
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
    .virtual_image{
      display: flex;
      align-items: center;
      img{
        width: 70px;
        height: 70px;
        border-radius: 4px;
      }
    }
    .delivery-hd{
      display: flex;
      justify-content: space-between;
      .morebtn{
        color: #236FE9;
        font-size: 16px;
      }
    }
    .delivery-info{
      display: flex;
      align-items: center;
      padding: 20px 22px;
      img{
        width: 40px;
        height: 40px;
      }
      .delivery-detail{
        margin-left: 20px;
        span{
          margin-right: 10px;
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
    .order_price{
      padding: 30px 0 !important;
      border: none !important;
    }
    .section-bd {
      padding: 30px;
      ul {
        font-size: 14px;
        color: #333;
        ~ ul {
          border-top: 2px dashed #cecece;
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
          font-size: 14px;
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
        padding: 30px 30px 0 30px;
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
              margin-left: 15px;
              ~ .orderBnt {
                &:last-child{
                  border-color:  #e93323;
                  background: #e93323;
                  color: #ffffff;
                }
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

  .operate_btn{
    display: flex;
    position: absolute;
    right: 0;
    color:  #B1B1B1;
    align-items: center;

  }
  .presell_process{
    margin-top: 20px;
    .process_count{
      background: #FFF8F7;
      padding: 21px 20px;
      >div{
        color: #282828;
        width: 60%;
      }
    }
    .mt10{
      margin-top: 10px;
    }

  }
  .evaluate_btn {
    margin-left: 15px;
  }
</style>
