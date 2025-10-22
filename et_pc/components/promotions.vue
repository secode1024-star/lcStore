<template>
  <div class="wrapper">
    <div class="promotions">
      <div class="promotions-top" @click="gopage()">
          <span class="title">
            {{activityData.name}}
          </span>
        <span class="iconfont icon-gengduo more"></span>
      </div>
      <div class="promotions-top-goods" v-if="activityData.productList.length">
        <div class="itemOne" @click="
                  goDetail(item)
                " v-for="item in activityData.productList.slice(0,1)" :key="item.id">
          <div class="content">
            <div class="title">
              {{item.storeName}}
            </div>
            <div class="price">
              <div class="current-price">{{GLOBAL.shopPayCurrency}}{{item.price}}</div>
              <div class="original-price">{{GLOBAL.shopPayCurrency}}{{item.otPrice}}</div>
            </div>
          </div>
          <img :src="item.image" alt="">
        </div>
        <div class="itemTwo" @click="
                  goDetail(item)
                " v-for="item in activityData.productList.slice(1,3)" :key="item.id">
          <div class="title">
            {{item.storeName}}
          </div>
          <div class="content">
            <div class="price">
              <div class="current-price">{{GLOBAL.shopPayCurrency}}{{item.price}}</div>
              <div class="original-price">{{GLOBAL.shopPayCurrency}}{{item.otPrice}}</div>
            </div>
            <img :src="item.image" alt="">
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import {goShopDetail} from '@/utils/order.js';

  export default {
    name: 'promotion',
    props: {
      activityData: {
        type: Object,
        default: () => {
        }
      }
    },
    data() {
      return {
        tempArr: [],
        params: {
          page: 1,
          limit: 10,
        },
      }
    },
    methods: {
      gopage() {
        this.$router.push({
          path: "/goods/activity_list",
          query: {
            id: this.activityData.id,
            type: this.activityData.type,
            name: this.activityData.name
          }
        })
      },
      goDetail(item) {
        goShopDetail(item.proId, this);
      },
    }
  }
</script>
<style lang="scss" scoped>
  .promotions {
    width: 1200px;
    height: 334px;
    margin: auto;
    margin-bottom: 40px;

    .promotions-top {
      width: 100%;
      display: flex;
      justify-content: space-between;
      align-items: center;
      cursor: pointer;

      .title {
        font-size: 26px;
        text-align: center;
        margin: 28px 20px;
      }
      .more {
        font-size: 14px;
        text-align: center;
        float: right;
        color: #666;
        margin-right: 20px;
      }
    }
    .promotions-top-goods {
      display: flex;

      .itemOne {
        width: 562px;
        height: 240px;
        background: #fff url('../assets/images/promotions.png') no-repeat center center;
        display: flex;
        justify-content: space-between;
        margin-right: 15px;
        cursor: pointer;

        .content {
          width: 270px;
          margin: 28px 27px 50px 20px;

          .title {
            width: 270px;
            word-wrap: break-word;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            font-size: 18px;
            font-family: Arial-BoldMT, Arial;
            font-weight: normal;
            color: #282828;
            line-height: 24px;
          }
          .price {
            margin-top: 60px;

            .current-price {
              font-size: 22px;
              color: red;
              font-weight: 600;
            }

            .original-price {
              font-size: 14px;
              color: #999;
              text-decoration: line-through;
            }
          }
        }
        img {
          width: 240px;
          height: 240px;
          display: inline-block;
        }
      }
      .itemTwo {
        margin-right: 15px;
        cursor: pointer;

        .title {
          overflow: hidden;
          text-overflow: ellipsis;
          display: -webkit-box;
          -webkit-line-clamp: 1;
          -webkit-box-orient: vertical;
          margin: 28px 43px 35px 23px;
        }

        .content {
          display: flex;
          align-items: flex-start;
          padding: 0 0 0 23px;

          .price {
            margin-bottom: 22px;
            display: inline-block;

            .current-price {
              font-size: 22px;
              color: red;
              font-weight: 600;
            }

            .original-price {
              font-size: 14px;
              color: #999;
              text-decoration: line-through;
            }
          }
        }
        img {
          width: 130px;
          height: 130px;
          margin-left: 20px;
        }
      }
    }
  }
</style>
