<template>
	<view class="reg-wrapper">
		<uniNavBar background-color="#fff" left-icon="back" color="#000" :border='false' @clickLeft='returns' ></uniNavBar>
		<div class="tabs">
			<text v-for="(item,index) in tabList" :key="index" :class="{ 'active': active == index}" @click="tab(index)">{{$t(`page.users.register.tabNav[${index}].name`)}}</text>
		</div>
		<div class="whiteBg">
			<div class="list" v-show="active == 0">
				<form @submit.prevent="submit">
					<div class="item">
						<div class="acea-row row-middle">
							<text class="iconfont icon-youxiang"></text>
							<input type="text" class="texts" :placeholder="$t(`page.users.register.placeEmail`)" v-model="email" required/>
						</div>
					</div>
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
							<input type="password" class="texts" maxlength="20" :placeholder="$t(`page.users.login.placePasd`)" v-model="password" />
						</div>
					</div>
					<div class="item">
						<div class="acea-row row-middle">
							<text class="iconfont icon-mima"></text>
							<input type="password" class="texts" :placeholder="$t(`page.users.login.Pasdagain`)" v-model="password1" />
						</div>
					</div>
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
					<div class="item pos">
						<div class="acea-row row-middle">
							<text class="iconfont icon-yanzhengma"></text>
							<input type="number" class="texts" :placeholder="$t(`page.users.register.placeCode`)" v-model="captcha" />
							<view class="Resend pos-rc" :disabled="disabled" @click="codePhone">{{ text }}</view>
						</div>
					</div>
					<div class="item">
						<div class="acea-row row-middle">
							<text class="iconfont icon-mima"></text>
							<input type="password" class="texts" maxlength="20" :placeholder="$t(`page.users.login.placePasd`)" v-model="password" />
						</div>
					</div>
					<div class="item">
						<div class="acea-row row-middle">
							<text class="iconfont icon-mima"></text>
							<input type="password" class="texts" maxlength="20" :placeholder="$t(`page.users.login.Pasdagain`)" v-model="password1" />
						</div>
					</div>
				</form>
			</div>
			<div class="logon bg_color text-white" v-show="active == 0" @click="emailRegister">{{$t(`page.users.register.submit`)}}</div>
			<div class="logon bg_color text-white" v-show="active == 1" @click="phoneRegister">{{$t(`page.users.register.submit`)}}</div>
			<div class="font-sm mt-40 text-center acea-row row-center">
				<span class="mr10">{{$t(`page.users.register.have`)}}</span>
				<navigator url="/pages/users/login/index?isToLogin=isToLogin" class="main_color">{{$t(`page.users.register.sign`)}}</navigator> 
			</div>
		</div>
		<tui-drawer mode="bottom" :visible="showList" @close="closeDrawer">
			<SortPickerList ref="sortPickerList" @clickData="clickData" @close="closeList"></SortPickerList>
		</tui-drawer>
	</view>
</template>

