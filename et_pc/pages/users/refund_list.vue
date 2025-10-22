<template>
  <div class="user-order-list" v-loading="loading">
    <div v-if="orderList.length > 0">
      <div v-for="(itemn,index) in orderList" :key="itemn.id" class="order-list">
        <div class="bd">
          <div class="content" @click="goDetail(itemn)">
            <div v-for="(goods, index) in itemn.orderInfoList" :key="index">
              <div class="order-txt acea-row row-between">
                <div>
                  <span class="status">{{$t(`page.users.userReturnList.orderId`)}}：</span>
                  <span class="mer_name">{{itemn.refundOrderNo}}</span>
                </div>
                <div v-if="itemn.refundStatus==0 || itemn.refundStatus==2" class="font-color">
                  {{$t(`page.users.userReturnList.refunding`)}}
                </div>
                <div v-if="itemn.refundStatus==3" class="font-color">{{$t(`page.users.userReturnList.refunded`)}}</div>
                <div v-if="itemn.refundStatus==1" class="font-color">{{$t(`message.tips.noadopt`)}}</div>
              </div>
              <div class="goods-item">
                <div class="acea-row">
                  <div class="img-box">
                    <img :src='goods.image' alt="">
                  </div>
                  <div class="info-txt">
                    <div class="title line2">{{goods.productName}}</div>
                  </div>
                </div>
                <div class="info-price">
                  <div class="price">{{GLOBAL.shopPayCurrency}}{{ goods.price }}</div>
                  <div class="num">x{{ goods.payNum }}</div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="foot">
          <p>{{itemn.totalNum}} {{$t(`page.users.orderList.item`)}}，{{$t(`page.users.goodsReturn.price`)}}
            <span class="price">{{GLOBAL.shopPayCurrency}}{{itemn.refundPrice}} </span>
          </p>
          <div class="btn-wrapper">
            <div class='pay' @click='goDetail(itemn)'>{{$t(`page.users.orderList.viewDetails`)}}</div>
          </div>
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
    <div class="empty-box" v-if="orderList.length == 0 && !loading">
      <img src="~assets/images/noorder.png" alt="">
      <p>{{$t(`page.users.orderList.empty`)}}~</p>
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
    name: "refund_list",
    components: {orderGoods},
    data() {
      return {
        total: 0,
        page: 1,
        limit: 10,
        orderList: [],
        loading: false
      }
    },
    head() {
      return {
        title: this.$t(`page.users.userReturnList.navTitle`)
      }
    },
    beforeMount() {
      this.getOrderList();
    },
    methods: {
      bindPageCur(data) {
        this.page = data
        this.getOrderList();
      },
      // 查看详情
      goDetail(item) {
        this.$router.push({
          path: `/order/refund_detail`,
          query: {
            orderNo: item.refundOrderNo
          }
        })
      },
      getOrderList() {
        this.loading = true
        this.$axios.get('/api/front/order/refund/list', {
          params: {
            page: this.page,
            limit: this.limit
          }
        }).then(res => {
          this.orderList = res.data.list
          this.total = res.data.total
          this.loading = false
        }).catch(err => {
          this.loading = false;
        })
      }
    }
  }
</script>

<style scoped lang="scss">
  .user-order-list {
    width: 100%;
    height: 100%;
  }

  .order-list {
    background-color: #fff;
    padding: 30px 40px 0 40px;
    margin-bottom: 15px;
  }

  .user-order-list {
    width: 100%;
    min-height: 730px;
    li {
      position: relative;
      padding: 30px 0 26px;
      border-bottom: 1px solid #ECECEC;

    }
    .refund-icon {
      position: absolute;
      right: 50px;
      top: 40px;
    }
    .goods_item {

    }
    .bd {
      cursor: pointer;
      border-bottom: 1px dashed #E1E1E1;
      .order-txt {
        color: #333333;
        font-size: 14px;
        margin-bottom: 23px;
        .mer_name {
          display: inline-block;
          color: #333333;
          &:hover {
            color: #E93323;
          }
        }
        .status {
          color: #E93323;
        }
      }
      .content {
        .goods-item {
          display: flex;
          position: relative;
          margin-bottom: 20px;
          align-items: center;
          justify-content: space-between;
          .img-box {
            width: 120px;
            height: 120px;
            position: relative;
            span {
              display: block;
              width: 100%;
              text-align: center;
              font-size: 12px;
              line-height: 18px;
              background: rgba(0, 0, 0, .5);
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
          .info-price {
            text-align: right;
          }
          .info-txt {
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: center;
            width: 500px;
            margin-left: 30px;
            font-size: 14px;
            .title {
              color: #333;
            }
            .info {
              font-size: 12px;
              color: #aaa;
              margin-top: 4px;
            }
            .price {
              margin-top: 10px;
              color: #E93323;
            }

          }
          .develity_date {
            color: #FD6523;
            margin-top: 6px;
            font-size: 14px;
          }
          .price {
            color: #999999;
            margin-bottom: 6px;
          }
          .num {
            /*position: absolute;*/
            /*right: 0;*/
            /*top: 50%;*/
            transform: translateY(-50%);
            color: #999999;
          }
        }
      }
    }
    .foot {
      padding: 25px 0;
      p {
        text-align: right;
        color: #666;
        font-size: 14px;
        .price {
          color: #E93323;
        }
      }
      .btn-wrapper {
        display: flex;
        justify-content: flex-end;
        margin-top: 20px;
        div {
          width: 110px;
          height: 36px;
          text-align: center;
          line-height: 34px;
          margin-left: 20px;
          border: 1px solid #999999;
          border-radius: 4px;
          font-size: 14px;
          color: #666666;
          cursor: pointer;
          &.pay {
            border-color: #E93323;
            background: #E93323;
            color: #fff;
          }
        }
      }
    }
  }

  .pages-box {
    margin-top: 30px;
    text-align: right;
  }
</style>
