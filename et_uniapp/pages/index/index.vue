<template>
	<view>
		<tui-skeleton v-if="skeletonShow"></tui-skeleton>
		<view class="page-index tui-skeleton">
			<view class="header">
				<view class="logo">
					<image class="tui-skeleton-rect" :src="logoUrl"></image>
				</view>
				<view class="search" @click="search()">
					<view class="search_input tui-skeleton-fillet">
						<view class="text-ccc">{{$t(`page.goodsSearch.place`)}}</view>
						<view class="input_btn">
							<text class="iconfont icon-sousuo2"></text>
						</view>
					</view>
				</view>
				<view class="open iconfont icon-more tui-skeleton-rect" @click="open"></view>
			</view>
			<view class="page_content">
				<view class="swiperlone tui-skeleton-rect">
					<swiper v-show="indexBannerType==1" :indicator-dots="false" :autoplay="true"  circular="true" interval="2500" duration="500" >
						<block v-for="(item,index) in imgUrls" :key="index">
							<swiper-item>
								<view class="slide-image" @click="menusTap(item.url)">
									<easy-loadimage mode="scaleToFill" :image-src="item.pic"></easy-loadimage>
								</view>
							</swiper-item>
						</block>
					</swiper>
				</view>
				<view v-show="indexBannerType==2">
					<view class="mp-bg"></view>
					<view class="swipershort tui-skeleton-rect">
						<swiper :indicator-dots="false" :autoplay="true"  circular="true" interval="2500" duration="500" >
							<block v-for="(item,index) in imgUrls" :key="index">
								<swiper-item>
									<view @click="menusTap(item.url)">
										<image :src="item.pic" class="slide-image" lazy-load></image>
									</view>
								</swiper-item>
							</block>
						</swiper>
					</view>
				</view>
				<!-- nav 地址栏 优惠券 -->
				<view class="nav">
					<view class="menu">
						<view class="menu_item tui-skeleton-fillet" v-for="(item,index) in menuList" :key="index" @click="menusTap(item.url)">
						    <easy-loadimage :image-src="item.pic" :key="item.pic"></easy-loadimage>
							<text class="menu_name tui-skeleton-rect">{{item.name}}</text>
						</view>
					</view>
				</view>
				<block v-for="(item, index) in activityindexList" :key="index">
					<recommended v-if="item.type === 1" :activityData="item"></recommended>
					<promotions v-if="item.type === 2" :activityData="item"></promotions>
					<first-new v-if="item.type === 3" :activityData="item"></first-new>
				</block>
				<!-- 店铺入口 -->
				 <index-shop :shopList="rankingList"></index-shop>
				 <!-- categories 特色分类 -->
				 <categories :categoryList="categoryList"></categories>
				  <!-- middle_banner 轮播广告 -->
				 <view class="middle_banner tui-skeleton-fillet">
				 	<swiper :indicator-dots="false" :autoplay="true"  circular="true" interval="2500" duration="500" >
				 		<block v-for="(item,index) in bastBanner" :key="index">
				 			<swiper-item>
				 				<view @click="menusTap(item.url)">
				 					<image :src="item.pic" class="slide-image" lazy-load></image>
				 				</view>
				 			</swiper-item>
				 		</block>
				 	</swiper>
				 </view>
				 <!-- 底部商品列表 -->
				 <view v-if="tempArr.length>0" class="waterfall">
					 <view class="index-product-wrapper" >
						<view class="waterfall_title">{{$t(`page.index.titAlso`)}}</view>
					 	<view class="list-box animated">
							 <WaterfallsFlow :shopPayCurrency="shopPayCurrency" :wfList='tempArr' :type="1" :isStore="1"/>
						</view>
					</view>
				 </view>
			</view>
		    <!-- 底部导航距离，做兼容处理的-->
		    <view v-if="bottomNavigationIsCustom" class="footerBottom"></view>
			<!-- 底部导航 -->
			<pageFooter></pageFooter>
		</view>
		<tui-drawer mode="right" :visible="rightDrawer" @close="closeDrawer">
			<user-drawer @close="closeDrawer"></user-drawer>
		</tui-drawer>
	</view>
