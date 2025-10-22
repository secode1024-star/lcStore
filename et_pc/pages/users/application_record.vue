<template>
  <div class="user-index">
    <div class="user-content" v-loading="loading">
      <div v-if="recordList.length" class="settled-count">
        <div class="settled-item" v-for="(item, index) in recordList" :key="index">
          <div class="title acea-row row-between">
            {{$t(`page.user.record`)}}
            <div class="settled-status acea-row">
              <img v-if="item.auditStatus == 1" src="../../assets/images/pending.png" />
              <img v-else-if="item.auditStatus == 2" src="../../assets/images/passed.png" />
              <img v-else-if="item.auditStatus == 3" src="../../assets/images/not-pass.png" />
              {{statusText(item.auditStatus)}}
            </div>
          </div>
          <div class="item-content">
            <div class="list">{{$t(`page.store.storeName`)}}：{{item.name}}</div>
            <div class="list">{{$t(`message.tips.time`)}}：{{item.createTime}}</div>
          </div>
          <div class="item-operate">
            <div v-show="item.denialReason">
              <span class="reason">{{$t(`message.tips.reason`)}}： {{ item.denialReason }}</span>
            </div>
          </div>
        </div>
      </div>
      <div class="empty-box" v-if="recordList.length===0 && !loading">
        <img src="~assets/images/nosort.png" alt="">
        <p>{{$t(`message.settled.appleTips`)}}~</p>
      </div>
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
  export default {
    name: "applicationRecord",
    auth: "guest",
    data(){
      return {
        recordList: [],
        isDialog: false,
        resData: {},
        page:1,
        limit:10,
        total: null,
        loading: false,
      }
    },
    head() {
      return {
        title: this.$t(`page.user.record`)
      }
    },
    beforeMount(){
    },
    mounted() {
      this.getRecordList();
    },
    methods:{
      statusText(number) {
        // 使用对象
        let statusData = {
          1: this.$t(`message.tips.stay`),
          2: this.$t(`message.tips.adopt`),
          3: this.$t(`message.tips.noadopt`)
        };
        return statusData[number]
      },
      getRecordList(){
        this.loading = true
        this.$axios.get(`/api/front/merchant/settled/record`).then(res => {
          this.recordList = res.data.list;
          this.total = res.data.total;
          this.loading = false
        }).catch(error=>{
          this.loading = false
        });
      },
      bindPageCur(data){
        this.page = data
        this.getRecordList()
      }
    }
  }
</script>
<style lang="scss" scoped>
  .user-index{
    height: 100%;
    .user-content{
      width: 975px;
      height: 100%;
      background-color: #fff;
      padding: 30px;
    }
  }
  .settled-count{
    .settled-item{
      width: 915px;
      box-shadow: 0px 3px 20px 0px rgba(0, 0, 0, 0.06);
      margin-bottom: 30px;
      .title{
        height: 53px;
        line-height: 53px;
        font-size: 16px;
        padding: 0 20px;
        border-bottom: 1px dashed #ECECEC;
        .settled-status{
          float: right;
          color: #282828;
          font-weight: bold;
          font-size: 16px;
          align-items: center;
          img{
            width: 22px;
            height: 22px;
            margin-right: 10px;
          }
          span{
            font-size: 22px;
            margin-right: 10px;
            position: relative;
            top: 2.2px;
          }
          .status0{
            color: rgb(51,130,247);
          }
          .status1{
            color: rgb(97,206,116);
          }
          .status2{
            color: rgb(240,68,28);
          }
        }

      }
      .item-content{
        padding: 20px 20px 10px;
        .list{
          color: #666666;
          line-height: 30px;
          font-size: 16px;
        }
      }
      .item-operate{
        padding: 0 20px 20px;
        overflow: hidden;
        .settled-btn{
          float: right;
          border: 1px solid #999999;
          background-color: #fff;
          color: #666666;
          border-radius: 4px;
        }
        .reason{
          color: #F0441C;

        }
      }
    }
  }
  ::v-deep.el-dialog{
    border-radius: 12px;
    width: 480px;
    ::v-deep.el-dialog__body{
      padding: 10px 20px;
    }
  }
  .merchant-details {
    text-align: center;
    background-color: #fff;
    position: relative;
    .top {
      width: 237px;
      height: 195px;
      display: inline-block;
      .img {
        width: 100%;
        height: 100%;
      }
      .title {
        font-size: 20px;
        color: #59B413;
      }
    }
    .msg {
      background-color: #F6F6F6;
      border-radius: 6px;
      margin: 35px 0;
      padding: 10px 30px;
      line-height: 30px;
      .url {
        display: flex;
        flex-wrap: nowrap;
        margin-bottom: 20px;
      }
      .phone {
        display: flex;
        justify-content: space-between;
      }
      .head {
        color: #333333;
        font-size: 28px;
        font-weight: 500;
        white-space: nowrap;
      }
      .content {
        color: #999999;
        font-size: 26px;
      }
    }
    .btn {
      color: #999999;
    }
  }
  .pages-box{
    margin-top: 30px;
    text-align: right;
  }

</style>
