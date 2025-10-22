<template>
  <div class="container">
    <div class="top_one wrapper_1200">
      <span>{{$t(`page.index.topOne`)}}</span>
    </div>
    <div class="wrapper_1200 top">
      <img class="pic pic1" src="../../assets/images/top-list0.png" alt="">
      <img class="pic pic2" src="../../assets/images/top-list1.png" alt="">
      <img class="pic pic3" src="../../assets/images/top-list2.png" alt="">
      <div @click="goDetail(item)" class="item" v-for="(item, index) in toponeList" :key="index">
        <div class="left_box">
          <el-image class="img" :src="item.image">
            <div slot="placeholder" class="image-slot">
              loading<span class="dot">...</span>
            </div>
          </el-image>
        </div>
        <div class="right_box">
          <div class="title line4">
            {{item.storeName}}
          </div>
          <div class="num">
            <div class="price">{{GLOBAL.shopPayCurrency}}{{item.price}}</div>
            <div class="sale">{{ (Math.floor(item.sales) + Math.floor(item.ficti)) || 0 }}
              {{$t(`page.goodsDetail.sold`)}}
            </div>
          </div>
        </div>
      </div>
    </div>
    <FloatWindow></FloatWindow>
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
  import {goShopDetail} from '@/utils/order.js';

  export default {
    name: 'IndexPage',
    auth: false,
    data() {
      return {}
    },
    async asyncData({app, error}) {
      let toponeList = await app.$axios.get(
        "/api/front/product/leaderboard"
      );
      return {
        toponeList: toponeList.data
      };
    },
    methods: {
      goDetail(item) {
        goShopDetail(item.id, this);
      },
    }
  }
</script>
<style lang="scss" scoped>
  .container {
    background: url('../../assets/images/top_one_bg.png') no-repeat;
    background-size: 100%;
    .top_one {
      width: 1200px;
      display: flex;
      margin: 0 auto;

      span {
        font-size: 50px;
        font-weight: normal;
        color: #FFFFFF;
        margin: 66px auto 62px;
      }

    }
    .top {
      display: flex;
      justify-content: space-between;
      flex-wrap: wrap;
      position: relative;

      .pic {
        position: absolute;
        width: 46px;
        height: 56px;
        z-index: 99;
      }
      .pic1 {
        left: 10px;
      }
      .pic2 {
        left: 625px;
      }
      .pic3 {
        left: 10px;
        top: 290px
      }

      .item {
        width: 585px;
        height: 260px;
        display: flex;
        justify-content: space-between;
        margin-bottom: 30px;
        cursor: pointer;

        .left_box {
          width: 260px;
          height: 260px;

          .img {
            width: 260px;
            height: 260px;
          }
        }

        .right_box {
          width: 325px;
          height: 260px;
          background: #FFFFFF;
          border-radius: 1px;
          padding: 22px 21px 40px;

          .title {
            height: 96px;
            line-height: 24px;
          }

          .num {
            margin-top: 84px;
            display: flex;
            justify-content: space-between;

            .price {
              font-size: 24px;
              font-weight: 900;
              color: #E93323;
            }

            .sale {
              font-size: 16px;
              color: #999999;
            }
          }
        }
      }
    }

  }
</style>

