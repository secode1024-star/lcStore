<template>
	<view>
		<view class="ChangePassword">
			<view class="navBar">
				<uniNavBar background-color="#fff" left-icon="back" color="#000" :border='false' @clickLeft='returns'></uniNavBar>
			</view>
			<view class="shading">Email verification</view>
			<view class="shading_desc">For the safety of your account, please verify your email: </view>
			<view class="list">
				<div class="item pos">
					<div class="acea-row row-middle">
						<text class="iconfont icon-yanzhengma"></text>
						<input type="number" class="texts" :placeholder="$t(`page.users.register.placeCode`)" v-model="captcha" required/>
						<view class="Resend pos-rc" :disabled="disabled" @click="codeEmail">{{ text }}</view>
					</div>
				</div>
				<div class="item">
					<div class="acea-row row-middle">
						<text class="iconfont icon-mima"></text>
						<input type="password" class="texts" :placeholder="$t(`page.users.login.placePasd`)" v-model="password" />
					</div>
				</div>
				<div class="item">
					<div class="acea-row row-middle">
						<text class="iconfont icon-mima"></text>
						<input type="password" class="texts" :placeholder="$t(`page.users.login.Pasdagain`)" v-model="password1" />
					</div>
				</div>
			</view>
			<button form-type="submit" class="confirmBnt bg_color"  @click="editPwd">{{$t(`page.users.login.submit`)}}</button>
		</view>
	</view>
</template>

<script>
	import sendVerifyCode from "@/mixins/SendVerifyCode";
	import {
		registerVerify,
		bindingPhone,
		verifyCode,
		bindingVerify
	} from '@/api/api.js';
	import {toLogin} from '@/libs/login.js';
	import {mapGetters} from "vuex";
	import {setThemeColor} from '@/utils/setTheme.js'
	const app = getApp();
	export default {
		mixins: [sendVerifyCode],
		data() {
			return {
				phone:'',
				captcha:'',
				email:'',
				password:'',
				password1:'',
				isAuto: false, //没有授权的不会自动授权
				isShowAuth: false, //是否隐藏授权
				key: '',
				timer: '',
				nums: 60,
			};
		},
		computed: mapGetters(['isLogin','userInfo']),
		onLoad() {
			let that = this;
		},
		methods: {
			returns() {
				uni.navigateBack()
			},
			editPwd: function() {
				let that = this;
				if (!that.phone) return that.$util.Tips({
					title: '请填写手机号码！'
				});
				if (!(/^1(3|4|5|7|8|9|6)\d{9}$/i.test(that.phone))) return that.$util.Tips({
					title: '请输入正确的手机号码！'
				});
				if (!that.captcha) return that.$util.Tips({
					title: '请填写验证码'
				});
				uni.showModal({
					title: '是否更换绑定账号',
					confirmText: '绑定',
					success(res) {
						if (res.confirm) {
							bindingPhone({
								phone: that.phone,
								captcha: that.captcha
							}).then(res => {
								return that.$util.Tips({
									title: res.message,
									icon: 'success'
								}, {
									tab: 5,
									url: '/pages/users/user_info/index'
								});
							}).catch(err => {
								return that.$util.Tips({
									title: err
								});
							})
						} else if (res.cancel) {
							return that.$util.Tips({
								title: that.$t(`message.login.calSU`)
							}, {
								tab: 5,
								url: '/pages/users/user_info/index'
							});
						}
					}
				});
			},
			/**
			 * 发送验证码
			 * 
			 */
			async code() {
				this.nums = 60;
				uni.showLoading({
					title: '加载中',
					mask: true
				});
				let that = this;
				if(!that.isNew){
					if (!that.phone) return that.$util.Tips({
						title: '请填写手机号码！'
					});
					if (!(/^1(3|4|5|7|8|9|6)\d{9}$/i.test(that.phone))) return that.$util.Tips({
						title: '请输入正确的手机号码！'
					});
				}
				await registerVerify(that.isNew?that.userInfo.phone:that.phone).then(res => {
					that.$util.Tips({
						title: res.message
					});
					
					// that.timer = setInterval(that.getTimes, 1000);
					 that.disabled = true;
					 uni.hideLoading();
				}).catch(err => {
					return that.$util.Tips({
						title: err
					});
					uni.hideLoading();
				});
			}
		}
	}
</script>

<style lang="scss" scoped>
	page {
		background-color: #fff !important;
		padding: 30rpx;
		box-sizing: border-box;
	}
	.navBar{
		padding: 30rpx 0 0 30rpx;
	}
	.shading {
		display: flex;
		align-items: center;
		justify-content: center;
		width: 100%;
		margin-top: 140rpx;
		font-size: 50rpx;
		font-family: PingFangSC-Semibold, PingFang SC;
		font-weight: 600;
		color: #220000;
		line-height: 50rpx;
	}
	.shading_desc{
		width: 612rpx;
		height: 64rpx;
		margin: 30rpx auto 50rpx;
		text-align: center;
		font-size: 28rpx;
		font-family: PingFangSC-Regular, PingFang SC;
		font-weight: 400;
		color: #222222;
		line-height: 32rpx;
	}
	.ChangePassword .phone {
		font-size: 32rpx;
		font-weight: bold;
		text-align: center;
		margin-top: 55rpx;
	}
	.acea-row.row-middle {
		input {
			margin-left: 20rpx;
			display: block;
		}
	}
	.list {
		border-radius: 16rpx;
		overflow: hidden;
		margin-bottom: 80rpx;
		padding: 0 60rpx 0;
	
		.item {
			border-bottom: 1px solid #F0F0F0;
			background: #fff;
	
			.iconfont {
				font-size: 30rpx;
				color: #B4B4B4;
			}
	
			.row-middle {
				position: relative;
				padding: 16rpx 24rpx;
	
				.texts {
					flex: 1;
					font-size: 28rpx;
					height: 80rpx;
					line-height: 80rpx;
					display: flex;
					justify-content: center;
					align-items: center;
				}
	
				input {
					flex: 1;
					font-size: 28rpx;
					height: 80rpx;
					line-height: 80rpx;
					display: flex;
					justify-content: center;
					align-items: center;
				}
	
				.code {
					position: absolute;
					right: 30rpx;
					top: 50%;
					color: $theme-color;
					font-size: 26rpx;
					transform: translateY(-50%);
				}
			}
		}
	
		.forget {
			font-size: 24rpx;
			font-family: PingFangSC-Regular, PingFang SC;
			font-weight: 400;
			color: #666666;
			margin-top: 24rpx;
			text-align: right;
		}
	}

	.ChangePassword .confirmBnt {
		font-size: 32rpx;
		width: 580rpx;
		height: 90rpx;
		border-radius: 45rpx;
		color: #fff;
		margin: 92rpx auto 0 auto;
		text-align: center;
		line-height: 90rpx;
	}
	.bg_color{
		@include main_bg_color(theme);
	}
</style>
