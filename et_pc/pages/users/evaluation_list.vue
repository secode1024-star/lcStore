<template>
  <div class="user-order-list" v-loading="loading">
    <div v-if="orderList.length > 0">
      <div v-for="(itemn,index) in orderList" :key="itemn.id" class="order-list">
        <div class="bd">
          <div class="content">
            <div class="order-txt" @click="goMerchant(itemn)">
              <span class="mr10 iconfont icon-shangjiadingdan"></span>
              <span class="mer_name">{{itemn.merName}}</span>
              <span class="iconfont icon-gengduo" style="font-size: 10px;"></span>
            </div>
            <div class="goods-item" @click="goDetail(itemn)">
              <div class="acea-row">
                <div class="img-box">
                  <img :src='itemn.image' alt="">
                </div>
                <div class="info-txt">
                  <div class="title line2">{{itemn.productName}}</div>
                  <div class="info" v-if="itemn.sku">{{ itemn.sku }}</div>
                </div>
              </div>
              <div class="info-price">
                <div class="price">{{GLOBAL.shopPayCurrency}} {{ itemn.price }}</div>
                <div class="num">x{{ itemn.payNum }}</div>
              </div>
            </div>
          </div>
        </div>
        <div class="foot">
          <div class="btn-wrapper">
            <div class='pay' @click='goEvaluation(itemn)'>{{$t(`page.users.orderList.evaluation`)}}</div>
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
      <p>{{$t(`message.tips.noEvaluation`)}}</p>
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
  import {goMerchant, goShopDetail} from "@/utils/order.js";

  export default {
    name: "evaluation_list",
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
    beforeMount() {
      this.getOrderList();
    },
    head() {
      return {
        title: this.$t(`page.users.replyList.navTitle`)
      }
    },
    methods: {
      goMerchant(item) {
        goMerchant(item.merId, this);
      },
      getOrderList() {
        this.loading = true
        this.$axios.get('/api/front/order/reply/list', {
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
      },
      bindPageCur(data) {
        this.page = data
        this.getOrderList();
      },
      goDetail(itemn) {
        goShopDetail(itemn.productId, this);
      },
      goEvaluation(itemn) {
        this.$store.commit('SET_EvaluationInfo', itemn);
        this.$router.push({
          path: `/users/evaluation_confirm`,
          query: {menuCur: 333}
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
      padding: 0 0 25px 0;
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
