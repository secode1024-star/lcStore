<template>
  <div class="divBox">
    <div>
      <el-card :bordered="false" class="box-card">
        <!-- <div>
          <el-tabs v-model="currentTab" @tab-click="changeTab">
            <el-tab-pane
              :label="item.label"
              :name="item.value.toString()"
              v-for="(item, index) in headerList"
              :key="index + '-only'"
            />
          </el-tabs>
        </div> -->

        <el-table
          :data="levelLists"
          ref="table"
          class="mt25"
          size="small"
          v-loading="loadingList"
          :header-cell-style="{ fontWeight: 'bold' }"
        >
          <el-table-column label="ID" prop="id" width="80"></el-table-column>
          <el-table-column label="通知类型" prop="type"></el-table-column>
          <el-table-column label="通知场景说明" prop="description"></el-table-column>
          <el-table-column label="标识" prop="mark"></el-table-column>
          <el-table-column label="发送邮箱" prop="isEmail">
            <template slot-scope="scope">
              <el-switch
                v-if="scope.row.isEmail !== 0 && checkPermi(['platform:system:notification:email:switch'])"
                v-model="scope.row.isEmail"
                :active-value="1"
                :inactive-value="2"
                active-text="启用"
                inactive-text="禁用"
                @change="changeEmail(scope.row)"
              >
              </el-switch>
              <span v-else>{{ scope.row.isEmail ? '启用' : '禁用' }}</span>
            </template>
          </el-table-column>
          <el-table-column label="发送短信" prop="isSms">
            <template slot-scope="scope">
              <el-switch
                v-if="scope.row.isSms !== 0 && checkPermi(['platform:system:notification:sms:switch'])"
                v-model="scope.row.isSms"
                :active-value="1"
                :inactive-value="2"
                active-text="启用"
                inactive-text="禁用"
                @change="changeSms(scope.row)"
              >
              </el-switch>
              <span v-else>{{ scope.row.isSms ? '启用' : '禁用' }}</span>
            </template>
          </el-table-column>
          <el-table-column label="海外短信" prop="isOverseaSms">
            <template slot-scope="scope">
              <el-switch
                v-if="scope.row.isOverseaSms !== 0 && checkPermi(['platform:system:notification:oversea:sms:switch'])"
                v-model="scope.row.isOverseaSms"
                :active-value="1"
                :inactive-value="2"
                active-text="启用"
                inactive-text="禁用"
                @change="changeOversea(scope.row)"
              >
              </el-switch>
              <span v-else>{{ scope.row.isOverseaSms ? '启用' : '禁用' }}</span>
            </template>
          </el-table-column>
          <el-table-column label="设置" prop="id">
            <template slot-scope="scope">
              <el-button type="text" @click="setting(scope.row)" v-hasPermi="['platform:system:notification:detail']"
                >详情</el-button
              >
            </template>
          </el-table-column>
        </el-table>
      </el-card>
    </div>
    <el-dialog title="通知详情" :visible.sync="centerDialogVisible" width="50%">
      <el-tabs v-model="infoTab" @tab-click="changeInfo">
        <el-tab-pane :label="item.label" :name="item.value.toString()" v-for="(item, index) in infoList" :key="index" />
        <el-form ref="form" :model="form" label-width="80px">
          <el-form-item label="ID">
            <el-input v-model="form.id" disabled></el-input>
          </el-form-item>
          <el-form-item label="模板名" v-if="form.name">
            <el-input v-model="form.name" disabled></el-input>
          </el-form-item>
          <el-form-item label="模板ID" v-if="form.tempId">
            <el-input v-model="form.tempId"></el-input>
          </el-form-item>
          <el-form-item label="模板类型" v-if="form.type">
            <el-input v-model="form.type" disabled></el-input>
          </el-form-item>
          <el-form-item label="模板编号" v-if="form.tempKey">
            <el-input v-model="form.tempKey" disabled></el-input>
          </el-form-item>
          <el-form-item label="模板说明" v-if="form.title">
            <el-input v-model="form.title" disabled></el-input>
          </el-form-item>
          <el-form-item label="短信模板" v-if="form.content">
            <el-input v-model="form.content" type="textarea" :rows="2" disabled></el-input>
          </el-form-item>
          <el-form-item label="邮件主题" v-if="form.subject">
            <el-input v-model="form.subject" disabled></el-input>
          </el-form-item>
          <el-form-item label="邮件正文" v-if="form.text">
            <el-input v-model="form.text" type="textarea" :rows="2" disabled></el-input>
          </el-form-item>
          <el-form-item v-if="detailType === 'email'" label="状态">
            <el-radio-group v-model="form.status" disabled>
              <el-radio label="1">开启</el-radio>
              <el-radio label="0">关闭</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item v-else label="状态">
            <el-radio-group v-model="form.status">
              <el-radio label="1">开启</el-radio>
              <el-radio label="2">关闭</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-form>
      </el-tabs>
      <span v-show="detailType !== 'email'" slot="footer" class="dialog-footer">
        <el-button @click="centerDialogVisible = false">取 消</el-button>
        <el-button type="primary" v-hasPermi="['platform:system:notification:update']" @click="submit()"
          >确 定</el-button
        >
      </span>
    </el-dialog>
  </div>
