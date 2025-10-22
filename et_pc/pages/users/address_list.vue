<template>
  <div class="address-wrapper">
    <div class="user-com-title">
      <el-button type="primary" icon="el-icon-plus" @click="addAddress">{{$t(`page.users.userAddressList.add`)}}</el-button>
    </div>
    <div class="address-content" v-loading="loading">
      <ul class="clearfix">
        <li v-for="(item,index) in list" :index="index" :class="item.isDefault ? 'isDefault' : ''">
          <div v-if="item.isDefault" class="iconfont icon-xuanzhong4 font-color"></div>
          <div v-else class="setDefault font-color" @click="bindDefault(item)">{{$t(`page.users.userAddressList.default`)}}</div>
          <div class="name line1">{{item.realName}}</div>
          <div class="phone">{{item.email}}</div>
          <div class="text line4">{{item.country}}{{item.detail}}</div>
          <div class="edit-box">
            <span @click="edit(item)">{{$t(`page.users.userAddressList.edit`)}}</span>
            <span @click="bingDelete(item,index)">{{$t(`page.users.userAddressList.del`)}}</span>
          </div>
          <div class="moren" v-if="item.isDefault">{{$t(`page.goodsList.default`)}}</div>
        </li>
      </ul>
    </div>
    <div class="empty-box" v-if="list.length == 0 && !loading">
      <img src="~assets/images/noDetail.png" alt="">
      <p>{{$t(`page.users.userAddressList.emptyAddress`)}}~</p>
    </div>
    <div class="pages-box" v-if="total > 0">
      <el-pagination
        background
        layout="prev, pager, next"
        @current-change="bindPageCur"
        :pageSize="limit"
        :total="total">
      </el-pagination>
    </div>
    <!-- 添加地址弹窗 -->
    <el-dialog
      :close-on-click-modal="false"
      :title="modelTitle"
      :visible.sync="dialogVisible"
      width="700px"
      center
      :before-close="handleClose">
      <add-address v-if="dialogVisible" @closeAddress="closeAddress" @closeAddressModal="handleClose" ref="addAddress" :formDatas="formData"></add-address>
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
  import {Message, MessageBox} from 'element-ui';
  import addAddress from "@/components/addAddress";
  export default {
    name: "address_list",
    auth: "guest",
    data(){
      return{
        list:[],
        page:1,
        limit:20,
        total: 0,
        isShowSelect:false,
        dialogVisible:false,
        stepStop: false,
        editId:0,
        formData:{},
        cityData:{
          pid:0,
          step:1,
          list:[],
          con:'',
          province:{},
          city:{},
          county: {},
          district:{}
        },
        selectedIndex: -1,
        selectedArr: [],
        loading: false,
        modelTitle: ''
      }
    },
    components: { addAddress },
    computed:{
      activeId(){
        return this.selectedIndex == -1 ? 0 : this.selectedArr[this.selectedIndex].id
      },
    },
    head() {
      return {
        title: this.$t(`page.users.userAddressList.navTitle`)
      }
    },
    beforeMount(){
    },
    mounted() {
      this.getList()
    },
    methods:{
      getList(){
        this.loading = true
        this.$axios.get('/api/front/address/list').then(res=>{
          this.list = res.data.list
          this.total = res.data.total
          this.loading = false
        }).catch(error=>{
          this.loading = false
        })
      },
      addAddress(){
        this.dialogVisible = true
        this.formData.id = ''
        this.modelTitle = this.$t(`page.users.userAddressList.add`)
      },
      bindPageCur(data){
        this.page = data
        this.getList()
      },
      closeAddress() {
        this.handleClose()
        this.getList()
      },
      handleClose() {
       // this.$refs.addAddress.resetForm('formData')
        this.dialogVisible = false
      },
      // 设为默认
      bindDefault(item){
        this.$axios.post('/api/front/address/default/set',{id: item.id}).then(res=>{
          this.getList()
          return Message.success(this.$t(`message.login.setSU`))
        })
      },
      // 删除
      bingDelete(item,index){
        MessageBox.confirm(this.$t(`page.users.userAddressList.sureDel`),this.$t(`message.login.prompt`)).then(res=>{
          this.$axios.post('/api/front/address/del',{id: item.id}).then(data=>{
            this.getList()
            return Message.success(this.$t(`message.login.delSU`))
          }).catch(err=>{
            return Message.error(err);
          })
        })
      },
      // 编辑
      edit(item){
        this.modelTitle = this.$t(`page.users.userAddressList.edit`)
        this.dialogVisible = true
        this.$axios.get('/api/front/address/detail/'+item.id).then(res=>{
          this.formData= res.data
        })
      },
      // 表单重置
      formReset(){
        this.formData.name = ''
        this.formData.phone = ''
        this.formData.con = ''
        this.formData.checked = false
        this.cityData.province = {}
        this.cityData.city = {}
        this.cityData.district = {}
        this.cityData.step = 1
        this.cityData.pid = 0
      }
    }
  }
