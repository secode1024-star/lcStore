<template>
    <div :class="$nuxt.$route.path == '/merchant/merchant/category' ? 'wrapper': ''">
        <div @click="goDetail(item)" class="goods_item" :class="$nuxt.$route.path == '/' ? 'imgItem1': $nuxt.$route.path == '/merchant/merchant/home' ? 'imgItem2' : $nuxt.$route.path == '/merchant/merchant/category' ? 'imgItem3' : 'imgItem1'"  v-for="item in productList" :key="item.id">
          <el-image :src="item.image">
            <div slot="placeholder" class="image-slot">
              loading<span class="dot">...</span>
            </div>
          </el-image>
            <div class="goods_content">
            <div class="lines2" :class="$nuxt.$route.path == '/' ? 'store_name1':'store_name'">
              {{item.storeName}}
            </div>
            <div class="acea_row" :class="$nuxt.$route.path == '/' ? 'acea_row1' : ''">
              <div class="price">{{GLOBAL.shopPayCurrency}}{{item.price}}</div>
              <div v-if="$nuxt.$route.path == '/'" class="ot_price1">
                  <span class="sold" style="margin-right:15px">{{ (Math.floor(item.sales) + Math.floor(item.ficti)) || 0 }} {{$t(`page.goodsDetail.sold`)}}</span>
              </div>
              <div v-if="$nuxt.$route.path !== '/'" class="ot_price">
                  <span v-if="$nuxt.$route.path !== '/'" class="lines">{{GLOBAL.shopPayCurrency}}{{item.otPrice}}</span>
                  <span>{{ (Math.floor(item.sales) + Math.floor(item.ficti)) || 0 }} {{$t(`page.goodsDetail.sold`)}}</span>
              </div>
            </div>
          </div>
      </div>
    </div>
</template>
<script>
import { goShopDetail } from '@/utils/order.js';
export default {
  name: "product",
    props: {
        productList:{
            type: Array,
            default: function() {
                return [];
            }
        }
    },
    methods : {
      goDetail(item){
        goShopDetail(item.id, this);
      },
    }
};
</script>
<style lang="scss" scoped>
.wrapper {
  width: 915px;
  // padding-right: 15px;
}
      .goods_item {
        display: inline-block;
        margin: 0 13px 15px 0;
        background: #FFFFFF;
        cursor: pointer;

        .el-image {
          margin: 20px 20px 8px;
        }

        .goods_content {

          .store_name{
            height: 44px;
            margin: 0 22px 13px 15px;
            font-size: 16px;
            color: #333333;
            line-height: 22px;
          }
          .store_name1{
            height: 44px;
            margin: 0 22px 20px 15px;
            font-size: 16px;
            color: #333333;
            line-height: 22px;
          }
          .lines2 {
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box; 
            -webkit-line-clamp: 2; 
            -webkit-box-orient: vertical;
          }
        }

        .acea_row1 {
          display: flex;
        }
        .acea_row {
          margin-left: 15px;
          justify-content: space-between;

          .price {
            font-size: 20px;
            font-weight: 900;
            color: #E93323;
            line-height: 20px;
            margin-bottom: 9px;

            .sold {
              font-size: 12px;
              color: #999999;
              margin-right: 15px;
            }
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
          .ot_price1 {
            font-size: 12px;
            font-weight: 400;
            color: #999999;
            line-height: 29px;

            .lines {
                text-decoration: line-through;
            }
          }
        }
      }
      .imgItem1 {
        width: 228px;
        height: 330px;

        &:nth-child(5n) {
          margin-right: 0;
        }

        .el-image {
          width: 198px;
          height: 198px;
          margin: 15px;
        }
      }
      .imgItem2 {
        width: 284px;
        height: 390px;
        margin-right: 20px;

        &:nth-child(4n) {
          margin-right: 0;
        }

        .el-image {
          width: 244px;
          height: 244px;
        }
      }
      .imgItem3 {
        width: 225px;
        height: 355px;
        margin: 0;


        &:nth-child(4n) {
          width: 240px;
          padding-right: 15px;
        }

        .el-image {
          width: 210px;
          height: 210px;
          margin: 15px 0 8px 15px;
        }
      }
</style>
