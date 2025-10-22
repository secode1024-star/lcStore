<template>
  <div class="container">
    <div class="banner" v-if="this.list.length>0">
      <div class="slider-banner">
        <el-carousel indicator-position="none" height="370px">
          <el-carousel-item v-for="(item, index) in list" :key="index">
            <el-image class="img" :src="item">
              <div slot="placeholder" class="image-slot">
                loading<span class="dot">...</span>
              </div>
            </el-image>
            <div class="box"></div>
          </el-carousel-item>
        </el-carousel>
      </div>
    </div>
    <div v-loading="loading" class="recommend">
      <div class="ht_title">
        <h2>{{typeInfo.name}}</h2>
        <h3>{{typeInfo.instruction}}</h3>
      </div>
      <div class="recommend_list">
        <div class="best_details">
          <img src="../../assets/images/actAd.png" alt="">
        </div>
        <div class="goods_item cursors" @click="goDetail(item)" v-for="item in tempArr" :key="item.proId">
          <el-image class="img" :src="item.image">
            <div slot="placeholder" class="image-slot">
              loading<span class="dot">...</span>
            </div>
          </el-image>
          <div class="goods_content">
            <div class="store_name lines2">
              {{item.storeName}}
            </div>
            <div class="acea_row">
              <div class="price">{{GLOBAL.shopPayCurrency}}{{item.price}}</div>
              <div class="ot_price">{{GLOBAL.shopPayCurrency}}{{item.otPrice}}</div>
            </div>
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
  import {log} from 'util';

  export default {
    name: 'IndexPage',
    auth: false,
    data() {
      return {
        recommendList: [],
        tempArr: [],
        list: [],
        loading: false,
        typeInfo: {},
        page: 1,
        limit: 10,
        total: 0,
      }
    },
    async asyncData({app, query}) {
      return {
        type: query.type,
        id: query.id
      }
    },
    created() {
      this.getactivityList()
      this.getActivityDetail()
    },
    mounted() {
      this.$nextTick(() => {
        this.$nuxt.$loading.start()
        setTimeout(() => this.$nuxt.$loading.finish(), 1000)
      })
    },
    methods: {
      getActivityDetail() {
        this.$axios
          .get(`/api/pc/activity/detail/${this.id}`, {
            params: {
              type: this.type,
              aid: this.id
            }
          })
          .then(res => {
            this.typeInfo = res.data;
            if (res.data.banner) {
              this.list = JSON.parse(res.data.banner);
            }
          })
      },
      getactivityList() {
        this.loading = true;
        this.$axios
          .get(`/api/front/activity/list/${this.id}`, {
            params: {
              limit: this.limit,
              page: this.page
            }
          })
          .then(res => {
            this.tempArr = res.data.list;
            this.total = res.data.total;
            this.loading = false
          })
      },
      bindPageCur(data) {
        this.page = data
        this.getList()
      },
      goDetail(item) {
        goShopDetail(item.proId, this);
      },
    }
  }
</script>
<style lang="scss" scoped>
  .container {
    width: 100%;
    .banner {
      width: 1200px;
      height: 370px;
      margin: auto;

      .img {
        width: 1200px;
        height: 370px;
      }
    }
    .recommend {
      width: 1200px;
      margin: auto;

      .ht_title {
        margin: 60px 0 64px 0;
        text-align: center;

        h2 {
          font-size: 40px;
          font-family: Arial-BoldMT, Arial;
          font-weight: normal;
          color: #333333;
          line-height: 40px;
          margin-bottom: 20px;
        }

        h3 {
          font-size: 26px;
          font-family: ArialMT;
          color: #999999;
          line-height: 26px;
        }
      }

      .recommend_list {
        width: 1200px;
        overflow: hidden;
        display: flex;
        flex-wrap: wrap;

        .best_details {
          width: 471px;
          height: 330px;
          display: inline-block;
          margin-right: 15px;

          img {
            width: 471px;
            height: 330px;

          }
        }
        .goods_item {
          display: inline-block;
          width: 228px;
          height: 330px;
          margin: 0 15px 15px 0;
          background: #FFFFFF;

          &:nth-child(4) {
            margin-right: 0;
          }
          &:nth-child(5n+4) {
            margin-right: 0;
          }

          .img {
            width: 198px;
            height: 198px;
            margin: 15px 15px;
          }

          .goods_content {

            .store_name {
              height: 44px;
              margin: 0 22px 20px 15px;
              font-size: 16px;
              font-family: ArialMT;
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

          .acea_row {

            .price {
              font-size: 18px;
              font-family: DINCond-Black, DINCond;
              font-weight: 900;
              color: #E93323;
              line-height: 15px;
              margin-left: 15px;
              float: left;
            }
            .ot_price {
              font-size: 12px;
              font-family: ArialMT;
              color: #999999;
              line-height: 12px;
              float: right;
              margin-right: 12px;
              text-decoration: line-through;
            }
          }
        }
      }
    }
  }
</style>

