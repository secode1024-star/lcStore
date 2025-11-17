<template>
  <div class="goods_count">
    <div class="menu-count">
      <div class="user-menu user-wrapper acea-row row-middle">
        <div class="menu-main acea-row row-middle">
        </div>
      </div>
    </div>
    <div class="goods-detail">
      <div class="wrapper_1200 acea-row">
        <div class="goods-main">
          <div class="acea-row row-top" style="position: relative;">
            <div class="carousel">
              <el-image :src="checkedImage" class="preview">
                <div slot="placeholder" class="image-slot">
                  loading<span class="dot">...</span>
                </div>
              </el-image>
<!--              <el-image :src="JSON.parse(productInfo.sliderImage)[slideIndex]" class="preview">-->
<!--                <div slot="placeholder" class="image-slot">-->
<!--                  loading<span class="dot">...</span>-->
<!--                </div>-->
<!--              </el-image>-->
              <client-only>
                <div v-swiper:carousel="swiperOption">
                  <div class="swiper-wrapper">
                    <div
                      v-for="(item, index) in JSON.parse(productInfo.sliderImage)"
                      :key="index"
                      :class="{ on: slideIndex === index }"
                      class="swiper-slide"
                      @mouseover="swiperMouseover(index)"
                    >
                      <el-image :src="item">
                        <div slot="placeholder" class="image-slot">
                          loading<span class="dot">...</span>
                        </div>
                      </el-image>
                    </div>
                  </div>
                  <div class="swiper-button-prev swiper-button-white"></div>
                  <div class="swiper-button-next swiper-button-white"></div>
                </div>
              </client-only>
              <div class="acea-row row-middle">
                <div class="btn" style="width:60px" @click="collect">
                <span
                  :class="[
                    'iconfont',
                    userCollect ? 'icon-xihuan1' : 'icon-xihuan'
                  ]"
                ></span
                >{{ userCollect ? $t(`page.store.followed`) : $t(`page.store.follow`) }}
                </div>
              </div>

            </div>
            <div class="text-wrapper">
              <div class="title">{{ productInfo.storeName }}</div>
              <div class="money-wrapper acea-row">
                <div class="priceBox">
                  <div class="acea-row row-middle mb22">
                    <div class="prict-title">{{$t(`page.goodsList.price`)}}</div>
                    <div class="price">
                      <span>{{GLOBAL.shopPayCurrency}}{{
                        attrValueSelected
                          ? attrValueSelected.price
                          : productInfo.price
                      }}</span>
                    </div>
                    <div class="money-wrap">
                      <del
                      >{{GLOBAL.shopPayCurrency}}{{
                        attrValueSelected
                        ? attrValueSelected.otPrice
                        : productInfo.otPrice
                        }}
                      </del
                      >
                      <div class="acea-row row-middle">

                      </div>
                    </div>
                  </div>
                  <div class="acea-row row-middle" v-if="couponList.length>0">
                    <div class="prict-title">{{$t(`page.goodsDetail.coupons`)}}</div>
                    <div class="acea-row row-between dropdown-box" style="width: 496px;">
                      <div class="coupons-box acea-row">
                        <div class="activity" v-for="item in couponList" :key="item.id">
                          {{GLOBAL.shopPayCurrency}}{{item.money}}
                        </div>
                      </div>
                      <el-dropdown style="z-index: 10">
                        <div class="coupons-get cursors">
                          {{$t(`page.users.userCoupon.receive`)}}
                          <i class="el-icon-arrow-down el-icon--right"></i>
                        </div>
                        <el-dropdown-menu slot="dropdown">
                          <div class="coupon_list">
                            <coupon :couponList="couponList"></coupon>
                          </div>
                        </el-dropdown-menu>
                      </el-dropdown>
                    </div>
                  </div>
                </div>
                <div class="saleBox acea-row row-center-wrapper">
                  <el-divider direction="vertical"></el-divider>
                  <div class="sales acea-row row-column row-center-wrapper">
                    <div class="num">
                      {{Math.floor(productInfo.sales) + Math.floor(productInfo.ficti) || 0}}
                    </div>
                    <div>{{$t(`page.goodsDetail.sales`)}}</div>
                  </div>
                </div>
              </div>
              <div class="attribute">
                <div
                  v-for="(item, index) in productAttr"
                  :key="index"
                  class="acea-row size-wrapper"
                >
                  <div class="label">{{ translateAttrName(item.attrName) }}</div>
                  <div class="acea-row list">
                    <label
                      v-for="(itm, idx) in item.attrValues.split(',')"
                      :key="idx"
                      class="item"
                    >
                      <input
                        v-model="attrSelected[index]"
                        type="radio"
                        :name="index"
                        :value="itm"
                        :checked="!idx"
                        hidden
                      />
                      <div class="acea-row cont">
                        <div class="acea-row row-middle name">{{ itm }}</div>
                        <div class="iconfont icon-xuanzhong4"></div>
                      </div>
                    </label>
                  </div>
                </div>
              </div>
              
              <div class="number-wrapper acea-row">
                <div class="label">{{$t(`page.goodsDetail.num`)}}</div>
                <div class="counter-wrap acea-row">
                  <div class="counter">
                    <button
                      class="iconfont icon-shangpinshuliang-jian"
                      :disabled="count === 1 || !stock"
                      @click="minus"
                    >—</button>
                    <input v-model="count" @input="inputNum"/>
                    <button
                      style="font-size: 20px;"
                      class="iconfont icon-shangpinshuliang-jia"
                      :disabled="count === stock || !stock"
                      @click="plus"
                    >+</button>
                  </div>
                  <span>{{$t(`page.goodsDetail.inventory`)}}：{{stock || 0}}{{productInfo.unitName || ''}}</span>
                </div>
              </div>
              
              <!-- 商品规格信息 -->
              <div class="product-specs-wrapper">
                <div class="specs-title">{{$t('page.goodsDetail.specsInfo')}}</div>
                <div class="specs-content">
                  <div v-if="attrValueSelected && attrValueSelected.productName" class="spec-item">
                    <span class="spec-label">{{$t('page.goodsDetail.productName')}}：</span>
                    <span class="spec-value">{{ attrValueSelected.productName }}</span>
                  </div>
                  <div v-if="attrValueSelected && attrValueSelected.material" class="spec-item">
                    <span class="spec-label">{{$t('page.goodsDetail.material')}}：</span>
                    <span class="spec-value">{{ attrValueSelected.material }}</span>
                  </div>
                  <div v-if="attrValueSelected && attrValueSelected.capacity" class="spec-item">
                    <span class="spec-label">{{$t('page.goodsDetail.capacity')}}：</span>
                    <span class="spec-value">{{ attrValueSelected.capacity }}</span>
                  </div>
                  <div v-if="attrValueSelected && attrValueSelected.origin" class="spec-item">
                    <span class="spec-label">{{$t('page.goodsDetail.origin')}}：</span>
                    <span class="spec-value">{{ attrValueSelected.origin }}</span>
                  </div>
                  <div v-if="attrValueSelected && attrValueSelected.size" class="spec-item">
                    <span class="spec-label">{{$t('page.goodsDetail.size')}}：</span>
                    <span class="spec-value">{{ attrValueSelected.size }}</span>
                  </div>
                  <div v-if="attrValueSelected && attrValueSelected.weight" class="spec-item">
                    <span class="spec-label">{{$t('page.goodsDetail.weight')}}：</span>
                    <span class="spec-value">{{ attrValueSelected.weight }} KG</span>
                  </div>
                  <div v-if="attrValueSelected && attrValueSelected.volume" class="spec-item">
                    <span class="spec-label">{{$t('page.goodsDetail.volume')}}：</span>
                    <span class="spec-value">{{ attrValueSelected.volume }} m³</span>
                  </div>
                  <div v-if="attrValueSelected && attrValueSelected.packQuantity" class="spec-item">
                    <span class="spec-label">{{$t('page.goodsDetail.packQuantity')}}：</span>
                    <span class="spec-value">{{ attrValueSelected.packQuantity }}</span>
                  </div>
                  <div v-if="attrValueSelected && attrValueSelected.skuLadderPrice" class="spec-item">
                    <span class="spec-label">{{$t('page.goodsDetail.skuLadderPrice')}}：</span>
                    <span class="spec-value">{{ attrValueSelected.skuLadderPrice }}</span>
                  </div>
                </div>
              </div>
              
              <div class="button-wrapper" v-if="stock">
                <button
                  class="btn cart"
                  :disabled="!stock"
                  @click="buy(1, $event)"
                >
                  {{$t(`page.goodsDetail.addCart`)}}
                </button>
                <button class="btn" :loading="loading" :disabled="!stock" @click="buy(0, $event)">
                  {{$t(`page.goodsDetail.buyNow`)}}
                </button>
              </div>
              <div class="button-wrapper" v-else>
                <button class="btn btn-out" disabled>{{$t(`page.goodsDetail.soldOut`)}}</button>
              </div>
              <div v-if="guaranteeList.length" class="number-wrapper acea-row guaranteeList">
                <div class="label" @mouseover="guaranteeTitle = true" @mouseleave="guaranteeTitle = false">{{$t(`page.goodsDetail.assure`)}} <span class="iconfont icon-duoshanghupc-shuomingdanchuang"></span></div>
                <div class="guaranee_tel" :style="{display:(guaranteeTitle || guaranteeInfo)? 'block':'none'}"  @mouseover="guaranteeInfo = true" @mouseleave="guaranteeInfo = false">
                  <div class="content">
                    <div v-for="item in guaranteeList" class="item" :key="item.id">
                      <div class="name">{{item.name}}</div>
                      <div class="info" style="white-space: pre-line;">{{item.content}}</div>
                    </div>
                  </div>
                </div>
                <div class="guaranteeAttr">
                  <div class="atterTxt1" v-for="item in guaranteeList" :key="item.id">
                    <span class="iconfont icon-gou"></span>{{item.name ? item.name : ''}}
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="detail-wrapper acea-row">
            <div class="recom-section">
              <div class="user-info">
                <div class="store-basis">
                  <div class="acea-row">
                    <div class="store-logo">
                      <img :src="merchantInfo.avatar" alt="">
                    </div>
                    <div>
                      <div class="store-name line2">{{merchantInfo.name}}</div>
                      <el-rate
                        v-model="merchantInfo.starLevel"
                        disabled
                        :colors="['#e93323', '#e93323', '#e93323']"
                        score-template="{value}">
                      </el-rate>
                    </div>
                  </div>
                  <span v-if="merchantInfo.isSelf" class="trader">{{$t(`page.store.selfSupport`)}}</span>
                  <span class="trader">{{merchantInfo.typeId | merchantTypeFilter}}</span>
                  <div class="store-info">
                    <div class="items acea-row row-middle">
                      <span class="titles">{{$t(`page.store.storeService`)}}</span>
                      <span class="iconfont icon-kefu" @click="call"></span>
                    </div>
                    <div class="items acea-row row-middle">
                      <span class="titles">{{$t(`page.store.storeQualification`)}}</span>
                      <nuxt-link class="desc" :to="{path:'/merchant/merchant/qualification',query:{id:merId}}">
                        <span class="iconfont icon-zizhi"></span>
                        <span class="license">{{$t(`page.store.storeQualification`)}}</span>
                      </nuxt-link>
                    </div>
                  </div>
                </div>
                <div class="store-favorites">
                  <button class="collection mb12 care" @click="followToggle(merId)">
                    <span v-show="!merchantInfo.isCollect" class="iconfont icon-guanzhu"></span>
                    {{ merchantInfo.isCollect ? $t(`page.store.followed`) : $t(`page.store.follow`) }}
                  </button>
                  <button class="collection" @click="goStore">
                    <span class="iconfont icon-shangjiadingdan"></span>
                    {{$t(`page.goodsSearch.mer`)}}
                  </button>
                </div>
              </div>
              <div class="store-recommend" v-if="goodsList && goodsList.length">
                <div class="title"><span>{{$t(`page.goodsDetail.navList[2].name`)}}</span></div>
                <div class="list">
                  <nuxt-link
                    v-for="(item, index) in goodsList"
                    :key="index"
                    :to="`/goods_detail/${item.id}`"
                    class="item"
                  >
                    <div class="image">
                      <img :src="item.image" />
                    </div>
                    <div class="text">
                      <div class="name line2">{{ item.storeName }}</div>
                      <div class="acea-row row-between-wrapper">
                        <div class="money">
                          {{GLOBAL.shopPayCurrency}}<span>{{ item.price }}</span>
                        </div>
                        <div class="sales">{{ (Math.floor(item.sales) + Math.floor(item.ficti)) || 0 }} {{$t(`message.tips.sold`)}}</div>
                      </div>
                    </div>
                  </nuxt-link>
                </div>
              </div>
            </div>
            <div class="ml30">
              <div class="detail-hd acea-row">
                <div class="tab acea-row">
                  <div
                    class="item acea-row row-center-wrapper"
                    :class="{ on: tabIndex === 0 }"
                    @click="tab(0)"
                  >
                    {{$t(`page.goodsDetail.navList[3].name`)}}
                  </div>
                  <div
                    class="item acea-row row-center-wrapper"
                    :class="{ on: tabIndex === 1 }"
                    @click="tab(1)"
                  >
                    {{$t(`page.goodsDetail.Reviews`)}}({{ replyInfo.sumCount }})
                  </div>
                </div>
              </div>
              <div class="detail-bd">
                <div v-show="tabIndex === 0">
                  <div
                    v-if="productInfo.content"
                    class="detail-html"
                  >
                    <div v-html="productInfo.content"></div>
                  </div>
                  <div v-else class="nothing">
                    <img src="@/assets/images/noDetail.png"/>
                    <div>{{$t(`message.tips.noDetal`)}}</div>
                  </div>
                </div>
                <div v-show="tabIndex === 1" class="comment">
                  <div class="comment-hd">
                    <div class="acea-row row-between-wrapper">
                      <div class="acea-row row-middle score">
                        {{$t(`page.users.goodsCommentList.score`)}}
                        <div class="cont">
                          <el-rate
                            v-model="replyInfo.replyStar"
                            disabled
                            :colors="['#e93323', '#e93323', '#e93323']"
                            score-template="{replyInfo.replyStar}">
                          </el-rate>
                        </div>
                      </div>
                      <div class="rate">
                        <span>{{$t(`page.users.goodsCommentList.good`)}} {{(replyInfo.replyChance)*100}}%</span>
                      </div>
                    </div>
                    <div class="menu">
                      <div
                        class="item"
                        :class="{ on: reply.type === '0' }"
                        @click="replyTypeChange('0')"
                      >
                        {{$t(`page.users.goodsCommentList.all`)}}({{ replyInfo.sumCount }})
                      </div>
                      <div
                        class="item"
                        :class="{ on: reply.type === '1' }"
                        @click="replyTypeChange('1')"
                      >
                        {{$t(`page.users.goodsCommentList.goodScore`)}}({{ replyInfo.goodCount }})
                      </div>
                      <div
                        class="item"
                        :class="{ on: reply.type === '2' }"
                        @click="replyTypeChange('2')"
                      >
                        {{$t(`page.users.goodsCommentList.general`)}}({{ replyInfo.inCount }})
                      </div>
                      <div
                        class="item"
                        :class="{ on: reply.type === '3' }"
                        @click="replyTypeChange('3')"
                      >
                        {{$t(`page.users.goodsCommentList.bad`)}}({{ replyInfo.poorCount }})
                      </div>
                    </div>
                  </div>
                  <div class="comment-bd">
                    <template v-if="replyList.length>0">
                      <div v-for="item in replyList" :key="item.reply_id" class="item">
                        <div class="acea-row row-middle item-hd">
                          <div class="image">
                            <img v-if="item.avatar" :src="item.avatar"/>
                            <img v-else src="~assets/images/f.png" alt="">
                          </div>
                          <div class="text">
                            <div class="acea-row row-middle name">
                              {{ item.nickname }}
                              <div class="star">
                                <el-rate
                                  v-model="item.star"
                                  disabled
                                  :colors="['#e93323', '#e93323', '#e93323']"
                                  score-template="{item.star}">
                                </el-rate>
                              </div>
                            </div>
                            <div>{{ item.createTime }}</div>
                          </div>
                        </div>
                        <div class="item-bd">
                          <div>{{ item.comment }}</div>
                          <div class="image-wrapper" v-if="item.pics && item.pics.length && item.pics[0]">
                            <div
                              v-for="(itm, idx) in item.pics"
                              :key="idx"
                              class="image"
                              @click="isDialog = true"
                            >
                              <el-image
                                style="width: 54px; height: 54px"
                                :src="itm"
                                :preview-src-list="item.pics"
                              ></el-image>
                            </div>
                          </div>
                          <div v-if="item.merchantReplyContent" class="reply">
                            <div class="item">
                              <span>{{$t(`page.users.goodsCommentList.seller`)}}：</span>{{ item.merchantReplyContent }}
                            </div>
                          </div>
                        </div>
                      </div>
                    </template>
                    <div class="empty-box" v-else="replyList.length<0">
                      <img src="~assets/images/noEvaluate.png" alt="">
                      <p>{{$t(`message.tips.noEvaluation`)}}</p>
                    </div>
                  </div>
                  <div v-if="replyList.length" class="acea-row row-right">
                    <el-pagination
                      layout="prev, pager, next"
                      :page-size="reply.limit"
                      :total="replyCount"
                      @current-change="callPaginate"
                      @prev-click="callPaginate"
                      @next-click="callPaginate"
                    ></el-pagination>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
    <float-window></float-window>
  </div>
