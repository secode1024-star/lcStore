<template>
  <div class="divBox relative">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <div class="container mt-1">
          <el-form :inline="true">
            <div class="acea-row">
              <el-button
                type="primary"
                class="mr20"
                v-hasPermi="['platform:merchant:category:add']"
                @click="handlerOpenEdit(0)"
                >添加商户分类</el-button
              >
            </div>
          </el-form>
        </div>
      </div>
      <el-table
        v-loading="listLoading"
        :data="tableData.data"
        style="width: 100%"
        size="mini"
        :highlight-current-row="true"
        :header-cell-style="{ fontWeight: 'bold' }"
      >
        <el-table-column prop="id" label="ID" min-width="50" />
        <el-table-column label="分类名称" prop="name" min-width="100" :show-overflow-tooltip="true"> </el-table-column>
        <el-table-column prop="handlingFee" label="手续费" min-width="100" align="center" />
        <el-table-column label="添加时间" min-width="120" align="center">
          <template slot-scope="scope">
            <span>{{ scope.row.createTime }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" min-width="130" fixed="right">
          <template slot-scope="scope">
            <el-button
              size="small"
              type="text"
              @click="handlerOpenEdit(1, scope.row)"
              v-hasPermi="['platform:merchant:category:update']"
              >编辑</el-button
            >
            <el-button
              size="small"
              type="text"
              @click="handlerOpenDel(scope.row)"
              v-hasPermi="['platform:merchant:category:delete']"
              >删除</el-button
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
  </div>
</template>
<script>
import * as merchant from '@/api/merchant';
import store from '@/store';
export default {
  data() {
    return {
      tableFrom: {
        page: 1,
        limit: 20,
      },
      tableData: {
        data: [],
        total: 0,
      },
      listLoading: false,
      keyNum: 0,
    };
  },
  mounted() {
    this.getList();
  },
  methods: {
    // 列表
    getList() {
      this.listLoading = true;
      merchant
        .merchantCategoryListApi(this.tableFrom)
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
    handlerOpenEdit(isCreate, editDate) {
      const _this = this;
      this.$modalParserFrom(
        isCreate === 0 ? '新建分类' : '编辑分类',
        151,
        isCreate,
        isCreate === 0
          ? {
              id: 0,
              name: '',
              handlingFee: '',
            }
          : Object.assign({}, editDate),
        function (formValue) {
          _this.submit(formValue);
          _this.resetForm(formValue);
        },
        (this.keyNum += 2),
        function () {
          _this.beforeClose();
        },
      );
    },
    beforeClose() {
      this.$msgbox.close();
    },
    submit(formValue) {
      const data = {
        id: !formValue.id ? 0 : formValue.id,
        name: formValue.name,
        handlingFee: formValue.handlingFee,
      };
      !formValue.id
        ? merchant
            .merchantCategoryAddApi(data)
            .then((res) => {
              this.$message.success('操作成功');
              this.$msgbox.close();
              this.$store.commit('merchant/SET_MerchantClassify', []);
              this.getList();
            })
            .catch(() => {
              this.loading = false;
            })
        : merchant
            .merchantCategoryUpdateApi(data)
            .then((res) => {
              this.$message.success('操作成功');
              this.$msgbox.close();
              this.$store.commit('merchant/SET_MerchantClassify', []);
              this.getList();
            })
            .catch(() => {
              this.loading = false;
            });
    },
    handlerOpenDel(rowData) {
      this.$modalSure('删除当前分类吗').then(() => {
        merchant.merchantCategoryDeleteApi(rowData.id).then((data) => {
          this.$message.success('删除分类成功');
          this.getList();
          this.$store.commit('merchant/SET_MerchantClassify', []);
        });
      });
    },
  },
};
</script>
