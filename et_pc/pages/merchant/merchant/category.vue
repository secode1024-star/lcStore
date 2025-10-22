<template>
  <div>
    <div class="wrapper_1200">
      <div class="user-wrapper">
        <div class="content clearfix acea-row">
          <div class="left-box">
            <div class="menu-collapse">
              <div class="menu-title cursors" :class="!searchForm.cid ? 'font-color' : ''" @click="goCategoryAll()">{{$t(`page.users.goodsCommentList.all`)}}</div>
              <div class="store-category" v-for="(item,index) in category" :key="index">
                <div class="cate-title">
                  <span v-if="item.childList" class="cate-btn"
                        @click="toggle(index)">{{ item === current ? '-' : '+' }}</span>
                  <span class="cate-name" :class="searchForm.cid == item.id ? 'font-color' : ''"
                        @click="goCategoryGoods(item,index)">{{ item.name }}{{item.checked}}</span>
                </div>
                <div class="cate-count" v-if="item.childList && index === current">
                  <div :class="searchForm.cid == itemn.id ? 'cate-item font-color' : 'cate-item'"
                       v-for="(itemn,indexn) in item.childList" :key="indexn"
                       @click="goCategoryGoods(itemn,'')">{{ itemn.name }}{{itemn.checked}}
                  </div>
                </div>
              </div>
            </div>
          </div>
          <NuxtChild keep-alive/>
          <div class="right-box">
            <div class="sort acea-row">
              <div class="acea-row">
                <div
                  class="items"
                  :class="iSdefaults === 1 ? 'font-color' : ''"
                  @click="set_where(1)"
                >
                  {{$t(`page.goodsList.default`)}}
                </div>
                <div
                  class="items acea-row"
                  :class="stock !== 0 ? 'font-color' : ''"
                  @click="set_where(3)"
                >
                  {{$t(`page.goodsList.sales`)}}
                  <img v-if="stock == 1" src="../../../assets/images/up.png" alt=""/>
                  <img v-else-if="stock == 2" src="../../../assets/images/down.png" alt=""/>
                  <img v-else src="../../../assets/images/horn.png" alt=""/>
                </div>
                <div
                  class="items acea-row"
                  :class="price !== 0 ? 'font-color' : ''"
                  @click="set_where(2)"
                >
                  <span>{{$t(`page.goodsList.price`)}}</span>
                  <img v-if="price == 1" src="../../../assets/images/up.png" alt=""/>
                  <img v-else-if="price == 2" src="../../../assets/images/down.png" alt=""/>
                  <img v-else src="../../../assets/images/horn.png" alt=""/>
                </div>
                <div class="item price-range">
                  <div class="price-count">
                    <el-input
                      class="input"
                      v-model.number="searchForm.minPrice"
                    ></el-input>
                    -
                    <el-input
                      class="input"
                      v-model.number="searchForm.maxPrice"
                    ></el-input>
                  </div>
                  <div class="action-box">
                    <span class="action-btn clear" @click="clearPrice">{{$t(`page.goodsAddcart.empty`)}}</span>
                    <span class="action-btn submit" @click="getProductList('')"
                    >{{$t(`page.goodsDetail.confirm`)}}</span
                    >
                  </div>
                </div>
              </div>
            </div>
            <div class="goods-list" v-loading="loading">
              <div class="list" v-if="productList.length > 0">
                <div class="brandshop">
                  <div class="store">
                    <goods-list :productList="productList" :picBox="picBox"></goods-list>
                  </div>
                </div>
              </div>
              <div class="noCart" v-if="!productList.length && !loading">
                <div class="pictrue"><img src="../../../assets/images/noCart.png"></div>
                <div class="tip">{{$t(`page.goodsList.empty`)}}</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <el-pagination
      v-if="total>0"
      background
      layout="prev, pager, next"
      :total="total"
      :pageSize="searchForm.limit"
      @current-change="bindPageCur"
    ></el-pagination>
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
  import {Debounce} from '@/utils/validate.js'
  import {followMer} from '@/utils/order.js';
  import product from "@/components/product";
  import goodsList from "@/components/goodsList";
  export default {
    name: "store",
    auth: false,
    components: {product, goodsList},
    data() {
      return {
        picBox: {
          width: '210',
          height: '210'
        },
        loading: false,
        search: '',
        current: 0,
        total: 0,
        productList: [],
        iSdefaults: 0,
        category: [], //店铺分类
        searchForm: {
          cid: null,
          page: 1, //代表页面的初始页数
          limit: 20,
          maxPrice: null,
          minPrice: null,
          merId: null,
          priceOrder: "",
          salesOrder: "",
          keyword: ''
        },
        stock: 0,
        price: 0,
      }
    },
    async asyncData({app, query}) {
      let [category] = await Promise.all([
        app.$axios.get(`/api/front/product/merchant/${query.id}/category/list`),
      ]);
      return {
        category: category.data,
        menuCur: query.type,
        cateId: query.cateId,
        merId: query.id,
        search: query.search
      };
    },
    watch: {
      "$route.query.search": function (nval, oldval) {
        this.search = nval
        this.getProductList();
      },
    },
    head() {
      return {
        title: this.$t(`page.store.classify`)
      }
    },
    created() {
      this.getProductList();
    },
    methods: {
      getProductList() {
        this.loading = true
        this.setWhere()
        this.searchForm.merId = this.merId
        this.searchForm.keyword = this.search;
        this.$axios
          .get(`/api/front/product/merchant/pro/list`, {
            params: this.searchForm,
          })
          .then(res => {
            this.total = res.data.total;
            this.productList = res.data.list;
            this.loading = false
          }).catch(error=>{
          this.loading = false
        })
      },
      goCategoryAll() {
        this.searchForm.cid = ''
        this.getProductList();
      },
      goCategoryGoods(item, index) {
        this.searchForm.cid = item.id
        if(index)this.current = index == this.current ? -1 : index;
        this.getProductList();
      },
      change(e) {
        this.$forceUpdate()
      },
      clearPrice() {
        this.searchForm.minPrice = "";
        this.searchForm.maxPrice = "";
      },
      /**
       * 分页点击
       * */
      bindPageCur(data) {
        this.searchForm.page = data;
        this.getProductList("");
      },
      toggle(index) {
        this.current = index == this.current ? -1 : index;
      },
      setWhere: function () {
        if (this.price == 0) this.searchForm.priceOrder = '';
        else if (this.price == 1) this.searchForm.priceOrder = 'asc';
        else if (this.price == 2) this.searchForm.priceOrder = 'desc';
        if (this.stock == 0) this.searchForm.salesOrder = '';
        else if (this.stock == 1) this.searchForm.salesOrder = 'asc';
        else if (this.stock == 2) this.searchForm.salesOrder = 'desc';
      },
      set_where(e) {
        switch (e) {
          case 1:
            this.iSdefaults = 1;
            this.price = 0;
            this.stock = 0;
            break;
          case 2:
            this.iSdefaults = 0;
            if (this.price == 0) this.price = 1;
            else if (this.price == 1) this.price = 2;
            else if (this.price == 2) this.price = 0;
            this.stock = 0;
            break;
          case 3:
            this.iSdefaults = 0;
            if (this.stock == 0) this.stock = 1;
            else if (this.stock == 1) this.stock = 2;
            else if (this.stock == 2) this.stock = 0;
            this.price = 0;
            break;
          default:
            break;
        }
        this.$set(this.searchForm, "page", 1);
        this.getProductList("");
      },
    }
  }