</template>

<script>
  import { getPreOrder, followPro, followMer, goMerchant } from '@/utils/order.js';
  import { Debounce } from '@/utils/validate.js'
  import coupon from "@/components/coupon";
  import FloatWindow from "../../../components/floatWindow";
  export default {
    name: "index",
    auth: false,
    data() {
      return {
        loading: false,
        swiperOption: {
          navigation: {
            nextEl: ".swiper-button-next",
            prevEl: ".swiper-button-prev"
          },
          slidesPerView: "auto",
          observer: true,
          observeParents: true
        },
        slideIndex: 0,
        reply: {
          type: '0',
          page: 1,
          limit: 20,
          loading: false,
          finished: false
        },
        couponList: [],
        attrSelected: [],
        attrValueSelected: null,
        CartCount: 0,
        replyCount: 0,
        replyList: [],
        replyInfo: {
          stat: {}
        },
        count: 1,
        stock: 1,
        unique: "",
        guaranteeTitle: false,
        guaranteeInfo: false,
        tabIndex: 0,
        serviceInfo: {},
        checkedImage: '' //选中的大图展示
      }
    },
    components: {FloatWindow, coupon },
    watch: {
      productAttr: {
        immediate: true,
        handler(attr) {
          if (attr && attr.length) {
            attr.forEach((value, index) => {
              this.attrSelected[index] = value.attrValues.split(',')[0];
            });
          }
          // 初始化 attrValueSelected（如果还没有赋值）
          this.initializeAttrValueSelected();
        }
      },
      productValue: {
        immediate: true,
        handler(val) {
          // 当 productValue 数据到达时，初始化 attrValueSelected
          if (val && Object.keys(val).length > 0) {
            this.initializeAttrValueSelected();
          }
        }
      },
      attrValueSelected(n){
        if(n) {
          let sliderImage = JSON.parse(this.productInfo.sliderImage)
          sliderImage[0] = n.image
          this.slideIndex = 0;
        }
      },
      attrSelected: {
        handler(attr) {
          if (attr && attr.length) {
            let name = attr.join(),
              value = this.productValue[name];
            if (value) {
              this.attrValueSelected = value;
              this.stock = value.stock;
              this.unique = value.id;
              this.checkedImage = value.image
            }else{
              // 如果匹配失败，尝试使用第一个可用的规格（兜底方案）
              const firstKey = Object.keys(this.productValue || {})[0];
              if (firstKey && this.productValue[firstKey]) {
                this.attrValueSelected = this.productValue[firstKey];
                this.stock = this.productValue[firstKey].stock;
                this.unique = this.productValue[firstKey].id;
                this.checkedImage = this.productValue[firstKey].image || '';
              } else {
                this.attrValueSelected = null;
                this.stock = 0;
                this.unique = '';
              }
            }
          }
        }
      }
    },
    // 商品详情
    async asyncData({error, app, params, query}) {
      try {
        // 获取当前语言（从cookie或localStorage）
        const currentLocale = app.$cookies.get('locale') || app.$i18n.locale || 'zh-CN';
        
        // 构建API请求URL，添加语言参数
        const apiUrl = `/api/front/product/detail/${params.id}`;
        const requestParams = currentLocale && currentLocale !== 'zh-CN' 
          ? { language: currentLocale } 
          : {};
        
        let [goods] = await Promise.all([
          app.$axios.get(apiUrl, { params: requestParams })
        ]);
        return {
          productInfo: goods.data.productInfo,
          productAttr: goods.data.productAttr,
          productValue: goods.data.productValue,
          goodsList: goods.data.merchantInfo.proList,
          merchantInfo: goods.data.merchantInfo,
          id: params.id,
          userCollect: goods.data.userCollect,
          merId: goods.data.productInfo.merId,
          guaranteeList: goods.data.guaranteeList || [],
          currentLocale: currentLocale,
        };
      } catch (e) {
        error({statusCode: 500, msg: typeof e === 'string' ? e : '系统繁忙'});
      }
    },
    head() {
      return {
        title: this.productInfo.storeName
      }
    },
    beforeMount() {
      this.$store.dispatch('MerTypeList')
      this.getCoupons();
      this.getReplyConfig();
      this.getReply(1)
    },
    watch: {
      // 监听语言切换，自动刷新商品详情
      '$i18n.locale'(newLocale) {
        if (newLocale && newLocale !== this.currentLocale) {
          this.refreshProductDetail(newLocale);
        }
      }
    },
    mounted() {
      // 检测移动设备并自动跳转到H5页面
      // ⚠️ 临时禁用：H5页面尚未部署
      // this.checkMobileAndRedirect();
      
      if (this.$auth.loggedIn) {
        this.getCartCount();
      }
      this.getMerCustomer()
      
      // 确保 attrValueSelected 被初始化
      this.initializeAttrValueSelected();
      
      this.$nextTick(() => {
        document.body.setAttribute("style", "background:#ffffff");
      });
      this.checkedImage = JSON.parse(this.productInfo.sliderImage)[this.slideIndex]
    },
    beforeDestroy() {
      document.body.removeAttribute("style");
    },
    methods: {
      /**
       * 翻译商品规格属性名称
       * @param {String} attrName - 属性名称（如"默认"、"颜色"、"尺寸"等）
       * @returns {String} 翻译后的属性名称
       */
      translateAttrName(attrName) {
        if (!attrName) return '';
        
        // 常见规格名称的翻译映射
        const translations = {
          '默认': this.$t('page.goodsDetail.default'),
          '规格': this.$t('page.goodsDetail.spec') || attrName,
          '颜色': this.$t('page.goodsDetail.color') || attrName,
          '尺寸': this.$t('page.goodsDetail.size'),
          '尺码': this.$t('page.goodsDetail.size'),
          '容量': this.$t('page.goodsDetail.capacity'),
          '材质': this.$t('page.goodsDetail.material') || attrName,
        };
        
        return translations[attrName] || attrName;
      },
      
      /**
       * 初始化 attrValueSelected（选中的规格）
       * 适用于单规格商品或多规格商品的默认值设置
       */
      initializeAttrValueSelected() {
        // 如果已经有值，不重复初始化
        if (this.attrValueSelected) {
          return;
        }

        // 确保 productValue 存在且有数据
        if (!this.productValue || Object.keys(this.productValue).length === 0) {
          return;
        }

        // 尝试根据 attrSelected 匹配
        if (this.attrSelected && this.attrSelected.length > 0) {
          const name = this.attrSelected.join(',');
          const matchedValue = this.productValue[name];
          if (matchedValue) {
            this.attrValueSelected = matchedValue;
            this.stock = matchedValue.stock;
            this.unique = matchedValue.id;
            this.checkedImage = matchedValue.image || '';
            return;
          }
        }

        // 如果没有匹配到，使用第一个可用的规格
        const firstKey = Object.keys(this.productValue)[0];
        if (firstKey && this.productValue[firstKey]) {
          this.attrValueSelected = this.productValue[firstKey];
          this.stock = this.productValue[firstKey].stock || (this.productInfo ? this.productInfo.stock : 0);
          this.unique = this.productValue[firstKey].id;
          this.checkedImage = this.productValue[firstKey].image || '';
        }
      },
      /**
       * 刷新商品详情（语言切换时调用）
       * @param {String} newLocale 新语言代码
       */
      async refreshProductDetail(newLocale) {
        try {
          const productId = this.id || this.$route.params.id;
          if (!productId) {
            return;
          }
          
          // 构建API请求参数
          const requestParams = newLocale && newLocale !== 'zh-CN' 
            ? { language: newLocale } 
            : {};
          
          // 调用API获取翻译后的商品详情
          const response = await this.$axios.get(`/api/front/product/detail/${productId}`, {
            params: requestParams
          });
          
          // 更新商品信息
          if (response.data) {
            this.productInfo = response.data.productInfo || this.productInfo;
            this.productAttr = response.data.productAttr || this.productAttr;
            this.productValue = response.data.productValue || this.productValue;
            this.currentLocale = newLocale;
            
            // 更新页面标题
            if (this.productInfo && this.productInfo.storeName) {
              document.title = this.productInfo.storeName;
            }
          }
        } catch (error) {
          console.error('刷新商品详情失败:', error);
          // 失败时不显示错误，避免影响用户体验
        }
      },
      /**
       * 检测移动设备并自动跳转到H5页面
       */
      checkMobileAndRedirect() {
        // 检测是否为移动设备
        const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
        
        if (isMobile) {
          // 提取商品ID
          const productId = this.$route.params.id;
          
          // 获取当前域名和协议
          const protocol = window.location.protocol;
          const hostname = window.location.hostname;
          const port = window.location.port ? `:${window.location.port}` : '';
          
          // 构造移动端URL
          // ⚠️ 重要：根据您的实际部署情况修改路径
          // 如果H5是uniapp编译的，路径可能是 /h5/#/pages/goods_details/index
          // 如果H5是独立部署的，可能需要完整的域名
          const mobileUrl = `${protocol}//${hostname}${port}/h5/#/pages/goods_details/index?id=${productId}`;
          
          console.log('🔍 检测到移动设备访问商品详情页:', {
            userAgent: navigator.userAgent,
            isMobile: true,
            productId: productId,
            redirectUrl: mobileUrl
          });
          
          // 显示提示信息
          this.$message({
            message: this.$t('page.goodsDetail.mobileRedirect') || '检测到移动设备，正在跳转到移动端页面...',
            type: 'info',
            duration: 1500
          });
          
          // 延迟跳转，让用户看到提示
          setTimeout(() => {
            window.location.href = mobileUrl;
          }, 1500);
        } else {
          console.log('🖥️ 检测到PC设备访问商品详情页');
        }
      },
      
      call:Debounce(function(){
          this.comsys.chatConfig(this.serviceInfo)
      }),
      getMerCustomer() {
        this.$axios.get(`/api/front/merchant/customer/service/info/${this.merId}`).then(res => {
          this.serviceInfo = res.data
        });
      },
      /**
       *
       * 购物车数量
       */
      getCartCount() {
        this.$axios.get(`/api/front/cart/count`,{
          params:{
            type: 'total',
            numType: true
          }
        }).then(res => {
          this.CartCount = res.data.count
          this.$store.commit('cartNum', this.CartCount);
        });
      },
      // 立即购买
      buy:Debounce(function(type, event) {
        this.loading = true
        if (!this.$auth.loggedIn) {
          this.$store.commit("isLogin", true);
          this.$store.commit("isTourists", true);
        } else {
          this.goCat(type);
        }
      }),
      // 加入购物车
      goCat(num){
        if (num === 1) {
          this.$axios
            .post("/api/front/cart/save", [{
              productId: parseFloat(this.$route.params.id),
              cartNum: parseFloat(this.count),
              productAttrUnique: parseFloat(this.unique)
            }])
            .then(res => {
              this.$message.success(this.$t(`message.tips.shoppingSU`));
              this.getCartCount();
            })
            .catch(err => {
              this.$message.error(err);
            });
        }else{
          this.getPreOrder()
        }
      },
      getPreOrder: function() {
        getPreOrder('buyNow', [{
          "attrValueId": parseFloat(this.unique),
          "productId": parseFloat(this.$route.params.id),
          "productNum": parseFloat(this.count)
        }], this);
      },
      /**
       *
       * 进店逛逛
       */
      goStore(){
        goMerchant(this.merId, this)
      },
      /**
       *
       * 收藏 | 取消收藏
       */
      collect:Debounce(function() {
        if (!this.$auth.loggedIn) {
          this.$store.commit("isLogin", true);
        }else {
          followPro(this, this.userCollect, this.$route.params.id).then(() => {
            this.$set(this, 'userCollect', !this.userCollect);
          });
        }
      }),

      swiperMouseover(index) {
        this.slideIndex = index;
        this.checkedImage = JSON.parse(this.productInfo.sliderImage)[this.slideIndex]
      },
      tab(type) {
        this.tabIndex = type;
      },
      minus() {
        this.count--;
      },
      plus() {
        this.count++;
      },
      inputNum() {
        this.count = parseInt(this.count) >= this.stock ? this.stock : this.count;
        this.count = parseInt(this.count) <= 1 ? 1 : this.count;
      },
      goPage(menu, index) {
        this.$router.push({
          path: `${menu.link}`,
          query: {id: this.mer_id}
        });
      },
      /**
       *
       * 关注店铺
       */
      followToggle(id){
        if (!this.$auth.loggedIn) {
          this.$store.commit("isLogin", true);
        }else{
          followMer(this, this.merchantInfo.isCollect, id).then(() => {
            this.$set(this.merchantInfo, 'isCollect', !this.merchantInfo.isCollect);
          });
        }
      },
      /**
       *
       * 优惠卷
       */
      getCoupons() {
        let that = this;
        that.$axios.get(`/api/front/coupons`, {
          params: {
            merId: that.merId,
            productId: that.$route.params.id,
            useType: 2,
            page: 1,
            limit: 20,
          }
        }).then(res => {
          that.couponList = res.data.list
        })
          .catch(err => {
            that.$message.error(err);
          });
      },
      replyTypeChange(type, count) {
        this.reply.type = type;
        this.reply.page = 1;
        this.replyList = [];
        this.getReply()
      },
      callPaginate(num) {
        this.reply.page = num;
        this.getReply(num);
      },
      /**
       *
       * 评论列表
       */
      getReply(num) {
        this.reply.loading = true;
        this.reply.page = num ? num : this.reply.page;
        this.$axios
          .get(`/api/front/product/reply/list/${this.$route.params.id}`, {
            params: {
              page: this.reply.page,
              limit: this.reply.limit,
              type: this.reply.type
            }
          })
          .then(res => {
            this.replyList = res.data.list;
            this.replyCount = res.data.total
          })
          .catch(err => {
            this.$message.error(err);
          });
      },
      /**
       *
       * 评论数量
       */
      getReplyConfig() {
        this.$axios
          .get(`/api/front/product/reply/config/${this.$route.params.id}`)
          .then(res => {
            this.replyInfo = res.data
          })
          .catch(err => {
            this.$message.error(err);
          });
      },
    }
  }
