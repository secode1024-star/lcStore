<template>
	<view v-if="!successful">
		<form report-submit='true'>
			<view class='merchantsSettled'>
				<view class="merchantBg">
					<view class="merchantBg-title">{{$t(`page.store.title1`)}}</view>
				</view>
				<view class="application-record" @click="jumpToList">
					{{$t(`page.user.record`)}}
					<text class="iconfont icon-xuanze"></text>
				</view>
				<view class='list'>
					<view class="item">
						<view class="acea-row row-middle">
							<text class="item-name">{{$t(`page.store.storeName`)}}</text>
							<input type="text" maxlength="30" :placeholder="$t(`page.store.storeName`)" v-model="merchantData.name" @change="validateBtn"
							 placeholder-class='placeholder' />
						</view>
					</view>
					<view class="item">
						<view class="acea-row row-middle">
							<text class="item-name">{{$t(`page.store.userName`)}}</text>
							<input type="text" :placeholder="$t(`page.store.userName`)" v-model="merchantData.realName" @change="validateBtn" placeholder-class='placeholder' />
						</view>
					</view>
					<view class="item">
						<view class="acea-row row-middle">
							<text class="item-name">{{$t(`page.store.phone`)}}</text>
							
							<view class="acea-row row-middle pos_line" @click="selectCountry()">
								<image :src="countryFlag" class="flag"></image>
								<image src="../../../static/images/xiala.png" class="select_code"></image>
							</view>
							<text class="px-20 mr10">+{{countryCode}}</text>
							<input type="number" class="texts" v-model="merchantData.phone" :placeholder="$t(`page.store.phone`)" style="margin:0;width: 252rpx;" />
	
						</view>
					</view>
					<view class="item">
						<view class="acea-row row-middle">
							<text class="item-name">{{$t(`page.store.emil`)}}</text>
							<input type="text" :placeholder="$t(`page.store.emil`)" v-model="merchantData.email" @change="validateBtn" placeholder-class='placeholder' />
						</view>
					</view>
					<view class="item rel">
						<view class="acea-row row-middle">
							<text class="item-name">{{$t(`page.store.code`)}}</text>
							<input type="text" :placeholder="$t(`page.store.code`)" v-model="merchantData.captcha" @change="validateBtn" class="codeIput"
							 placeholder-class='placeholder' />
							<button class="code" :disabled="disabled" :class="disabled === true ? 'on' : ''" @click="code">
								{{ text }}
							</button>
						</view>
					</view>
					<view class="item">
						<view class="uni-list">
							<view class="uni-list-cell">
								<view class="uni-list-cell-db acea-row row-middle">
									<text class="item-name">{{$t(`page.store.class`)}}</text>
									<picker @change="bindPickerChange" :value="index" :range="merchantClassify" range-key="name">
										<input :placeholder="$t(`page.store.class`)" type="text" readonly disabled v-model="merchantCategoryName" @change="validateBtn">
										<view class='iconfont icon-gengduo'></view>
									</picker>
								</view>
							</view>
						</view>
					</view>
					<view class="item">
						<view class="uni-list">
							<view class="uni-list-cell">
								<view class="uni-list-cell-db acea-row row-middle">
									<text class="item-name">{{$t(`page.store.type`)}}</text>
									<picker @change="bindPickerChange1" :value="index1" :range="merchantType" range-key="name">									
										<input :placeholder="$t(`page.store.type`)" type="text" disabled readonly v-model="merchantTypeName" @change="validateBtn">
										<view v-if="merchantTypeName" @tap.stop="merchantTypeName=''" class="iconfont icon-guanbi2"></view> 
										<view class='iconfont icon-gengduo'></view>
									</picker>
								</view>
							</view>
						</view>
					</view>
					<view class="item">
						<view class="acea-row row-middle">
							<text class="item-name">{{$t(`page.store.keyword`)}}</text>
							<input type="text" maxlength="30" :placeholder="$t(`page.store.keyword`)" v-model="merchantData.keywords"
							 placeholder-class='placeholder' />
						</view>
					</view>
					<view class='item acea-row row-between-wrapper relative'>
						<view class='name'>{{$t(`page.users.userAddress.country`)}}</view>
						<input type='text' placeholder-style="color:#ccc;" name="country"
							:value='country' placeholder-class='placeholder' @click="selectCountry('country')"></input>
					</view>
					<view class='item acea-row row-between-wrapper relative'>
						<view class='name'>{{$t(`page.users.userAddress.address`)}}</view>
						<input type='text' :placeholder='$t(`page.users.userAddress.place`) +  $t(`page.users.userAddress.address`)' placeholder-style="color:#ccc;" name='detail'
							placeholder-class='placeholder' v-model="address"></input>
					</view>
					<view class="item no-border">
						<view class='acea-row row-middle'>
							<text class="item-title">{{$t(`page.store.place1`)}}</text>
							<text v-show="merchantTypeInfo" class="item-title">( {{merchantTypeInfo}} )</text>
							<text class="item-desc">({{$t(`page.store.place2`)}})</text>
							<view class="upload">
								<view class='pictrue' v-for="(item,index) in pics" :key="index" :data-index="index" @click="getPhotoClickIdx">
									<image :src='item'></image>
									<text class='iconfont icon-zhifushibai' @click.stop='DelPic(index)'></text>
								</view>
								<view class='pictrue acea-row row-center-wrapper row-column' @click='uploadpic' v-if="pics.length < 10">
									<text class='iconfont icon-icon25201'></text>
									<view>{{$t(`page.users.goodsCommentCon.upload`)}}</view>
								</view>
							</view>
						</view>
					</view>
					<view class="item no-border acea-row">
						<checkbox-group @change='ChangeIsAgree' class="acea-row" style="align-items: end;">
							<checkbox class="checkbox" :checked="isAgree ? true : false" />
							<span>{{$t(`page.store.agree`)}}</span>
						</checkbox-group>
						<button class="settleAgree" @click="showProtocol = true">《{{$t(`page.store.agreement`)}}》</button>
					</view>
					<button class='submitBtn' :class="successful === true ? 'on':''" @click="formSubmit">{{$t(`page.store.submit`)}}</button>
				</view>
			</view>
		</form>
		<view class="settlementAgreement" v-if="showProtocol">
			<view class="setAgCount">
				<i class="icon iconfont icon-guanbi" @click="showProtocol = false"></i>
				<div class="title">{{$t(`page.store.agreement2`)}}</div>
				<view class="content">
					<jyf-parser :html="protocol" ref="article" :tag-style="tagStyle"></jyf-parser>
				</view>

			</view>
		</view>
		<view class='loadingicon acea-row row-center-wrapper' v-if="loading">
			<text class='loading iconfont icon-jiazai' :hidden='loading==false'></text>
		</view>
        <tui-drawer mode="bottom" :visible="showList" @close="closeDrawer">
        	<SortPickerList ref="sortPickerList" @clickData="clickData" @close="closeList"></SortPickerList>
        </tui-drawer>
	</view>
	<view class="settledSuccessMain" v-else>
		<view class="settledSuccessful">
			<img class="image" src="../images/settledSuccessful.svg" alt="">
			<view class="title">{{$t(`page.store.Tips1`)}}</view>
			<view class="info">{{$t(`page.store.Tips2`)}}</view>
			<view class="goHome" hover-class="none" @click="goHome">
				{{$t(`page.store.Tips3`)}}
			</view>
		</view>
	</view>
