<template>
  <div class="divBox">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <div class="container">
          <el-form size="small" inline label-width="100px">
            <span class="seachTiele">时间选择：</span>
            <el-radio-group
              v-model="tableFrom.dateLimit"
              type="button"
              class="mr20"
              size="small"
              @change="selectChange(tableFrom.dateLimit)"
            >
              <el-radio-button v-for="(item, i) in fromList.fromTxt" :key="i" :label="item.val">{{
                item.text
              }}</el-radio-button>
            </el-radio-group>
            <el-date-picker
              v-model="timeVal"
              value-format="yyyy-MM-dd"
              format="yyyy-MM-dd"
              size="small"
              type="daterange"
              placement="bottom-end"
              placeholder="自定义时间"
              style="width: 250px"
              @change="onchangeTime"
            />
            <div class="mt20">
              <span class="seachTiele">关键字：</span>
              <el-input v-model="tableFrom.orderNo" placeholder="请输入订单号/退款单号" class="selWidth mr20" />
              <el-button size="small" type="primary" icon="el-icon-search" @click="getList">查询</el-button>
              <!--<el-button size="small" type="primary" icon="el-icon-top" @click="exportRecord">列表导出</el-button>-->
              <!--<el-button size="small" type="primary" @click="getExportFileList">导出记录</el-button>-->
            </div>
          </el-form>
        </div>
      </div>
      <el-table v-loading="listLoading" :data="tableData.data" style="width: 100%" size="mini">
        <el-table-column prop="id" label="ID" min-width="60" />
        <el-table-column prop="orderNo" label="订单号" min-width="230" />
        <el-table-column prop="nickName" label="对方信息" min-width="100" :show-overflow-tooltip="true">
          <template slot-scope="scope">
            <span>{{ scope.row.nickName }} | {{ scope.row.uid }}</span>
          </template>
        </el-table-column>
        <el-table-column label="交易类型" min-width="100">
          <template slot-scope="scope">
            <span>{{ scope.row.type | transactionTypeFilter }}</span>
          </template>
        </el-table-column>
        <el-table-column label="金额" min-width="100">
          <template slot-scope="scope">
            <span>{{ scope.row.pm === 1 ? scope.row.amount : -scope.row.amount }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="mark" label="备注" min-width="150" :show-overflow-tooltip="true" />
        <el-table-column prop="createTime" label="交易时间" min-width="100" :show-overflow-tooltip="true" />
        <el-table-column label="操作" min-width="70" fixed="right">
          <template slot-scope="scope">
            <el-button
              type="text"
              size="small"
              class="mr10"
              @click.native="onOrderDetails(scope.row.id)"
              v-hasPermi="['platform:finance:monitor:info']"
              >详情
            </el-button>
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

    <!--详情-->
    <el-dialog v-if="dialogVisible" title="转账信息:" :visible.sync="dialogVisible" width="1000px">
      <el-table v-loading="infolistLoading" :data="tableDataLog.data" style="width: 100%" size="mini">
        <el-table-column prop="merId" label="商户ID" min-width="60" />
        <el-table-column prop="orderNo" label="关联订单" min-width="230" />
        <el-table-column prop="nickName" label="商户名称" min-width="130" :show-overflow-tooltip="true">
          <template slot-scope="scope">
            <span>{{ scope.row.merName }}</span>
          </template>
        </el-table-column>
        <el-table-column label="流水类型" min-width="100">
          <template slot-scope="scope">
            <span>{{ scope.row.type | transactionTypeFilter }}</span>
          </template>
        </el-table-column>
        <el-table-column label="金额" min-width="100">
          <template slot-scope="scope">
            <span>{{ scope.row.pm === 1 ? scope.row.amount : -scope.row.amount }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="mark" label="备注" min-width="150" :show-overflow-tooltip="true" />
        <el-table-column prop="createTime" label="交易时间" min-width="100" :show-overflow-tooltip="true" />
      </el-table>
    </el-dialog>
    <!--导出订单列表-->
    <!--<file-list ref="exportList" />-->
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
import { capitalFlowLstApi, capitalFlowExportApi, getStatisticsApi, financeInfoApi } from '@/api/financial';
//import detailsFrom from '@/views/order/orderDetail'
import { checkPermi } from '@/utils/permission'; // 权限判断函数
export default {
  data() {
    return {
      tableData: {
        data: [],
        total: 0,
      },
      listLoading: true,
      tableFrom: {
        orderNo: '',
        dateLimit: '',
        page: 1,
        limit: 20,
      },
      timeVal: [],
      fromList: this.$constants.fromList,
      ids: '',
      tableFromLog: {
        page: 1,
        limit: 10,
      },
      tableDataLog: {
        data: [],
      },
      LogLoading: false,
      dialogVisible: false,
      infolistLoading: false,
      evaluationStatusList: [
        { value: 1, label: '已回复' },
        { value: 0, label: '未回复' },
      ],
      orderDatalist: null,
    };
  },
  mounted() {
    this.getList();
  },
  methods: {
    checkPermi,
    // 详情
    onOrderDetails(id) {
      this.infolistLoading = true;
      financeInfoApi(id)
        .then((res) => {
          this.tableDataLog.data = res;
          this.infolistLoading = false;
        })
        .catch((res) => {
          this.infolistLoading = false;
        });
      this.dialogVisible = true;
    },
    // 选择时间
    selectChange(tab) {
      this.tableFrom.dateLimit = tab;
      this.timeVal = [];
      this.getList();
    },
    // 具体日期
    onchangeTime(e) {
      this.timeVal = e;
      this.tableFrom.dateLimit = e ? this.timeVal.join(',') : '';
      this.getList();
    },
    // 导出
    exportRecord() {
      capitalFlowExportApi(this.tableFrom)
        .then((res) => {
          const h = this.$createElement;
          this.$msgbox({
            title: '提示',
            message: h('p', null, [
              h('span', null, '文件正在生成中，请稍后点击"'),
              h('span', { style: 'color: teal' }, '导出记录'),
              h('span', null, '"查看~ '),
            ]),
            confirmButtonText: '我知道了',
          }).then((action) => {});
        })
        .catch((res) => {
          this.$message.error(res.message);
        });
    },
    // 导出列表
    getExportFileList() {
      this.$refs.exportList.exportFileList();
    },
    // 列表
    getList() {
      this.listLoading = true;
      capitalFlowLstApi(this.tableFrom)
        .then((res) => {
          this.tableData.data = res.list;
          this.tableData.total = res.total;
          this.listLoading = false;
        })
        .catch((res) => {
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
  },
};
</script>

<style lang="scss" scoped>
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
.mt20 {
  margin-top: 20px;
}
.demo-image__preview {
  position: relative;
  padding-left: 40px;
}
.demo-image__preview .el-image,
.el-image__error {
  position: absolute;
  left: 0;
}
.maxw180 {
  display: inline-block;
  max-width: 180px;
}
</style>
