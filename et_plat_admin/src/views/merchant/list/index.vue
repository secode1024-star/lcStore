<template>
  <div class="divBox">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <div class="container">
          <el-form size="small" label-width="100px" :inline="true">
            <el-form-item label="选择时间：" style="display: inline-block">
              <el-radio-group v-model="tableFrom.dateLimit" size="small" @change="selectChange(tableFrom.dateLimit)">
                <el-radio-button v-for="(itemn, indexn) in fromList.fromTxt" :key="indexn" :label="itemn.val">{{
                  itemn.text
                }}</el-radio-button>
              </el-radio-group>
              <el-date-picker
                v-model="timeVal"
                type="daterange"
                placeholder="选择日期"
                format="yyyy-MM-dd"
                value-format="yyyy-MM-dd"
                range-separator="至"
                start-placeholder="开始日期"
                end-placeholder="结束日期"
                @change="onchangeTime"
              />
            </el-form-item>
            <el-form-item label="关 键 字：" label-width="100px" style="display: inline-block">
              <el-input
                v-model="tableFrom.keywords"
                @keyup.enter.native="getList(1)"
                placeholder="请输入店铺关键字/店铺名"
                class="selWidth"
              >
                <el-button slot="append" icon="el-icon-search" class="el-button-solt" @click="getList(1)" />
              </el-input>
            </el-form-item>
            <el-form-item label="商户类别：">
              <el-select
                v-model="tableFrom.isSelf"
                clearable
                placeholder="请选择"
                class="selWidth"
                @change="getList(1)"
              >
                <el-option label="自营" value="1" />
                <el-option label="非自营" value="0" />
              </el-select>
            </el-form-item>
            <el-form-item v-hasPermi="['platform:merchant:category:all']" label="商户分类：">
              <el-select
                v-model="tableFrom.categoryId"
                clearable
                placeholder="请选择"
                class="selWidth"
                @change="getList(1)"
              >
                <el-option v-for="item in merchantClassify" :key="item.id" :label="item.name" :value="item.id" />
              </el-select>
            </el-form-item>
            <el-form-item v-hasPermi="['platform:merchant:type:all']" label="店铺类型：">
              <el-select
                v-model="tableFrom.typeId"
                clearable
                placeholder="请选择"
                class="selWidth"
                @change="getList(1)"
              >
                <el-option v-for="item in merchantType" :key="item.id" :label="item.name" :value="item.id" />
              </el-select>
            </el-form-item>
            <el-tabs
              v-if="headeNum.length > 0 && checkPermi(['platform:merchant:list:header:num'])"
              v-model="tableFrom.isSwitch"
              @tab-click="getList(1), getHeadNum()"
            >
              <el-tab-pane
                v-for="(item, index) in headeNum"
                :key="index"
                :name="item.type.toString()"
                :label="item.title + '(' + item.count + ')'"
              />
            </el-tabs>
          </el-form>
        </div>
        <el-button size="small" type="primary" v-hasPermi="['platform:merchant:add']" @click="onAdd"
          >添加商户</el-button
        >
      </div>
      <el-table
        v-loading="listLoading"
        :data="tableData.data"
        style="width: 100%"
        size="small"
        highlight-current-row
        class="switchTable"
      >
        <el-table-column prop="id" label="ID" min-width="60" />
        <el-table-column prop="name" label="商户名称" min-width="150" />
        <el-table-column prop="email" label="商户账号" min-width="200" />
        <el-table-column prop="realName" label="商户姓名" min-width="150" />
        <el-table-column prop="password" label="登录密码" min-width="150">
          <template slot-scope="scope">
            <span v-if="scope.row.password" style="font-family: monospace; color: #e6a23c;">{{ scope.row.password }}</span>
            <span v-else style="color: #909399;" :title="'调试: ' + JSON.stringify(scope.row.password)">{{ scope.row.password || '-' }}</span>
          </template>
        </el-table-column>
        <el-table-column label="创建类型" min-width="150">
          <template slot-scope="scope">
            <span class="spBlock">{{ scope.row.createType | merCreateTypeFilter }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="sort" label="排序" min-width="100" />
        <el-table-column prop="status" label="开启/关闭" min-width="100">
          <template slot-scope="scope">
            <el-switch
              v-if="checkPermi(['platform:merchant:close,platform:merchant:open'])"
              v-model="scope.row.isSwitch"
              :active-value="true"
              :inactive-value="false"
              active-text="开启"
              inactive-text="关闭"
              disabled
              @click.native="onchangeIsClose(scope.row)"
            />
            <span v-else>{{ scope.row.isSwitch ? '开启' : '关闭' }}</span>
          </template>
        </el-table-column>
        <el-table-column label="推荐" min-width="100">
          <template slot-scope="scope">
            <el-switch
              v-if="checkPermi(['platform:merchant:recommend:switch'])"
              v-model="scope.row.isRecommend"
              :active-value="true"
              :inactive-value="false"
              active-text="是"
              inactive-text="否"
              disabled
              @click.native="onchangeIsShow(scope.row)"
            />
            <span v-else>{{ scope.row.isRecommend ? '是' : '否' }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" min-width="150" />
        <el-table-column label="操作" min-width="130" fixed="right" align="center">
          <template slot-scope="scope">
            <el-button
              type="text"
              size="small"
              @click="onEdit(scope.row.id, 1)"
              class="mr10"
              v-hasPermi="['platform:merchant:detail']"
              >详情</el-button
            >
            <el-dropdown v-show="tableFrom.isSwitch === '1'" trigger="click">
              <span class="el-dropdown-link"> 更多<i class="el-icon-arrow-down el-icon--right" /> </span>
              <el-dropdown-menu slot="dropdown" class="icon-arrow-down">
                <el-dropdown-item @click.native="onEdit(scope.row.id)" v-if="checkPermi(['platform:merchant:update'])"
                  >编辑</el-dropdown-item
                >
                <el-dropdown-item
                  @click.native="onPassword(scope.row.id, 1)"
                  v-if="checkPermi(['platform:merchant:update:password'])"
                  >修改管理员密码</el-dropdown-item
                >
                <el-dropdown-item
                  @click.native="handleTimes(scope.row, 2)"
                  v-if="checkPermi(['platform:merchant:copy:prodcut:num'])"
                  >设置第三方平台商品复制次数</el-dropdown-item
                >
              </el-dropdown-menu>
            </el-dropdown>
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
    <creat-merchant
      v-if="dialogVisible"
      ref="creatMerchants"
      :merId="merId"
      :indexKey="indexKey"
      :dialogVisible="dialogVisible"
      :is-disabled="isDisabled"
      @getList="getChange"
      @closeModel="closeModel"
    ></creat-merchant>
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
import * as merchant from '@/api/merchant';
import creatMerchant from './creatMerchant';
import Cookies from 'js-cookie';
import { mapGetters } from 'vuex';
import { checkPermi } from '@/utils/permission'; // 权限判断函数

export default {
  name: 'MerchantList',
  components: { creatMerchant },
  data() {
    return {
      dialogVisible: false,
      fromList: this.$constants.fromList,
      isChecked: false,
      listLoading: true,
      headeNum: [
        {
          count: '',
          type: '1',
          title: '正常开启的商户',
        },
        {
          count: '',
          type: '0',
          title: '已关闭商户',
        },
      ],
      tableData: {
        data: [],
        total: 0,
      },
      tableFrom: {
        page: 1,
        limit: 20,
        dateLimit: '',
        isSwitch: '0',
        keywords: '',
        isSelf: '',
        categoryId: '',
        typeId: '',
      },
      autoUpdate: true,
      timeVal: [],
      merId: 0,
      keyNum: 0,
      isDisabled: false,
      indexKey: 0,
    };
  },
  computed: {
    ...mapGetters(['merchantClassify', 'merchantType']),
  },
  mounted() {
    if (!this.merchantClassify.length && checkPermi(['platform:merchant:category:all']))
      this.$store.dispatch('merchant/getMerchantClassify');
    if (!this.merchantType.length && checkPermi(['platform:merchant:type:all']))
      this.$store.dispatch('merchant/getMerchantType');
    if (checkPermi(['platform:merchant:list:header:num'])) this.getHeadNum();
    if (checkPermi(['platform:merchant:page:list'])) this.getList('');
  },
  methods: {
    checkPermi,
    // 选择时间
    selectChange(tab) {
      this.tableFrom.dateLimit = tab;
      this.timeVal = [];
      this.tableFrom.page = 1;
      this.getList('');
    },
    // 具体日期
    onchangeTime(e) {
      this.timeVal = e;
      this.tableFrom.dateLimit = this.timeVal ? this.timeVal.join(',') : '';
      this.tableFrom.page = 1;
      this.getList('');
    },
    // 获取开启商户数
    getHeadNum() {
      merchant
        .merHeaderNumApi()
        .then((res) => {
          this.headeNum[0]['count'] = res.openNum;
          this.headeNum[1]['count'] = res.closeNum;
        })
        .catch((res) => {});
    },
    // 列表
    getList(num) {
      this.listLoading = true;
      this.tableFrom.page = num ? num : this.tableFrom.page;
      merchant
        .merchantListAddApi(this.tableFrom)
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
      this.getList('');
    },
    handleSizeChange(val) {
      this.tableFrom.limit = val;
      this.getList(1);
    },
    // 修改状态
    onchangeIsShow(row) {
      if (this.tableFrom.isSwitch === '0') return;
      const title = !row.isRecommend ? '是否开启推荐商户' : '是否关闭推荐商户';
      this.$modalSure(title).then(() => {
        merchant.merchantSwitchApi(row.id).then((res) => {
          row.isRecommend = !row.isRecommend;
          this.$message.success('切换商户推荐开关成功');
        });
      });
    },
    // 开启关闭
    onchangeIsClose(row) {
      !row.isSwitch
        ? merchant.merchantOpenApi(row.id).then(() => {
            this.$message.success('开启成功');
            this.tableFrom.isSwitch = '1';
            this.getHeadNum();
            this.getList('');
          })
        : merchant.merchantCloseApi(row.id).then(() => {
            this.$message.success('关闭成功');
            this.tableFrom.isSwitch = '0';
            this.getHeadNum();
            this.getList('');
          });
    },
    getChange() {
      this.getHeadNum();
      this.getList(1);
    },
    closeModel() {
      this.dialogVisible = false;
    },
    // 添加
    onAdd() {
      this.isDisabled = false;
      this.dialogVisible = true;
      this.merId = 0;
    },
    // 编辑
    onEdit(id, n) {
      this.merId = id;
      n ? (this.isDisabled = true) : (this.isDisabled = false);
      this.dialogVisible = true;
      this.indexKey += 1;
    },
    // 设置复制次数
    handleTimes(row, num) {
      this.merId = row.id;
      let nums = row.copyProductNum;
      const _this = this;
      this.$modalParserFrom(
        '修改复制商品数量',
        154,
        0,
        { copyProductNum: nums || '0' },
        function (formValue) {
          _this.submit(formValue, num);
        },
        (this.keyNum += 1),
      );
    },
    // 修改密码表单
    onPassword(id, num) {
      this.merId = id;
      const _this = this;
      this.$modalParserFrom(
        '修改密码',
        153,
        1,
        { newPassword: '', passwordAgain: '' },
        function (formValue) {
          _this.submit(formValue, num);
        },
        (this.keyNum += 1),
      );
    },
    //表单提交
    submit(formValue, num) {
      if (num === 1) {
        const data = {
          id: this.merId,
          newPassword: formValue.newPassword,
          passwordAgain: formValue.passwordAgain,
        };
        merchant
          .merchantupdatePasswordApi(data)
          .then((res) => {
            this.$message.success('操作成功');
            this.$msgbox.close();
          })
          .catch(() => {
            this.loading = false;
          });
      } else {
        const data = {
          id: this.merId,
          type: formValue.type,
          num: formValue.num,
        };
        merchant
          .merchantCopyNumApi(data)
          .then((res) => {
            this.$message.success('操作成功');
            this.$msgbox.close();
          })
          .catch(() => {
            this.loading = false;
          });
      }
    },
  },
};
</script>

<style scoped lang="scss">
.demo-table-expand label {
  width: 90px;
}
.el-dropdown-link {
  cursor: pointer;
  color: #1890ff;
  font-size: 12px;
}
.el-icon-arrow-down {
  font-size: 12px;
}
.icon-arrow-down {
  ::v-deep .el-dropdown-menu__item {
    font-size: 12px;
  }
}
</style>
