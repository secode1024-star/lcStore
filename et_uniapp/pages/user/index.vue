<template>
	<view :data-theme="theme">
		<view class="new-users copy-data"  >
			<view>
				<view class="main_bg">
					<uniNavBar background-color="transparent" color="#fff" :title="$t(`page.user.navTitle`)" :border='false' @clickLeft='returns' @clickRight="open">
						    <view slot="right" class="iconfont icon-more"></view>
					</uniNavBar>
				</view>
				<view class="head pad30">
					<view class="user-card">
						<view class="user-info">
							<image class="avatar" :src='userInfo.avatar' v-if="userInfo.avatar && uid"
								@click="goEdit()"></image>
							<image v-else class="avatar" src="../../static/images/default_avatar.png" mode="" @click="goEdit()"></image>
							<view class="info">
								<view class="name" v-if="!uid" @tap="openAuto">
									{{$t(`page.user.placeLogin`)}}
								</view>
								<view class="name" v-if="uid">
									{{userInfo.nickname}}
								</view>
								<view class="flex">
									<view class="num" v-if="userInfo.email && uid">
										<text class="iconfont icon-youxiang"></text>
										<view class="num-txt">{{userInfo.email}}</view>
									</view>
									<view class="num" v-if="userInfo.phone && uid && userInfo.email == ''">
										<text class="iconfont icon-shouji"></text>
										<view class="num-txt">{{userInfo.phone}}</view>
									</view>
								</view>
								<!-- <view class="phone" v-if="!userInfo.phone && isLogin" @tap="bindPhone">绑定手机号</view> -->
								<text class="iconfont icon-shezhi app_set" @click.stop="goEdit()"></text>
							</view>
						</view>
						<view class="num-wrapper">
							<view class="num-item" @click="goMenuPage('/pages/users/user_goods_collection/index')">
								<text class="num">{{userInfo.collectCount && uid ? userInfo.collectCount : 0}}</text>
								<view class="txt">{{$t(`page.user.like`)}}</view>
							</view>
							<view class="num-item" @click="goMenuPage('/pages/users/user_coupon/index')">
								<text class="num">{{userInfo.couponCount && uid ? userInfo.couponCount : 0}}</text>
								<view class="txt">{{$t(`page.user.coupons`)}}</view>
							</view>
						</view>
					</view>
					<view class="order-wrapper">
						<view class="order-hd flex">
							<view class="left">{{$t(`page.user.orderCenter`)}}</view>
							<view class="right flex" @click="menusTap('/pages/users/order_list/index')">{{$t(`page.user.myOrder`)}}
								<text class="iconfont icon-gengduo"></text> 
							</view>
						</view>
						<view class="order-bd">
							<block v-for="(item,index) in orderMenu" :key="index">
								<view class="order-item" @click="menusTap(item.url)"> 
									<view class="pic">
										<text class="iconfont pic_status" :class="item.img"></text>
										<text class="order-status-num" v-if="item.num > 0">{{ item.num }}</text>
									</view>
									<view class="txt">{{$t(`page.user.orderStatus[${index}].name`)}}</view>
								</view>
							</block>
						</view>
					</view>
				</view>
				<view class="contenBox">
					<!-- 轮播 -->
					<view class="slider-wrapper"  v-if="imgUrls != null && imgUrls.length > 0">
						<swiper v-if="imgUrls.length>0" indicator-dots="true" :autoplay="autoplay" :circular="circular" :interval="interval"
							:duration="duration" indicator-color="rgba(255,255,255,0.6)" indicator-active-color="#fff">
							<block v-for="(item,index) in imgUrls" :key="index">
								<swiper-item class="borRadius14">
									<image :src="item.pic" class="slide-image" @click="navito(item.url)"></image>
								</swiper-item>
							</block>
						</swiper>
					</view>
					<!-- 会员菜单 -->
					<view class="user-menus mt-20">
						<view class="menu-title">{{$t(`page.user.services`)}}</view>
						<view class="menu_item" v-for="(item,index) in MyMenus" :key="index" @click="menusTap(item.url)">
							<view class="flex align-center">
								<image :src="item.pic"></image>
								<text class="pl-20">{{item.name}}</text>
							</view>
							<text class="iconfont icon-gengduo"></text>
						</view>
						<view class="menu_item" @click="kefuClick()">
							<view class="flex align-center">
								<image src="/static/images/chat_icon.png"></image>
								<text class="pl-20">{{$t(`page.user.contact`)}}</text>
							</view>
							<text class="iconfont icon-gengduo"></text>
						</view>
					</view>
					<image src="/static/images/support.png" alt="" class='support'>
					<view class="uni-p-b-98"></view>
				</view>
			</view>
		</view>
		 <!-- 底部导航距离，做兼容处理的-->
		<view v-if="bottomNavigationIsCustom" class="footerBottom"></view>
		<!-- 底部导航 -->
		<pageFooter></pageFooter>
		<tui-drawer mode="right" :visible="rightDrawer" @close="closeDrawer">
			<user-drawer @close="closeDrawer"></user-drawer>
		</tui-drawer>
	</view>
