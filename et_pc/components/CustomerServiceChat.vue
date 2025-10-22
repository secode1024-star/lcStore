<template>
  <div class="customer-service-chat" v-if="visible">
    <div class="chat-container">
      <!-- 聊天头部 -->
      <div class="chat-header">
        <div class="header-left">
          <div class="service-avatar">
            <img :src="defaultAvatar" alt="客服">
          </div>
          <div class="service-info">
            <div class="service-name">{{ $t('customerService.title') || '在线客服' }}</div>
            <div class="service-status" :class="{ 'online': isOnline }">
              {{ isOnline ? '在线' : '离线' }}
            </div>
          </div>
        </div>
        <div class="header-right">
          <button @click="minimizeChat" class="minimize-btn" :title="$t('customerService.minimize') || '最小化'">
            <i class="el-icon-minus"></i>
          </button>
          <button @click="closeChat" class="close-btn" :title="$t('customerService.close') || '关闭'">
            <i class="el-icon-close"></i>
          </button>
        </div>
      </div>

      <!-- 聊天消息区域 -->
      <div class="chat-messages" ref="messagesContainer">
        <!-- 连接状态 -->
        <div v-if="connecting" class="connection-status">
          {{ $t('customerService.connecting') || '正在连接客服...' }}
        </div>
        
        <!-- 离线提示 -->
        <!-- 离线提示 -->
        <div v-if="!isOnline && !connecting" class="connection-status">
          {{ offlineMessage || $t('customerService.offline') || '客服不在线，请稍后再试' }}
        </div>

        <!-- 欢迎消息 -->
        <div v-if="welcomeMessage && isOnline" class="message service-message">
          <div class="message-avatar">
            <img :src="defaultAvatar" alt="客服">
          </div>
          <div class="message-content">
            <div class="message-bubble">{{ welcomeMessage }}</div>
            <div class="message-time">{{ formatTime(new Date()) }}</div>
          </div>
        </div>

        <!-- 聊天消息 -->
        <div v-for="message in messages" :key="message.id" 
             :class="['message', message.senderType === 'user' ? 'user-message' : 'service-message']">
          <div class="message-avatar">
            <img :src="message.senderType === 'user' ? userAvatar : defaultAvatar" alt="">
          </div>
          <div class="message-content">
            <div class="message-bubble">{{ message.content }}</div>
            <div class="message-time">{{ formatTime(message.createTime) }}</div>
          </div>
        </div>

        <!-- 正在输入提示 -->
        <div v-if="isTyping" class="message service-message">
          <div class="message-avatar">
            <img :src="defaultAvatar" alt="客服">
          </div>
          <div class="message-content">
            <div class="message-bubble typing">
              <span class="typing-dot"></span>
              <span class="typing-dot"></span>
              <span class="typing-dot"></span>
            </div>
          </div>
        </div>
      </div>

      <!-- 输入区域 -->
      <div class="chat-input" v-if="isOnline">
        <div class="input-container">
          <el-input
            v-model="inputMessage"
            type="textarea"
            :rows="2"
            :placeholder="$t('customerService.inputPlaceholder') || '请输入您的问题...'"
            @keyup.enter.native="handleEnterKey"
            :disabled="sending"
            resize="none"
            class="message-input"
          ></el-input>
          <el-button 
            type="primary" 
            @click="sendMessage"
            :loading="sending"
            class="send-button"
            :disabled="!inputMessage.trim()"
          >
            <i class="el-icon-s-promotion"></i>
            {{ $t('customerService.send') || '发送' }}
          </el-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'CustomerServiceChat',
  data() {
    return {
      visible: false,
      isOnline: false,
      connecting: false,
      sessionId: null,
      messages: [],
      inputMessage: '',
      sending: false,
      welcomeMessage: '',
      offlineMessage: '',
      isTyping: false,
      defaultAvatar: require('@/assets/images/morentou.png'), // 默认头像
      userAvatar: require('@/assets/images/morentou.png'), // 用户头像
      messagePollingTimer: null, // 消息轮询定时器
      currentUserId: null // 当前用户ID，用于检测用户切换
    };
  },

  mounted() {
    // 组件挂载时就获取客服配置
    this.initChat();
    // 记录当前用户ID
    this.currentUserId = this.$auth.loggedIn ? this.$auth.user.id : null;
  },

  beforeDestroy() {
    // 组件销毁前清理定时器
    this.stopMessagePolling();
  },

  watch: {
    // 监听用户登录状态变化
    '$auth.loggedIn'(newVal, oldVal) {
      if (newVal !== oldVal) {
        this.handleUserChange();
      }
    },
    // 监听用户信息变化
    '$auth.user'(newUser, oldUser) {
      const newUserId = newUser ? newUser.id : null;
      const oldUserId = oldUser ? oldUser.id : null;
      
      if (newUserId !== oldUserId) {
        this.handleUserChange();
      }
    }
  },

  methods: {
    // 处理用户变化
    handleUserChange() {
      const newUserId = this.$auth.loggedIn ? this.$auth.user.id : null;
      
      // 如果用户ID发生变化，重置聊天状态
      if (newUserId !== this.currentUserId) {
        console.log('用户切换检测到，从', this.currentUserId, '切换到', newUserId);
        
        // 停止消息轮询
        this.stopMessagePolling();
        
        // 重置聊天状态
        this.sessionId = null;
        this.messages = [];
        this.inputMessage = '';
        this.currentUserId = newUserId;
        
        // 如果用户已登录且聊天窗口可见，重新初始化
        if (this.$auth.loggedIn && this.visible) {
          this.initChat();
        }
      }
    },

    // 显示聊天窗口
    showChat() {
      // 检查用户是否切换
      const currentUserId = this.$auth.loggedIn ? this.$auth.user.id : null;
      if (currentUserId !== this.currentUserId) {
        this.handleUserChange();
      }
      
      this.visible = true;
      if (!this.sessionId) {
        this.initChat();
      }
      // 启动消息轮询
      this.startMessagePolling();
    },

    // 关闭聊天窗口
    closeChat() {
      this.visible = false;
      // 停止消息轮询
      this.stopMessagePolling();
    },

    // 最小化聊天窗口
    minimizeChat() {
      this.visible = false;
      // 停止消息轮询
      this.stopMessagePolling();
    },

    // 初始化聊天
    async initChat() {
      try {
        this.connecting = true;
        
        // 检查用户登录状态
        if (!this.$auth.loggedIn) {
          this.isOnline = false;
          this.offlineMessage = '请先登录后使用客服功能';
          this.connecting = false;
          return;
        }
        
        // 更新当前用户ID
        this.currentUserId = this.$auth.user.id;
        
        // 获取客服配置
        try {
          const configRes = await this.$axios.get('/api/front/customer-service/config');
          
          // 检查响应格式：可能是直接的数据，也可能是包装的 {code, message, data} 格式
          let config = null;
          if (configRes.data && typeof configRes.data === 'object') {
            if (configRes.data.code === 200 && configRes.data.data) {
              // 格式：{code: 200, message: "操作成功", data: {...}}
              config = configRes.data.data;
            } else if (configRes.data.id && configRes.data.title) {
              // 格式：直接的业务数据 {id: 1, title: "在线客服", ...}
              config = configRes.data;
            }
          }
          
          if (config) {
            this.welcomeMessage = config.welcomeMessage || '您好！欢迎咨询，有什么可以帮助您的吗？';
            this.offlineMessage = config.offlineMessage || '客服暂时离线，请稍后再试';
            // 客服在线状态 = 启用客服功能 && 客服状态为在线
            // 兼容布尔值和数字值：true/1 表示在线，false/0 表示离线
            const isEnabledValue = config.isEnabled === true || config.isEnabled === 1;
            const isOnlineValue = config.status === true || config.status === 1;
            this.isOnline = isEnabledValue && isOnlineValue;
          } else {
            // API调用失败时的默认配置
            this.isOnline = false;
            this.offlineMessage = '客服系统暂时不可用，请稍后再试';
          }
        } catch (configError) {
          this.isOnline = false;
          this.offlineMessage = '客服系统暂时不可用，请稍后再试';
        }

        if (this.isOnline) {
          // 创建会话
          await this.createSession();
          // 加载历史消息
          await this.loadMessages();
          // 滚动到底部
          this.scrollToBottom();
          // 如果聊天窗口可见，启动消息轮询
          if (this.visible) {
            this.startMessagePolling();
          }
        }
      } catch (error) {
        this.$message.error(this.$t('customerService.networkError'));
      } finally {
        this.connecting = false;
      }
    },

    // 创建会话
    async createSession() {
      try {
        const res = await this.$axios.post('/api/front/customer-service/session/create');
        
        // 检查响应格式：可能是直接的数据，也可能是包装的 {code, message, data} 格式
        if (res) { // res不再是res.data，因为axios拦截器直接返回了data
          if (res.data && res.data.sessionId) { // 如果是包装格式，data字段里还有sessionId
            this.sessionId = res.data.sessionId;
          } else if (res.sessionId) { // 如果是直接数据格式，res本身就是sessionId
            this.sessionId = res.sessionId;
          }
        }
      } catch (error) {
        // 错误会被axios拦截器处理，这里不需要额外处理
      }
    },

    // 加载消息
    async loadMessages() {
      if (!this.sessionId) return;
      
      try {
        const res = await this.$axios.get(`/api/front/customer-service/messages/${this.sessionId}`);
        
        // PC前端的axios拦截器直接返回response.data，所以res就是后端的CommonResult
        if (res && res.data) {
          const newMessages = res.data.map(msg => ({
            id: msg.id,
            content: msg.content,
            senderType: msg.senderType === 1 ? 'user' : 'service',
            createTime: msg.createTime,
            sendTime: msg.createTime  // 保持兼容性
          }));
          
          // 检查是否有新消息
          const hasNewMessages = newMessages.length > this.messages.length;
          
          this.messages = newMessages;
          
          // 只有新消息时才滚动到底部
          if (hasNewMessages) {
            this.scrollToBottom();
          }
        }
      } catch (error) {
        console.error('加载消息失败:', error);
      }
    },

    // 发送消息
    async sendMessage() {
      if (!this.inputMessage.trim() || this.sending || !this.sessionId) return;

      const messageContent = this.inputMessage.trim();
      this.inputMessage = '';
      this.sending = true;

      try {
        await this.$axios.post('/api/front/customer-service/message/send', {
          sessionId: this.sessionId,
          messageType: 1,
          content: messageContent
        });
        
        // 消息发送成功，添加到消息列表
        this.messages.push({
          id: Date.now(),
          content: messageContent,
          senderType: 'user',
          createTime: new Date(),
          sendTime: new Date()  // 保持兼容性
        });
        this.scrollToBottom();
        
        // 重新加载消息以获取最新状态
        setTimeout(() => this.loadMessages(), 500);
      } catch (error) {
        this.$message.error(this.$t('customerService.sendFailed') || '发送失败，请重试');
        // 恢复输入内容
        this.inputMessage = messageContent;
      } finally {
        this.sending = false;
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
      this.$nextTick(() => {
        const container = this.$refs.messagesContainer;
        if (container) {
          container.scrollTop = container.scrollHeight;
        }
      });
    },

    // 格式化时间
    formatTime(time) {
      console.log('formatTime 输入:', time, '类型:', typeof time);
      if (!time) {
        console.log('时间为空，返回空字符串');
        return '';
      }
      
      let date;
      if (typeof time === 'string') {
        // 处理数据库时间格式 YYYY-MM-DD HH:mm:ss
        // 服务器返回的时间已经是北京时间，需要明确指定为本地时间
        // 使用 YYYY/MM/DD HH:mm:ss 格式，JavaScript会将其解析为本地时间
        const timeStr = time.replace(/-/g, '/');
        date = new Date(timeStr);
        console.log('字符串时间解析:', timeStr, '->', date);
        console.log('解析后的本地时间:', date.toLocaleString());
        console.log('解析后的UTC时间:', date.toUTCString());
      } else {
        date = new Date(time);
        console.log('直接时间解析:', time, '->', date);
      }
      
      // 检查日期是否有效
      if (isNaN(date.getTime())) {
        console.log('日期无效:', date);
        return '';
      }
      
      const now = new Date();
      let diff = now - date; // 时间差（毫秒）
      
      console.log('当前时间:', now);
      console.log('消息时间:', date);
      console.log('时间差(毫秒):', diff);
      console.log('时间差(小时):', diff / (1000 * 60 * 60));
      
      // 如果时间差为负数，使用绝对值
      if (diff < 0) {
        console.log('时间差为负数，使用绝对值');
        diff = Math.abs(diff);
      }
      
      // 1分钟内
      if (diff < 60000) {
        return '刚刚';
      }
      // 30分钟内，精确显示分钟
      else if (diff < 1800000) { // 30分钟
        const minutes = Math.floor(diff / 60000);
        return minutes + '分钟前';
      }
      // 1小时内，显示分钟
      else if (diff < 3600000) { // 1小时
        const minutes = Math.floor(diff / 60000);
        return minutes + '分钟前';
      }
      // 24小时内，显示小时
      else if (diff < 86400000) { // 24小时
        const hours = Math.floor(diff / 3600000);
        return hours + '小时前';
      }
      // 超过24小时，统一显示"24小时前"
      else {
        return '24小时前';
      }
    },

    // 启动消息轮询
    startMessagePolling() {
      // 如果已经有定时器在运行，先清除
      this.stopMessagePolling();
      
      // 只有在聊天窗口可见且有sessionId时才启动轮询
      if (this.visible && this.sessionId && this.isOnline) {
        this.messagePollingTimer = setInterval(() => {
          this.loadMessages();
        }, 3000); // 每3秒轮询一次
      }
    },

    // 停止消息轮询
    stopMessagePolling() {
      if (this.messagePollingTimer) {
        clearInterval(this.messagePollingTimer);
        this.messagePollingTimer = null;
      }
    }
  }
}
</script>

