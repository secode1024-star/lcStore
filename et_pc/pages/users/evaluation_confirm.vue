<template>
  <div class="evaluation wrapper_1200">
    <div class="header wrapper_1200">
      <span class="home"><nuxt-link class="home" to="/">{{$t(`userDrawer.data[0].name`)}}  </nuxt-link> > 个人中心 > 我的订单 ></span>{{$t(`page.users.goodsCommentCon.navTitle`)}}
    </div>
    <div class="refund wrapper_1200">
      <order-goods :cartInfo="cartInfo"></order-goods>
      <div class="lines mt30"></div>
    </div>
    <client-only>
      <el-form ref="form" :model="form" label-width="100px" :rules="rules">
        <div class="cont">
          <el-form-item :label="$t(`page.users.goodsCommentCon.score[0].name`)+'：'" class="fontSize" prop="star">
            <el-rate v-model="form.star" show-text> </el-rate>
          </el-form-item>
          <el-form-item :label="$t(`page.users.goodsCommentCon.navTitle`)+'：'" class="fontSize" prop="comment">
            <el-input
              type="textarea"
              :placeholder="$t(`page.users.goodsCommentCon.place`)"
              :autosize="{ minRows: 4 }"
              maxlength="100"
              v-model="form.comment"
            ></el-input>
          </el-form-item>
          <el-form-item :label="$t(`page.users.goodsCommentCon.upload`)+'：'" class="fontSize">
            <div class="img-box-wrapper">
              <upload-from @picList="picList"></upload-from>
            </div>
            <div class="tip">
              每张图片大小不超过5M，支持jpg,png,jpeg格式文件
            </div>
          </el-form-item>
        </div>
        <div class="lines"></div>
        <el-form-item>
          <el-button type="primary" @click="onSubmit('form')" :loading="isLoading">立即评价</el-button>
        </el-form-item>
      </el-form>
      <!-- 弹窗 -->
      <el-dialog
        :show-close="false"
        :visible.sync="isDialog"
        width="370px">
        <div class="refund-box acea-row row-column row-middle">
          <div class="pic">
            <img src="~assets/images/evaluation.png" alt="" />
          </div>
          <div class="status font-color">{{$t(`page.users.goodsCommentCon.SU`)}}</div>
          <div class="tips">{{$t(`page.users.goodsCommentCon.tipsSU`)}}</div>
          <el-button type="primary" @click="subBtn">{{$t(`page.goodsDetail.confirm`)}}</el-button>
        </div>
      </el-dialog>
    </client-only>
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
        name: "evaluation_confirm",
      data(){
          return {
            rules: {
              star: [
                { required: true, message: this.$t(`page.users.goodsCommentCon.score[0].name`), trigger: 'change' }
              ],
              comment: [
                { required: true, message: this.$t(`page.users.goodsCommentCon.place`), trigger: 'change' }
              ]
            },
            cartInfo: [this.$store.state.evaluationInfo],
            form: {
              comment: '',
              orderInfoId: this.$store.state.evaluationInfo.id,
              orderNo: this.$store.state.evaluationInfo.merOrderNo,
              pics: '',
              star: 0
            },
            isLoading: false,
            isDialog: false
          }
      },
      components: { orderGoods, uploadFrom },
      methods: {
        picList(item){
          this.pics = item
        },
        onSubmit: Debounce(function (formName) {
            let that = this;
            that.isLoading = true;
            that.form.pics = that.pics.length>0?JSON.stringify(that.pics):'';
            that.$refs[formName].validate((valid) => {
              if (valid) {
                that.$axios
                  .post("/api/front/order/comment", that.form)
                  .then(res => {
                    that.isDialog = true;
                    that.isLoading = false;
                  }).catch(error => {
                  that.isLoading = false;
                });
              } else {
                return false;
              }
            })
          }
        ),
        subBtn() {
          this.isDialog = false;
          this.$router.go(-1);
        }
      }
    }
</script>

<style lang="scss" scoped>
  .status{
    font-size: 20px;
    font-weight: bold;
  }
  .tips{
    font-size: 16px;
    color: #999999;
    margin: 24px 0;
  }
  .pic{
    width: 165px;
    height: 165px;
    margin-bottom: 30px;
    img{
      width: 100%;
      height: 100%;
    }
  }
  .wrapper_1200{
    margin: 0 auto !important;
  }
  .evaluation {
    background: #ffffff;
    ::v-deep.cartInfo{
      padding: 0;
    }
    ::v-deep.cartCount{
      margin-bottom: 0;
    }
    .fontSize {
      ::v-deep.el-form-item__label {
        font-size: 14px;
        color: #666666;
      }
      .tip {
        font-size: 12px;
        color: #969696;
      }
    }

    .goods {
      width: 450px;

      .item {
        padding: 36px 14px;
      }

      .image {
        width: 70px;
        height: 70px;
        overflow: hidden;

        img {
          display: block;
          width: 100%;
          height: 100%;
        }
      }

      .text {
        flex: 1;
        margin-left: 20px;
        font-size: 14px;
        color: #282828;

        div {
          &:first-child {
            display: -webkit-box;
            -webkit-box-orient: vertical;
            -webkit-line-clamp: 2;
            margin-bottom: 13px;
            overflow: hidden;
          }

          span {
            margin-left: 10px;
            font-size: 12px;
            color: #b1b1b1;
          }
        }
      }
    }

    .el-form {
      .cont {
        padding: 40px 30px 16px 30px;

        > .el-form-item {
          margin-bottom: 24px;
        }
      }

      .el-rate {
        display: inline-block;
        vertical-align: middle;
      }

      > .el-form-item {
        margin-top: 30px;
        margin-bottom: 0;
        padding-bottom: 30px;
        padding-right: 30px;
        text-align: right;
      }

      .rate-group {
        padding-bottom: 21px;

        .group-hd {
          width: 80px;
          text-align: center;
          margin-bottom: 10px;
          font-size: 16px;
        }

        .el-form-item {
          margin-left: 20px;
          margin-bottom: 0;
          ::v-deep.el-form-item__label {
            line-height: 30px;
          }
          ::v-deep.el-form-item__content {
            line-height: 30px;
          }
        }
      }

      .el-textarea {
        width: 820px;
      }

      ::v-deep.el-textarea__inner {
        border: none;
        background-color: #f7f7f7;
      }

      ::v-deep.el-upload-list__item.is-success .el-upload-list__item-status-label {
        display: none;
      }
    }
  }
  .lang{
    width: 400px;
  }
  .header {
    height: 60px;
    line-height: 60px;
    padding: 0 30px;
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
    padding: 0 30px;
  }
</style>
