<template>
  <div>
    <el-drawer :visible.sync="dialogVisible" :direction="direction" size="700px" :before-close="handleClose">
      <div slot="title" class="title">订单详情</div>
      <div class="demo-drawer__content" v-loading="loading">
        <div class="description" v-if="orderDatalist">
          <div class="title">用户信息</div>
          <div class="acea-row">
            <div class="description-term">用户昵称：{{ orderDatalist.nikeName }}</div>
            <div class="description-term">邮箱：{{ orderDatalist.userEmail }}</div>
          </div>
          <el-divider></el-divider>
          <div class="title">收货信息</div>
          <div class="acea-row">
            <div class="description-term">收货人：{{ orderDatalist.realName }}</div>
            <div class="description-term">收货电话：{{ orderDatalist.userPhone }}</div>
            <div class="description-term">收货地址：{{ orderDatalist.userAddress }}</div>
            <div class="description-term">收货邮箱：{{ orderDatalist.email }}</div>
          </div>
          <el-divider></el-divider>
          <div class="title">商户信息</div>
          <div class="acea-row">
            <div class="description-term">商户ID：{{ orderDatalist.merId }}</div>
            <div class="description-term">商户名称：{{ orderDatalist.merName }}</div>
            <div class="description-term">商户类别：{{ orderDatalist.merIsSelf | selfTypeFilter }}</div>
          </div>
          <el-divider></el-divider>
          <div class="title">商品信息</div>
          <div v-for="(item, index) in orderDatalist.orderInfo" :key="index" class="acea-row">
            <div class="description-term">商品名称：{{ item.productName }}</div>
            <div class="description-term">商品价格：{{ item.price }}</div>
            <div class="description-term">商品规格：{{ item.sku }}x{{ item.payNum }}</div>
            <div class="description-term">商品重量：{{ item.weight }}</div>
            <div class="description-term">商品体积：{{ item.volume }}</div>
            <div class="description-term">
              商品图片：
              <div class="demo-image__preview mr10">
                <el-image :src="$imageUrl(item.image)" :preview-src-list="[$imageUrl(item.image)]" />
              </div>
            </div>
          </div>
          <el-divider></el-divider>
          <div class="title">订单信息</div>
          <div class="acea-row">
            <div class="description-term">订单号：{{ orderDatalist.orderNo }}</div>
            <div class="description-term">主订单号：{{ orderDatalist.masterOrderNo }}</div>
            <div class="description-term" style="color: red">
              订单状态：
              <span v-show="orderDatalist.isUserDel">已删除</span>
              <span v-show="orderDatalist.refundStatus === 3">已退款</span>
              <span v-show="orderDatalist.paid === false && orderDatalist.status === 0">未支付</span>
              <span v-show="orderDatalist.status === 0">未发货</span>
              <span v-show="orderDatalist.status === 1">待收货</span>
              <span v-show="orderDatalist.status === 3">已完成</span>
              <span v-show="orderDatalist.status === 9">已取消</span>
            </div>
            <div class="description-term">支付状态：{{ orderDatalist.paid ? '已支付' : '未支付' }}</div>
            <div class="description-term">商品总数：{{ orderDatalist.totalNum }}</div>
            <div class="description-term">商品总价：{{ orderDatalist.proTotalPrice }}</div>
            <div class="description-term">支付邮费：{{ orderDatalist.payPostage }}</div>
            <div class="description-term">优惠券金额：{{ orderDatalist.couponPrice }}</div>
            <div class="description-term">实际支付：{{ orderDatalist.payPrice }}</div>
            <div class="description-term fontColor3" v-if="orderDatalist.refundPrice">
              退款金额：{{ orderDatalist.refundPrice }}
            </div>
            <div class="description-term">创建时间：{{ orderDatalist.createTime }}</div>
            <div class="description-term" v-if="orderDatalist.refundReasonTime">
              退款时间：{{ orderDatalist.refundReasonTime }}
            </div>
            <div class="description-term">支付方式：{{ orderDatalist.payType }}</div>
            <div class="description-term">用户备注：{{ orderDatalist.userRemark | filterEmpty }}</div>
            <div class="description-term">平台备注：{{ orderDatalist.platformRemark | filterEmpty }}</div>
            <div class="description-term">商家备注：{{ orderDatalist.merRemark | filterEmpty }}</div>
          </div>
          <template v-if="orderDatalist.deliveryName">
            <el-divider></el-divider>
            <div class="title">物流信息</div>
            <div class="acea-row">
              <div class="description-term">快递公司：{{ orderDatalist.deliveryName }}</div>
              <div class="description-term">
                快递单号：{{ orderDatalist.deliveryId }}
                <el-button
                  type="primary"
                  size="mini"
                  @click="openLogistics"
                  style="margin-left: 5px"
                  v-hasPermi="['platform:order:logistics:info']"
                  >物流查询</el-button
                >
              </div>
            </div>
          </template>
        </div>
      </div>
    </el-drawer>
    <el-dialog v-if="orderDatalist" title="提示" :visible.sync="modal2" width="30%">
      <div class="logistics acea-row row-top">
        <div class="logistics_img"><img src="@/assets/imgs/expressi.jpg" /></div>
        <div class="logistics_cent">
          <span class="mb10">物流公司：{{ resultInfo.expName }}</span>
          <span>物流单号：{{ resultInfo.expNo }}</span>
          <span v-show="resultInfo.courierPhone">快递站：{{ resultInfo.courierPhone }}</span>
          <span v-show="resultInfo.courierPhone">快递员电话：{{ resultInfo.courierPhone }}</span>
        </div>
      </div>
      <div class="acea-row row-column-around trees-coadd">
        <div class="scollhide">
          <el-timeline :reverse="reverse">
            <el-timeline-item v-for="(item, i) in result" :key="i">
              <p class="time" v-text="item.AcceptTime"></p>
              <p class="content" v-text="item.AcceptStation"></p>
            </el-timeline-item>
          </el-timeline>
        </div>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button type="primary" @click="modal2 = false">关闭</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import { orderDetailApi, getLogisticsInfoApi } from '@/api/order';
