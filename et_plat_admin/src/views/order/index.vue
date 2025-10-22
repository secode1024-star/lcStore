<template>
  <div class="divBox relative">
    <el-card class="box-card">
      <div class="clearfix">
        <div class="container">
          <el-form size="small" label-width="100px">
            <el-form-item label="订单状态：" v-if="checkPermi(['platform:order:status:num'])">
              <el-radio-group v-model="tableFrom.status" type="button" @change="seachList">
                <el-radio-button label="all"
                  >全部 {{ '(' + orderChartType.all ? orderChartType.all : 0 + ')' }}
                </el-radio-button>
                <el-radio-button label="unPaid"
                  >未支付 {{ '(' + orderChartType.unPaid ? orderChartType.unPaid : 0 + ')' }}
                </el-radio-button>
                <el-radio-button label="notShipped"
                  >未发货 {{ '(' + orderChartType.notShipped ? orderChartType.notShipped : 0 + ')' }}
                </el-radio-button>
                <el-radio-button label="spike"
                  >待收货 {{ '(' + orderChartType.spike ? orderChartType.spike : 0 + ')' }}
                </el-radio-button>
                <el-radio-button label="complete"
                  >交易完成 {{ '(' + orderChartType.complete ? orderChartType.complete : 0 + ')' }}
                </el-radio-button>
                <el-radio-button label="refunded"
                  >已退款 {{ '(' + orderChartType.refunded ? orderChartType.refunded : 0 + ')' }}
                </el-radio-button>
                <el-radio-button label="deleted"
                  >已删除 {{ '(' + orderChartType.deleted ? orderChartType.deleted : 0 + ')' }}
                </el-radio-button>
              </el-radio-group>
            </el-form-item>
            <el-form-item label="时间选择：" class="width100">
              <el-radio-group
                v-model="tableFrom.dateLimit"
                type="button"
                class="mr20"
                size="small"
                @change="selectChange(tableFrom.dateLimit)"
              >
                <el-radio-button v-for="(item, i) in fromList.fromTxt" :key="i" :label="item.val"
                  >{{ item.text }}
                </el-radio-button>
              </el-radio-group>
              <el-date-picker
                v-model="timeVal"
                value-format="yyyy-MM-dd"
                format="yyyy-MM-dd"
                size="small"
                type="daterange"
                placement="bottom-end"
                placeholder="自定义时间"
                style="width: 220px"
                @change="onchangeTime"
              />
            </el-form-item>
            <el-form-item label="订单号：" class="width100">
              <el-input v-model="tableFrom.orderNo" placeholder="请输入订单号" class="selWidth" size="small" clearable>
                <el-button slot="append" icon="el-icon-search" size="small" @click="seachList" />
              </el-input>
            </el-form-item>
          </el-form>
        </div>
      </div>
    </el-card>
    <el-card class="box-card">
      <el-table
        v-loading="listLoading"
        :data="tableData.data"
        size="mini"
        class="table"
        highlight-current-row
        :header-cell-style="{ fontWeight: 'bold' }"
        :row-key="
          (row) => {
            return row.orderNo;
          }
        "
      >
        <!-- @selection-change="handleSelectionChange" -->
        <!-- <el-table-column
          type="selection"
          :reserve-selection="true"
          width="55"
        /> -->
        <el-table-column label="订单号" min-width="185" v-if="checkedCities.includes('订单号')">
          <template slot-scope="scope">
            <span
              style="display: block"
              :class="scope.row.refundStatus === 1 || scope.row.refundStatus === 3 ? 'red' : ''"
              v-text="scope.row.orderNo"
            />
            <span v-show="scope.row.isUserDel" style="color: #ed4014; display: block">用户已删除</span>
          </template>
        </el-table-column>
        <el-table-column
          prop="masterOrderNo"
          label="主订单号"
          min-width="180"
          v-if="checkedCities.includes('主订单号')"
        />
        <el-table-column prop="merName" label="商户名称" min-width="180" v-if="checkedCities.includes('商户名称')" />
        <el-table-column prop="realName" label="收货人" min-width="100" v-if="checkedCities.includes('收货人')" />
        <el-table-column prop="payPrice" label="实际支付" min-width="80" v-if="checkedCities.includes('实际支付')" />
        <el-table-column label="支付方式" min-width="80" v-if="checkedCities.includes('支付方式')">
          <template slot-scope="scope">
            <span>{{ scope.row.payType }}</span>
          </template>
        </el-table-column>
        <el-table-column label="订单状态" min-width="100" v-if="checkedCities.includes('订单状态')">
          <template slot-scope="scope">
            <span v-show="scope.row.isUserDel">已删除</span>
            <span v-show="scope.row.refundStatus === 3">已退款</span>
            <span v-show="scope.row.paid === false && scope.row.status === 0">未支付</span>
            <span v-show="scope.row.status === 0">未发货</span>
            <span v-show="scope.row.status === 1">待收货</span>
            <span v-show="scope.row.status === 3">已完成</span>
            <span v-show="scope.row.status === 9">已取消</span>
          </template>
        </el-table-column>
        <el-table-column
          label="平台备注"
          min-width="120"
          :show-overflow-tooltip="true"
          v-if="checkedCities.includes('平台备注')"
        >
          <template slot-scope="scope">
            <span>{{ scope.row.platformRemark | filterEmpty }}</span>
          </template>
        </el-table-column>
        <el-table-column
          label="商家备注"
          min-width="120"
          :show-overflow-tooltip="true"
          v-if="checkedCities.includes('商家备注')"
        >
          <template slot-scope="scope">
            <span>{{ scope.row.merRemark | filterEmpty }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="下单时间" min-width="150" v-if="checkedCities.includes('下单时间')" />
        <el-table-column label="操作" min-width="150" fixed="right" align="center" :render-header="renderHeader">
          <template slot-scope="scope">
            <el-button
              type="text"
              size="small"
              @click.native="onOrderDetails(scope.row.orderNo)"
              v-hasPermi="['platform:order:info']"
              >订单详情</el-button
            >
            <el-button
              type="text"
              size="small"
              @click.native="onOrderMark(scope.row)"
              v-hasPermi="['platform:order:mark']"
              >订单备注</el-button
            >
          </template>
        </el-table-column>
      </el-table>
      <div class="block">
        <el-pagination
          :page-sizes="[20, 40, 60, 80]"
          :page-size="tableFrom.limit"
          :current-page="tableFrom.page"
          layout="total, sizes, prev, pager, next, jumper"
          :total="tableData.total"
          @size-change="handleSizeChange"
          @current-change="pageChange"
        />
      </div>
    </el-card>
    <div class="card_abs" v-show="card_select_show">
      <template>
        <div class="cell_ht">
          <el-checkbox :indeterminate="isIndeterminate" v-model="checkAll" @change="handleCheckAllChange"
            >全选</el-checkbox
          >
          <el-button type="text" @click="checkSave()">保存</el-button>
        </div>
        <el-checkbox-group v-model="checkedCities" @change="handleCheckedCitiesChange">
          <el-checkbox v-for="item in columnData" :label="item" :key="item" class="check_cell">{{ item }}</el-checkbox>
        </el-checkbox-group>
      </template>
    </div>
    <!--详情-->
    <details-from ref="orderDetail" :orderId="orderId" />
  </div>
</template>

<script>
import {
  orderListDataApi,
  orderStatusNumApi,
  orderListApi,
  updatePriceApi,
  orderMarkApi,
  orderPrint,
} from '@/api/order';
import detailsFrom from '@/components/orderDetail';
import { isWriteOff } from '@/utils';
import { orderExcelApi } from '@/api/store';
import { checkPermi } from '@/utils/permission'; // 权限判断函数
export default {
  name: 'orderlistDetails',
  components: {
    detailsFrom,
  },
  data() {
    return {
      RefuseVisible: false,
      RefuseData: {},
      orderId: '',
      refundData: {},
      tableDataLog: {
        data: [],
        total: 0,
      },
      tableFromLog: {
        page: 1,
        limit: 10,
        orderNo: 0,
      },
      LogLoading: false,
      isCreate: 1,
      editData: null,
      tableData: {
        data: [],
        total: 0,
      },
      listLoading: true,
      tableFrom: {
        status: 'all',
        dateLimit: '',
        orderNo: '',
        page: 1,
        limit: 20,
        type: 0,
      },
      orderChartType: {},
      timeVal: [],
      fromList: this.$constants.fromList,
      fromType: [
        { value: 'all', text: '全部' },
        { value: 'info', text: '普通' },
        { value: 'pintuan', text: '拼团' },
        { value: 'bragin', text: '砍价' },
        { value: 'miaosha', text: '秒杀' },
      ],
      selectionList: [],
      ids: '',
      orderids: '',
      cardLists: [],
      isWriteOff: isWriteOff(),
      proType: 0,
      active: false,
      card_select_show: false,
      checkAll: false,
      checkedCities: [
        '订单号',
        '主订单号',
        '商户名称',
        '收货人',
        '实际支付',
        '支付方式',
        '订单状态',
        '平台备注',
        '商家备注',
        '下单时间',
      ],
      columnData: [
        '订单号',
        '主订单号',
        '商户名称',
        '收货人',
        '实际支付',
        '支付方式',
        '订单状态',
        '平台备注',
        '商家备注',
        '下单时间',
      ],
      isIndeterminate: true,
    };
  },
  mounted() {
    this.getList();
    this.getOrderStatusNum();
    // this.getOrderListData();
  },
  methods: {
    checkPermi,
    seachList() {
      this.tableFrom.page = 1;
      this.getList();
      this.getOrderStatusNum();
    },
    // 详情
    onOrderDetails(id) {
      this.orderId = id;
      this.$refs.orderDetail.getDetail(id);
      this.$refs.orderDetail.dialogVisible = true;
    },
    // 备注
    onOrderMark(row) {
      this.$prompt('订单备注', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        inputErrorMessage: '请输入订单备注',
        inputType: 'textarea',
        inputValue: row.platformRemark,
        inputPlaceholder: '请输入订单备注',
        inputValidator: (value) => {
          if (!value) return '输入不能为空';
        },
      })
        .then(({ value }) => {
          orderMarkApi({ remark: value, orderNo: row.orderNo }).then(() => {
            this.$message.success('操作成功');
            this.getList();
          });
        })
        .catch(() => {
          this.$message.info('取消输入');
        });
    },
    handleSelectionChange(val) {
      this.selectionList = val;
      const data = [];
      this.selectionList.map((item) => {
        data.push(item.orderNo);
      });
      this.ids = data.join(',');
    },
    // 选择时间
    selectChange(tab) {
      this.timeVal = [];
      this.tableFrom.page = 1;
      this.getList();
      this.getOrderStatusNum();
      // this.getOrderListData();
    },
    // 具体日期
    onchangeTime(e) {
      this.timeVal = e;
      this.tableFrom.dateLimit = e ? this.timeVal.join(',') : '';
      this.tableFrom.page = 1;
      this.getList();
      this.getOrderStatusNum();
      // this.getOrderListData();
    },
    // 列表
    getList() {
      this.listLoading = true;
      orderListApi(this.tableFrom)
        .then((res) => {
          this.tableData.data = res.list || [];
          this.tableData.total = res.total;
          this.listLoading = false;
          this.checkedCities = this.$cache.local.has('order_stroge')
            ? this.$cache.local.getJSON('order_stroge')
            : this.checkedCities;
        })
        .catch(() => {
          this.listLoading = false;
        });
    },
    // 数据统计
    getOrderListData() {
      orderListDataApi({ dateLimit: this.tableFrom.dateLimit }).then((res) => {
        this.cardLists = [
          { name: '订单数量', count: res.count, color: '#1890FF', class: 'one', icon: 'icondingdan' },
          { name: '订单金额', count: res.amount, color: '#A277FF', class: 'two', icon: 'icondingdanjine' },
          {
            name: '微信支付金额',
            count: res.weChatAmount,
            color: '#EF9C20',
            class: 'three',
            icon: 'iconweixinzhifujine',
          },
          { name: '余额支付金额', count: res.yueAmount, color: '#1BBE6B', class: 'four', icon: 'iconyuezhifujine2' },
        ];
      });
    },
    // 获取各状态数量
    getOrderStatusNum() {
      orderStatusNumApi({ dateLimit: this.tableFrom.dateLimit, type: this.tableFrom.type }).then((res) => {
        this.orderChartType = res;
      });
    },
    pageChange(page) {
      this.tableFrom.page = page;
      this.getList();
    },
    handleSizeChange(val) {
      this.tableFrom.limit = val;
      this.getList();
    },
    exports() {
      let data = {
        dateLimit: this.tableFrom.dateLimit,
        orderNo: this.tableFrom.orderNo,
        status: this.tableFrom.status,
        type: this.tableFrom.type,
      };
      orderExcelApi(data).then((res) => {
        window.open(res.fileName);
      });
    },
    renderHeader(h) {
      return (
        <p>
          <span style="padding-right:5px;">操作</span>
          <i class="el-icon-setting" onClick={() => this.handleAddItem()}></i>
        </p>
      );
    },
    handleAddItem() {
      if (this.card_select_show) {
        this.$set(this, 'card_select_show', false);
      } else if (!this.card_select_show) {
        this.$set(this, 'card_select_show', true);
      }
    },
    handleCheckAllChange(val) {
      this.checkedCities = val ? this.columnData : [];
      this.isIndeterminate = false;
    },
    handleCheckedCitiesChange(value) {
      let checkedCount = value.length;
      this.checkAll = checkedCount === this.columnData.length;
      this.isIndeterminate = checkedCount > 0 && checkedCount < this.columnData.length;
    },
    checkSave() {
      this.$set(this, 'card_select_show', false);
      this.$modal.loading('正在保存到本地，请稍候...');
      this.$cache.local.setJSON('order_stroge', this.checkedCities);
      setTimeout(this.$modal.closeLoading(), 1000);
    },
    //打印小票
    onOrderPrint(data) {
      orderPrint(data.orderNo)
        .then((res) => {
          this.$modal.msgSuccess('打印成功');
        })
        .catch((error) => {
          this.$modal.msgError(error.message);
        });
    },
  },
};
</script>
<style lang="scss" scoped>
.el-table__body {
  width: 100%;
  table-layout: fixed !important;
}
.demo-table-expand {
  ::v-deeplabel {
    width: 83px !important;
  }
}
.refunding {
  span {
    display: block;
  }
}
.selWidth {
  width: 300px;
}
.el-dropdown-link {
  cursor: pointer;
  color: #409eff;
  font-size: 12px;
}
.el-icon-arrow-down {
  font-size: 12px;
}
.tabBox_tit {
  font-size: 12px !important;
  /*margin: 0 2px 0 10px;*/
  letter-spacing: 1px;
  /*padding: 5px 0;*/
  box-sizing: border-box;
}
.text_overflow {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 400px;
}
.pup_card {
  width: 200px;
  border-radius: 5px;
  padding: 5px;
  box-sizing: border-box;
  font-size: 12px;
  line-height: 16px;
}
.flex-column {
  display: flex;
  flex-direction: column;
}
.mt20 {
  margin-top: 20px;
}
.relative {
  position: relative;
}
.card_abs {
  position: absolute;
  padding-bottom: 15px;
  top: 340px;
  right: 40px;
  width: 200px;
  background: #fff;
  z-index: 99999;
  box-shadow: 0px 0px 14px 0px rgba(0, 0, 0, 0.1);
}
.cell_ht {
  height: 50px;
  padding: 15px 20px;
  box-sizing: border-box;
  border-bottom: 1px solid #eeeeee;
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.check_cell {
  width: 100%;
  padding: 15px 20px 0;
}
::v-deep .el-checkbox__input.is-checked + .el-checkbox__label {
  color: #606266;
}
</style>
