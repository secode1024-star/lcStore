<template>
	<view>
		<view class="ChangePassword">
			<view>
				<uniNavBar background-color="#fff" left-icon="back" color="#000" :border='false' @clickLeft='returns'></uniNavBar>
			</view>
			<view v-if="current == 0">
				<view class="shading">{{$t(`page.users.login.forget`)}}</view>
				<view class="shading_desc">{{$t(`page.users.login.resetDesc`)}}</view>
				<view class="list">
					<div class="item">
						<div class="acea-row row-middle">
							<text class="iconfont icon-youxiang"></text>
							<input type="text" class="texts" :placeholder="$t(`page.users.login.placeEmail`)" v-model="email"  />
						</div>
					</div>
				</view>
				<button form-type="submit" class="confirmBnt bg_color"  @click="next">{{$t(`page.users.login.next`)}}</button>
			</view>
			<view v-if="current == 1">
				<view class="shading mb-50" v-if="type == 'resetPhone'">{{$t(`page.users.login.phoneVer`)}}</view> 
				<view class="shading" v-if="type == 'forgetemail' || type == 'resetEmail'">{{$t(`page.users.login.emailVer`)}}</view>
				<view class="shading_desc" v-if="type == 'forgetemail'">{{$t(`page.users.login.verDesc`)}} <text class="font_color">{{email}}</text> </view>
				
				<view class="list">
					<div class="item pos">
						<div class="acea-row row-middle">
							<text class="iconfont icon-yanzhengma"></text>
							<input type="number" class="texts" :placeholder="$t(`page.users.register.placeCode`)" v-model="captcha" required/>
							<view class="Resend pos-rc" :disabled="disabled" @click="code()">{{ text }}</view>
						</div>
					</div>
					<div class="item">
						<div class="acea-row row-middle">
							<text class="iconfont icon-mima"></text>
							<input type="password" maxlength="20" class="texts" :placeholder="$t(`page.users.login.placePasd`)" v-model="password" />
						</div>
					</div>
					<div class="item">
						<div class="acea-row row-middle">
							<text class="iconfont icon-mima"></text>
							<input type="password" maxlength="20" class="texts" :placeholder="$t(`page.users.login.Pasdagain`)" v-model="password1" />
						</div>
					</div>
				</view>
				<button form-type="submit" class="confirmBnt bg_color"  @click="editPwd">{{$t(`page.users.login.submit`)}}</button>
			</view>
		</view>
		<tui-modal :show="modal" @click="handleClick" @cancel="hide" :title="$t(`message.login.prompt`)" :content="$t(`message.login.loginSure`)"></tui-modal>
	</view>
</template>

