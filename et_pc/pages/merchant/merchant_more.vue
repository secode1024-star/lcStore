<template>
  <div class="container wrapper_1200">
    <div class="title">
      <span class="home" @click="goHome">{{$t(`page.store.index`)}} > </span>{{searchVal}}
    </div>

    <div class="search">
      <div class="sort acea-row">
        <div class="name">{{$t(`page.goodsSearch.merchantType`)}}：</div>
        <div class="listCon acea-row row-between">
          <div class="list acea-row row-middle" :class="brandNav?'':'on'">
            <div class="item" :class="current === index?'font-color':''" v-for="(item, index) in storeType" :key="index"
                 @click="storeTypeTap(index)">{{item.name}}
            </div>
          </div>
        </div>
      </div>
      <div class="sort acea-row">
        <div class="name">{{$t(`page.goodsSearch.merchantClassify`)}}：</div>
        <div class="listCon acea-row row-between">
          <div class="list acea-row row-middle" :class="brandNav?'':'on'">
            <div class="item" :class="brandCurrent === index?'font-color':''" v-for="(item, index) in categoryList"
                 :key="index" @click="categoryListTap(index)">{{item.name}}
            </div>
          </div>
        </div>
      </div>
      <div class="shop-search">
        <input type="text" :placeholder="$t(`page.store.search`)" v-model="searchVal">
        <span class="iconfont icon-sousuo" @click="storeSearch"></span>
      </div>
    </div>
    <div v-loading="loading" class="brandshop" v-if="storeList.length">
      <div class="store">
        <store :storeList="storeList"></store>
      </div>
    </div>
    <div v-if="!storeList.length && noProduct">
      <div class="noCart">
        <div class="pictrue"><img src="../../assets/images/noCart.png"></div>
        <div class="tip">{{$t(`page.goodsSearch.searchMer`)}}</div>
      </div>
    </div>
    <el-pagination v-if="storeList.length && storeList.length>0" background layout="prev, pager, next" :total="total"
                   :pageSize="limits" @current-change="bindPageCur"></el-pagination>
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
  import store from "../../components/merchant.vue";

  export default {
    name: "store_street",
    auth: false,
    components: {
      store
    },
    data() {
      return {
        storeList: [],
        searchVal: "",
        brandCurrent: 0,
        iSdefaults: 0,
        current: 0,
        page: 1,
        limits: 8,
        total: 0,
        brandNav: false,
        loading: false,
        noProduct: false,
        storeType: [],
        categoryList: [],
        priceOrder: "",
        news: 0,
        colors: ["#99A9BF", "#E93323", "#E93323"]
      };
    },
    async asyncData({app, error}) {
      let storeList = await app.$axios.get("/api/front/merchant/street");

      return {
        storeList: storeList.data.list,
        total: storeList.data.total
      };
    },
    created() {
      this.searchVal = this.$route.query.title;
    },
    beforeMount() {
      this.getTypeList();
      this.getCategoryList();
    },
    mounted() {
      this.$nextTick(() => {
        this.$nuxt.$loading.start();

        setTimeout(() => this.$nuxt.$loading.finish(), 1000);
      });
    },
    methods: {
      callPaginate(num) {
      },
      /**
       * 分页点击
       * */

      bindPageCur(data) {
        this.page = data;
        this.getStoreList("");
      },
      goHome() {
        this.$router.push({path: "/"});
      },
      storeSearch() {
        this.storeList = [];
        this.page = 1;
        this.getStoreList();
      },
      /**
       * 获取店铺
       */
      getStoreList() {
        let _this = this,
          currentPage = {
            pages: this.page,
            limit: this.limit,
            keywords: this.searchVal,
            typeId: this.typeId,
            categoryId: this.categoryId
          };
        _this.loading = true;
        _this.$axios
          .get("/api/front/merchant/search/list", {
            params: currentPage
          })
          .then(function (res) {
            _this.total = res.data.total;
            _this.storeList = res.data.list;
            _this.noProduct = res.data.list.length ? false : true;
            _this.loading = false;
          })
          .catch(function (err) {
          });
      },
      /**
       * 获取店铺
       */
      getSearchList() {
        let _this = this,
          currentPage = {
            page: this.page,
            limit: this.limit,
            keyword: this.searchVal,
            typeId: this.typeId,
            categoryId: this.categoryId
          };
        _this.loading = true;
        _this.$axios
          .get("/api/front/merchant/search/list", {
            params: currentPage
          })
          .then(function (res) {
            _this.pageTotal = res.data.count;
            _this.storeList = res.data.list;
            _this.noProduct = res.data.list.length ? false : true;
            _this.loading = false;
          })
          .catch(function (err) {
          });
      },
      /**
       * 获取店铺
       */
      getcategoryList() {
        let _this = this,
          currentPage = {
            page: this.page,
            limit: this.limit,
            keyword: this.searchVal,
            typeId: this.typeId,
            categoryId: this.categoryId
          };
        _this.loading = true;
        _this.$axios
          .get("/api/front/merchant/search/list", {
            params: currentPage
          })
          .then(function (res) {
            _this.pageTotal = res.data.count;
            _this.storeList = res.data.list;
            _this.noProduct = res.data.list.length ? false : true;
            _this.loading = false;
          })
          .catch(function (err) {
          });
      },
      /**
       * 获取全部商户类型列表
       */

      getTypeList() {
        this.$axios.get("/api/front/merchant/all/type/list").then(res => {
          this.storeType = res.data;
          this.storeType.unshift({
            id: "",
            name: "All"
          });
        });
      },
      /**
       * 获取全部商户分类列表
       */

      getCategoryList() {
        this.$axios.get("/api/front/merchant/all/category/list").then(res => {
          this.categoryList = res.data;
          this.categoryList.unshift({
            id: "",
            name: "All"
          });
        });
      },
      /**
       * 点击店铺类型
       */
      storeTypeTap(index) {
        this.current = index;
        this.typeId = this.storeType[index].id;
        this.titleName = this.storeType[index].name;
        this.page = 1;
        this.limit = 99;
        this.storeList = [];
        this.getSearchList();
      },
      /**
       * 点击店铺类型
       */
      categoryListTap(index) {
        this.brandCurrent = index;
        this.categoryId = this.categoryList[index].id;
        this.titleName = this.categoryList[index].name;
        this.page = 1;
        this.limit = 99;
        this.storeList = [];
        this.getcategoryList();
      }
    }
  };
