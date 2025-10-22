<template>
  <div class="divBox">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <div class="container">
          <el-form ref="form" inline :model="form">
            <el-form-item label="关键字：">
              <el-input v-model="form.keywords" placeholder="请输入关键字" class="selWidth" size="small" clearable>
                <el-button slot="append" size="small" icon="el-icon-search" @click="handlerSearch" />
              </el-input>
            </el-form-item>
          </el-form>
        </div>
      </div>
      <el-table v-loading="loading" :data="tableData.list" :header-cell-style="{ fontWeight: 'bold' }">
        <el-table-column prop="id" label="ID" min-width="180" />
        <el-table-column label="物流公司名称" min-width="150" prop="name" />
        <el-table-column min-width="200" label="编码" prop="code" />
        <el-table-column min-width="100" label="排序" prop="sort" sortable />
        <el-table-column label="是否显示" min-width="100">
          <template slot-scope="scope">
            <el-switch
              v-model="scope.row.isShow"
              class="demo"
              :active-value="true"
              :inactive-value="false"
              active-text="开启"
              inactive-text="关闭"
              @change="bindStatus(scope.row)"
              v-if="checkPermi(['platform:express:update:show'])"
            />
            <span v-else>{{ scope.row.isShow ? '开启' : '关闭' }}</span>
          </template>
        </el-table-column>
      </el-table>
      <div class="block-pagination">
        <el-pagination
          :page-sizes="[20, 40, 60, 80]"
          :page-size="tableData.limit"
          :current-page="tableData.page"
          layout="total, sizes, prev, pager, next, jumper"
          :total="tableData.total"
          @current-change="pageChange"
          @size-change="handleSizeChange"
        />
      </div>
    </el-card>
  </div>
</template>

<script>
import parser from '@/components/FormGenerator/components/parser/Parser';
import * as systemFormConfigApi from '@/api/systemFormConfig.js';
import * as logistics from '@/api/logistics.js';
import { checkPermi } from '@/utils/permission'; // 权限判断函数
import { Debounce } from '@/utils/validate';
export default {
  name: 'CompanyList',
  components: { parser },
  data() {
    return {
      constants: this.$constants,
      // 表单
      formConf: { fields: [] },
      form: {
        keywords: '',
      },
      tableData: {},
      page: 1,
      limit: 20,
      loading: false,
      dialogVisible: false,
      fromType: 'add',
      formData: {
        status: false,
      },
      isCreate: 0,
      formShow: false,
      editId: 0,
      rules: {
        sort: [{ required: true, message: '请输入排序', trigger: 'blur' }],
        account: [{ required: true, message: '请输入月结账号', trigger: 'blur' }],
        password: [{ required: true, message: '请输入月结密码', trigger: 'blur' }],
        netName: [{ required: true, message: '请输入网点名称', trigger: 'blur' }],
      },
    };
  },
  created() {
    this.getExpressList();
  },
  methods: {
    checkPermi,
    handlerSearch() {
      this.page = 1;
      this.getExpressList();
    },
    //  获取物流公司列表
    getExpressList() {
      this.loading = true;
      logistics
        .expressList({
          page: this.page,
          limit: this.limit,
          keywords: this.form.keywords,
        })
        .then((res) => {
          this.loading = false;
          this.tableData = res;
        })
        .catch(() => {
          this.loading = false;
        });
    },
    // 物流开关
    bindStatus(item) {
      logistics
        .expressUpdateShow({
          account: item.account,
          code: item.code,
          id: item.id,
          isShow: item.isShow,
          name: item.name,
          sort: item.sort,
        })
        .then((res) => {
          this.$message.success('操作成功');
          // this.getExpressList()
        })
        .catch(() => {
          item.isShow = !item.isShow;
        });
    },
    // 分页
    pageChange(e) {
      this.page = e;
      this.getExpressList();
    },
    handleSizeChange(e) {
      this.limit = e;
      this.getExpressList();
    },
    // 删除物流公司
    bindDelete(item) {
      this.$modalSure().then(() => {
        logistics.expressDelete({ id: item.id }).then((res) => {
          this.$message.success('删除成功');
          this.getExpressList();
        });
      });
    },
  },
};
</script>

<style lang="scss" scoped>
.selWidth {
  width: 350px;
}
.el-icon-plus {
  margin-right: 5px;
}

.demo .el-switch__label {
  position: absolute;
  display: none;
  color: #fff;
}

/*打开时文字位置设置*/
.demo .el-switch__label--right {
  z-index: 1;
}

/*关闭时文字位置设置*/
.demo .el-switch__label--left {
  z-index: 1;
  left: 19px;
}

/*显示文字*/
.demo .el-switch__label.is-active {
  display: block;
}

.demo.el-switch .el-switch__core,
.el-switch .el-switch__label {
  width: 60px !important;
}
.formBox {
  .el-input-number--medium {
    width: 100px;
  }
}
</style>
