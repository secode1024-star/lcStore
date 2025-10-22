<template>
  <div class="divBox">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <el-tabs v-model="activeName" @tab-click="handleClick">
          <el-tab-pane label="日账单" name="day"></el-tab-pane>
          <el-tab-pane label="月账单" name="month"></el-tab-pane>
        </el-tabs>
        <div v-if="activeName === 'day'">
          <el-date-picker
            v-model="timeVal"
            align="right"
            unlink-panels
            value-format="yyyy-MM-dd"
            format="yyyy-MM-dd"
            type="daterange"
            placement="bottom-end"
            placeholder="自定义时间"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            class="selWidth"
            :picker-options="pickerOptions"
            @change="onchangeTime"
          />
        </div>
        <div v-else>
          <el-date-picker
            v-model="timeVal"
            type="monthrange"
            align="right"
            unlink-panels
            value-format="yyyy-MM"
            format="yyyy-MM"
            @change="onchangeTime"
            range-separator="至"
            start-placeholder="开始月份"
            end-placeholder="结束月份"
            :picker-options="pickerOptionsYear"
          >
          </el-date-picker>
        </div>
      </div>
      <el-table v-loading="listLoading" :data="tableData.data" style="width: 100%" size="small" highlight-current-row>
        <el-table-column prop="id" label="ID" min-width="90" />
        <el-table-column prop="dataDate" :label="activeName === 'day' ? '日期' : '月份'" min-width="150" />
        <el-table-column prop="incomeExpenditure" label="商户收支" min-width="100" />
        <el-table-column prop="handlingFee" :label="'手续费 (' + GLOBAL.shopPayCurrency + ')'" min-width="150" />

        <el-table-column
          prop="orderPayAmount"
          :label="'订单支付总金额 (' + GLOBAL.shopPayCurrency + ')'"
          min-width="140"
        />
        <el-table-column label="操作" min-width="200" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="onDetails(scope.row)">详情</el-button>
            <!--<el-button type="text" size="small" @click="downloadAccounts(scope.row.time)">下载账单</el-button>-->
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
    <el-dialog
      :title="activeName === 'day' ? '日账单详情' : '月账单详情'"
      :visible.sync="dialogVisible"
      width="830px"
      :before-close="handleClose"
      center
    >
      <el-row align="middle" class="ivu-mt mt20">
        <el-col :span="4">
          <el-menu default-active="0" class="el-menu-vertical-demo">
            <el-menu-item :name="accountDetails.dataDate">
              <span>{{ accountDetails.dataDate }}</span>
            </el-menu-item>
          </el-menu>
        </el-col>
        <el-col :span="20">
          <el-col :span="8">
            <div class="grid-content">
              <span class="title">订单收入金额</span>
              <span class="color_gray">{{ GLOBAL.shopPayCurrency }}{{ accountDetails.orderIncomeAmount }}</span>
              <span class="count">{{ accountDetails.orderNum }}笔</span>
              <div class="list">
                <el-row class="item">
                  <el-col :span="12" class="name">订单支付金额</el-col>
                  <el-col :span="12" class="cost">
                    <span class="cost_num">{{ GLOBAL.shopPayCurrency }}{{ accountDetails.orderPayAmount }}</span>
                  </el-col>
                </el-row>
                <el-row class="item">
                  <el-col :span="12" class="name">平台手续费</el-col>
                  <el-col :span="12" class="cost">
                    <span class="cost_num">-{{ GLOBAL.shopPayCurrency }}{{ accountDetails.handlingFee }}</span>
                  </el-col>
                </el-row>
              </div>
            </div>
            <el-divider direction="vertical" />
          </el-col>
          <el-col :span="8">
            <div class="grid-content">
              <span class="title">支出总金额</span>
              <span class="color_gray">{{ GLOBAL.shopPayCurrency }}{{ accountDetails.payoutAmount }}</span>
              <span class="count">{{ accountDetails.payoutNum }}笔</span>
              <div class="list">
                <el-row class="item">
                  <el-col :span="12" class="name">商户退款金额</el-col>
                  <el-col :span="12" class="cost">
                    <span class="cost_num">{{ GLOBAL.shopPayCurrency }}{{ accountDetails.refundAmount }}</span>
                    <span class="cost_count">{{ accountDetails.refundNum }}笔</span>
                  </el-col>
                </el-row>
              </div>
            </div>
            <el-divider direction="vertical" />
          </el-col>
          <el-col :span="6">
            <div class="grid-content">
              <span class="title">{{ activeName === 'day' ? '当日收支' : '当月收支' }}</span>
              <span class="color_red">{{ GLOBAL.shopPayCurrency }}{{ accountDetails.incomeExpenditure }}</span>
            </div>
          </el-col>
        </el-col>
      </el-row>
      <span slot="footer" class="dialog-footer">
        <el-button type="primary" size="small" @click="dialogVisible = false">我知道了</el-button>
      </span>
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
import { monthStatementApi, dayStatementApi } from '@/api/accounts';
import yearOptions from '@/libs/yearOptions';
export default {
  name: 'statement',
  data() {
    return {
      timeVal: [],
      activeName: 'day',
      listLoading: true,
      tableData: {
        data: [],
        total: 0,
      },
      tableFrom: {
        page: 1,
        limit: 20,
        dateLimit: '',
      },
      dialogVisible: false,
      accountDetails: {},
      pickerOptions: this.$timeOptions,
      pickerOptionsYear: yearOptions,
    };
  },
  mounted() {
    this.getList(1);
  },
  methods: {
    // 具体日期
    onchangeTime(e) {
      this.timeVal = e;
      this.tableFrom.dateLimit = e ? this.timeVal.join(',') : '';
      this.getList(1);
    },
    handleClick() {
      this.tableFrom.dateLimit = '';
      this.timeVal = [];
      this.getList(1);
    },
    onDetails(date) {
      this.dialogVisible = true;
      this.accountDetails = date;
    },
    seachList() {
      this.handleClose();
      this.getList(1);
    },
    // 列表
    getList(num) {
      this.listLoading = true;
      this.tableFrom.page = num ? num : this.tableFrom.page;
      this.activeName === 'day'
        ? dayStatementApi(this.tableFrom)
            .then((res) => {
              this.tableData.data = res.list;
              this.tableData.total = res.total;
              this.listLoading = false;
            })
            .catch(() => {
              this.listLoading = false;
            })
        : monthStatementApi(this.tableFrom)
            .then((res) => {
              this.tableData.data = res.list;
              this.tableData.total = res.total;
              this.listLoading = false;
            })
            .catch(() => {
              this.listLoading = false;
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
    handleClose() {
      this.dialogVisible = false;
    },
    // 删除
    handleDelete(id, idx) {
      this.$modalSure().then(() => {
        storeApi.brandDeleteApi(id).then((res) => {
          this.$message.success('删除成功');
          this.$store.commit('merchant/SET_MerchantClassify', []);
          this.getList();
        });
      });
    },
    onchangeIsShow(row) {
      activityApi.activitySwitchApi(row.id).then((res) => {
        this.$message.success('操作成功');
        this.getList();
      });
    },
  },
};
</script>

<style lang="scss" scoped>
.divBox {
  ::v-deep.el-date-range-picker,
  ::v-deep.has-sidebar {
    /*position: relative;*/
    /*top: 209px;*/
    /*left: 0px;*/
    /*z-index: 9;*/
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
  width: 60%;
  font-size: 12px !important;
  margin: 0 2px 0 10px;
  letter-spacing: 1px;
  padding: 5px 0;
  box-sizing: border-box;
}
.el-menu-item {
  font-weight: bold;
  color: #333;
}
::v-deep.el-dialog__header {
  text-align: left;
}
.el-col {
  position: relative;
  .el-divider--vertical {
    position: absolute;
    height: 100%;
    right: 0;
    top: 0;
    margin: 0;
  }
}
.grid-content {
  padding: 0 15px;
  display: block;
  .title,
  .color_red,
  .color_gray {
    display: block;
    line-height: 20px;
  }
  .color_red {
    color: red;
    font-weight: bold;
  }
  .color_gray {
    color: #333;
    font-weight: bold;
  }
  .count {
    font-size: 12px;
  }
  .list {
    margin-top: 20px;
    .item {
      overflow: hidden;
      margin-bottom: 10px;
    }
    .name,
    .cost {
      line-height: 20px;
    }
    .cost {
      text-align: right;
      span {
        display: block;
      }
    }
    .name,
    .cost_count {
      font-size: 12px;
    }
    .cost_count {
      margin-top: 10px;
    }
    .cost_num {
      font-weight: bold;
      color: #333;
    }
  }
}
</style>
