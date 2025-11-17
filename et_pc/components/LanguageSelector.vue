
<template>
  <div v-if="show" class="language-selector-overlay" @click.self="handleClose">
    <div class="language-selector-modal">
      <div class="modal-header">
        <h2 class="modal-title">{{ $t('languageSelector.title') }}</h2>
        <p class="modal-subtitle">{{ $t('languageSelector.subtitle') }}</p>
      </div>
      
      <div class="modal-body">
        <div class="language-options">
          <div 
            v-for="(option, index) in languageOptions" 
            :key="option.code"
            class="language-option"
            :class="{ 'selected': selectedLanguage === option.code }"
            @click="selectLanguage(option.code)"
          >
            <div class="language-flag">
              <span class="flag-emoji">{{ option.flag }}</span>
            </div>
            <div class="language-info">
              <div class="language-name">{{ option.name }}</div>
              <div class="language-native">{{ option.nativeName }}</div>
            </div>
            <div class="selection-indicator" v-if="selectedLanguage === option.code">
              <i class="el-icon-check"></i>
            </div>
          </div>
        </div>
        
        <div class="remember-choice">
          <el-checkbox v-model="rememberChoice">
            {{ $t('languageSelector.remember') }}
          </el-checkbox>
        </div>
      </div>
      
      <div class="modal-footer">
        <el-button 
          type="default" 
          @click="handleSkip"
          class="skip-btn"
        >
          {{ $t('languageSelector.skip') }}
        </el-button>
        <el-button 
          type="primary" 
          @click="handleConfirm"
          :disabled="!selectedLanguage"
          class="confirm-btn"
        >
          {{ $t('languageSelector.confirm') }}
        </el-button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'LanguageSelector',
  props: {
    show: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      selectedLanguage: '',
      rememberChoice: true,
      languageOptions: [
        {
          code: 'zh-CN',
          name: '中文',
          nativeName: '简体中文',
          flag: '🇨🇳'
        },
        {
          code: 'en',
          name: 'English',
          nativeName: 'English',
          flag: '🇺🇸'
        },
        {
          code: 'fr',
          name: 'Français',
          nativeName: 'Français',
          flag: '🇫🇷'
        },
        {
          code: 'th',
          name: 'ไทย',
          nativeName: 'ภาษาไทย',
          flag: '🇹🇭'
        },
        {
          code: 'ru',
          name: 'Русский',
          nativeName: 'Русский язык',
          flag: '🇷🇺'
        },
        {
          code: 'ko',
          name: '한국어',
          nativeName: '한국어',
          flag: '🇰🇷'
        },
        {
          code: 'ar',
          name: 'العربية',
          nativeName: 'العربية',
          flag: '🇸🇦'
        },
        {
          code: 'ja',
          name: '日本語',
          nativeName: '日本語',
          flag: '🇯🇵'
        }
      ]
    }
  },
  mounted() {
    // 默认选择当前语言或中文
    this.selectedLanguage = this.$i18n.locale || 'zh-CN';
  },
  watch: {
    show(newVal) {
      // 显示模态框时阻止背景滚动
      if (newVal) {
        document.body.style.overflow = 'hidden';
        document.documentElement.style.overflow = 'hidden';
      } else {
        document.body.style.overflow = '';
        document.documentElement.style.overflow = '';
      }
    }
  },
  beforeDestroy() {
    // 组件销毁时恢复滚动
    document.body.style.overflow = '';
    document.documentElement.style.overflow = '';
  },
  methods: {
    selectLanguage(code) {
      this.selectedLanguage = code;
    },
    
    handleConfirm() {
      if (!this.selectedLanguage) return;
      
      // 恢复页面滚动
      document.body.style.overflow = '';
      document.documentElement.style.overflow = '';
      
      // 设置语言
      this.$i18n.locale = this.selectedLanguage;
      this.$cookies.set('locale', this.selectedLanguage);
      this.$store.commit('SET_LANG', this.selectedLanguage);
      
      // 如果选择记住选择，保存到本地存储
      if (this.rememberChoice) {
        localStorage.setItem('language_selected', 'true');
        localStorage.setItem('preferred_language', this.selectedLanguage);
      }
      
      // 显示成功消息
      this.$message.success(this.$t('languageSelector.success'));
      
      // 触发确认事件
      this.$emit('confirm', this.selectedLanguage);
      
      // 触发全局事件通知页面语言已切换
      this.$nuxt.$emit('language-changed', this.selectedLanguage);
    },
    
    handleSkip() {
      // 恢复页面滚动
      document.body.style.overflow = '';
      document.documentElement.style.overflow = '';
      
      // 使用默认语言（中文）
      const defaultLanguage = 'zh-CN';
      this.$i18n.locale = defaultLanguage;
      this.$cookies.set('locale', defaultLanguage);
      this.$store.commit('SET_LANG', defaultLanguage);
      
      // 标记已跳过选择
      localStorage.setItem('language_selected', 'true');
      localStorage.setItem('preferred_language', defaultLanguage);
      
      this.$emit('skip', defaultLanguage);
    },
    
    handleClose() {
      // 恢复页面滚动
      document.body.style.overflow = '';
      document.documentElement.style.overflow = '';
      
      this.$emit('close');
    }
  }
}
</script>

