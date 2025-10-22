<template>
	<view :data-theme="theme">
		<tui-skeleton v-if="skeletonShow"></tui-skeleton>
		<view class="product-con tui-skeleton">
			<view class='navbar' :class="opacity>0.6?'bgwhite':''">
				<view class='navbarH' :style='"height:"+navH+"rpx;"'>
					<view class='navbarCon acea-row' :style="{ paddingRight: navbarRight + 'px' }">
						<view id="home" class="home acea-row row-center-wrapper iconfont icon-dingbufanhui h5_back tui-skeleton-circular" :class="opacity>0.5?'on':''"
							:style="{ top: homeTop + 'rpx' }" v-if="returnShow" @tap="returns">
						</view>
						<navigator url="/pages/goods_search/index" class="input" hover-class="none" :style="{ top: homeTop + 'rpx' }"><text
							class="iconfont icon-xiazai5 tui-skeleton-fillet"></text>
						{{$t(`page.goodsDetail.search`)}}</navigator>
						<view class="right_select tui-skeleton-rect" :style="{ top: homeTop + 'rpx' }" @click="showNav">
							<text class="iconfont icon-more"></text>
						</view>
					</view>
				</view>
				<view class="tab_nav" v-show="opacity > 0.6">
					<view class="header flex justify-between align-center">
						<view class="item" :class="navActive === index ? 'on' : ''" v-for="(item,index) in navList"
							:key='index' @tap="tap(index)">{{$t(`page.goodsDetail.navList[${index}].name`)}}
						</view>
					</view>
				</view>
			</view>
			<view class="detail_container" >
				<scroll-view :scroll-top="scrollTop" scroll-y='true' scroll-with-animation="true"
					:style='"height:"+height+"px;"' @scroll="scroll">
					<view id="past0">
						<productConSwiper class="tui-skeleton-rect" :imgUrls="sliderImage" :videoline="videoLink"
							@videoPause="videoPause"></productConSwiper> 
						<view class="pad24">
							<view class='wrapper mb30 borRadius14'>
								<view class='share acea-row row-between row-bottom'>
									<view class='x-money tui-skeleton-rect flex align-baseline'>
										{{shopPayCurrency}}<text class='num font-44'>{{attr.productSelect.price}}</text>
									</view>
									<!-- <view class='iconfont icon-fenxiang' @click="listenerActionSheet"></view> -->
								</view>
								<view class='introduce tui-skeleton-rect'>{{productInfo.storeName}}</view>
								<view class='label acea-row row-between-wrapper'>
									<view class="tui-skeleton-rect">
										{{$t(`page.goodsDetail.oldPrice`)}}: {{shopPayCurrency}}{{attr.productSelect.otPrice || 0}}</view>
									<view class="tui-skeleton-rect">
										{{$t(`page.goodsDetail.inventory`)}}:{{attr.productSelect.stock || 0}}{{productInfo.unitName || ''}}</view>
									<view class="tui-skeleton-rect">
										{{$t(`page.goodsDetail.sales`)}}:{{Math.floor(productInfo.sales) + Math.floor(productInfo.ficti) || 0}}{{productInfo.unitName || ''}}
									</view>
								</view>
								<view v-if="defaultCoupon.length>0 && type=='normal'"
									class='coupon acea-row row-between-wrapper tui-skeleton-fillet' @click='couponTap'>
									<view class='hide line1 acea-row'>
										<text class="text-333 fw-bold">{{$t(`page.goodsDetail.coupons`)}}</text>
										<view class='activity'>{{shopPayCurrency}} {{defaultCoupon[0].money}}</view>
										<!-- 满{{defaultCoupon[0].minPrice}}减 -->
									</view>
									<view class='iconfont icon-gengduo'></view>
								</view>
							</view>
							<view class='attribute mb30 borRadius14' @click="selecAttr">
								<view class="acea-row row-between-wrapper">
									<view class="line1 tui-skeleton-fillet"><text class="text-333 fw-bold">{{$t(`page.goodsDetail.choose`)}}：</text>
										<text class='text-666 tui-skeleton-fillet'>{{attrValue}}</text>
									</view>
									<view class='iconfont icon-gengduo'></view>
								</view>
								<view class="acea-row row-between-wrapper" style="margin-top:7px;padding-left:55px;" v-if="skuArr.length > 1">
									<view class="flex">
										<image :src="item.image" v-for="(item,index) in skuArr.slice(0,4)" :key="index" class="attrImg"></image>
									</view>
									<view class="switchTxt tui-skeleton-fillet">{{skuArr.length}}{{$t(`page.goodsDetail.type`)}}</view>
								</view>
							</view>
						<!-- 商品规格信息 -->
						<view v-if="attr.productSelect && (attr.productSelect.productName || attr.productSelect.material || attr.productSelect.capacity || attr.productSelect.origin || attr.productSelect.skuLadderPrice || attr.productSelect.size || attr.productSelect.packQuantity)" class='product-specs mb30 borRadius14'>
							<view class="specs-title text-333 fw-bold">商品规格信息</view>
							<view class="specs-content">
								<view v-if="attr.productSelect.productName" class="spec-item acea-row">
									<text class="spec-label text-666">品名：</text>
									<text class="spec-value text-333">{{attr.productSelect.productName}}</text>
								</view>
								<view v-if="attr.productSelect.material" class="spec-item acea-row">
									<text class="spec-label text-666">材质(成分)：</text>
									<text class="spec-value text-333">{{attr.productSelect.material}}</text>
								</view>
								<view v-if="attr.productSelect.capacity" class="spec-item acea-row">
									<text class="spec-label text-666">容量：</text>
									<text class="spec-value text-333">{{attr.productSelect.capacity}}</text>
								</view>
								<view v-if="attr.productSelect.origin" class="spec-item acea-row">
									<text class="spec-label text-666">产地：</text>
									<text class="spec-value text-333">{{attr.productSelect.origin}}</text>
								</view>
								<view v-if="attr.productSelect.skuLadderPrice" class="spec-item acea-row">
									<text class="spec-label text-666">SKU(阶梯价格)：</text>
									<text class="spec-value text-333">{{attr.productSelect.skuLadderPrice}}</text>
								</view>
								<view v-if="attr.productSelect.size" class="spec-item acea-row">
									<text class="spec-label text-666">尺寸：</text>
									<text class="spec-value text-333">{{attr.productSelect.size}}</text>
								</view>
								<view v-if="attr.productSelect.packQuantity" class="spec-item acea-row">
									<text class="spec-label text-666">装箱数量：</text>
									<text class="spec-value text-333">{{attr.productSelect.packQuantity}}</text>
								</view>
							</view>
						</view>
							<view v-show="guaranteeList.length>0" class="attribute mb30 borRadius14" @click="assureDrawer = true">
								<view class="acea-row row-between-wrapper">
									<view class="line1 tui-skeleton-fillet"> <text class="text-333 fw-bold">{{$t(`page.goodsDetail.assure`)}}: </text>
										<text class='text-666 tui-skeleton-fillet' 
										v-for="(item,index) in guaranteeList" :key="index">{{item.name }} · </text>
									</view>
									<view class='iconfont icon-gengduo'></view>
								</view>
							</view>
							<view class='userEvaluation' id="past1">
								<view class='title acea-row row-between-wrapper'
									:style="replyCount==0?'border-bottom-left-radius:14rpx;border-bottom-right-radius:14rpx;':''">
									<view class="tui-skeleton-fillet fw-bold">{{$t(`page.goodsDetail.Reviews`)}}<i>({{replyCount}})</i></view>
									<navigator class='praise tui-skeleton-fillet' hover-class='none'
										:url='"/pages/users/goods_comment_list/index?productId="+id'>
										<i>{{$t(`page.goodsDetail.good`)}}</i>&nbsp;<text class='font_color px-12'>{{replyChance || 0}}%</text>
										<text class='iconfont icon-gengduo'></text>
									</navigator>
								</view>
								<block v-if="replyCount">
									<userEvaluation :reply="reply"></userEvaluation>
								</block>
							</view>
							
							<!-- 优品推荐 -->
							<view class="superior borRadius14" if='merchantInfo' id="past2">
								<merHome :merchantInfo="merchantInfo" :merid="productInfo.merId" type="home"></merHome>
								<view class="slider-banner banner">
									<view class="list acea-row row-middle" id="list0">
										<view class="item" v-for="(val,indexw) in merchantInfo.proList" :key="indexw"
											@click="goDetail(val)">
											<view class="pictrue">
												<image :src="val.image"></image>
												<!-- <easy-loadimage mode="widthFix" :image-src="val.image" ></easy-loadimage> -->
											</view>
											<view class="name line1">{{val.storeName}}</view>
											<view class="money theme_price">{{shopPayCurrency}}{{val.price}}</view>
										</view>
									</view>
								</view>
							</view>
						</view>
					</view>
					<view class='product-intro pad24' id="past3">
						<view class="borRadius14" style="overflow: hidden;">
							<view class='title'>
								<image src="../../static/images/xzuo.png"></image>
								<span class="sp">{{$t(`page.goodsDetail.details`)}}</span>
								<image src="../../static/images/xyou.png"></image>
							</view>
							<view class='conter'>
								<jyf-parser :html="description.replace(/<br\/>/ig, '')" ref="article" :tag-style="tagStyle"></jyf-parser>
							</view>
						</view>
					</view>
					<view style='height:120rpx;'></view>
				</scroll-view>
			</view>
			<view class='footer acea-row row-between-wrapper'>
				<view v-if="locale!=='lao'&&locale!=='th'" class="item tui-skeleton-fillet" @click="toHome()">
					<view class="iconfont icon-shouye8"></view>
					<view>{{$t(`page.goodsDetail.home`)}}</view>
				</view>
				<block v-if="type === 'normal'">
					<view @click="setCollect" class='item tui-skeleton-fillet'>
						<view class='iconfont icon-ic_love_2  font_color' v-if="userCollect"></view>
						<view class='iconfont icon-ic_love' v-else></view>
						<view>{{$t(`page.goodsDetail.like`)}}</view>
					</view>
					<navigator class="animated item tui-skeleton-fillet"
						:class="animated==true?'bounceIn':''" url='/pages/order_addcart/order_addcart'
						hover-class="none">
						<view class='iconfont icon-gouwuche'>
							<text v-if="Math.floor(CartCount)>0" class='num bg_color'>{{CartCount}}</text>
						</view>
						<view>{{$t(`page.goodsDetail.cart`)}}</view>
					</navigator>
					<view class="bnt acea-row tui-skeleton-rect" v-if="attr.productSelect.stock <= 0">
						<form report-submit="true" style="margin-right: 2rpx;"><button class="bnts bg-color-hui butJoin"
								form-type="submit">{{$t(`page.goodsDetail.addCart`)}}</button></form>
						<form report-submit="true"><button class="bnts bg-color-hui butBuy" form-type="submit">{{$t(`page.goodsDetail.soldOut`)}}</button>
						</form>
					</view>
					<view class="bnt acea-row tui-skeleton-rect" v-else>
						<form @submit="joinCart" report-submit="true"><button class="joinCart bnts butJoin"
								form-type="submit">{{$t(`page.goodsDetail.addCart`)}}</button></form>
						<form @submit="goBuy" report-submit="true"><button class="buy bnts butBuy"
								form-type="submit">{{$t(`page.goodsDetail.buyNow`)}}</button>
						</form>
					</view>
				</block>
			</view>
			<!-- 组件 -->
			<productWindow v-if="isOpen" :attr="attr" :isShow='1' :iSplus='1' @myevent="onMyEvent" @ChangeAttr="ChangeAttr"
				@ChangeCartNum="ChangeCartNum" @attrVal="attrVal" @iptCartNum="iptCartNum" id='product-window' @getImg="showImg">
			</productWindow>
			<couponListWindow :shopPayCurrency="shopPayCurrency" :coupon='coupon' :typeNum="couponDeaultType[0].useType" @ChangCouponsClone="ChangCouponsClone" @ChangCoupons="ChangCoupons"
				@ChangCouponsUseState="ChangCouponsUseState" @tabCouponType="tabCouponType"></couponListWindow>
			<cus-previewImg ref="cusPreviewImg" :list="skuArr" @changeSwitch="changeSwitch"/>
			<tui-drawer mode="right" :visible="rightDrawer" @close="closeDrawer">
				<user-drawer @close="closeDrawer"></user-drawer>
			</tui-drawer>
			<tui-drawer mode="bottom" :visible="assureDrawer" @close="closeAssure">
				<view class="ensure" >
					<view class="title">{{$t(`page.goodsDetail.assure`)}}<text class="iconfont icon-guanbi" ></text></view>
					<view class="list">
						<view class="item acea-row" v-for="(item,index) in guaranteeList" :key="index">
							<view class="pictrue">
								<image :src="item.icon"></image>
							</view>
							<view class="text">
								<view class="name">{{item.name}}</view>
								<view>{{item.content}}</view>
							</view>
						</view>
					</view>
					<view class="bnt" @click="assureDrawer = false">{{$t(`page.users.orderList.complete`)}}</view>
				</view>
			</tui-drawer>
			<view class="mask" v-if="canvasStatus"></view>
		</view>
	</view>
