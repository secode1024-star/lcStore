<template>
  <div class="app-container">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>客服配置</span>
      </div>
      
      <el-form 
        ref="configForm" 
        :model="configForm" 
        :rules="rules" 
        label-width="120px"
        v-loading="loading"
      >
        <el-form-item label="客服标题" prop="title">
          <el-input 
            v-model="configForm.title" 
            placeholder="请输入客服标题"
            maxlength="50"
            show-word-limit
          />
        </el-form-item>

        <el-form-item label="欢迎消息" prop="welcomeMessage">
          <el-input 
            type="textarea" 
            v-model="configForm.welcomeMessage" 
            placeholder="请输入欢迎消息"
            :rows="3"
            maxlength="200"
            show-word-limit
          />
        </el-form-item>

        <el-form-item label="离线消息" prop="offlineMessage">
          <el-input 
            type="textarea" 
            v-model="configForm.offlineMessage" 
            placeholder="请输入离线消息"
            :rows="3"
            maxlength="200"
            show-word-limit
          />
        </el-form-item>

        <el-form-item label="客服状态">
          <el-switch 
            v-model="configForm.status" 
            active-text="在线" 
            inactive-text="离线"
          />
        </el-form-item>

        <el-form-item label="启用自动回复">
          <el-switch 
            v-model="configForm.autoReply" 
            active-text="启用" 
            inactive-text="禁用"
          />
        </el-form-item>

        <el-form-item 
          label="自动回复消息" 
          prop="autoReplyMessage"
          v-if="configForm.autoReply"
        >
          <el-input 
            type="textarea" 
            v-model="configForm.autoReplyMessage" 
            placeholder="请输入自动回复消息"
            :rows="3"
            maxlength="200"
            show-word-limit
          />
        </el-form-item>

        <el-form-item label="启用客服">
          <el-switch 
            v-model="configForm.isEnabled" 
            active-text="启用" 
            inactive-text="禁用"
          />
        </el-form-item>

        <el-form-item label="工作时间">
          <el-time-picker
            v-model="workTimeStart"
            format="HH:mm"
            value-format="HH:mm"
            placeholder="开始时间"
            style="width: 120px; margin-right: 10px;"
          />
          <span style="margin: 0 10px;">至</span>
          <el-time-picker
            v-model="workTimeEnd"
            format="HH:mm"
            value-format="HH:mm"
            placeholder="结束时间"
            style="width: 120px;"
          />
        </el-form-item>

        <el-form-item>
          <el-button type="primary" @click="saveConfig" :loading="saveLoading">
            保存配置
          </el-button>
          <el-button @click="resetForm">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import { customerServiceConfigApi, customerServiceConfigSaveApi } from '@/api/customerService';

export default {
  name: 'CustomerServiceConfig',
  data() {
    return {
      loading: false,
      saveLoading: false,
      workTimeStart: '09:00',
      workTimeEnd: '18:00',
      configForm: {
        title: '在线客服',
        welcomeMessage: '您好，欢迎咨询！我们将竭诚为您服务。',
        offlineMessage: '客服暂时离线，请留言，我们会尽快回复您。',
        status: true,
        autoReply: false,
        autoReplyMessage: '您好，我们已收到您的消息，客服人员会尽快回复您。',
        isEnabled: true
      },
      rules: {
        title: [
          { required: true, message: '请输入客服标题', trigger: 'blur' }
        ],
        welcomeMessage: [
          { required: true, message: '请输入欢迎消息', trigger: 'blur' }
        ],
        offlineMessage: [
          { required: true, message: '请输入离线消息', trigger: 'blur' }
        ],
        autoReplyMessage: [
          { required: true, message: '请输入自动回复消息', trigger: 'blur' }
        ]
      }
    };
  },
  mounted() {
    this.getConfig();
  },
  methods: {
    // 获取配置
    async getConfig() {
      this.loading = true;
      try {
        const response = await customerServiceConfigApi();
        if (response.data) {
          this.configForm = { ...this.configForm, ...response.data };
        }
      } catch (error) {
        console.error('获取客服配置失败:', error);
        this.$message.error('获取客服配置失败');
      } finally {
        this.loading = false;
      }
    },

    // 保存配置
    async saveConfig() {
      try {
        const valid = await this.$refs.configForm.validate();
        if (!valid) return;

        this.saveLoading = true;
        const response = await customerServiceConfigSaveApi(this.configForm);
        
        this.$message.success('保存成功');
      } catch (error) {
        console.error('保存客服配置失败:', error);
        this.$message.error('保存失败: ' + (error.message || '未知错误'));
      } finally {
        this.saveLoading = false;
      }
    },

    // 重置表单
    resetForm() {
      this.$refs.configForm.resetFields();
      this.getConfig();
    }
  }
};
</script>

<style lang="scss" scoped>
.app-container {
  padding: 20px;
}

.box-card {
  max-width: 800px;
}
</style>




