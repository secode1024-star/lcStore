<template>
  <div>
    <div class="header">
      <span class="home"><nuxt-link class="home" to="/">{{$t(`userDrawer.data[0].name`)}}  </nuxt-link> > 个人中心 > 我的订单 ></span>申请退款
    </div>
    <div class="refund">
      <order-goods :cartInfo="orderInfo.orderInfoList"></order-goods>
      <div class="lines"></div>
      <client-only>
        <el-form ref="form" :model="form" label-width="100px" :rules="rules" label-position="right">
          <div class="cont">
            <el-form-item :label="$t(`page.users.goodsReturn.number`)+ '：'">
              <el-input :disabled="true" v-model="orderInfo.totalNum" class="lang"></el-input>
            </el-form-item>
            <el-form-item :label="$t(`page.users.goodsReturn.price`)+ '：'">
              <el-input :disabled="true" v-model="orderInfo.payPrice" class="lang"></el-input>
            </el-form-item>
            <el-form-item :label="$t(`page.users.goodsReturn.reason`)+ '：'" class="item-border" prop="text">
              <el-select v-model="form.text" :placeholder="$t(`page.users.goodsReturn.reason`)" class="lang">
                <el-option
                  :label="item"
                  :value="item"
                  v-for="(item, index) in refundArray"
                  :key="index"
                ></el-option>
              </el-select>
            </el-form-item>
            <el-form-item :label="$t(`page.users.goodsReturn.info`)+ '：'">
              <el-input
                type="textarea"
                :placeholder="$t(`page.users.goodsReturn.place`)"
                :autosize="{ minRows: 4 }"
                maxlength="100"
                v-model="form.refund_reason_wap_explain"
              ></el-input>
            </el-form-item>
            <el-form-item :label="$t(`page.users.goodsReturn.upload`)+ '：'">
              <div class="img-box-wrapper">
                <upload-from @picList="picList"></upload-from>
              </div>
              <div class="tip">
                {{$t(`message.tips.picTips`)}}
              </div>
            </el-form-item>
            <div class="lines" style="margin-top: 18px"></div>
          </div>
          <el-form-item>
            <el-button type="primary" :disabled="isDialog" @click="onSubmit('form')">{{$t(`page.users.goodsReturn.submit`)}}</el-button>
          </el-form-item>
        </el-form>
      </client-only>
    </div>

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
  import orderGoods from "@/components/orderGoods";
  import { Debounce } from '@/utils/validate.js'
  import uploadFrom from "@/components/upload";
    export default {
      name: "refund_confirm",
      data() {
          return {
            form: {
              text: "",
              refund_reason_wap_explain: "",
              refund_reason_wap_img: '',
              orderNo: ''
            },
            upLoadUrl: process.env.BASE_URL + "/api/front/upload/image",
            myHeaders: {},
            pics: [],
            rules: {
              text: [
                { required: true, message: this.$t(`page.users.goodsReturn.reason`), trigger: 'change' }
              ]
            },
            isDialog: false
          }
      },
      components: { orderGoods, uploadFrom },
      async asyncData({ app, query }) {
        let [refundInfo, refundArray] = await Promise.all([
          app.$axios.get(`/api/front/order/apply/refund/${query.orderNo}`),
          app.$axios.get('/api/front/order/refund/reason')
        ]);
        return {
          orderInfo: refundInfo.data,
          refundArray: refundArray.data,
          orderNo: query.orderNo
        }
      },
      head() {
        return {
          title: this.$t(`page.orderDetails.refund`)
        }
      },
      methods: {
        picList(item){
          this.pics = item
        },
        onSubmit: Debounce(function (formName) {
          let that = this;
          that.form.refund_reason_wap_img = that.pics.join(',')
          that.form.orderNo = that.orderNo
          that.$refs[formName].validate((valid) => {
            if (valid) {
              that.$axios
                .post("/api/front/order/refund", that.form)
                .then(res => {
                  that.isDialog = true;
                  that.$message.success(that.$t(`message.login.operationSU`));
                  that.$router.push({ path: '/users/refund_list?menuCur=222' });
                })
            } else {
              return false;
            }
          })
          }
        ),
      }
  }
</script>

<style lang="scss" scoped>
  .lang{
    width: 400px;
  }
  .header {
    height: 60px;
    line-height: 60px;
    color: #999999;
    .home {
      color: #282828;
    }
  }
  .lines{
    border: 1px dashed #e1e1e1;
  }
  .refund {
    background: #ffffff;
  }
  .el-form {
    .cont {
      padding: 30px;
    }
    .item-price{
      ::v-deep input{
        padding-right: 0;
      }
    }
    .item-desc{
      color: #B5B5B5;
    }
    .item-border{
    //  padding-bottom: 25px;
    }
    > .el-form-item {
      margin-top: 10px;
      margin-bottom: 0;
      padding-bottom: 30px;
      padding-right: 30px;
      text-align: right;
    }
    .el-textarea {
      width: 820px;
    }
    ::v-deep.el-form-item__label{
      font-size: 14px;
      color: #666666;
    }
    ::v-deep.el-textarea__inner {
      border: none;
      background: #f7f7f7;
    }
    ::v-deep.el-upload--picture-card {
      width: 100px;
      height: 100px;
      border-style: solid;
      line-height: 100px;
    }
    ::v-deep.el-upload-list--picture-card .el-upload-list__item {
      width: 100px;
      height: 100px;
    }
  }
</style>
