<template>
	<view :data-theme="theme">
		<view class="fixed">
			<uniNavBar background-color="#fff" color="#333" :title="$t(`page.users.userCoupon.navTitle`)" :border='false' @clickLeft='returns' @clickRight="open">
				    <view slot="left" class="iconfont icon-dingbufanhui"></view>
				    <view slot="right" class="iconfont icon-more"></view>
			</uniNavBar>
			<view class="navbar acea-row row-around">
				<view class="item acea-row row-center-wrapper" :class="{ on: navOn === 'usable' }" @click="onNav('usable')">{{$t(`page.users.userCoupon.available`)}}</view>
				<view class="item acea-row row-center-wrapper" :class="{ on: navOn === 'unusable' }" @click="onNav('unusable')">{{$t(`page.users.userCoupon.expired`)}}</view>
			</view>
		</view>
		<view class="couponBox">
			<view class='coupon-list' v-if="couponsList.length">
				<view class='item acea-row row-center-wrapper' v-for='(item,index) in couponsList' :key="index">
					<view class='money' :class="item.validStr==='unusable'||item.validStr==='overdue'||item.validStr==='notStart' ? 'moneyGray' : 'bg_color'">
						<view>{{shopPayCurrency}}<text class='num'>{{item.money?Number(item.money):''}}</text></view>
						<view class="pic-num" v-if="parseFloat(item.minPrice)>0">{{shopPayCurrency}}{{ item.minPrice?Number(item.minPrice):'' }} {{$t(`page.users.userCoupon.min`)}}</view>
					</view>
					<view class='text'>
						<view class='condition line2'>
							<span>{{item.name}}</span>
						</view>
						<span class="font-mini" :class="item.validStr==='unusable'||item.validStr==='overdue'||item.validStr==='notStart' ? 'bg-color-huic' : 'bg-color-check'">{{item.useType===1?$t(`page.users.userCoupon.navList[0].name`):$t(`page.users.userCoupon.navList[1].name`)}}</span>
						<view class='data acea-row row-between-wrapper'>
							<view class="time">{{ item.startTime | dateFormat }}~{{ item.endTime | dateFormat }}</view>
							<view class='bnt' :class="item.validStr==='unusable'||item.validStr==='overdue'||item.validStr==='notStart'?'gray':'bg_color'">{{item.validStr | validStrFilter}}</view>
						</view>
					</view>
				</view>
			</view>
			<view class='loadingicon acea-row row-center-wrapper'>
			     <text class='loading iconfont icon-jiazai' :hidden='loading==false'></text>{{loadTitle}}
			  </view>
			<view class='noCommodity' v-if="!couponsList.length && !loading">
				<view class='pictrue text-center'>
					<image src='../../../static/images/noCoupon.png'></image>
				</view>
				<text class="text-ccc">{{$t(`page.users.userCoupon.empty`)}}</text>
			</view>
		</view>
		<tui-drawer mode="right" :visible="rightDrawer" @close="closeDrawer">
			<user-drawer @close="closeDrawer"></user-drawer>
		</tui-drawer>
	</view>
</template>

<script>
	import {
		getUserCoupons
	} from '@/api/api.js';
	import {
		toLogin
	} from '@/libs/login.js';
	import {
		mapGetters
	} from "vuex";
	let app = getApp();
	export default {
		filters: {
		    validStrFilter(status) {
		      const statusMap = {
		        'usable': '可用',
		        'unusable': '已用',
				'overdue': '过期',
				'notStart': '未开始'
		      }
		      return statusMap[status]
		    }
		},
		data() {
			return {
				couponsList: [],
				loading: false,
				loadend: false,
				loadTitle: this.$t('page.goodsList.more'),//提示语
				page: 1,
				limit: 20,
				navOn: 'usable',
				isAuto: false, //没有授权的不会自动授权
				isShowAuth: false, //是否隐藏授权
				theme:app.globalData.theme,
				rightDrawer: false,
				shopPayCurrency: app.globalData.shopPayCurrency //货币符号
			};
		},
		computed: mapGetters(['isLogin']),
		watch: {
			isLogin: {
				handler: function(newV, oldV) {
					if (newV) {
						this.getUseCoupons();
					}
				},
				deep: true
			}
		},
		onLoad() {
			uni.setNavigationBarTitle({
				title: this.$t(`page.users.userCoupon.navTitle`)
			})
			if (this.isLogin) {
				this.getUseCoupons();
			} else {
				toLogin();
			}
		},
		methods: {
			onNav: function(type) {
				this.navOn = type;
				this.couponsList = [];
				this.page = 1;
				this.loadend = false;
				this.getUseCoupons();
			},
			/**
			 * 获取领取优惠券列表
			 */
			getUseCoupons: function() {
				let that = this;
				if(this.loadend) return false;
				if(this.loading) return false;
				this.loading = true;
				getUserCoupons({ page: that.page, limit: that.limit, type: that.navOn}).then(res => {
					let list= res.data.list ? res.data.list : [],loadend=list.length < that.limit;
					let couponsList = that.$util.SplitArray(list, that.couponsList);
					that.$set(that,'couponsList',couponsList);
					that.loadend = loadend;
					that.loadTitle = loadend ? '' : this.$t('page.goodsList.more');
					that.page = that.page + 1;
					that.loading = false;
				}).catch(err=>{
					  that.loading = false;
					  that.loadTitle = this.$t('page.goodsList.more');
				  });
			},
			returns: function() {
				uni.navigateBack()
			},
			open(){
				this.rightDrawer = true
			},
			closeDrawer(e) {
				this.rightDrawer = false
				if(!e){
					this.rightDrawer = false
				}
			},
		},
		/**
		  * 页面上拉触底事件的处理函数
		  */
		 onReachBottom: function () {
		   this.getUseCoupons();
		 }
	}
</script>

<style lang="scss" scoped>
	.couponBox{
		margin-top: 210rpx;
	}
	.fixed{
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		background-color: #fff;
		z-index: 9;
	}
	.navbar {
		width: 100%;
		height: 106rpx;
	
		.item {
			border-top: 5rpx solid transparent;
			border-bottom: 5rpx solid transparent;
			font-size: 30rpx;
			color: #999999;
			&.on{
				@include tab_border_bottom(theme);
				@include main_color(theme);
			}
		}
	}
	
	
	.money {
		display: flex;
		flex-direction: column;
		justify-content: center;
	}
	.bg_color{
		@include main_bg_color(theme);
	}
	.pic-num {
		color: #ffffff;
		font-size: 24rpx;
	}
	.coupon-list .item .text{
		height: 100%;
	}
	.coupon-list .item .text .condition{
		/* display: flex;
		align-items: center; */
	}
	.condition .line-title {
		width: 90rpx;
		height: 40rpx !important;
		line-height: 40rpx !important;
		padding: 2rpx 10rpx;
		-webkit-box-sizing: border-box;
		box-sizing: border-box;
		@include coupons_border_color(theme);
		opacity: 1;
		border-radius: 20rpx;
		font-size: 18rpx !important;
		@include main_color(theme);
		margin-right: 12rpx;
	}
	.font_color{
		@include main_color(theme);
	}
</style>
