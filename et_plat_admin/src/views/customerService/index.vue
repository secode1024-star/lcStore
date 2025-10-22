<template>
  <div class="customer-service-container">
    <div class="service-layout">
      <!-- 左侧会话列表 -->
      <div class="session-list">
        <div class="session-header">
          <h3>客服会话</h3>
          <el-button type="primary" size="small" @click="refreshSessions">
            <i class="el-icon-refresh"></i>
            刷新
          </el-button>
        </div>
        
        <div class="session-items">
          <div 
            v-for="session in sessionList" 
            :key="session.id"
            :class="['session-item', { 'active': activeSessionId === session.sessionId }]"
            @click="selectSession(session)"
          >
            <div class="session-avatar">
              <img :src="session.userAvatar || defaultAvatar" :alt="session.userName">
            </div>
            <div class="session-info">
              <div class="session-name">{{ session.userName }}</div>
              <div class="session-last-message">{{ session.lastMessage || '暂无消息' }}</div>
              <div class="session-time">{{ formatTime(session.lastMessageTime) }}</div>
            </div>
            <div class="session-badge" v-if="session.unreadCount > 0">
              {{ session.unreadCount }}
            </div>
          </div>
        </div>
        
        <div v-if="sessionList.length === 0" class="empty-sessions">
          <i class="el-icon-chat-dot-square"></i>
          <p>暂无客服会话</p>
        </div>
      </div>

      <!-- 右侧聊天区域 -->
      <div class="chat-area">
        <div v-if="!activeSession" class="no-session">
          <i class="el-icon-chat-dot-round"></i>
          <p>请选择一个会话开始聊天</p>
        </div>
        
        <div v-else class="chat-container">
          <!-- 聊天头部 -->
          <div class="chat-header">
            <div class="user-info">
              <img :src="activeSession.userAvatar || defaultAvatar" :alt="activeSession.userName">
              <div class="user-details">
                <div class="user-name">{{ activeSession.userName }}</div>
                <div class="user-status">用户ID: {{ activeSession.userId }}</div>
              </div>
            </div>
            <div class="chat-actions">
              <el-button size="small" @click="refreshMessages">
                <i class="el-icon-refresh"></i>
                刷新消息
              </el-button>
            </div>
          </div>

          <!-- 消息列表 -->
          <div class="message-list" ref="messageContainer">
            <div 
              v-for="message in messageList" 
              :key="message.id"
              :class="['message-item', message.senderType === 1 ? 'user-message' : 'service-message']"
            >
              <div class="message-avatar">
                <!-- 用户消息显示用户头像，客服消息显示客服图标 -->
                <img 
                  v-if="message.senderType === 1" 
                  :src="message.senderAvatar || defaultAvatar" 
                  :alt="message.senderName || '用户'"
                  class="user-avatar"
                >
                <i 
                  v-else 
                  class="el-icon-service customer-service-icon"
                  :title="message.senderName || '客服'"
                ></i>
              </div>
              <div class="message-content">
                <div class="message-info">
                  <span class="sender-name">{{ message.senderName }}</span>
                  <span class="message-time">{{ formatTime(message.createTime) }}</span>
                </div>
                <div class="message-text">{{ message.content }}</div>
              </div>
            </div>
            
            <div v-if="messageList.length === 0" class="empty-messages">
              <p>暂无聊天记录</p>
            </div>
          </div>

          <!-- 输入区域 -->
          <div class="message-input">
            <el-input
              v-model="inputMessage"
              type="textarea"
              :rows="3"
              placeholder="请输入回复内容..."
              @keyup.enter.native="handleEnterKey"
              :disabled="sending"
            ></el-input>
            <div class="input-actions">
              <el-button 
                type="primary" 
                @click="sendMessage"
                :loading="sending"
                :disabled="!inputMessage.trim()"
              >
                发送消息
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
  getCustomerServiceSessions, 
  getSessionMessages, 
  sendMessage as sendMessageApi, 
  markMessagesRead 
} from '@/api/customerService'

