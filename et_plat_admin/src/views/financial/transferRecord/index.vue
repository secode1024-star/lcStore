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
                placeholder="自定义时间"
                style="width: 250px"
                @change="onchangeTime"
              />
            </el-form-item>
            <el-form-item label="商户名称：">
              <el-select
                class="selWidth"
                clearable
                filterable
                v-model="tableFrom.merId"
                v-selectLoadMore="selectLoadMore"
                :loading="loading"
                remote
                :remote-method="remoteMethod"
                placeholder="请选择商户"
              >
                <el-option v-for="user in merchantList" :key="user.id" :label="user.name" :value="user.id"> </el-option>
              </el-select>
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
          </el-form>
        </div>
      </div>
      <el-table v-loading="listLoading" tooltip-effect="dark" :data="tableData.data" style="width: 100%" class="table">
        <el-table-column prop="id" label="ID" min-width="60" />
        <el-table-column prop="merName" label="商户名称" min-width="120" />
        <el-table-column prop="amount" label="转账金额" min-width="120" />
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
          </template>
        </el-table-column>
        <el-table-column label="到账状态" min-width="120">
          <template slot-scope="scope">
            <span>{{ scope.row.transferStatus == 1 ? '已转账' : '未转账' }}</span>
          </template>
        </el-table-column>
        <el-table-column label="平台备注" min-width="120" :show-overflow-tooltip="true">
          <template slot-scope="scope">
            <span>{{ scope.row.platformMark | filterEmpty }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="申请时间" min-width="120" :show-overflow-tooltip="true" />
        <el-table-column label="操作" min-width="120" fixed="right" align="center">
          <template slot-scope="scope">
            <el-button
              type="text"
              size="small"
              @click="transferDetail(scope.row.id, 1)"
              v-hasPermi="['platform:finance:transfer:record:info']"
              >转账详情</el-button
            >
            <el-button
              v-show="scope.row.auditStatus === 0"
              type="text"
              size="small"
              v-hasPermi="['platform:finance:transfer:audit']"
              @click="transferDetail(scope.row.id, 2)"
              >审核</el-button
            >
            <el-button
              v-show="scope.row.auditStatus === 1 && scope.row.transferStatus === 0"
              type="text"
              size="small"
              @click="transferDetail(scope.row.id, 3)"
              >转账</el-button
            >
            <el-button
              type="text"
              size="small"
              v-hasPermi="['platform:finance:transfer:remark']"
              @click="onRemark(scope.row)"
              >备注</el-button
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
    <!--转账凭证 审核 详情-->
    <el-drawer direction="rtl" :visible.sync="dialogVisible" size="700px" @close="close">
      <div slot="title" class="title">转账详情</div>
      <div class="box-container" v-loading="loading">
        <div class="acea-row">
          <div class="list sp100"><label class="name">商户名称：</label>{{ transferData.merName }}</div>
          <div class="list sp100"><label class="name">商户流水金额：</label>{{ transferData.amount }}</div>
          <div class="list sp100"><label class="name">商户余额：</label>{{ transferData.balance }}</div>
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
          <div v-if="transferData.auditStatus == 1" class="list sp100">
            <label class="name">审核时间：</label>{{ transferData.auditTime | filterEmpty }}
          </div>
          <div v-if="transferData.transferProof" class="list sp100">
            <label class="name">转账凭证：</label>
            <div class="acea-row">
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
          <div class="list sp100">
            <label class="name">平台备注：</label>{{ transferData.platformMark | filterEmpty }}
          </div>
          <div class="list sp100"><label class="name">商户备注：</label>{{ transferData.mark | filterEmpty }}</div>
        </div>
        <div v-if="isShow !== 1" class="from-foot-btn fix btn-shadow">
          <el-form ref="ruleForm" :model="ruleForm" :rules="rules" label-width="100px" class="demo-ruleForm">
            <template v-if="isShow === 2 && transferData.auditStatus == 0">
              <el-form-item label="审核状态" prop="auditStatus">
                <el-radio-group v-model="ruleForm.auditStatus">
                  <el-radio :label="1">通过</el-radio>
                  <el-radio :label="2">拒绝</el-radio>
                </el-radio-group>
              </el-form-item>
              <el-form-item v-if="ruleForm.auditStatus === 2" label="原因" prop="refusalReason">
                <el-input v-model="ruleForm.refusalReason" type="textarea" placeholder="请输入原因" />
              </el-form-item>
            </template>
            <el-form-item
              label="转账凭证："
              prop="voucher_image"
              v-if="isShow === 3 && transferData.auditStatus === 1 && transferData.transferStatus === 0"
            >
              <div class="acea-row">
                <div class="acea-row" v-if="ruleForm.voucher_image.length > 0">
                  <div v-for="(item, index) in ruleForm.voucher_image" :key="index" class="pictrue">
                    <img :src="item" @click="getPicture(item)" />
                    <i class="el-icon-error btndel" @click="handleRemove(index)" />
                  </div>
                </div>
                <el-upload
                  v-show="ruleForm.voucher_image.length < 6"
                  class="upload-demo"
                  action
                  :http-request="handleUploadForm"
                  :headers="myHeaders"
                  :show-file-list="false"
                  multiple
                >
                  <div class="upLoadPicBox">
                    <div class="upLoad">
                      <i class="el-icon-upload2" />
                    </div>
                  </div>
                </el-upload>
              </div>
            </el-form-item>
            <el-form-item>
              <el-button @click="close">取 消</el-button>
              <el-button type="primary" @click="onSubmit('ruleForm')">{{
                loadingBtn ? '提交中 ...' : '确 定'
              }}</el-button>
            </el-form-item>
          </el-form>
        </div>
      </div>
    </el-drawer>
    <!--查看图片-->
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
  transferProofApi,
  transferAuditApi,
  transferDetailApi,
  transferRecordsExportApi,
  transferRemarkApi,
} from '@/api/financial';
import * as merchant from '@/api/merchant';
import { getToken } from '@/utils/auth';
import { fileImageApi } from '@/api/systemSetting';
export default {
  name: 'transferAccount',
  directives: {
    // 计算是否滚动到最下面
    selectLoadMore: {
      bind(el, binding) {
        // 获取element-ui定义好的scroll盒子
        const SELECTWRAP_DOM = el.querySelector('.el-select-dropdown .el-select-dropdown__wrap');
        SELECTWRAP_DOM.addEventListener('scroll', function () {
          if (this.scrollHeight - this.scrollTop < this.clientHeight + 1) {
            binding.value();
          }
        });
      },
    },
  },
  data() {
    return {
      myHeaders: { 'X-Token': getToken() },
      isShow: 0,
      loadingBtn: false,
      rules: {
        auditStatus: [{ required: true, message: '请选择审核状态', trigger: 'change' }],
        refusalReason: [{ required: true, message: '请填写拒绝原因', trigger: 'blur' }],
        voucher_image: [{ required: true, message: '请上传转账凭证', type: 'array', trigger: 'change' }],
      },
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
        auditStatus: 0,
        transferStatus: '',
        merId: '',
      },
      timeVal: [],
      fromList: this.$constants.fromList,
      loading: false,
      dialogVisible: false,
      pictureVisible: false,
      transferData: {},
      baseInfoform: {
        amount: 0,
        mark: '',
        transferType: '',
      },
      merchantList: [],
      search: {
        limit: 10,
        page: 1,
        keywords: '',
      },
      ruleForm: {
        refusalReason: '',
        auditStatus: 1,
        id: '',
        voucher_image: [],
      },
      localImg: '',
    };
  },
  mounted() {
    this.getList(1);
  },
  methods: {
    onRemark(row) {
      this.$prompt('备注', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        inputErrorMessage: '请输入备注',
        inputType: 'textarea',
        inputValue: row.platformMark,
        inputPlaceholder: '请输入备注',
        inputValidator: (value) => {
          if (!value) {
            return '请输入备注';
          }
        },
      })
        .then(({ value }) => {
          transferRemarkApi({
            id: row.id,
            remark: value,
          }).then((res) => {
            this.$message({
              type: 'success',
              message: '提交成功',
            });
            this.getList('');
          });
        })
        .catch(() => {
          this.$message({
            type: 'info',
            message: '取消输入',
          });
        });
    },
    onSubmit(formName) {
      if (this.isShow === 2) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.loadingBtn = true;
            const data = {
              id: this.transferData.id,
              refusalReason: this.ruleForm.refusalReason,
              auditStatus: this.ruleForm.auditStatus,
            };
            transferAuditApi(data)
              .then((res) => {
                this.$message.success('操作成功');
                this.dialogVisible = false;
                this.getList(1);
                this.close();
                this.loadingBtn = false;
              })
              .catch((res) => {
                this.loadingBtn = false;
              });
          } else {
            return false;
          }
        });
      } else {
        this.loadingBtn = true;
        const data = {
          id: this.transferData.id,
          transferProof: JSON.stringify(this.ruleForm.voucher_image),
        };
        this.$refs[formName].validate((valid) => {
          if (valid) {
            transferProofApi(data)
              .then((res) => {
                this.$message.success('操作成功');
                this.dialogVisible = false;
                this.getList(1);
                this.close();
                this.loadingBtn = false;
              })
              .catch((res) => {
                this.loadingBtn = false;
              });
          }
        });
      }
    },
    handleUploadForm(param) {
      const formData = new FormData();
      const data = {
        model: 'financial',
        pid: 0,
      };
      formData.append('multipart', param.file);
      let loading = this.$loading({
        lock: true,
        text: '上传中，请稍候...',
        spinner: 'el-icon-loading',
        background: 'rgba(0, 0, 0, 0.7)',
      });
      fileImageApi(formData, data)
        .then((res) => {
          loading.close();
          this.$message.success('上传成功');
          this.ruleForm.voucher_image.push(res.url);
        })
        .catch((res) => {
          loading.close();
        });
    },
    handleRemove(i) {
      this.ruleForm.voucher_image.splice(i, 1);
    },
    close() {
      this.dialogVisible = false;
      this.$refs['ruleForm'].resetFields();
      this.ruleForm.voucher_image = [];
    },
    // 远程搜索
    remoteMethod(query) {
      this.loading = true;
      this.search.keywords = query;
      this.search.limit = 1;
      this.merchantList = [];
      setTimeout(() => {
        this.loading = false;
        this.getMerList(); // 请求接口
      }, 200);
    },
    // 下拉加载更多
    selectLoadMore() {
      this.search.limit = this.search.limit + 1;
      if (this.search.limit > this.totalPage) return;
      this.getMerList(); // 请求接口
    },
    // 列表
    getMerList() {
      merchant
        .merchantListAddApi(this.search)
        .then((res) => {
          this.totalPage = res.totalPage;
          this.merchantList = this.merchantList.concat(res.list);
        })
        .catch((res) => {
          this.listLoading = false;
        });
    },
    // 转账信息
    transferDetail(id, num) {
      this.isShow = num;
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
.title {
  font-size: 20px;
}
.wid100 {
  width: 100px;
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
  padding: 0 30px;
  font-size: 14px;
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
