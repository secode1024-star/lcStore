<template>
  <div class="wrapper">
    <div class="goods_item" v-for="item in productList" :key="item.id" @click="goDetail(item)">
      <div class="pic" :style="{width:picBox.width+ 'px',height:picBox.height+ 'px'}">
        <el-image :src="item.image">
          <div slot="placeholder" class="image-slot">
            loading<span class="dot">...</span>
          </div>
        </el-image>
      </div>
      <div class="goods_content">
        <div class="store_name lines2">
          {{item.storeName}}
        </div>
        <div class="acea-row row-between">
          <div class="price">{{GLOBAL.shopPayCurrency}}{{item.price}}</div>
          <div  v-if="item.sales" class="sold">{{ (Math.floor(item.sales) + Math.floor(item.ficti)) || 0 }} {{$t(`page.goodsDetail.sold`)}}</div>
          <div v-if="item.isFollow" @click="collect(item)" class="follow" :class="item.isFollow ? 'bg-color' : ''">
            <span class="iconfont" :class="item.isFollow ? 'icon-xihuan1' : 'icon-guanzhu'"></span>
          </div>
        </div>
        <div v-show="item.otPrice" class="ot_price">{{GLOBAL.shopPayCurrency}}{{item.otPrice}}</div>
      </div>
    </div>
  </div>
</template>
<script>
  import { followPro, goShopDetail } from '@/utils/order.js';
  export default {
    name: "goodsList",
    props: {
      productList:{
        type: Array,
        default: function() {
          return [];
        }
      },
      //商品列表商品图片的长宽
      picBox: {
        type: Object,
        default: function() {
          return null;
        }
      }
    },
    methods: {
      goDetail(item) {
        goShopDetail(item.productId || item.id, this);
      },
      /**
       *
       * 收藏 | 取消收藏
       */
      collect(item) {
        if (!this.$auth.loggedIn) {
          this.$store.commit("isLogin", true);
        }else {
          followPro(this, item.isFollow, item.productId).then(() => {
            this.$set(item, 'isFollow', !item.isFollow);
          });
        }
      },
    }
  };
</script>
<style lang="scss" scoped>
  .sold {
    font-size: 12px;
    color: #999999;
    margin-right: 15px;
  }
  .ot_price {
    font-size: 12px;
    font-weight: 400;
    color: #888888;
    line-height: 12px;
    display: flex;
    justify-content: space-between;
    margin-right: 20px;

    .lines {
      text-decoration: line-through;
    }
  }
  .icon-xihuan1{
    color: #fff;
  }
  .wrapper{
    width:975px;
    background-color: #fff;
    padding: 0 0 30px 0;
  }
  .goods_item {
    width: 210px;
    display: inline-block;
    margin: 0 23px 40px 0;
    cursor: pointer;
    .pic{
      width: 210px;
      height: 210px;
      .el-image {
        width: 100%;
        height: 100%;
      }
    }
    .goods_content {

      .store_name{
        height: 44px;
        margin: 7px 0 20px 0;
        font-size: 16px;
        font-family: ArialMT;
        color: #333333;
      }
      .lines2 {
        overflow: hidden;
        text-overflow: ellipsis;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
      }
    }

    .acea-row {
      .price {
        font-size: 18px;
        font-family: DINCond-Black, DINCond;
        font-weight: 900;
        color: #E93323;
        line-height: 20px;
        margin-bottom: 9px;
      }
      .follow{
        width: 25px;
        height: 25px;
        line-height: 25px;
        background: #F1F1F1;
        border-radius: 50%;
        cursor: pointer;
        .iconfont{
          margin: auto;
          margin-left: 5px;
          font-size: 14px;
        }
      }
    }
  }
</style>