</template>

<script>
	import store from '@/store';
	import {
		getProductDetail,
		collectAdd,
		collectDel,
		postCartAdd,
		getReplyConfig,
		getProductGood,
		getReplyProduct
	} from '@/api/store.js';
	import {getCoupons} from '@/api/api.js';
	import {getCartCounts} from '@/api/order.js';
	import {toLogin} from '@/libs/login.js';
	import {mapGetters} from "vuex";
	import productConSwiper from '@/components/productConSwiper';
	import couponListWindow from '@/components/couponListWindow';
	import productWindow from '@/components/productWindow';
	import userEvaluation from '@/components/userEvaluation';
	import cusPreviewImg from '@/components/cus-previewImg/cus-previewImg.vue'
	import parser from "@/components/jyf-parser/jyf-parser";
	import merHome from '@/components/merHome/index.vue'
	let app = getApp();
	import {setThemeColor} from '@/utils/setTheme.js'
	import {Debounce} from '@/utils/validate.js'
	import {
		goShopDetail
	} from '@/libs/order.js'
	export default {
		components: {
			productConSwiper,
			couponListWindow,
			productWindow,
			userEvaluation,
			cusPreviewImg ,
			"jyf-parser": parser,
			merHome
		},
		data() {
			let that = this;
			return {
				locale: uni.getStorageSync('locale'), //设置的语言
				skeletonShow: true, //骨架屏显示隐藏
				//属性是否打开
				coupon: {
					coupon: false,
					type: 0,
					list: [],
					count: []
				},
				attrTxt: this.$t(`page.goodsDetail.choose1`), //属性页面提示
				attrValue: '', //已选属性
				animated: false, //购物车动画
				id: 0, //商品id
				replyCount: 0, //总评论数量
				reply: [], //评论列表
				productInfo: {}, //商品详情
				productValue: [], //系统属性
				guaranteeList:[],//保障服务
				couponList: [], //优惠券
				cart_num: 1, //购买数量
				isAuto: false, //没有授权的不会自动授权
				isShowAuth: false, //是否隐藏授权
				isOpen: false, //是否打开属性组件
				actionSheetHidden: true,
				storeImage: '', //海报产品图
				PromotionCode: '', //二维码图片
				posterbackgd: '/static/images/posterbackgd.png',
				circular: false,
				autoplay: false,
				interval: 3000,
				duration: 500,
				clientHeight: "",
				systemStore: {}, //门店信息
				replyChance: 0,
				CartCount: 0,
				isDown: true,
				posters: false,
				attr: {
					cartAttr: false,
					productAttr: [],
					productSelect: {}
				},
				description: '',
				navActive: 0,
				retunTop: true, //顶部返回
				navH: "",
				navList: ['商品', '评价','推荐', '详情'],
				opacity: 0,
				scrollY: 0,
				topArr: [],
				toView: '',
				height: 0,
				heightArr: [],
				lock: false,
				scrollTop: 0,
				tagStyle: {
					img: 'width:100%;display:block;',
					table: 'width:100%',
					video: 'width:100%'
				},
				sliderImage: [],
				videoLink:'',
				qrcodeSize: 600,
				canvasStatus: false, //是否显示海报
				imagePath: '', //海报路径
				imgTop: '',
				errT: '',
				homeTop: 20,
				navbarRight: 0,
				userCollect: false,
				options: null,
				returnShow: true, //判断顶部返回是否出现
				type: "", //视频号普通商品类型
				theme:app.globalData.theme,
				indicatorBg:'',
				shareStatus:true,
				skuArr:[],
				currentPage:false,
				selectSku:{},
				defaultCoupon:[],
				couponDeaultType:[
					{useType:1}
				],
				rightDrawer: false,
				assureDrawer:false,
				merchantInfo: {},
				shopPayCurrency: app.globalData.shopPayCurrency //货币符号
			};
		},
		// 滚动监听
		onPageScroll(e) {
		   // 传入scrollTop值并触发所有easy-loadimage组件下的滚动监听事件
		   uni.$emit('scroll');
		},
		mounted: function() {
			this.$store.dispatch('MerTypeList');
		},
		computed: mapGetters(['isLogin', 'uid', 'chatUrl']),
		watch: {
			
			productInfo: {
				handler: function() {
					this.$nextTick(() => {});
				},
				immediate: true
			}
		},
		onShow: function() {
			if (this.isLogin) {
				this.getCartCount();
			};
		},
		onLoad(options) {
			this.options = options;
			let that = this;
			var pages = getCurrentPages();
			that.returnShow = pages.length === 1 ? false : true;
			if (pages.length <= 1) {
				that.retunTop = false
			}
			that.navH = app.globalData.navHeight;
			uni.getSystemInfo({
				success: function(res) {
					that.height = res.windowHeight
				},
			});
			if (!options.scene && !options.id) {
				this.showSkeleton = false;
				this.$util.Tips({
					title: '缺少参数无法查看商品'
				}, {
					url: '/pages/index/index'
				});
				return;
			}
			if (options.hasOwnProperty('id') || options.scene) {  
				this.id = options.id;
				options.type == undefined || options.type == null ? that.type = 'normal' : that.type = options.type;
				that.$store.commit("PRODUCT_TYPE", that.type);
			}
			this.getGoodsDetails();
			//this.getCouponList();
			this.getCouponType();
			this.getProductReplyList();
			this.getProductReplyCount();
			this.indicatorBg = setThemeColor();
		},
		methods: {
			toHome() {
				uni.reLaunch({
					url:'/pages/index/index'
				})
			},
			/**
			 * 购物车手动填写
			 * 
			 */
			iptCartNum: function(e) {
				this.$set(this.attr.productSelect, 'cart_num', e ? e : 1);
			},
			// 后退
			returns: function() {
				uni.navigateBack()
			},
			showNav(){
				this.rightDrawer = true
			},
			closeDrawer(e) {
				this.rightDrawer = false
				if(!e){
					this.rightDrawer = false
				}
			},
			closeAssure(){
				this.assureDrawer = false;
			},
			tap: function(index) {
				var id = "past" + index;
				var index = index;
				var that = this;
				this.$set(this, 'toView', id);
				this.$set(this, 'navActive', index);
				this.$set(this, 'lock', true);
				this.$set(this, 'scrollTop', index > 0 ? that.topArr[index] - (app.globalData.navHeight / 2) : that
					.topArr[index]);
			},
			scroll: function(e) {
				var that = this,
					scrollY = e.detail.scrollTop;
				var opacity = scrollY / 500;
				opacity = opacity > 1 ? 1 : opacity;
				that.$set(that, 'opacity', opacity);
				that.$set(that, 'scrollY', scrollY);
				if (that.lock) {
					that.$set(that, 'lock', false)
					return;
				}
				for (var i = 0; i < that.topArr.length; i++) {
					if (scrollY < that.topArr[i] - (app.globalData.navHeight / 2) + that.heightArr[i]) {
						that.$set(that, 'navActive', i)
						break
					}
				}
			},
			/*
			 *去商品详情页 
			 */
			goDetail(item) {
				uni.redirectTo({
					url: '/pages/goods_details/index?id=' + item.id
				})
			},
			ChangCouponsClone: function() {
				this.$set(this.coupon, 'coupon', false)
			},
			/**
			 * 购物车数量加和数量减
			 * 
			 */
			ChangeCartNum: function(changeValue) {
				//changeValue:是否 加|减
				//获取当前变动属性
				let productSelect = this.productValue[this.attrValue];
				//如果没有属性,赋值给商品默认库存
				if (productSelect === undefined && !this.attr.productAttr.length)
					productSelect = this.attr.productSelect;
				//无属性值即库存为0；不存在加减；
				if (productSelect === undefined) return;
				let stock = productSelect.stock || 0;
				let num = this.attr.productSelect;
				if (changeValue) {
					num.cart_num++;
					if (num.cart_num > stock) {
						this.$set(this.attr.productSelect, "cart_num", stock);
						this.$set(this, "cart_num", stock);
					}
				} else {
					num.cart_num--;
					if (num.cart_num < 1) {
						this.$set(this.attr.productSelect, "cart_num", 1);
						this.$set(this, "cart_num", 1);
					}
				}
			},
			attrVal(val) {
				this.$set(this.attr.productAttr[val.indexw], 'index', this.attr.productAttr[val.indexw].attrValues[val.indexn]);
			},
			/**
			 * 属性变动赋值
			 * 
			 */
			ChangeAttr: function(res) {
				let productSelect = this.productValue[res];
				this.$set(this, "selectSku", productSelect);
				if (productSelect) {
					this.$set(this.attr.productSelect, "image", productSelect.image);
					this.$set(this.attr.productSelect, "price", productSelect.price);
					this.$set(this.attr.productSelect, "stock", productSelect.stock);
					this.$set(this.attr.productSelect, "unique", productSelect.id);
					this.$set(this.attr.productSelect, "cart_num", 1);
					this.$set(this.attr.productSelect, "vipPrice", productSelect.vipPrice);
					this.$set(this.attr.productSelect,'otPrice',productSelect.otPrice);
					this.$set(this, "attrValue", res);
					this.$set(this, "attrTxt", this.$t(`page.goodsDetail.choose`));
				} else {
					this.$set(this.attr.productSelect, "image", this.productInfo.image);
					this.$set(this.attr.productSelect, "price", this.productInfo.price);
					this.$set(this.attr.productSelect, "stock", 0);
					this.$set(this.attr.productSelect, "unique", this.productInfo.id);
					this.$set(this.attr.productSelect, "cart_num", 1);
					this.$set(this.attr.productSelect, "vipPrice", this.productInfo.vipPrice);
					this.$set(this.attr.productSelect,'otPrice',this.productInfo.otPrice);
					this.$set(this, "attrValue", "");
					this.$set(this, "attrTxt", this.$t(`page.goodsDetail.choose1`));
				}
			},
			/**
			 * 领取完毕移除当前页面领取过的优惠券展示
			 */
			ChangCoupons: function(e) {
				let coupon = e;
				let couponList = this.$util.ArrayRemove(this.couponList, 'id', coupon.id);
				this.$set(this, 'couponList', couponList);
				this.getCouponList();
			},

			setClientHeight: function() {
				let that = this;
				if (!that.good_list.length) return;
				//if (!that.merchantInfo.proList.length) return;
				let view = uni.createSelectorQuery().in(this).select("#list0");
				view.fields({
					size: true,
				}, data => {
					that.$set(that, 'clientHeight', data.height + 20)
				}).exec();
			},
			/**
			 * 获取产品详情
			 * 
			 */
			getGoodsDetails: function() {
				let that = this;
				getProductDetail(that.id, that.type).then(res => {
					let productInfo = res.data.productInfo;
					// 字符串数组转数组；
					let arrayImg = productInfo.sliderImage;
					let sliderImage = JSON.parse(arrayImg);
					that.$set(that, 'sliderImage', sliderImage);
					that.$set(that, 'productInfo', productInfo);
					that.$set(that, 'guaranteeList', res.data.guaranteeList || []);//保障服务信息
					that.$set(that, 'merchantInfo', res.data.merchantInfo);
					that.$set(that, 'description', productInfo.content);
					that.$set(that, 'userCollect', res.data.userCollect);
					that.$set(that.attr, 'productAttr', res.data.productAttr);
					that.$set(that, 'productValue', res.data.productValue);
					that.getCouponList(2);
					for(let key in res.data.productValue){
						let obj = res.data.productValue[key];
						that.skuArr.push(obj)
					}
					this.$set(this, "selectSku", that.skuArr[0]);
					uni.setNavigationBarTitle({
						title: productInfo.storeName.substring(0, 7) + "..."
					})
					
					let productAttr = this.attr.productAttr.map(item => {
					return {
						attrName : item.attrName,
						attrValues: item.attrValues.split(','),
						id:item.id,
						isDel:item.isDel,
						productId:item.productId,
						type:item.type
					 }
					});
					this.$set(this.attr,'productAttr',productAttr);
					if (that.isLogin) {
						that.getCartCount();
					};
					setTimeout(function() {
						that.infoScroll();
					}, 500);
					
					that.DefaultSelect();
					setTimeout(() => {
						this.defaultCoupon = this.coupon.list;
					}, 1000)
					this.skeletonShow = false;
				}).catch(err => {
					this.skeletonShow = false;
					//状态异常返回上级页面
					that.$util.Tips({
						title: err.toString()
					}, {
						tab: 3,
						url: 1
					});
					
				})
			},
			getProductReplyList: function() {
				getReplyProduct(this.id).then(res => {
					this.reply = res.data.productReply ? [res.data.productReply] : [];
				})
			},
			getProductReplyCount: function() {
				let that = this;
				getReplyConfig(that.id).then(res => {
					that.$set(that, 'replyChance', res.data.replyChance * 100);
					that.$set(that, 'replyCount', res.data.sumCount);
				});
			},
			infoScroll: function() {
				var that = this,
					topArr = [],
					heightArr = [];
				for (var i = 0; i < that.navList.length; i++) { //productList
					//获取元素所在位置
					var query = uni.createSelectorQuery().in(this);
					var idView = "#past" + i;
					// if (!that.data.good_list.length && i == 2) {
					//   var idView = "#past" + 3;
					// }
					query.select(idView).boundingClientRect();
					query.exec(function(res) {
						var top = res[0].top;
						var height = res[0].height;
						topArr.push(top);
						heightArr.push(height);
						that.$set(that, 'topArr', topArr);
						that.$set(that, 'heightArr', heightArr);
					});
				};
			},
			/**
			 * 默认选中属性
			 * 
			 */
			DefaultSelect: function() {
				let productAttr = this.attr.productAttr;
				let value = [];
				//默认选中每种规格的第一个
				productAttr.forEach(item=>{
					value.push(item.attrValues[0]);
				})
				for (let i = 0; i < value.length; i++) {
					this.$set(productAttr[i], "index", value[i]);
				}
				
				//sort();排序函数:数字-英文-汉字；
				let productSelect = this.productValue[value.join(",")];
				if (productSelect && productAttr.length) {
					this.$set(this.attr.productSelect,"storeName",this.productInfo.storeName);
					this.$set(this.attr.productSelect, "image", productSelect.image);
					this.$set(this.attr.productSelect, "price", productSelect.price);
					this.$set(this.attr.productSelect, "stock", productSelect.stock);
					this.$set(this.attr.productSelect, "unique", productSelect.id);
					this.$set(this.attr.productSelect, "cart_num", 1);
					this.$set(this.attr.productSelect, "vipPrice", productSelect.vipPrice); //attr.productSelect.otPrice
					this.$set(this.attr.productSelect,'otPrice',productSelect.otPrice);
					this.$set(this, "attrValue", value.join(","));
					this.$set(this, "attrTxt", this.$t(`page.goodsDetail.choose`));
				} else if (!productSelect && productAttr.length) {
					this.$set(this.attr.productSelect,"storeName",this.productInfo.storeName);
					this.$set(this.attr.productSelect, "image", this.productInfo.image);
					this.$set(this.attr.productSelect, "price", this.productInfo.price);
					this.$set(this.attr.productSelect, "stock", 1000);
					this.$set(this.attr.productSelect, "unique", this.productInfo.id);
					this.$set(this.attr.productSelect, "cart_num", 1);
					this.$set(this.attr.productSelect, "vipPrice", this.productInfo.vipPrice);
					this.$set(this.attr.productSelect,'otPrice',this.productInfo.otPrice);
					this.$set(this, "attrValue", "");
					this.$set(this, "attrTxt", "请选择");
				} else if (!productSelect && !productAttr.length) {
					this.$set(this.attr.productSelect,"storeName",this.productInfo.storeName);
					this.$set(this.attr.productSelect, "image", this.productInfo.image);
					this.$set(this.attr.productSelect, "price", this.productInfo.price);
					this.$set(this.attr.productSelect, "stock", this.productInfo.stock);
					this.$set(this.attr.productSelect,"unique",this.productInfo.id || "");
					this.$set(this.attr.productSelect, "cart_num", 1);
					this.$set(this.attr.productSelect, "vipPrice", this.productInfo.vipPrice);
					this.$set(this.attr.productSelect,'otPrice',this.productInfo.otPrice);
					this.$set(this, "attrValue", "");
					this.$set(this, "attrTxt", "请选择");
				}
			},
			/**
			 * 获取优惠券
			 * 
			 */
			getCouponList(type) {
				let that = this,
					obj = {
						merId: that.productInfo.merId,
						page: 1,
						limit: 20,
						productId: that.id,
						useType: type
					};
				getCoupons(obj).then(res => {
					that.$set(that.coupon, 'list', res.data.list);
				});
			},
			async getCouponType(){
				let obj = {
						merId: this.productInfo.merId,
						page: 1,
						limit: 20,
						productId: this.id,
						useType: 2
					};
				//在onLoad只调用一次，获取默认的类型作为打开优惠券列表的参数，不会随着切换变化
				let dataList = await getCoupons(obj);
				if(dataList.length){
					this.couponDeaultType = dataList.data.list;
					this.$set(this.coupon,'type',dataList);
				}
				
			},
			tabCouponType(type) {
				this.$set(this.coupon, 'type', type);
				this.getCouponList(type);
			},

			ChangCouponsUseState(index) {
				let that = this;
				that.coupon.list[index].isUse = true;
				that.$set(that.coupon, 'list', that.coupon.list);
				that.$set(that.coupon, 'coupon', false);
			},
			/** 
			 * 
			 * 
			 * 收藏商品
			 */
			setCollect: function() {
				let that = this;
				if (this.isLogin === false) {
					toLogin();
				} else {
					if (this.userCollect) {
						collectDel(this.productInfo.id).then(res => {
							that.$set(that, 'userCollect', !that.userCollect);
						})
					} else {
						collectAdd(this.productInfo.id).then(res => {
							that.$set(that, 'userCollect', !that.userCollect);
						})
					}
				}
			},
			/**
			 * 打开属性插件
			 */
			selecAttr: function() {
				this.$set(this.attr, 'cartAttr', true);
				this.$set(this, 'isOpen', true);
			},
			/**
			 * 打开优惠券插件
			 */
			couponTap: function() {
				let that = this;
				if (that.isLogin === false) {
					toLogin();
				} else {
					that.getCouponList(this.couponDeaultType[0].useType); //打开弹框默认请求商品券
					that.$set(that.coupon, 'coupon', true);
				}
			},
			onMyEvent: function() {
				this.$set(this.attr, 'cartAttr', false);
				this.$set(this, 'isOpen', false);
			},
			/**
			 * 打开属性加入购物车
			 * 
			 */
			joinCart: function(e) {
				//是否登录
				if (this.isLogin === false) {
					toLogin();
				} else {
					this.goCat(1);
				}
			},
			/*
			 * 加入购物车
			 */
			goCat: function(num) {
				let that = this,
					productSelect = that.productValue[this.attrValue];
				//打开属性
				if (that.attrValue) {
					//默认选中了属性，但是没有打开过属性弹窗还是自动打开让用户查看默认选中的属性
					that.attr.cartAttr = !that.isOpen ? true : false;
				} else {
					if (that.isOpen) that.attr.cartAttr = true;
					else that.attr.cartAttr = !that.attr.cartAttr;
				}
				//只有关闭属性弹窗时进行加入购物车
				if (that.attr.cartAttr === true && that.isOpen === false)
					return (that.isOpen = true);
				//如果有属性,没有选择,提示用户选择
				// if (
				// 	that.attr.productAttr.length &&
				// 	productSelect.stock === 0 &&
				// 	that.isOpen === true
				// )
					// return that.$util.Tips({
					// 	title: "产品库存不足，请选择其它"
					// });
				if (num === 1) {
					let q = [{
						productId: parseFloat(that.id),
						cartNum: parseFloat(that.attr.productSelect.cart_num),
						isNew: false,
						productAttrUnique: that.attr.productSelect !== undefined ?
							that.attr.productSelect.unique : that.productInfo.id
					}];
					postCartAdd(q).then(function(res) {
							that.isOpen = false;
							that.attr.cartAttr = false;
							that.$util.Tips({
								title: that.$t(`message.tips.shoppingSU`),
								success: () => {
									that.getCartCount(true);
								}
							});
						})
						.catch(res => {
							that.isOpen = false;
							return that.$util.Tips({
								title: res
							});
						});
				} else {
					this.getPreOrder();
				}
			},
			/**
			 * 获取购物车数量
			 * @param boolean 是否展示购物车动画和重置属性
			 */
			getCartCount: function(isAnima) {
				let that = this;
				const isLogin = that.isLogin;
				if (isLogin) {
					getCartCounts(true, 'total').then(res => {
						that.CartCount = res.data.count;
						//加入购物车后重置属性
						if (isAnima) {
							that.animated = true;
							setTimeout(function() {
								that.animated = false;
							}, 500);
						}
					});
				}
			},
			/**
			 * 立即购买
			 */
			goBuy: Debounce(function(e) {
				if (this.isLogin === false) {
					toLogin();
				} else {
					this.goCat(0);
				}
			}),
			/**
			 * 预下单
			 */
			getPreOrder: function() {
				this.$Order.getPreOrder(this.type === 'normal' ? 'buyNow' : 'video', [{
					"attrValueId": parseFloat(this.attr.productSelect.unique),
					"productId": parseFloat(this.id),
					"productNum": parseFloat(this.attr.productSelect.cart_num)
				}]);
				this.isOpen = false;
			},
			//替换安全域名
			setDomain: function(url) {
				url = url ? url.toString() : '';
				//本地调试打开,生产请注销
				if (url.indexOf("https://") > -1) return url;
				else return url.replace('http://', 'https://');
			},
			//点击sku图片打开轮播图
			showImg(index){
				this.$refs.cusPreviewImg.open(this.selectSku.sku)
			},
			//滑动轮播图选择商品
			changeSwitch(e){
				let productSelect = this.skuArr[e];
				this.$set(this,'selectSku',productSelect);
				var skuList = productSelect.sku.split(',');
				skuList.forEach((i,index)=>{
					this.$set(this.attr.productAttr[index],'index',skuList[index]);
				})
				if (productSelect) {
					this.$set(this.attr.productSelect, "image", productSelect.image);
					this.$set(this.attr.productSelect, "price", productSelect.price);
					this.$set(this.attr.productSelect, "stock", productSelect.stock);
					this.$set(this.attr.productSelect, "unique", productSelect.id);
					this.$set(this.attr.productSelect, "vipPrice", productSelect.vipPrice);
					this.$set(this, "attrTxt", this.$t(`page.goodsDetail.choose`));
					this.$set(this, "attrValue", productSelect.sku)
				}
			},
			getFileType(fileName) {
				// 后缀获取
				let suffix = '';
				// 获取类型结果
				let result = '';
				try {
				const flieArr = fileName.split('.');
				suffix = flieArr[flieArr.length - 1];
				} catch (err) {
				suffix = '';
				}
				// fileName无后缀返回 false
				if (!suffix) { return false; }
				suffix = suffix.toLocaleLowerCase();
				// 图片格式
				const imglist = ['png', 'jpg', 'jpeg', 'bmp', 'gif'];
				// 进行图片匹配
				result = imglist.find(item => item === suffix);
				if (result) {
				return 'image';
				}
				// 匹配 视频
				const videolist = ['mp4', 'm2v', 'mkv', 'rmvb', 'wmv', 'avi', 'flv', 'mov', 'm4v'];
				result = videolist.find(item => item === suffix);
				if (result) {
				return 'video';
				}
				// 其他 文件类型
				return 'other';
			},
		},
	}
