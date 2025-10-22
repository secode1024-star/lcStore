<template>
	<view class="">
		<uni-nav-bar background-color="#fff" color="#333" :title="$t(`page.user.record`)" :border='false' @clickLeft='returns' @clickRight="open">
			<view slot="left" class="iconfont icon-dingbufanhui"></view>
			<view slot="right" class="iconfont icon-more"></view>
		</uni-nav-bar>
		<view class="application-record" v-if="listData.length">
			<view class="card-list" v-for="item in listData" :key="item.id">
				<view class="card-top">
					<view class="title">{{item.name}}</view>
					<view class="time">{{$t(`message.tips.time`)}}：{{item.createTime}}</view>
					<view v-if="item.denialReason" class="reason">{{$t(`message.tips.reason`)}}：{{item.denialReason}}</view>
				</view>
				<view class="line"></view>
				<view class="card-bottom">
					<view class="card-status">
						<image class="status-icon" v-if="item.auditStatus === 1" src="../images/pending.png" mode=""></image>
						<image class="status-icon" v-else-if="item.auditStatus === 2" src="../images/passed.png" mode=""></image>
						<image class="status-icon" v-else-if="item.auditStatus === 3" src="../images/not-pass.png" mode=""></image>
						<text class="status-text">{{statusText(item.auditStatus)}}</text>
					</view>
					<!-- <view class="status-btn" @click="jump(item)">{{statusBtn(item.auditStatus)}}</view> -->
				</view>
			</view>
		</view>
		<view class='no-shop' v-if="!listData.length && !loading">
			<view class='pictrue' style="margin: 0 auto;" @click="menusTap()">
				<image src='/static/images/noShopper.png'></image>
				<text class="text-ccc">{{$t(`message.settled.appleTips`)}}</text>
			</view>
		</view>
		<tui-drawer mode="right" :visible="rightDrawer" @close="closeDrawer">
			<user-drawer @close="closeDrawer"></user-drawer>
		</tui-drawer>
	</view>
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
	import {
		getMerSettledRecordApi
	} from '@/api/merchant.js'
	export default {
		data() {
			return {
				loading: false,
				listData: [],
				pageData: {
					page: 1,
					limit: 10,
				},
				rightDrawer: false
			}
		},
		onLoad() {
			uni.setNavigationBarTitle({
				title: this.$t(`page.user.record`)
			})
			this.getListData()
		},
		// 滚动到底部
		onReachBottom() {
			if (this.count == this.listData.length) {
				uni.showToast({
					title: '没有更多啦',
					icon: 'none',
					duration: 1000
				});
			} else {
				this.pageData.page += 1
				this.getListData()
			}
		},
		methods: {
			open(){
				this.rightDrawer = true
			},
			returns(){
				uni.navigateBack()
			},
			closeDrawer(e) {
				this.rightDrawer = false
				if(!e){
					this.rightDrawer = false
				}
			},
			menusTap() {
				uni.navigateTo({
					url: '/pages/merchant/settled/index'
				})
			},
			getListData() {
				this.loading = true
				uni.showLoading({
					title: this.$t(`message.tips.loding`)
				});
				getMerSettledRecordApi(this.pageData).then(res => {
					this.count = res.data.total
					this.listData = this.listData.concat(res.data.list)
					uni.hideLoading();
					this.loading = false
				})
			},
			// 跳转逻辑
			jump(item) {
				if ([0, 2].includes(item.status)) {
					uni.navigateTo({
						url: `/pages/store/settled/index?mer_i_id=${item.mer_intention_id}`
					})
				} else if (item.status === 1) {
					uni.navigateTo({
						url: `/pages/store/merchantDetails/index?mer_i_id=${item.mer_intention_id}&mer_id=${item.mer_id}`
					})
				}
			},
			//状态判断
			statusText(number) {
				// 使用对象
				let statusData = {
					1: this.$t(`message.tips.stay`),
					2: this.$t(`message.tips.adopt`),
					3: this.$t(`message.tips.noadopt`)
				};
				return statusData[number]
			},
			// button显示文字
			statusBtn(number) {
				// 使用对象
				let statusData = {
					0: this.$t(`message.tips.edit`),
					1: this.$t(`message.tips.see`),
					2: this.$t(`message.tips.again`),
				};
				return statusData[number]
			},
		}
	}
</script>

<style lang="scss" scoped>
	.main {}

	.application-record {
		display: flex;
		flex-direction: column;
		align-items: center;
		background-color: #F5F5F5;
		padding: 20rpx 30rpx;

		.card-list {
			width: 100%;
			background-color: #fff;
			padding: 20rpx 24rpx;
			margin: 10rpx 20rpx;
			border-radius: 12rpx;

			.card-top {

				.title {
					font-size: 28rpx;
					font-weight: bold;
					color: #333333;
				}

				.time {
					color: #999999;
					font-size: 24rpx;
					padding: 5rpx 0;
				}

				.reason {
					color: #E93323;
					font-weight: bold;
					font-size: 24rpx;
				}
			}

			.line {
				height: 2rpx;
				margin: 20rpx 0 20rpx 0;
				background-color: #EEEEEE;
			}

			.card-bottom {
				display: flex;
				justify-content: space-between;
				align-items: center;
				color: #333;

				.card-status {
					display: flex;
					align-items: center;

					.status-icon {
						width: 30rpx;
						height: 30rpx;
						margin: 10rpx;
					}

					.status-text {
						font-size: 28rpx;
						font-weight: 500;
					}
				}

				.status-btn {
					font-size: 26rpx;
					color: #555;
					border: 1px solid #999999;
					padding: 8rpx 32rpx;
					border-radius: 40rpx;
				}
			}
		}

	}

	.no-shop {
		width: 100%;
		background-color: #fff;
		height: 100vh;
        text-align: center;
		.pictrue {
			display: flex;
			flex-direction: column;
			align-items: center;
			//@include main_color(theme);

			image {
				width: 414rpx;
				height: 256rpx;
			}
		}
	}
</style>