</script>

<style lang="scss" scoped>
  .coupons-get{
    font-size: 14px;
    font-weight: 400;
    color: #666666;
  }
  .coupons-box{
    /*width: 467px;*/
  }
  .coupon_list{
    padding: 5px 10px 5px 30px;
    ::v-deep.list{
      flex-direction: column;
    }
  }
  .ml30{
    margin-left: 30px;
  }
  .mb22{
    margin-bottom: 22px;
  }
  .mb12{
    margin-bottom: 12px;
  }
  .activity{
    height: 24px;
    padding: 0 10px;
    background: #E93323;
    color: #fff;
    font-size: 14px;
    line-height: 24px;
    position: relative;
    margin: 0 10px 5px 0;
  }
  .activity:before {
    content: ' ';
    position: absolute;
    width: 3px;
    height: 5px;
    border-radius: 0 3px 3px 0;
    border: 1px solid #E93323;
    background-color: #fff !important;
    bottom: 50%;
    left: -2px;
    margin-bottom: -3px;
    border-left-color: #fff !important;
  }
  .activity:after {
    content: ' ';
    position: absolute;
    width: 3px;
    height: 5px;
    border-radius: 3px 0 0 3px;
    border: 1px solid #E93323;
    background-color: #fff;
    right: -2px;
    bottom: 50%;
    margin-bottom: -3px;
    border-right-color: #fff !important;
  }
  .store-banner{
    width: 100%;
    height: 130px;
    img{
      object-fit: none;
      width: 100%;
      height: 100%;
    }
  }
  .menu-count{
    width: 100%;
    height: 40px;
    background: #DFDFDF;
  }
  .store-name{
    display: inline-block;
    width: 117px;
    position: relative;
    top: 11px;
    font-size: 16px;
    margin-bottom: 10px;
  }
  .user-menu{
    position: relative;
    -webkit-justify-content: space-between;
    justify-content: space-between;
    width: 1200px;
    margin: 0 auto;
    .category{
      position: absolute;
      top: 40px;
      left: 0;
      background-color: rgba(254,248,248,.96);
      width: 100%;
      padding: 40px 20px 20px;
      z-index: 10;

      .name{
        width: 130px;
        position: relative;
        padding-right: 20px;
        margin-right: 30px;
        cursor: pointer;
        .iconfont{
          font-size: 10px;
          position: absolute;
          right: 0;
          top: 3px;
          color: #282828;
        }
      }
      .sortCon{
        width: 1000px;
        .sub-item{
          margin: 0 15px 15px;
          color: #666666;
          cursor: pointer;
        }
      }
      .erSort{
        align-items: center;
      }
      .item{
        margin-bottom: 20px;
        align-items: baseline;
      }
      .moreBtn{
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
    .menu-main{
      width: 300px;
      height: 40px;
      -webkit-justify-content: space-between;
      justify-content: space-between;
      .menu-item{
        display: inline-block;
        height: 26px;
        line-height: 26px;
        color: #282828;
        padding: 0 10px;
        cursor: pointer;
        &.active{
          color: #fff;
          background: #282828;
          color: #fff;
          border-radius: 15px;
        }
      }
    }
    .menu-search{
      width: 220px;
      height: 24px;
      background-color: #fff;
      border-radius: 17px;
      .text{
        width: 175px;
      }
      input{
        border: none;
        height: 24px;
        line-height: 24px;
        color: #999999;
        padding: 0 15px;
        border-radius: 17px 0 0 17px;
        &:focus{
          border: none;
          outline: none;;
        }
      }
      .bnt{
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
  .product_content .title{
    text-align: center;
    font-size: 18px;
    margin: 5px 0;
  }
  .dropdown-box{
    ::v-deep.el-dropdown-menu{
      z-index: 10 !important;
    }
  }
  .goods-detail {
    padding-top: 40px;
    border-top: 1px solid #efefef;
    .goods-main {
      flex: 1;
      min-width: 0;
    }
    .carousel {
      width: 440px;

      .preview {
        display: block;
        width: 440px;
        height: 440px;
      }

      .swiper-container {
        padding-right: 25px;
        padding-left: 25px;
        margin-top: 10px;
        margin-bottom: 20px;

        .swiper-button-prev,
        .swiper-button-next {
          top: 0;
          width: 25px;
          height: 100%;
          margin-top: 0;
          background-color: rgba(0, 0, 0, 0.3);
          background-size: 12px 22px;
        }

        .swiper-button-prev {
          left: 0;
        }

        .swiper-button-next {
          right: 0;
        }

        .swiper-slide {
          width: 70px;
          height: 70px;
          border: 2px solid transparent;
          box-sizing: border-box;
          overflow: hidden;
          cursor: pointer;

          &.on {
            border-color: #e93323;
          }

          ~ .swiper-slide {
            margin-left: 10px;
          }

          img {
            display: block;
            width: 70px;
            height: 70px;
          }
        }
      }

      .btn {
        margin-right: 30px;
        font-size: 12px;
        color: #4b4b4b;
        cursor: pointer;
        position: relative;

        .qrcode1 {
          display: none;
          box-shadow: 0px 3px 16px rgba(0, 0, 0, 0.08);
          background: #fff;
          padding: 6px;
          position: relative;
          width: 100px;
          img{
            width: 100%;
          }

          &.contactService {
            position: absolute;
            left: 50%;
            top: 25px;
            z-index: 10;
            width: 100px;
            height: 100px;
            margin-left: -50px;
          }
        }
      }

      .contactBtn:hover {
        .qrcode1 {
          display: inline;
        }
      }

      .iconfont {
        margin-right: 6px;
        font-size: 14px;
        color: #e93323;
      }
    }

    .text-wrapper {
      flex: 1;
      min-width: 0;
      margin-left: 30px;
      width: 735px;

      .title {
        font-size: 20px;
        line-height: 28px;
        color: #333333;
        font-weight: bold;
      }
      .integral_count{
        display: inline-block;
        margin-top: 18px;
        color: #FF6200;
        line-height: 27px;
        background: #FFF4E6;
        padding: 0 15px;
        border-radius: 2px;
      }
      .money-wrapper {
        width: 730px;
        margin-top: 6px;
        background: #FFF4F4;
        border-radius: 1px;
        color: #ffffff;
        justify-content: space-between;
        .priceBox{
          padding: 14px 0;
        }
        .prict-title{
          width: 119px;
          font-size: 14px;
          font-family: ArialMT;
          color: #666666;
          padding-left: 13px;
        }
        .money-wrap {
          flex: 1;
          min-width: 0;
          padding-left: 8px;
        }

        del {
          color: #999999;
          margin-bottom: 10px;
          font-size: 14px;
        }

        .price {
          span {
            font-weight: bold;
            font-size: 24px;
            color: #E93323;
          }
        }

        .vip {
          width: 100px;
          height: 25px;
          border-radius: 2px;
          margin-left: 14px;
          background: linear-gradient(205deg, #fdcaa4 0%, #fce3c3 100%);
          overflow: hidden;
          font-size: 12px;
          color: #0f0f0f;

          .iconfont {
            width: 32px;
            height: 25px;
          }

          .iconfontVip {
            width: 32px;
            height: 25px;
          }

          .money {
            flex: 1;
            min-width: 0;

            span {
              font-size: 14px;
            }
          }
        }
        .saleBox{
          ::v-deep .el-divider--vertical{
            height: 70px;
            background: #E93323;
            border-radius: 1px;
            opacity: 0.2;
          }
        }
        .sales {
          position: relative;
          height: 100%;
          padding-right: 20px;
          padding-left: 12px;
          font-size: 14px;
          color: #E93323;

          &::before {
            content: "";
            position: absolute;
            top: 14px;
            bottom: 12px;
            left: 0;
            width: 1px;
            border-left: 1px solid rgba(255, 255, 255, 0.24);
          }

          .num {
            margin-bottom: 3px;
            font-weight: bold;
            font-size: 20px;
          }
        }

        .timer-wrapper {
          width: 180px;
          margin-right: 15px;
          font-size: 12px;
          color: #ffffff;

          ::v-deep .styleAll {
            width: 24px;
            height: 24px;
            margin-right: 3px;
            margin-left: 3px;
            background-color: #ffffff;
            font-size: 16px;
            line-height: 24px;
            text-align: center;
            color: #e93323;

            &:first-child {
              margin-left: 0;
            }

            &:last-child {
              margin-right: 0;
            }
          }

          .progress-group {
            margin-top: 10px;
          }

          .progress {
            width: 120px;
            height: 8px;
            border: 1px solid #ffffff;
            border-radius: 4px;
            font-size: 0;

            span {
              display: inline-block;
              width: 50%;
              height: 100%;
              border-radius: 4px;
              background-color: #ffffff;
            }
          }
        }
      }

      .coupon-wrapper {
        background-color: #f7f7f7;

        .coupon-bd {
          padding-top: 18px;
          padding-bottom: 18px;
          font-size: 12px;
          color: #5a5a5a;

          .label {
            width: 80px;
            padding-left: 20px;
          }

          .list {
            flex: 1;
            min-width: 0;
            padding-right: 24px;
            max-height: 240px;
            overflow-y: auto;
            overflow-x: hidden;

            &.on {
              max-height: 100px;
              overflow: hidden;
            }
          }

          .item {
            margin-top: 11px;

            &:first-child {
              margin-top: 0;
            }
          }

          .cell-left {
            width: 65px;
          }

          .cell-right {
            flex: 1;
            min-width: 0;
            color: #e93323;
            max-width: 94px;
            justify-content: left;
            padding: 0 3px;
          }

          .cell {
            width: 165px;
            height: 24px;
            font-size: 13px;
            color: #ffffff;

            &.svip {
              color: #FDD7B4;

              .cell-right {
                color: #333333;
              }
            }
          }

          .time {
            flex: 1;
            min-width: 0;
            padding-right: 8px;
            padding-left: 8px;
            font-size: 12px;
            color: #727272;
          }

          button {
            border: none;
            border-bottom: 1px solid #e93323;
            background: none;
            font-size: 12px;
            color: #e93323;

            &:disabled {
              border-color: #c0c4cc;
              color: #c0c4cc;
              cursor: not-allowed;
            }
          }
        }

        .coupon-ft {
          height: 36px;
          padding-right: 24px;
          background-color: #f2f2f2;

          .button {
            font-size: 12px;
            color: #666666;
            cursor: pointer;

            .iconfont {
              margin-left: 7px;
              font-size: 10px;
              color: #666666;
            }
          }
        }
      }

      .attribute {
        margin-top: 24px;

        .size-wrapper {
          .label {
            width: 119px;
            font-size: 14px;
            color: #5a5a5a;
            margin-right: 2px;
            word-break: break-all;
            padding-top: 2px;
            padding-left: 13px;
          }

          .list {
            flex: 1;
            min-width: 0;
          }

          .item {
            margin-right: 12px;
            margin-bottom: 16px;
            box-sizing: border-box;
            cursor: pointer;

            .cont {
              position: relative;
              height: 32px;
              border: 1px solid #d3d3d3;
            }

            &:hover {
              .cont {
                border-color: #e93323;
                color: #e93323;
              }
            }

            input:checked {
              + .cont {
                border-color: #e93323;
                color: #e93323;

                .iconfont {
                  display: block;
                }
              }
            }
          }

          .image {
            width: 34px;
            height: 34px;
          }

          img {
            display: block;
            width: 100%;
            height: 100%;
          }

          .name {
            padding-right: 20px;
            padding-left: 20px;
            font-size: 12px;
          }

          .iconfont {
            position: absolute;
            right: -3px;
            bottom: -3px;
            display: none;
            font-size: 22px;
          }
        }
      }
      .guaranteeList{
        margin-top: 24px !important;
      }
      .product-specs-wrapper {
        margin-top: 16px;
        padding: 16px;
        background: #f8f9fa;
        border-radius: 8px;
        border: 1px solid #e9ecef;
        
        .specs-title {
          font-size: 16px;
          font-weight: 600;
          color: #333;
          margin-bottom: 12px;
        }
        
        .specs-content {
          .spec-item {
            display: flex;
            margin-bottom: 8px;
            
            .spec-label {
              font-size: 14px;
              color: #666;
              min-width: 100px;
              font-weight: 500;
            }
            
            .spec-value {
              font-size: 14px;
              color: #333;
              flex: 1;
            }
          }
        }
      }
      
      .number-wrapper {
        margin-top: 8px;
        position: relative;
        .guaranee_tel{
          position: absolute;
          top: 20px;
          left: 0;
          background: #ffffff;
          z-index: 10;
          padding: 0 24px 24px;
          display: none;
          box-shadow: 0px 3px 16px rgba(0, 0, 0, 0.08);
          .item{
            margin-top: 24px;
            .name{
              font-size: 16px;
              color: #000000;
            }
            .info{
              font-size: 12px;
              color: #969696;
              margin-top: 6px;
            }
          }
        }
        .icon-duoshanghupc-shuomingdanchuang{
          color: #E93323;
          font-size: 12px;
          position: relative;

        }
        .label{
          cursor: pointer;
        }
        .guaranteeAttr{
          display: inline-block;
          width: 445px;

        }
        .atterTxt1{
          margin-bottom: 9px;
          .icon-gou{
            display: inline-block;
            font-size: 12px;
            color: #E93323;
            margin-right: 2px;
          }
        }

        .label {
          width: 119px;
          font-size: 14px;
          color: #5a5a5a;
          margin-right: 2px;
          word-break: break-all;
          padding-top: 2px;
          padding-left: 13px;
        }

        .counter-wrap {
          flex: 1;
          min-width: 0;

          span {
            vertical-align: bottom;
            font-size: 14px;
            color: #5a5a5a;
            margin-top: 9px;
            margin-left: 15px;
          }
        }

        .counter {
          display: inline-block;
          border: 1px solid #d3d3d3;
          font-size: 0;

          button {
            width: 44px;
            height: 36px;
            border: none;
            background: none;
            outline: none;
            font-weight: inherit;
            font-size: 12px;
            font-family: inherit;
            color: #707070;
            vertical-align: middle;

            &:disabled {
              color: #d0d0d0;
              cursor: not-allowed;
            }
          }

          input {
            width: 64px;
            height: 36px;
            border: none;
            border-right: 1px solid #d3d3d3;
            border-left: 1px solid #d3d3d3;
            outline: none;
            font-weight: inherit;
            font-size: 18px;
            font-family: inherit;
            text-align: center;
            color: #5a5a5a;
            vertical-align: middle;
          }
        }
      }

      .button-wrapper {
        margin-top: 36px;
        font-size: 0;

        .btn {
          width: 158px;
          height: 50px;
          border: 1px solid #e93323;
          border-radius: 4px;
          font-size: 16px;
          color: #e93323;
          margin-left: 119px;
          &.btn-out{
            width: 120px;
            color: #ffffff;
            background: #D0D0D0;
          }
          &.btn-notify{
            width: 120px;
            border-color: #E93323;
            color: #E93323;
          }

          ~ .btn {
            margin-left: 18px;
          }
        }


        button {
          background: none;
          outline: none;
          vertical-align: middle;

          &:disabled {
            border-color: #ebeef5;
            color: #c0c4cc;
            cursor: not-allowed;
          }

          &.cart {
            background-color: #e93323;
            color: #ffffff;

            &:disabled {
              border-color: #fab6b6;
              background-color: #fab6b6;
            }
          }

          ~ button {
            margin-left: 18px;
          }
        }

        a {
          display: inline-block;
          background-color: #e93323;
          vertical-align: middle;
          line-height: 50px;
          text-align: center;

          &.btn {
            color: #ffffff;
          }
        }
      }
    }

    .detail-wrapper {
      margin-top: 70px;
      .detail-hd {
        width: 950px;
        height: 56px;
        background-color: #f7f7f7;
        .tab {
          flex: 1;
          min-width: 0;
        }

        .item {
          position: relative;
          height: 56px;
          padding-right: 30px;
          padding-left: 30px;
          font-size: 14px;
          color: #333333;
          cursor: pointer;

          &.on {
            background: url("~assets/images/checked.png") center top/100% 7px no-repeat;
            color: #e93323;
          }

          &::before {
            content: "";
            position: absolute;
            top: 18px;
            bottom: 18px;
            left: 0;
            width: 1px;
            border-left: 1px solid #d9d9d9;
          }

          &:first-child::before {
            display: none;
          }

          &:hover {
            color: #e93323;
          }
        }

        .qrcode-button {
          position: relative;
          width: 160px;
          height: 56px;
          background-color: #ededed;
          font-size: 14px;
          color: #333333;
          cursor: pointer;

          &:hover {
            .qrcode {
              display: block;
            }
          }

          .icon-saoma {
            margin-right: 6px;
            font-size: 13px;
            line-height: 1;
            color: #000000;
          }

          .icon-xiangxia2,
          .icon-xiangshang1 {
            margin-left: 10px;
            font-size: 10px;
            line-height: 12px;
            color: #d0d0d0;
          }

          .qrcode {
            position: absolute;
            z-index: 99;
            display: none;
            padding: 6px;
            background-color: #ffffff;
            border: 1px solid #ededed;
            margin-top: 6px;
            width: 160px;
            height: 160px;
            top: 50px;
            left: 0px;
            box-sizing: border-box;

            ::v-deep img {
              display: block;
              width: 100%;
              height: 100%;
            }
          }
        }
      }

      .detail-bd {
        width: 950px;
        .detail-html {
          ::v-deep div {
            width: 100% !important;
          }
          ::v-deep img {
            display: block;
            width: 100% !important;
          }
        }
      }

      .comment {
        .comment-hd {
          padding-top: 30px;
          padding-bottom: 30px;

          .rate {
            font-size: 0;

            span {
              font-size: 14px;
              color: #e93323;

              ~ span {
                margin-left: 5px;
              }
            }
          }

          .score {
            font-size: 14px;
            color: #7e7e7e;

            .cont {
              margin-left: 8px;
            }

            .iconfont {
              font-size: 12px;
              color: #e6e6e6;

              ~ .iconfont {
                margin-left: 5px;
              }

              &.on {
                color: #e93323;
              }
            }
          }

          .menu {
            margin-top: 20px;
            font-size: 0;

            .item {
              display: inline-block;
              width: 86px;
              height: 34px;
              border-radius: 2px;
              background-color: #f7f7f7;
              font-size: 14px;
              line-height: 34px;
              text-align: center;
              color: #282828;
              cursor: pointer;

              &:hover {
                color: #e93323;
              }

              &.on {
                background-color: #e93323;
                color: #ffffff;
              }

              ~ .item {
                margin-left: 14px;
              }
            }
          }
        }

        .comment-bd {
          > img {
            width: 200px;
            margin: 50px auto;
          }

          .item {
            padding-bottom: 20px;

            .item-hd {
              .image {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                overflow: hidden;
              }

              img {
                display: block;
                width: 100%;
                height: 100%;
              }

              .text {
                flex: 1;
                margin-left: 12px;
                font-size: 14px;
                color: #868686;
              }

              .name {
                margin-bottom: 4px;
                font-size: 16px;
                color: #282828;
              }

              .star {
                margin-left: 12px;
                font-size: 0;
              }

              .iconfont {
                font-size: 12px;
                color: #e6e6e6;

                &.on {
                  color: #e93323;
                }

                ~ .iconfont {
                  margin-left: 5px;
                }
              }
            }

            .item-bd {
              padding-bottom: 20px;
              border-bottom: 1px solid #e3e3e3;
              margin-left: 52px;
              font-size: 14px;
              color: #282828;

              > div {
                margin-top: 15px;
              }

              .image-wrapper {
                font-size: 0;
              }

              .image {
                display: inline-block;
                width: 54px;
                height: 54px;
                margin-right: 8px;
                margin-bottom: 10px;

                img {
                  display: block;
                  width: 100%;
                  height: 100%;
                }
              }

              .reply {
                background-color: #f7f7f7;
                margin-top: 10px !important;

                .item {
                  padding: 7px 12px;
                  font-size: 14px;
                  color: #282828;

                  span {
                    color: #e93323;
                  }
                }
              }
            }
          }
        }
      }
    }
    .user-info{
      width: 220px;
      display: flex;
      flex-direction: column;
      align-items: center;
      height: 300px;
      background: #fff;
      color: #282828;
      font-size: 14px;
      border: 1px solid #efefef;
      border-radius: 4px;
      padding: 15px;
      .store-basis{
        width: 100%;
        justify-content: center;
        height: 175px;
        border-bottom: 1px dashed #ECECEC;
        ::v-deep.el-rate__icon{
          font-size: 15px !important;
          margin-right: 2px !important;
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
      }
      .store-logo{
        width: 61px;
        height: 61px;
        border-radius: 50%;
        overflow: hidden;
        margin-bottom: 10px;
        margin-right: 10px;
        img{
          width: 61px;
          height: 61px;
          border-radius: 50%;
        }
      }
      .name{
        margin-top: 10px;
        padding: 0 15px;
      }
    }
    .store-info{
      padding: 20px 0 0;
      position: relative;
      .service{
        right:210px;
        position:absolute;
        top:0;
        .ewm{
          width:140px;
          border:1px solid #eeeeee;
          background-color:#fff;
          padding: 10px 15px;
          -webkit-justify-content: space-between;
          justify-content: space-between;
          align-items: center;
          color: #282828;
          // font-family: 'Microsoft YaHei';
          .tip{
            font-size: 14px;
            color: #666666;
            margin-top: 10px;
          }

        }
      }
      .items {
        font-size: 12px;
        color: #7e7e7e;
        margin-bottom: 12px;
        justify-content: space-between;
        .iconfont{
          cursor: pointer;
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
        .titles{
          color: #999999;
          font-size: 12px;
          margin-right: 15px;
        }
        .desc{
          color:#333333;
          position: relative;
          .store_qualify{
            width: 16px;
            height: 16px;
            &:hover + .license{
              display: inline-block;
            }
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
    .recom-section {
      align-self: flex-start;
      width: 220px;
      .store-recommend{
        margin-top: 30px;
        padding: 0 20px;
        border: 1px solid #efefef;
        border-radius: 4px;
      }
      .title {
        height: 60px;
        font-size: 18px;
        line-height: 60px;
        text-align: center;
        color: #333333;
        font-weight: bold;
        span {
          position: relative;
        }
      }

      .item {
        display: block;
        width: 170px;
        margin-bottom: 20px;

        .image {
          width: 180px;
          height: 180px;

          img {
            display: block;
            width: 100%;
            height: 100%;
          }
        }

        .text {
          .name {
            margin-top: 10px;
            margin-bottom: 15px;
            font-size: 14px;
            color: #333333;
          }

          .money {
            font-weight: bold;
            font-size: 14px;
            color: #e93323;

            span {
              font-size: 18px;
            }
          }

          .sales {
            font-size: 12px;
            color: #888888;
          }
        }
      }
    }

    .el-pagination {
      padding: 0;
      border: 1px solid #cccccc;

      ::v-deep button {
        width: 78px;
        height: 38px;
        padding: 0;
        font-size: 15px;
        color: #707070;

        &.btn-prev {
          border-right: 1px solid #cccccc;
        }

        &.btn-next {
          border-left: 1px solid #cccccc;
        }
      }

      ::v-deep li {
        width: 38px;
        height: 38px;
        padding: 0;
        font-weight: normal;
        font-size: 15px;
        line-height: 38px;
        color: #707070;

        ~ li {
          border-left: 1px solid #cccccc;
        }

        &.active {
          background-color: #e93323;
          color: #ffffff;
        }
      }
    }

    .nothing {
      margin-top: 100px;
      font-size: 16px;
      text-align: center;
      color: #999999;

      img {
        margin: 0 auto;
      }
    }
  }
  .store-favorites{
    margin-top: 20px;
    .collection{
      width: 180px;
      height: 30px;
      line-height: 30px;
      text-align: center;
      color: #333333;
      border: 1px solid #C8C8C8;
      border-radius: 2px;
      background: #fff;
      &.care{
        color: #E93323;
        border-color: #e93323;
      }
    }
  }
</style>
       
