<template>
	<view :style="{ 'background-image': `linear-gradient(0deg, rgba(0, 0, 0, 0) 0%, rgba(0, 0, 0, 1) 40%),url(${store.mer_banner})` }" class="store-detail">
		<tui-skeleton v-if="skeletonShow"></tui-skeleton>
		<uni-nav-bar background-color="transparent" color="#fff" :title="$t(`page.store.merInfo`)" :border='false' @clickLeft='returns' @clickRight="open">
			<view slot="left" class="iconfont icon-dingbufanhui"></view>
			<view slot="right" class="iconfont icon-more"></view>
		</uni-nav-bar>
	    <view class="sectionBox">
			<view class="section head">
				<image :src="merchantAPPInfo.avatar"></image>
				<view class="text-wrap">
					<view class="name line1">
						<text class="name_store">{{ merchantAPPInfo.name }}</text>
						<text v-if="store.typeId" class="font-bg-red ml8">{{ store.typeId | merchantTypeFilter }}</text>
						<text v-else-if="store.isSelf" class="font-bg-red ml8">{{$t(`page.store.selfSupport`)}}</text>
					</view>
					<view class="fans">{{ store.collectNum < 10000 ? store.collectNum + $t(`page.store.people`) : (store.collectNum / 10000).toFixed(2) + '万' + $t(`page.store.people`) }}</view>
				</view>
			</view>
			<view class="section wrap">
				<view class="name">{{$t(`page.store.storeRating`)}}</view>
				<view class="score-wrap">
					<view class="star">
						<view :style="'width:'+(merchantAPPInfo.starLevel/5)*100+'%'"></view>
				    </view>
				</view>
			</view>
			
			<view class="section wrap" @click="popupShow = true">
				<view class="name">{{$t(`page.store.storeQualification`)}}</view>
				<view><text class="iconfont icon-zizhi"></text></view>
			</view>	
			
			<view class="section wrap" @click="call">
				<view class="name">{{$t(`page.store.storeService`)}}</view>
				<view><text class="iconfont icon-kefu_o"></text></view>					
			</view>
			<view class="section info">
				<view class="item very">
					<view class="name">{{$t(`page.store.storeIntroduction`)}}</view>
					<view class="value">{{ store.intro }}</view>
				</view>
				<view class="item very">
					<view class="name">{{$t(`page.store.storeAddress`)}}</view>
					<view class="value">{{ store.address }}</view>
				</view>
				<view class="item">
					<view class="name">{{$t(`page.store.storeTime`)}}</view>
					<view class="value">{{ store.createTime | dateFormat }}</view>
				</view>
			</view>
			<view :class="{ mask: popupShow }" @click="popupShow = false"></view>
			<view :class="{ 'popup-active': popupShow }" class="popup-qrcode">
				<view class="name">资质图片</view>
				<template v-for="(item,index) in qualificationPicture">
					<image :src="item" @click='getpreviewImage(index)'></image>
				</template>
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
import { mapGetters } from 'vuex';
import { getMerDetailApi } from '@/api/merchant.js';
import {chatConfig} from '@/utils/consumerType.js'
let app = getApp();
export default {
	computed: mapGetters(['isLogin', 'uid', 'merchantAPPInfo', 'merchantType']),
	data() {
		return {
			skeletonShow: true,
			id: 0,
			store: {},
			score: 0,
			star: 0,
			popupShow: false,
			storeCode: '',
			openSettingBtnHidden: true, //是否授权
			qualificationPicture: [],
			rightDrawer: false
		};
	},
	onLoad: function(options) {
		uni.setNavigationBarTitle({
			title: this.$t(`page.store.merInfo`)
		})
		this.id = options.id;
		this.getStore();
	},
	onReady: function() {
			
	},
	mounted: function() {
		
	},
	methods: {
		closeDrawer(){
			this.rightDrawer = false
		},
		open(){
			this.rightDrawer = true
		},
		returns() {
			uni.navigateBack()
		},

		call: function(){
			chatConfig('mer');
		},
		getpreviewImage: function(indexw) {
			uni.previewImage({
				urls: this.qualificationPicture,
				current: this.qualificationPicture[indexw]
			});
		},
		getStore: function() {
			getMerDetailApi(this.id).then(res => {
				let store = res.data;
				this.store = store;
				this.qualificationPicture = JSON.parse(store.qualificationPicture)
			
				this.score = (parseFloat(store.postage_score) + parseFloat(store.product_score) + parseFloat(store.service_score)) / 3;
				this.star = (this.score / 5) * 100;
				this.skeletonShow = false
			});
		},
		follow: function() {
			followStore(this.id).then(res => {
				if (res.status === 200) {
					this.store.care = true;
				}
				this.$util.Tips({
					title: res.message
				});
			});
		},
		unfollow: function() {
			unfollowStore(this.id).then(res => {
				if (res.status === 200) {
					this.store.care = false;
				}
				this.$util.Tips({
					title: res.message
				});
			});
		},
		followToggle: function() {
			this.store.care ? this.unfollow() : this.follow();
		}
	}
};
</script>

