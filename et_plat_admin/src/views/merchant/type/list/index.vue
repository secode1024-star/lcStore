<template>
  <div class="divBox relative">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <div class="container mt-1">
          <el-form inline size="small">
            <el-button
              type="primary"
              size="mini"
              v-hasPermi="['platform:merchant:type:add']"
              @click="handlerOpenEdit(0)"
              >添加店铺类型</el-button
            >
          </el-form>
        </div>
      </div>
      <el-table
        v-loading="listLoading"
        :data="tableData.data"
        style="width: 100%"
        size="mini"
        height="500px"
        :highlight-current-row="true"
        :header-cell-style="{ fontWeight: 'bold' }"
      >
        <el-table-column prop="id" label="ID" min-width="50" />
        <el-table-column label="店铺类型名称" prop="name" min-width="100"> </el-table-column>
        <el-table-column prop="info" label="店铺类型要求" min-width="200" />
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
              v-hasPermi="['platform:merchant:type:update']"
              >编辑</el-button
            >
            <el-button
              size="small"
              type="text"
              @click="handlerOpenDel(scope.row)"
              v-hasPermi="['platform:merchant:type:delete']"
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
export default {
  data() {
    return {
      tableFrom: {},
      tableData: {
        data: [],
        total: 0,
      },
      listLoading: false,
      editDialogConfig: {
        visible: false,
        editData: {},
      },
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
        .merchantTypeListApi()
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
        152,
        isCreate,
        isCreate === 0 ? { id: 0, name: '', info: '' } : Object.assign({}, editDate),
        function (formValue) {
          _this.submit(formValue);
        },
        (this.keyNum += 3),
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
        info: formValue.info,
      };
      !formValue.id
        ? merchant
            .merchantTypeAddApi(data)
            .then((res) => {
              this.$message.success('操作成功');
              this.$msgbox.close();
              this.$store.commit('merchant/SET_MerchantType', []);
              this.getList();
            })
            .catch(() => {
              this.loading = false;
            })
        : merchant
            .merchantTypeUpdateApi(data)
            .then((res) => {
              this.$message.success('操作成功');
              this.$msgbox.close();
              this.$store.commit('merchant/SET_MerchantType', []);
              this.getList();
            })
            .catch(() => {
              this.loading = false;
            });
    },
    handlerOpenDel(rowData) {
      this.$modalSure('删除当前分类吗').then(() => {
        merchant.merchantTypeDeleteApi(rowData.id).then((data) => {
          this.$message.success('删除分类成功');
          this.getList();
          this.$store.commit('merchant/SET_MerchantType', []);
        });
      });
    },
    hideEditDialog() {
      this.editDialogConfig.visible = false;
      this.handleGetRoleList();
    },
  },
};
</script>
