<template>
  <div class="divBox">
    <el-card class="box-card">
      <el-table
        :data="tableData.data"
        style="width: 100%"
        v-loading="listLoading"
        :header-cell-style="{ fontWeight: 'bold' }"
      >
        <el-table-column prop="id" label="ID" width="80"></el-table-column>
        <el-table-column prop="phone" label="手机号" min-width="120"></el-table-column>
        <el-table-column prop="countryCode" label="国际区号" min-width="120"></el-table-column>
        <el-table-column
          prop="content"
          label="短信内容"
          min-width="120"
          :show-overflow-tooltip="true"
        ></el-table-column>
        <el-table-column label="状态码" min-width="120">
          <template slot-scope="scope">
            <span>{{ scope.row.resultcode | resultcodeFilter }}</span>
          </template>
        </el-table-column>
        <el-table-column
          prop="message"
          label="状态码描述"
          min-width="120"
          :show-overflow-tooltip="true"
        ></el-table-column>
        <el-table-column prop="createTime" label="创建时间" min-width="120"></el-table-column>
      </el-table>
      <el-pagination
        :page-sizes="[20, 40, 60, 80]"
        :page-size="tableFrom.limit"
        :current-page="tableFrom.page"
        layout="total, sizes, prev, pager, next, jumper"
        :total="tableData.total"
        @size-change="handleSizeChange"
        @current-change="pageChange"
      />
    </el-card>
  </div>
</template>

<script>
import { smsApi } from '@/api/systemFormConfig';
export default {
  data() {
    return {
      tableData: {
        data: [],
        total: 0,
      },
      tableFrom: {
        page: 1,
        limit: 20,
      },
      listLoading: false,
    };
  },
  created() {
    this.getList();
  },
  methods: {
    getList() {
      this.listLoading = true;
      smsApi(this.tableFrom).then((res) => {
        this.tableData.data = res.list;
        this.tableData.total = res.total;
        this.listLoading = false;
      });
    },
    handleSizeChange(val) {
      this.tableFrom.limit = val;
      this.getList();
    },
    pageChange(page) {
      this.tableFrom.page = page;
      this.getList();
    },
  },
};
</script>

<style scoped>
.mt-1 {
  margin-top: 6px;
}
.description {
  padding: 16px;
  position: relative;
  border-radius: 4px;
  margin-bottom: 20px;
  color: #515a6e;
  line-height: 1.5;
  font-size: 14px;
  border: 1px solid #abdcff;
  background-color: #f0faff;
}
.iconfont {
  color: #06c05f;
}
</style>