<style lang="scss">
.font-bg-red {
	display: inline-block;
	background: #e93424;
	color: #fff;
	font-size: 20rpx;
	text-align: center;
	line-height: 30rpx;
	border-radius: 5rpx;
	margin-right: 8rpx;
	position: relative;
	top: -2rpx;

	&.ml8 {
		margin-left: 8rpx;
		margin-right: 0;
	}
}

.store-detail {
	
	background: left top/750rpx 360rpx no-repeat fixed;
    .sectionBox{
		padding: 0 30rpx;
	}
	.section {
		border-radius: 20rpx;
		margin-bottom: 20rpx;
		background-color: #ffffff;
	}

	.head {
		display: flex;
		align-items: center;
		padding: 20rpx;

		image {
			width: 90rpx;
			height: 90rpx;
			border-radius: 6rpx;
		}

		.text-wrap {
			flex: 1;
			min-width: 0;
			margin-right: 20rpx;
			margin-left: 20rpx;
			line-height: 1;

			.name {
				
				font-weight: bold;
				font-size: 28rpx;
				color: #282828;
				.name_store {
					display: inline-block;
					overflow: hidden;
					white-space: nowrap;
					text-overflow: ellipsis;
					max-width: 140px;
				}
			}

			.fans {
				margin-top: 15rpx;
				font-weight: 500;
				font-size: 22rpx;
				color: #666666;
			}
		}

		button {
			display: flex;
			justify-content: center;
			align-items: center;
			padding: 0 18rpx;
			height: 48rpx;
			border-radius: 24rpx;
			background-image: linear-gradient(-90deg, rgba(246, 122, 56, 1) 0%, rgba(241, 27, 9, 1) 100%);
			font-weight: 500;
			font-size: 22rpx;
			color: #ffffff;

			.iconfont {
				margin-right: 6rpx;
				font-size: 22rpx;
			}
		}

		.followed {
			border: 1rpx solid #bfbfbf;
			background: none;
			color: #999999;
		}
	}

	.wrap {
		display: flex;
		align-items: center;
		padding: 32rpx 20rpx;

		.name {
			flex: 1;
			min-width: 0;
			font-weight: 400;
			font-size: 28rpx;
			color: #282828;
		}

		.score-wrap {
			display: flex;
			align-items: center;
			font-weight: 500;
			font-size: 28rpx;
			color: $theme-color;

			.star {
				position: relative;
				width: 111rpx;
				height: 19rpx;
				margin-right: 10rpx;
				background: url(../images/star.png) left top/100% 100% no-repeat;
				overflow: hidden;

				view {
					position: absolute;
					top: 0;
					left: 0;
					height: 100%;
					background: url(../images/star_active.png) left top/111rpx 19rpx no-repeat;
				}
			}
		}

		.iconfont {
			font-size: 36rpx;
		}

		.icon-pingfen {
			margin-right: 6rpx;
			font-size: 23rpx;
			color: #666666;
		}

		.active {
			color: $theme-color;
		}
	}

	.info {
		.item {
			display: flex;
			align-items: center;
			padding: 30rpx 20rpx;
			border: 1rpx solid #f5f5f5;
			font-weight: normal;
			font-size: 28rpx;
			line-height: 30rpx;
			color: #282828;
            justify-content: flex-start;
			.name {
				margin-right: 18rpx;
				width: 176rpx;
			}

			.value {
				font-size: 30rpx;
				font-family: PingFangSC-Regular, PingFang SC;
				font-weight: 400;
				color: #999999;
				line-height: 40rpx;
				width: 450rpx;
				word-break: break-all;
			}
		}

		.very {
			.name {
				align-self: flex-start;
			}
		}
	}

	.popup-qrcode {
		position: fixed;
		top: 50%;
		left: 50%;
		z-index: 99;
		width: 544rpx;
		padding-top: 48rpx;
		padding-bottom: 36rpx;
		border-radius: 24rpx;
		background-color: #ffffff;
		transform: translate(-50%, -50%) scale(0);
		opacity: 0;
		transition: 0.3s;
		line-height: 1;
		text-align: center;
		color: #282828;

		.name {
			max-width: 90%;
			margin-right: auto;
			margin-left: auto;
			font-weight: bold;
			font-size: 32rpx;
		}

		.info {
			margin-top: 24rpx;
			font-weight: 500;
			font-size: 24rpx;
		}

		image {
			width: 110rpx;
			height: 110rpx;
			margin-top: 18rpx;
		}
	}

	.popup-active {
		transform: translate(-50%, -50%) scale(1);
		opacity: 1;
	}
}
</style>