</template>
<script>
	import Cache from '@/utils/cache';
	import {BACK_URL} from '@/config/cache';
	import {getMenuList} from '@/api/user.js';
	import {orderCenterData} from '@/api/order.js';
	import {toLogin} from '@/libs/login.js';
	import {mapGetters} from "vuex";
	import {getShare} from '@/api/public.js';
	import {setThemeColor} from '@/utils/setTheme.js'
	import {chatConfig} from '@/utils/consumerType.js'
	import pageFooter from "@/components/pageFooter/index.vue";
	const app = getApp();
	export default {
		computed: mapGetters(['isLogin', 'chatUrl', 'userInfo', 'uid', 'bottomNavigationIsCustom']),
		components: {
			pageFooter
		},
		data() {
			return {
				orderMenu: [
					{img: 'icon-daifukuan',title: '待付款',url: '/pages/users/order_list/index?status=0',num: 0},
					{img: 'icon-daifahuo',title: '待发货',url: '/pages/users/order_list/index?status=1',num: 0},
					{img: 'icon-daishouhuo',title: '待收货',url: '/pages/users/order_list/index?status=2',num: 0},
					{img: 'icon-daipingjia-2',title: '待评价',url: '/pages/users/evaluation_list/index',num: 0},
					{img: 'icon-shouhou_tuikuan-2',title: '售后/退款',url: '/pages/users/user_return_list/index',num: 0},
				],
				imgUrls: [],
				userMenu: [],
				autoplay: true,
				circular: true,
				interval: 3000,
				duration: 500,
				isAuto: false, //没有授权的不会自动授权
				orderStatusNum: {},
				MyMenus: [],
				wechatUrl: [],
				servicePic: '/static/images/customer.png',
				configApi: {}, //分享类容配置
				theme:app.globalData.theme,
				bgColor:'#e93323',
				rightDrawer: false
			}
		},
		onLoad() {
			uni.setNavigationBarTitle({
				title: this.$t(`page.user.navTitle`)
			})
			let that = this;
			that.$set(that, 'MyMenus', app.globalData.MyMenus);
			if (that.isLogin == false) {
				// toLogin()
			}
			that.bgColor = setThemeColor();
		},
		onShow: function() {
			let that = this;
			if (that.isLogin) {
				this.getMyMenus();
				this.getOrderData();
				this.$store.dispatch('USERINFO');
			} else {
				// toLogin();
			}
		},
		methods: {
			open(){
				this.rightDrawer = true
			},
			closeDrawer(e) {
				this.rightDrawer = false
				if(!e){
					this.rightDrawer = false
				}
			},
			//菜单跳转
			menusTap(url) {
				this.$util.navigateTo(url);
			},
			//轮播图跳转
			navito(url) {
				this.$util.navigateTo(url);
			},
			kefuClick() {
				chatConfig();
			},
			//订单数量
			getOrderData() {
				let that = this;
				orderCenterData().then(res => {
					that.orderMenu.forEach((item, index) => {
						switch (item.title) {
							case '待付款':
								item.num = res.data.unPaidCount
								break
							case '待发货':
								item.num = res.data.unShippedCount
								break
							case '待收货':
								item.num = res.data.receivedCount
								break
							case '待评价':
								item.num = res.data.commentCount
								break
							case '售后/退款':
								item.num = res.data.refundCount
								break
						}
					})
					that.$set(that, 'orderMenu', that.orderMenu);
				})
			},
			// 打开授权
			openAuto() {
				Cache.set(BACK_URL, '/pages/user/index')
				uni.navigateTo({
					url: '/pages/users/login/index?isToLogin=isToLogin'
				})
			},
			/**
			 * 
			 * 获取个人中心图标
			 */
			getMyMenus: function() {
				let that = this;
				getMenuList().then(res => {
					that.$set(that, 'MyMenus', res.data.routine_my_menus);
					that.wechatUrl = res.data.routine_my_menus.filter((item) => {
						return item.url.indexOf('service') !== -1
					})
					res.data.routine_my_menus.map((item) => {
						if (item.url.indexOf('service') !== -1) that.servicePic = item.pic
					})
					// that.imgUrls = res.data.routine_my_banner
					if(res.data.routine_my_banner){
						that.imgUrls = res.data.routine_my_banner
					}
				});
			},
			// 编辑页面
			goEdit() {
				if (this.isLogin == false) {
					toLogin();
				} else {
					uni.navigateTo({
						url: '/pages/users/user_info/index'
					})
				}
			},
			// goMenuPage
			goMenuPage(url) {
				if (this.isLogin) {
					uni.navigateTo({
						url
					})
				}
			},
			returns(){
				uni.navigateBack()
			}
		}
	}
</script>