export default {
  name: 'CustomerServiceIndex',
  data() {
    return {
      sessionList: [],
      messageList: [],
      activeSession: null,
      activeSessionId: null,
      inputMessage: '',
      sending: false,
      loading: false,
      defaultAvatar: require('@/assets/imgs/default_avatar.png'),
      refreshTimer: null
    };
  },
  created() {
    this.loadSessions();
    // 设置定时刷新
    this.refreshTimer = setInterval(() => {
      this.loadSessions();
      if (this.activeSessionId) {
        this.loadMessages(this.activeSessionId);
      }
    }, 10000); // 每10秒刷新一次
  },
  beforeDestroy() {
    if (this.refreshTimer) {
      clearInterval(this.refreshTimer);
    }
  },
  methods: {
    // 加载会话列表
    async loadSessions() {
      try {
        const response = await getCustomerServiceSessions();
        if (response.code === 200 && response.data) {
          this.sessionList = response.data || [];
        }
      } catch (error) {
        console.error('加载会话列表失败:', error);
        this.$message.error('加载会话列表失败');
      }
    },

    // 选择会话
    async selectSession(session) {
      this.activeSession = session;
      this.activeSessionId = session.sessionId;
      await this.loadMessages(session.sessionId);
      // 暂时移除标记已读功能，避免错误
      // this.markMessagesAsRead(session.sessionId);
    },

    // 加载消息列表
    async loadMessages(sessionId) {
      try {
        const response = await getSessionMessages(sessionId);
        if (response.code === 200 && response.data) {
          this.messageList = response.data || [];
          this.$nextTick(() => {
            this.scrollToBottom();
          });
        }
      } catch (error) {
        console.error('加载消息列表失败:', error);
        this.$message.error('加载消息列表失败');
      }
    },

    // 发送消息
    async sendMessage() {
      if (!this.inputMessage.trim() || !this.activeSessionId || this.sending) {
        return;
      }

      const messageContent = this.inputMessage.trim();
      this.inputMessage = '';
      this.sending = true;

      try {
        const response = await sendMessageApi({
          sessionId: this.activeSessionId,
          messageType: 1,
          content: messageContent
        });

        if (response.code === 200) {
          // 重新加载消息
          await this.loadMessages(this.activeSessionId);
          // 刷新会话列表
          await this.loadSessions();
          this.$message.success('消息发送成功');
        } else {
          this.$message.error(response.message || '发送失败');
          this.inputMessage = messageContent; // 恢复输入内容
        }
      } catch (error) {
        console.error('发送消息失败:', error);
        this.$message.error('发送消息失败');
        this.inputMessage = messageContent; // 恢复输入内容
      } finally {
        this.sending = false;
      }
    },

    // 标记消息为已读（暂时禁用）
    async markMessagesAsRead(sessionId) {
      // 暂时禁用此功能，避免错误
      console.log('标记已读功能已暂时禁用');
      return;
      
      // try {
      //   await markMessagesRead(sessionId);
      // } catch (error) {
      //   console.error('标记消息已读失败:', error);
      // }
    },

    // 刷新会话列表
    async refreshSessions() {
      await this.loadSessions();
      this.$message.success('会话列表已刷新');
    },

    // 刷新消息列表
    async refreshMessages() {
      if (this.activeSessionId) {
        await this.loadMessages(this.activeSessionId);
        this.$message.success('消息列表已刷新');
      }
    },

    // 处理回车键
    handleEnterKey(event) {
      if (!event.shiftKey) {
        event.preventDefault();
        this.sendMessage();
      }
    },

    // 滚动到底部
    scrollToBottom() {
      const container = this.$refs.messageContainer;
      if (container) {
        container.scrollTop = container.scrollHeight;
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
      } else if (date.toDateString() === now.toDateString()) { // 今天
        return date.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' });
      } else {
        return date.toLocaleDateString('zh-CN') + ' ' + date.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' });
      }
    }
  }
};
</script>

<style scoped lang="scss">
.customer-service-container {
  height: calc(100vh - 120px);
  background: #f5f5f5;
}

.service-layout {
  display: flex;
  height: 100%;
  background: white;
  border-radius: 4px;
  overflow: hidden;
}

