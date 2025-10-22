<template>
  <div class="divBox relative">
    <el-card class="box-card">
      <div class="clearfix">
        <div class="container">
          <el-form size="small" label-width="100px">
            <el-form-item label="订单状态：" v-if="checkPermi(['merchant:refund:order:status:num'])">
              <el-radio-group v-model="tableFrom.refundStatus" type="button" @change="seachList">
                <el-radio-button label="9"
                  >全部 {{ '(' + orderChartType.all ? orderChartType.all : 0 + ')' }}
                </el-radio-button>
                <el-radio-button label="0"
                  >待审核 {{ '(' + orderChartType.await ? orderChartType.await : 0 + ')' }}
                </el-radio-button>
                <el-radio-button label="1"
                  >审核未通过 {{ '(' + orderChartType.reject ? orderChartType.reject : 0 + ')' }}
                </el-radio-button>
                <el-radio-button label="2"
                  >退款中 {{ '(' + orderChartType.refunding ? orderChartType.refunding : 0 + ')' }}
                </el-radio-button>
                <el-radio-button label="3"
                  >已退款 {{ '(' + orderChartType.refunded ? orderChartType.refunded : 0 + ')' }}
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
                start-placeholder="开始日期"
                end-placeholder="结束日期"
                style="width: 220px"
                @change="onchangeTime"
              />
            </el-form-item>
            <el-form-item label="订单号：" class="width100">
              <el-input
                v-model="tableFrom.merOrderNo"
                placeholder="请输入订单号"
                class="selWidth"
                size="small"
                clearable
              >
                <el-button slot="append" icon="el-icon-search" size="small" @click="seachList" />
              </el-input>
            </el-form-item>
            <el-form-item label="退款单号：" class="width100">
              <el-input
                v-model="tableFrom.refundOrderNo"
                placeholder="请输入退款单号"
                class="selWidth"
                size="small"
                clearable
              >
                <el-button slot="append" icon="el-icon-search" size="small" @click="seachList" />
              </el-input>
            </el-form-item>
          </el-form>
        </div>
      </div>
    </el-card>
    <div class="mt20"></div>
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
            return row.merOrderNo;
          }
        "
      >
        <el-table-column type="expand">
          <template slot-scope="props">
            <el-form label-position="left" inline class="demo-table-expand demo-table-expands">
              <el-form-item label="退款商品总数：">
                <span>{{ props.row.totalNum }}</span>
              </el-form-item>
              <el-form-item label="商家备注：">
                <span>{{ props.row.merRemark | filterEmpty }}</span>
              </el-form-item>
              <el-form-item label="退款信息：">
                <div class="pup_card flex-column">
                  <span>退款原因：{{ props.row.refundReasonWap }}</span>
                  <span>备注说明：{{ props.row.refundReasonWapExplain }}</span>
                  <!--<span>退款时间：{{scope.row.refundTime}}</span>-->
                  <span class="acea-row">
                    退款凭证：
                    <template v-if="props.row.refundReasonWapImg">
                      <div
                        v-for="(item, index) in props.row.refundReasonWapImg.split(',')"
                        :key="index"
                        class="demo-image__preview"
                        style="width: 35px; height: auto; display: inline-block"
                      >
                        <el-image :src="item" :preview-src-list="[item]" />
                      </div>
                    </template>
                    <span v-else style="display: inline-block">无</span>
                  </span>
                </div>
                <div v-show="props.row.refundReason" class="pup_card flex-column">
                  <span>拒绝原因：{{ props.row.refundReason }}</span>
                </div>
              </el-form-item>

              <!--<el-form-item v-if="props.row.status === 2" label="快递公司：">-->
              <!--<span>{{ props.row.delivery_type | filterEmpty }}</span>-->
              <!--</el-form-item>-->
              <!--<el-form-item v-if="props.row.status === 2" label="快递单号：">-->
              <!--<span class="mr5">{{ props.row.delivery_id | filterEmpty }}</span>-->
              <!--<el-button type="text" @click="openLogistics(props.row)">物流查询</el-button>-->
              <!--</el-form-item>-->
            </el-form>
          </template>
        </el-table-column>
        <el-table-column label="退款单号" min-width="185" v-if="checkedCities.includes('退款单号')">
          <template slot-scope="scope">
            <span style="display: block" v-text="scope.row.refundOrderNo" />
          </template>
        </el-table-column>
        <el-table-column prop="merOrderNo" label="订单号" min-width="180" v-if="checkedCities.includes('订单号')" />
        <el-table-column prop="realName" label="用户信息" min-width="180" v-if="checkedCities.includes('用户信息')" />
        <el-table-column prop="email" label="用户邮箱" min-width="180" v-if="checkedCities.includes('用户邮箱')" />
        <el-table-column
          prop="refundPrice"
          :label="'退款金额 (' + GLOBAL.shopPayCurrency + ')'"
          min-width="100"
          v-if="checkedCities.includes('退款金额')"
        />
        <el-table-column label="退款状态" min-width="100" v-if="checkedCities.includes('退款状态')">
          <template slot-scope="scope">
            <div v-if="scope.row.refundStatus === 0 || scope.row.refundStatus === 1" class="refunding">
              <template>
                <el-popover trigger="hover" placement="left" :open-delay="500">
                  <b style="color: #f124c7; cursor: pointer" slot="reference">{{
                    scope.row.refundStatus | refundStatusFilter
                  }}</b>
                  <div class="pup_card flex-column">
                    <span>退款原因：{{ scope.row.refundReasonWap }}</span>
                    <span>备注说明：{{ scope.row.refundReasonWapExplain }}</span>
                    <!--<span>退款时间：{{scope.row.refundTime}}</span>-->
                    <span class="acea-row">
                      退款凭证：
                      <template v-if="scope.row.refundReasonWapImg">
                        <div
                          v-for="(item, index) in scope.row.refundReasonWapImg.split(',')"
                          :key="index"
                          class="demo-image__preview"
                          style="width: 35px; height: auto; display: inline-block"
                        >
                          <el-image :src="item" :preview-src-list="[item]" />
                        </div>
                      </template>
                      <span v-else style="display: inline-block">无</span>
                    </span>
                  </div>
                  <div class="pup_card flex-column">
                    <span>拒绝原因：{{ scope.row.refundReason }}</span>
                  </div>
                </el-popover>
              </template>
            </div>
            <span v-else>{{ scope.row.refundStatus | refundStatusFilter }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" min-width="150" v-if="checkedCities.includes('创建时间')" />
        <el-table-column label="操作" min-width="150" fixed="right" align="center" :render-header="renderHeader">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click.native="onOrderDetails(scope.row.merOrderNo)"
              >订单详情</el-button
            >
            <el-button
              type="text"
              size="small"
              v-if="scope.row.refundStatus === 0 && checkPermi(['merchant:refund:order:refuse'])"
              @click.native="onOrderRefuse(scope.row)"
              >拒绝退款</el-button
            >
            <el-button
              type="text"
              size="small"
              v-if="scope.row.refundStatus === 0 && checkPermi(['merchant:refund:order:refund'])"
              @click.native="onOrderRefund(scope.row)"
              >立即退款</el-button
            >
            <el-button
              type="text"
              size="small"
              @click.native="onOrderMark(scope.row)"
              v-if="checkPermi(['merchant:refund:order:mark'])"
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
            >全选
          </el-checkbox>
          <el-button type="text" @click="checkSave()">保存</el-button>
        </div>
        <el-checkbox-group v-model="checkedCities" @change="handleCheckedCitiesChange">
          <el-checkbox v-for="item in columnData" :label="item" :key="item" class="check_cell">{{ item }}</el-checkbox>
        </el-checkbox-group>
      </template>
    </div>

    <!--记录-->
    <el-dialog title="操作记录" :visible.sync="dialogVisibleJI" width="700px">
      <el-table v-loading="LogLoading" border :data="tableDataLog.data" style="width: 100%">
        <el-table-column prop="oid" align="center" label="ID" min-width="80" />
        <el-table-column prop="changeMessage" label="操作记录" align="center" min-width="280" />
        <el-table-column prop="createTime" label="操作时间" align="center" min-width="280" />
      </el-table>
      <div class="block">
        <el-pagination
          :page-sizes="[10, 20, 30, 40]"
          :page-size="tableFromLog.limit"
          :current-page="tableFromLog.page"
          layout="total, sizes, prev, pager, next, jumper"
          :total="tableDataLog.total"
          @size-change="handleSizeChangeLog"
          @current-change="pageChangeLog"
        />
      </div>
    </el-dialog>

    <!--详情-->
    <details-from ref="orderDetail" :orderId="orderId" />

    <!--拒绝退款-->
    <el-dialog
      title="拒绝退款原因"
      v-if="RefuseVisible"
      :visible.sync="RefuseVisible"
      width="500px"
      :before-close="RefusehandleClose"
    >
      <z-b-parser
        :form-id="106"
        :is-create="1"
        :edit-data="RefuseData"
        @submit="RefusehandlerSubmit"
        @resetForm="resetFormRefusehand"
      />
    </el-dialog>

    <!--立即退款-->
    <el-dialog title="退款处理" :visible.sync="refundVisible" width="500px" :before-close="refundhandleClose">
      <z-b-parser
        :form-id="107"
        :is-create="1"
        :edit-data="refundData"
        @submit="refundhandlerSubmit"
        v-if="refundVisible"
        @resetForm="resetFormRefundhandler"
      />
    </el-dialog>
  </div>
</template>

<script>
import {
  refundStatusNumApi,
  refundListApi,
  orderLogApi,
  refundMarkApi,
  orderRefuseApi,
  orderRefundApi,
  orderPrint,
} from '@/api/order';
import detailsFrom from '@/components/orderDetail';
import Cookies from 'js-cookie';
import { isWriteOff } from '@/utils';
import { orderExcelApi } from '@/api/store';
import { checkPermi } from '@/utils/permission';
// 权限判断函数
export default {
  name: 'orderRefund',
  components: {
    detailsFrom,
  },
  data() {
    return {
      RefuseVisible: false,
      RefuseData: {},
      orderId: '',
      refundVisible: false,
      refundData: {},
      dialogVisibleJI: false,
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
      dialogVisible: false,
      tableData: {
        data: [],
        total: 0,
      },
      listLoading: true,
      tableFrom: {
        refundStatus: '9',
        dateLimit: '',
        merOrderNo: '',
        refundOrderNo: '',
        page: 1,
        limit: 20,
      },
      orderChartType: {},
      timeVal: [],
      fromList: this.$constants.fromList,
      selectionList: [],
      ids: '',
      orderids: '',
      cardLists: [],
      isWriteOff: isWriteOff(),
      proType: 0,
      active: false,
      card_select_show: false,
      checkAll: false,
      checkedCities: ['退款单号', '订单号', '用户邮箱', '用户信息', '退款金额', '退款状态', '创建时间'],
      columnData: ['退款单号', '订单号', '用户邮箱', '用户信息', '退款金额', '退款状态', '创建时间'],
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
    resetFormRefundhandler() {
      this.refundVisible = false;
    },
    resetFormRefusehand() {
      this.RefuseVisible = false;
    },
    resetForm(formValue) {
      this.dialogVisible = false;
    },
    seachList() {
      this.tableFrom.page = 1;
      this.getList();
      this.getOrderStatusNum();
    },
    // 拒绝退款
    RefusehandleClose() {
      this.RefuseVisible = false;
    },
    onOrderRefuse(row) {
      this.orderids = row.orderNo;
      this.RefuseData = {
        refundOrderNo: row.refundOrderNo,
        reason: '',
      };
      this.RefuseVisible = true;
    },
    RefusehandlerSubmit(formValue) {
      orderRefuseApi({ refundOrderNo: formValue.refundOrderNo, reason: formValue.reason }).then((data) => {
        this.$message.success('操作成功');
        this.RefuseVisible = false;
        this.getList();
      });
    },
    // 立即退款
    refundhandleClose() {
      this.refundVisible = false;
    },
    onOrderRefund(row) {
      this.refundData = {
        orderId: row.refundOrderNo,
        amount: row.refundPrice,
        type: '',
      };
      this.orderids = row.refundOrderNo;
      this.refundVisible = true;
    },
    refundhandlerSubmit(formValue) {
      orderRefundApi({ refundOrderNo: this.orderids }).then((data) => {
        this.$message.success('操作成功');
        this.refundVisible = false;
        this.getList();
      });
    },
    // 详情
    onOrderDetails(id) {
      this.orderId = id;
      this.$refs.orderDetail.getDetail(id);
      this.$refs.orderDetail.dialogVisible = true;
    },
    // 订单记录
    onOrderLog(id) {
      this.dialogVisibleJI = true;
      this.LogLoading = true;
      this.tableFromLog.orderNo = id;
      orderLogApi(this.tableFromLog)
        .then((res) => {
          this.tableDataLog.data = res.list;
          this.tableDataLog.total = res.total;
          this.LogLoading = false;
        })
        .catch(() => {
          this.LogLoading = false;
        });
    },
    pageChangeLog(page) {
      this.tableFromLog.page = page;
      this.onOrderLog();
    },
    handleSizeChangeLog(val) {
      this.tableFromLog.limit = val;
      this.onOrderLog();
    },
    handleClose() {
      this.dialogVisible = false;
    },
    // 备注
    onOrderMark(row) {
      this.$prompt('退款单备注', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        inputErrorMessage: '请输入退款单备注',
        inputType: 'textarea',
        inputValue: row.merRemark,
        inputPlaceholder: '请输入退款单备注',
        inputValidator: (value) => {
          if (!value) return '输入不能为空';
        },
      })
        .then(({ value }) => {
          refundMarkApi({ remark: value, refundOrderNo: row.refundOrderNo }).then(() => {
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
      refundListApi(this.tableFrom)
        .then((res) => {
          this.tableData.data = res.list || [];
          this.tableData.total = res.total;
          this.listLoading = false;
          this.checkedCities = this.$cache.local.has('refund_order_stroge')
            ? this.$cache.local.getJSON('refund_order_stroge')
            : this.checkedCities;
        })
        .catch(() => {
          this.listLoading = false;
        });
    },
    // 获取各状态数量
    getOrderStatusNum() {
      refundStatusNumApi({ dateLimit: this.tableFrom.dateLimit }).then((res) => {
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
        refundStatus: this.tableFrom.status,
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
      this.$cache.local.setJSON('refund_order_stroge', this.checkedCities);
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
.red {
  color: #ed4014;
}
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
