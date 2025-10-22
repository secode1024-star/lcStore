<template>
  <div class="user-index">
    <div class="user-content">
      <div class="item user-info">
        <div class="info acea-row">
          <div class="title">
            {{$t(`page.store.title1`)}}
          </div>
        </div>
      </div>
      <el-form style="margin-left: 109px" label-position="right" label-width="180px" :model="merchantData">
        <el-form-item :label="$t(`page.store.storeName`)" required>
          <el-input :placeholder="$t(`page.store.storeName`)" v-model="merchantData.name"></el-input>
        </el-form-item>
        <el-form-item :label="$t(`page.store.userName`)" required>
          <el-input :placeholder="$t(`page.store.userName`)" v-model="merchantData.realName"></el-input>
        </el-form-item>
        <el-form-item :label="$t(`page.store.phone`)" required>
          <div class="acea-row">
            <country-code-selector @countryInfo="countryInfo"  :countryCode.sync="countryCode"></country-code-selector>
            <el-input :placeholder="$t(`page.store.phone`)" v-model="merchantData.phone" class="country_input"></el-input>
          </div>
        </el-form-item>
        <el-form-item :label="$t(`page.store.emil`)" required>
          <el-input :placeholder="$t(`page.store.emil`)" v-model="merchantData.email"></el-input>
        </el-form-item>
        <el-form-item :label="$t(`page.store.code`)" required>
          <el-input style="width:268px" :placeholder="$t(`page.store.code`)" v-model="merchantData.captcha">
          </el-input>
          <div class="btn">
            <el-button type="danger" class="code-box" :class="disabled === true ? 'on' : ''" @click="registerCode" :disabled="disabled">{{text}}</el-button>
          </div>
        </el-form-item>
        <el-form-item :label="$t(`page.store.class`)" required>
          <el-select style="width:400px" v-model="merchantData.categoryId" @change="onSelectedDrug($event)"  :placeholder="$t(`page.store.class`)">
            <el-option
              v-for="item in classOptions"
              :key="item.id"
              :label="item.name"
              :value="item.id">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item :label="$t(`page.store.type`)" required>
          <el-select style="width:400px"  v-model="merchantData.typeId" :placeholder="$t(`page.store.type`)" @change="onSelectedType($event)">
            <el-option
              v-for="item in typeOptions"
              :key="item.id"
              :label="item.name"
              :value="item.id">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item :label="$t(`page.store.keyword`)" required>
          <el-input :placeholder="$t(`page.store.keyword`)" v-model="merchantData.keywords"></el-input>
        </el-form-item>
        <el-form-item :label="$t(`page.users.userAddress.country`)" required>
          <div class="acea-row">
            <country-code-selector @countryInfo="countryInfo"  :countryCode.sync="countryCode"></country-code-selector>
            <el-input :placeholder="$t(`page.users.userAddress.country`)" v-model="merchantData.country" class="country_input"></el-input>
          </div>
        </el-form-item>
        <el-form-item :label="$t(`page.users.userAddress.address`)" required>
          <el-input :placeholder="$t(`page.users.userAddress.address`)" v-model="merchantData.address"></el-input>
        </el-form-item>
        <el-form-item required="" :label="$t(`page.users.goodsCommentCon.upload`)">
          <span class="place1">{{$t(`page.store.place1`)}}</span>
          <!--店铺类型说明-->
          <span v-show="merchantTypeInfo" class="place1">({{merchantTypeInfo}})</span>
          <span class="place2">{{$t(`page.store.place2`)}}</span>
          <upload-from style="width:550px" @picList="picList" v-if="!focusUpdate" :limitNum="maxlength" :maxlength="maxlength"></upload-from>
        </el-form-item>
        <el-form-item>
            <div class="checkbox-wrapper item_protocol mt15">
            <label class="well-check">
              <input
                type="checkbox"
                name=""
                value=""
                :checked="isAgree"
                @click="isAgree = !isAgree"
              />
              <i class="icon mr50"></i>
              <span style="margin-left: 30px">{{$t(`page.store.agree`)}}</span>
            </label>
            <el-button type="text" @click="dialogVisible = true">《{{$t(`page.store.agreement`)}}》</el-button>
          </div>
        </el-form-item>
      </el-form>
      <el-dialog
        :title="$t(`page.store.agreement2`)"
        :visible.sync="dialogVisible"
        width="900px"
        center>
        <div class="agreement" v-html="agreementInfo.agreement"></div>
        <span slot="footer" class="dialog-footer">
          <el-button type="primary" @click="dialogVisible = false">{{$t(`page.goodsDetail.confirm`)}}</el-button>
        </span>
      </el-dialog>
      <div class="out-btn">
        <span @click="submitForm">{{$t(`page.store.submit`)}}</span>
      </div>
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
  import sendVerifyCode from "@/mixins/SendVerifyCode";
  import {Message, MessageBox } from 'element-ui';
  import uploadFrom from "@/components/upload";
  import axios from 'axios'
  import { Debounce } from '@/utils/validate.js'
  import CountryCodeSelector from "~/components/countryCodeSelector.vue";
  export default {
    name: "user_info",
    auth: "guest",
    mixins: [sendVerifyCode],
    components: {CountryCodeSelector, uploadFrom},
    data(){
      return {
        dialogVisible: false,
        isShow: false,
        userInfo:{},
        isShowCode: false,
        avatar: '',
        nickname: '',
        isAgree: false,
        disabled: false,
        showProtocol: false,
        merchantData: {
					name: "",
					realName: "",
					phone: "",
					captcha: '',
					address: '',
					categoryId: '',
					email: '',
					handlingFee: '', //手续费
					keywords: '',
					qualificationPicture: [],
					typeId: '',
          country:""
        },
        agreementInfo: '',
        validate: '',
        captcha: "",
        classOptions: [],
        typeOptions: [],
        countryCode: 86,
        focusUpdate: false,
        merchantTypeInfo: '', //店铺类型说明
        maxlength: 10 //上传最大值限制
      }
    },
    head() {
      return {
        title: this.$t(`page.users.userInfo.navTitle`)
      }
    },
    beforeMount(){
    },
    mounted() {
      this.resetFormDate();
      let local = this.$cookies.get('auth.strategy')
      this.userInfo = this.$auth.user
      this.avatar = this.userInfo.avatar
      this.nickname = this.userInfo.nickname
      this.getClassOptions();
      this.getTypeOptions();
      this.getAgreementInfo()
    },
    methods:{
      submit:Debounce(function () {
        this.$axios.post("/api/front/merchant/settled/apply", { avatar: this.avatar, nickname: this.nickname}).then(res=>{
          this.getUserInfo()
        })
      }),
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
      ChangeIsAgree: function(e) {
				this.isAgree = !this.isAgree;
				this.validateBtn();
			},
      // 提交申请
      submitForm() {
        if(this.isAgree == true) {
          this.merchantData.qualificationPicture = JSON.stringify(this.merchantData.qualificationPicture);
          this.$axios.post('/api/front/merchant/settled/apply',this.merchantData).then(res => {
            this.$message.success('success');
            this.$emit('closeAddress')
            this.resetFormDate();
          }).catch(err => {
            if(res.data.code === 200){
              that.$message.success(res.data.message);
              that.sendCode();
            }else{
              that.$message.error(res.data.message);
            }
          })
        } else {
          this.$message.error('Please check the protocol');
        }
      },
      getUserInfo(){
        this.$axios.get("/api/front/user/info",).then(res=>{
          let data = res.data
          this.avatar = data.avatar
          this.nickname = data.nickname
        })
      },
      getAgreementInfo(){
        this.$axios.get("/api/front/merchant/settled/agreement",).then(res=>{
          this.agreementInfo = res.data;
        })
      },

      getClassOptions() {
        this.$axios.get("/api/front/merchant/all/category/list",).then(res=>{
          this.classOptions = res.data;
          this.handlingFee = res.data.handlingFee
        })
      },
      getTypeOptions() {
        this.$axios.get("/api/front/merchant/all/type/list",).then(res=>{
          this.typeOptions = res.data;
        })
      },
      picList(item){
        this.merchantData.qualificationPicture = item
      },
      // 退出登录
      async longOut(){
        let val = this.$cookies.get('auth.strategy')
        await this.$auth.logout().then(res=>{
          this.$router.replace({
            path:'/'
          })
        })
      },
      registerCode(){
        this.emailCode()
      },
    /**
     *
     * 邮箱验证码
     */
    emailCode: Debounce(function () {
      let that = this;
      if (!that.merchantData.email) return that.$message.error(this.$t(`message.login.emailEmpty`));
      if (!/^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/i.test(that.merchantData.email))  return that.$message.error(this.$t(`message.login.correctEmail`));
      axios({
        method: 'post',
        url: process.env.BASE_URL + '/api/front/captcha/email/merchant/settled',
        data: that.merchantData.email,
        headers: { 'Content-Type': 'application/json; charset=UTF-8'},
      }).then(res => {
        if(res.data.code === 200){
          that.$message.success(res.data.message);
            that.sendCode();
          }else{
            that.$message.error(res.data.message);
          }
      })
    }),
      // 发送验证码
      getCode:Debounce(function (type){
        let that = this;
            this.$axios.post("/api/front/captcha/email/merchant/settled").then(res=>{
            Message.success(this.$t(`message.login.updateSU`));
            that.sendCode();
          })
      }),
      code:Debounce(function (type){
          let that = this;
             this.$axios.post("/api/front/captcha/email/merchant/settled").then(res=>{
              Message.success(this.$t(`message.login.updateSU`));
              that.sendCode();
            })
      }),
      // 绑定新手机号码
      async bindNewPhone(){
        let that = this
        if (!that.phoneData.newPhone) return Message.error('请填写新手机号码');
        if (!/^1(3|4|5|7|8|9|6)\d{9}$/i.test(that.phoneData.newPhone)) return Message.error('请输入正确的手机号码');
        if(!that.phoneData.code) return  Message.error('请填写验证码');
        this.$axios.post('/api/user/change/phone',{
          phone:that.phoneData.newPhone,
          sms_code:that.phoneData.code
        }).then(res=>{
          Message.success(res.message);
          this.isPhone = false
          this.phoneData.newPhone = ''
          this.phoneData.code = ""
        })
      },
      //店铺类型选择
      onSelectedType(id){
        let obj = {};
        obj = this.typeOptions.find((item)=>{//这里的classOptions就是上面遍历的数据源
          return item.id === id;//筛选出匹配数据
        });
        this.merchantTypeInfo = obj.info // 店铺类型说明
      },
      // 商户分类选择
      onSelectedDrug(id){
				let obj = {};
			      obj = this.classOptions.find((item)=>{//这里的classOptions就是上面遍历的数据源
			        return item.id === id;//筛选出匹配数据
            });
            this.merchantData.handlingFee = obj.handlingFee //手续费
			},
      countryInfo(obj){
        this.merchantData.country = obj.name;
      },
      resetFormDate(){
        this.merchantData.name = "";
        this.merchantData.realName = "";
        this.merchantData.phone = "";
        this.merchantData.captcha = '';
        this.merchantData.address ='';
        this.merchantData.categoryId = '';
        this.merchantData.email = '';
        this.merchantData.handlingFee = '';
        this.merchantData.keywords = '';
        this.merchantData.qualificationPicture = [];
        this.merchantData.typeId = '';
        this.merchantData.country = "";
        if(!this.focusUpdate){
          setTimeout(()=>{
            this.focusUpdate = true;
            setTimeout(()=>{
              this.focusUpdate = false;
            },800)
          },800)
        }
      }
    },
  }