</template>

<script>
import {
  notificationListApi,
  notificationSms,
  overseaSwitch,
  notificationEmail,
  notificationDetail,
  notificationUpdate,
} from '@/api/systemFormConfig';
import { Debounce } from '@/utils/validate';
import { checkPermi } from '@/utils/permission'; // 权限判断函数
export default {
  data() {
    return {
      modalTitle: '',
      notificationModal: false,
      headerList: [
        { label: '通知会员', value: '1' },
        { label: '通知平台', value: '2' },
      ],
      id: 0,
      levelLists: [],
      currentTab: '1',
      loading: false,
      formData: {},
      industry: null,
      loadingList: false,
      centerDialogVisible: false,
      infoList: [],
      form: {
        content: '',
        name: '',
        id: '',
        status: null,
        tempId: '',
        tempKey: '',
        title: '',
      },
      detailType: '',
      infoTab: '',
    };
  },
  created() {
    this.getNotificationList(1);
  },
  methods: {
    checkPermi,
    changeTab(data) {
      this.getNotificationList(data.name);
    },
    //获取消息列表
    getNotificationList(id) {
      this.loadingList = true;
      notificationListApi({ sendType: id })
        .then((res) => {
          this.loadingList = false;
          this.levelLists = res;
        })
        .catch((res) => {
          this.loadingList = false;
        });
    },
    //短信消息开关
    changeSms(row) {
      notificationSms(row.id).then((res) => {
        this.$modal.msgSuccess('修改成功');
      });
    },
    //海外短信
    changeOversea(row) {
      overseaSwitch(row.id).then((res) => {
        this.$modal.msgSuccess('修改成功');
      });
    },
    //邮件开关
    changeEmail(row) {
      notificationEmail(row.id).then((res) => {
        this.$modal.msgSuccess('修改成功');
      });
    },
    //详情tab切换
    changeInfo(data) {
      this.getNotificationDetail(data);
    },
    //详情数据
    getNotificationDetail(param) {
      let data = {
        id: this.id,
        type: param.name,
      };
      this.$set(this, 'detailType', data.type);
      notificationDetail(data).then((res) => {
        this.form = res;
        this.$set(this.form, 'status', res.status.toString());
      });
    },
    // 设置
    setting(row) {
      this.infoList = [];
      this.id = row.id;
      this.centerDialogVisible = true;
      if (row.isSms !== 0) {
        this.infoList.push({ label: '短信', value: 'sms' });
      }
      if (row.isEmail !== 0) {
        this.infoList.push({ label: '邮箱', value: 'email' });
      }
      if (row.isOverseaSms !== 0) {
        this.infoList.push({ label: '海外短信', value: 'overseaSms' });
      }
      this.infoTab = this.infoList[0].value;
      this.getNotificationDetail({ name: this.infoTab });
    },
    //修改通知
    submit: Debounce(function () {
      let data = {
        id: this.id,
        status: Number(this.form.status),
        tempId: this.form.tempId,
        type: this.detailType,
      };
      notificationUpdate(data).then((res) => {
        this.$modal.msgSuccess('修改成功');
        this.centerDialogVisible = false;
        this.getNotificationList();
      });
    }),
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
