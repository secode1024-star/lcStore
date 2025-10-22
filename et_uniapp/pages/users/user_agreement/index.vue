<template>
	<view class="user_about">
		<view>
			<view class="text cancelTxt" v-html="loginInfo.agreement"></view>
		</view>
	</view>
</template>

<script>
	import {
		loginMethodInfo
	} from '@/api/user.js'
	import { mapGetters } from "vuex";
	export default {
		name: 'user_about',
		data() {
			return {
				check: false,
				moal: false,
				loaded: false,
				loginInfo: {}
			}
		},
		onLoad(options) {
			uni.setNavigationBarTitle({
				title: this.$t(`message.login.agreementName`)
			})
			this.getCacheinfo();
		},
		methods: {
			getCacheinfo() {
				this.loaded = false;
				loginMethodInfo().then(res => {
					this.loginInfo = res.data;
					this.loaded = true;
				})
			}
		}
	}
</script>

<style scoped lang="scss">
	.user_about {
		.text {
			font-size: 30rpx;
			font-weight: 400;
			padding: 30rpx;
			color: #282828;
			image{
				max-width: 100%;
			}
		}
		.cancelTxt {
			overflow-y: auto;
			image{
				max-width: 100%;
			}
		}
		.cancel {
			position: fixed;
			bottom: 60rpx;
			left: 0;
			z-index: 1;
			width: 100%;
			.checkbox {
				width: 50%;
				text-align: center;
				margin: 0 auto;
				font-size: 24rpx;
				font-weight: 400;
				span {
					margin-left: 5rpx;
				}
				.iconfont {
					font-size: 24rpx;
				}
			}
		}
	}
	.outMoal {
		width: 100%;
		height: 100%;
		background: rgba(0, 0, 0, 0.5);
		position: fixed;
		top: 0;
		left: 0;
		z-index: 2;
		display: flex;
		align-items: center;
		justify-content: center;
		.box {
			position: fixed;
			width: 590rpx;
			height: 258rpx;
			background: #FFFFFF;
			opacity: 1;
			border-radius: 20rpx;
			text-align: center;
			padding: 50rpx;
			.title {
				font-size: 30rpx;
				font-weight: 600;
				color: #282828;
			}
			.moalBtn {
				margin-top: 43rpx;
				display: flex;
				justify-content: space-between;
				.ok {
					width: 234rpx;
					height: 66rpx;
					border: 1rpx solid #E93323;
					border-radius: 33rpx;
					font-size: 26rpx;
					line-height: 66rpx;
					color: #E93323;
				}
				.no {
					width: 234rpx;
					height: 66rpx;
					background: linear-gradient(90deg, #FF7931 0%, #F11B09 100%);
					border-radius: 33rpx;
					font-size: 26rpx;
					color: #FFFFFF;
					line-height: 66rpx;
				}
			}
		}
	}
</style>
