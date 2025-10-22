<template>
	<view :data-theme="theme">
		<uniNavBar background-color="#fff" color="#333" :title="$t(`page.users.goodsCommentCon.navTitle`)" :border='false' @clickLeft='returns' @clickRight="open">
			<view slot="left" class="iconfont icon-dingbufanhui"></view>
			<view slot="right" class="iconfont icon-more"></view>
		</uniNavBar>
		<form @submit="formSubmit" report-submit='true'>
			<view class='evaluate-con pad30'>
				<view class='score borRadius14'>
					<view class='item acea-row row-middle' v-for="(item,indexw) in scoreList" :key="indexw">
						<view>{{$t(`page.users.goodsCommentCon.score[${indexw}].name`)}}</view>
						<view class='starsList'>
							<text @click="stars(indexn, indexw)" v-for="(itemn, indexn) in item.stars" :key="indexn" class='iconfont' :class="item.index >= indexn? 'icon-pingfen':'icon-pingweifen'"></text>
						</view>
						<text class='evaluate'>{{item.index === -1 ? "" : item.index + 1 + "分"}}</text>
					</view>
					<view class='textarea'>
						<textarea :placeholder='$t(`page.users.goodsCommentCon.place`)' name="comment" placeholder-class='placeholder'></textarea>
						<view class='list acea-row row-middle'>
							<view class='pictrue' v-for="(item,index) in picsPath" :key="index">
								<image :src='item'></image>
								<text class='iconfont icon-zhifushibai' @click='DelPic(index)'></text>
							</view>
							<view class='pictrue acea-row row-center-wrapper row-column' @click='uploadpic' v-if="picsPath.length < 8">
								<text class='iconfont icon-icon25201'></text>
								<view>{{$t(`page.users.goodsCommentCon.upload`)}}</view>
							</view>
						</view>
					</view>
					<button class='evaluateBnt bg_color' formType="submit">{{$t(`page.users.goodsCommentCon.submit`)}}</button>
				</view>
			</view>
		</form>
		<tui-drawer mode="right" :visible="rightDrawer" @close="closeDrawer">
			<user-drawer @close="closeDrawer"></user-drawer>
		</tui-drawer>
	</view>
</template>

<script>
	import {
		orderComment
	} from '@/api/order.js';
	import {toLogin} from '@/libs/login.js';
	import {mapGetters} from "vuex";
	import {Debounce} from '@/utils/validate.js'
	let app = getApp();
	export default {
		data() {
			return {
				pics: [],
				picsPath: [],
				scoreList: [{
						name: "商品星级",
						stars: ["", "", "", "", ""],
						index: -1
					},
				],
				orderNo: 0, //产品id
				evaluateId: 0, //评价id
				unique: '',
				productInfo: {storeName:'',sku:'',truePrice:'',cartNum:'',image:''},
				cart_num: 0,
				isAuto: false, //没有授权的不会自动授权
				isShowAuth: false, //是否隐藏授权
				id: 0 ,//订单id
				theme:app.globalData.theme,
				rightDrawer: false
			};
		},
		computed: mapGetters(['isLogin']),
		onLoad(options) {
			uni.setNavigationBarTitle({
				title: this.$t(`page.users.goodsCommentCon.navTitle`)
			})
			if (!options.orderNo ) return this.$util.Tips({
				title: this.$t('message.pay.errorOrder')
			}, {
				tab: 3,
				url: 1
			});
			this.orderNo = options.orderNo || 0;
			this.evaluateId = Number(options.id) || 0;
			if (!this.isLogin) {
				toLogin();
			}
		},
		methods: {
			open(){
				this.rightDrawer = true
			},
			closeDrawer(e) {
				this.rightDrawer = false
				if(!e){
					this.rightDrawer = false
				}
			},
			stars: function(indexn, indexw) {
				this.scoreList[indexw].index = indexn;
			},
			/**
			 * 删除图片
			 * 
			 */
			DelPic: function(index) {
				let that = this,
					pic = this.picsPath[index];
				that.picsPath.splice(index, 1);
				that.pics.splice(index, 1);
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
					model: "product",
					pid: 1
				}, function(res) {
					that.pics.push(res.data.url);
					that.picsPath.push(res.data.localPath);
					that.$set(that, 'pics', that.pics);
					that.$set(that, 'picsPath', that.picsPath);
				});
			},

			/**
			 * 立即评价
			 */
			formSubmit: Debounce(function(e) {
				let formId = e.detail.formId,
					value = e.detail.value,
					that = this,
					product_score = that.scoreList[0].index + 1 === 0 ? "" : that.scoreList[0].index + 1;
				if (!value.comment) return that.$util.Tips({
					title: this.$t(`page.users.goodsCommentCon.tipsWrite`)
				});
				value.star = product_score;
				value.pics = that.pics.length>0?JSON.stringify(that.pics):'';
				value.orderInfoId = that.evaluateId;
				value.orderNo = that.orderNo;
				uni.showLoading({
					title: this.$t(`message.tips.loding`)
				});
				orderComment(value).then(res => {
					uni.hideLoading();
					return that.$util.Tips({
						title: this.$t(`page.users.goodsCommentCon.tips`),
						icon: 'success'
					}, '/pages/order_details/index?order_id=' + that.orderNo);
				}).catch(err => {
					uni.hideLoading();
					return that.$util.Tips({
						title: err
					});
				});
			}),
			returns(){
				uni.navigateBack()
			}
		}
	}