<script>
	import sendVerifyCode from "@/mixins/SendVerifyCode";
	import {mapGetters} from "vuex";
	import tuiModal from "@/components/tui-modal/tui-modal"
	import {
		emailForgetCode,
		emailCaptcheReset,
		phoneCaptcheReset,
		emailResetPassword,
		phoneUpdatePassword,
		getLogout,
		mobilePassword,
		getUserInfo,
		loginEmail,
		emailUpdatePassword} from '@/api/user'
		import {Debounce} from '@/utils/validate.js'
	const app = getApp();
	export default {
		mixins: [sendVerifyCode],
		data() {
			return {
				current:0,
				captcha:'',
				email:'',
				phone:'',
				password:'',
				password1:'',
				type:'',
				modal: false,
				countryCode: uni.getStorageSync('countryCode')
			};
		},
		components:{
			tuiModal
		},
		computed: mapGetters(['isLogin','userInfo']),
		onLoad(e) {
			uni.setNavigationBarTitle({
				title: this.$t(`page.users.userInfo.password`)
			})
			let that = this;
			if(e.scene == 'reset' && e.type == 'email'){
				this.type = 'resetEmail';
				this.email = this.userInfo.email;
				this.current = 1;
			}else if(e.scene == 'reset' && e.type == 'phone'){
				this.type = 'resetPhone';
				this.phone = this.userInfo.phone;
				this.current = 1;
			}else if(e.scene == 'forget' && e.type == 'email'){
				this.type = 'forgetemail';
			}
		},
		methods: {
			returns() {
				uni.navigateBack()
			},
			next(){
				let that = this;
				if (!that.email) return that.$util.Tips({
					title: this.$t(`message.login.emailEmpty`)
				});
				if (!/^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/i.test(that.email)) return that.$util.Tips({
					title: this.$t(`message.login.correctEmail`)
				});
				that.current = 1;
			},
			handleClick(e) {
				let index = e.index,that = this;
				if (index === 1) {
					if(that.type == 'resetPhone'){
						mobilePassword({
							"countryCode": '+' + that.countryCode,
							"password": that.password,
							"phone": that.phone
						}).then(res=>{
							let data = res.data;
							let newTime = Math.round(new Date() / 1000);
							that.$store.commit("LOGIN", {
								'token': res.data.token
							});
							that.getUserInfo(data);
						}).catch(err => {
							return that.$util.Tips({
								title: err
							});
						});
					}else if(that.type == 'resetEmail'){
						loginEmail({
							email: that.email,
							password: that.password,
						}).then(({data}) => {
							this.$store.commit("LOGIN", {
								'token': data.token
							});
							that.getUserInfo(data);
						}).catch(e => {
							that.$util.Tips({
								title: e
							});
						});
					}
					
				}else{
					uni.reLaunch({
						url: '/pages/index/index'
					});
				} 
				this.hide();
			},
			hide() {
				this.modal = false;
				uni.navigateTo({
					url: '/pages/users/login/index?isToLogin=isToLogin'
				})
			},
			getUserInfo(data) {
				let that = this;
				this.$store.commit("SETUID", data.uid);
				getUserInfo().then(res => {
					uni.hideLoading();
					this.$store.commit("UPDATE_USERINFO", res.data);
					return that.$util.Tips({
						title: '登录成功',
						icon:'success'
					}, {
						tab: 4,
						url: '/pages/index/index'
					});
				})
			},
			editPwd: Debounce(function() {
				let that = this;
				if (!that.captcha) return that.$util.Tips({
					title: this.$t(`message.login.emptyCaptche`)
				});
				if(!that.password) return that.$util.Tips({
					title:this.$t(`message.login.emptyPassword`)
				})
				if(!that.password1) return that.$util.Tips({
					title:this.$t(`message.login.againPassword`)
				})
				if(that.password !== that.password1) return that.$util.Tips({ 
					title:this.$t(`message.login.diffPassword`)
				})
				// forgetemail忘记邮箱密码
				if(that.type == 'forgetemail'){ 
					emailResetPassword({
						"captcha": that.captcha,
						"email": that.email,
						"newPassword": that.password,
						"passwordAgain": that.password1
					}).then(res=>{
						return that.$util.Tips({
							title: this.$t(`message.login.resetSuccess`),
							icon:'success'
						}, {
							tab: 4,
							url: '/pages/users/login/index'
						});
					}).catch(err => {
						return that.$util.Tips({
							title: err
						});
					});
				}else if(that.userInfo.userType == 'email'){
					uni.showLoading({
						title: this.$t(`message.tips.loding`)
					});
					emailUpdatePassword({
						"captcha": that.captcha,
						"newPassword": that.password,
						"passwordAgain": that.password1
					}).then(res=>{
						uni.hideLoading();
						that.$util.Tips({
							title: res.message,
							icon:'success'
						});
						that.getLogout();
					}).catch(err => {
						return that.$util.Tips({
							title: err
						});
					});
				}else if(that.userInfo.userType == 'phone'){
					uni.showLoading({
						title: this.$t(`message.tips.loding`)
					});
					phoneUpdatePassword({
						"captcha": that.captcha,
						"newPassword": that.password,
						"passwordAgain": that.password1
					}).then(res=>{
						uni.hideLoading();
						that.$util.Tips({
							title: res.message,
							icon:'success'
						});
						that.getLogout();
					}).catch(err => {
						uni.hideLoading();
						return that.$util.Tips({
							title: err
						});
					})
				}
			}),
			getLogout(){
				getLogout().then(res => {
					this.modal = true;
					this.$store.commit("LOGOUT");
				}).catch(err => {
					console.log(err);
				});
			},
			code:Debounce(function() {
				let that = this;
				if(that.type == 'resetEmail'){
					if (that.disabled) return;
					 emailCaptcheReset({email:that.email}).then(res => {
						that.$util.Tips({title:res.message});
						that.sendCode();
					}).catch(err => {
						return that.$util.Tips({
							title: err
						});
					});
				}else if(that.type == 'resetPhone'){
					if (that.disabled) return;
					 phoneCaptcheReset({phone:that.phone}).then(res => {
						that.$util.Tips({title:res.message});
						that.sendCode();
					}).catch(err => {
						return that.$util.Tips({
							title: err
						});
					});
				}else if(that.type == 'forgetemail'){
					if (that.disabled) return;
					 emailForgetCode(that.email).then(res => {
						that.$util.Tips({title:res.message});
						that.sendCode();
					}).catch(err => {
						return that.$util.Tips({
							title: err
						});
					});
				}
			}),
		}
	}
</script>

<style lang="scss" scoped>
	page {
		background-color: #fff !important;
		padding: 30rpx;
		box-sizing: border-box;
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
		margin: 30rpx auto 0;
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
		margin-top: 50rpx;
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
	
				.Resend {
					height: 48rpx;
					padding: 0 24rpx 0;
					line-height: 40rpx;
					text-align: center;
					font-size: 24rpx;
					font-family: PingFangSC-Regular, PingFang SC;
					font-weight: 400;
					border-radius: 24rpx;
					@include main_color(theme);
					@include coupons_border_color(theme)
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
	.mb-50{
		margin-bottom: 50rpx;
	}
	.bg_color{
		@include main_bg_color(theme);
	}
	.font_color{
		@include main_color(theme);
	}
</style>