</script>

<style scoped lang="scss">
	.superior{
		/deep/.name, /deep/.icon-gengduo{
			color: #333 !important;
		}
		/deep/.store{
			padding: 0 !important;
		}
	}
	.product-con {
		height: 100%;
	}
	.x-money{
		font-size: 28rpx;
		font-weight: 700;
		font-family: D-DIN-Bold, D-DIN;
		@include price_color(theme);
		
	}
	.select_nav{
		width: 170rpx !important;
		height: 60rpx !important;
		border-radius: 33rpx;
		background: rgba(255, 255, 255, 0.3);
		border: 1px solid rgba(0,0,0,0.07);
		color: #000;
		position: fixed;
		font-size: 18px;
		line-height: 62rpx;
		z-index: 1000;
		left: 14rpx;
	}
	.px-20{
		padding: 0 20rpx 0;
	}
	.nav_line{
		content: '';
		display: inline-block;
		width: 1px;
		height: 34rpx;
		background: #b3b3b3;
		position: absolute;
		left: 0;
		right: 0;
		margin: auto;
	}
	.bgwhite{
		background: #fff;
	}
	.input {
		display: flex;
		align-items: center;
		width: 460rpx;
		height: 58rpx;
		padding: 0 0 0 30rpx;
		border: 1px solid rgba(0,0,0,0.07);
		border-radius: 33rpx;
		color: #666;
		font-size: 26rpx;
		position: fixed;
		left: 0;
		right: 0;
		margin: auto;
		background: rgba(255, 255, 255, 0.3);
		.iconfont {
			margin-right: 20rpx;
			font-size: 26rpx;
			color: #666666;
		}
	}
	.tab_nav{
		width: 100%;
		height: 48px;
		padding:0 30rpx 0;
	}
	.right_select{
		width: 58rpx;
		height: 58rpx;
		position: fixed;
		right: 20rpx;
		text-align: center;
		line-height: 58rpx;
	}
	.dialog_nav{
		position: absolute;
		right: 14rpx;
		width: 240rpx;
		background: #FFFFFF;
		box-shadow: 0px 0px 16rpx rgba(0, 0, 0, 0.08);
		z-index: 310;
		border-radius: 14rpx;
		&::before{
			content: '';
			width: 0;
			height: 0;
			position: absolute;
			right: 8px;
			top:-9px;
			border-bottom: 10px solid #F5F5F5;
			border-left: 10px solid transparent;    /*transparent 表示透明*/
			border-right: 10px solid transparent;
		}
	}
	.dialog_nav_item{
		width: 100%;
		height: 84rpx;
		line-height: 84rpx;
		padding: 0 20rpx 0;
		box-sizing: border-box;
		border-bottom: #eee;
		font-size: 28rpx;
		color: #333;
		position: relative;
		.iconfont{
			font-size: 32rpx;
		}
	}
	.dialog_after{
		::after{
			content: '';
			position: absolute;
			width:172rpx;
			height: 1px;
			background-color: #EEEEEE;
			bottom: 0;
			right: 0;
		}
	}
	.pl-20{
		padding-left: 20rpx;
	}
	.activity {
		height: 34rpx;
		padding: 0 30rpx;
		@include coupons_border_color(theme);
		@include main_color(theme);
		font-size: 24rpx;
		font-weight: 400;
		line-height: 32rpx;
		position: relative;
		margin-left: 4rpx;
		border-radius: 8rpx;
	}
	.product-con .wrapper .coupon .activity:before {
		content: ' ';
		position: absolute;
		width: 7rpx;
		height: 10rpx;
		border-radius: 0 7rpx 7rpx 0;
		@include coupons_border_color(theme);
		background-color: #fff !important;
		bottom: 50%;
		left: -5rpx;
		margin-bottom: -6rpx;
		// border-left-color: #fff ;
		@include white_left_border;
	}
	
	.product-con .wrapper .coupon .activity:after {
		content: ' ';
		position: absolute;
		width: 7rpx;
		height: 10rpx;
		border-radius: 7rpx 0 0 7rpx;
		@include coupons_border_color(theme);
		background-color: #fff;
		right: -5rpx;
		bottom: 50%;
		margin-bottom: -6rpx;
		// border-right-color: #fff;
		@include white_right_border;
	}
	.justify-center{
		justify-content: center;
	}
	.align-center {
		align-items: center;
	}
	.align-baseline{
		align-items: baseline;
	}
	.bg_color{
		@include main_bg_color(theme);
	}
	.vip_icon {
		width: 44rpx;
		height: 28rpx;
	}
	.pl-2{
		padding-left: 20rpx;
	}
	.vip_money {
		background: #FFE7B9;
		border-radius: 4px;
		font-size: 22rpx;
		color: #333;
		line-height: 28rpx;
		text-align: center;
		padding: 0 6rpx;
		box-sizing: border-box;
		margin-left: -4rpx;
	}
	.theme_price{
		@include price_color(theme);
	}
	.activityName {
		line-height: 44rpx;
	}

	.userEvaluation {
		i {
			display: inline-block;
		}
	}

	.bntVideo {
		width: auto !important;

		.buy {
			border-radius: 50rpx !important;
		}
	}

	.attribute {
		.line1 {
			width: 600rpx;
		}
	}

	.product-specs {
		padding: 24rpx;
		background: #f8f9fa;
		
		.specs-title {
			font-size: 32rpx;
			font-weight: 600;
			margin-bottom: 20rpx;
		}
		
		.specs-content {
			.spec-item {
				margin-bottom: 16rpx;
				
				.spec-label {
					font-size: 28rpx;
					min-width: 160rpx;
					font-weight: 500;
				}
				
				.spec-value {
					font-size: 28rpx;
					flex: 1;
				}
			}
		}
	}

	.chat-btn {
		background-color: antiquewhite !important;
	}

	.activity_pin {
		width: auto;
		height: 44rpx;
		line-height: 44rpx;
		// background: linear-gradient(90deg, rgba(233, 51, 35, 1) 0%, rgba(250, 101, 20, 1) 100%);
		@include linear-gradient(theme);
		opacity: 1;
		border-radius: 22rpx;
		padding: 0 15rpx;
		// margin-left: 19rpx;
	}

	.activity_miao {
		width: auto;
		height: 44rpx;
		line-height: 44rpx;
		padding: 0 15rpx;
		// background: linear-gradient(90deg, rgba(250, 102, 24, 1) 0%, rgba(254, 161, 15, 1) 100%);
		@include linear-gradient(theme);
		opacity: 1;
		border-radius: 22rpx;
		margin-left: 19rpx;
	}

	.iconfonts {
		color: #fff !important;
		font-size: 28rpx;
	}

	.activity_title {
		font-size: 24rpx;
		color: #fff;
	}

	.activity_kan {
		width: auto;
		height: 44rpx;
		line-height: 44rpx;
		padding: 0 15rpx;
		@include linear-gradient(theme);
		opacity: 1;
		border-radius: 22rpx;
		margin-left: 19rpx;
	}

	.mask {
		z-index: 300 !important;
	}

	.head-bar {
		background: #fff;
	}

	.generate-posters {
		width: 100%;
		height: 318rpx;
		background-color: #fff;
		position: fixed;
		left: 0;
		bottom: 0;
		z-index: 388;
		transform: translate3d(0, 100%, 0);
		transition: all 0.3s cubic-bezier(0.25, 0.5, 0.5, 0.9);
		border-top: 1rpx solid #eee;
		
		.generateCon {
			height: 220rpx;
		}
		
		.generateClose {
			height: 98rpx;
			font-size: 28rpx;
			color: #333333;
			border-top: 1px solid #eee;
		}
		
		.item {
			.pictrue {
				width: 96rpx;
				height: 96rpx;
				border-radius: 50%;
				margin: 0 auto 6rpx auto;
		
				image {
					width: 100%;
					height: 100%;
					border-radius: 50%;
				}
			}
		}
	}

	.generate-posters.on {
		transform: translate3d(0, 0, 0);
	}
	
	.generate-posters .item {
		flex: 1;
		text-align: center;
		font-size: 30rpx;
	}
	
	.generate-posters .item .iconfont {
		font-size: 80rpx;
		color: #5eae72;
	}
	
	.generate-posters .item .iconfont.icon-haibao {
		color: #5391f1;
	}
	
	.generate-posters .item .iconfont.icon-haowuquan1 {
		color: #ff954d;
	}

	.product-con .footer {
		padding: 0 20rpx 0 30rpx;
		position: fixed;
		bottom: 0;
		width: 100%;
		box-sizing: border-box;
		background-color: #fff;
		z-index: 277;
		border-top: 1rpx solid #f0f0f0;
		height: 100rpx;
		height: calc(100rpx+ constant(safe-area-inset-bottom)); ///兼容 IOS<11.2/
		height: calc(100rpx + env(safe-area-inset-bottom)); ///兼容 IOS>11.2/
	}

	.product-con .footer .item {
		font-size: 18rpx;
		color: #666;
	}

	.product-con .footer .item .iconfont {
		text-align: center;
		font-size: 40rpx;
	}

	.product-con .footer .item .iconfont.icon-shoucang1 {
		@include main_color(theme);
	}

	.product-con .footer .item .iconfont.icon-gouwuche {
		font-size: 40rpx;
		position: relative;
	}

	.product-con .footer .item .iconfont.icon-gouwuche .num {
		color: #fff;
		position: absolute;
		font-size: 18rpx;
		padding: 2rpx 8rpx 3rpx;
		border-radius: 200rpx;
		top: -10rpx;
		right: -10rpx;
	}

	.product-con .footer .bnt {
		height: 76rpx;
	}

	.product-con .footer .bnt .bnts {
		width: 222rpx;
		text-align: center;
		line-height: 76rpx;
		color: #fff;
		font-size: 28rpx;
	}
	.butBuy{
		border-radius: 0 50rpx 50rpx 0;
	}
    .butJoin{
		border-radius: 50rpx 0 0 50rpx;
	}
	.product-con .footer .bnt .joinCart {
		@include left_color(theme);
	}

	.product-con .footer .bnt .buy {
		@include main_bg_color(theme);
	}

	.product-con .store-info {
		margin-top: 20rpx;
		background-color: #fff;
	}

	.product-con .store-info .title {
		padding: 0 30rpx;
		font-size: 28rpx;
		color: #282828;
		height: 80rpx;
		line-height: 80rpx;
		border-bottom: 1px solid #f5f5f5;
	}

	.product-con .store-info .info {
		padding: 0 30rpx;
		height: 126rpx;
	}

	.product-con .store-info .info .picTxt {
		width: 615rpx;
	}

	.product-con .store-info .info .picTxt .pictrue {
		width: 76rpx;
		height: 76rpx;
	}

	.product-con .store-info .info .picTxt .pictrue image {
		width: 100%;
		height: 100%;
		border-radius: 6rpx;
	}

	.product-con .store-info .info .picTxt .text {
		width: 522rpx;
	}

	.product-con .store-info .info .picTxt .text .name {
		font-size: 30rpx;
		color: #282828;
	}

	.product-con .store-info .info .picTxt .text .address {
		font-size: 24rpx;
		color: #666;
		margin-top: 3rpx;
	}

	.product-con .store-info .info .picTxt .text .address .iconfont {
		color: #707070;
		font-size: 18rpx;
		margin-left: 10rpx;
	}

	.product-con .store-info .info .picTxt .text .address .addressTxt {
		max-width: 480rpx;
	}

	.product-con .store-info .info .iconfont {
		font-size: 40rpx;
	}

	.product-con .superior {
		background-color: #fff;
		margin-top: 30rpx;
		padding: 24rpx;
	}

	.product-con .superior .title {
		height: 98rpx;
	}

	.product-con .superior .title image {
		width: 20rpx;
		height: 20rpx;
	}

	.product-con .superior .title .titleTxt {
		margin: 0 10rpx;
		font-size: 30rpx;
		color: #333333;
	}

	.product-con .superior .slider-banner {
		width: 100%;
		margin: 0 auto;
		position: relative;
		margin-top: 26rpx;
	}

	.product-con .superior .slider-banner swiper {
		height: 100%;
		width: 100%;
	}

	.product-con .superior .slider-banner swiper-item {
		height: 100%;
	}

	.product-con .superior .slider-banner .list {
		width: 100%;
	}

	.product-con .superior .slider-banner .list .item {
		width: 146rpx;
		margin: 0 22rpx 0rpx 0;
		font-size: 26rpx;
	}

	.product-con .superior .slider-banner .list .item:nth-of-type(4n) {
		margin-right: 0;
	}

	.product-con .superior .slider-banner .list .item .pictrue {
		position: relative;
		width: 100%;
		height: 146rpx;
		border-radius: 6rpx;
		overflow: hidden;
	}

	.product-con .superior .slider-banner .list .item .pictrue image {
		width: 100%;
		height: 100%;
		border-radius: 6rpx;
	}

	.product-con .superior .slider-banner .list .item .name {
		color: #282828;
		margin-top: 12rpx;
	}

	.product-con .superior .slider-banner .swiper-pagination-bullet {
		background-color: #999;
	}

	.product-con .superior .slider-banner .swiper-pagination-bullet-active {
		background-color: $theme-color;
	}

	button {
		padding: 0;
		margin: 0;
		line-height: normal;
		background-color: #fff;
	}

	button::after {
		border: 0;
	}

	action-sheet-item {
		padding: 0;
		height: 240rpx;
		align-items: center;
		display: flex;
	}

	.contact {
		font-size: 16px;
		width: 50%;
		background-color: #fff;
		padding: 8rpx 0;
		border-radius: 0;
		margin: 0;
		line-height: 2;
	}

	.contact::after {
		border: none;
	}

	.action-sheet {
		font-size: 17px;
		line-height: 1.8;
		width: 50%;
		position: absolute;
		top: 0;
		right: 0;
		padding: 25rpx 0;
	}

	.canvas {
		position: fixed;
		z-index: -5;
		opacity: 0;
	}

	.poster-pop {
		position: fixed;
		width: 450rpx;
		height: 714rpx;
		top: 50%;
		left: 50%;
		transform: translateX(-50%);
		margin-top: -432rpx;
		z-index: 399;
	}

	.poster-pop image {
		width: 100%;
		height: 100%;
		display: block;
	}

	.poster-pop .close {
		width: 46rpx;
		height: 75rpx;
		position: fixed;
		right: 0;
		top: -73rpx;
		display: block;
	}

	.poster-pop .save-poster {
		background-color: #df2d0a;
		font-size: ：22rpx;
		color: #fff;
		text-align: center;
		height: 76rpx;
		line-height: 76rpx;
		width: 100%;
	}

	.poster-pop .keep {
		color: #fff;
		text-align: center;
		font-size: 25rpx;
		margin-top: 10rpx;
	}

	.mask {
		position: fixed;
		top: 0;
		left: 0;
		right: 0;
		bottom: 0;
		background-color: rgba(0, 0, 0, 0.6);
	}

	.pro-wrapper .iconn {
		background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHgAAAB4CAYAAAA5ZDbSAAAYKElEQVR4nO2deXhTVfrHP0nTlpautHSjZSkt+x42UTYVF5C4gsKIOqOjIxJHZdTfyG+eEZ1xxgVHjeLo6KiIKKsYcAUEBQooASxQKC1QulPolm50S+aPJPXmZm2a3BTo53n6QM49956T+8259yzv+x7ZmC8WcbGjU2migBFAGpAK9AGSgBjzX3dAAYSbT6kBWoA6oNz8VwycAU4BuUCmUquuku5beIZOpXF6XCFRPbyGTqUJAsYCVwCTgTFASjsvYxE6Gkh2UlYBcADYCewB9iu16qb21tmfXBQC61SaeGA2cANwHb8K5GtSzH83mz/X6lSarcCXwCalVn1Wonp4TKcVWKfSRAJzgLuAaUCAXytkIgy4xfzXqlNpfgA+A9Yotepqv9bMAbLO9g7WqTTjgYcxidvdnXNaDK3k1Z4lt6aEorrzFDdUUFpfQXljDfrmehpaGmkxtlLf0ghAqCIYhSyAEEUw4YEhxAZHkBDag6SQHvTqHktaeCJ9w+JRyN3+TdUBa4F3lFr13vZ/a89x9Q7uFALrVBo5plaxGJjkKn9lUy37zmVzqPwkmZWnOVlTQouh1at1UsgD6B+eyIjofozqkcqEuEFEB4W5c2oGsAzYqNSqDV6tlB06tcA6lUYG3Ao8Cwx3lveEvojvS34h42wWx6rzMRiNUlSxDblMxuDI3kyKH8LViSMZENHL1SmHMX2vz5Vatc8q22kF1qk004BXAKWjPGUXqtDm7+Xrwv3k1Xau/kzfsHhuTB6LqvdE4rpFOcuqA/6k1Kp3+KIenU5gnUqTDLwEzHOUZ9+5bD47vYNdZ7MwGH3+lOsQcpmcq+KHcFe/aUzoOdBZ1s+Ap5RadYE3y+80ApvfswuBF7AzzDEYjWwpPsBHuVvJri6UpE7eZmBkMvemXcuMpDHIZTJ7WWqAZ4Dl3no/dwqBdSpNX2AlcKW94ztKM3n7+Jfk6ot9XhcpSItI4uFBs5iWMMJRlt3AAqVWfbqjZfldYJ1KczfwFhAhPpZdXciyoxvQnc/xaR38hTI2ncVDb2NgpN3JMj3wiFKrXtmRMvwmsE6lCQbeBB4QH6tvaWT58c2sPv2D5L1hqZHLZMztN4VHBs0mVBFsL8t7wCKlVt3oyfVdCSz35KJuFJqMaf7WRty9544zd/sLfHpqxyUvLpj6Fp+d+oG5219g77nj9rI8AOw03zOv43WBdSrNKGAfME6Y3mRo4dWjG1i0ZzklDRXeLrbTU9JQwaI9y1l2ZANNhhbx4XHAPvO98ypeFVin0lyPqeUmCdOL6su5b+cyPjm5HSOXfqt1hBEjq05t576dyyiqLxcfTsLUkq/3ZpleE1in0twKaDFNyLeRUZbFgh9fvmiHPr4gu7qQBT++zJ6yY+JDYYBWp9Lc5q2yvCKwTqWZj2myPUiYvjZvJ3/c9w7VTXXeKOaSorqpjkf3/Zt1eTvFh4KANeZ72mE6LLD517YCwXKeESOvZ23kn5lrOv1MlD8xGA38I3MNrx3dKH51BQArdCrN7R0to0MC61SaG4FPEYhrMBp4/tAqVuRu62jdLhs+PrmN5w6tEjeGAGCV+R57jMcC61Sa4cBqBI9lg9HA0kOf8EW+pEuilwTa/L0sPfSJWGTL49rpSpszPBLYPGb7CsGcshEjL2SuZnPBT57W5bJnc8FPvJC5Wvy4DgO+8nSc3G6BzUZvGxAZq715bBOfn8nwpA5dCPj8TAZvHtskTk4GNphnB9uFJy14OaJJjHV5O/kwZ4sHl+rCHh/mbLHXux6HaU6/XbRLYPPCwf3CtIyyLF48vK695XbhghcPryOjLEucfL9ZA7dxW2Dzkp/VL6iovpwlBz7qGgr5AIPRwJIDH9mb8XpLp9L0c/c6bglsXqxfiWDJr8nQwpM/v4e+qd7dsrpoJ/qmep78+T3x3HUE8LFZE5e424IXIlqsf/OYtmv6UQKyqwvRZGnFyVdi0sQlLgXWqTQpmMxs2th37jirTu5ws4pddJRPT+1gn+1S4wtmbZziTgtehmC8W9/SyPOHPr2sV4WkxoiR5w6tajPcNxOOSRunOBVYp9JMBu4Qpr11bNNluZ7rb0obKnnLdnw8B5MDnkMcCmw2Sv8X0GYemF1dyBrb8VkXErEmb6e9fo+VRmKcteBbERmlLzu6oWtI5EcMRgPLjqwXJysxaWUXuwKbu+DPCtO2l/xyyVo/XkzoynPZUZopTl6KAy0dteDZCHyFDEYjy49v9koFu+g4bx//UmywOAyTZjY4EvhJ4Yfvig9wqqbUO7XrosPk6ovZUnxAnPykvbw2DuA6lWYiokmNFblbvVY5byGXyUkLTyQ1IpHk0BiigsIIVXQjQCajtvkC+uZ6ShsqOFVTygl9EY2tzf6uslf5KHcr1/ey6iJdCUwErBbj7Xn4Pyj88NP57E4zYxUWGMK1SaOZnjACZWw6IQFBrk8CWo0GMitOs6vsKN8W6i6JYV52dSH7zmWLHd4eRCSwlWeDOWxCEQLP+sf2vcPOs0d8W1sX9AqN5XfpM7gheSzd3BTVGRllWaw8+T37zmV7oXb+Y3L8MF6b8JAwqQ7oBbSFkxC34DsRiHu2ocrekpVkhCqCWTjoJub0ndyecAoumRQ3hElxQ9h/PodXjqwnR1/ktWtLye6yLM42VBEf0uaf3B2Thu9aEsSdrDuFHzYV7KPVT+Pe0TH9WTf9/5mXOs2r4goZG5vOJ1Of4g8DZyKX+cSLx6cYjAY2FewTJ1tp2PatdCpNAjBVePDrwp99Vjln3NF3Mu9MelT4y/QZATI5vx94I8uveITwwBCfl+dtviq0sYGbCiRYPgh/trMRmL/m6Iv8EjbhvvQZ/HnEXAIkblHjYgfw/lWP0yNYqhBc3uFMbRknrF8xAcBNlg/CuzhTmGtr8SHf1swOt/SZhHqwSvJyLfQPT+TtKxYRdpG15G22Ws2y/EcOoFNpAoGrhTmk7jkPjerDMyPudJ3Rx6RFJPHc6AXIHM/fdzp2nT0qTroaCIRfe9FjEZjjlDfqOVEtXc8yUB7A35T3unwsH6nM4+OT31NYd570iCQeH3orkUGuY6Wdu1DN+ye+Jas6n6jA7jwyeLYjr3sApiYM5/a+V9mzbOyUZFcXUtFYI3y9RGCywsywCGw1c7X/fI6kC/rzUqfRu3tPp3mOVRXwwO7XaDYHPDteXUBNcwPLxv/e6XkXWpv43a5XKa7/dXLjWHUBX85YSpA80OF5fxxyM1uLD1LVVOv+F/ETRoz8fP6EeGZrEpAhF3xo45eKU1LVjSB5IPemXesy35biA23iWjhQkevyvMzK01biAlQ01nBS73xuPVQRzIK0q53m6UwcstVsEvzaybKS/peKDgd/cZvreo0myo0QganhCTZpLgKQAZDSvafNo18uk9GzW6TLc2/vc5XTVt6ZyLTVTAkg16k00UBvS6rBaJR05Wh64ki38s1KGc+81GltYnVXdOOJoa79pBNDerB09AIiAkMBk7gPDZxFbDeboD82hAeGcGX8ELfq529ya4rF8Tp7A9EKRDEiSxoqaDJIs/IiQ8b4WKfR4azy/mnY7Tw48EZKGypJDo11FLXGhhuTx3JN0ijya8uIDg4jJti+uAajgZIGU5TaZkMrClmAy75BZ8EScTctwip6xnAFkC5MkXJyIyk0xm2RLEQEhra1xvYQJFeIvzxg6rxtKT7A/vIcsqsLaTG0Eh0URs9ukYQogjAYjfQPT+TshSpqmxvaXa6U5NaUiL/jIAXQV5iSX1smWYUSQ6MlK0uIESPfFOr4KHcrOfoiBkT0YnriSB4dfDNDono7/NGVN+rJrDjN3nPH2VGayfkLeolr7pxiWzeXVAWmTSzayJNQ4DCF9DNGx6sLeP7Qp+Toi7gxeRxLR9/tdEwsJCY4gumJI5meOJKnh8/hh9LDfJS7lcOVeb6ttJsU1Z0XJ/VWAPFWmeptMvmMZqN3g3i74pOT23nj2BeM7tGftdOX0CcszuNryWXyNrG3lRzilcPrKbvg301aShoqxUlxCqCHMEXKgb1ewug7Lx1ey7q8XTw29Bbmp0736rWvSRzFFT0H8+zBlWwrkX4O34K+2eZ+xsgBq5+xlCGP8uvOSVLOy4fX8UX+XjQTF3pdXAuhimBeGnc/DwzwahyzdlHVaKNdnBxR4DK9hD3F6qY6Cm3fG17li/y9rD+zi1fHP+gqYLdXeHjQTTw0cKbrjD6gpsVGu+5yRFYdUnsu+HLVqri+gpcOr2XxsNslEdfCgwNv5IbksZKVZ8GOdgFyRNHXRR5sPucrH1qNLDuynjExaczp69Q/yycsGXEXSaE9XGf0Ina0C/O7IVJWVb4939cOc7y6gF1lR/nTMOfB4hpam/iz7gOu/ub/ePynd1z2hJcf38yMb5/h3p3LyKrKd5gvVBHMY0MdugxJhhzTPgJttHdmyRu8eWyT12NHr83bxdT44S6HQitzt/Fd0QGqm+r4sfQI/8xc4zDvnrJjvH/iWyoaazhSmccTP73rMC+Yetf9wxM9qr8n2NGuVg5YPbj9YV2YVZXvVe8Jg9HItuKD3NznCpd5G1qt95p09oqyl9eV1eltfe1uU+ET7GjXKsdkLN1GuB9mlwDezv6Sg+UnvXKtrKozNBlaGBc7wGXee9KuYXh0X8BkrvPk8Dsc5p2WMIJZyeORy2TEdYviH8r7XFqhTE3wOAphu7GjXZ0CKEMQwDsquLtfXDtaDK088dO7fDD5CfqGxbs+wQnZ1UX0D08kSO56782ooDA+nLyYC61NLr0m5DIZz41ZwJKRdxEc4N46cWJID3oEh1PRWOM6cweJCrYxXyqTY9ocuY3IQLf2g/QJ+uZ6Htj1Wod9oQrrz9ErNLZd57THJcZdcS2kSLTkGGGrXbkcsFofTJC4ay+msqmWBzPeYHcHXGbqWi7QrZ0i+JIwRTdJykkMsVmdOysHrGw9eoXGSFIZZ9Q2N/DHvf/mw1zP4l8qZAG0SLyQ4YzalguSlJNkq12ejcB2MvkFI0YqGz1b+IgKCqP8gu/fee5y/oI0e0f36m7zWjotB6wCb6RJOG5zxYyk0R6dl9K9J7k1nWObvPMX9PbiTfoEO9qdUABWk8GWna+9veFye0kIiWaYefhioaG1idWnf+BsQxWDI1MYEtWb1PAEm/Hf0Og+VDTWkKMvIt31Pr8+ZUfpL5KUo5AH2Bt9HFEoteoKnUpTAKRYMqaFJ3G82qu7oLabawWtt8nQzPq83XyQs4XyRmszmUB5AEmhMfTsFtlmIXLBPCHxXdEBvwu8Lm+3JOX0D08Uu9nmAxWWgeJ+zAIDjOzRz+8Cz0ga3Sbsh7lbHNo/NRtaOVNbxhk7pkYb8/dw/4DrvRIVwBO+KdJJ5lw+skeqOEkHvy4VZrjILCkRgaFkVp5m9tZneeXIeo+N2yoaa/y2+4u+uZ43sjZKVt4oW80y4FeBrZ4jyph0v3rX6ZvrWXZkg1esFj/I+c4vIRqeP7SKsw3S2GjJkDE2Nl2cbCXwfkz72QIQ2y2CdDs2xBcjTYYWnt7/X0lNkd7I+oLvS6TpXIFp53GRMX8N8DOYBVZq1c3A98IcUyScJPc1Z2rLeHTfv9E3+z46/bvZX/ORxHHFroofKk7aBjSDtbnOV8Ic1yR5fadTv3KkMo/7d/2LAh8Z+hmMBl46vJZ3sr9yndnL2NHqS8t/hAJvAtoGvwMienXIbrgzcqqmlLt/fJmN+Xu8fu3nDq1i9ekfvX5dV/QJi2OA9VCwFWgLLNomsFKrLgV+EOacmTze1/WTnNrmBp4/tIr7di7zqqmQO+6ovmBm8jhx0g9Am3uoeLV6tfDD7JQJkke7kYrDlXks3PMWc7b/nRW52+yOo+2hb65n99mjNkuakxOG+aKaTpHL5MxOmShOttJQvCK+GlME8VCA+JAoJsUN8XsoQ19yqqaU17M28nrWRmKCIxgS1ZuU7j2J7RZBcEAgRqORqqY6iuvLya4u5FRNKUaMyGUyZiaPY+Gg2cSHRDE8ui9RQWGSeoZcGTdEHEusHmcCK7Xqap1Ksxr4rSVtXuq0S1pgIeWNere/q8FoZHPBT2wpPsj81On8Nn0GV8UPZbNt5DmfMS91qjhpNYI4lWA/XrSVqeCEngPd9r67HGlsbeaDnO9QbV1KpQRmORYGRiYzoecgcbKNmaeNwEqtei9g1c28p/81Xq3cpUhVU22HrFDayz22gWv2IAolDI4jvr8o/HBdL6XdIChd+If+4YlclzRGnPyivbyOBN6EYJ1YLpOxcNBNDrJ2ITUPD5qFXGa1VnAEk2Y22BVYqVUbgL8K06YnjkQZk+atOnbhIWNi0uxFJvorIgcGC84GuZ9jXlO0sHjY7RdlXOVLBblMZs/X6gAmreyf4+iAUqs2Ao8L0wZGJjPXD556XZiY23eKvRHN4+A47qTT5qjUqncCa4VpjwyeTYKt/W0XPiYhJJpHBttsjbQWcDoB7s7zdjECD8RQRTB/GTX/ogq3e7EjQ8ZfRs0Xew/WYtLGKS4FVmrVBcAzwrSJPQcxL3Va+2rZhcfclTqVibaTGs+YtXGKuz2m5YjMetRDVF0zXBIwMDKZR4fcLE7OAN5y53y3BDYPmxYgMOsJkit4edz9HoUV7MI9IgJDeXnc/WIvST2wwKyJS9we8yi16tPAImFar9BY/q68t2vo5APkMjl/U95rz0tykVKrdjugd7uUUWrVHwPvC9MmxQ3haSdO0114xtPD7+DKOJtQxv81a+A2njS9RzBZYbZxR9/J3Jc+w4NLdWGP+9JncIftfMN+YGF7r9VugZVadSOmHaetTBoWDZ7NLX0m2T+pC7e5pc8kFtmOdwuBW833vl149PJUatWFmPZZajNfkCFjyYg7mXUJ2nFJxazk8SwZcad4jqEOmGm+5+3G496RUqs+DMwF2kLPyGVynh39G2anTPD0spctN6VM4NnRvxF3WJuAOeZ77REd6v4qteqvgXkIzG3lMjl/Hf0bFnQZCbjN3f2vtiduKzDffI89psPjG6VWvQG4B4HIMmQ8NvQWnh4+p2sI5QS5TM7Tw+fw+NBbxY/lVuAepVa9vsNldPQCAEqtehWixzXA3H5TeH3CQ0QEdU2GiIkICuX1CQ8xt98U8aEm4E7zPe0wXmte5pZ8M4KOF5jGySunPNU1rSlgYGQyK6c8xSTbcW4tcLM3Wq4Frz4/lVr1N8AUwCpARq/QGD6c/ATzU6df1qtQMmTc2W8KH05+wl40o2Jgivkeeg2vvyCVWvVBYAKiyZAgeSCLh92GZuLDl+V6ckJING9M/ANPDZ9jbze1/cAE873zKj7pAZnHbJOB98THrogbzNrpS7ir31Sx4dgliVwm465+U1k7fYm9RzKYpn4nezrOdYVszBeLXOfqADqV5m5MS1s2241lVxey7OgGdOdzbE+8BFDGprN46G2O+h96QK3Uqld0pAydSuP0uM8FNlciFViBaBtbCztKM1l+bDMna0p8Xhcp6B+eyMLBNzEtYYSjLBmYlvw6vM1rpxDYXBE5poWKvyPaRgBMvj7fFR9gRe7WDgcj9RcDI5O5J+1arksa4+j1UwMsAd5ydz3XFZ1GYAs6lSYFeBVwuMa471w2q05tJ6PsmOSbhLQXuUzOpLjBzE+d7mrjj/XA4+6Y2bSHTiewBZ1KMw1YBtj4YFg421DFpoK9fFX4s9v+u1LRJyyOmcnjmJ0yUezCKeYAsFipVe/wRT06rcAAOpVGhmnpcSng1IM6u7qQrcUH2V2WxYnqIkm3oAfTGHZAZC+uih/KNYmj3Jm4OQI8C2ww25j7hE4tsAXz+/kWTGagLheVyxv1/HzuBAcrTnG48jQna0q8HltTIQ+gf3giw6P7MapHKuN7DnC477CIDExPpo3ees8646IQWIhOpZkIPIRpbtutSewWQyuna0s5WVNKUd15iuvLKWmopLxRT01zAw0tjTQbWto21QgJCCJQriBEEUx4YAgxwREkhESRFBpLcvdY+ocn0C8sQRz70Rn1wBrgHbP7rWRcdAJb0Kk0kZhEnodp+tPtuy0RrZi8Cj4F1ii1ammCQotwJbDrXSv8hPmG/Qf4j06liQdmAzcA12FnmCURtcBWTHGoNim1aum2S/eQTiuwEPONfA94T6fSBAFjgSswTYeOQRAp18sUYOoF78TkQb9fqVU3OT+lc9FpH9HtQafSRAMjgHRMW9b3xbRVUIz5LxQIAizbktQDjeZ/y81/xUCe+S8HyFRq1TY7Lnc2XD2i/wckBEniScYuwQAAAABJRU5ErkJggg==');
		width: 100rpx;
		height: 100rpx;
		background-repeat: no-repeat;
		background-size: 100% 100%;
		margin: 0 auto;
	}

	.pro-wrapper .iconn.iconn1 {
		background-image: url('data:image/png;base64,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');
	}

	.pictrue_log {
		width: 80upx;
		height: 40upx;
		border-radius: 10upx 0 12upx 0;
		line-height: 40upx;
		font-size: 24upx;
	}

	.pictrue_log_class {
		z-index: 3;
		background: -webkit-gradient(linear, left top, right top, from(rgba(246, 122, 56, 1)), to(rgba(241, 27, 9, 1)));
		background: linear-gradient(90deg, rgba(246, 122, 56, 1) 0%, rgba(241, 27, 9, 1) 100%);
		opacity: 1;
		position: absolute;
		top: 0;
		left: 0;
		color: #fff;
		text-align: center;

	}

	.tab_nav .header {
		width: 100%;
		height: 96rpx;
		padding: 0 30rpx 0;
		font-size: 30rpx;
		color: #050505;
		background-color: #fff;
	}

	.icon-xiangzuo {
		/* #ifdef H5 */
		top: 20rpx !important;
		/* #endif */
	}

	.navbar .header .item {
		position: relative;
		margin: 0 25rpx;
	}

	.navbar .header .item.on:before {
		position: absolute;
		width: 60rpx;
		height: 5rpx;
		background-repeat: no-repeat;
		content: "";
		@include linear-gradient(theme);
		bottom: -10rpx;
		left: 50%;
		margin-left: -28rpx;
	}

	.navbar {
		position: fixed;
		// background-color: #fff;
		top: 0;
		left: 0;
		z-index: 99;
		width: 100%;
	}

	.navbar .navbarH {
		position: relative;
	}

	.navbar .navbarH .navbarCon {
		position: absolute;
		bottom: 0;
		height: 100rpx;
		width: 100%;
	}

	.h5_back {
		color: #000;
		position: fixed;
		left:20rpx;
		font-size: 32rpx;
		text-align: center;
		width: 58rpx;
		height: 58rpx;
		background: rgba(255, 255, 255, 0.3);
		border: 1px solid rgba(0,0,0,0.1);
		border-radius: 50%;
	}

	.share-box {
		z-index: 1000;
		position: fixed;
		left: 0;
		top: 0;
		width: 100%;
		height: 100%;

		image {
			width: 100%;
			height: 100%;
		}
	}
	.mask_transparent{
		position: fixed;
		top: 0;
		left: 0;
		right: 0;
		bottom: 0;
		background:transparent;
		z-index: 300;
	}
	.px-12 {
		padding-left: 12rpx;
		padding-right: 12rpx;
	}
	.font-44{
		font-size: 44rpx;
	}
	.font_color{
		@include main_color(theme);
	}
	.attrImg{
		width: 66rpx;
		height: 66rpx;
		border-radius: 6rpx;
		display: block;
		margin-right: 14rpx;
	}
	.switchTxt{
		flex: 1;
		line-height: 54rpx;
		box-sizing: border-box;
		background: #EEEEEE;
		padding-right: 0 24rpx 0;
		border-radius: 8rpx;
		text-align: center;
	}
	.text-333{
		color: #333;
		font-size: 26rpx;
	}
	.text-666{
		font-size: 26rpx;
		color:#666;
		margin-left:4rpx;
	}
	.fw-bold{
		font-weight: 600;
	}
	.ensure{
		width: 100%;
		background-color: #fff;
		padding-bottom: 22rpx;
		padding-bottom: calc(22rpx+ constant(safe-area-inset-bottom)); ///兼容 IOS<11.2/
		padding-bottom: calc(22rpx + env(safe-area-inset-bottom)); ///兼容 IOS>11.2/
		.title{
			font-size: 32rpx;
			color: #282828;
			text-align: center;
			margin: 38rpx 0 36rpx 0;
			position: relative;
			.iconfont{
				position: absolute;
				right: 30rpx;
				top:0;
				font-size: 36rpx;
			}
		}
		.list{
			height: 750rpx;
			margin: 0 30rpx;
			overflow-x: hidden;
			overflow-y: auto;
			.item{
				margin-bottom: 52rpx;
				.pictrue{
					width: 36rpx;
					height: 36rpx;
					border-radius: 50%;
					margin-right: 30rpx;
					image{
						width: 100%;
						height: 100%;
						border-radius: 50%;
					}
				}
				.text{
					width: 618rpx;
					color: #999999;
					font-size: 28rpx;
					.name{
						color: #333333;
						font-weight: bold;
						margin-bottom: 20rpx;
					}
				}
			}
		}
		.bnt{
			width: 690rpx;
			height: 86rpx;
			text-align: center;
			line-height: 86rpx;
			border-radius: 43rpx;
			@include main_bg_color(theme);
			font-size: 30rpx;
			color: #fff;
			margin: 0 auto;
		}
	}
	.ensure.on{
		transform: translate3d(0, 0, 0);
	}
	/deep/ .tui-drawer-container_bottom{
		border-radius: 16rpx 16rpx 0 0;
	}
	.icon-ic_love_2 {
		@include main_color(theme);
	}
</style>