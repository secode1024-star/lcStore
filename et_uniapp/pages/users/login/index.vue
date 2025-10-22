<template>
	<div class="login-wrapper pos">
		<uniNavBar background-color="#fff" left-icon="back" color="#000" :border='false' @clickLeft='returns'></uniNavBar>
		<div class="tabs">
			<text v-for="(item,index) in tabList" :key="index" :class="{ 'active': active == index}" @click="tab(index)">{{$t(`page.users.register.tabNav[${index}].name`)}}</text>
		</div>
		<div class="whiteBg">
			<div class="list" v-show="active == 0">
				<form @submit.prevent="submit">
					<div class="item">
						<div class="acea-row row-middle">
							<text class="iconfont icon-youxiang"></text>
							<input type="text" class="texts" :placeholder="$t(`page.users.login.placeEmail`)" v-model="email"  />
						</div>
					</div>
					<div class="item">
						<div class="acea-row row-middle">
							<text class="iconfont icon-mima"></text>
							<input type="password" class="texts" maxlength="20" :placeholder="$t(`page.users.login.placePasd`)" v-model="password" />
						</div>
					</div>
					<div class="forget" @click="goPage('/pages/users/user_pwd_edit/index?type=email&scene=forget')">{{$t(`page.users.login.forget`)}}</div>
				</form>
			</div>
			<div class="list" v-show="active == 1">
				<form @submit.prevent="submit">
					<div class="item">
						<div class="acea-row row-middle">
							<text class="iconfont icon-shouji"></text>
							<view class="acea-row row-middle pos_line" @click="selectCountry()">
								<image :src="countryFlag" class="flag"></image>
								<image src="../../../static/images/xiala.png" class="select_code"></image>
							</view>
							<text class="px-20">+{{countryCode}}</text>
							<input type="number" class="texts" v-model="phone" :placeholder="$t(`page.users.register.placePhone`)" style="margin:0" />
						</div>
					</div>
					<div class="item pos" v-if="current==0">
						<div class="acea-row row-middle">
							<text class="iconfont icon-yanzhengma"></text>
							<input type="number" class="texts" :placeholder="$t(`page.users.register.placeCode`)" v-model="captcha" />
							<view class="Resend pos-rc" :class="disabled === true ? 'on' : ''" :disabled="disabled" @click="codePhone">{{ text }}</view>
						</div>
					</div>
					<div class="item" v-if="current==1">
						<div class="acea-row row-middle">
							<text class="iconfont icon-mima"></text>
							<input type="password" class="texts" maxlength="20" :placeholder="$t(`page.users.login.placePasd`)" v-model="password" />
						</div>
					</div>
					<div class="forget" v-if="current==1" @click="current = 0">{{$t(`page.users.login.quick`)}}</div>
					<div class="forget" v-if="current==0" @click="current = 1">{{$t(`page.users.login.pasdLogin`)}}</div>
				</form>
			</div>
			<div class="protocol acea-row row-between-wrapper">
				<checkbox-group class="checkgroup acea-row" @change='isAgree=!isAgree'  style="align-items: end;">
					<checkbox class="checkbox" :checked="isAgree ? true : false" />
					<text class="protocol_text">{{$t(`message.login.agree`)}}<text @click="userAgree" class="font_pro">《{{$t(`message.login.agreementName`)}}》</text></text>
		        </checkbox-group>
			</div>
			<div class="logon bg_color text-white" @click="submit">{{$t(`page.users.login.sign`)}}</div>
			<div class="logon border text-333 mt-40" @click="goPage('/pages/users/register/index')">{{$t(`page.users.login.create`)}}</div>
			<div class="text-center anonymous" @click="goPage('/pages/users/tourists/index')" v-if="loginInfo.visitorOpen && !isToLogin">{{$t(`page.users.login.tourists`)}}</div>
		</div>
		<div class="bottom">
			<text class="sign_type">{{$t(`page.users.login.with`)}}</text>
			<view class="sign_type_list">
				<image src="/static/images/twitter.png" @click="twitterGetToken()" v-if="loginInfo.twitterOpen"></image>
				<!-- Facebook登录已移除 -->
				<!-- <image src="/static/images/facebook.png" @click="fbLogin()" v-if="loginInfo.facebookOpen"></image> -->
				<image src="/static/images/goggle.png" v-google-signin-button="loginInfo.googleClientId" v-if="loginInfo.googleOpen"></image>
			</view>
		</div>
		<tui-drawer mode="bottom" :visible="showList" @close="closeDrawer">
			<SortPickerList ref="sortPickerList" @clickData="clickData" @close="closeList"></SortPickerList>
		</tui-drawer>
	</div>
