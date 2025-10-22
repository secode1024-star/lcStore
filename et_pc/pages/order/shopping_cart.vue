<template>
  <div class="shoppingCart">
    <div class="wrapper_1200">
      <div class="title wrapper_1200">
        <nuxt-link class="home" to="/">{{$t(`page.goodsDetail.home`)}} ></nuxt-link>
        {{$t(`page.goodsAddcart.navTitle`)}}
      </div>
      <div v-loading="loading">
        <div class="cartList" v-if="cartValid.length">
          <div class="body">
            <div v-for="(item, index) in cartValid" :key="index">
              <div class="store-info acea-row">
                <div class="storeAllSelect">
                  <div class="checkbox-wrapper">
                    <label class="well-check">
                      <input
                        type="checkbox"
                        name=""
                        value=""
                        :checked="item.checked"
                        @click="storeChecked(item,index)"
                      />
                      <i class="icon"></i>
                      <span class="checkAll">{{ item.merName }}</span>
                    </label>
                  </div>
                </div>
              </div>
              <div class="storeCartList">
                <div class="item acea-row row-middle" v-for="(itemn, indexn) in item.cartInfoList" :key="indexn">
                  <div class="allSelect acea-row row-center-wrapper">
                    <div class="checkbox-wrapper">
                    <label class="well-check">
                      <input
                        type="checkbox"
                        name=""
                        value=""
                        :checked="itemn.checked"
                        @click="switchSelect(index,indexn)"
                      />
                      <i class="icon"></i>
                    </label>
                  </div>
                  </div>
                  <div class="info acea-row row-middle"  @click="goDetail(itemn)">
                    <div class="pictrue">
                      <img v-if="itemn.image" :src='itemn.image'>
                    </div>
                    <div class="text">
                      <div class="name line2">{{ itemn.storeName }}</div>
                      <div class="infor" v-if="itemn.suk">{{$t(`page.goodsAddcart.attribute`)}}：{{ itemn.suk | filterEmpty }}</div>
                    </div>
                  </div>
                  <div class="price acea-row row-center-wrapper">{{GLOBAL.shopPayCurrency}}{{ itemn.price | filterEmpty }}</div>
                  <div class="num acea-row row-center-wrapper">
                    <div class="iconfont icon-shangpinshuliang-jian" :class="itemn.numSub?'greyCar':''"
                         @click.prevent="reduce(itemn)">-</div>
                    <input class="numCon" v-model="itemn.cartNum" type="number" @input="inputNum(itemn)"/>
                    <button :disabled="itemn.numAdd" class="iconfont icon-shangpinshuliang-jia"
                            :class="itemn.numAdd ?'greyCar':''" @click.prevent="plus(itemn)">+</button>
                  </div>
                  <div class="money acea-row row-center-wrapper font-color">
                    {{GLOBAL.shopPayCurrency}}{{ (itemn.price * itemn.cartNum).toFixed(2) }}
                  </div>
                  <div class="operate acea-row row-center-wrapper" @click="delgoods(itemn)"><span
                    class="iconfont icon-shanchu"></span></div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="cartList invalid" v-if="cartInvalid.length">
          <div class="body">
            <div class="store-info acea-row row-between">
              <div class="storeAllSelect cursor" @click='goodsOpen'>
                <label class="well-check cursor">
                    <span class='iconfont'
                          :class='goodsHidden==true?"icon-xiangxia":"icon-xiangshang"'></span>
                  {{$t(`page.goodsAddcart.failureGoods`)}}
                </label>
              </div>
              <div class='del' @click='unsetCart'><span class='iconfont icon-shanchu'></span></div>
            </div>
            <div v-show="goodsHidden">
              <div v-for="(itemn, index) in cartInvalid" :key="index">
                <div class="item acea-row row-middle row-between" v-for="(item, indexn) in itemn.cartInfoList" :key="indexn">
                  <div class="info acea-row row-center-wrapper">
                    <div class="pictrue">
                      <img :src="item.image">
                    </div>
                    <div class="text">
                      <div class="name line2 grey">{{ item.storeName }}</div>
                      <div class="infor" v-if="item.suk">{{$t(`page.goodsAddcart.attribute`)}}：{{ item.suk }}</div>
                    </div>
                  </div>
                  <div class="money acea-row row-center-wrapper font-color grey" >
                    {{$t(`page.goodsAddcart.failureGoods`)}}
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="footer acea-row row-between-wrapper" v-if="cartValid.length || cartInvalid.length">
          <div class="num">
            <div class="allSelect" @click="allChecked">
              <div class="checkbox-wrapper">
                <label class="well-check">
                  <input
                    type="checkbox"
                    name=""
                    value=""
                    :checked="isAllSelect"
                    @click="allChecked"
                  />
                  <i class="icon"></i>
                  <span class="checkAll">{{$t(`page.goodsAddcart.selectAll`)}}</span>
                </label>
              </div>
            </div>
             （{{ cartCount }}） </div>
          <div class="acea-row row-middle">
            <div class="total"><span class="font-color">{{GLOBAL.shopPayCurrency}}{{ countmoney }}</span></div>
            <div class="bnt bg-color" @click="subOrder">{{$t(`page.goodsAddcart.buyNow`)}}</div>
          </div>
        </div>
        <div class="noCart" v-if="isShow">
          <div class="pictrue"><img src="../../assets/images/noCart1.png"></div>
          <div class="tip">{{$t(`page.goodsAddcart.emptyCart`)}}</div>
          <nuxt-link to="/" class="goIndex">继续逛</nuxt-link>
        </div>
      </div>
    </div>
    <FloatWindow></FloatWindow>
  </div>
