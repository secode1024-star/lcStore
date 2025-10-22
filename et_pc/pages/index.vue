<template>
  <div class="container">
    <div class="banner">
      <div class="slider-banner">
        <el-carousel height="480px">
          <el-carousel-item v-for="item in bannerList" :key="item.id">
            <el-image class="img" :src="item.pic">
              <div slot="placeholder" class="image-slot">
                loading<span class="dot">...</span>
              </div>
            </el-image>
            <div class="box"></div>
          </el-carousel-item>
        </el-carousel>
      </div>
    </div>
    <div v-for="item in actList" :key="item.id">
      <recommended v-if="item.type === 1" :activityData="item"></recommended>
      <promotions v-if="item.type === 2" :activityData="item"></promotions>
      <first-new v-if="item.type === 3" :activityData="item"></first-new>
    </div>
    <!-- 店铺街 -->
    <div class="brandstore">
      <div class="left">
        <div class="left-top" @click="gopage()">
          <div class="title">{{ $t(`page.index.shopStreet`) }}</div>
          <span class="iconfont icon-gengduo"></span>
        </div>
        <div class="left-bottom">
          <div class="left-bottom-left">
            <el-carousel indicator-position="none">
              <el-carousel-item v-for="(item, index) in storeList" :key="index">
                <div style="height:3px;">
                  <div>
                    <el-image class="backImg img" :src="item.backImage" @click="goMerchant(item)">
                      <div slot="placeholder" class="image-slot">
                        loading<span class="dot">...</span>
                      </div>
                    </el-image>
                  </div>
                  <div class="logo">
                    <el-image class="img" :src="item.avatar">
                      <div slot="placeholder" class="image-slot">
                        loading<span class="dot">...</span>
                      </div>
                    </el-image>
                  </div>
                </div>
              </el-carousel-item>
            </el-carousel>
          </div>
          <div class="left-bottom-right" v-if="storeList.length">
            <div @click="goMerchant(item)" class="logo" v-for="(item, index) in storeList.slice(0, 6)" :key="index">
              <el-image class="img" :src="item.avatar">
                <div slot="placeholder" class="image-slot">
                  loading<span class="dot">...</span>
                </div>
              </el-image>
            </div>
          </div>
        </div>
      </div>
      <!-- TOP ONE -->
      <div class="right">
        <div class="right-top" @click="goTopone()">
          <div class="title">{{ $t(`page.index.topOne`) }}</div>
          <span class="iconfont icon-gengduo"></span>
        </div>
        <div class="right-bottom">
          <img class="pic pic1" src="../assets/images/top-list0.png" alt="">
          <img class="pic pic2" src="../assets/images/top-list1.png" alt="">
          <img class="pic pic3" src="../assets/images/top-list2.png" alt="">
          <div class="goods" v-for="(item, index) in toponeList" :key="index" @click="goDetail(item)">
            <el-image class="img" :src="item.image">
              <div slot="placeholder" class="image-slot">
                loading<span class="dot">...</span>
              </div>
            </el-image>
            <div class="title line2">
              <DynamicTranslate 
                :original-text="item.storeName" 
                translate-type="product_name" 
                :entity-id="item.id"
                text-class="line2"
              />
            </div>
            <span class="price">{{ GLOBAL.shopPayCurrency }}{{ item.price }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 活动列表 -->
    <div v-for="item in activityindexList" :key="item.id">
      <recommended v-if="item.type === 1" :activityData="item"></recommended>
      <promotions v-if="item.type === 2" :activityData="item"></promotions>
      <first-new v-if="item.type === 3" :activityData="item"></first-new>
    </div>
    <!-- 轮播广告 -->
    <div class="ad">
      <el-carousel width="100%" height="120px" indicator-position="none">
        <el-carousel-item v-for="item in adList" :key="item.id">
          <el-image class="img" :src="item.pic">
            <div slot="placeholder" class="image-slot">
              loading<span class="dot">...</span>
            </div>
          </el-image>
        </el-carousel-item>
      </el-carousel>
    </div>

    <div class="product">
      <div class="product-top">
        <span class="title"> {{ $t(`page.index.titAlso`) }} </span>
      </div>
      <div class="product-bottom">
        <div class="brandshop" v-if="productList.length">
          <div class="left">
            <el-image class="img" :src="list.recommendImage">
              <div slot="placeholder" class="image-slot">
                loading<span class="dot">...</span>
              </div>
            </el-image>
          </div>
          <div class="store">
            <div class="wrapper" v-if="productList.length">
              <div @click="goDetail(item)" class="goods_item imgItem" v-for="item in productList.slice(0, 8)"
                :key="item.id">
                <el-image class="img" :src="item.image">
                  <div slot="placeholder" class="image-slot">
                    loading<span class="dot">...</span>
                  </div>
                </el-image>
                <div class="goods_content">
                  <div class="lines2 store_name1">
                    {{ item.storeName }}
                  </div>
                  <div class="acea_row">
                    <div class="price1">{{ GLOBAL.shopPayCurrency }}{{ item.price }}</div>
                    <div class="ot_price">
                      <span>{{ (Math.floor(item.sales) + Math.floor(item.ficti)) || 0 }}
                        {{ $t(`page.goodsDetail.sold`) }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="bottom" v-if="productList.length > 8">
        <product :productList="productList.slice(8)"></product>
      </div>
    </div>
    <!-- 加载更多 -->
    <div class="loadingicon acea-row row-center-wrapper" v-if="productList.length && productList.length >= limits">
      <span class="loading iconfont icon-jiazai" v-if="!pullRefreshss"></span>
    </div>
    <!--右侧浮窗-->
    <FloatWindow></FloatWindow>
    
    <!--语言选择弹窗-->
    <LanguageSelector 
      :show="showLanguageSelector" 
      @confirm="onLanguageConfirm"
      @skip="onLanguageSkip"
      @close="onLanguageSelectorClose"
    />
  </div>
</template>

<script>
import recommended from "@/components/recommended.vue";
import promotions from "@/components/promotions.vue";
import firstNew from "@/components/first_new.vue";
import { goMerchant, goShopDetail } from "@/utils/order.js";
import product from "@/components/product.vue";
import LanguageSelector from "@/components/LanguageSelector.vue";
import DynamicTranslate from "@/components/DynamicTranslate.vue";

export default {
  name: "IndexPage",
  auth: false,
  components: {
    recommended,
    promotions,
    firstNew,
    product,
    LanguageSelector,
    DynamicTranslate
  },
  data() {
    return {
      seen: false,
      hide: true,
      activityindexList: [],
      storeList: [],
      bannerList: [],
      colors: ["#99A9BF", "#E93323", "#E93323"],
      visible: false,
      recommendList: [],
      productList: [],
      adList: [],
      goodsList: [],
      MerTypeList: [],
      categoryCurrent: [],
      toponeList: [],
      list: [],
      actList: [],
      pullRefreshss: true,
      page: 1, //代表页面的初始页数
      limit: 10,
      limits: 13,
      scollY: null, // 离底部距离有多少
      pageTotal: 0, //总页数
      showLanguageSelector: false // 控制语言选择器显示
    };
  },
  async asyncData({ app, error, store }) {
    typeof localstorage !== 'undefined' && window.localStorage.clear();
    let [
      list,
      storeList,
      activityindexList,
      toponeList,
      proList
    ] = await Promise.all([
      app.$axios.get("/api/pc/home/index"),
      app.$axios.get("/api/front/merchant/street"),
      app.$axios.get("/api/front/activity/index/list"),
      app.$axios.get("/api/front/product/leaderboard"),
      app.$axios.get("/api/front/index/product", {
        params: {
          page: 1,
          limit: 13
        }
      }),
      app.$axios.get("/api/front/activity/index/list")
    ]);
    typeof localstorage !== 'undefined' && localStorage.setItem("homeDataPc", JSON.stringify(list.data));
    return {
      list: list.data,
      bannerList: list.data.banner,
      adList: list.data.bastBanner,
      storeList: storeList.data.list,
      activityindexList: activityindexList.data,
      actList: activityindexList.data.splice(0, 1),
      toponeList: toponeList.data.splice(0, 3),
      proList: proList.data.list
    };
  },
  beforeDestroy() {
    window.onscroll = null;
  },
  beforeMount() {
    this.getList();
  },
  mounted() {
    // 🔥 检查是否有Google登录调试信息
    try {
      const debugInfo = localStorage.getItem('google_login_debug');
      if (debugInfo) {
        console.log('🔍 发现Google登录调试信息:');
        console.log(debugInfo);
        
        // 解析并显示关键信息
        const parsed = JSON.parse(debugInfo);
        console.log('🔍 解析后的调试信息:');
        console.log('- 时间戳:', parsed.timestamp);
        console.log('- 数组长度:', parsed.arrayLength);
        console.log('- 数组内容:', parsed.arrayContent);
        
        // 显示一个提示，让用户知道有调试信息
        this.$message.info('发现Google登录调试信息，请查看控制台');
        
        // 清除调试信息，避免重复显示
        localStorage.removeItem('google_login_debug');
      }
    } catch (e) {
      console.warn('读取Google登录调试信息失败:', e);
    }
    
    this.$nextTick(() => {
      this.$nuxt.$loading.start();
      setTimeout(() => this.$nuxt.$loading.finish(), 1000);
    });
    this.$cookies.set("merPlatChatConfig", {
      serviceEmail: this.list.consumerEmail,
      serviceLink: this.list.consumerH5Url,
      servicePhone: this.list.consumerHotline,
      serviceMessage: this.list.consumerMessage,
      serviceType: this.list.consumerType
    });
    this.pullRefresh();
    
    // 检查是否需要显示语言选择器
    this.checkLanguageSelector();
  },
  methods: {
    goDetail(item) {
      goShopDetail(item.id, this);
    },
    goTopone() {
      this.$router.push({
        path: "/goods/top_one"
      });
    },
    watchScroll() {
      let _this = this;
      this.scollY =
        this.comsys.getScrollTop() +
        this.comsys.getWindowHeight() -
        this.comsys.getScrollHeight();
      // 把下拉刷新置为false，防止多次请求
      if (this.scollY >= -50) {
        if (this.page >= Math.ceil(this.pageTotal / this.limits)) {
          this.pullRefreshss = true;
          return false;
        }
        if (!this.pullRefreshss) {
          return false;
        }
        _this.pullRefreshss = false;
        if (_this.productList.length < _this.pageTotal) {
          // 加页码数
          _this.page++;
          _this.getList();
        }
      } else {
        // 其他时候把下拉刷新置为true
        _this.pullRefreshss = true;
      }
    },
    getList() {
      let currentPage = { page: this.page, limit: this.limits };
      this.$axios
        .get(`/api/front/index/product`, {
          params: currentPage
        })
        .then(res => {
          this.pageTotal = res.data.total;
          let proList = res.data.list;
          this.productList = this.productList.concat(proList);
        })
        .catch(err => {
          this.$message.error(err);
        });
    },
    gopage() {
      this.$router.push({
        path: "/merchant/merchant_street"
      });
    },
    goMerchant(item) {
      goMerchant(item.id, this);
    },
    // 下拉加载ajax
    pullRefresh: function () {
      let _this = this;
      window.onscroll = function () {
        _this.watchScroll();
      };
    },
    
    // 检查是否需要显示语言选择器
    checkLanguageSelector() {
      // 检查用户是否已经选择过语言
      const hasSelectedLanguage = localStorage.getItem('language_selected');
      const currentLocale = this.$cookies.get('locale');
      
      console.log('检查语言选择器:', {
        hasSelectedLanguage,
        currentLocale,
        shouldShow: !hasSelectedLanguage && !currentLocale
      });
      
      // 如果是首次访问且没有语言cookie，显示语言选择器
      if (!hasSelectedLanguage && !currentLocale) {
        // 延迟显示，让页面先加载完成
        setTimeout(() => {
          console.log('显示语言选择器');
          this.showLanguageSelector = true;
        }, 1500);
      }
      
      // 为了测试方便，可以临时取消注释下面的代码强制显示
      // 如果URL中包含 ?test-lang=true，则强制显示语言选择器
      if (window.location.search.includes('test-lang=true')) {
        setTimeout(() => {
          console.log('测试模式：强制显示语言选择器');
          this.showLanguageSelector = true;
        }, 2000);
      }
      
      // 如果URL中包含 ?reset-lang=true，则清除语言设置
      if (window.location.search.includes('reset-lang=true')) {
        localStorage.removeItem('language_selected');
        localStorage.removeItem('preferred_language');
        this.$cookies.remove('locale');
        console.log('已清除语言设置，刷新页面将显示语言选择器');
        
        // 清除URL参数并刷新
        const url = new URL(window.location);
        url.searchParams.delete('reset-lang');
        window.history.replaceState({}, '', url);
        
        setTimeout(() => {
          window.location.reload();
        }, 1000);
      }
    },
    
    // 语言选择确认
    onLanguageConfirm(selectedLanguage) {
      console.log('Language confirmed:', selectedLanguage);
      this.showLanguageSelector = false;
      
      // 可以在这里添加页面刷新逻辑，如果需要的话
      // this.$router.go(0);
    },
    
    // 跳过语言选择
    onLanguageSkip(defaultLanguage) {
      console.log('Language selection skipped, using:', defaultLanguage);
      this.showLanguageSelector = false;
    },
    
    // 语言选择器关闭
    onLanguageSelectorClose() {
      this.showLanguageSelector = false;
    }
  }
};
</script>
<style lang="scss" scoped>
.container {
  width: 100%;
  flex: 1;

  .banner {
    width: 1200px;
    height: 480px;
    margin: 0;
    position: relative;

    .slider-banner {
      width: 100%;
      margin: auto;

      ::v-deep .el-carousel__arrow--left {
        left: 224px;
      }
    }

    .nav-tabs {
      width: 260px;
      height: 480px;
      background: #242424;
      opacity: 0.85;
      position: absolute;
      top: 0;
      left: 360px;
      z-index: 99;
    }

    .img {
      width: 100%;
      height: 100%;
    }
  }

  .brandstore {
    width: 1200px;
    height: 413px;
    margin: 40px 0 0 0;
    display: flex;

    .left {
      width: 590px;
      height: 413px;
      background: url("../assets/images/storeShop.png") no-repeat;
      display: flex;
      flex-wrap: wrap;
      margin-right: 15px;

      .left-top {
        width: 100%;
        height: 90px;
        color: #000;
        display: flex;
        justify-content: space-between;
        cursor: pointer;

        .title {
          font-size: 20px;
          font-family: Arial-BoldMT, Arial;
          font-weight: normal;
          line-height: 20px;
          margin: 20px 0 43px 20px;
        }

        .iconfont {
          margin-top: 20px;
          margin-right: 20px;
        }

        .more {
          font-size: 16px;
          font-family: ArialMT;
          line-height: 16px;
          margin-left: 71px;
        }

        .icon {
          width: 12px;
          height: 12px;
          display: inline-block;
          border: 1px solid #fff;
          opacity: 0.8;
          border-radius: 50%;
          font-size: 12px;
        }
      }

      .left-bottom {
        width: 100%;
        height: 305px;
        display: flex;
        flex-wrap: wrap;
        margin: 0 20px 20px 20px;

        .left-bottom-left {
          width: 243px;
          cursor: pointer;

          .logo {
            width: 241px;
            height: 64px;
            margin-top: 10px;
            display: flex;
            justify-content: center;

            .img {
              width: 96px;
              height: 48px;
            }
          }

          .backImg {
            width: 241px;
            height: 241px;
            display: inline-block !important;
          }
        }

        .left-bottom-right {
          width: 306px;
          height: 304px;

          .logo {
            width: 150px;
            height: 101px;
            background: #ffffff;
            padding: 32px;
            margin: 1px;
            float: left;
            cursor: pointer;

            .img {
              width: 90px;
              height: 36px;
            }
          }
        }
      }
    }

    .right {
      width: 590px;
      height: 413px;
      background: url("../assets/images/topOne.png") no-repeat;
      display: flex;
      flex-wrap: wrap;

      .right-top {
        width: 100%;
        height: 90px;
        color: #000;
        display: flex;
        justify-content: space-between;
        cursor: pointer;

        .title {
          font-size: 20px;
          font-family: Arial-BoldMT, Arial;
          font-weight: normal;
          line-height: 20px;
          margin: 20px 0 43px 20px;
        }

        .iconfont {
          margin-top: 20px;
          margin-right: 20px;
        }

        .more {
          font-size: 16px;
          font-family: ArialMT;
          line-height: 16px;
          margin-left: 71px;
        }

        .icon {
          width: 12px;
          height: 12px;
          display: inline-block;
          border: 1px solid #fff;
          opacity: 0.8;
          border-radius: 50%;
          font-size: 12px;
        }
      }

      .right-bottom {
        width: 100%;
        height: 313px;
        display: flex;
        position: relative;

        .pic {
          position: absolute;
          width: 36px;
          height: 44px;
          z-index: 99;
        }

        .pic1 {
          left: 30px;
        }

        .pic2 {
          left: 220px;
        }

        .pic3 {
          left: 410px;
        }

        .goods {
          width: 170px;
          margin-left: 20px;
          cursor: pointer;

          .img {
            width: 170px;
            height: 170px;
          }

          .title {
            width: 100%;
            height: 44px;
            font-size: 16px;
            font-family: ArialMT;
            color: #333333;
            line-height: 22px;
            margin: 15px 0 30px 0;
          }

          .price {
            font-size: 24px;
            font-family: DINCond-Black, DINCond;
            font-weight: 900;
            color: #e93323;
            line-height: 24px;
            margin-left: 46px;
          }
        }
      }
    }
  }

  .product {
    width: 1200px;
    margin: 0;

    .product-top {
      width: 100%;
      display: flex;
      justify-content: space-between;
      align-items: center;

      .title {
        font-size: 26px;
        text-align: center;
        margin: 28px 20px;
      }

      .more {
        font-size: 14px;
        text-align: center;
        float: right;
        color: #666;
        margin-right: 20px;
      }
    }

    .product-bottom {
      display: flex;
      flex-wrap: wrap;

      .brandshop {
        display: flex;
      }

      .left {
        width: 226px;
        height: 675px;
        background: #fff;
        margin: 0 15px 15px 0;
        float: left;

        .img {
          width: 226px;
          height: 675px;
        }
      }

      .goods_item {
        display: inline-block;
        width: 228px;
        height: 330px;
        margin: 0 13px 15px 0;
        background: #ffffff;
        cursor: pointer;

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
    }
  }

  .ad {
    width: 1200px;
    height: 120px;
    margin: 40px 0 0 0;

    .img {
      width: 100%;
      height: 120px;
    }
  }

  .el-carousel__item.is-animating {
    display: flex;
  }
}

.flex-column {
  display: flex;
  flex-direction: column;
}

.wrapper {
  .goods_item {
    display: inline-block;
    margin: 0 13px 15px 0;
    background: #ffffff;

    .img {
      margin: 20px 20px 8px;
    }

    .goods_content {
      .store_name {
        height: 44px;
        margin: 0 22px 13px 15px;
        font-size: 16px;
        color: #333333;
        line-height: 22px;
      }

      .store_name1 {
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

      .price1 {
        font-size: 20px;
        font-weight: 900;
        color: #e93323;
        line-height: 20px;
        margin-bottom: 9px;
        display: inline-block;

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

  .imgItem {
    width: 228px;
    height: 330px;

    .img {
      width: 198px;
      height: 198px;
      margin: 15px;
    }
  }
}

.goods_item:nth-child(4n) {
  margin-right: 0 !important;
}

.topindeximg1 {
  width: 54px;
  height: 66px;
  position: absolute;
  left: 900px;
  background-image: url("../assets/images/01.png");
}

.topindeximg2 {
  width: 54px;
  height: 66px;
  position: absolute;
  left: 1090px;
  background-image: url("../assets/images/02.png");
}

.topindeximg3 {
  width: 54px;
  height: 66px;
  position: absolute;
  left: 1280px;
  background-image: url("../assets/images/03.png");
}
</style>

