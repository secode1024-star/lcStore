<template>
    <div class="wrapper">
        <div class="store_item" v-for="item in storeList" :key="item.id">
            <div class="head" @click="gopage(item)">
                <div class="left_wrapper">
                    <div class="logo">
                        <el-image class="img" :src="item.avatar">
                            <div slot="placeholder" class="image-slot">
                                loading<span class="dot">...</span>
                            </div>
                        </el-image>
                    </div>
                    <div class="con_box">
                        <div class="title">
                            {{item.name}}
                        </div>
                        <div class="start_box">
                            <el-rate 
                            v-model="item.starLevel" 
                            disabled
                            :colors="colors"
                            text-color="#E93323"
                            
                            ></el-rate>
                        </div>
                    </div>
                </div>
                <div class="right_wrapper">
                    <span class="iconfont icon-shangjiadingdan"></span>
                    <span class="name">{{$t(`page.goodsSearch.mer`)}}</span>                    
                </div>
            </div>
            <div class="pic_wrapper">
                <div class="proList" @click="goDetail(items)" v-for="items in item.proList" :key="items.id">
                    <div class="pic_item">
                        <el-image class="img" :src="items.image">
                            <div slot="placeholder" class="image-slot">
                                loading<span class="dot">...</span>
                            </div>
                        </el-image>
                    </div>
                    <div class="title lines1">
                        {{items.storeName}}
                    </div>
                    <div class="price">
                      {{GLOBAL.shopPayCurrency}}{{items.price}}
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
import { goShopDetail, goMerchant } from '@/utils/order.js';
export default {
  name: "store",
    props: {
        storeList:{
            type: Array,
            default: function() {
                return [];
            }
        }
    },
    data() {
        return {
            colors: ['#99A9BF','#E93323','#E93323']
        }
        
    },
  methods: {
    gopage(item) {
      goMerchant(item.id, this);
    },
    goDetail(items){
        goShopDetail(items.id, this);
    },
  }
};
</script>
<style lang="scss" scoped>
    .wrapper {
        display: flex;
        flex-wrap: wrap;
        // justify-content: space-between;
        justify-content: flex-start;

        .store_item:nth-child(odd) {
            margin-right: 36px;
        }
        .store_item {
            width: 582px;
            height: 360px;
            padding: 20px;
            display: inline-block;
            margin-bottom: 36px;
            border: 1px solid #DDDDDD;
            background: url('../assets/images/storelist.png') no-repeat;
            background-size: 100%;
            // margin-right: 15px;

            .head {
                margin-bottom: 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                cursor: pointer;

                .left_wrapper {
                    display: flex;

                    .logo {
                        .img {
                            width: 61px;
                            height: 61px;
                            border-radius: 50%;
                            margin-right: 20px;
                        }
                    }
                    .con_box {
                        // display: flex;
                        .title {
                            margin: 12px 0 10px 0;
                        }
                    }
                }

                .right_wrapper {
                    background: #FFFFFF;
                    border-radius: 15px;
                    border: 1px solid #E93323;
                    display: flex;
                    justify-content: space-around;
                    align-items: center;
                    padding: 6px 14px;

                    .name {
                        margin-left: 2px;
                    }

                    i {
                        margin-right: 6px;
                    }

                    span {
                        font-size: 12px;
                        font-family: ArialMT;
                        color: #E93323;
                    }
                }
            }

            .pic_wrapper {
                display: flex;
                justify-content: flex-start;

                .proList {
                    width: 174px;
                    margin-right: 10px;
                    cursor: pointer;

                    .pic_item {
                        width: 174px;
                        height: 174px;

                        .img {
                            width: 100%;
                            height: 100%;
                            border: 1px solid #DDDDDD;
                        }
                    }

                    .title {
                        margin: 10px 0;
                        font-size: 16px;
                        font-family: ArialMT;
                        color: #333333;
                        line-height: 22px;
                    }

                    .lines1 {
                        overflow: hidden;
                        text-overflow: ellipsis;
                        display: -webkit-box; 
                        -webkit-line-clamp: 1; 
                        -webkit-box-orient: vertical;
                    }

                    .price {
                        font-size: 18px;
                        font-family: DINCond-Black, DINCond;
                        font-weight: 900;
                        color: #E93323;
                        line-height: 18px;
                        text-align: center;
                    }
                }
            }
        }
    }
</style>

