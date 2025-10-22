<template>
  <div>
    <div class="goodsSearch wrapper_1200">
      <div class="title">
        <span class="home" @click="goHome">{{$t(`page.store.index`)}} > </span>{{ searchVal }}
      </div>
      <div class="head" v-if="storeList.length">
        <div class="item" v-for="item in storeList.slice(0, 2)" :key="item.id">
          <div class="left_wrapper">
            <div class="logo">
              <el-image class="img" :src="item.avatar">
                <div slot="placeholder" class="image-slot">
                  loading<span class="dot">...</span>
                </div>
              </el-image>
            </div>
            <div class="con_box">
              <div class="name">
                {{ item.name }}
              </div>
              <div class="start_box">
                <el-rate
                  v-model="item.starLevel"
                  disabled
                  :colors="colors"
                  text-color="#E93323"
                  style="display:inline-block"
                ></el-rate>
              </div>
            </div>
          </div>
          <div class="right_wrapper" @click="goPage(item)">
            <span class="iconfont icon-shangjiadingdan"></span>
            <span class="name">{{$t(`page.goodsSearch.mer`)}}</span>
          </div>
        </div>
        <nuxt-link
          :to="{ path: '/merchant/merchant_more', query: { title: searchVal } }"
          class="moreBtn"
        >
          <span class="iconfont icon-gengduo"></span>
        </nuxt-link>
      </div>
      <div class="wrapper sort-count">
        <div class="sort acea-row">
          <div class="name">{{$t(`page.goodsSearch.sort`)}}：</div>
          <div class="acea-row">
            <div
              class="items"
              :class="iSdefaults === 1 ? 'font-color' : ''"
              @click="set_where(1)"
            >{{$t(`page.goodsSearch.Default`)}}
            </div>
            <div
              class="items acea-row"
              :class="stock !== 0 ? 'font-color' : ''"
              @click="set_where(3)"
            >{{$t(`page.goodsSearch.Seller`)}}
              <img v-if="stock == 1" src="../../assets/images/up.png" alt=""/>
              <img v-else-if="stock == 2" src="../../assets/images/down.png" alt=""/>
              <img v-else src="../../assets/images/horn.png" alt=""/>
            </div>
            <div
              class="items acea-row"
              :class="price !== 0 ? 'font-color' : ''"
              @click="set_where(2)"
            >
              <span>{{$t(`page.goodsSearch.Price`)}}</span>
              <img v-if="price == 1" src="../../assets/images/up.png" alt=""/>
              <img v-else-if="price == 2" src="../../assets/images/down.png" alt=""/>
              <img v-else src="../../assets/images/horn.png" alt=""/>
            </div>
            <div class="items price-range">
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
                <span class="action-btn submit" @click="getSearchList('')"
                >{{$t(`page.goodsDetail.confirm`)}}</span
                >
              </div>
            </div>
          </div>
        </div>
      </div>

      <div v-loading="loading" class="list acea-row row-middle" v-if="searchList.length">
        <div
          class="goods_item cursors"
          v-for="item in searchList"
          :key="item.id"
          @click="goDetail(item.id)"
        >
          <el-image class="img" :src="item.image">
            <div slot="placeholder" class="image-slot">
              loading<span class="dot">...</span>
            </div>
          </el-image>
          <div class="goods_content">
            <div class="store_name lines2">
              {{ item.storeName }}
            </div>
            <div class="acea_row">
              <div class="price">{{GLOBAL.shopPayCurrency}}{{ item.price }}</div>
              <div class="ot_price">{{ (Math.floor(item.sales) + Math.floor(item.ficti)) || 0 }}
                {{$t(`message.tips.sold`)}}
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class='loadingicon acea-row row-center-wrapper' v-if="searchList.length && searchList.length>=limit">
        <span class='loading iconfont icon-jiazai' v-if="!pullRefreshss"></span>{{title}}
      </div>
      <div class="noCart" v-if="!searchList.length && noProduct">
        <div class="pictrue"><img src="../../assets/images/noCart.png"/></div>
        <div class="tip">{{$t(`page.goodsSearch.searchGoods`)}}</div>
      </div>
      <div class="pages-box" v-if="total > 0">
        <el-pagination
          v-if="searchList.length && searchList.length > 0"
          background
          layout="prev, pager, next"
          :total="total"
          :pageSize="limit"
          @current-change="bindPageCur"
        ></el-pagination>
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
  import {Message, MessageBox} from "element-ui";
  import {Promise} from 'q';

  export default {
    name: "goods_search",
    auth: false,
    components: {
      // hotGoods
    },
    data() {
      return {
        searchVal: "",
        starLevel: "",
        loading: false,
        noProduct: false,
        searchList: [],
        storeList: [],
        price_on: "",
        price_off: "",
        page: 1, //代表页面的初始页数
        limit: 20,
        scollY: null, // 离底部距离有多少
        total: 0, //总页数
        pageTotal: 50, //总页数
        colors: ["#99A9BF", "#E93323", "#E93323"],
        iSdefaults: 1,
        news: 0,
        priceOrder: "",
        salesOrder: "",
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
      };
    },
    head() {
      return {
        title: "商品搜索",
      };
    },
    created() {
      this.searchVal = this.$route.query.title;
      this.searchForm.cid = this.$route.query.cid;
      this.getSearchList();
      this.getStoreList();
    },
    mounted() {
      this.$nextTick(() => {
        this.$nuxt.$loading.start();
        setTimeout(() => this.$nuxt.$loading.finish(), 1000);
      })
    },
    beforeDestroy() {
      window.onscroll = null;
    },
    watch: {
      "$route.query.title": function (nval, oldval) {
        this.searchVal = nval;
        this.getSearchList();
        this.getStoreList();
      },
      "$route.query.cid": function (nval, oldval) {
        this.searchForm.cid = nval;
        this.getSearchList();
        this.getStoreList();
      },
    },
    methods: {
      goHome() {
        this.$router.push({path: "/"});
      },
      gopage() {
        this.$router.push({
          path: `/merchant/merchant_more`,
          query: {
            title: this.searchVal,
          },
        });
      },
      goPage(item) {
        this.$router.push({
          path: `/merchant/merchant/home`,
          query: {
            id: item.id,
          },
        });
      },
      goDetail: function (id) {
        this.$router.push({path: `/goods_detail/${id}`});
      },
      search() {
        if (this.searchVal.trim() !== "") {
          this.searchList = [];
          this.storeList = [];
          this.page = 1;
          this.getSearchList();
          this.getStoreList();
        } else {
          this.$message.error("请输入要搜索的内容");
        }
      },
      setWhere: function () {
        if (this.price == 0) this.searchForm.priceOrder = '';
        else if (this.price == 1) this.searchForm.priceOrder = 'asc';
        else if (this.price == 2) this.searchForm.priceOrder = 'desc';
        if (this.stock == 0) this.searchForm.salesOrder = '';
        else if (this.stock == 1) this.searchForm.salesOrder = 'asc';
        else if (this.stock == 2) this.searchForm.salesOrder = 'desc';
      },
      getSearchList() {
        let that = this;
        that.setWhere();
        this.searchForm.keyword = this.searchVal,
          this.searchForm.page = this.page,
          this.loading = true;
        this.$axios
          .get("/api/front/product/list", {
            params: this.searchForm,
          })
          .then((res) => {
            this.searchList = res.data.list;
            this.noProduct = res.data.list.length ? false : true;
            this.loading = false;
            this.total = res.data.total;
          });
      },
      getStoreList() {
        let _this = this;
        _this.$axios
          .get("api/front/merchant/search/list", {
            params: {
              keywords: _this.searchVal,
              page: this.page,
              limit: 20,
            },
          })
          .then(function (res) {
            _this.pageTotal = res.data.count;
            _this.storeList = res.data.list;
          })
          .catch(function (err) {
          });
      },
      /**
       * 分页点击
       * */
      bindPageCur(data) {
        this.page = data;
        this.getSearchList("");
      },
      clearPrice() {
        this.searchForm.minPrice = "";
        this.searchForm.maxPrice = "";
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
        this.getSearchList("");
      },
    },
  };