</script>
<style lang="scss" scoped>
  .trader_box {
    margin: 8px 0 16px 0;
  }

  .trader {
    display: inline-block;
    height: 24px;
    line-height: 24px;
    padding: 0 5px;
    text-align: center;
    color: #fff;
    background: #E93323;
    border-radius: 3px;
    margin-right: 3px;
    font-size: 12px;
  }

  .content {
    margin-top: 25px;
  }
  .store{
    padding: 15px;
    background: #fff;
  }

  .store-banner {
    width: 100%;
    height: 130px;
    overflow: hidden;
    min-width: 1200px;
    img {
      object-fit: none;
      width: 100%;
      height: 100%;
    }
  }

  .wrapper_1200 {
    margin: 0 auto;
  }

  .user-menu {
    position: relative;
    -webkit-justify-content: space-between;
    justify-content: space-between;
    padding: 0 10px;
    .category {
      position: absolute;
      top: 40px;
      left: 0;
      background-color: rgba(254, 248, 248, .96);
      width: 100%;
      padding: 40px 20px 20px;
      z-index: 10;
      .name {
        width: 130px;
        position: relative;
        padding-right: 20px;
        margin-right: 30px;
        cursor: pointer;
        .iconfont {
          font-size: 10px;
          position: absolute;
          right: 0;
          top: 3px;
          color: #282828;
        }
      }
      .sortCon {
        width: 1000px;
        .sub-item {
          margin: 0 15px 15px;
          color: #666666;
          cursor: pointer;
        }
      }
      .erSort {
        align-items: center;
      }
      .item {
        margin-bottom: 20px;
        align-items: baseline;
      }
      .moreBtn {
        color: #282828;
        font-size: 12px;
        width: 100px;
        height: 26px;
        line-height: 26px;
        text-align: center;
        border-radius: 13px;
        border: 1px solid #666666;
      }
    }

    .shop {
      width: 671px;
      height: 130px;
      background: #fff;
      position: absolute;
      bottom: 90px;
      left: 0;
      display: flex;
      padding: 15px 20px;
      margin-left: 25px;

      .shop-left {
        img {
          width: 100px;
          height: 100px;
          border-radius: 50%;
        }
      }

      .shop-right {
        margin-left: 20px;
        width: 510px;

        .title {
          display: flex;
          justify-content: space-between;

          .name {
            font-size: 24px;
            font-family: ArialMT;
            color: #333333;
            line-height: 24px;
          }

        }
        .tag {
          width: 78px;
          height: 24px;
          background: #E93323;
          border-radius: 3px;
          font-size: 12px;
          font-family: ArialMT;
          color: #FFFFFF;
          line-height: 12px;
          margin: 8px 0 16px 0;
          text-align: center;
          line-height: 24px;
          display: inline-block;
        }

        .shop-detail {
          display: flex;
          justify-content: space-between;
          font-size: 12px;
          font-family: ArialMT;
          color: #666666;
          line-height: 12px;

          .qualification {

            img {
              display: inline-block;
              margin-left: 5px;
            }
          }

          .seller {
            .iconfont {
              color: #E93323;
            }
          }
        }
      }
    }
    .menu-main {
      height: 40px;
      -webkit-justify-content: space-between;
      justify-content: space-between;
      .menu-item {
        display: inline-block;
        height: 26px;
        line-height: 26px;
        color: #333;
        padding: 0 15px;
        cursor: pointer;
        &.active {
          color: #E93323;
          border-radius: 15px;
        }
      }
    }
    .menu-search {
      width: 220px;
      // height: 24px;
      background-color: #fff;
      border-radius: 17px;

      .text {
        width: 175px;
      }

      input {
        width: 220px;
        position: relative;
        border: none;
        height: 24px;
        line-height: 24px;
        color: #999999;
        padding: 0 15px;
        border: 1px solid #CCCCCC;

        &:focus {
          border: none;
          outline: 1px solid #CCCCCC;
        }
      }

      .iconfont {
        position: absolute;
        top: 0;
        right: 18px;
        color: #999999;
      }
      .bnt {
        width: 44px;
        background-color: #282828;
        color: #fff;
        border-radius: 0 17px 17px 0;
        line-height: 24px;
        text-align: center;
        cursor: pointer;
      }
    }
  }

  .user-wrapper {
    width: 1200px;
    // height: 66px;
    margin: 0 auto;
    .left-box {
      width: 270px;
      // float: left;
      .user-info {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 370px;
        background: #fff;
        color: #282828;
        font-size: 14px;
        padding: 0 25px;
        .store-basis {
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: center;
          border-bottom: 1px dashed #ECECEC;
          height: 130px;
          .trader {
            display: inline-block;
            width: 32px;
            height: 18px;
            line-height: 18px;
            text-align: center;
            color: #fff;
            background: #E93323;
            border-radius: 2px;
            margin-right: 3px;
            font-size: 12px;
            font-family: 'PingFang SC';
          }
        }
        .store-logo {
          width: 61px;
          height: 61px;
          margin-bottom: 15px;
          img {
            width: 61px;
            height: 61px;
            border-radius: 50%;
          }
        }
        .name {
          margin-top: 10px;
          padding: 0 15px;
        }
      }
      .store-info {
        padding: 15px 0 0;
        position: relative;
        border-bottom: 1px dashed #ECECEC;
        .service {
          right: 210px;
          position: absolute;
          top: 0;
          .ewm {
            width: 140px;
            border: 1px solid #eeeeee;
            background-color: #fff;
            padding: 10px 15px;
            -webkit-justify-content: space-between;
            justify-content: space-between;
            align-items: center;
            color: #282828;
            .tip {
              font-size: 14px;
              color: #666666;
              margin-top: 10px;
              text-align: center;
            }
            .pictrue {
              vertical-align: middle;
              width: 116px;
              height: 116px;
              display: inline;
              img {
                width: 100%;
                height: 100%;
              }
              .iconfont {
                margin-bottom: 0;
                color: #282828;
              }
              .arrow {
                position: absolute;
                right: -15px;
                top: 23px;
                width: 0px;
                height: 0px;
                border: 8px solid transparent;
                border-left-color: #eee;
                &:before {
                  position: absolute;
                  left: -8px;
                  top: -7px;
                  content: "";
                  width: 0px;
                  height: 0px;
                  border: 7px solid transparent;
                  border-left-color: #fff;
                }
              }
            }
          }
        }
        .item {
          font-size: 12px;
          color: #7e7e7e;
          margin-bottom: 15px;
          .iconfont {
            cursor: pointer;
          }
          .icon-kefu {
            color: #E93323;
          }
          .cont {
            margin-left: 8px;
          }
          .star {
            font-size: 12px;
            color: #e6e6e6;
            ~ .star {
              margin-left: 5px;
            }
            &.on {
              color: #e93323;
            }
          }
          .title {
            color: #999999;
            font-size: 12px;
            margin-right: 15px;
          }
          .desc {
            color: #333333;
            position: relative;
          }
          .store_qualify {
            width: 16px;
            height: 16px;
            &:hover + .license {
              display: inline-block;
            }
          }
          .license {
            width: 90px;
            line-height: 26px;
            color: #fff;
            text-align: center;
            background: #282828;
            border-radius: 5px;
            position: absolute;
            top: 26px;
            left: -10px;
            display: none;
            &:before {
              content: '';
              display: inline-block;
              border: 3px solid transparent;
              border-bottom-color: #282828;
              position: absolute;
              top: -6px;
              left: 15px;
            }
          }
        }
      }
      .store-favorites {
        margin-top: 14px;
        .collection {
          width: 80px;
          height: 30px;
          line-height: 30px;
          text-align: center;
          color: #333333;
          border: 1px solid #C8C8C8;
          border-radius: 2px;
          background: #fff;
          &.care {
            color: #fff;
            background-color: #e93323;
            border-color: #e93323;
          }
        }
      }
      .menu-collapse {
        background: #fff;
        .menu-title {
          padding: 18px 12px;
          font-weight: bold;
          border-bottom: 1px solid #F2F2F2;
        }

        .store-category {
          line-height: 34px;
          color: #666;
          &:last-child {
            border-bottom: none;
          }
          .cate-title {
            padding: 0 12px;
            .cate-name {
              cursor: pointer;
            }
          }
          .cate-btn {
            cursor: pointer;
            display: inline-block;
            margin-right: 2px;
            width: 13px;
            height: 13px;
            background-color: #D2D2D2;
            border-radius: 2px;
            color: #fff;
            text-align: center;
            line-height: 13px;
          }
          .cate-count {
            padding: 0 40px;
            div {
              cursor: pointer;
            }
            .font-red {
              color: #e93323;
            }
          }
          .font-bold {
            font-weight: bold;
          }
        }

      }
    }
    .right-box {
      width: 915px;
      min-height: 730px;
      margin-left: 15px;
      padding-bottom: 30px;
      // float: right;
      .sort {
        background: #fff;
        height: 64px;
        align-items: center;
        padding: 18px 15px;
        .item {
          margin-right: 30px;
          cursor: pointer;
          &:hover {
            color: #E93323;
          }
          .icon {
            font-size: 15px;
            margin-left: 5px;
            color: #E2E2E2;
          }
          .iconfont {
            font-size: 15px;
            color: #E2E2E2;
            margin-left: 5px;
          }
        }
        .name {
          color: #969696;
          margin-right: 20px;
        }
      }
    }
  }

  .router-tips {
    height: 60px;
    line-height: 60px;
    font-size: 14px;
    a {
      color: #333;
    }
    span {
      color: #999999;
    }
  }

  .noGoods {
    text-align: center;
    .pictrue {
      width: 274px;
      height: 213px;
      margin: 130px auto 0 auto;
      img {
        width: 100%;
        height: 100%;
      }
    }
  }

  .banner {
    width: 1200px;
    height: 180px;
    margin: auto;
    // position: relative;

    img {
      width: 100%;
      height: 180px;
    }
  }

  .goods {
    width: 1200px;
    height: 340px;
    margin: auto;

    img {
      width: 100%;
      height: 100%;
    }
  }

  .goods-list {
    margin-top: 15px;
    ::v-deep .wrapper{
      width: auto !important;
    }
    ::v-deep .goods_item{
      margin: 0 15px 24px 0;
      &:nth-child(4n){
        margin-right: 0;
      }
    }

    .title {
      text-align: center;

      .name {
        font-size: 24px;
        font-family: Arial-BoldMT, Arial;
        font-weight: normal;
        color: #333333;
        line-height: 24px;
        margin-top: 40px;
        margin-bottom: 14px;
      }

      .text {
        font-size: 16px;
        font-family: ArialMT;
        color: #999999;
        line-height: 16px;
        margin-bottom: 34px;
      }
    }

    .list {

      .goods_item {
        display: inline-block;
        width: 284px;
        height: 390px;
        margin: 0 13px 15px 0;
        background: #FFFFFF;

        img {
          width: 244px;
          height: 244px;
          margin: 20px 20px 8px;
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
          margin-left: 15px;
          .price {
            font-size: 20px;
            font-family: DINCond-Black, DINCond;
            font-weight: 900;
            color: #E93323;
            line-height: 20px;
            margin-bottom: 9px;
          }
          .ot_price {
            font-size: 12px;
            font-family: DINPro-Regular, DINPro;
            font-weight: 400;
            color: #888888;
            line-height: 12px;
            text-decoration: line-through;
          }
        }
      }
    }
  }

  .noCart {
    text-align: center;
    margin-bottom: 70px;
    margin-top: 70px;
    .pictrue {
      width: 216px;
      height: 136px;
      margin: 0 auto;
      img {
        width: 100%;
        height: 100%;
      }
      .tip {
        margin-top: 12px;
        color: #646464;
      }
    }
  }

  .sort {
    .items {
      margin-right: 30px;
      position: relative;
      cursor: pointer;
      &:hover {
        color: #e93323;
      }
      img {
        width: 7px;
        height: 10px;
        margin-left: 5px;
        margin-top: 5px;
      }
      // .up {
      //   width: 15px;
      //   height: 18px;
      //   position: absolute;
      //   right: -25px;
      //   top: 5px;
      //   background: url('../../assets/images/up.png') no-repeat;
      //   background-size: 8px 10px;
      // }
      // .horn {
      //   width: 15px;
      //   height: 18px;
      //   position: absolute;
      //   right: -25px;
      //   top: 5px;
      //   background: url('../../assets/images/horn.png') no-repeat;
      //   background-size: 8px 10px;
      // }
      // .down {
      //   width: 15px;
      //   height: 18px;
      //   position: absolute;
      //   right: -25px;
      //   top: 5px;
      //   background: url('../../assets/images/down.png') no-repeat;
      //   background-size: 8px 10px;
      // }
      .icon {
        font-size: 15px;
        margin-left: 5px;
      }
      .iconfont {
        font-size: 15px;
        color: #e2e2e2;
        margin-left: 5px;
      }
    }
    .name {
      color: #969696;
      margin-right: 20px;
    }
  }

  .price-range {
    position: relative;
    top: -15px;
    padding: 10px;
    &:hover {
      box-shadow: 0px 3px 20px rgba(0, 0, 0, 0.08);
      .action-box {
        display: block;
      }
    }
    .action-box {
      display: none;
      position: absolute;
      left: 0;
      bottom: -50px;
      text-align: center;
      background: #f9f9f9;
      height: 50px;
      line-height: 50px;
      width: 100%;
      box-shadow: 0px 3px 20px rgba(0, 0, 0, 0.08);
      padding: 0 15px;
      overflow: hidden;
      .clear {
        float: left;
        color: #999999;
      }
      .submit {
        float: right;
        color: #666666;
        width: 60px;
        height: 30px;
        line-height: 30px;
        margin-top: 10px;
        background-color: #f1f1f1;
        border-radius: 2px;
        border: 1px solid #d4d4d4;
      }
    }
    .price-count {
      .input {
        width: 80px;
        height: 32px;
        position: relative;

        &:before {
          /*content: "$";*/
          display: inline-block;
          color: #d4d4d4;
          position: absolute;
          left: 5px;
          top: 0;
          line-height: 32px;
        }
        ::v-deep .el-input__inner {
          height: 32px;
          line-height: 32px;
          padding-left: 18px;
        }
      }
    }
  }

  ::v-deep .el-rate__item {
    width: 16px;
  }

  ::v-deep .el-input__inner {
    height: 32px;
    line-height: 32px;
    padding-left: 18px;
  }
</style>