</template>
<script>
	import {
		getconfig,
	} from '@/api/public.js';
	import {
		toLogin
	} from '@/libs/login.js';
	import {
		getMerSettledApplyApi,
		emailSettledApi,
		settledAgreementApi
	} from '@/api/merchant.js';
	import {
		emailCaptcheReset
	} from "@/api/user";

	import {
		mapGetters
	} from "vuex";
	import wPicker from "@/components/wPicker/w-picker.vue";
	import parser from "@/components/jyf-parser/jyf-parser";
	import SortPickerList from "@/components/sortPickerList/index.vue";
	import sendVerifyCode from "@/mixins/SendVerifyCode";
	const app = getApp();
	export default {
		components: {
			SortPickerList,
			"jyf-parser": parser
		},
		data() {
			return {
				showList:false,
				countryCode:'86',
				countryFlag:'../../../static/flag/cn.png',
				cartId: '', //购物车id
				pinkId: 0, //拼团id
				couponId: 0, //优惠券id
				isAuto: false, //没有授权的不会自动授权
				isShowAuth: false, //是否隐藏授权
				text: this.$t(`page.store.getCode`),
				disabled: false,
				isAgree: false,
				showProtocol: false,
				isShowCode: false,
				loading: false,
				merchantData: {
					name: "",
					realName: "",
					phone: "",
					captcha: '',
					address: '',
					categoryId: 0,
					email: '',
					handlingFee: '',
					keywords: '',
					qualificationPicture: '',
					typeId: 0
				},
				address: '',
				validate: false,
				successful: false,
				codeVal: "",
				protocol: "",
				timer: "",
				index: 0,
				index1: 0,
				merchantCategoryName: "",
			    merchantTypeName: '',
				pics: [],
				tagStyle: {
					img: 'width:100%;display:block;'
				},
				mer_i_id: null, // 商户申请id
				checkType:'country',
				country:'China',
				isType: false,
				merchantTypeInfo: '' //店铺类型说明
			};
		},
		mixins: [sendVerifyCode],
		beforeDestroy() {
			clearTimeout(this.timer)
		},
		computed: mapGetters(['isLogin', 'merchantClassify', 'merchantType']),
		mounted() {
			this.$store.dispatch('MerCategoryList');
			this.$store.dispatch('MerTypeList');
		},
		onLoad(options) {
			uni.setNavigationBarTitle({
				title: this.$t(`page.store.title1`)
			})
			if (!this.isLogin) {
				toLogin();
			}
			if (options.mer_i_id) {
				this.mer_i_id = options.mer_i_id
				uni.showLoading({
					title: this.$t(`message.tips.loding`)
				});
			}
		},
		onShow() {
			this.getConfig()
		},
		onReady() {
			this.$refs["sortPickerList"].initPage()
		},
		methods: {
			selectCountry(type){
				this.showList = true;
				this.checkType = type;
			},
			clickData(data) {
				this.countryCode = data.value;
				this.countryFlag = data.flag;
				this.country = data.country;
				this.showList = false;
				
				//this.countryCode = '+' + data.value;
				
				//this.showList = false;
			},
			closeList(){
				this.showList = false;
			},
			getConfig() {
				// 获取配置
				settledAgreementApi().then(res => {
					this.protocol = res.data.agreement
				}).catch(err => {
					return this.$util.Tips({
						title: err
					});
				});
			},
			bindPickerChange: function(e) {
				console.log('picker发送选择改变，携带值为', e.target.value)
				this.index = e.target.value
				let idx = e.target.value
				this.merchantData.categoryId = this.merchantClassify[idx]['id']
				this.merchantCategoryName = this.merchantClassify[idx]['name']
				this.merchantData.handlingFee = this.merchantClassify[idx]['handlingFee']
			},
			bindPickerChange1: function(e) {
				console.log('picker发送选择改变，携带值为', e.target.value)
				this.index1 = e.target.value
				let idx = e.target.value
				this.merchantData.typeId = this.merchantType[idx]['id']
				this.merchantTypeName = this.merchantType[idx]['name']
				this.merchantTypeInfo = this.merchantType[idx]['info']
			},
			/*店铺类型说明*/
			getAgreement() {
				this.showProtocol = true;
				this.isType = true
				
			},
			// 图片预览
			// 获得相册 idx
			getPhotoClickIdx(e) {
				let _this = this;
				let idx = e.currentTarget.dataset.index;
				_this.imgPreview(_this.pics, idx);
			},
			// 图片预览
			imgPreview: function(list, idx) {
				// list：图片 url 数组
				if (list && list.length > 0) {
					uni.previewImage({
						current: list[idx], //  传 Number H5端出现不兼容 
						urls: list
					});
				}
			},
			// 授权回调
			onLoadFun: function() {
				this.isShowAuth = false;
			},
			// 授权关闭
			authColse: function(e) {
				this.isShowAuth = e
			},
			toggleTab(str) {
				this.$refs[str].show();
			},
			// 首页
			goHome() {
				uni.navigateTo({
					url: '/pages/index/index'
				});
			},
			/**
			 * 上传文件
			 * 
			 */
			uploadpic: function() {
				let that = this;
				that.$util.uploadImageOne({
					url: 'upload/image',
					name: 'multipart',
					model: "user",
					pid: 0
				}, function(res) {
					that.pics.push(res.data.url);
					that.$set(that, 'pics', that.pics);
				});
			},
			/**
			 * 删除图片
			 * 
			 */
			DelPic: function(index) {
				let that = this,
					pic = this.pics[index];
				that.pics.splice(index, 1);
				that.$set(that, 'pics', that.pics);
			},
			async code() {
				let that = this;
				if (that.disabled) return;
				if (!that.merchantData.email) return that.$util.Tips({
					title: this.$t(`message.login.emailEmpty`)
				});
				emailSettledApi(that.merchantData.email).then(res => {
					that.$util.Tips({title:res.message});
					that.sendCode();
				}).catch(err => {
					return that.$util.Tips({
						title: err
					});
				});
			},
			onConfirm(val) {
				this.region = val.checkArr[0] + '-' + val.checkArr[1] + '-' + val.checkArr[2];
			},
			ChangeIsAgree: function(e) {
				this.isAgree = !this.isAgree;
				this.validateBtn();
			},

			formSubmit: function(e) {
				if (this.validateForm() && this.validate) {
					if(this.pics.length==0) return this.$util.Tips({
						title: this.$t(`message.settled.emptyIsPicture`)
					});
					this.merchantData.qualificationPicture = JSON.stringify(this.pics)
					this.merchantData.address = this.country + ',' + this.address
					getMerSettledApplyApi(this.merchantData).then(data => {
						this.loading = true;
						this.timer = setTimeout(() => {
							this.successful = true;
						}, 1000)
					
					}).catch(res => {
						this.$util.Tips({
							title: res
						});
					})
					
				}
			},
			validateBtn: function() {
				let that = this,
					value = that.merchantData;
				if (value.name && value.realName && value.email && value.categoryId &&
					value.captcha && that.isAgree && value.typeId && value.address && value.pics) {
					if (that.codeVal) {
						that.validate = true;
					} else {
						that.validate = false;
					}

				}
			},

			validateForm: function() {
				let that = this,
					value = that.merchantData;

				if (!value.name) return that.$util.Tips({
					title: this.$t(`message.settled.emptyName`)
				});
				if (!value.realName) return that.$util.Tips({
					title: this.$t(`message.settled.emptyRealName`)
				});
				if (!value.captcha) return that.$util.Tips({
					title: this.$t(`message.settled.emptyCaptcha`)
				});
				if (!value.categoryId) return that.$util.Tips({
					title: this.$t(`message.settled.emptyCategory`)
				});
				if (!that.isAgree) return that.$util.Tips({
					title: this.$t(`message.settled.emptyIsAgree`)
				});
				that.validate = true;
				return true;
			},
			jumpToList() {
				uni.navigateTo({
					url: "/pages/merchant/application_record/index"
				})
			},

		}
	}
