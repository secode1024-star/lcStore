<template>
  <div class="order">
    <div class="list">
      <div class="cartCount">
        <div v-if="orderInfo.merName" class="storeInfo acea-row" @click="goMerchant(orderInfo)">
          <span class="mr10 iconfont icon-shangjiadingdan"></span>
          <div class="name mr10">{{ orderInfo.merName }}</div>
          <span class="iconfont icon-gengduo" style="font-size: 10px;"></span>
        </div>
        <div class="cartInfo">
          <div class="item" v-for="(item, indexn) in cartInfo" :key="indexn">
            <div class="acea-row row-between-wrapper">
              <div class="txtPic acea-row row-middle">
                <div class="pictrue">
                  <img :src='item.image'>
                </div>
                <div class="text">
                  <div class="name line2">{{ item.productName ? item.productName : item.storeName }}</div>
                  <div class="info" v-if="item.sku">{{ item.sku }}</div>
                </div>
              </div>
              <div>
                <span class="font-color money">{{GLOBAL.shopPayCurrency}}{{ item.price }}</span>
                <span class="num">x{{ item.payNum }}</span>
                <!--<span class="font-color">{{ item.price }}</span>-->
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import { goMerchant, goShopDetail } from "@/utils/order.js";
    export default {
        name: "orderGoods",
      props: {
        cartInfo: {
          type: Array,
          default: function() {
            return [];
          }
        },
        orderInfo: {
          type: Object,
          default: function() {
            return {};
          }
        },
      },
      methods: {
        goMerchant(item) {
          goMerchant(item.merId, this);
        }
      }
    }
</script>

<style scoped lang="scss">
  .list{
    background-color: #fff;
  }
  .cartInfo {
    padding: 30px;
  }
  .cartCount{
    margin-bottom: 15px;
  }
  .storeInfo{
    width: 100%;
    height: 76px;
    line-height: 76px;
    padding: 0 30px;
    border-bottom: 2px dashed #CECECE;
    font-size: 16px;
    color: #333333;
    cursor: pointer;
  }
  .order {
    margin: 0 auto;

    .list {
      .item:last-child{
        margin-bottom: 0;
      }
      .item {
        margin-bottom: 24px;

        .txtPic {
          .pictrue {
            width: 70px;
            height: 70px;
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
              width: 100%;
              height: 100%;
            }
          }

          .text {
            max-width: 500px;
            margin-left: 20px;

            .name {
              width: 100%;
              color: #333;
              font-size: 14px;
            }

            .info {
              margin-top: 10px;
              color: #999999;
            }
            .err-txt{
              margin-top: 12px;
              color: #E93323;
              align-items: center;
              .txt{
                display: inline-block;
              }
              .icon-tishi{
                position: relative;
                top: 1px;
              }
            }
          }
        }
        .ship_date{
          margin-top: 10px;
          color: #FD6523;
        }

        .font-color {
          font-size: 16px;
          font-weight: bold;
          display: inline-block;
          text-align: right;
        }

        .money {
          font-size: 16px;
        }

        .num {
          margin-left: 6px;
        }
      }
    }

  }
</style>
