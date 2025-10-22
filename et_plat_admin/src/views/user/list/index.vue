<template>
  <div class="divBox relative">
    <el-card class="box-card">
      <div slot="header" class="clearfix" ref="tableheader">
        <el-tabs v-model="loginType" @tab-click="getList(1)">
          <el-tab-pane :label="item.name" :name="item.type.toString()" v-for="(item, index) in headeNum" :key="index" />
        </el-tabs>
        <div class="container">
          <el-form
            inline
            size="small"
            :model="userFrom"
            ref="userFrom"
            :label-position="labelPosition"
            label-width="100px"
          >
            <el-row>
              <el-col :xs="24" :sm="24" :md="24" :lg="18" :xl="18">
                <el-col v-bind="grid">
                  <el-form-item label="用户昵称：">
                    <el-input v-model="userFrom.nikename" placeholder="请输入用户昵称" clearable class="selWidth" />
                  </el-form-item>
                </el-col>
              </el-col>
              <template v-if="collapse">
                <el-col :xs="24" :sm="24" :md="24" :lg="18" :xl="18">
                  <el-col v-bind="grid">
                    <el-form-item label="用户标签：">
                      <el-select
                        v-model="labelData"
                        placeholder="请选择"
                        class="selWidth"
                        clearable
                        filterable
                        multiple
                      >
                        <el-option
                          :value="item.id"
                          v-for="(item, index) in labelLists"
                          :key="index"
                          :label="item.name"
                        ></el-option>
                      </el-select>
                    </el-form-item>
                  </el-col>
                  <el-col v-bind="grid">
                    <el-form-item label="消费情况：">
                      <el-select v-model="userFrom.payCount" placeholder="请选择" class="selWidth" clearable>
                        <el-option value="" label="全部"></el-option>
                        <el-option value="0" label="0"></el-option>
                        <el-option value="1" label="1+"></el-option>
                        <el-option value="2" label="2+"></el-option>
                        <el-option value="3" label="3+"></el-option>
                        <el-option value="4" label="4+"></el-option>
                        <el-option value="5" label="5+"></el-option>
                      </el-select>
                    </el-form-item>
                  </el-col>
                  <el-col v-bind="grid">
                    <el-form-item label="访问情况：">
                      <el-select v-model="userFrom.accessType" placeholder="请选择" class="selWidth">
                        <el-option :value="0" label="全部"></el-option>
                        <el-option :value="1" label="首次访问"></el-option>
                        <el-option :value="2" label="时间段访问过"></el-option>
                        <el-option :value="3" label="时间段未访问"></el-option>
                      </el-select>
                    </el-form-item>
                  </el-col>
                  <el-col v-bind="grid">
                    <el-form-item label="手机号：">
                      <el-input
                        v-model="userFrom.phone"
                        placeholder="请输入手机号，不包含国标区号，不支持模糊搜索"
                        clearable
                        class="selWidth"
                      />
                    </el-form-item>
                  </el-col>
                  <el-col v-bind="grid">
                    <el-form-item label="邮箱：">
                      <el-input
                        v-model="userFrom.email"
                        placeholder="请输入邮箱，不支持模糊搜索"
                        clearable
                        class="selWidth"
                      />
                    </el-form-item>
                  </el-col>
                  <el-col v-bind="grid">
                    <el-form-item label="访问时间：" class="timeBox">
                      <el-date-picker
                        v-model="timeVal"
                        align="right"
                        unlink-panels
                        value-format="yyyy-MM-dd"
                        format="yyyy-MM-dd"
                        size="small"
                        type="daterange"
                        placement="bottom-end"
                        placeholder="自定义时间"
                        class="selWidth"
                        :picker-options="pickerOptions"
                        @change="onchangeTime"
                      />
                    </el-form-item>
                  </el-col>
                </el-col>
              </template>
              <el-col :xs="24" :sm="24" :md="24" :lg="6" :xl="6" class="text-right userFrom">
                <el-form-item>
                  <el-button
                    type="primary"
                    icon="ios-search"
                    label="default"
                    class="mr15"
                    size="small"
                    @click="userSearchs"
                    >查询</el-button
                  >
                  <el-button class="ResetSearch mr10" @click="reset('userFrom')" size="small">重置</el-button>
                  <a class="ivu-ml-8" @click="onCollapse">
                    <template v-if="!collapse"> 展开 <i class="el-icon-arrow-down"></i> </template>
                    <template v-else> 收起 <i class="el-icon-arrow-up"></i> </template>
                  </a>
                </el-form-item>
              </el-col>
            </el-row>
          </el-form>
        </div>
        <div class="btn_bt">
          <el-button class="mr10" size="small" @click="setBatch('label')">批量设置标签</el-button>
        </div>
      </div>
      <el-table
        ref="table"
        v-loading="listLoading"
        :data="tableData.data"
        style="width: 100%"
        size="mini"
        :height="tableHeight"
        @selection-change="onSelectTab"
        highlight-current-row
      >
        <el-table-column type="expand">
          <template slot-scope="props">
            <el-form label-position="left" inline class="demo-table-expand">
              <el-form-item label="真实姓名：">
                <span>{{ props.row.realName | filterEmpty }}</span>
              </el-form-item>
              <!--<el-form-item label="性别">-->
              <!--<span>{{props.row.sex | sexFilter}}</span>-->
              <!--</el-form-item>-->
              <el-form-item label="首次访问：">
                <span>{{ props.row.createTime | filterEmpty }}</span>
              </el-form-item>
              <el-form-item label="近次访问：">
                <span>{{ props.row.lastLoginTime | filterEmpty }}</span>
              </el-form-item>
              <el-form-item label="标签：">
                <span>{{ props.row.tagId | tagFilter }}</span>
              </el-form-item>
              <el-form-item label="备注：">
                <span>{{ props.row.mark | filterEmpty }}</span>
              </el-form-item>
            </el-form>
          </template>
        </el-table-column>
        <el-table-column type="selection" width="55"> </el-table-column>
        <el-table-column prop="uid" label="ID" min-width="80" />
        <el-table-column label="头像" min-width="80">
          <template slot-scope="scope">
            <div class="demo-image__preview">
              <el-image
                style="width: 36px; height: 36px"
                :src="$imageUrl(scope.row.avatar)"
                :preview-src-list="[scope.row.avatar]"
              />
            </div>
          </template>
        </el-table-column>
        <el-table-column label="昵称" min-width="130" v-if="checkedCities.includes('昵称')">
          <template slot-scope="scope">
            <span>{{ scope.row.nickname | filterEmpty }}</span>
          </template>
        </el-table-column>
        <el-table-column label="手机号" min-width="100">
          <template slot-scope="scope">
            <span>{{ scope.row.phone | filterEmpty }}</span>
          </template>
        </el-table-column>
        <el-table-column label="邮箱" min-width="100">
          <template slot-scope="scope">
            <span>{{ scope.row.email | filterEmpty }}</span>
          </template>
        </el-table-column>
        <el-table-column label="用户类型" min-width="100">
          <template slot-scope="scope">
            <span>{{ scope.row.userType | typeFilter }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" min-width="130" fixed="right" align="center" :render-header="renderHeader">
          <template slot-scope="scope">
            <el-button type="text" @click="editUser(scope.row.uid)" size="small" v-hasPermi="['platform:user:update']"
              >编辑</el-button
            >
            <el-dropdown trigger="click">
              <span class="el-dropdown-link"> 更多<i class="el-icon-arrow-down el-icon--right" /> </span>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item @click.native="onDetails(scope.row.uid)" v-if="checkPermi(['platform:user:info'])"
                  >账户详情</el-dropdown-item
                >
                <el-dropdown-item @click.native="setBatch('label', scope.row)" v-if="checkPermi(['platform:user:tag'])"
                  >设置标签</el-dropdown-item
                >
              </el-dropdown-menu>
            </el-dropdown>
          </template>
        </el-table-column>
      </el-table>
      <div class="block">
        <el-pagination
          :page-sizes="[15, 30, 45, 60]"
          :page-size="userFrom.limit"
          :current-page="userFrom.page"
          layout="total, sizes, prev, pager, next, jumper"
          :total="tableData.total"
          @size-change="handleSizeChange"
          @current-change="pageChange"
        />
      </div>
    </el-card>
    <div class="card_abs" v-show="card_select_show" :style="{ top: collapse ? 570 + 'px' : 270 + 'px' }">
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
    <!--用户列表-->
    <el-dialog title="用户列表" :visible.sync="userVisible" width="900px">
      <user-list v-if="userVisible" @getTemplateRow="getTemplateRow"></user-list>
      <span slot="footer" class="dialog-footer">
        <el-button @click="userVisible = false">取 消</el-button>
        <el-button type="primary" @click="userVisible = false">确 定</el-button>
      </span>
    </el-dialog>
    <!--批量设置-->
    <el-dialog title="设置" :visible.sync="dialogVisible" width="500px" :before-close="handleClose">
      <el-form
        :model="dynamicValidateForm"
        ref="dynamicValidateForm"
        label-width="100px"
        class="demo-dynamic"
        v-loading="loading"
      >
        <el-form-item
          prop="groupId"
          label="用户标签"
          :rules="[{ required: true, message: '请选择用户标签', trigger: 'change' }]"
        >
          <el-select
            v-model="dynamicValidateForm.groupId"
            placeholder="请选择标签"
            style="width: 80%"
            filterable
            multiple
          >
            <el-option :value="item.id" v-for="(item, index) in labelLists" :key="index" :label="item.name"></el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="handleClose">取 消</el-button>
        <el-button type="primary" @click="submitForm('dynamicValidateForm')">确 定</el-button>
      </span>
    </el-dialog>
    <!--编辑-->
    <el-dialog title="编辑" :visible.sync="visible" width="600px">
      <edit-from v-if="visible" :uid="uid" @resetForm="resetForm"></edit-from>
    </el-dialog>
    <!--账户详情-->
    <el-dialog title="用户详情" :visible.sync="Visible" width="1100px" v-if="uid" :before-close="Close">
      <user-details ref="userDetails" :uid="uid" v-if="Visible"></user-details>
    </el-dialog>
  </div>
</template>

<script>
import { tagAllListApi, userListApi, levelListApi, groupPiApi, tagPiApi, updateSpreadApi } from '@/api/user';
import editFrom from './edit';
import userDetails from './userDetails';
import levelEdit from './level';
import userList from '@/components/userList';
import { checkPermi } from '@/utils/permission'; // 权限判断函数
import { Debounce } from '@/utils/validate';
export default {
  name: 'UserIndex',
  components: { editFrom, userDetails, userList, levelEdit },
  filters: {
    sexFilter(status) {
      const statusMap = {
        0: '未知',
        1: '男',
        2: '女',
        3: '保密',
      };
      return statusMap[status];
    },
    typeFilter(value) {
      const statusMap = {
        facebook: 'Facebook',
        twitter: 'Twitter',
        google: 'Google',
        email: 'Email',
        phone: 'Phone',
        visitor: '游客',
      };
      return statusMap[value];
    },
  },
  data() {
    return {
      tableHeight: 0,
      formExtension: {
        image: '',
        spreadUid: '',
        userId: '',
      },
      ruleInline: {},
      extensionVisible: false,
      userVisible: false,
      levelInfo: '',
      pickerOptions: this.$timeOptions,
      loadingBtn: false,
      PointValidateForm: {
        integralType: 2,
        integralValue: 0,
        moneyType: 2,
        moneyValue: 0,
        uid: '',
      },
      loadingPoint: false,
      VisiblePoint: false,
      visible: false,
      userIds: '',
      dialogVisible: false,
      levelData: [],
      groupData: [],
      labelData: [],
      selData: [],
      labelPosition: 'right',
      collapse: false,
      props: {
        children: 'child',
        label: 'name',
        value: 'name',
        emitPath: false,
      },
      propsCity: {
        children: 'child',
        label: 'name',
        value: 'name',
      },
      headeNum: [
        { type: '', name: '全部用户' },
        { type: 'facebook', name: 'Facebook' },
        { type: 'twitter', name: 'Twitter' },
        { type: 'google', name: 'Google' },
        { type: 'email', name: 'Email' },
        { type: 'phone', name: 'Phone' },
        { type: 'visitor', name: '游客' },
      ],
      listLoading: true,
      tableData: {
        data: [],
        total: 0,
      },
      loginType: '',
      userFrom: {
        labelId: '',
        userType: '',
        phone: '',
        email: '',
        // isPromoter: '',
        // country: '',
        payCount: '',
        accessType: 0,
        dateLimit: '',
        nikename: '',
        // province: '',
        // city: '',
        page: 1,
        limit: 15,
        //level: '',
        status: null,
      },
      grid: {
        xl: 8,
        lg: 12,
        md: 12,
        sm: 24,
        xs: 24,
      },
      levelList: [],
      labelLists: [],
      selectedData: [],
      timeVal: [],
      dynamicValidateForm: {
        groupId: [],
      },
      loading: false,
      groupIdFrom: [],
      selectionList: [],
      batchName: '',
      uid: 0,
      Visible: false,
      keyNum: 0,
      address: [],
      multipleSelectionAll: [],
      idKey: 'uid',
      card_select_show: false,
      checkAll: false,
      checkedCities: ['ID', '头像', '昵称', '用户等级', '分组', '推荐人', '手机号', '余额', '积分'],
      columnData: ['ID', '头像', '昵称', '用户等级', '分组', '推荐人', '手机号', '余额', '积分'],
      isIndeterminate: true,
    };
  },
  created() {
    // 浏览器高度
    let windowHeight = document.documentElement.clientHeight || document.body.clientHeight;

    // 此处减去100即为当前屏幕内除了表格高度以外其它内容的总高度，
    // this.tableHeight = windowHeight - 388;
  },
  activated() {
    this.labelLists = JSON.parse(localStorage.getItem('tagAllList')) || [];
    if (this.labelLists.length === 0) this.getAlltag();
    this.userFrom.nikename = '';
    this.loginType = '0';
    this.getList(1);
  },
  mounted() {
    this.labelLists = JSON.parse(localStorage.getItem('tagAllList')) || [];
    if (this.labelLists.length === 0) this.getAlltag();
    this.getList();
    this.$nextTick(() => {
      let tableHeader = this.$refs.tableheader.offsetHeight;
      this.tableHeight = this.$selfUtil.getTableHeight(tableHeader + 100);
    });
  },
  methods: {
    checkPermi,
    getAlltag() {
      tagAllListApi().then((res) => {
        this.labelLists = res;
        localStorage.setItem('tagAllList', JSON.stringify(res));
      });
    },
    onCollapse() {
      this.collapse = !this.collapse;
      this.$nextTick(() => {
        let tableHeader = this.$refs.tableheader.offsetHeight;
        this.tableHeight = this.$selfUtil.getTableHeight(tableHeader + 100);
      });
    },
    onSubExtension(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          updateSpreadApi(this.formExtension).then((res) => {
            this.$message.success('设置成功');
            this.extensionVisible = false;
            this.getList();
          });
        } else {
          return false;
        }
      });
    },
    getTemplateRow(row) {
      this.formExtension.image = row.avatar;
      this.formExtension.spreadUid = row.uid;
    },
    // setExtension(row){
    //   this.formExtension = {
    //       image: '',
    //       spreadUid: '',
    //       userId: row.uid
    //   };
    //   this.extensionVisible = true
    // },
    handleCloseExtension() {
      this.extensionVisible = false;
    },
    modalPicTap() {
      this.userVisible = true;
    },
    resetForm() {
      this.visible = false;
    },
    reset(formName) {
      this.userFrom = {
        labelId: '',
        userType: '',
        isPromoter: '',
        country: '',
        payCount: '',
        accessType: 0,
        dateLimit: '',
        nikename: '',
        province: '',
        city: '',
        page: 1,
        limit: 15,
        level: '',
        phone: '',
        email: '',
      };
      this.levelData = [];
      this.groupData = [];
      this.labelData = [];
      this.timeVal = [];
      this.getList();
    },
    // 发送优惠劵
    onSend() {
      if (this.selectionList.length === 0) return this.$message.warning('请选择要设置的用户');
      const _this = this;
      this.$modalCoupon(
        'send',
        (this.keyNum += 1),
        [],
        function (row) {
          _this.formValidate.give_coupon_ids = [];
          _this.couponData = [];
          row.map((item) => {
            _this.formValidate.give_coupon_ids.push(item.coupon_id);
            _this.couponData.push(item.title);
          });
          _this.selectionList = [];
        },
        this.userIds,
        'user',
      );
    },
    Close() {
      this.Visible = false;
    },
    // 账户详情
    onDetails(id) {
      this.uid = id;
      this.Visible = true;
    },
    editUser(id) {
      this.uid = id;
      this.visible = true;
    },
    submitForm(formName) {
      // let data = [];
      // if(!this.userIds){
      //   if(this.multipleSelectionAll.length){
      //     this.multipleSelectionAll.map((item) => {
      //       data.push(item.uid)
      //     });
      //     this.userIds = data.join(',');
      //   }
      // }
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.loading = true;
          this.batchName === 'group'
            ? groupPiApi({ groupId: this.dynamicValidateForm.groupId, uids: this.userIds })
                .then((res) => {
                  this.$message.success('设置成功');
                  this.loading = false;
                  this.handleClose();
                  this.getList();
                })
                .catch(() => {
                  this.loading = false;
                })
            : tagPiApi({ tagIds: this.dynamicValidateForm.groupId.join(','), uids: this.userIds })
                .then((res) => {
                  this.$message.success('设置成功');
                  this.loading = false;
                  this.handleClose();
                  this.getList();
                })
                .catch(() => {
                  this.loading = false;
                });
        } else {
          return false;
        }
      });
    },
    setBatch(name, row) {
      this.batchName = name;
      if (row) {
        this.userIds = row.uid;
        if (this.batchName === 'group') {
          this.dynamicValidateForm.groupId = row.groupId ? Number(row.groupId) : null;
        } else {
          this.dynamicValidateForm.groupId = row.tagId ? row.tagId.split(',').map(Number) : [];
        }
      } else {
        this.dynamicValidateForm.groupId = this.batchName === 'group' ? null : [];
      }
      if (this.multipleSelectionAll.length === 0 && !row) return this.$message.warning('请选择要设置的用户');
      this.dialogVisible = true;
    },
    handleClose() {
      this.dialogVisible = false;
      this.$refs['dynamicValidateForm'].resetFields();
    },
    // 记忆选择核心方法
    changePageCoreRecordData() {
      // 标识当前行的唯一键的名称
      const idKey = this.idKey;
      const that = this;
      // 如果总记忆中还没有选择的数据，那么就直接取当前页选中的数据，不需要后面一系列计算
      if (this.multipleSelectionAll.length <= 0) {
        this.multipleSelectionAll = this.selectionList;
        return;
      }
      // 总选择里面的key集合
      const selectAllIds = [];
      this.multipleSelectionAll.forEach((row) => {
        selectAllIds.push(row[idKey]);
      });
      const selectIds = [];
      // 获取当前页选中的id
      this.selectionList.forEach((row) => {
        selectIds.push(row[idKey]);
        // 如果总选择里面不包含当前页选中的数据，那么就加入到总选择集合里
        if (selectAllIds.indexOf(row[idKey]) < 0) {
          that.multipleSelectionAll.push(row);
        }
      });
      const noSelectIds = [];
      // 得到当前页没有选中的id
      this.tableData.data.forEach((row) => {
        if (selectIds.indexOf(row[idKey]) < 0) {
          noSelectIds.push(row[idKey]);
        }
      });
      noSelectIds.forEach((uid) => {
        if (selectAllIds.indexOf(uid) >= 0) {
          for (let i = 0; i < that.multipleSelectionAll.length; i++) {
            if (that.multipleSelectionAll[i][idKey] == uid) {
              // 如果总选择中有未被选中的，那么就删除这条
              that.multipleSelectionAll.splice(i, 1);
              break;
            }
          }
        }
      });
    },
    // 全选
    onSelectTab(selection) {
      this.selectionList = selection;
      setTimeout(() => {
        this.changePageCoreRecordData();
        let data = [];
        if (this.multipleSelectionAll.length > 0) {
          this.multipleSelectionAll.map((item) => {
            data.push(item.uid);
          });
          this.userIds = data.join(',');
        }
      }, 50);
    },
    // 搜索
    userSearchs() {
      this.userFrom.page = 1;
      this.getList();
    },
    // 选择国家
    changeCountry() {
      if (this.userFrom.country === 'OTHER' || !this.userFrom.country) {
        this.selectedData = [];
        this.userFrom.province = '';
        this.userFrom.city = '';
        this.address = [];
      }
    },
    // 选择地址
    handleChange(value) {
      this.userFrom.province = value[0];
      this.userFrom.city = value[1];
    },
    // 具体日期
    onchangeTime(e) {
      this.timeVal = e;
      this.userFrom.dateLimit = e ? this.timeVal.join(',') : '';
    },
    // 等级列表
    levelLists() {
      levelListApi().then(async (res) => {
        this.levelList = res;
        localStorage.setItem('levelKey', JSON.stringify(res));
      });
    },
    // 列表
    getList(num) {
      this.listLoading = true;
      this.userFrom.page = num ? num : this.userFrom.page;
      this.userFrom.userType = this.loginType;
      if (this.loginType == 0) this.userFrom.userType = '';
      // this.userFrom.level = this.levelData.join(',')
      this.userFrom.groupId = this.groupData.join(',');
      this.userFrom.labelId = this.labelData.join(',');
      userListApi(this.userFrom)
        .then((res) => {
          this.tableData.data = res.list;
          this.tableData.total = res.total;
          this.$nextTick(function () {
            this.setSelectRow(); // 调用跨页选中方法
          });
          this.listLoading = false;
        })
        .catch(() => {
          this.listLoading = false;
        });
      this.checkedCities = this.$cache.local.has('user_stroge')
        ? this.$cache.local.getJSON('user_stroge')
        : this.checkedCities;
      this.$set(this, 'card_select_show', false);
    },
    // 设置选中的方法
    setSelectRow() {
      if (!this.multipleSelectionAll || this.multipleSelectionAll.length <= 0) {
        return;
      }
      // 标识当前行的唯一键的名称
      const idKey = this.idKey;
      const selectAllIds = [];
      this.multipleSelectionAll.forEach((row) => {
        selectAllIds.push(row[idKey]);
      });
      this.$refs.table.clearSelection();
      for (var i = 0; i < this.tableData.data.length; i++) {
        if (selectAllIds.indexOf(this.tableData.data[i][idKey]) >= 0) {
          // 设置选中，记住table组件需要使用ref="table"
          this.$refs.table.toggleRowSelection(this.tableData.data[i], true);
        }
      }
    },
    pageChange(page) {
      this.changePageCoreRecordData();
      this.userFrom.page = page;
      this.getList();
    },
    handleSizeChange(val) {
      this.changePageCoreRecordData();
      this.userFrom.limit = val;
      this.getList();
    },
    // 删除
    handleDelete(id, idx) {
      this.$modalSure().then(() => {
        productDeleteApi(id).then(() => {
          this.$message.success('删除成功');
          this.getList();
        });
      });
    },
    onchangeIsShow(row) {
      row.isShow
        ? putOnShellApi(row.id)
            .then(() => {
              this.$message.success('上架成功');
              this.getList();
            })
            .catch(() => {
              row.isShow = !row.isShow;
            })
        : offShellApi(row.id)
            .then(() => {
              this.$message.success('下架成功');
              this.getList();
            })
            .catch(() => {
              row.isShow = !row.isShow;
            });
    },
    renderHeader(h) {
      return (
        <p>
          <span style="padding-right:5px;">操作</span>
        </p>
      );
      //<i class="el-icon-setting" onClick={()=>this.handleAddItem()}></i>
    },
    handleAddItem() {
      if (this.card_select_show) {
        this.$set(this, 'card_select_show', false);
      } else if (!this.card_select_show) {
        this.$set(this, 'card_select_show', true);
      }
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
      this.$modal.loading('正在保存到本地，请稍候...');
      this.$cache.local.setJSON('user_stroge', this.checkedCities);
      setTimeout(this.$modal.closeLoading(), 1000);
    },
  },
};
</script>

<style scoped lang="scss">
.timeBox {
  ::v-deep.el-date-editor {
    width: 300px !important;
  }
}
.el-dropdown-link {
  cursor: pointer;
  color: #409eff;
  font-size: 12px;
}
.el-icon-arrow-down {
  font-size: 12px;
}
.text-right {
  text-align: right;
}
.demo-table-expand {
  font-size: 0;
}
.demo-table-expand label {
  width: 90px;
  color: #99a9bf;
}
.demo-table-expand .el-form-item {
  margin-right: 0;
  margin-bottom: 0;
  width: 33.33%;
}
.selWidth {
  /*width: 100% !important;*/
}
.seachTiele {
  line-height: 30px;
}
.container {
  min-width: 821px;
  ::v-deepel-form-item {
    width: 100%;
  }
  ::v-deepel-form-item__content {
    width: 72%;
  }
}
.ivu-ml-8 {
  font-size: 12px;
  color: #1682e6;
}
.btn_bt {
  border-top: 1px dashed #ccc;
  padding-top: 20px;
}
.relative {
  position: relative;
}
.card_abs {
  position: absolute;
  padding-bottom: 15px;
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
::v-deep .el-checkbox__input.is-checked + .el-checkbox__label {
  color: #606266;
}
</style>
