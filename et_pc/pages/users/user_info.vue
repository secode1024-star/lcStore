<template>
  <div class="user-index">
    <div class="user-content">
      <div class="item user-info">
        <div class="info acea-row">
          <span class="label">{{$t(`page.users.userInfo.avatar`)}}：</span>
          <div class="img-box-wrapper acea-row">
            <img v-if="userInfo.avatar" :src="avatar" alt="avatar">
            <img v-else src="~assets/images/f.png"/>
            <div class="upload-from">
              <upload-from @picList="picList" :isShow="isShow"></upload-from>
            </div>
          </div>
        </div>
      </div>
      <div class="item text-info acea-row mt30">
        <span class="label">{{$t(`page.users.userInfo.name`)}}：</span>
        <el-input v-model="nickname" :placeholder="$t(`page.users.userInfo.name`)" style="width: 500px;margin-top: -9px;"></el-input>
      </div>
      <div v-if="userInfo.email" class="item text-info">
        <span class="label">{{$t(`page.users.userInfo.email`)}}：</span>
        <span class="txt">{{userInfo.email}}</span>
        <span class='iconfont icon-suozi'></span>
      </div>
      <div v-if="userInfo.phone" class="item text-info">
        <span class="label">{{$t(`page.users.userInfo.phone`)}}：</span>
        <span class="txt">{{userInfo.phone}}</span>
        <span class='edit-txt iconfont icon-suozi'></span>
      </div>
      <div class="item text-info">
        <span class="label">{{$t(`page.users.userInfo.password`)}}：</span>
        <span class="txt">******</span>
        <div class="edit-txt font-color" @click="isPassword = true">{{$t(`message.tips.edidM`)}}</div>
      </div>
      <div class="out-btn">
        <span @click="submit">{{$t(`page.users.userInfo.save`)}}</span>
      </div>
    </div>
    <!-- 修改密码 -->
    <el-dialog
      :title="$t(`page.users.userAddressList.edit`) + $t(`page.users.userInfo.password`)"
      :visible.sync="isPassword"
      width="545px"
      :before-close="handleClose">
      <div class="form-box">
        <div v-if="userInfo.userType==='phone'" class="input-item">
          <el-input :placeholder="$t(`page.users.login.phoneVer`)" v-model="userInfo.phone" disabled>
            <template slot="prepend">+86</template>
          </el-input>
        </div>
        <div v-else class="input-item">
          <el-input :placeholder="$t(`page.users.login.emailVer`)" v-model="userInfo.email" disabled>
          </el-input>
        </div>
        <div class="input-item">
          <el-input :placeholder="$t(`page.users.register.placeCode`)" v-model="passwordData.captcha">
          </el-input>
          <el-button plain class="code-box" @click="getCode(0)" :disabled="disabled">{{ text }}</el-button>
        </div>
        <div class="input-item">
          <el-input :placeholder="$t(`page.users.login.placePasd`)" type="password" v-model="passwordData.newPassword">
          </el-input>
        </div>
        <div class="input-item">
          <el-input :placeholder="$t(`page.users.login.Pasdagain`)" type="password" v-model="passwordData.passwordAgain">
          </el-input>
        </div>
      </div>
      <div class="dialog-footer">
          <span slot="footer" >
            <el-button type="primary" @click="bindPassword">{{$t(`page.users.login.submit`)}}</el-button>
            <el-button @click="handleClose">{{$t(`page.goodsDetail.cancel`)}}</el-button>
          </span>
      </div>
    </el-dialog>
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
  import {Message, MessageBox} from 'element-ui';
  import uploadFrom from "@/components/upload";
  import { Debounce } from '@/utils/validate.js'
  export default {
    name: "user_info",
    auth: "guest",
    mixins: [sendVerifyCode],
    data(){
      return {
        isShow: false,
        userInfo:{},
        isPassword:false, //修改密码号码弹窗
        passwordData:{
          passwordAgain:'',
          captcha:'',
          newPassword:''
        },
        isShowCode: false,
        avatar: '',
        nickname: ''
      }
    },
    components: { uploadFrom },
    head() {
      return {
        title: this.$t(`page.users.userInfo.navTitle`)
      }
    },
    beforeMount(){
    },
    mounted() {
      let local = this.$cookies.get('auth.strategy')
      this.userInfo = this.$auth.user
      this.avatar = this.userInfo.avatar
      this.nickname = this.userInfo.nickname
    },
    methods:{
      //保存用户信息
      submit:Debounce(function () {
        if(!this.nickname) return  Message.error(this.$t(`page.users.userInfo.msg`));
        this.$axios.post("/api/front/user/edit", { avatar: this.avatar, nickname: this.nickname}).then(res=>{
          Message.success(res.message);
          this.getUserInfo()
        })
      }),
      getUserInfo(){
        this.$axios.get("/api/front/user/info",).then(res=>{
          let data = res.data
          this.avatar = data.avatar
          this.nickname = data.nickname
          this.$auth.setUser(res.data)
        })
      },
      picList(item){
        this.avatar = item
      },
      // 修改密码
      bindPassword:Debounce(function (){
        if(!this.passwordData.captcha) return  Message.error(this.$t(`message.login.emptyCaptche`));
        if(!this.passwordData.newPassword) return  Message.error(this.$t(`message.login.emptyPassword`));
        if (!this.passwordData.passwordAgain) return Message.error(this.$t(`message.login.againPassword`));
        if(this.passwordData.newPassword !== this.passwordData.passwordAgain) return Message.error(this.$t(`message.login.diffPassword`));
        if(this.userInfo.userType === 'phone'){
          this.$axios.post('/api/front/user/phone/update/password',this.passwordData).then(res=>{
            Message.success(res.message);
            this.isPassword = false
            this.passwordData.captcha = ''
            this.passwordData.passwordAgain = ""
            this.passwordData.newPassword = ""
          })
        }else{
          this.$axios.post('/api/front/user/email/update/password',this.passwordData).then(res=>{
            Message.success(res.message);
            this.isPassword = false
            this.passwordData.captcha = ''
            this.passwordData.passwordAgain = ""
            this.passwordData.newPassword = ""
          })
        }

      }),
      handleClose(){
        this.isPassword = false
        this.passwordData.captcha = ''
        this.passwordData.passwordAgain = ""
        this.passwordData.newPassword = ""
      },
      // 发送验证码
      getCode:Debounce(function (){
          if(this.userInfo.userType==='phone'){
            this.$axios.post("/api/front/captcha/phone/password").then(res=>{
              Message.success(res.message);
              this.sendCode();
            })
          }else{
            this.$axios.post("/api/front/captcha/email/password").then(res=>{
              Message.success(res.message);
              this.sendCode();
            })
          }
      })
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
          width: 80px;
          color: #666666;
        }
        &.user-info{
          margin-top: 53px;
          .title{
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
          width: 130px;
          height: 40px;
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
      width: 115px;
      height: 40px;
      text-align: center;
      cursor: pointer;
      margin-left: 30px;
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
</style>