.session-list {
  width: 300px;
  border-right: 1px solid #e4e7ed;
  display: flex;
  flex-direction: column;

  .session-header {
    padding: 16px;
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

  .session-items {
    flex: 1;
    overflow-y: auto;
  }

  .session-item {
    display: flex;
    align-items: center;
    padding: 12px 16px;
    cursor: pointer;
    border-bottom: 1px solid #f0f0f0;
    transition: background-color 0.2s;
    position: relative;

    &:hover {
      background: #f5f7fa;
    }

    &.active {
      background: #ecf5ff;
      border-right: 3px solid #409eff;
    }

    .session-avatar {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      overflow: hidden;
      margin-right: 12px;

      img {
        width: 100%;
        height: 100%;
        object-fit: cover;
      }
    }

    .session-info {
      flex: 1;
      min-width: 0;

      .session-name {
        font-weight: 500;
        color: #303133;
        margin-bottom: 4px;
      }

      .session-last-message {
        font-size: 12px;
        color: #909399;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        margin-bottom: 2px;
      }

      .session-time {
        font-size: 11px;
        color: #c0c4cc;
      }
    }

    .session-badge {
      background: #f56c6c;
      color: white;
      border-radius: 10px;
      padding: 2px 6px;
      font-size: 11px;
      min-width: 16px;
      text-align: center;
    }
  }

  .empty-sessions {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    color: #909399;

    i {
      font-size: 48px;
      margin-bottom: 16px;
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
    align-items: center;
    justify-content: center;
    color: #909399;

    i {
      font-size: 64px;
      margin-bottom: 16px;
    }

    p {
      font-size: 16px;
    }
  }

  .chat-container {
    flex: 1;
    display: flex;
    flex-direction: column;
  }

  .chat-header {
    padding: 16px;
    border-bottom: 1px solid #e4e7ed;
    display: flex;
    justify-content: space-between;
    align-items: center;

    .user-info {
      display: flex;
      align-items: center;

      img {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        margin-right: 12px;
      }

      .user-details {
        .user-name {
          font-weight: 500;
          color: #303133;
          margin-bottom: 4px;
        }

        .user-status {
          font-size: 12px;
          color: #909399;
        }
      }
    }
  }

  .message-list {
    flex: 1;
    padding: 16px;
    overflow-y: auto;
    background: #f8f9fa;
    max-height: calc(100vh - 300px); /* 限制最大高度，确保滚动生效 */
    min-height: 400px; /* 设置最小高度 */

    .message-item {
      display: flex;
      margin-bottom: 16px;

      .message-avatar {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        overflow: hidden;
        margin-right: 8px;
        display: flex;
        align-items: center;
        justify-content: center;

        img {
          width: 100%;
          height: 100%;
          object-fit: cover;
        }

        .customer-service-icon {
          font-size: 18px;
          color: #409eff;
          background: #f0f9ff;
          width: 32px;
          height: 32px;
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          border: 2px solid #409eff;
        }
      }

      .message-content {
        flex: 1;
        max-width: calc(100% - 40px);

        .message-info {
          display: flex;
          align-items: center;
          margin-bottom: 4px;

          .sender-name {
            font-size: 12px;
            color: #606266;
            margin-right: 8px;
          }

          .message-time {
            font-size: 11px;
            color: #c0c4cc;
          }
        }

        .message-text {
          background: white;
          padding: 8px 12px;
          border-radius: 8px;
          word-wrap: break-word;
          box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
        }
      }

      &.service-message {
        .message-content .message-text {
          background: #409eff;
          color: white;
        }
      }

      &.user-message {
        flex-direction: row-reverse;

        .message-avatar {
          margin-right: 0;
          margin-left: 8px;
        }

        .message-content {
          text-align: right;

          .message-info {
            justify-content: flex-end;
          }
        }
      }
    }

    .empty-messages {
      text-align: center;
      color: #909399;
      padding: 40px;
    }
  }

  .message-input {
    padding: 16px;
    border-top: 1px solid #e4e7ed;
    background: white;

    .input-actions {
      margin-top: 8px;
      text-align: right;
    }
  }
}

// 滚动条样式
.session-items::-webkit-scrollbar,
.message-list::-webkit-scrollbar {
  width: 4px;
}

.session-items::-webkit-scrollbar-track,
.message-list::-webkit-scrollbar-track {
  background: #f1f1f1;
}

.session-items::-webkit-scrollbar-thumb,
.message-list::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 2px;
}

.session-items::-webkit-scrollbar-thumb:hover,
.message-list::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}
</style>