<template>
	<view class='recommend'>
		<view class='title acea-row row-center-wrapper'>
			<text class='iconfont icon-zhuangshixian'></text>
			<text class='name'>{{$t(`page.goodsSearch.recommend`)}}</text>
			<text class='iconfont icon-zhuangshixian lefticon'></text>
		</view>
		<view class='recommendList acea-row row-between-wrapper'>
			<WaterfallsFlow :wfList='tempArr' :type="1" :isStore="1" :shopPayCurrency="shopPayCurrency" />
		</view>
		<view class='loadingicon acea-row row-center-wrapper' :hidden='loading==false'>
			<text class='loading iconfont icon-jiazai'></text>
		</view>
		<view v-if="goodScroll" class="text-center pb-20">
			<text>{{$t(`page.goodsList.no`)}}</text>
		</view>
	</view>
</template>

<script>
	import {
		mapGetters
	} from "vuex";
	import {
		goShopDetail
	} from '@/libs/order.js'
	import {
		getGroomList
	} from '@/api/store.js'
	import WaterfallsFlow from '@/components/WaterfallsFlow/WaterfallsFlow.vue'
	let app = getApp();
	export default {
		computed: mapGetters(['uid']),
		name: 'recommend',
		components: {
			WaterfallsFlow
		},
		props: {
			//币种
			shopPayCurrency: {
				type: String,
				require: '$'
			}
		},
		data() {
			return {
				goodScroll: false,
				params: { //精品推荐分页
					page: 1,
					limit: 10,
				},
				loading: false,
				tempArr: []
			};
		},
		mounted() {
			this.params.page = 1;
			this.goodScroll = false;
			this.tempArr = [];
			this.get_host_product();
		},

		methods: {
			get_host_product: function() {
				if (this.goodScroll) return
				this.loading = true
				getGroomList(this.params).then(({
					data
				}) => {
					this.$set(this.params, 'page', this.params.page + 1);
					this.goodScroll = this.params.page > data.pages;
					this.tempArr = this.tempArr.concat(data.list || []);
					this.loading = false
				})
			}
		},
		onReachBottom() {
			this.get_host_product();
		}
	}
</script>

<style scoped lang="scss">
	.recommend {
		background-color: #fff;
	}

	.recommend .title {
		height: 135rpx;
		line-height: 135rpx;
		font-size: 28rpx;
		color: #282828;
	}

	.recommend .title .name {
		margin: 0 28rpx;
	}

	.recommend .title .iconfont {
		font-size: 170rpx;
		color: #454545;
	}

	.recommend .title .iconfont.lefticon {
		transform: rotate(180deg);
	}

	.recommend .recommendList {
		padding-left: 30rpx;
	}

	.recommend .recommendList .item {
		width: 335rpx;
		margin-bottom: 30rpx;
	}

	.recommend .recommendList .item .pictrue {
		position: relative;
		width: 100%;
		height: 335rpx;
	}

	.recommend .recommendList .item .pictrue image {
		width: 100%;
		height: 100%;
		border-radius: 14rpx;
	}

	.recommend .recommendList .item .name {
		font-size: 28rpx;
		color: #282828;
		margin-top: 20rpx;
	}

	.money {
		font-size: 20rpx;
		margin-top: 8rpx;
		font-weight: 600;
		@include price_color(theme);
	}

	.recommend .recommendList .item .money .num {
		font-size: 28rpx;
		@include price_color(theme);
	}
</style>