<template>
  <div class="divBox">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <div class="container">
          <el-form size="small" inline label-width="100px">
            <el-form-item label="时间选择：" class="width100" style="display: block">
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
                start-placeholder="开始日期"
                end-placeholder="结束日期"
                style="width: 250px"
                @change="onchangeTime"
              />
            </el-form-item>
            <el-form-item label="审核状态：">
              <el-radio-group v-model="tableFrom.auditStatus" type="button" @change="getList(1)">
                <el-radio-button label="">全部 </el-radio-button>
                <el-radio-button label="0">待审核</el-radio-button>
                <el-radio-button label="1">已审核</el-radio-button>
                <el-radio-button label="2">审核失败</el-radio-button>
              </el-radio-group>
            </el-form-item>
            <el-form-item label="到账状态：">
              <el-select
                v-model="tableFrom.transferStatus"
                placeholder="请选择"
                class="filter-item selWidth mr20"
                clearable
                @change="getList(1)"
              >
                <el-option
                  v-for="item in arrivalStatusList"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                />
              </el-select>
            </el-form-item>
            <br />
            <el-form-item label="关键字：" class="width100">
              <el-input
                v-model="tableFrom.keyword"
                @keyup.enter.native="getList(1)"
                placeholder="请输入管理员姓名"
                class="selWidth"
                size="small"
              >
                <el-button
                  slot="append"
                  icon="el-icon-search"
                  size="small"
                  class="el-button-solt"
                  @click="getList(1)"
                />
              </el-input>
              <!--<el-button size="small" type="primary" icon="el-icon-top" @click="exportRecord">列表导出</el-button>-->
              <!--<el-button size="small" type="primary" @click="getExportFileList">导出记录</el-button>-->
            </el-form-item>
            <el-button style="display: block" size="small" type="primary" @click="applyTransfer"> 申请转账 </el-button>
          </el-form>
        </div>
      </div>
      <el-table v-loading="listLoading" tooltip-effect="dark" :data="tableData.data" style="width: 100%" class="table">
        <el-table-column prop="id" label="ID" min-width="60" />
        <el-table-column prop="amount" :label="'转账金额 (' + GLOBAL.shopPayCurrency + ')'" min-width="120" />
        <el-table-column label="审核员姓名" min-width="120" :show-overflow-tooltip="true">
          <template slot-scope="scope">
            <span>{{ scope.row.auditName | filterEmpty }}</span>
          </template>
        </el-table-column>
        <el-table-column label="转账类型" min-width="100">
          <template slot-scope="scope">
            <span>{{ scope.row.transferType | transferTypeFilter }}</span>
          </template>
        </el-table-column>

        <el-table-column label="审核状态" min-width="120">
          <template slot-scope="scope">
            <span>{{
              scope.row.auditStatus == 0 ? '待审核' : scope.row.auditStatus == 1 ? '审核通过' : '审核失败'
            }}</span>
            <span v-if="scope.row.auditStatus === 2 && scope.row.refusal" style="font-size: 12px">
              <br />
              原因：{{ scope.row.refusal }}
            </span>
          </template>
        </el-table-column>
        <el-table-column label="到账状态" min-width="120">
          <template slot-scope="scope">
            <span>{{ scope.row.transferStatus == 1 ? '已到账' : '未到账' }}</span>
          </template>
        </el-table-column>
        <el-table-column label="审核时间" min-width="120" :show-overflow-tooltip="true">
          <template slot-scope="scope">
            <span>{{ scope.row.auditTime | filterEmpty }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="申请时间" min-width="120" :show-overflow-tooltip="true" />
        <el-table-column label="操作" min-width="70" fixed="right" align="center">
          <template slot-scope="scope">
            <el-button
              type="text"
              size="small"
              v-hasPermi="['merchant:finance:transfer:base:info']"
              @click="transferDetail(scope.row.id)"
              >转账信息</el-button
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
    <!--转账信息-->
    <el-dialog v-if="dialogVisible" title="转账信息:" :visible.sync="dialogVisible" width="700px">
      <div class="box-container" v-loading="loading">
        <div class="acea-row">
          <div class="list sp100">
            <label class="name">{{ '转账金额 (' + GLOBAL.shopPayCurrency + ')' }}：</label>{{ transferData.amount }}
          </div>
          <div class="list sp100">
            <label class="name">商户收款方式：</label>{{ transferData.transferType | transferTypeFilter }}
          </div>
          <template v-if="transferData.transferType === 'bank'">
            <div class="list sp100"><label class="name">开户银行：</label>{{ transferData.transferBank }}</div>
            <div class="list sp100"><label class="name">银行账号：</label>{{ transferData.transferBankCard }}</div>
            <div class="list sp100"><label class="name">开户户名：</label>{{ transferData.transferName }}</div>
          </template>

          <div class="list sp100">
            <label class="name">审核状态：</label
            >{{ transferData.auditStatus == 0 ? '待审核' : transferData.auditStatus == 1 ? '已审核' : '审核失败' }}
          </div>
          <div v-if="transferData.auditStatus == 1 && transferData.auditTime" class="list sp100">
            <label class="name">审核时间：</label>{{ transferData.auditTime }}
          </div>
          <div v-if="transferData.auditStatus == 1" class="list sp100">
            <label class="name">转账凭证：</label>
            <div v-if="transferData.transferProof" class="acea-row">
              <div v-for="(item, index) in JSON.parse(transferData.transferProof)" :key="index" class="pictrue">
                <img @click="getPicture(item)" :src="item" />
              </div>
            </div>
          </div>
          <div v-if="transferData.auditStatus == 1 && transferData.transferTime" class="list sp100">
            <label class="name">转账时间：</label>{{ transferData.transferTime }}
          </div>
          <div v-if="transferData.auditStatus == 2 && transferData.refusalReason" class="list sp100">
            <label class="name">审核未通过原因：</label>{{ transferData.refusalReason }}
          </div>
          <div class="list sp100" v-show="transferData.mark">
            <label class="name">商户备注：</label>{{ transferData.mark }}
          </div>
        </div>
      </div>
    </el-dialog>
    <!--申请转账-->
    <el-dialog v-if="transferDialogVisible" title="申请转账:" :visible.sync="transferDialogVisible" width="700px">
      <div class="box-container" v-loading="loadingBaseInfo">
        <div class="acea-row">
          <div class="list el-form-item el-form-item--mini sp100">
            <label class="el-form-item__label wid100">{{ '商户余额 (' + GLOBAL.shopPayCurrency + ')' }}：</label>
            <div class="el-form-item__content ml100">
              {{ transferBaseInfo.balance }}
            </div>
          </div>
          <div class="list el-form-item el-form-item--mini sp100">
            <label class="el-form-item__label wid100">{{ '可提现金额 (' + GLOBAL.shopPayCurrency + ')' }}：</label>
            <div class="el-form-item__content ml100">
              {{ transferBaseInfo.transferBalance }}
            </div>
          </div>
          <div class="list el-form-item el-form-item--mini sp100">
            <label class="el-form-item__label wid100">{{ '保证金额 (' + GLOBAL.shopPayCurrency + ')' }}：</label>
            <div class="el-form-item__content ml100">
              {{ transferBaseInfo.guaranteedAmount }}
            </div>
          </div>
          <div class="list el-form-item el-form-item--mini sp100">
            <label class="el-form-item__label wid100">转账类型：</label>
            <div class="el-form-item__content ml100">
              {{ transferBaseInfo.transferType | transferTypeFilter }}
            </div>
          </div>
          <template v-if="transferBaseInfo.transferType === 'bank'">
            <div class="list el-form-item el-form-item--mini sp100">
              <label class="el-form-item__label wid100">开户户名：</label>
              <div class="el-form-item__content ml100">
                {{ transferBaseInfo.transferName }}
              </div>
            </div>
            <div class="list el-form-item el-form-item--mini sp100">
              <label class="el-form-item__label wid100">开户银行：</label>
              <div class="el-form-item__content ml100">
                {{ transferBaseInfo.transferBank }}
              </div>
            </div>
            <div class="list el-form-item el-form-item--mini sp100">
              <label class="el-form-item__label wid100">银行账号：</label>
              <div class="el-form-item__content ml100">
                {{ transferBaseInfo.transferBankCard }}
              </div>
            </div>
          </template>
          <el-form ref="baseInfoform" :model="baseInfoform" label-width="100px" size="mini">
            <el-form-item
              :label="'申请金额 (' + GLOBAL.shopPayCurrency + ')'"
              :rules="[{ required: true, message: '请输入申请金额', trigger: 'blur' }]"
            >
              <el-input-number v-model="baseInfoform.amount" :min="1" :max="99999"></el-input-number>
            </el-form-item>
            <el-form-item label="金额说明：" class="transferMinAmount">
              <el-alert
                effect="dark"
                :closable="false"
                :title="`最低可提现额度${transferBaseInfo.transferMinAmount}${GLOBAL.shopPayCurrency}; 最高可提现额度${transferBaseInfo.transferMaxAmount}${GLOBAL.shopPayCurrency}`"
                type="warning"
              >
              </el-alert>
            </el-form-item>
            <el-form-item label="备注">
              <el-input v-model="baseInfoform.mark" type="textarea" :rows="2"></el-input>
            </el-form-item>
            <el-form-item>
              <el-button
                :disabled="
                  parseFloat(transferBaseInfo.transferBalance) < parseFloat(transferBaseInfo.transferMinAmount)
                "
                type="primary"
                @click="submitForm('baseInfoform')"
                :loading="btnLoading"
                >立即申请</el-button
              >
            </el-form-item>
          </el-form>
        </div>
      </div>
    </el-dialog>
    <!--查看二维码-->
    <el-dialog v-if="pictureVisible" :visible.sync="pictureVisible" width="700px">
      <img :src="pictureUrl" class="pictures" />
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
import {
  transferLstApi,
  transferBaseInfoApi,
  applyTransferApi,
  transferDetailApi,
  transferRecordsExportApi,
} from '@/api/accounts';
export default {
  name: 'transferAccount',
  data() {
    return {
      tableData: {
        data: [],
        total: 0,
      },
      arrivalStatusList: [
        { label: '已到账', value: 1 },
        { label: '未到账', value: 0 },
      ],
      listLoading: true,
      tableFrom: {
        dateLimit: '',
        page: 1,
        limit: 20,
        keyword: '',
        auditStatus: '',
        transferStatus: '',
      },
      timeVal: [],
      fromList: this.$constants.fromList,
      loading: false,
      dialogVisible: false,
      pictureVisible: false,
      transferData: {},
      transferDialogVisible: false,
      loadingBaseInfo: false,
      transferBaseInfo: {},
      baseInfoform: {
        amount: 0,
        mark: '',
        transferType: '',
      },
      btnLoading: false,
    };
  },
  mounted() {
    this.getList(1);
  },
  methods: {
    // 转账信息
    transferDetail(id) {
      this.dialogVisible = true;
      this.loading = true;
      transferDetailApi(id)
        .then((res) => {
          this.transferData = res;
          this.loading = false;
        })
        .catch((res) => {
          this.loading = false;
        });
    },
    // 查看图片
    getPicture(url) {
      this.pictureVisible = true;
      this.pictureUrl = url;
    },
    submitForm(formName) {
      this.baseInfoform.transferType = this.transferBaseInfo.transferType || 'bank';
      if (parseFloat(this.baseInfoform.amount) > parseFloat(this.transferBaseInfo.transferMaxAmount))
        return this.$message.warning(`最高提现额度为${this.transferBaseInfo.transferMaxAmount},请修改提现金额`);
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.btnLoading = true;
          applyTransferApi(this.baseInfoform)
            .then((res) => {
              this.$message.success('申请成功');
              this.btnLoading = false;
              this.transferDialogVisible = false;
              this.getList(1);
            })
            .catch(() => {
              this.btnLoading = false;
            });
        } else {
          return false;
        }
      });
    },
    // 申请转账
    applyTransfer() {
      this.loadingBaseInfo = true;
      this.transferDialogVisible = true;
      transferBaseInfoApi()
        .then((res) => {
          this.transferBaseInfo = res;
          this.loadingBaseInfo = false;
        })
        .catch(() => {
          this.loadingBaseInfo = false;
        });
    },
    // 选择时间
    selectChange(tab) {
      this.tableFrom.dateLimit = tab;
      this.timeVal = [];
      this.getList(1);
    },
    // 具体日期
    onchangeTime(e) {
      this.timeVal = e;
      this.tableFrom.dateLimit = e ? this.timeVal.join(',') : '';
      this.getList(1);
    },
    // 导出
    exportRecord() {
      transferRecordsExportApi(this.tableFrom)
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
    getList(num) {
      this.listLoading = true;
      this.tableFrom.page = num ? num : this.tableFrom.page;
      transferLstApi(this.tableFrom)
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
      this.getList('');
    },
    handleSizeChange(val) {
      this.tableFrom.limit = val;
      this.getList('');
    },

    handleClose() {
      this.dialogLogistics = false;
    },
  },
};
</script>

<style lang="scss" scoped>
.wid100 {
  width: 120px;
}
.ml100 {
  margin-left: 100px;
}
.transferMinAmount {
  ::v-deep.el-form-item__content {
    line-height: normal;
  }
}
::v-deep .el-dialog__title {
  font-weight: bold;
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
.font-red {
  color: #ff4949;
}
.tabBox_tit {
  width: 60%;
  font-size: 12px !important;
  margin: 0 2px 0 10px;
  letter-spacing: 1px;
  padding: 5px 0;
  box-sizing: border-box;
}
.pictrue {
  width: 60px;
  height: 60px;
  border: 1px dotted rgba(0, 0, 0, 0.1);
  margin-right: 10px;
  position: relative;
  cursor: pointer;
  img {
    width: 100%;
    height: 100%;
  }
}
.box-container {
  overflow: hidden;
  padding: 0 10px;
}

.box-container .list.image {
  margin: 20px 0;
  position: relative;
}
.box-container .list.image img {
  position: absolute;
  top: -20px;
}
.box-container .list {
  float: left;
  line-height: 40px;
}
.box-container .sp100 {
  width: 100%;
}

.acea-row {
  margin-bottom: 25px;
}
</style>