</script>

<style lang="scss" scoped>
  .img-box-wrapper{
    margin-top: -33px;
  }
  .upload-from{
    position: relative;
    left: -90px;
    top: -9px;
    opacity: 0;
  }
  .user-com-title{
    border: none;
    padding-left: 30px;
  }
  .user-index{
    background-color: #fff;
    .user-content{
      padding:34px 0;
      .item{
        padding-left: 46px;
        position: relative;
        font-size: 14px;
        margin-right: 54px;
        .edit-txt{
          position: absolute;
          right: 0;
          bottom: 16px;
          cursor: pointer;
        }
        .label{
          display: inline-block;
          line-height: 40px;
          margin-right: 10px;
          width: 128px;
          color: #666666;
        }
        &.user-info{
          margin-bottom: 40px;
          text-align: center;
          font-size: 18px;
          color: #333333;

          .title{
            width: 100%;
            color: #282828;
            font-size: 18px;
          }
          .info{
            color: #777777;
            font-size: 14px;
            img{
              width: 80px;
              height: 80px;
              border-radius: 50%;
              vertical-align: -44px;
              display: inline-block;
            }
          }
        }
        &.text-info{
         margin-bottom: 30px;
          .edit-txt{
            top: 0;
          }
          .txt{
            color: #333;
            width: 700px;
          }
        }
      }
      .out-btn{
        text-align: center;
        margin-right: 54px;
        span{
          display: inline-block;
          width: 150px;
          height: 44px;
          margin-top: 38px;
          line-height: 40px;
          text-align: center;
          background: #E93323;
          color: #fff;
          border-radius: 4px;
          cursor: pointer;
        }
      }
    }
  }
  .input-item{
    display: flex;
    align-items: center;
    margin-bottom: 20px;
    .code-box{
      width: 90px;
      height: 40px;
      background: #E93323;
      border-radius: 2px;
      text-align: center;
      cursor: pointer;
      // margin-left: 15px;
        &.on {
          color: #CCC !important;
        }
    }
    .el-button {
      background: #E93323;
      border-radius: 2px;
    }
  }
  .dialog-footer{
    display: flex;
    align-items: center;
    justify-content: center;
    padding-top: 40px;
    button{
      width: 190px;
      height: 45px;
    }
  }
  .el-form {
    .btn {
      display: inline-block;
      margin-left: 15px;
      span{
        display: inline-block;
        width: 90px;
        height: 40px;
        line-height: 40px;
        text-align: center;
        background: #E93323;
        color: #fff;
        border-radius: 4px;
        cursor: pointer;
      }
    }
    .place1 {
      font-size: 14px;
      line-height: 20px;
      width: 400px;
      display: block;
    }
    .place2 {
      font-size: 14px;
      color: #999999;
      line-height: 20px;
      width: 400px;
      display: block;
      margin-bottom: 20px;
    }
  }

  .el-input {
    width: 400px;
  }
  .country_input{
    width:290px;
    margin-left:18px;
  }
  .settleAgree {
    outline: none;
    background: #fff;
    border: 0;
  }
  .agreement {
    font-size: 14px;
    color: #333333;
    line-height: 20px;
  }
</style>
