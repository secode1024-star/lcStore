<template>
  <div class="app-container">
    <div class="chat-container">
      <!-- 左侧会话列表 -->
      <div class="session-list">
        <div class="session-header">
          <h3>客服会话</h3>
          <el-button 
            type="primary" 
            size="small" 
            @click="refreshSessions"
            :loading="sessionLoading"
          >
            刷新
          </el-button>
        </div>
        
        <div class="session-content" v-loading="sessionLoading">
          <div 
            v-for="session in sessionList" 
            :key="session.id"
            :class="['session-item', { active: currentSessionId === session.id }]"
            @click="selectSession(session)"
          >
            <div class="session-info">
              <div class="user-name">用户 {{ session.userId }}</div>
              <div class="last-message">{{ session.lastMessage || '暂无消息' }}</div>
            </div>
            <div class="session-time">
              {{ formatTime(session.lastMessageTime) }}
            </div>
          </div>
          
          <div v-if="sessionList.length === 0" class="empty-sessions">
            <i class="el-icon-chat-dot-round"></i>
            <p>暂无会话</p>
          </div>
        </div>
      </div>

      <!-- 右侧聊天区域 -->
      <div class="chat-area">
        <div v-if="!currentSessionId" class="no-session">
          <i class="el-icon-chat-dot-round"></i>
          <p>请选择一个会话开始聊天</p>
        </div>
        
        <div v-else class="chat-content">
          <!-- 聊天头部 -->
          <div class="chat-header">
            <h4>与用户 {{ currentSession && currentSession.userId }} 的对话</h4>
            <div class="chat-actions">
              <el-button size="small" @click="refreshMessages">刷新消息</el-button>
            </div>
          </div>

          <!-- 消息列表 -->
          <div class="message-list" ref="messageList" v-loading="messageLoading">
            <div 
              v-for="message in messageList" 
              :key="message.id"
              :class="['message-item', message.senderType === 'service' ? 'service' : 'user']"
            >
              <div class="message-content">
                <div class="message-text">{{ message.content }}</div>
                <div class="message-time">{{ formatTime(message.createTime) }}</div>
              </div>
            </div>
            
            <div v-if="messageList.length === 0" class="empty-messages">
              <p>暂无消息</p>
            </div>
          </div>

          <!-- 发送消息 -->
          <div class="message-input">
            <el-input
              type="textarea"
              v-model="newMessage"
              placeholder="请输入消息内容..."
              :rows="3"
              maxlength="500"
              show-word-limit
              @keydown.ctrl.enter="sendMessage"
            />
            <div class="input-actions">
              <span class="tip">Ctrl + Enter 发送</span>
              <el-button 
                type="primary" 
                @click="sendMessage"
                :loading="sendLoading"
                :disabled="!newMessage.trim()"
              >
                发送
              </el-button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { 
  customerServiceSessionListApi, 
  customerServiceMessageListApi,
  customerServiceSendMessageApi 
} from '@/api/customerService';

export default {
  name: 'CustomerServiceChat',
  data() {
    return {
      sessionLoading: false,
      messageLoading: false,
      sendLoading: false,
      sessionList: [],
      messageList: [],
      currentSessionId: null,
      currentSession: null,
      newMessage: '',
      refreshTimer: null
    };
  },
  mounted() {
    this.getSessions();
    // 定时刷新会话列表
    this.refreshTimer = setInterval(() => {
      this.getSessions();
      if (this.currentSessionId) {
        this.getMessages(this.currentSessionId);
      }
    }, 10000); // 每10秒刷新一次
  },
  beforeDestroy() {
    if (this.refreshTimer) {
      clearInterval(this.refreshTimer);
    }
  },
  methods: {
    // 获取会话列表
    async getSessions() {
      this.sessionLoading = true;
      try {
        const response = await customerServiceSessionListApi();
        this.sessionList = response.data || [];
      } catch (error) {
        console.error('获取会话列表失败:', error);
        this.$message.error('加载会话列表失败');
      } finally {
        this.sessionLoading = false;
      }
    },

    // 刷新会话列表
    refreshSessions() {
      this.getSessions();
    },

    // 选择会话
    selectSession(session) {
      this.currentSessionId = session.id;
      this.currentSession = session;
      this.getMessages(session.id);
    },

    // 获取消息列表
    async getMessages(sessionId) {
      this.messageLoading = true;
      try {
        const response = await customerServiceMessageListApi(sessionId);
        this.messageList = response.data || [];
        this.$nextTick(() => {
          this.scrollToBottom();
        });
      } catch (error) {
        console.error('获取消息列表失败:', error);
        this.$message.error('加载消息失败');
      } finally {
        this.messageLoading = false;
      }
    },

    // 刷新消息
    refreshMessages() {
      if (this.currentSessionId) {
        this.getMessages(this.currentSessionId);
      }
    },

    // 发送消息
    async sendMessage() {
      if (!this.newMessage.trim() || !this.currentSessionId) return;

      this.sendLoading = true;
      try {
        await customerServiceSendMessageApi({
          sessionId: this.currentSessionId,
          content: this.newMessage.trim(),
          messageType: 'text'
        });
        
        this.newMessage = '';
        this.getMessages(this.currentSessionId);
        this.$message.success('消息发送成功');
      } catch (error) {
        console.error('发送消息失败:', error);
        this.$message.error('发送消息失败');
      } finally {
        this.sendLoading = false;
      }
    },

    // 滚动到底部
    scrollToBottom() {
      const messageList = this.$refs.messageList;
      if (messageList) {
        messageList.scrollTop = messageList.scrollHeight;
      }
    },

    // 格式化时间
    formatTime(time) {
      if (!time) return '';
      const date = new Date(time);
      const now = new Date();
      const diff = now - date;
      
      if (diff < 60000) { // 1分钟内
        return '刚刚';
      } else if (diff < 3600000) { // 1小时内
        return Math.floor(diff / 60000) + '分钟前';
      } else if (diff < 86400000) { // 24小时内
        return Math.floor(diff / 3600000) + '小时前';
      } else {
        return date.toLocaleDateString() + ' ' + date.toLocaleTimeString().slice(0, 5);
      }
    }
  }
};
</script>