</script>

<style scoped lang="scss">
  .nav {
    width: 100%;
    height: 96px;
    background: #ffffff;
    .navCon {
      height: 100%;

      .search {
        width: 360px;
        height: 40px;
        border: 1px solid #e93323;
        border-radius: 2px;
        cursor: pointer;
        .text {
          width: 290px;
          padding-left: 14px;
          color: #c1c1c1;
          input {
            width: 250px;
            height: 36px;
            border: none;
            outline: none;
            padding-left: 10px;
            margin-top: -2px;
          }
          .iconfont {
            font-size: 15px;
            margin-right: 5px;
          }
        }
        .bnt {
          width: 64px;
          height: 40px;
          text-align: center;
          line-height: 40px;
          color: #fff;
        }
      }
    }
  }

  .goodsSearch {
    .title {
      height: 60px;
      line-height: 60px;
      color: #999999;
      .home {
        color: #282828;
        font-size: 14px;
        cursor: pointer;
      }
    }
    .head {
      width: 1200px;
      height: 96px;
      margin-bottom: 20px;
      border-radius: 4px;
      display: flex;
      flex-wrap: nowrap;

      .item {
        width: 570px;
        height: 96px;
        display: flex;
        justify-content: space-between;
        border-radius: 4px;
        margin-right: 14px;
        background: #ffffff;
        align-items: center;
        cursor: pointer;

        .left_wrapper {
          display: flex;
          align-items: center;

          .logo {
            width: 61px;
            height: 61px;
            margin-left: 16px;

            .img {
              width: 61px;
              height: 61px;
              border-radius: 50%;
              margin-right: 20px;
            }
          }
          .con_box {
            margin-left: 12px;
            .name {
              font-size: 14px;
              font-family: ArialMT;
              color: #333333;
              line-height: 14px;
              margin-bottom: 10px;
            }
            .star_box {
              ::v-deep .el-rate__item {
                width: 16px;
              }
            }
          }
        }

        .right_wrapper {
          background: #ffffff;
          border-radius: 15px;
          border: 1px solid #e93323;
          display: flex;
          justify-content: space-around;
          align-items: center;
          padding: 6px 14px;
          margin-right: 20px;

          .name {
            margin-left: 2px;
          }

          i {
            margin-right: 6px;
          }

          span {
            font-size: 12px;
            font-family: ArialMT;
            color: #e93323;
          }
        }
      }
      .moreBtn {
        width: 32px;
        height: 76px;
        padding: 10px 0;
        background-color: #fff;
        color: #999999;
        text-align: center;
        font-size: 12px;
        float: left;
        .iconfont {
          display: block;
          font-size: 14px;
          border-radius: 100%;
          width: 11px;
          line-height: 76px;
          text-align: center;
          margin: 3px auto 0;
        }
      }
    }
    .goods_item {
      display: inline-block;
      width: 228px;
      height: 330px;
      margin: 0 13px 15px 0;
      background: #ffffff;
      &:nth-child(5n) {
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
          color: #e93323;
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
        }
      }
    }
    .el-pagination {
      display: block;
    }
    .noCart {
      text-align: center;
      margin-bottom: 70px;
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
  }

  .wrapper {
    background-color: #fff;
    padding: 25px 17px;
    margin-bottom: 20px;
    cursor: pointer;
    .list {
      width: 1100px;
      border-bottom: 1px dotted #efefef;
      padding-bottom: 10px;
      .item {
        margin-right: 30px;
        margin-bottom: 10px;
        &:hover {
          color: #e93323;
        }
      }
    }

    .sort {
      .items {
        margin-right: 30px;
        position: relative;
        &:hover {
          color: #e93323;
        }
        img {
          width: 7px;
          height: 10px;
          margin-left: 5px;
          margin-top: 5px;
        }
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
</style>
