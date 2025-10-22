<template>
  <div class="container">
    <div class="banner">
      <img :src="shopStreetHeaderImag" alt="">
    </div>
    <div class="brandshop">
      <div class="ht_title">
        <div class="line"></div>
        <h2>{{ $t(`page.index.shopStreet`) }}</h2>
        <div class="line"></div>
      </div>
      <div v-loading="loading" class="store">
        <store :storeList="storeList"></store>
      </div>
      <div class="pages-box" v-if="storeList.length && storeList.length > 0">
        <el-pagination background layout="prev, pager, next" :total="total" :pageSize="limit"
          @current-change="bindPageCur"></el-pagination>
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
import store from '../../components/merchant.vue';
export default {
  name: "store_street",
  auth: false,
  components: {
    store
  },
  data() {
    return {
      shopStreetHeaderImag: '',
      storeList: [],
      list: {},
      loading: false,
      page: 1,
      limit: 10,
      total: 0,
      colors: ['#99A9BF', '#E93323', '#E93323']
    };
  },
  beforeMount() {
    this.getStoreList()
  },
  mounted() {
    this.$nextTick(() => {
      this.$nuxt.$loading.start();
      this.getHeaderImg()
      setTimeout(() => this.$nuxt.$loading.finish(), 1000);
    });
  },
  methods: {
    getHeaderImg() {
      this.shopStreetHeaderImag = JSON.parse(localStorage.getItem("homeDataPc"))['shopStreetHeaderImag'];
    },
    /**
     * 分页点击
     * */
    bindPageCur(data) {
      this.page = data
      this.getStoreList('');
    },
    gopage(item) {
      this.$router.push({
        path: `/merchant/store`,
        query: {
          id: item.id
        }
      })
    },
    getStoreList() {
      this.loading = true;
      this.$axios
        .get(`/api/front/merchant/street?page=${this.page}&limit=${this.limit}`)
        .then(res => {
          this.storeList = res.data.list;
          this.loading = false;
        })
    }
  }
};
</script>
<style lang="scss" scoped>
.pages-box {
  margin-top: 30px;

  ::v-deep.el-pagination {
    text-align: center;
  }
}

.container {
  width: 100%;

  .banner {
    width: 1200px;
    height: 370px;
    margin: auto;

    img {
      width: 1200px;
      height: 370px;
    }
  }

  .brandshop {
    width: 1200px;
    margin: auto;

    .ht_title {
      margin: 60px 0 64px 0;
      text-align: center;
      display: flex;
      align-items: center;

      .line {
        width: 400px;
        height: 1px;
        background: #999999;
        border-radius: 2px;
      }

      h2 {
        font-size: 40px;
        font-family: Arial-BoldMT, Arial;
        font-weight: normal;
        color: #333333;
        line-height: 40px;
        margin: 0 50px;
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
  text-align: right;
}

::v-deep .el-rate__item {
  width: 16px;
}
</style>