<style lang="scss" scoped>
.language-selector-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.7);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 99999; /* 提高优先级 */
  animation: fadeIn 0.3s ease-in-out;
  overflow: hidden; /* 阻止滚动 */
}

.language-selector-modal {
  background: white;
  border-radius: 12px;
  width: 90%;
  max-width: 500px;
  max-height: 80vh;
  overflow-y: auto;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
  animation: slideUp 0.3s ease-out;
}

.modal-header {
  padding: 24px 24px 16px;
  text-align: center;
  border-bottom: 1px solid #f0f0f0;
  
  .modal-title {
    font-size: 20px;
    font-weight: 600;
    color: #333;
    margin: 0 0 8px 0;
  }
  
  .modal-subtitle {
    font-size: 14px;
    color: #666;
    margin: 0;
  }
}

.modal-body {
  padding: 20px 24px;
}

.language-options {
  margin-bottom: 20px;
}

.language-option {
  display: flex;
  align-items: center;
  padding: 12px;
  border: 2px solid #f0f0f0;
  border-radius: 8px;
  margin-bottom: 8px;
  cursor: pointer;
  transition: all 0.2s ease;
  
  &:hover {
    border-color: #409EFF;
    background-color: #f8f9ff;
  }
  
  &.selected {
    border-color: #409EFF;
    background-color: #ecf5ff;
  }
  
  .language-flag {
    width: 32px;
    height: 24px;
    margin-right: 12px;
    border-radius: 4px;
    display: flex;
    align-items: center;
    justify-content: center;
    
    .flag-emoji {
      font-size: 20px;
      line-height: 1;
    }
  }
  
  .language-info {
    flex: 1;
    
    .language-name {
      font-size: 16px;
      font-weight: 500;
      color: #333;
      margin-bottom: 2px;
    }
    
    .language-native {
      font-size: 13px;
      color: #666;
    }
  }
  
  .selection-indicator {
    color: #409EFF;
    font-size: 18px;
    margin-left: 8px;
  }
}

.remember-choice {
  padding-top: 16px;
  border-top: 1px solid #f0f0f0;
  
  ::v-deep .el-checkbox__label {
    font-size: 14px;
    color: #666;
  }
}

.modal-footer {
  padding: 16px 24px 24px;
  display: flex;
  gap: 12px;
  justify-content: flex-end;
  border-top: 1px solid #f0f0f0;
  
  .skip-btn,
  .confirm-btn {
    padding: 10px 20px;
    border-radius: 6px;
    font-size: 14px;
  }
  
  .skip-btn {
    min-width: 80px;
  }
  
  .confirm-btn {
    min-width: 80px;
  }
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

@keyframes slideUp {
  from {
    transform: translateY(50px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

// 响应式设计
@media (max-width: 768px) {
  .language-selector-modal {
    width: 95%;
    margin: 20px;
  }
  
  .modal-header {
    padding: 20px 16px 12px;
    
    .modal-title {
      font-size: 18px;
    }
  }
  
  .modal-body {
    padding: 16px;
  }
  
  .modal-footer {
    padding: 12px 16px 20px;
    flex-direction: column;
    
    .skip-btn,
    .confirm-btn {
      width: 100%;
      margin: 0;
    }
  }
  
  .language-option {
    padding: 10px;
    
    .language-flag {
      width: 28px;
      height: 20px;
    }
    
    .language-info {
      .language-name {
        font-size: 15px;
      }
    }
  }
}
</style>








