</template>
<script>
	import recommended from './components/recommended.vue';
	import goodsRank from './components/goodsRank';
	// import swiperItem from './components/swiperItem.vue';
	import promotions from './components/promotions.vue';
	import firstNew from './components/firstNew.vue';
	import categories from './components/categories.vue';
	import indexShop from './components/shop.vue'
	import WaterfallsFlow from '@/components/WaterfallsFlow/WaterfallsFlow.vue'
	import pageFooter from "@/components/pageFooter/index.vue";
	import {getGroomList, getActivityindexList} from '@/api/store.js';
	import {getIndexData,setCouponReceive,} from '@/api/api.js';
	import Cache from "@/utils/cache.js"
	import {mapGetters} from "vuex"; 
	import {
		goShopDetail
	} from '@/libs/order.js'
	let app = getApp();
	export default {
		computed: mapGetters(['bottomNavigationIsCustom']),
		data() {
			return {
				skeletonShow: true,
				logoUrl:'',
				params: { //精品推荐分页
					page: 1,
					limit: 10,
				},
				goodScroll: true,
				loaded: false,
				loading: false,
				iSshowH: false,
				imgUrls: [],
				menuList:[{},{},{},{}],
				tempArr:[],
				bastBanner:[],
				loading: false,
				rightDrawer: false,
				activityindexList: [],
				categoryList: [],
				rankingList: [],
				indexBannerType: '1',
				shopPayCurrency: app.globalData.shopPayCurrency //货币符号
			}
		},
		components:{
			WaterfallsFlow,
			recommended,
			goodsRank,
			// swiperItem,
			promotions,
			firstNew,
			categories,
			indexShop,
			pageFooter
		},
		// 滚动监听
		onPageScroll(e) {
		   // 传入scrollTop值并触发所有easy-loadimage组件下的滚动监听事件
		   uni.$emit('scroll');
		},
		onLoad() {
			uni.setNavigationBarTitle({
				title: this.$t(`page.store.merInfo`)
			})
			// let locale = (navigator.language || navigator.browserLanguage).toLowerCase();
			// uni.setStorageSync('locale', locale);
			uni.setNavigationBarTitle({
				title: this.$t(`userDrawer.data[0].name`)
			})
			this.getIndexConfig();
			this.getActivityindex();
		},
		mounted() {
		},
		methods: {
			getActivityindex() {
				getActivityindexList().then(res => {
					this.activityindexList = res.data;
				}).catch(res => {
					return this.$util.Tips({
						title: res
					});
				});
			},
			open() {
				this.rightDrawer = true
			},
			closeDrawer(e) {
				this.rightDrawer = false;
				if(!e){
					this.rightDrawer = false
				}
			},
			search(){
				uni.navigateTo({
					url:'/pages/goods_search/index'
				})
			},
			menusTap(url){
				this.$util.navigateTo(url);
			},
			// 首页数据
			getIndexConfig: function() {
				let that = this;
				getIndexData().then(res => {
					that.$set(that, "logoUrl", res.data.logoUrl);
					that.$set(that, "imgUrls", res.data.banner);
					that.$set(that, "menuList", res.data.menus); //bastBanner
					that.$set(that, "bastBanner", res.data.bastBanner); //bastBanner
					that.$set(that, "categoryList", res.data.categoryList); //categoryList
					that.$set(that, "rankingList", res.data.ranking);
					that.$set(that, "indexBannerType", res.data.indexBannerType);
					// 保存商品分类页配置
					that.$Cache.setItem({
						name: 'categoryConfig',
						value: {
							categoryConfig: res.data.categoryPageConfig,
							isShowCategory: res.data.isShowCategory
						}
					});
					that.$store.commit("SET_CHATURL", res.data.consumerH5Url);
					Cache.setItem({
						name:'merPlatChatConfig',
						value:{
							consumerHotline:res.data.consumerHotline, //客服电话
							consumerH5Url:res.data.consumerH5Url, //云智服
							consumerMessage:res.data.consumerMessage, //基于facebook的message消息
							consumerEmail:res.data.consumerEmail, //客服邮箱
							consumerType:res.data.consumerType //客服类型四选一
						}
					});
					this.skeletonShow = false;
					this.getGroomList();
				}).catch(err => {
					this.skeletonShow = false;
					return this.$util.Tips({
						title: err
					});
				});;
			},
			// 精品推荐
			getGroomList(onloadH) {
				this.loading = true
				let type = this.goodType;
				if (!this.goodScroll) return
				if (onloadH) {
					this.iSshowH = true
				}
				getGroomList(this.params).then(({
					data
				}) => {
					this.iSshowH = false
					this.loading = false
					this.goodScroll = data.list.length >= this.params.limit
					this.params.page++
					this.tempArr = this.tempArr.concat(data.list)
				})
			},
			goDetail(item) {
				uni.navigateTo({
					url: `/pages/goods_details/index?id=${item.id}` 
				})
			},
		},
		// 滚动到底部
		onReachBottom() {
			if (this.params.page != 1) {
				this.getGroomList();
			}
		},
	};
