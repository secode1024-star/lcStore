<template>
  <div class="divBox">
    <el-row :gutter="20">
      <el-col :xs="24" :sm="24" :md="24" :lg="12">
        <el-card class="box-card">
          <div class="header_title">快捷入口</div>
          <div class="nav_grid">
            <div class="nav_grid_item" v-for="(item, index) in permList" :key="index" @click="navigatorTo(item.url)">
              <div class="pic_badge" :style="{ backgroundColor: item.bgColor }">
                <span class="iconfont" :class="item.icon"></span>
              </div>
              <p>{{ item.title }}</p>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="24" :md="24" :lg="12">
        <el-card class="box-card">
          <div class="header_title">经营数据</div>
          <div class="nav_grid">
            <div
              class="nav_grid_item"
              v-for="(item, index) in businessList"
              :key="index"
              @click="navigatorTo(item.path)"
            >
              <p class="num_data">{{ item.num }}</p>
              <p class="label">{{ item.title }}</p>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>
<script>
import echartsNew from '@/components/echartsNew/index';
import { businessData } from '@/api/dashboard';
import { checkPermi } from '@/utils/permission'; // 权限判断函数
export default {
  components: {
    echartsNew,
  },
  data() {
    return {
      grid: {
        xl: 3,
        lg: 3,
        md: 6,
        sm: 8,
        xs: 8,
      },
      nav_list: [
        {
          bgColor: '#1890FF',
          icon: 'iconhuiyuanguanli',
          title: '用户管理',
          url: '/user/index',
          perms: ['merchant:user:page:list'],
        },
        {
          bgColor: '#1BBE6B',
          icon: 'iconxitongshezhi',
          title: '商户设置',
          url: '/operation/modifyStoreInfo',
          perms: ['merchant:base:info'],
        },
        {
          bgColor: '#EF9C20',
          icon: 'iconshangpinguanli',
          title: '商品管理',
          url: '/product/list',
          perms: ['merchant:product:page:list'],
        },
        {
          bgColor: '#F56C6C',
          icon: 'icondingdanguanli',
          title: '订单管理',
          url: '/order/list',
          perms: ['merchant:order:page:list'],
        },
        {
          bgColor: '#1890FF',
          icon: 'iconyouhuiquan',
          title: '优惠券',
          url: '/coupon/list',
          perms: ['merchant:coupon:page:list'],
        },
      ],
      statisticData: [
        { title: '待发货订单', num: 0, path: '/order/list', perms: ['merchant:order:page:list'] },
        { title: '待退款订单', num: 0, path: '/order/list', perms: ['merchant:order:page:list'] },
        { title: '库存预警', num: 0, path: '/product/list', perms: ['merchant:product:page:list'] },
        { title: '上架商品', num: 0, path: '/product/list', perms: ['merchant:product:page:list'] },
        { title: '仓库商品', num: 0, path: '/product/list', perms: ['merchant:product:page:list'] },
      ],
      optionData: {},
      applyNum: 0,
      style: { height: '250px' },
    };
  },
  computed: {
    //鉴权处理
    permList: function () {
      let arr = [];
      this.nav_list.forEach((item) => {
        if (this.checkPermi(item.perms)) {
          arr.push(item);
        }
      });
      return arr;
    },
    businessList: function () {
      let arr = [];
      this.statisticData.forEach((item) => {
        if (this.checkPermi(item.perms)) {
          arr.push(item);
        }
      });
      return arr;
    },
  },
  mounted() {
    this.getbusinessData();
  },
  methods: {
    checkPermi,
    navigatorTo(path) {
      this.$router.push(path);
    },
    getbusinessData() {
      businessData().then((res) => {
        this.statisticData[0].num = res.notShippingOrderNum; //待发货订单
        this.statisticData[1].num = res.refundingOrderNum; //退款中订单
        this.statisticData[2].num = res.vigilanceInventoryNum; //库存预警
        this.statisticData[3].num = res.onSaleProductNum; //上架商品
        this.statisticData[4].num = res.notSaleProductNum; //仓库商品
      });
    },
  },
};
</script>
<style lang="scss" scoped>
.ivu-mb {
  margin-bottom: 10px;
}
.divBox {
  padding: 0 20px !important;
}

.dashboard-console-grid {
  text-align: center;
  .ivu-card-body {
    padding: 0;
  }
  i {
    font-size: 32px;
  }
  a {
    display: block;
    color: inherit;
  }
  p {
    margin-top: 8px;
  }
}
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
.nav_grid {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  margin-bottom: 10px;
}
.nav_grid_item {
  width: 25%;
  height: 90px;
  margin-top: 30px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  cursor: pointer;
  img {
    width: 58px;
    height: 58px;
  }
  .pic_badge {
    width: 58px;
    height: 58px;
    display: flex;
    justify-content: center;
    align-items: center;
    color: #fff;
    border-radius: 4px;
    .iconfont {
      font-size: 30px;
    }
  }
  p {
    height: 17px;
    font-size: 14px;
    font-family: PingFangSC-Regular, PingFang SC;
    font-weight: 400;
    color: #000000;
    line-height: 17px;
    margin-top: 12px;
  }
  .num_data {
    font-size: 28px;
    font-weight: 600;
    color: #333;
    text-align: center;
    margin-bottom: 18px;
  }
  .label {
    font-size: 14px;
    color: #666666;
    text-align: center;
  }
}
</style>