export default {
  name: 'OrderDetail',
  props: {
    orderId: {
      type: String,
      default: 0,
    },
  },
  data() {
    return {
      direction: 'rtl',
      reverse: true,
      dialogVisible: false,
      orderDatalist: null,
      loading: false,
      modal2: false,
      result: [],
      resultInfo: {},
    };
  },
  mounted() {},
  methods: {
    handleClose() {
      this.dialogVisible = false;
    },
    openLogistics() {
      this.getOrderData();
      this.modal2 = true;
    },
    // 获取订单物流信息
    getOrderData() {
      getLogisticsInfoApi({ orderNo: this.orderId }).then(async (res) => {
        this.resultInfo = res;
        this.result = JSON.parse(res.logisticsInfo);
      });
    },
    getDetail(id) {
      this.loading = true;
      orderDetailApi({ orderNo: id })
        .then((res) => {
          this.orderDatalist = res;
          this.loading = false;
        })
        .catch(() => {
          this.orderDatalist = null;
          this.loading = false;
        });
    },
  },
};
</script>

<style scoped lang="scss">
.title {
  font-size: 36px;
}
.demo-drawer__content {
  padding: 0 30px;
}
.demo-image__preview {
  width: 35px;
  height: auto;
  display: inline-block;
}
.logistics {
  align-items: center;
  padding: 10px 0px;
  .logistics_img {
    width: 45px;
    height: 45px;
    margin-right: 12px;
    img {
      width: 100%;
      height: 100%;
    }
  }
  .logistics_cent {
    span {
      display: block;
      font-size: 12px;
    }
  }
}

.trees-coadd {
  width: 100%;
  height: 400px;
  border-radius: 4px;
  overflow: hidden;
  .scollhide {
    width: 100%;
    height: 100%;
    overflow: auto;
    margin-left: 18px;
    padding: 10px 0 10px 0;
    box-sizing: border-box;
    .content {
      font-size: 12px;
    }

    .time {
      font-size: 12px;
      color: #2d8cf0;
    }
  }
}

.title {
  margin-bottom: 14px;
  color: #303133;
  font-weight: 500;
  font-size: 14px;
}

.description {
  &-term {
    display: table-cell;
    padding-bottom: 5px;
    line-height: 20px;
    width: 50%;
    font-size: 12px;
    color: #606266;
  }
  ::v-deep .el-divider--horizontal {
    margin: 12px 0 !important;
  }
}
</style>