</script>
<style lang="scss">
	page {
		// height: auto;
		height: 100%;
		background-color: #fff;
	}
	.text-ccc{
		text-align: left;
		width: auto;
		margin-left: 20rpx;
	}
	.mp-bg {
			position: absolute;
			left: 0;
			/* #ifdef H5 */
			top: 98rpx;
			/* #endif */
			width: 100%;
			height: 304rpx;
			@include index-gradient(theme);
		}
	.header{
		width: 100%;
		height: 100rpx;
		@include main_bg_color(theme);
		display: flex;
		align-items: center;
		.logo{
			width: 138rpx;
			height: 48rpx;
			margin: 0 30rpx 0;
		}
		image {
			width: 138rpx;
			height: 48rpx;
		}
		.search{
			width: 450rpx;
			height: 65rpx;
			.search_input{
				width: 100%;
				height: 65rpx;
				line-height: 65rpx;
				background: #FFFFFF;
				border-radius: 35rpx;
				position: relative;
				.input_btn{
					position: absolute;
					top: 0;
					right: 0;
					width: 82rpx;
					height: 64rpx;
					background: #EEEEEE;
					border-radius: 0px 35rpx 35rpx 0px;
					text-align: center;
					line-height: 64rpx;
					font-size: 28rpx;
					color: #999;
				}
			}
		}
		.open{
			width: 40rpx;
			height: 36rpx;
			color: #fff;
			font-size: 40rpx;
			margin: 0 36rpx 0 30rpx;
		}
	}
	.page_content{
		background-color: #fff;
		.swipershort{
			position: relative;
			width: 100%;
			height: 320rpx;
			margin: 0 auto;
			border-radius: 10rpx;
			overflow: hidden;
			margin-bottom: 25rpx;
			padding:0 15px;
			/* #ifdef MP */
			z-index: 10;
			margin-top: 20rpx;
			
			/* #endif */
			swiper,
			.swiper-item,
			image {
				width: 100%;
				height: 320rpx;
				border-radius: 10rpx;
			}
		}
		.swiperlone{
			width: 100%;
			swiper,.swiper-item{
				height: 750rpx;
			}
			.slide-image,/deep/.easy-loadimage > uni-image>div, uni-image>img ,/deep/.easy-loadimage > uni-image
			 {
				width: 100%;
				height: 750rpx;
				overflow: initial !important;
			}
		}
		.nav{
			width: 100%;
			background: linear-gradient(180deg, #F5F5F5 0%, #FFFFFF 100%);
			padding: 0 30rpx 0;
			box-sizing: border-box;
			.menu{
				display: flex;
				justify-content: space-between;
				flex-wrap: wrap;
				.menu_item{
					width: 156rpx;
					height: 148rpx;
					background: #FFFFFF;
					border-radius: 16rpx;
					display: flex;
					flex-direction: column;
					justify-content: center;
					align-items: center;
					margin-top: 32rpx;
					.easy-loadimage,image,uni-image a{
						width: 60rpx;
						height: 60rpx;
					}
					.menu_name{
						font-size: 24prx;
						font-family: PingFangSC-Regular, PingFang SC;
						font-weight: 400;
						color: #333333;
						padding-top: 16rpx;
					}
				}
			}
		}

		.middle_banner{
			width: 690rpx;
			height: 115rpx;
			margin: 70rpx auto 0;
			swiper,.swiper-item{
				height:  115rpx !important;
			}
			image {
				width: 100%;
				height: 115rpx;
			}
		}
		.waterfall{
			background:#F5F5F5;
			.waterfall_title{
				font-size: 36rpx;
				font-weight: bold;
				color: #282828;
				padding: 30rpx 0 32rpx 30rpx;
				background: linear-gradient(180deg, #FFFFFF 0%, #F5F5F5 100%);
			}
			.index-product-wrapper {
				margin-bottom: 110rpx;
				&.on {
					min-height: 1500rpx;
				}
				.list-box {
					display: flex;
					flex-wrap: wrap;
					justify-content: space-between;
			        padding-left: 30rpx;
					.item {
						width: 335rpx;
						margin-bottom: 22rpx;
						background-color: #fff;
						border-radius: 10rpx;
						overflow: hidden;
			
						image {
							width: 100%;
							height: 330rpx;
						}
			
						.text-info {
							padding: 10rpx 20rpx 15rpx;
			
							.title {
								color: #222222;
							}
			
							.old-price {
								margin-top: 8rpx;
								font-size: 26rpx;
								color: #AAAAAA;
								text-decoration: line-through;
								font-weight: normal !important;
								text {
									margin-right: 2px;
									font-size: 20rpx;
								}
							}
			
							.price {
								display: flex;
								align-items: flex-end;
								@include price-color(theme);
								font-size: 34rpx;
								font-weight: 800;
								margin-top:0;
								text {
									padding-bottom: 4rpx;
									font-size: 24rpx;
									font-weight: 800;
								}
			
								.txt {
									display: flex;
									align-items: center;
									justify-content: center;
									width: 28rpx;
									height: 28rpx;
									margin-left: 15rpx;
									margin-bottom: 10rpx;
									border: 1px solid $theme-color;
									border-radius: 4rpx;
									font-size: 22rpx;
									font-weight: normal;
								}
							}
						}
					}
			
					&.on {
						display: flex;
					}
				}
			}
		}
		
	}
</style>