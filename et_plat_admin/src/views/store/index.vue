<template>
  <div class="divBox relative">
    <el-card class="box-card">
      <div slot="header" class="clearfix" ref="headerBox">
        <el-tabs
          v-model="tableFrom.type"
          @tab-click="getList(1), goodHeade()"
          v-if="checkPermi(['platform:product:tabs:headers'])"
        >
          <el-tab-pane
            :label="item.name + '(' + item.count + ')'"
            :name="item.type.toString()"
            v-for="(item, index) in headeNum"
            :key="index"
          />
        </el-tabs>
        <div v-show="isShowSeach" class="container mt-1">
          <el-form inline v-hasPermi="['platform:product:page:list']">
            <el-form-item v-hasPermi="['platform:product:category:list']" label="商品分类：">
              <el-cascader
                class="selWidth"
                ref="cascader"
                v-model="tableFrom.categoryId"
                @change="getList(1)"
                clearable
                :options="adminProductClassify"
                :props="categoryProps"
                style="width: 100%"
              />
            </el-form-item>
            <el-form-item label="商户类别：">
              <el-select
                v-model="tableFrom.isSelf"
                clearable
                placeholder="请选择"
                class="selWidth"
                @change="getList(1)"
              >
                <el-option label="自营" :value="1" />
                <el-option label="非自营" :value="0" />
              </el-select>
            </el-form-item>
            <el-form-item label="商户名称：">
              <el-select
                @change="getList(1)"
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
            <el-form-item label="商品搜索：">
              <el-input
                v-model="tableFrom.keywords"
                placeholder="请输入商品名称，关键字"
                class="selWidth"
                size="small"
                clearable
              >
                <el-button slot="append" icon="el-icon-search" @click="getList(1)" />
              </el-input>
            </el-form-item>
          </el-form>
        </div>
        <el-button v-show="Number(tableFrom.type) < 2" size="mini" style="margin-left: 0px" @click="batchOff"
          >批量强制下架</el-button
        >
        <el-button size="small" icon="el-icon-upload2" @click="isShowSeach = !isShowSeach">显示隐藏</el-button>
      </div>
      <el-table
        v-loading="listLoading"
        :data="tableData.data"
        style="width: 100%"
        size="mini"
        :highlight-current-row="true"
        @selection-change="handleSelectionChange"
        :header-cell-style="{ fontWeight: 'bold' }"
      >
        <el-table-column v-if="Number(tableFrom.type) < 3" key="2" type="selection" width="55" />
        <el-table-column type="expand">
          <template slot-scope="props">
            <el-form label-position="left" inline class="demo-table-expand">
              <el-form-item label="商户类别：">
                <span>{{ props.row.isSelf | selfTypeFilter }}</span>
              </el-form-item>
              <el-form-item label="邮费：">
                <span>{{ props.row.postage }}</span>
              </el-form-item>
              <el-form-item label="虚拟销量：">
                <span>{{ props.row.ficti }}</span>
              </el-form-item>

              <el-form-item label="拒绝原因：" v-if="tableFrom.type == 7">
                <span>{{ props.row.reason }}</span>
              </el-form-item>
            </el-form>
          </template>
        </el-table-column>
        <el-table-column prop="id" label="ID" min-width="50" v-if="checkedCities.includes('ID')" />
        <el-table-column label="商品图" min-width="80" v-if="checkedCities.includes('商品图')">
          <template slot-scope="scope">
            <div class="demo-image__preview">
              <el-image
                style="width: 36px; height: 36px"
                :src="$imageUrl(scope.row.image)"
                :preview-src-list="[scope.row.image]"
              />
            </div>
          </template>
        </el-table-column>
        <el-table-column
          label="商品名称"
          prop="storeName"
          min-width="180"
          v-if="checkedCities.includes('商品名称')"
          :show-overflow-tooltip="true"
        >
        </el-table-column>
        <el-table-column
          :label="'商品售价 (' + GLOBAL.shopPayCurrency + ')'"
          prop="price"
          min-width="100"
          v-if="checkedCities.includes('商品售价')"
        >
        </el-table-column>
        <el-table-column
          prop="merchantName"
          label="商户名称"
          v-if="checkedCities.includes('商户名称')"
          min-width="180"
          :show-overflow-tooltip="true"
        />
        <el-table-column label="商户类别" min-width="100" v-if="checkedCities.includes('商户类别')">
          <template slot-scope="scope">
            <span>{{ scope.row.isSelf | selfTypeFilter }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="sales" label="销量" v-if="checkedCities.includes('销量')" min-width="100" />
        <el-table-column prop="stock" label="库存" min-width="70" v-if="checkedCities.includes('库存')" />
        <el-table-column label="审核状态" min-width="80" fixed="right" v-if="checkedCities.includes('审核状态')">
          <template slot-scope="scope">
            <span>{{ scope.row.auditStatus | auditStatusFilter }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" min-width="180" fixed="right" align="center" :render-header="renderHeader">
          <template slot-scope="scope">
            <el-button
              v-if="tableFrom.type === '6'"
              type="text"
              size="small"
              @click="handleAudit(scope.row.id, true)"
              v-hasPermi="['platform:product:audit']"
              >审核</el-button
            >
            <el-button
              v-if="tableFrom.type === '6' || tableFrom.type === '1'"
              type="text"
              size="small"
              @click="handleSales(scope.row)"
              v-hasPermi="['platform:product:virtual:sales']"
              >虚拟销量</el-button
            >
            <el-button
              type="text"
              size="small"
              @click="handleAudit(scope.row.id, false)"
              v-hasPermi="['platform:product:info']"
              >详情</el-button
            >
            <el-button
              v-if="Number(tableFrom.type) < 2"
              type="text"
              size="small"
              @click="handleOff(scope.row.id)"
              v-hasPermi="['platform:product:force:down']"
              >强制下架</el-button
            >
            <el-button
              v-if="tableFrom.type === '5'"
              type="text"
              size="small"
              @click="handleRestore(scope.row.id, scope.$index)"
              >恢复商品</el-button
            >
            <el-button
              v-if="Number(tableFrom.type) < 2"
              type="text"
              size="small"
              @click="handleRank(scope.row)"
              v-hasPermi="['platform:product:update:rank']"
              >排序</el-button
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
    <!--商品详情-->
    <el-drawer
      :visible.sync="dialogVisible"
      :title="isAtud ? '商品审核' : '商品详情'"
      :direction="direction"
      :append-to-body="true"
      custom-class="demo-drawer"
      size="1000px"
      :wrapperClosable="isAtud ? false : true"
      :modal-append-to-body="false"
      class="infoBox"
    >
      <info-from
        v-if="dialogVisible"
        ref="infoFrom"
        :is-atud="isAtud"
        :is-show="isShow"
        :productId="productId"
        @subSuccess="subSuccess"
        @handleClose="handleClose"
      />
    </el-drawer>
  </div>
</template>

<script>
import {
  onChangeSalesApi,
  productLstApi,
  productDeleteApi,
  categoryApi,
  putOnShellApi,
  offShellApi,
  productHeadersApi,
  productExportApi,
  restoreApi,
  productExcelApi,
  updateRankApi,
} from '@/api/store';
import { getToken } from '@/utils/auth';
import { checkPermi } from '@/utils/permission'; // 权限判断函数
import * as merchant from '@/api/merchant';
import infoFrom from './info';
import { mapGetters } from 'vuex';
const headerName = [
  {
    name: '出售中商品',
    type: 1,
  },
  {
    name: '仓库中商品',
    type: 2,
  },
  {
    name: '待审核商品',
    type: 6,
  },
  {
    name: '审核未通过商品',
    type: 7,
  },
];
export default {
  name: 'ProductList',
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
  components: { infoFrom },
  data() {
    return {
      isAtud: false,
      isShow: false,
      productId: 0,
      categoryProps: {
        value: 'id',
        label: 'name',
        children: 'childList',
        expandTrigger: 'hover',
        checkStrictly: false,
        emitPath: false,
        multiple: false,
      },
      props: {
        children: 'child',
        label: 'name',
        value: 'id',
        emitPath: false,
      },
      isShowSeach: true,
      categoryIdData: [],
      headeNum: [],
      listLoading: false,
      tableData: {
        data: [],
        total: 0,
      },
      tableFrom: {
        page: 1,
        limit: 20,
        categoryId: null,
        keywords: '',
        type: '1',
        isSelf: null,
      },
      categoryList: [],
      merCateList: [],
      objectUrl: process.env.VUE_APP_BASE_API,
      dialogVisible: false,
      card_select_show: false,
      checkAll: false,
      checkedCities: ['ID', '商品图', '商品名称', '商品售价', '商户名称', '商户类别', '销量', '库存', '审核状态'],
      columnData: ['ID', '商品图', '商品名称', '商品售价', '商户名称', '商户类别', '销量', '库存', '审核状态'],
      isIndeterminate: true,
      merchantList: [],
      search: {
        limit: 10,
        page: 1,
        keywords: '',
      },
      loading: false,
      totalPage: 0,
      total: 0,
      keyNum: 0,
      multipleSelection: [],
      OffId: [],
      direction: 'rtl', //抽屉展开方向
    };
  },
  mounted() {
    if (checkPermi(['platform:product:tabs:headers'])) this.goodHeade();
    if (!this.adminProductClassify.length && checkPermi(['platform:product:category:cache:tree']))
      this.$store.dispatch('product/getAdminProductClassify');
    if (checkPermi(['platform:merchant:page:list'])) this.getMerList();
    if (checkPermi(['platform:product:page:list'])) this.getList();
    this.checkedCities = this.$cache.local.has('goods_stroge')
      ? this.$cache.local.getJSON('goods_stroge')
      : this.checkedCities;
  },
  computed: {
    ...mapGetters(['adminProductClassify']),
    heightBoxs: function () {
      this.$nextTick(() => {
        // 页面渲染完成后的回调
        return Number(this.$refs.headerBox.offsetHeight) - Number(document.documentElement.clientHeight);
      });
    },
  },
  methods: {
    checkPermi,
    handleRank(editDate) {
      const _this = this;
      this.$modalParserFrom(
        '修改排序',
        160,
        1,
        { rank: editDate.rank, id: editDate.id },
        function (formValue) {
          _this.submitRank(formValue);
        },
        (this.keyNum += 5),
      );
    },
    submitRank(formValue) {
      const data = {
        id: formValue.id,
        rank: formValue.rank,
      };
      updateRankApi(data)
        .then((res) => {
          this.$message.success('操作成功');
          this.$msgbox.close();
          this.getList();
        })
        .catch(() => {
          this.loading = false;
        });
    },
    // 批量下架
    batchOff() {
      if (this.multipleSelection.length === 0) return this.$message.warning('请先选择商品');
      this.handleOff(this.OffId);
    },
    // 下架
    handleOff(id) {
      this.$modalSure('强制下架吗').then(() => {
        offShellApi({
          ids: id.toString(),
        }).then((res) => {
          this.$message({
            type: 'success',
            message: '提交成功',
          });
          this.getList('');
        });
      });
    },
    handleSelectionChange(val) {
      this.multipleSelection = val;
      const data = [];
      this.multipleSelection.map((item) => {
        data.push(item.id);
      });
      this.OffId = data;
    },
    handleSales(row) {
      const _this = this;
      this.$modalParserFrom(
        '修改虚拟销量',
        156,
        0,
        { ficti: row.ficti || '0', id: row.id },
        function (formValue) {
          _this.submit(formValue);
        },
        (this.keyNum += 5),
      );
    },
    submit(formValue) {
      const data = {
        id: formValue.id,
        num: formValue.num,
        type: formValue.type,
      };
      onChangeSalesApi(data)
        .then((res) => {
          this.$message.success('操作成功');
          this.$msgbox.close();
          this.getList();
        })
        .catch(() => {
          this.loading = false;
        });
    },
    // 审核回调
    subSuccess() {
      this.dialogVisible = false;
      this.getList('');
      this.goodHeade();
    },
    handleClose() {
      this.dialogVisible = false;
    },
    // 详情、审核
    handleAudit(id, c) {
      this.productId = id;
      this.dialogVisible = true;
      //this.$refs.infoFrom.dialogVisible = true;
      this.isShow = true;
      this.isAtud = c;
      //this.$refs.infoFrom.getInfo(id);
    },
    // 下拉加载更多
    selectLoadMore() {
      this.search.page = this.search.page + 1;
      if (this.search.page > this.totalPage) return;
      this.getMerList(); // 请求接口
    },
    // 远程搜索
    remoteMethod(query) {
      this.loading = true;
      this.search.keywords = query;
      this.search.page = 1;
      this.merchantList = [];
      setTimeout(() => {
        this.loading = false;
        this.getMerList(); // 请求接口
      }, 200);
    },
    // 列表
    getMerList(num) {
      merchant
        .merchantListAddApi(this.search)
        .then((res) => {
          this.totalPage = res.totalPage;
          this.total = res.total;
          this.merchantList = this.merchantList.concat(res.list);
        })
        .catch((res) => {
          this.listLoading = false;
        });
    },
    handleRestore(id) {
      this.$modalSure('恢复商品').then(() => {
        restoreApi(id).then((res) => {
          this.$message.success('操作成功');
          this.goodHeade();
          this.getList();
        });
      });
    },
    // 导出
    exports() {
      productExcelApi({
        cateId: this.tableFrom.cateId,
        keywords: this.tableFrom.keywords,
        type: this.tableFrom.type,
      }).then((res) => {
        window.location.href = res.fileName;
      });
    },
    // 获取商品表单头数量
    goodHeade() {
      productHeadersApi()
        .then((res) => {
          res.map((item, index) => {
            if (item.type === headerName[index].type) item.name = headerName[index].name;
          });
          this.headeNum = res;
        })
        .catch((res) => {
          this.$message.error(res.message);
        });
    },
    // 列表
    getList(num) {
      this.tableFrom.page = num ? num : this.tableFrom.page;
      this.listLoading = true;
      productLstApi(this.tableFrom)
        .then((res) => {
          this.tableData.data = res.list;
          this.tableData.total = res.total;
          this.listLoading = false;
        })
        .catch((res) => {
          this.listLoading = false;
          this.$message.error(res.message);
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
    // 删除
    handleDelete(id, type) {
      this.$modalSure(`删除 id 为 ${id} 的商品`).then(() => {
        const deleteFlag = type == 5 ? 'delete' : 'recycle';
        productDeleteApi(id, deleteFlag).then(() => {
          this.$message.success('删除成功');
          this.getList();
          this.goodHeade();
        });
      });
    },
    onchangeIsShow(row) {
      row.isShow
        ? putOnShellApi(row.id)
            .then(() => {
              this.$message.success('上架成功');
              this.getList();
              this.goodHeade();
            })
            .catch(() => {
              row.isShow = !row.isShow;
            })
        : offShellApi(row.id)
            .then(() => {
              this.$message.success('下架成功');
              this.getList();
              this.goodHeade();
            })
            .catch(() => {
              row.isShow = !row.isShow;
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
    handleCloseMod(item) {
      this.dialogVisible = item;
      this.goodHeade();
      this.getList();
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
      this.$cache.local.setJSON('goods_stroge', this.checkedCities);
      setTimeout(this.$modal.closeLoading(), 1000);
    },
  },
};
</script>

<style scoped lang="scss">
.el-table__body {
  width: 100%;
  table-layout: fixed !important;
}
.taoBaoModal {
  //  z-index: 3333 !important;
}
.demo-table-expand {
  ::v-deep label {
    width: 82px;
  }
}
.demo-table-expand {
  ::v-deep .el-form-item__content {
    width: 70%;
  }
}
.selWidth {
  width: 350px !important;
}
.seachTiele {
  line-height: 30px;
}
.relative {
  position: relative;
}
.card_abs {
  position: absolute;
  padding-bottom: 15px;
  top: 260px;
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
.mt-1 {
  margin-top: 6px;
}
::v-deep .el-checkbox__input.is-checked + .el-checkbox__label {
  color: #606266;
}
</style>