</template>

<script>
  // +----------------------------------------------------------------------
  // | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
  // +----------------------------------------------------------------------
  // | Copyright (c) 2016~2023 https://www.crmeb.com All rights reserved.
  // +----------------------------------------------------------------------
  // | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
  // +----------------------------------------------------------------------
  // | Author: CRMEB Team <admin@crmeb.com>
  // +----------------------------------------------------------------------
  import { Debounce } from '@/utils/validate.js'
  import { getPreOrder } from '@/utils/order.js';
  import { goShopDetail } from '@/utils/order.js';
  export default {
        name: "shopping_cart",
      auth: "guest",
      data() {
        return {
          cartValid: [],
          cartInvalid: [],
          isAllSelect: false,
          countmoney: 0,//购物车产品总价；
          cartNum: 0,
          cartCount: '',
          loading: false,
          isShow: false,
          goodsHidden: true
        }
      },
      head() {
        return {
          title: this.$t(`page.goodsAddcart.navTitle`)
        }
      },
      beforeMount() {
        if (!this.$auth.loggedIn) {
          this.$store.commit("isLogin", true);
          this.isShow = true;
        }else {
          this.getCartList();
          this.getCartInvalid();
        }
      },
      methods: {
        goDetail(item){
          goShopDetail(item.productId, this)
        },
        goodsOpen: Debounce(function() {
          let that = this;
          that.goodsHidden = !that.goodsHidden;
        }),
        unsetCart: Debounce(function() {
          let that = this,
            ids = [];
          that.cartInvalid.forEach((el, index) => {
            el.cartInfoList.forEach(e => {
              ids.push(e.id);
            })
          })
          that.$axios.post('/api/front/cart/delete', {ids: ids}).then(res => {
            that.$message.success(this.$t(`message.login.delSU`));
            that.$set(that, 'cartInvalid', []);
          })
        }),
        inputNum(item) {
          let that = this;
          item.cartNum = parseInt(item.cartNum) >= item.stock ? item.stock : item.cartNum;
          item.cartNum = parseInt(item.cartNum) <= 1 || isNaN(parseInt(item.cartNum)) ? 1 : item.cartNum;
          that.countMoney();
          let conNum = 0;
          that.cartValid.forEach(item => {
            item.cartInfoList.forEach(i => {
              conNum += parseInt(i.cartNum)
            });
          });
          that.cartInvalid.forEach(item => {
            item.cartInfoList.forEach(i => {
              conNum += parseInt(i.cartNum)
            });
          });
          that.$store.commit('cartNum', conNum);
          that.syncCartNum(item);
        },
        //立即下单；
        subOrder: function () {
          let that = this,
            list = that.cartValid,
            id = [];
          list.forEach(function (val) {
            val.cartInfoList.forEach(function (val) {
              if (val.checked === true) {
                id.push(val.id);
              }
            })
          });
          if (id.length === 0) {
            that.$message.error("请选择产品");
            return;
          }
          this.getPreOrder(id)
        //  this.$router.push({path: '/order/order_confirm?cartId=' + id.join(',')});
        },
        getPreOrder: function(id) {
          let shoppingCartId = id.map(item => {
            return {
              "shoppingCartId": Number(item)
            }
          })
          getPreOrder('shoppingCart', shoppingCartId, this);
        },
        //删除商品；
        delgoods: Debounce(function (item) {
          let that = this;
          let checkedIds = [];
          let index = checkedIds.indexOf(item.id);
          if(index>-1){
            checkedIds.splice(index, 1);
          }
          that.$axios.post('/api/front/cart/delete', {ids: [item.id]}).then(res => {
            that.$message.success(this.$t(`message.login.delSU`));
            that.gainCount();
            that.getCartList();
            that.countMoney();
          })
        }),
        // 购物车数量
        gainCount: function() {
          let that = this;
          that.$axios.get('/api/front/cart/count',{
            params: {
              numType: true,
              type: 'total'
            }
          }).then(res=>{
            that.$store.commit('cartNum', res.data.count || 0);
          });
        },
        getCartList() {
          let that = this;
          that.loading = true;
          that.$axios.get('/api/front/cart/list?isValid=true').then(res => {
            that.cartValid = res.data;
            let checked = [];
            that.cartValid.forEach(cart => {
              cart.cartInfoList.forEach(cartItem => {
                if (checked.length) {
                  cartItem.checked = checked.indexOf(cartItem.id) > -1;
                } else {
                  cartItem.checked = true;
                }
                if (cartItem.cartNum === 1) {
                  cartItem.numSub = true;
                } else {
                  cartItem.numSub = false;
                }
                if (cartItem.cartNum === cartItem.stock) {
                  cartItem.numAdd = true;
                } else {
                  cartItem.numAdd = false;
                }
              })
            });
            that.storeAllChceked();
            that.countMoney();
            that.loading = false;
            if(that.cartValid.length === 0) that.isShow = true;
          }).catch(error=>{
            that.loading = false
            if(that.cartValid.length === 0) that.isShow = true;
          });
        },
        getCartInvalid(){
          this.loading = true;
          this.$axios.get('/api/front/cart/list?isValid=false').then(res => {
            this.cartInvalid = res.data;
            this.loading = false;
            if(this.cartValid.length && this.cartInvalid.length === 0) this.isShow = true;
          }).catch(error=>{
            this.loading = false
            if(this.cartValid.length && this.cartInvalid.length === 0) this.isShow = true;
          });
        },
        //加
        plus: Debounce(function (goods, index) {
          let that = this;
          goods.cartNum++;
          if (goods.hasOwnProperty('productAttr') && goods.cartNum > goods.productAttr.stock) {
            goods.cartNum = goods.productAttr.stock;
            goods.numAdd = true;
            goods.numSub = false;
            return
          } else {
            goods.numAdd = false;
            goods.numSub = false;
          }
          that.countMoney();
          that.syncCartNum(goods);
        }),
        //减
        reduce: Debounce(function (goods) {
          let that = this;
          let status = false;
          if (goods.cartNum <= 1) {
            goods.cartNum = 1;
            goods.numSub = true;
            status = true;
          } else {
            goods.cartNum = Number(goods.cartNum) - 1
            this.cartTotalCount = Number(that.cartTotalCount) - 1;
            goods.numSub = false;
            goods.numAdd = false;
            if (goods.cartNum <= 1) {
              goods.numSub = true;
            }
            that.countMoney();
            that.syncCartNum(goods);
          }
        }),
        syncCartNum:Debounce(function(cart) {
          this.$axios.post('/api/front/cart/num', {
            id: cart.id,
            number: Math.max(cart.cartNum, 1) || 1
          }).then(res => {
          }).catch(err =>{
            cart.cartNum--;
            this.$message.error(err);
          })
        }),
        //单选
        switchSelect: function (index, indexn) {
          let that = this,
            cart = that.cartValid[index]['cartInfoList'][indexn];
          that.$set(cart, "checked", !cart.checked);
          that.$set(that, "cartValid", that.cartValid);
         // cart.checked = !cart.checked;
          let len = 0;
          let selectnum = [];
          for (let j = 0; j < that.cartValid.length; j++) {
            for (let k = 0; k < that.cartValid[j]['cartInfoList'].length; k++) {
              len++;
              if (that.cartValid[j]['cartInfoList'][k].checked === true) {
                selectnum.push(true);
              }
            }
          }
           that.isAllSelect = selectnum.length === len;
           that.$set(that, "cartValid", that.cartValid);
          that.cartValid = [...that.cartValid]

          that.storeAllChceked();
          that.$set(that, "isAllSelect", that.isAllSelect);
          that.countMoney();
        },
        /**判断单个店铺是不是全选 */
        storeAllChceked: function () {
          let selectnum, selectAllnum = [], checknum = 0;
          let that = this;
          for (let j = 0; j < that.cartValid.length; j++) {
            selectnum = [];
            for (let k = 0; k < that.cartValid[j]['cartInfoList'].length; k++) {
              checknum++;
              if (that.cartValid[j]['cartInfoList'][k].checked) {
                selectnum.push(true);
                selectAllnum.push(true);
              } else {
                selectnum.length - 1;
                selectAllnum.length - 1;
              }
              that.cartValid[j]['checked'] = selectnum.length === that.cartValid[j]['cartInfoList'].length;
              that.isAllSelect = selectAllnum.length === checknum;
              that.$set(that, "cartValid", that.cartValid);
              that.cartValid = [...that.cartValid]
            }
          }
        },
        //单个店铺商品全选
        storeChecked: function (item, index) {
          let that = this;
          item.checked = !item.checked;
          that.cartValid[index]['cartInfoList'].forEach(cart => {
            cart.checked = item.checked;
          });
          that.$set(that, "cartValid", that.cartValid);
          that.storeAllChceked();
          that.countMoney();
        },
        //全选
        allChecked: function () {
          let that = this;
          let selectAllStatus = that.isAllSelect;
          selectAllStatus = !selectAllStatus;
          that.cartValid.forEach(cart => {
            cart.checked = selectAllStatus;
            cart.cartInfoList.forEach(cartItem => {
              cartItem.checked = selectAllStatus;
            });
          });
          that.$set(that, "cartValid", that.cartValid);
          that.$set(that, "isAllSelect", selectAllStatus);
          that.countMoney();
        },
        //总共价钱；
        countMoney: function () {
          let that = this;
          let carmoney = 0, totalNum = 0;
          let array = that.cartValid;
          for (let i = 0; i < array.length; i++) {
            for (let j = 0; j < array[i]['cartInfoList'].length; j++) {
              if (array[i]['cartInfoList'][j].checked === true) {
                carmoney = this.comsys.Add(carmoney, this.comsys.Mul(array[i]['cartInfoList'][j].cartNum, array[i]['cartInfoList'][j]['price']));
                totalNum += Number(
                  array[i]['cartInfoList'][j].cartNum
                )
              }
            }
          }
          this.cartCount = totalNum
          that.countmoney = carmoney;
          this.countNum();
        },
        countNum() {
          let num = 0;
          let checkedList = []
          this.cartValid.forEach(item => {
            item.cartInfoList.forEach(cart => {
              if (cart.checked) {
                checkedList.push(cart.id);
                num++;
              }
            })
          })
          this.cartNum = num;
        }
      }
    }