</template>
<script>
	import sendVerifyCode from "@/mixins/SendVerifyCode";
	import {
		loginEmail,
		// Facebook登录已移除
		loginTwitter,
		loginGoogle,
		twitterToken,
		register,
		getUserInfo,
		registerVerify,
		mobileCaptcha,
		mobilePassword,
		loginMethodInfo
	} from "@/api/user";
	// Facebook插件已移除
	// import facebookWebLogin from '@/plugin/facebookWebLogin.js';
	import GoogleSignInButton from '@/plugin/googleSign.js'
	import attrs, {required} from "@/utils/validate";
	import {Debounce} from '@/utils/validate.js'
	import SortPickerList from "@/components/sortPickerList/index.vue";
	const BACK_URL = "login_back_url";
	let app = getApp();
	export default {
		name: "Login",
		mixins: [sendVerifyCode],
		data: function() {
			return {
				isAgree: false,
				tabList:['Email','handphone'],
				current: 1,
				email: "",
				password: "",
				phone:'',
				captcha: "",
				type: "login",
				active:0,
				showList:false,
				countryCode:'86',
				countryFlag:'../../../static/flag/cn.png',
				theme: app.globalData.theme,
				// clientId: '527732578974-i1v5q5h1tg3qj4hp3t96s1p4kjpvi9mf.apps.googleusercontent.com',
				loginInfo:{},
				isToLogin: undefined,
			};
		},
		directives: {
			GoogleSignInButton
		},
		components: {
			SortPickerList
		},
		onReady() {
			var that = this
			that.$refs["sortPickerList"].initPage()
		},
		onLoad(e) {
			uni.setStorageSync('countryCode', this.countryCode);
			this.isToLogin = e.isToLogin || undefined;
			let locale = (navigator.language || navigator.browserLanguage).toLowerCase();
			//uni.setStorageSync('locale', locale);
			this.getLoginInfo();
			//Twitter跳到回调地址以后执行的继续登录
			if(e.oauth_verifier){
				this.twitterLogin(e.oauth_verifier);
			}
		},
		methods: {
			userAgree(){
				uni.navigateTo({
					url: '/pages/users/user_agreement/index'
				})
			},
			tab(index){
				this.active = index;
				this.password = '';
			},
			returns() {
				uni.navigateBack()
			},
			//获取第三方登录的信息和是否开启
			getLoginInfo(){
				loginMethodInfo().then(res=>{
					this.loginInfo = res.data;
					if(res.data.facebookOpen && !!res.data.facebookAppId){
						facebookWebLogin.init(res.data.facebookAppId, status => {
							if (status) {
								console.log('Facebook授权登录环境配置成功');
							}
						});
					}
				}).catch(e => {
					this.$util.Tips({
						title: e
					});
				});
			},
			twitterGetToken(){
				twitterToken().then(res=>{
					this.$Cache.setItem({
						name: 'twitterToken',
						value: res.data
					});
					window.location.href = res.data.authorizationURL;
				}).catch(e => {
					this.$util.Tips({
						title: e
					});
				});
			},
			twitterLogin(auth) {
				uni.showLoading({
					title: this.$t(`message.login.loginLoading`)
				});
				let tToken = this.$Cache.getItem('twitterToken');
				let data = {
					oauthToken:tToken.token,
					oauthTokenSecret:tToken.tokenSecret,
					oauthVerifier:auth
				};
				loginTwitter(data).then(res=>{
					this.$store.commit("LOGIN", {
						'token': res.data.token
					});
					this.getUserInfo(res.data);
				}).catch(e => {
					uni.hideLoading();
					this.$util.Tips({
						title: e
					});
				});
			},
			fbLogin() {
				let that = this;
				facebookWebLogin.login(
					response => {
						facebookWebLogin.getLoginStatus(response => {
							if (response['status'] == 'connected') {
								uni.showLoading({
									title: this.$t(`message.login.getting`)
								});
								facebookWebLogin.api('permissions', res => {
									let fields = 'id,name,picture,';
									fields += res.permissions.data
										.filter(item => {
											return item['status'] == 'granted' && item[
												'permission'] != 'public_profile';
										})
										.map(item => {
											return item['permission'];
										})
										.join(',');
									facebookWebLogin.api(fields, facebookInfo => {
										let dataInfo = JSON.parse(JSON.stringify(facebookInfo));
										let fbData = {
											email:dataInfo.email,
											id:dataInfo.id,
											name:dataInfo.name,
											picture:`https://graph.facebook.com/${dataInfo.id}/picture?type=large`
										};
										uni.showLoading({
											title: this.$t(`message.login.loginLoading`)
										});
										loginFacebook(fbData).then(res=>{
											this.$store.commit("LOGIN", {
												'token': res.data.token
											});
											that.getUserInfo(res.data);
										}).catch(e => {
											uni.hideLoading()
											that.$util.Tips({
												title: e
											});
										});
									});
								});
							} else {
								uni.showToast({
									title: this.$t(`message.login.loginFacebook`),
									icon: 'none'
								});
							}
						});
					}, {
						scope: 'email',
						return_scopes: true,
					}
				);

			},
			OnGoogleAuthSuccess(idToken) {
				let that=  this;
				uni.showLoading({
					title: this.$t(`message.login.loginLoading`)
				});
				loginGoogle(idToken).then(res=>{
					this.$store.commit("LOGIN", {
						'token': res.data.token
					});
					that.getUserInfo(res.data);
				}).catch(e => {
					uni.hideLoading();
					that.$util.Tips({
						title: e
					});
				});
			},
			OnGoogleAuthFail(error) {
				console.log(error)
			},
			goPage(url) {
				uni.navigateTo({
					url
				})
			},
			submit: Debounce(function() {
				let that = this;
				if(this.active === 0){
					if (!that.email) return that.$util.Tips({
						title: this.$t(`message.login.emailEmpty`)
					});
					if (!/^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/i.test(that.email)) return that.$util.Tips({
						title: this.$t(`message.login.correctEmail`)
					});
					if (!that.password) return that.$util.Tips({
						title: this.$t(`message.login.emptyPassword`)
					});
					if (!that.isAgree) return that.$util.Tips({
						title: this.$t(`message.login.agreement`)
					});
					uni.showLoading({
						title: this.$t(`message.login.loginLoading`)
					});
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
				}else if(this.active === 1 && this.current == 1){
					if (!that.phone) return that.$util.Tips({
						title: this.$t(`message.login.emptyPhone`)
					});
					if (!that.password) return that.$util.Tips({
						title: this.$t(`message.login.emptyPassword`)
					});
					if (!that.isAgree) return that.$util.Tips({
						title: this.$t(`message.login.agreement`)
					});
					uni.showLoading({
						title: this.$t(`message.login.loginLoading`)
					});
					mobilePassword({
						"countryCode": '+' + that.countryCode,
						"password": that.password,
						"phone": that.phone
					}).then(res=>{
						let data = res.data;
						let newTime = Math.round(new Date() / 1000);
						this.$store.commit("LOGIN", {
							'token': res.data.token
						});
						that.getUserInfo(data);
					}).catch(err => {
						return that.$util.Tips({
							title: err
						});
					});
				}else if(this.active === 1 && this.current == 0){
					if (!that.phone) return that.$util.Tips({
						title: this.$t(`message.login.emptyPhone`)
					});
					if (!that.captcha) return that.$util.Tips({
						title: this.$t(`message.login.emptyCaptche`) 
					});
					if (!/^[\w\d]+$/i.test(that.captcha)) return that.$util.Tips({
						title: this.$t(`message.login.correctCaptche`)
					});
					mobileCaptcha({
						"captcha": that.captcha,
						"countryCode": '+' + that.countryCode,
						"phone": that.phone
					}).then(res=>{
						let data = res.data;
						let newTime = Math.round(new Date() / 1000);
						this.$store.commit("LOGIN", {
							'token': res.data.token
						});
						that.getUserInfo(data);
					}).catch(err => {
						return that.$util.Tips({
							title: err
						});
					});
				}
			}),
			codePhone(){
				let that = this;
				if (that.disabled) return;
				if (!that.phone) return that.$util.Tips({
					title: this.$t(`message.login.emptyPhone`)
				});
				uni.showLoading({
					title: this.$t(`message.tips.loding`)
				});
				registerVerify({countryCode:'+'+that.countryCode,phone:that.phone}).then(res => {
					that.sendCode();
					uni.hideLoading();
					that.$util.Tips({title:res.message});
				}).catch(err => {
					uni.hideLoading();
					return that.$util.Tips({
						title: err
					});
				});
			},
			getUserInfo(data) {
				let that = this;
				this.$store.commit("SETUID", data.uid);
				getUserInfo().then(res => {
					uni.hideLoading();
					this.$store.commit("UPDATE_USERINFO", res.data);
					let backUrl = this.$Cache.get(BACK_URL) || "/pages/index/index";
					return that.$util.Tips({
						title: this.$t(`message.login.loginSuccess`),
						icon:'success'
					}, {
						tab: 4,
						url: backUrl
					});
				}).catch(e => {
					this.$util.Tips({
						title: e
					});
				});
			},
			selectCountry(){
				this.showList = true;
			},
			clickData(data) {
				this.countryCode = data.value;
				uni.setStorageSync('countryCode', data.value);
				this.countryFlag = data.flag;
				this.showList = false;
			},
			closeList(){
				this.showList = false;
			}
		}
	};