<script>
	import {registerEmail,emailCaptcha,registerVerify,registerMobile,getUserInfo} from '@/api/user'
	import sendVerifyCode from "@/mixins/SendVerifyCode";
	import SortPickerList from "@/components/sortPickerList/index.vue";
	import {Debounce} from '@/utils/validate.js'
	export default {
		data() {
			return {
				tabList:['Email','Phone'],
				email:'',
				captcha:'',
				phone:'',
				password:'',
				password1:'',
				active:0,
				showList:false,
				countryCode:'86',
				countryFlag:'../../../static/flag/cn.png'
			}
		},
		mixins: [sendVerifyCode],
		components:{
			SortPickerList
		},
		onReady() {
			var that = this
			that.$refs["sortPickerList"].initPage();
		},
		methods: {
			tab(index){
				this.active = index;
			},
			returns(){
				uni.navigateBack()
			},
			emailRegister:Debounce(function(){
				let that = this;
				if (!that.email) return that.$util.Tips({
					title: this.$t(`message.login.emailEmpty`)
				});
				if (!/^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/i.test(that.email)) return that.$util.Tips({
					title: this.$t(`message.login.correctEmail`)
				});
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
				uni.showLoading({
					title: this.$t(`message.login.loginLoading`)
				});
				registerEmail({
					email: that.email,
					captcha: that.captcha,
					password:that.password
				}).then(res => {
					this.$store.commit("LOGIN", {
						'token': res.data.token
					});
					that.getUserInfo(res.data);
				}).catch(res => {
					that.$util.Tips({
						title: res
					});
				});
			}),
			phoneRegister:Debounce(function(){
				let that = this;
				if (!that.phone) return that.$util.Tips({ 
					title: this.$t(`message.login.emptyPhone`)
				});
				if (!that.captcha) return that.$util.Tips({
					title: this.$t(`message.login.emptyCaptche`)
				});
				if (!/^[\w\d]+$/i.test(that.captcha)) return that.$util.Tips({  
					title: this.$t(`message.login.correctCaptche`)
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
				uni.showLoading({
					title: this.$t(`message.login.loginLoading`)
				});
				registerMobile({
					"captcha": that.captcha,
					"countryCode": '+' + that.countryCode,
					"password": that.password,
					"phone": that.phone
				}).then(res => {
					let data = res.data;
					let newTime = Math.round(new Date() / 1000);
					this.$store.commit("LOGIN", {
						'token': res.data.token
					});
					that.getUserInfo(data);
				}).catch(res => {
					that.$util.Tips({
						title: res
					});
				});
			}),
			codeEmail:Debounce(function() {
				let that = this;
				if (that.disabled) return;
				if (!that.email) return that.$util.Tips({
					title: this.$t(`message.login.emailEmpty`)
				});
				if (!/^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/i.test(that.email)) return that.$util.Tips({
					title: this.$t(`message.login.correctEmail`)
				});
				emailCaptcha(that.email).then(res => {
					that.$util.Tips({title:res.message});
					that.sendCode();
				}).catch(err => {
					return that.$util.Tips({
						title: err
					});
				});
			}),
			codePhone:Debounce(function(){
				let that = this;
				if (that.disabled) return;
				if (!that.phone) return that.$util.Tips({
					title: this.$t(`message.login.emptyPhone`)
				});
				uni.showLoading({
					title: this.$t(`message.tips.loding`)
				});
				registerVerify({countryCode:'+'+that.countryCode,phone:that.phone}).then(res => {
					that.$util.Tips({title:res.message});
					uni.hideLoading();
					that.sendCode();
				}).catch(err => {
					uni.hideLoading();
					return that.$util.Tips({
						title: err
					});
				});
			}),
			getUserInfo(data) {
				let that = this;
				this.$store.commit("SETUID", data.uid);
				getUserInfo().then(res => {
					uni.hideLoading();
					this.$store.commit("UPDATE_USERINFO", res.data);
					return that.$util.Tips({
						title: this.$t(`message.login.loginSuccess`),
						icon:'success'
					}, {
						tab: 4,
						url: '/pages/index/index'
					});
				})
			},
			selectCountry(){
				this.showList = true;
			},
			clickData(data) {
				this.countryCode = data.value;
				this.countryFlag = data.flag;
				this.showList = false;
			},
			closeList(){
				this.showList = false;
			}
		}
	}
</script>

<style lang="scss">
.bg_color{
	@include main_bg_color(theme);
}
.main_color{
	@include main_color(theme);
}
.text-white{
	color: #fff;
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
 .reg-wrapper{
	 height: 100vh;
	 padding: 30rpx;
	 background: #fff;
	 .tabs {
	 	display: flex;
	 	align-items: center;
	 	justify-content: space-between;
		width: 80%;
	 	margin: 142rpx auto 0;
	 	font-size: 36rpx;
	 	font-family: PingFangSC-Semibold, PingFang SC;
	 	font-weight: 600;
	 	color: #333;
	 	line-height: 50rpx;
		.active{
			@include main_color(theme);
			position: relative
			::after{
				content: '';
				position: absolute;
				width: 80rpx;
				height: 6rpx;
				@include main_bg_color(theme);
				bottom: -20rpx;
				left: 0;
				right: 0;
				margin:auto ;
			}
		}
	 }
	 .acea-row.row-middle {
	 	input {
	 		margin-left: 20rpx;
	 		display: block;
	 	}
	 }
	 .whiteBg {
	 	margin-top: 100rpx;
	 	
	 	.list {
	 		border-radius: 16rpx;
	 		overflow: hidden;
	 		margin-bottom: 100rpx;
			padding: 0 60rpx 0;
	 		.item {
	 			border-bottom: 1px solid #F0F0F0;
	 			background: #fff;
				.iconfont{
					font-size: 30rpx;
					color: #B4B4B4;
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
	 			.row-middle {
	 				position: relative;
	 				padding: 16rpx 24rpx;
	 				
	 				.texts{
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
	 		.forget{
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
 }
 .pos {
    position: relative;
	&-rc {
	  position: absolute;
	  right: 0;
	  top: 50%;
	  transform: translateY(-50%);
	}
 }
</style>