</script>

<style lang="scss" scoped>
  .setDefault{
    background: #FCEAE9;
    position: absolute;
    padding: 6px 8px;
    right: 0px;
    top: 0px;
    font-size: 12px;
    opacity: 0;
    cursor: pointer;
  }

  .pages-box{
    margin-top: 30px;
    text-align: right;
  }
  .icon-xuanzhong4 {
    position: absolute;
    right: -3px;
    bottom: -3px;
    font-size: 22px;
  }
  .isDefault{
    border: 1px solid #E93323 !important;
  }
  .user-com-title{
    padding: 0 30px;
    height: 100px;
    line-height: 100px;
    background-color: #fff;
  }
  .address-wrapper{
    .address-content{
      padding: 0 30px 30px 30px;
      background-color: #fff;
      li{
        position: relative;
        float: left;
        width: 250px;
        min-height: 200px;
        margin-top: 30px;
        margin-right: 30px;
        padding: 22px 27px;
        border: 1px solid #EAEAEA;
        &:nth-child(3n){
          margin-right: 0;
        }
        .moren{
          position: absolute;
          right: 0;
          top: 0;
          padding: 6px;
          text-align: center;
          color: #fff;
          background: #E93323;
          font-size: 12px;
        }
        .name{
          color: #282828;
          font-size: 16px;
        }
        .phone{
          margin-top: 15px;
          margin-bottom: 18px;
          font-size: 12px;
        }
        .text{
          color: #999999;
          font-size: 14px;
          max-height: 75px;
        }
        .edit-box{
          opacity: 0;
          position: absolute;
          right: 14px;
          bottom: 12px;
          color: #E93323;
          font-size: 12px;
          span{
            margin-left: 5px;
            cursor: pointer;
          }
        }
        &.addbox{
          .box{
            position: absolute;
            left: 0;
            top: 50%;
            margin-top: -25px;
            text-align: center;
            width: 100%;
            color: #C8C8C8;
            font-size: 14px;
            img{
              display: inline-block;
              width: 27px;
              height: 27px;
            }
          }
        }
        &:hover{
          .setDefault, .edit-box{
            opacity: 1;
            transition: all .6s ease;
          }
        }
      }
    }
  }
  .input-item{
    margin-bottom: 20px;
  }
  .text-wrapper{
    position: relative;
    height: 40px;
    line-height: 40px;
    border: 1px solid #DCDFE6;
    padding: 0 15px;
    box-sizing: border-box;
    border-radius: 4px;
    color: #cfcfcf;
    .select-wrapper{
      z-index: 10;
      position: absolute;
      left: 0;
      top: 45px;
      width: 100%;
      padding:0 15px;
      background: #fff;
      border: 1px solid #E93323;
      border-radius: 4px;
      line-height: 2;
      .title-box{
        height: 40px;
        line-height: 40px;
        border-bottom: 1px solid #EFEFEF;
        color: #E93323;
        font-size: 14px;
        span{
          margin-right: 8px;
          color: #666666;
        }
      }
      .label-txt{
        margin: 8px 0 18px;
        color: #666666;
        font-size: 14px;
        span{
          margin-right: 10px;
          cursor: pointer;
          &.on{
            color: #E93323;
          }
        }
      }
    }
  }
</style>