</script>
<style lang="scss" scoped>
	.protocol{
		margin: 30rpx 0;
		padding-left: 44rpx;
	}
	.protocol_text{
		.font_pro{
			@include main_color(theme);
		}
	}
	.main_color {
		@include main_color(theme);
	}

	.bg_color {
		@include main_bg_color(theme);
	}

	.text-white {
		color: #fff;
	}

	.text-333 {
		color: #333;
	}

	.border {
		border: 1px solid #DDDDDD;
	}

	.acea-row.row-middle {
		input {
			margin-left: 20rpx;
			display: block;
		}
	}
	.px-20{
		padding: 0 20rpx 0;
	}
	.flag{
		width: 40rpx;
		height:26rpx;
		display: inline-block;
		margin-left: 26rpx;
	}
	.select_code{
		width: 16px;height: 8px;
		display: inline-block;
		margin-left: 16rpx;
	}
	.pos_line{
		position: relative;
		&::after{
			content: '';
			position: absolute;
			right: 0;
			top: 50%;
			transform: translateY(-50%);
			width: 1px;
			height: 28rpx;
			background-color: #eee;
		}
	}
	.anonymous{
		font-size: 24rpx;
		margin-top: 32rpx;
		color: #666;
	}
	.login-wrapper {
		padding: 30rpx;
		height: 100vh;
		background: #fff;
		.tabs {
			display: flex;
			align-items: center;
			justify-content: center;
			width: 100%;
			margin: 142rpx auto 0;
			font-size: 36rpx;
			font-family: PingFangSC-Semibold, PingFang SC;
			font-weight: 600;
			color: #333;
			line-height: 50rpx;
			text:nth-child(1){
				margin-right: 166rpx;
			}
				.active{
					@include main_color(theme);
					position: relative;
					::after{
						content: '';
						position: absolute;
						width: 80rrpx;
						height: 6rpx;
						@include main_bg_color(theme);
						bottom: -20rpx;
						left: 0;
						right: 0;
						margin:auto ;
					}
				}
		}

		.whiteBg {
			margin-top: 100rpx;

			.list {
				border-radius: 16rpx;
				overflow: hidden;
				margin-bottom: 30rpx;
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
						.Resend{
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

			.logon {
				display: flex;
				align-items: center;
				justify-content: center;
				width: 546rpx;
				height: 86rpx;
				margin: auto;
				border-radius: 120rpx;
				font-size: 30rpx;
			}

			.tips {
				margin: 30rpx;
				text-align: center;
				color: #999;
			}
		}

		.bottom {
			text-align: center;
			margin-top: 104rpx;
			margin-bottom: 80rpx;
			.sign_type {
				font-size: 24rpx;
				font-family: PingFangSC-Regular, PingFang SC;
				font-weight: 400;
				color: #B4B4B4;
				position: relative;
				&::before{
					content: '';
					position: absolute;
					top: 16rpx;
					left: -80rpx;
					width: 68rpx;
					height: 1px;
					background: #ccc;
					opacity: .5;
				}
				&::after{
					content: '';
					position: absolute;
					top: 16rpx;
					right: -80rpx;
					width: 68rpx;
					height: 1px;
					background: #ccc;
					opacity: .5;
				}
			}

			.sign_type_list {
				width: 284rpx;
				margin: auto;
				display: flex;
				justify-content: space-around;
				padding-top: 40rpx;

				image {
					width: 68rpx;
					height: 68rpx;
				}
			}

		}
	}

	.pos {
		position: relative;

		&-cb {
			position: absolute;
			left: 50%;
			bottom: 200rpx;
			transform: translateX(-50%);
		}
	}
</style>
