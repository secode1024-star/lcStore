<template>
	<view id="store" class="store">
		<!-- <easy-loadimage mode="widthFix" :image-src="avatar" class="tui-skeleton-rect"></easy-loadimage> -->
		<image :src="merchantInfo.avatar" class="tui-skeleton-rect"></image>
		<view class="text tui-skeleton-rect">
			<navigator :url="`/pages/merchant/${type}/index?id=${merid}`" hover-class="none">
				<view class="flex merchantInfo">
					<text v-if="merchantInfo.isSelf" class="font-bg-red bt-color mr10 self_min">{{$t(`page.store.selfSupport`)}}</text>
					<text class="name">{{merchantInfo.name}}</text>
					<text class="iconfont icon-gengduo"></text>
				</view>
				<text class="font-bg-red bt-color mr10">{{merchantInfo.typeId | merchantTypeFilter}}</text>
			</navigator>
			<view class="score">
				<view class='starsList'>
					<block v-for="(itemn, indexn) in merchantInfo.starLevel" :key="indexn">
						<text class='iconfont icon-pingfen font-color'></text>
					</block>
					<block v-show="Number(merchantInfo.starLevel)<5">
						<text v-for="(itemn, indexn) in noStarLevel" :key="indexn" class='iconfont icon-pingfen noCheck'></text>
					</block>
				</view>
			</view>
		</view>
		<button hover-class="none" :class="merchantInfo.isCollect ? 'care' : ''" @click="followToggle">
			<text v-show="!merchantInfo.isCollect" class="iconfont icon-guanzhu"></text>
			{{ merchantInfo.isCollect ? $t(`page.store.followed`) : $t(`page.store.follow`) }}
		</button>
	</view>
</template>

<script>
	import { getMerCollectAddApi, getMerCollectCancelApi} from '@/api/merchant.js';
	import {mapGetters} from "vuex"; 
	import {toLogin} from '@/libs/login.js';
	export default {
		data() {
			return {
				skeletonShow: true,
				isShow: true,
				avatar: '',
				noStarLevel: 0 // 没达到的星级
			}
		},
		computed: {
		  ...mapGetters(["merchantClassify", "merchantType", 'isLogin', 'uid']),
		},
		watch: {
			merchantInfo: function(nVal, oVal) {
				if(parseInt(nVal.starLevel)<5) this.noStarLevel = 5-parseInt(nVal.starLevel);
			}
		},
		props: {
			merchantInfo:{
				type: Object,
				default: ()=> {}
			},
			merid:{
				type: Number,
				default: ()=> 0
			},
			type: {
				type: String,
				default: ()=> 'detail'
			}
		},
		created() {
			//this.avatar = merchantInfo.avatar;
		},
		methods: {
			// 设置是否关注
			followToggle: function() {
				if (this.isLogin === false) {
					toLogin();
				} else {
					if (this.merchantInfo.isCollect) {
						getMerCollectCancelApi(this.merid).then(res => {
							this.$set(this.merchantInfo, 'isCollect', !this.merchantInfo.isCollect);
						}).catch(err => {
							this.$util.Tips({
								title: err
							});
						});
					} else {
						getMerCollectAddApi(this.merid).then(res => {
							this.$set(this.merchantInfo, 'isCollect', !this.merchantInfo.isCollect);
						}).catch(err => {
							this.$util.Tips({
								title: err
							});
						});
					}
				}
			}
		}
	};
</script>

<style lang="scss" scoped>
	.font-color{
		@include main_color(theme);
	}
	.icon-pingweifen{
		color: #ccc;
	}
	.merchantInfo{
		align-items: center;
		margin-bottom: 6rpx;
	}
	.font-bg-red{
		padding: 4rpx;
		@include main_bg_color(theme);
		color: #fff;
		font-size: 18rpx;
		display: inline-block;
		border-radius: 4rpx;
		margin-bottom: 6rpx;
	}
	.store {
		position: relative;
		z-index: 5;
		display: flex;
		align-items: center;
		padding: 20rpx 30rpx 22rpx 30rpx;
		
	    // top:12rpx;
		image,.easy-loadimage,image,uni-image {
			width: 120rpx;
			height: 120rpx;
			border-radius: 50%;
			overflow: hidden;
		}
	
		.text {
			flex: 1;
			min-width: 0;
			margin-right: 20rpx;
			margin-left: 20rpx;
	
			navigator {
				// display: inline-flex;
				align-items: center;
				max-width: 100%;
	
				.name {
					min-width: 0;
					overflow: hidden;
					white-space: nowrap;
					text-overflow: ellipsis;
					font-weight: bold;
					font-size: 30rpx;
					line-height: 1;
					color: #FFFFFF;
				}
	
				.iconfont {
					margin-left: 10rpx;
					font-size: 17rpx;
					color: #FFFFFF;
				}
			}
	
			.score {
				display: flex;
				align-items: center;
				margin-top: 8rpx;
				font-weight: 500;
				font-size: 24rpx;
				line-height: 1;
	
				.star {
					position: relative;
					width: 111rpx;
					height: 19rpx;
					margin-right: 10rpx;
					background: url(@/pages/merchant/images/star.png) left top/100% 100% no-repeat;
					overflow: hidden;
	
					view {
						position: absolute;
						top: 0;
						left: 0;
						width: 100%;
						height: 100%;
						background: url(@/pages/merchant/images/star_active.png) left top/111rpx 19rpx no-repeat;
					}
				}
			}
		}
	
		button {
			display: flex;
			justify-content: center;
			align-items: center;
			padding: 0 18rpx;
			height: 48rpx;
			border-radius: 24rpx;
			@include linear-gradient(theme);
			font-weight: 500;
			font-size: 22rpx;
			color: #FFFFFF;
	
			.iconfont {
				margin-right: 6rpx;
				font-size: 22rpx;
			}
	
			&.gary {
				background-color: #999;
			}
		}
	}
</style>
