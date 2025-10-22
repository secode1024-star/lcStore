<template>
  <div class="divBox relative">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <div class="container mt-1">
          <el-form inline size="small">
            <el-button
              type="primary"
              size="small"
              v-hasPermi="['platform:product:guarantee:add']"
              @click="handlerOpenEdit(0)"
              >添加保障服务</el-button
            >
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
        <el-table-column prop="name" label="服务条款" min-width="150" />
        <el-table-column label="服务条款图标" min-width="120">
          <template slot-scope="scope">
            <div class="demo-image__preview">
              <el-image style="width: 36px; height: 36px" :src="scope.row.icon" :preview-src-list="[scope.row.icon]" />
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="content" label="服务内容描述" min-width="200" />
        <el-table-column prop="sort" align="center" label="排序" min-width="80" />
        <el-table-column label="是否显示" min-width="90">
          <template slot-scope="scope">
            <el-switch
              v-if="checkPermi(['platform:product:guarantee:show:status'])"
              v-model="scope.row.isShow"
              :active-value="true"
              :inactive-value="false"
              active-text="显示"
              inactive-text="隐藏"
              @click.native="onchangeIsShow(scope.row)"
            />
            <span v-else>{{ scope.row.isShow ? '显示' : '隐藏' }}</span>
          </template>
        </el-table-column>
        <el-table-column label="创建时间" min-width="120" align="center">
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
              v-hasPermi="['platform:product:guarantee:update']"
              >编辑</el-button
            >
            <el-button
              size="small"
              type="text"
              @click="handlerOpenDel(scope.row)"
              v-hasPermi="['platform:product:guarantee:delete']"
              >删除</el-button
            >
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>
<script>
import * as store from '@/api/store';
import { checkPermi } from '@/utils/permission'; // 权限判断函数
export default {
  data() {
    return {
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
    checkPermi,
    // 列表
    getList() {
      this.listLoading = true;
      store
        .guaranteeListApi()
        .then((res) => {
          this.tableData.data = res;
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
        isCreate === 0 ? '添加服务条款' : '编辑服务条款',
        155,
        isCreate,
        isCreate === 0 ? {} : Object.assign({}, editDate),
        function (formValue) {
          _this.submit(formValue);
          _this.resetForm(formValue);
        },
        (this.keyNum += 4),
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
        content: formValue.content,
        icon: formValue.icon,
        sort: formValue.sort,
      };
      !formValue.id
        ? store
            .guaranteeAddApi(data)
            .then((res) => {
              this.$message.success('操作成功');
              this.$msgbox.close();
              this.getList();
            })
            .catch(() => {
              this.loading = false;
            })
        : store
            .guaranteeUpdateApi(data)
            .then((res) => {
              this.$message.success('操作成功');
              this.$msgbox.close();
              this.getList();
            })
            .catch(() => {
              this.loading = false;
            });
    },
    handlerOpenDel(rowData) {
      this.$modalSure('删除当前保障服务吗').then(() => {
        store.guaranteeDeleteApi(rowData.id).then((data) => {
          this.$message.success('删除成功');
          this.getList();
        });
      });
    },
    onchangeIsShow(row) {
      store.guaranteeShowApi(row.id).then(() => {
        this.$message.success('操作成功');
        this.getList();
      });
    },
  },
};
</script>
