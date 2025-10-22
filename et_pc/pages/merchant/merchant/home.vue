<template>
  <div>
    <div class="goods" v-if="JSON.parse($store.state.merPcBanner).length">
      <el-carousel height="340px">
        <el-carousel-item v-for="(item, index) in JSON.parse($store.state.merPcBanner)" :key="index">
          <el-image :src="item.sattDir">
            <div slot="placeholder" class="image-slot">
              loading<span class="dot">...</span>
            </div>
          </el-image>
        </el-carousel-item>
      </el-carousel>
    </div>
    <div class="goods-list">
      <div class="title">
        <div class="name">Store Recommended</div>
        <div class="text">Best-selling list, everyone is buying</div>
      </div>
      <div class="list" v-loading="loading">
          <div class="brandshop" v-if="productList.length">
            <div class="store">
                <product :productList="productList"></product>
            </div>
        </div>
      </div>
    </div>
    <el-pagination v-if="productList.length && productList.length>0" background layout="prev, pager, next" :total="total" :pageSize="limit" @current-change="bindPageCur"></el-pagination>
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
export default {
  name: "store",
  auth: false,
  data() {
    return {
      page: 1,
      limit: 8,
      total: 0,
      productList: [],
      loading: false
    }
  },
  async asyncData({app, query, store}) {
    return {
      indexCur: query.type,
      cateId: query.cateId,
      merId: query.id,
      search: query.search,
    };
  },
  computed: {
  },
  head() {
    return {
      title: this.$t(`page.store.index`)
    }
  },
  created() {
    this.getProductList();
  },
  methods: {
    getProductList() {
      this.loading = true
      let currentPage = { page: this.page, limit: this.limit, merId: this.merId};
      this.$axios
        .get(`/api/front/product/merchant/pro/list`, {
          params: currentPage,
        })
        .then(res => {
          this.total = res.data.total;
          this.productList = res.data.list;
          this.loading = false
        }).catch(error=>{
        this.loading = false
      })
  },
    /**
    * 分页点击
    * */ 
    bindPageCur(data){
        this.page = data
        this.getProductList('');
    }
  }
}
</script>
<style lang="scss" scoped>
  .trader_box{
    margin: 8px 0 16px 0;
  }
  .trader{
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
.menu-count {
  height: 66px;
  background: #fff;
  min-width: 1200px;
  width: 100%;
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
      top: 25px;
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
  height: 66px;
  margin: 0 auto;
  .left-box {
    width: 224px;
    float: left;
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
        .store_qualify{
          width: 16px;
          height: 16px;
          &:hover + .license{
              display: inline-block;
          }
        }
        .license{
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
          &:before{
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
      margin-top: 15px;
      .store-category {
        line-height: 34px;
        color: #666;
        border-bottom: 1px solid #F2F2F2;
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
          padding: 15px 40px;
          div {
            cursor: pointer;
          }
          .font-red {
            color: #e93323;
          }
        }
        .font-bold{
          font-weight: bold;
        }
      }

    }
  }
  .right-box {
    width: 956px;
    min-height: 730px;
    margin-left: 8px;
    padding-bottom: 30px;
    float: right;
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
.noGoods{
  text-align: center;
  .pictrue{
    width: 274px;
    height: 213px;
    margin: 130px auto 0 auto;
    img{
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

      .el-image {
      width: 100%;
      height: 100%;
    }
  }

  .goods-list {
    width: 1200px;
    margin: auto;

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
        cursor: pointer;

        img {
          width: 244px;
          height: 244px;
          margin: 20px 20px 8px;
        }

        .goods_content {

          .store_name{
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

  ::v-deep .el-rate__item {
    width: 16px;
  }
</style>
