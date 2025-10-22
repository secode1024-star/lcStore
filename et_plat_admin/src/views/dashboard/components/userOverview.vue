<template>
  <div class="divBox" style="padding-top: 0">
    <el-row :gutter="20">
      <el-col :xs="24" :sm="24" :md="24" :lg="24" v-if="checkPermi(['platform:statistics:home:user:channel'])">
        <el-card class="box-card">
          <div class="header_title">用户渠道</div>
          <echarts-new
            :option-data="optionData"
            :styles="style"
            height="100%"
            width="100%"
            v-if="optionData"
          ></echarts-new>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>
<script>
import echartsNew from '@/components/echartsNew/index';
import { userOverviewData, userChannelData } from '@/api/statistic';
import { checkPermi } from '@/utils/permission'; // 权限判断函数
export default {
  data() {
    return {
      optionData: {},
      style: { height: '370px' },
      timeVal: [],
      dateLimit: '',
      list: [],
      fromList: this.$constants.timeList,
      userView: {},
      pickerOptions: this.$timeOptions, //快捷时间选项
    };
  },
  components: {
    echartsNew,
  },
  created() {
    const end = new Date();
    const start = new Date();
    start.setTime(start.setTime(new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate() - 29)));
    this.timeVal = [start, end];
  },
  mounted() {
    this.dateLimit = 'lately7';
    this.dateLimitPram = 'lately7';
    this.getChannel();
  },
  methods: {
    checkPermi,
    onchangeTime(e) {
      this.timeVal = e;
      this.dateLimit = e ? this.timeVal.join(',') : '';
      this.dateLimitPram = e ? this.timeVal.join(',') : '';
    },
    exports() {},
    selectChange(limit) {
      if (limit == '') {
        //昨天的时间
        this.$set(this, 'dateLimitPram', 'yesterday');
      } else {
        this.dateLimitPram = limit;
        this.getUserView();
      }
    },
    //用户概览
    getUserView() {
      userOverviewData({ dateLimit: this.dateLimitPram }).then((res) => {
        this.userView = res;
      });
    },
    //渠道
    getChannel() {
      userChannelData().then((res) => {
        let channelData = new Array();
        res = res.map((item) => {
          return {
            value: item.num,
            name: item.userType,
          };
        });
        this.optionData = {
          tooltip: {
            trigger: 'item',
          },
          legend: {
            top: '5%',
            left: 'center',
          },
          series: [
            {
              name: '访问来源',
              type: 'pie',
              radius: ['40%', '70%'],
              avoidLabelOverlap: false,
              label: {
                show: false,
                position: 'center',
              },
              itemStyle: {
                emphasis: {
                  shadowBlur: 10,
                  shadowOffsetX: 0,
                  shadowColor: 'rgba(0, 0, 0, 0.5)',
                },
                normal: {
                  color: function (params) {
                    //自定义颜色
                    var colorList = ['#1890FF', '#1BBE6B', '#EF9C20', '#4BCAD5', '#F56C6C', '#7880A0', '#E8B600'];
                    return colorList[params.dataIndex];
                  },
                },
              },
              labelLine: {
                show: false,
              },
              data: res,
            },
          ],
        };
      });
    },
  },
};
</script>

<style scoped lang="scss">
.mb20 {
  margin-bottom: 20px;
}
.header_title {
  font-size: 16px;
  font-family: PingFangSC-Semibold, PingFang SC;
  font-weight: 600;
  color: #000000;
  padding-left: 8px;
  position: relative;
  &::before {
    position: absolute;
    content: '';
    width: 2px;
    height: 18px;
    background: #1890ff;
    top: 0;
    left: 0;
  }
}
.flex {
  display: flex;
}
.flex-wrap {
  flex-wrap: wrap;
}
.mb20 {
  margin-bottom: 20px;
}
.mt20 {
  margin-top: 20px;
}
.mb30 {
  margin-bottom: 30px;
}
.mr-20 {
  margin-right: 20px;
}
.justify-between {
  justify-content: space-between;
}
.up,
.el-icon-caret-top {
  color: #f5222d;
  font-size: 12px;
  opacity: 1 !important;
}

.down,
.el-icon-caret-bottom {
  color: #39c15b;
  font-size: 12px;
}
.curP {
  cursor: pointer;
}
.header {
  &-title {
    font-size: 16px;
    color: rgba(0, 0, 0, 0.85);
  }
  &-time {
    font-size: 12px;
    color: #000000;
    opacity: 0.45;
  }
}