</script>
<style lang="scss" scoped>
  .container {
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

    .search {
      background: #fff;
      margin-bottom: 20px;
      padding: 20px 0 20px 17px;
      cursor: pointer;
      border-radius: 4px;

      .sort {
        margin-bottom: 40px;

        .name {
          width: 120px;
          font-size: 14px;
          font-family: MicrosoftYaHei;
          color: #969696;
          line-height: 19px;
        }

        .item {
          margin-right: 30px;
          &:hover {
            color: #e93323;
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
      }
      .shop-search {
        width: 220px;
        height: 26px;
        position: relative;
        input {
          width: 220px;
          height: 26px;
          border-radius: 2px;
          border: 1px solid #cccccc;
          outline: none;
          text-indent: 10px;
        }
        span {
          position: absolute;
          right: 10px;
          top: 6px;
          font-size: 14px;
          color: #999;
        }
      }
      .all {
        margin-right: 30px;
        font-size: 14px;
        // color: #E93323;
      }
    }

    .brandshop {
      width: 1200px;
      margin: auto;
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
    .store {
      display: flex;
      flex-wrap: wrap;
      justify-content: space-between;
    }
  }

  .el-pagination {
    width: 1200px;
    margin: auto;
    text-align: center;
  }

  ::v-deep .el-rate__item {
    width: 16px;
  }
</style>