</script>

<style scoped lang="scss">
	.select_code{
		width: 16px;height: 8px;
		display: inline-block;
		margin-left: 16rpx;
	}
	.flag{
		width: 40rpx;
		height:26rpx;
		display: inline-block;
	}
	.uni-input-placeholder {
		color: #B2B2B2;
	}
	.item-name{
		width: 174rpx;
	}

	.uni-list-cell {
		position: relative;

		.iconfont {
			font-size: 14px;
			color: #7a7a7a;
			position: absolute;
			right: 15px;
			top: 7rpx;
		}
		.icon-guanbi2{
			right: 35px;
		}
	}
	.merchantsSettled {
		@include linear-gradient(theme);
		height: 154vh;
	}
	.merchantsSettled .merchantBg {
		width: 100%;
		height: 342rpx;
		background-image: url("../images/ruzhu.png");
		background-size: 100% 100%;
		background-repeat: no-repeat;
		padding-top: 92rpx;
		.merchantBg-title{
			text-align: center;
			color: #fff;
			font-size: 60rpx;
			font-weight: 600;
			margin-bottom: 20rpx;
		}
		.merchantBg-join{
			text-align: center;
			color: #fff;
			font-size: 36rpx;
		}
	}
	.merchantsSettled .list {
		background-color: #fff;
		border-radius: 12px;
		margin: 0 15px;
		position: absolute;
		top: 214rpx;
		width: calc(100% - 30px);
	}
	.application-record {
		position: absolute;
		display: flex;
		align-items: center;
		top: 40rpx;
		right: 0;
		color: #fff;
		font-size: 22rpx;
		background-color: rgba(0, 0, 0, 0.3);
		padding: 8rpx 18rpx;
		border-radius: 20px 0px 0px 20px;
	}
	.merchantsSettled .list .item {
		padding: 22rpx 0;
		border-bottom: 1rpx solid #eee;
		position: relative;
		margin: 0 20px;
		&.no-border {
			border-bottom: none;
			padding-left: 0;
			padding-right: 0;
		}
		.item-title {
			color: #666666;
			font-size: 28rpx;
			display: block;
		}
		.item-desc {
			color: #B2B2B2;
			font-size: 22rpx;
			display: block;
			margin-top: 9rpx;
			line-height: 36rpx;
		}
	}
	.acea-row,.upload {
		display: -webkit-box;
		display: -moz-box;
		display: -webkit-flex;
		display: -ms-flexbox;
		display: flex;
		-webkit-box-lines: multiple;
		-moz-box-lines: multiple;
		-o-box-lines: multiple;
		-webkit-flex-wrap: wrap;
		-ms-flex-wrap: wrap;
		flex-wrap: wrap;
	}
	.upload {
		margin-top: 20rpx;
	}
	.acea-row.row-middle {
		-webkit-box-align: center;
		-moz-box-align: center;
		-o-box-align: center;
		-ms-flex-align: center;
		-webkit-align-items: center;
		align-items: center;
		padding-left: 2px;
	}
	.acea-row.row-column {
		-webkit-box-orient: vertical;
		-moz-box-orient: vertical;
		-o-box-orient: vertical;
		-webkit-flex-direction: column;
		-ms-flex-direction: column;
		flex-direction: column;
	}
	.acea-row.row-center-wrapper {
		-webkit-box-align: center;
		-moz-box-align: center;
		-o-box-align: center;
		-ms-flex-align: center;
		-webkit-align-items: center;
		align-items: center;
		-webkit-box-pack: center;
		-moz-box-pack: center;
		-o-box-pack: center;
		-ms-flex-pack: center;
		-webkit-justify-content: center;
		justify-content: center;
	}
	.merchantsSettled .list .item .pictrue {
		width: 130rpx;
		height: 130rpx;
		margin: 24rpx 22rpx 0 0;
		position: relative;
		font-size: 11px;
		color: #bbb;
		&:nth-child(4n) {
			margin-right: 0;
		}
		&:nth-last-child(1) {
			border: 0.5px solid #ddd;
			box-sizing: border-box;
		}
		uni-image,
		image {
			width: 100%;
			height: 100%;
			border-radius: 1px;
			img {
				-webkit-touch-callout: none;
				-webkit-user-select: none;
				-moz-user-select: none;
				display: block;
				position: absolute;
				top: 0;
				left: 0;
				opacity: 0;
				width: 100%;
				height: 100%;
			}
		}
		.icon-zhifushibai {
			font-size: 33rpx;
			position: absolute;
			top: -10px;
			right: -10px;
		}
	}
	.uni-list-cell-db{
		position: relative;
	}
	.wenhao{
		width: 34rpx;
		height: 34rpx;
		display: flex;
		align-items: center;
		justify-content: center;
		font-size: 28rpx;
		border-radius: 50%; 
		background: #E3E3E3;
		color: #ffffff!important;
		margin-left: 4rpx;
		position: absolute;
		left: 122rpx;
	}
	.merchantsSettled .list .item .imageCode {
		position: absolute;
		top: 7px;
		right: 0;
	}
	.merchantsSettled .list .item .icon {
		font-size: 40rpx;
		color: #b4b1b4;
	}
	.merchantsSettled .list .item input {
		width: 420rpx;
		font-size: 30rpx;
	}
	.merchantsSettled .list .item .placeholder {
		color: #b2b2b2;
	}
	.merchantsSettled .default {
		padding: 0 30rpx;
		height: 90rpx;
		background-color: #fff;
		margin-top: 23rpx;
	}
	.merchantsSettled .default checkbox {
		margin-right: 15rpx;
	}
	.merchantsSettled .acea-row uni-image {
		// width: 20px;
		// height: 20px;
		display: block;
	}
	.merchantsSettled .list .item .codeIput {
		width: 125px;
	}
	.uni-input-input {
		display: block;
		height: 100%;
		background: none;
		color: inherit;
		opacity: 1;
		-webkit-text-fill-color: currentcolor;
		font: inherit;
		line-height: inherit;
		letter-spacing: inherit;
		text-align: inherit;
		text-indent: inherit;
		text-transform: inherit;
		text-shadow: inherit;
	}
	.merchantsSettled .list .item .code {
		position: absolute;
		width: 93px;
		line-height: 27px;
		@include coupons_border_color(theme);
		border-radius: 15px;
		@include main_color(theme);
		text-align: center;
		bottom: 8px;
		right: 0;
		font-size: 12px;
	}
	.merchantsSettled .list .item .code.on {
		background-color: #bbb;
		color: #fff;
		border-color: #bbb;
	}
	.merchantsSettled .submitBtn {
		width: 588rpx;
		margin: 25px auto 25px auto;
		height: 86rpx;
		border-radius: 25px;
		text-align: center;
		line-height: 86rpx;
		font-size: 15px;
		color: #fff;
		@include main_bg_color(theme);
	}
	.merchantsSettled .submitBtn.on {
		@include main_bg_color(theme);
	}
	uni-checkbox-group,
	.settleAgree {
		display: inline-block;
		font-size: 24rpx;
	}
	uni-checkbox-group {
		color: #b2b2b2;
	}
	::v-deep checkbox .uni-checkbox-input.uni-checkbox-input-checked {
	  @include coupons_border_color(theme);
	  @include main_color(theme);
	}
	.settleAgree {
		@include main_color(theme);
		position: relative;
		top: 2px;
		left: 8px;
	}
	.merchantsSettled uni-checkbox .uni-checkbox-wrapper {
		width: 30rpx;
		height: 30rpx;
		border: 2rpx solid #C3C3C3;
		border-radius: 15px;
	}
	.settlementAgreement {
		width: 100%;
		height: 100%;
		position: fixed;
		top: 0;
		left: 0;
		background: rgba(0, 0, 0, .5);
		z-index: 10;
	}
	.settlementAgreement .setAgCount {
		background: #fff;
		width: 656rpx;
		height: 458px;
		position: absolute;
		top: 50%;
		left: 50%;
		border-radius: 12rpx;
		-webkit-border-radius: 12rpx;
		padding: 52rpx;
		-webkit-transform: translate(-50%, -50%);
		-moz-transform: translate(-50%, -50%);
		transform: translate(-50%, -50%);
		overflow: hidden;
		.content {
			height: 900rpx;
			overflow-y: scroll;
			::v-deep p {
				font-size: 13px;
				line-height: 22px;
			}
			::v-deep img {
				max-width: 100%;
			}
		}
	}
	.settlementAgreement .setAgCount .icon {
		font-size: 24rpx;
		color: #b4b1b4;
		position: absolute;
		top: 15rpx;
		right: 15rpx;

	}
	.settlementAgreement .setAgCount .title {
		color: #333;
		font-size: 32rpx;
		text-align: center;
		font-weight: bold;
	}
	.settlementAgreement .setAgCount .content {
		margin-top: 32rpx;
		color: #333;
		font-size: 26rpx;
		line-height: 22px;
		text-align: justify;
		text-justify: distribute-all-lines;
		height: 756rpx;
		overflow-y: scroll;
	}
	.settledSuccessMain {
		height: 100vh;
		display: flex;
		flex-direction: column;
		background: #fff;
	}
	.settledSuccessful {
		flex: 1;
		width: 100%;
		padding: 0 56px;
		height: auto;
		background: #fff;
		text-align: center;
	}
	.settledSuccessful .image {
		width: 189px;
		height: 157px;
		margin-top: 66px;
	}
	.settledSuccessful .title {
		color: #333333;
		font-size: 16px;
		font-weight: bold;
		margin-top: 35px;
	}
	.settledSuccessful .info {
		color: #A0A0A0;
		font-size: 13px;
		margin-top: 12px;
	}
	.settledSuccessful .goHome {
		margin: 60px auto 0;
		line-height: 43px;
		color: #282828;
		font-size: 15px;
		border: 1px solid #B4B4B4;
		border-radius: 60px;
	}
	::v-deep uni-checkbox .uni-checkbox-input {
		width: 15px;
		height: 15px;
		position: relative;
	}
	::v-deep uni-checkbox .uni-checkbox-input.uni-checkbox-input-checked:before {
		font-size: 14px;
	}
	.loadingicon {
		height: 100vh;
		overflow: hidden;
		position: absolute;
		top: 0;
		left: 0;
	}
	.icon-xuanze {
		font-size: 22rpx;
	}
	// #ifdef MP
	checkbox-group {
		display: inline-block;
	}
	// #endif
	.setAgCount{
		::v-deep table{
			border:  1rpx solid #DDD;
			border-bottom: none;
			border-right: none;
		}
		::v-deep td, th {
		    padding: 5rpx 10rpx;
		    border-bottom: 1rpx solid #DDD;
			border-right:  1rpx solid #DDD;
		}
	}
	
</style>
