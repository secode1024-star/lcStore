<template>
  <div class="collect">
    <div class="user-com-tab">
      <span class="item" :class="{on:tabCur == 0}" @click="tabCur= 0">{{$t(`page.user.goodsCollection`)}}</span>
      <span class="item" :class="{on:tabCur == 1}" @click="tabCur= 1">{{$t(`page.user.applicationRecord`)}}</span>
    </div>
    <div v-loading="loading">
      <div v-if="tabCur == 0 && list.length>0" class="collectStore" >
        <goods-list :productList="list" v-if="list.length>0" :picBox="picBox"></goods-list>
      </div>
      <ul v-if="tabCur == 1 && storeList.length>0" class="collectStore">
        <li v-for="(item,index) in storeList" :key="index">
          <div class="user-info">
            <div class="store-basis">
              <div class="store-logo">
                <img :src="item.merAvatar" alt="">
              </div>
              <div class="store-name line1">
                <span class="names line1">{{ item.merName }}</span>
              </div>
            </div>
            <div class="store-info"></div>
            <div class="store-favorites">
              <button class="store-btn toStore" @click="goStore(item.merId)">进店逛逛</button>
              <button class="store-btn collection" @click="bindDetele(item,index)">{{$t(`page.store.delFollow`)}}</button>
            </div>
          </div>
        </li>
      </ul>
      <div class="empty-box" v-if="total <= 0 && isShow">
        <img src="~assets/images/noEvaluate.png" alt="">
        <p>{{$t(`page.users.userGoodsCollection.empty`)}}~</p>
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
  import {Message} from 'element-ui';
  import goodsList from "@/components/goodsList";
  import { goMerchant } from '@/utils/order.js';
  import { Debounce } from '@/utils/validate.js'
  export default {
    name: "collect",
    auth: "guest",
    data(){
      return{
        tabCur: 0,
        list:[],
        storeList: [],
        page:1,
        limit:12,
        total: null,
        loading: false,
        isShow: false,
        //商品列表商品图片的长宽
        picBox: {
          width: '210',
          height: '210'
        },
      }
    },
    components: { goodsList },
    watch:{
      tabCur(nVal,oVal){
        this.page = 1;
        if(nVal == 1){
          this.getStoreList()
        }else{
          this.getGoodsList()
        }
      }
    },
    head() {
      return {
        title: this.$t(`page.users.userGoodsCollection.navTitle`)
      }
    },
    beforeMount(){
    },
    mounted() {
      this.getGoodsList()
    },
    methods:{
      /**
       *
       * 商品收藏
       */
      getGoodsList(){
        this.loading = true
        this.$axios.get('/api/front/collect/product/list',{
          params:{
            page:this.page,
            limit:this.limit
          }
        }).then(res=>{
          res.data.list.map(item => {
            this.$set(item, 'isFollow', true)
          })
          this.list = res.data.list
          this.total = res.data.total
          this.loading = false
          this.isShow = true
        }).catch(error=>{
          this.loading = false
        })
      },
      /**
       *
       * 店铺收藏
       */
      getStoreList(){
        this.loading = true
        this.$axios.get('/api/front/collect/merchant/list',{
          params:{
            page:this.page,
            limit:this.limit
          }
        }).then(res=>{
          this.storeList = res.data.list
          this.total = res.data.total
          this.isShow = true
          this.loading = false
        }).catch(error=>{
          this.loading = false
        })
      },
      /**
       *
       * 取消收藏店铺
       */
      bindDetele:Debounce(function(item, index) {
        this.$axios.post(`/api/front/collect/cancel/merchant/${item.merId}`).then(res=>{
          Message.success(this.$t(`message.login.calSU`))
          this.total = this.total - 1
          this.storeList.splice(index,1)
          this.isShow = true
        })
      }),
      /**
       *
       * 去详情
       */
      goPage(item) {
        goShopDetail(item.productId, this)
      },
      /**
       *
       * 去店铺
       */
      goStore(merId){
        goMerchant(merId, this)
      },
      bindPageCur(data){
        this.page = data
        if(this.tabCur == 1){
          this.getStoreList()
        }else{
          this.getGoodsList()
        }
      }
    }
  }
</script>

<style lang="scss" scoped>
  .collect{
    .collectProduct{
      li{
        padding: 30px 5px;
        border-bottom: 1px solid #E1E1E1;
        .hd{
          display: flex;
          padding-bottom: 30px;
          border-bottom: 1px dashed #E1E1E1;
          .img-box{
            width: 120px;
            height: 120px;
            img{
              width: 100%;
              height: 100%;
            }
          }
          .info{
            display: flex;
            align-items: center;
            margin-left: 25px;
            width: 60%;
          }
        }
        .bd{
          display: flex;
          justify-content: flex-end;
          padding-top: 25px;
          padding-right: 25px;
        }
      }
    }
  }
  .collectStore{
    overflow: hidden;
    margin-top: 15px;
    background-color: #fff;
    padding: 30px;
    li{
      float: left;
      border: 1px solid #EFEFEF;;
      width: 210px;
      margin: 0 20px 20px 0;
      &:nth-child(4n){
        margin-right: 0;
      }
    }
  }
  .user-info{
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    background: #fff;
    color: #282828;
    font-size: 14px;
    padding: 0 15px;
    .store-basis{
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      .trader{
        display: inline-block;
        width: 32px;
        height: 18px;
        line-height: 18px;
        text-align: center;
        color: #E93323;
        color: #fff;
        background: #E93323;
        border-radius: 2px;
        margin-right: 3px;
        font-size: 12px;
        font-family: 'PingFang SC';
      }
    }
    .store-logo{
      width: 61px;
      height: 61px;
      margin: 30px 0 15px;
      img{
        width: 61px;
        height: 61px;
        border-radius: 50%;
      }
    }
    .store-name{
      color: #333333;
      font-weight: bold;
      font-size: 16px;
      .names{
        max-width: 150px;
        display: inline-block;
        position: relative;
        top: 4px;
      }
    }
    .name{
      margin-top: 10px;
      padding: 0 15px;
    }
  }
  .store-info{
    padding: 15px 0 0;
    position: relative;
    border-bottom: 1px dashed #ECECEC;
    width: 100%;
    text-align: center;
    .item {
      font-size: 12px;
      color: #7e7e7e;
      margin-bottom: 15px;
      .iconfont{
        cursor: pointer;
      }
      .cont {
        margin-left: 8px;
      }
      .desc{
        color: #666666;
        font-size: 16px;
      }
    }
  }
  .store-favorites{
    margin: 9px 0;
    padding: 0 12px;
    overflow: hidden;
    width: 100%;
    position: relative;
    &:after{
      content: "";
      display: inline-block;
      width: 1px;
      height: 20px;
      background: #F3F3F3;
      position: absolute;
      top: 6px; right:50%;
    }
    .store-btn{
      height: 30px;
      line-height: 30px;
      text-align: center;
      color: #333333;
      border: none;
      background: #fff;
      font-size: 13px;
      color: #333333;
    }
    .toStore{
      float: left;

    }
    .collection{
      float: right;
    }
  }
  .pages-box{
    margin-top: 30px;
    text-align: right;
  }

</style>