<style lang="scss" scoped>
	page,
	body {
		height: 100%;
	}
	.main_bg{
		@include main_bg_color(theme);
	}
	.contenBox {
		padding: 0 30rpx;
	}

	.support {
		width: 219rpx;
		height: 74rpx;
		margin: 54rpx auto;
		display: block;
	}

	.new-users {
		display: flex;
		flex-direction: column;
		height: 100%;

		.sys-head {
			position: relative;
			width: 100%;
			background: linear-gradient(90deg, $bg-star1 0%, $bg-end1 100%);

			.sys-title {
				z-index: 10;
				position: relative;
				height: 43px;
				text-align: center;
				line-height: 43px;
				font-size: 36rpx;
				color: #FFFFFF;
			}
		}

		.head {
			@include index-gradient(theme);
			.user-card {
				position: relative;
				width: 100%;
				margin: 0 auto;
				padding: 35rpx 0 30rpx 0;
				.user-info {
					z-index: 20;
					position: relative;
					display: flex;

					.avatar {
						width: 120rpx;
						height: 120rpx;
						border-radius: 50%;
					}

					.info {
						flex: 1;
						display: flex;
						flex-direction: column;
						justify-content: space-between;
						margin-left: 20rpx;
						padding: 15rpx 0;
						position: relative;

						.name {
							display: flex;
							align-items: center;
							color: #fff;
							font-size: 31rpx;
						}
						.app_set{
							position: absolute;
							font-size: 36rpx;
							color: #fff;
							top: 40rpx;
							right: 20rpx;
						}

						.num {
							display: flex;
							align-items: center;
							padding: 6rpx 20rpx 6rpx 0;
							font-size: 20rpx;
							color: #fff;
							.iconfont {
								font-size: 20rpx;
							}
							.icon-youxiang{
								padding-right: 10rpx;
							}
						}
					}
				}

				.num-wrapper {
					z-index: 30;
					position: relative;
					display: flex;
					align-items: center;
					justify-content: space-between;
					margin-top: 30rpx;
					height: 138rpx;
					color: #333;
					background-color: #fff;
					border-radius: 14rpx;
					.num-item {
						width: 33.33%;
						text-align: center;

						.num {
							font-size: 42rpx;
							font-weight: bold;
						}

						.txt {
							margin-top: 10rpx;
							font-size: 24rpx;
							color: #333;
						}
					}
				}

				.sign {
					z-index: 200;
					position: absolute;
					right: -12rpx;
					top: 80rpx;
					display: flex;
					align-items: center;
					justify-content: center;
					width: 120rpx;
					height: 60rpx;
					background: linear-gradient(90deg, rgba(255, 225, 87, 1) 0%, rgba(238, 193, 15, 1) 100%);
					border-radius: 29rpx 4rpx 4rpx 29rpx;
					color: #282828;
					font-size: 28rpx;
					font-weight: bold;
				}
			}

			.order-wrapper {
				background-color: #fff;
				border-radius: 14rpx;
				padding: 30rpx 16rpx;
				position: relative;
				z-index: 11;
                
				.order-hd {
					justify-content: space-between;
					font-size: 30rpx;
					color: #282828;
					margin-bottom: 40rpx;
					padding: 0 16rpx;

					.left {
						color: #282828;
						font-size: 30rpx;
						font-weight: 600;
					}

					.right {
						align-items: center;
						color: #666666;
						font-size: 26rpx;

						.icon-xuanze {
							margin-left: 5rpx;
							font-size: 24rpx;
						}
					}
				}

				.order-bd {
					display: flex;
					justify-content: space-between;
					padding: 0;

					.order-item {
						display: flex;
						flex-direction: column;
						justify-content: center;
						align-items: center;

						.pic {
							position: relative;
							text-align: center;

							image {
								width: 48rpx;
								height: 48rpx;
							}
						}

						.txt {
							margin-top: 15rpx;
							font-size: 26rpx;
							color: #454545;
						}
					}
				}
			}
		}

		.slider-wrapper {
			margin: 20rpx 0;
			height: 138rpx;

			swiper,
			swiper-item {
				height: 100%;
			}

			image {
				width: 100%;
				height: 100%;
			}
		}

		.user-menus {
			background-color: #fff;
			border-radius: 14rpx;
			padding: 30rpx 30rpx 0;
			.menu-title {
				padding-bottom: 40rpx;
				font-size: 30rpx;
				color: #282828;
				font-weight: 600;
			}
			.menu_item{
				height: 100rpx;
				display: flex;
				justify-content: space-between;
				align-items: center;
				border-bottom: 2rpx solid #f5f5f5;
				image{
					width: 42rpx;
					height: 42rpx;
				}
				.text-999{
					color: #999;
					font-size: 28rpx;
				}
			}
		}

		.phone {
			color: #fff;
		}
		.pic_status{
			font-size: 43rpx;
			@include main_color(theme);
		}
		.order-status-num {
			min-width: 13rpx;
			background-color: #fff;
			@include main_color(theme);
			border-radius: 15px;
			position: absolute;
			right: -14rpx;
			top: -15rpx;
			font-size: 20rpx;
			padding: 0 8rpx;
			@include coupons_border_color(theme);
		}
		
	}
	.sub_btn{
		width: 690rpx;
		height: 86rpx;
		line-height: 86rpx;
		margin-top: 60rpx;
		background: $theme-color;
		border-radius: 43rpx;
		color: #fff;
		font-size: 28rpx;
		text-align: center;
	}
</style>