.iconfont {
  font-size: 16px;
  color: #fff;
}

.iconCrl {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  text-align: center;
  line-height: 32px;
  opacity: 0.7;
}

.lan {
  background: #1890ff;
}

.iconshangpinliulanliang {
  color: #fff;
}

.infoBox {
  width: 20%;
  height: 87px;
  @media screen and (max-width: 1300px) {
    width: 25%;
  }
  @media screen and (max-width: 1200px) {
    width: 33%;
  }
  @media screen and (max-width: 900px) {
    width: 50%;
  }
}
.data_num {
  height: 100px;
}
.info {
  .sp1 {
    color: #666;
    font-size: 14px;
    display: block;
  }
  .sp2 {
    font-weight: 400;
    font-size: 30px;
    color: rgba(0, 0, 0, 0.85);
    display: block;
    padding: 10px 0 10px;
  }
  .sp3 {
    font-size: 12px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.45);
    display: block;
  }
}
.user_chart {
  min-width: 900px;
}
.user-visitUser {
  width: 75%;
  height: 100px;
  background: #f2f6ff;
  // padding: 18px 0 18px 17px;
  -webkit-box-sizing: border-box;
  box-sizing: border-box;
  @media screen and (max-width: 1200px) {
    width: 55%;
  }
  @media screen and (max-width: 900px) {
    width: 35%;
  }
}
.user-visitUser-ti {
  width: 310px;
  height: 100px;
  background: #1890ff;
  transform: perspective(5em) rotateX(-11deg);
  margin-left: -104px;
  margin-top: 8px;
  text-align: center;
  color: #fff;
  font-size: 14px;
}
.column_center {
  display: flex;
  flex-direction: column;
  // justify-content: center;
  align-items: center;
  padding-top: 17px;
}
.orderUser {
  position: relative;
  top: -6px;
  display: -webkit-box;
  display: -ms-flexbox;
  display: flex;
  white-space: normal;
}
.payOrderUser {
  position: relative;
  top: -16px;
}
.user-orderUser {
  width: 75%;
  height: 98px;
  background: #f1fffa;
  box-sizing: border-box;
  @media screen and (max-width: 1200px) {
    width: 55%;
  }
  @media screen and (max-width: 900px) {
    width: 35%;
  }
}
.user-orderUser-ti {
  width: 226px;
  height: 98px;
  background: #4bcad5;
  transform: perspective(7em) rotateX(-20deg);
  margin-left: -62px;
  margin-top: 7px;
  text-align: center;
  color: #fff;
  font-size: 14px;
}
.user-orderUser-change,
.user-orderUser-changeduan {
  height: 100px;
  border-bottom: 1px solid #d8d8d8;
  border-top: 1px solid #d8d8d8;
  margin-left: -19px;
}
.user-orderUser-change {
  width: 128px;
}
.user-payOrderUser {
  width: 75%;
  height: 95px;
  background: #f3f4f8;
  box-sizing: border-box;
  margin-top: 3px;
  @media screen and (max-width: 1200px) {
    width: 55%;
  }
  @media screen and (max-width: 900px) {
    width: 35%;
  }
}
.user-payOrderUser-ti {
  width: 145px;
  height: 92px;
  background: #5e7092;
  transform: perspective(3em) rotateX(-13deg);
  margin-left: -22px;
  margin-top: 15px;
  text-align: center;
  color: #fff;
  font-size: 14px;
}
.num_data {
  font-size: 24px;
  color: #fff;
  font-weight: 600;
  line-height: 33px;
}
.sp1 {
  margin-left: 10px;
  overflow: auto;
}
.sp2 {
  margin-top: 77px;
  margin-left: 10px;
  overflow: auto;
  white-space: nowrap;
  text-overflow: ellipsis;
}
.inone {
  display: flex;
  flex-direction: column;
  justify-content: center;
  margin-left: 61px;
}
.m20 {
  margin: 20px;
}
.user_reg_tit {
  font-size: 16px;
  color: #333;
  font-weight: bold;
}
.reg_time {
  font-size: 14px;
  padding: 10px 0 10px;
  color: #333;
}

.mb30 {
  margin-bottom: 30px;
}
.card_show {
  @media screen and (max-width: 700px) {
    display: none;
  }
}
</style>
