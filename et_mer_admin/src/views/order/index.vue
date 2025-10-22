<template>
  <div class="divBox relative">
    <el-card class="box-card">
      <div class="clearfix">
        <div class="container">
          <el-form size="small" label-width="100px">
            <el-form-item label="订单状态：" v-if="checkPermi(['merchant:order:status:num'])">
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
            return row.orderNo;
          }
        "
      >
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
        <el-table-column prop="realName" label="收货人" min-width="100" v-if="checkedCities.includes('收货人')" />
        <el-table-column
          prop="payPrice"
          :label="'实际支付 (' + GLOBAL.shopPayCurrency + ')'"
          min-width="100"
          v-if="checkedCities.includes('实际支付')"
        />
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
        <el-table-column prop="createTime" label="下单时间" min-width="150" v-if="checkedCities.includes('下单时间')" />
        <el-table-column label="操作" min-width="150" fixed="right" align="center" :render-header="renderHeader">
          <template slot-scope="scope">
            <el-button
              v-if="scope.row.status === 0 && scope.row.paid && checkPermi(['merchant:order:send'])"
              type="text"
              size="small"
              class="mr10"
              @click="sendOrder(scope.row)"
              >发货
            </el-button>
            <el-button
              v-if="!scope.row.paid && scope.row.status === 0 && checkPermi(['merchant:order:status:update'])"
              type="text"
              size="small"
              class="mr10"
              @click="updateOrderStatus(scope.row)"
              style="color: #67C23A;"
              >修改状态
            </el-button>
            <el-button
              type="text"
              size="small"
              class="mr10"
              @click.native="onOrderDetails(scope.row.orderNo)"
              v-if="checkPermi(['merchant:order:info'])"
              >订单详情
            </el-button>
            <el-dropdown trigger="click">
              <span class="el-dropdown-link"> 更多<i class="el-icon-arrow-down el-icon--right" /> </span>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item @click.native="onOrderMark(scope.row)" v-if="checkPermi(['merchant:order:mark'])"
                  >订单备注
                </el-dropdown-item>
                <el-dropdown-item
                  v-if="scope.row.isUserDel === 1 && checkPermi(['merchant:order:delete'])"
                  @click.native="handleDelete(scope.row, scope.$index)"
                  >删除订单
                </el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
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
          <el-button size="small" type="text" @click="checkSave()">保存</el-button>
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

    <!-- 发送货 -->
    <order-send ref="send" :orderId="orderId" @submitFail="getList"></order-send>

    <!-- 修改订单状态 -->
    <el-dialog title="修改订单状态" :visible.sync="statusDialogVisible" width="500px" :close-on-click-modal="false">
      <div style="margin-bottom: 20px;">
        <p><strong>订单号：</strong>{{ currentOrder.orderNo }}</p>
        <p><strong>当前状态：</strong>
          <span v-if="!currentOrder.paid" style="color: #E6A23C;">未支付</span>
          <span v-else-if="currentOrder.status === 0" style="color: #409EFF;">待发货</span>
          <span v-else-if="currentOrder.status === 1" style="color: #67C23A;">待收货</span>
        </p>
      </div>
      
      <el-form :model="statusForm" :rules="statusRules" ref="statusForm" label-width="120px">
        <el-form-item label="目标状态" prop="targetStatus">
          <el-radio-group v-model="statusForm.targetStatus">
            <el-radio label="paid">标记为已支付(待发货)</el-radio>
            <el-radio label="shipped">标记为已发货(待收货)</el-radio>
          </el-radio-group>
        </el-form-item>
        
        <el-form-item label="操作备注" prop="remark">
          <el-input
            type="textarea"
            v-model="statusForm.remark"
            placeholder="请输入状态修改原因，如：客户已线下支付"
            :rows="3"
            maxlength="200"
            show-word-limit>
          </el-input>
        </el-form-item>
      </el-form>
      
      <div slot="footer" class="dialog-footer">
        <el-button @click="statusDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="confirmUpdateStatus" :loading="statusUpdateLoading">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {
  orderStatusNumApi,
  orderListApi,
  orderLogApi,
  orderMarkApi,
  orderDeleteApi,
  orderRefundApi,
  orderPrint,
  updateOrderStatusApi,
} from '@/api/order';
import detailsFrom from '@/components/orderDetail';
import orderSend from './orderSend';
import Cookies from 'js-cookie';
import { isWriteOff } from '@/utils';
import { orderExcelApi } from '@/api/store';
import { checkPermi } from '@/utils/permission'; // 权限判断函数
export default {
  name: 'orderlistDetails',
  components: {
    detailsFrom,
    orderSend,
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
        status: 'all',
        dateLimit: '',
        orderNo: '',
        page: 1,
        limit: 20,
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
      checkedCities: ['订单号', '主订单号', '收货人', '实际支付', '支付方式', '订单状态', '下单时间'],
      columnData: ['订单号', '主订单号', '收货人', '实际支付', '支付方式', '订单状态', '下单时间'],
      isIndeterminate: true,
      // 订单状态修改相关
      statusDialogVisible: false,
      currentOrder: {},
      statusUpdateLoading: false,
      statusForm: {
        targetStatus: 'paid',
        remark: ''
      },
      statusRules: {
        targetStatus: [
          { required: true, message: '请选择目标状态', trigger: 'change' }
        ],
        remark: [
          { required: true, message: '请输入操作备注', trigger: 'blur' },
          { min: 5, max: 200, message: '备注长度在 5 到 200 个字符', trigger: 'blur' }
        ]
      }
    };
  },
  mounted() {
    this.getList();
    this.getOrderStatusNum();
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
    // 发送
    sendOrder(row) {
      this.$refs.send.modals = true;
      this.$refs.send.getList();
      this.orderId = row.orderNo;
    },
    // 订单删除
    handleDelete(row, idx) {
      if (row.isDel) {
        this.$modalSure().then(() => {
          orderDeleteApi({ orderNo: row.orderNo }).then(() => {
            this.$message.success('删除成功');
            this.tableData.data.splice(idx, 1);
          });
        });
      } else {
        this.$confirm('您选择的的订单存在用户未删除的订单，无法删除用户未删除的订单！', '提示', {
          confirmButtonText: '确定',
          type: 'error',
        });
      }
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
      this.$prompt('订单备注', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        inputErrorMessage: '请输入订单备注',
        inputType: 'textarea',
        inputValue: row.merRemark,
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
    
    // 修改订单状态
    updateOrderStatus(row) {
      this.currentOrder = { ...row };
      this.statusForm = {
        targetStatus: 'paid',
        remark: ''
      };
      this.statusDialogVisible = true;
      this.$nextTick(() => {
        this.$refs.statusForm.clearValidate();
      });
    },
    
    // 确认修改状态
    confirmUpdateStatus() {
      this.$refs.statusForm.validate((valid) => {
        if (valid) {
          this.statusUpdateLoading = true;
          
          const requestData = {
            orderNo: this.currentOrder.orderNo,
            targetStatus: this.statusForm.targetStatus,
            remark: this.statusForm.remark
          };
          
          updateOrderStatusApi(requestData)
            .then(() => {
              this.$message.success('订单状态修改成功！');
              this.statusDialogVisible = false;
              this.getList(); // 刷新列表
              this.getOrderStatusNum(); // 刷新状态统计
            })
            .catch((error) => {
              this.$message.error('修改失败：' + (error.message || '请重试'));
            })
            .finally(() => {
              this.statusUpdateLoading = false;
            });
        }
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
    },
    // 具体日期
    onchangeTime(e) {
      this.timeVal = e;
      this.tableFrom.dateLimit = e ? this.timeVal.join(',') : '';
      this.tableFrom.page = 1;
      this.getList();
      this.getOrderStatusNum();
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