<style lang="scss" scoped>
.app-container {
  padding: 20px;
  height: calc(100vh - 120px);
}

.chat-container {
  display: flex;
  height: 100%;
  background: #fff;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.session-list {
  width: 300px;
  border-right: 1px solid #e4e7ed;
  display: flex;
  flex-direction: column;

  .session-header {
    padding: 20px;
    border-bottom: 1px solid #e4e7ed;
    display: flex;
    justify-content: space-between;
    align-items: center;

    h3 {
      margin: 0;
      font-size: 16px;
      color: #303133;
    }
  }

  .session-content {
    flex: 1;
    overflow-y: auto;
  }

  .session-item {
    padding: 15px 20px;
    border-bottom: 1px solid #f5f7fa;
    cursor: pointer;
    transition: background-color 0.3s;
    display: flex;
    justify-content: space-between;
    align-items: center;

    &:hover {
      background-color: #f5f7fa;
    }

    &.active {
      background-color: #ecf5ff;
      border-right: 3px solid #409eff;
    }

    .session-info {
      flex: 1;
      min-width: 0;

      .user-name {
        font-weight: 500;
        color: #303133;
        margin-bottom: 5px;
      }

      .last-message {
        font-size: 12px;
        color: #909399;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }
    }

    .session-time {
      font-size: 12px;
      color: #c0c4cc;
      margin-left: 10px;
    }
  }

  .empty-sessions {
    text-align: center;
    padding: 50px 20px;
    color: #909399;

    i {
      font-size: 48px;
      margin-bottom: 20px;
      display: block;
    }
  }
}

.chat-area {
  flex: 1;
  display: flex;
  flex-direction: column;

  .no-session {
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    color: #909399;

    i {
      font-size: 64px;
      margin-bottom: 20px;
    }

    p {
      font-size: 16px;
    }
  }

  .chat-content {
    flex: 1;
    display: flex;
    flex-direction: column;
  }

  .chat-header {
    padding: 20px;
    border-bottom: 1px solid #e4e7ed;
    display: flex;
    justify-content: space-between;
    align-items: center;

    h4 {
      margin: 0;
      color: #303133;
    }
  }

  .message-list {
    flex: 1;
    padding: 20px;
    overflow-y: auto;

    .message-item {
      margin-bottom: 20px;
      display: flex;

      &.user {
        justify-content: flex-start;

        .message-content {
          background: #f5f7fa;
          color: #303133;
        }
      }

      &.service {
        justify-content: flex-end;

        .message-content {
          background: #409eff;
          color: #fff;
        }
      }

      .message-content {
        max-width: 70%;
        padding: 12px 16px;
        border-radius: 8px;
        word-wrap: break-word;

        .message-text {
          margin-bottom: 5px;
          line-height: 1.4;
        }

        .message-time {
          font-size: 12px;
          opacity: 0.7;
        }
      }
    }

    .empty-messages {
      text-align: center;
      padding: 50px 20px;
      color: #909399;
    }
  }

  .message-input {
    padding: 20px;
    border-top: 1px solid #e4e7ed;

    .input-actions {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-top: 10px;

      .tip {
        font-size: 12px;
        color: #909399;
      }
    }
  }
}
</style>
