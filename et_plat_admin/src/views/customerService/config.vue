<template>
  <div class="app-container">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>客服配置</span>
      </div>
      
      <el-form :model="configForm" :rules="rules" ref="configForm" label-width="120px">
        <el-form-item label="客服标题" prop="title">
          <el-input v-model="configForm.title" placeholder="请输入客服标题"></el-input>
        </el-form-item>
        
        <el-form-item label="客服名称" prop="serviceName">
          <el-input v-model="configForm.serviceName" placeholder="请输入客服名称"></el-input>
        </el-form-item>
        
        <el-form-item label="欢迎语" prop="welcomeMessage">
          <el-input 
            type="textarea" 
            :rows="3" 
            v-model="configForm.welcomeMessage" 
            placeholder="请输入欢迎语">
          </el-input>
        </el-form-item>
        
        <el-form-item label="离线提示" prop="offlineMessage">
          <el-input 
            type="textarea" 
            :rows="3" 
            v-model="configForm.offlineMessage" 
            placeholder="请输入离线提示语">
          </el-input>
        </el-form-item>
        
        <el-form-item label="客服状态">
          <el-switch
            v-model="configForm.status"
            :active-value="true"
            :inactive-value="false"
            active-text="在线"
            inactive-text="离线">
          </el-switch>
        </el-form-item>
        
        <el-form-item label="启用客服">
          <el-switch
            v-model="configForm.isEnabled"
            :active-value="true"
            :inactive-value="false"
            active-text="启用"
            inactive-text="禁用">
          </el-switch>
        </el-form-item>
        
        <el-form-item label="自动回复">
          <el-switch
            v-model="configForm.autoReply"
            :active-value="true"
            :inactive-value="false"
            active-text="开启"
            inactive-text="关闭">
          </el-switch>
        </el-form-item>
        
        <el-form-item label="自动回复内容" prop="autoReplyMessage" v-if="configForm.autoReply">
          <el-input 
            type="textarea" 
            :rows="3" 
            v-model="configForm.autoReplyMessage" 
            placeholder="请输入自动回复内容">
          </el-input>
        </el-form-item>
        
        <el-form-item label="工作时间">
          <el-col :span="11">
            <el-time-picker
              v-model="configForm.workingHoursStart"
              format="HH:mm"
              value-format="HH:mm:ss"
              placeholder="开始时间">
            </el-time-picker>
          </el-col>
          <el-col class="line" :span="2">-</el-col>
          <el-col :span="11">
            <el-time-picker
              v-model="configForm.workingHoursEnd"
              format="HH:mm"
              value-format="HH:mm:ss"
              placeholder="结束时间">
            </el-time-picker>
          </el-col>
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" @click="saveConfig" :loading="loading">保存配置</el-button>
          <el-button @click="resetForm">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import { getCustomerServiceConfig, saveCustomerServiceConfig } from '@/api/customerService'

export default {
  name: 'CustomerServiceConfig',
  data() {
    return {
      loading: false,
      configForm: {
        title: '在线客服',
        serviceName: '客服小助手',
        welcomeMessage: '',
        offlineMessage: '',
        status: true,
        isEnabled: true,
        autoReply: false,
        autoReplyMessage: '',
        workingHoursStart: '09:00:00',
        workingHoursEnd: '18:00:00'
      },
      rules: {
        title: [
          { required: true, message: '请输入客服标题', trigger: 'blur' }
        ],
        serviceName: [
          { required: true, message: '请输入客服名称', trigger: 'blur' }
        ],
        welcomeMessage: [
          { required: true, message: '请输入欢迎语', trigger: 'blur' }
        ],
        offlineMessage: [
          { required: true, message: '请输入离线提示语', trigger: 'blur' }
        ]
      }
    }
  },
  created() {
    this.getConfig()
  },
  methods: {
    async getConfig() {
      try {
        const response = await getCustomerServiceConfig()
        if (response.code === 200 && response.data) {
          // 确保数据类型正确
          const data = response.data
          this.configForm = {
            ...this.configForm,
            ...data,
            status: Boolean(data.status), // 确保status是布尔类型
            autoReply: Boolean(data.autoReply),
            isEnabled: Boolean(data.isEnabled)
          }
        }
      } catch (error) {
        console.error('获取客服配置失败:', error)
        this.$message.error('获取客服配置失败')
      }
    },
    
    async saveConfig() {
      this.$refs.configForm.validate(async (valid) => {
        if (valid) {
          this.loading = true
          try {
            console.log('发送的配置数据:', this.configForm)
            console.log('status值:', this.configForm.status, '类型:', typeof this.configForm.status)
            console.log('isEnabled值:', this.configForm.isEnabled, '类型:', typeof this.configForm.isEnabled)
            console.log('autoReply值:', this.configForm.autoReply, '类型:', typeof this.configForm.autoReply)
            const response = await saveCustomerServiceConfig(this.configForm)
            console.log('保存配置响应:', response)
            console.log('响应code类型:', typeof response.code, '值:', response.code)
            console.log('响应message:', response.message)
            console.log('响应data:', response.data)
            
            // 兼容不同的code类型（数字或字符串）
            const code = parseInt(response.code) || response.code
            if (response && (code === 200 || response.code === '200')) {
              this.$message.success('保存成功')
              // 重新获取配置
              await this.getConfig()
            } else {
              console.log('保存失败，响应详情:', response)
              this.$message.error((response && response.message) || '保存失败')
            }
          } catch (error) {
            console.error('保存客服配置失败:', error)
            this.$message.error('保存失败')
          } finally {
            this.loading = false
          }
        }
      })
    },
    
    resetForm() {
      this.$refs.configForm.resetFields()
      this.getConfig()
    }
  }
}
</script>

<style scoped>
.line {
  text-align: center;
}
</style>