</script>

<style scoped lang="scss">
  .cursor{
    cursor: pointer;
  }
  .icon-xiangshang, .icon-xiangxia{
    font-size: 14px !important;
  }
  .greyCar{
    color: #D0D0D0 !important;
    cursor: not-allowed;
  }
  .grey {
    color: #D0D0D0 !important;
  }
  .shoppingCart {
    cursor: pointer;
    background-color: #F9F9F9;
    .noCart {
      padding-bottom: 1px;
      text-align: center;
      .pictrue {
        width: 274px;
        height: 174px;
        margin: 111px auto 0 auto;
        img {
          width: 100%;
          height: 100%;
        }
      }
      .tip {
        font-size: 14px;
        color: #969696;
        margin-top: 20px;
      }
      .goIndex {
        width: 90px;
        height: 35px;
        border: 1px solid #282828;
        border-radius: 6px;
        text-align: center;
        line-height: 35px;
        font-size: 14px;
        color: #282828;
        margin: 24px auto 100px auto;
        display: block;
      }
    }
    .title {
      height: 59px;
      line-height: 59px;
      color: #999999;
      .home {
        color: #282828;
      }
    }
    .cartList {
      .header {
        height: 54px;
        background: #EEEEEE;
      }
      .allSelect {
        /*width: 90px;*/
        position: relative;
        .checkAll {
          margin-left: 30px;
        }
      }
      .info {
        /*width: 400px;*/
        padding-left: 60px;
      }
      .price {
        width: 195px;
      }
      .num {
        width: 150px;
      }
      .money {
        width: 230px;
      }
      .body {
        .storeCartList {
          background: #FFFBFB;
          box-shadow: 0px 2px 6px 0px rgba(170, 161, 161, 0.11);
          border-top: 1px solid #EFEFEF;
          padding: 0 30px;
          margin-bottom: 30px;
        }
        .item {
          & ~ .item {
            border-top: 1px dotted #E2E2E2;
          }
          height: 170px;
          .info {
            .pictrue {
              width: 90px;
              height: 90px;
              border-radius: 4px;
              margin-right: 20px;
              overflow: hidden;
              img {
                width: 100%;
                height: 100%;
              }
            }
            .text {
              width: 370px;
              color: #333;
              font-size: 14px;
              .infor {
                margin-top: 10px;
                font-size: 12px;
                color: #D0D0D0;
              }
            }
          }
          .price {
            font-size: 16px;
          }
          .num {
            .iconfont {
              width: 40px;
              height: 36px;
              line-height: 36px;
              border: 1px solid #D3D3D3;
              text-align: center;
              color: #707070;
              background-color: #fff;
            }
            .numCon {
              width: 54px;
              height: 36px;
              border: 0;
              border-top: 1px solid #D3D3D3;
              border-bottom: 1px solid #D3D3D3;
              font-size: 15px;
              color: #5A5A5A;
              text-align: center;
              line-height: 36px;
              outline: none;
            }
          }
          .money {
            font-size: 16px;
          }
          .operate {
            color: #D0D0D0;
            .iconfont {
              font-size: 20px;
            }
          }
        }
      }
      .iconfont {
        font-size: 20px;
      }
    }
    .store-info {
      line-height: 60px;
      height: 60px;
      background-color: #fff;
      padding: 0 30px;
      align-items: center;
      .checkbox-wrapper {
        padding-left: 28px;
      }
      .trader {
        display: inline-block;
        color: #fff;
        font-size: 12px;
        background-color: #E93323;
        width: 32px;
        height: 17px;
        line-height: 17px;
        text-align: center;
        border-radius: 2px;
        margin-left: 7px;
      }
    }
    .invalid {
      margin-top: 20px;
      background-color: #fff;
      .store-info{
        border-bottom: 1px solid #EFEFEF;
      }
    }
    .footer {
      width: 1200px;
      height: 82px;
      background: #FFFFFF;
      box-shadow: 0px -2px 6px 0px rgba(0, 0, 0, 0.05);
      margin-top: 60px;
      padding-left: 30px;
      position: fixed;
      bottom: 0;
      .allSelect {
        width: 100px;
        position: relative;
        display: inline-block;
        .checkAll {
          margin-left: 30px;
        }
      }
      .total {
        font-size: 16px;
        .font-color {
          font-size: 22px;
          font-weight: bold;
        }
      }
      .bnt {
        width: 160px;
        height: 82px;
        text-align: center;
        line-height: 82px;
        font-size: 18px;
        color: #fff;
        margin-left: 30px;
      }
    }
  }
</style>