</script>

<style lang="scss" scoped>
	.goodsStyle .text .name, .attr{
		//width: 496rpx;
	}
	.font_sm{
		font-size: 24rpx;
		color: #999;
		padding-top: 10rpx;
	}
	.icon-pingfen{
		@include main_color(theme);
	}
	.evaluate-con .score {
		background-color: #fff;
		// border-top: 1rpx solid #f5f5f5;
		margin-top: 20rpx;
		font-size: 28rpx;
		color: #282828;
		padding: 46rpx 24rpx;
	}

	.evaluate-con .score .item~.item {
		margin-top: 36rpx;
	}

	.evaluate-con .score .item .starsList {
		padding: 0 35rpx 0 40rpx;
	}

	.evaluate-con .score .item .starsList .iconfont {
		font-size: 40rpx;
		color: #aaa;
	}

	.evaluate-con .score .item .starsList .iconfont~.iconfont {
		margin-left: 20rpx;
	}

	.evaluate-con .score .item .evaluate {
		color: #aaa;
		font-size: 24rpx;
	}

	.evaluate-con .score .textarea {
		width: 100%;
		background-color: #F5F5F5;
		border-radius: 14rpx;
		margin-top: 55rpx;
	}

	.evaluate-con .score .textarea textarea {
		font-size: 28rpx;
		padding: 38rpx 30rpx 0 30rpx;
		width: 100%;
		box-sizing: border-box;
		height: 160rpx;
		width: auto !important;
	}

	.evaluate-con .score .textarea .placeholder {
		color: #bbb;
	}

	.evaluate-con .score .textarea .list {
		margin-top: 25rpx;
		padding-left: 5rpx;
	}

	.evaluate-con .score .textarea .list .pictrue {
		width: 140rpx;
		height: 140rpx;
		margin: 0 0 35rpx 25rpx;
		position: relative;
		font-size: 22rpx;
		color: #bbb;
		border-radius: 14rpx;
	}

	.evaluate-con .score .textarea .list .pictrue:nth-last-child(1) {
		border: 1rpx solid #ddd;
		box-sizing: border-box;
	}

	.evaluate-con .score .textarea .list .pictrue image {
		width: 100%;
		height: 100%;
		border-radius: 14rpx;
	}

	.evaluate-con .score .textarea .list .pictrue .icon-zhifushibai {
		font-size: 35rpx;
		position: absolute;
		top: -20rpx;
		right: -20rpx;
	}

	.evaluate-con .score .textarea .list .pictrue .icon-icon25201 {
		color: #bfbfbf;
		font-size: 50rpx;
	}

	.evaluate-con .score .evaluateBnt {
		font-size: 30rpx;
		color: #fff;
		width: 100%;
		height: 86rpx;
		border-radius: 43rpx;
		text-align: center;
		line-height: 86rpx;
		margin-top: 45rpx;
	}
	.bg_color{
		@include main_bg_color(theme);
	}
</style>
