<template>
  <div class="divBox">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <div class="acea-row">
          <el-button class="mr20" size="small" type="primary" v-hasPermi="['platform:activity:add']" @click="onAdd"
            >添加活动</el-button
          >
          <div style="width: 80%">
            <el-alert title="活动列表只会加载前三个商品" type="warning" effect="dark" :closable="false"> </el-alert>
          </div>
        </div>
      </div>
      <el-table v-loading="listLoading" :data="tableData.data" style="width: 100%" size="small">
        <el-table-column prop="id" label="ID" min-width="60" />
        <el-table-column label="活动名称" prop="name" min-width="150" />
        <el-table-column label="活动类型" min-width="120">
          <template slot-scope="scope">
            <span>{{ scope.row.type | activityTypeFilter }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="sort" label="排序" min-width="50" />
        <el-table-column label="是否开启" min-width="100">
          <template slot-scope="scope">
            <el-switch
              v-if="checkPermi(['platform:activity:switch'])"
              v-model="scope.row.isOpen"
              :active-value="true"
              :inactive-value="false"
              active-text="开启"
              inactive-text="关闭"
              @change="onchangeIsShow(scope.row)"
            />
            <span v-else>{{ scope.row.isOpen ? '开启' : '关闭' }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" min-width="150" />
        <el-table-column label="操作" min-width="100" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" size="small" v-hasPermi="['platform:activity:info']" @click="onEdit(scope.row.id)"
              >编辑</el-button
            >
            <el-button
              type="text"
              size="small"
              v-hasPermi="['platform:activity:delete']"
              @click="handleDelete(scope.row.id, scope.$index)"
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
    <el-drawer
      :title="ativityId === 0 ? '添加活动' : '编辑活动'"
      :visible.sync="dialogVisible"
      :direction="direction"
      size="950px"
      :before-close="handleClose"
    >
      <creata-ativity ref="creataAtivity" :key="timer" :ativityId="ativityId" @getList="seachList"></creata-ativity>
    </el-drawer>
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
import * as activityApi from '@/api/activity.js';
import creataAtivity from './creataAtivity';
import { checkPermi } from '@/utils/permission'; // 权限判断函数
export default {
  name: 'activityList',
  components: { creataAtivity },
  data() {
    return {
      direction: 'rtl',
      props: {
        value: 'store_brand_category_id',
        label: 'cate_name',
        children: 'children',
        emitPath: false,
      },
      isChecked: false,
      listLoading: true,
      tableData: {
        data: [],
        total: 0,
      },
      tableFrom: {
        page: 1,
        limit: 20,
      },
      editData: {},
      dialogVisible: false,
      timer: '',
      ativityId: 0,
    };
  },
  mounted() {
    this.getList(1);
  },
  methods: {
    checkPermi,
    seachList() {
      this.handleClose();
      this.getList(1);
    },
    // 列表
    getList(num) {
      this.listLoading = true;
      this.tableFrom.page = num ? num : this.tableFrom.page;
      activityApi
        .activityListApi(this.tableFrom)
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
    handleClose() {
      this.dialogVisible = false;
    },
    // 添加
    onAdd() {
      this.ativityId = 0;
      this.timer = new Date().getTime();
      this.dialogVisible = true;
    },
    // 编辑
    onEdit(id) {
      this.ativityId = id;
      this.timer = new Date().getTime();
      this.dialogVisible = true;
    },
    // 删除
    handleDelete(id, idx) {
      this.$modalSure().then(() => {
        activityApi.activityDeleteApi(id).then((res) => {
          this.$message.success('删除成功');
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

<style scoped lang="scss">
.selWidth {
  width: 300px !important;
}
</style>