<style scoped lang="scss">
.customer-service-chat {
  position: fixed;
  bottom: 20px;
  right: 20px;
  width: 350px;
  height: 500px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  z-index: 99999;
  display: flex;
  flex-direction: column;
  pointer-events: auto;

  .chat-container {
    display: flex;
    flex-direction: column;
    height: 100%;
  }

  .chat-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 16px;
    background: #409eff;
    color: white;
    border-radius: 8px 8px 0 0;

    .header-left {
      display: flex;
      align-items: center;

      .service-avatar {
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

      .service-info {
        .service-name {
          font-weight: 500;
          font-size: 16px;
        }

        .service-status {
          font-size: 12px;
          opacity: 0.8;

          &.online {
            color: #67c23a;
          }
        }
      }
    }

    .header-right {
      display: flex;
      gap: 8px;

      button {
        background: none;
        border: none;
        color: white;
        cursor: pointer;
        padding: 4px;
        border-radius: 4px;
        transition: background-color 0.2s;

        &:hover {
          background: rgba(255, 255, 255, 0.1);
        }

        i {
          font-size: 16px;
        }
      }
    }
  }

  .chat-messages {
    flex: 1;
    padding: 16px;
    overflow-y: auto;
    background: #f8f9fa;

    .message {
      display: flex;
      margin-bottom: 16px;

      .message-avatar {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        overflow: hidden;
        flex-shrink: 0;

        img {
          width: 100%;
          height: 100%;
          object-fit: cover;
        }
      }

      .message-content {
        margin-left: 8px;
        max-width: calc(100% - 40px);

        .message-bubble {
          background: white;
          padding: 8px 12px;
          border-radius: 12px;
          word-wrap: break-word;
          box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);

          &.typing {
            display: flex;
            align-items: center;
            gap: 4px;
            padding: 12px;

            .typing-dot {
              width: 6px;
              height: 6px;
              background: #ccc;
              border-radius: 50%;
              animation: typing 1.4s infinite;

              &:nth-child(2) {
                animation-delay: 0.2s;
              }

              &:nth-child(3) {
                animation-delay: 0.4s;
              }
            }
          }
        }

        .message-time {
          font-size: 11px;
          color: #999;
          margin-top: 4px;
        }
      }

      &.user-message {
        flex-direction: row-reverse;

        .message-content {
          margin-left: 0;
          margin-right: 8px;
          text-align: right;

          .message-bubble {
            background: #409eff;
            color: white;
          }
        }
      }
    }
  }

  .chat-input {
    padding: 16px;
    border-top: 1px solid #ebeef5;
    background: #fafbfc;
    border-radius: 0 0 8px 8px;

    .input-container {
      display: flex;
      gap: 12px;
      align-items: flex-end;

      .message-input {
        flex: 1;
        
        .el-textarea__inner {
          border-radius: 8px;
          border: 1px solid #dcdfe6;
          transition: border-color 0.2s;
          
          &:focus {
            border-color: #409eff;
            box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.1);
          }
        }
      }

      .el-textarea {
        flex: 1;
      }

      .send-button {
        flex-shrink: 0;
        height: 40px;
        border-radius: 8px;
        padding: 0 20px;
        font-weight: 500;
        transition: all 0.2s;
        
        &:not(:disabled):hover {
          transform: translateY(-1px);
          box-shadow: 0 4px 12px rgba(64, 158, 255, 0.3);
        }
        
        &:disabled {
          opacity: 0.5;
          cursor: not-allowed;
        }

        i {
          margin-right: 4px;
        }
      }
    }
  }

  .connection-status {
    padding: 8px 16px;
    background: #fff3cd;
    color: #856404;
    border-top: 1px solid #ffeaa7;
    text-align: center;
    font-size: 12px;
  }
}

@keyframes typing {
  0%, 60%, 100% {
    transform: translateY(0);
  }
  30% {
    transform: translateY(-10px);
  }
}

// 滚动条样式
.chat-messages::-webkit-scrollbar {
  width: 4px;
}

.chat-messages::-webkit-scrollbar-track {
  background: #f1f1f1;
}

.chat-messages::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 2px;
}

.chat-messages::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}
</style>

