<template>
  <span v-if="translatedText" :class="textClass">{{ translatedText }}</span>
  <span v-else :class="textClass">{{ originalText }}</span>
</template>

<script>
/**
 * 动态翻译组件
 * 用于翻译数据库中的动态内容
 */
export default {
  name: 'DynamicTranslate',
  props: {
    // 原始文本
    originalText: {
      type: String,
      required: true
    },
    // 翻译类型：product_name, category_name, description等
    translateType: {
      type: String,
      default: 'text'
    },
    // 关联ID（如商品ID、分类ID）
    entityId: {
      type: [String, Number],
      default: null
    },
    // CSS类名
    textClass: {
      type: String,
      default: ''
    },
    // 是否启用缓存
    enableCache: {
      type: Boolean,
      default: true
    }
  },
  data() {
    return {
      translatedText: '',
      isTranslating: false,
      translationCache: new Map()
    }
  },
  computed: {
    currentLocale() {
      return this.$i18n.locale;
    },
    cacheKey() {
      return `${this.translateType}_${this.entityId}_${this.currentLocale}`;
    }
  },
  watch: {
    currentLocale: {
      immediate: true,
      handler(newLocale) {
        this.handleTranslation(newLocale);
      }
    },
    originalText: {
      immediate: true,
      handler() {
        this.handleTranslation(this.currentLocale);
      }
    }
  },
  methods: {
    /**
     * 处理翻译逻辑
     */
    async handleTranslation(locale) {
      // 如果是中文或原始语言，直接显示原文
      if (locale === 'zh-CN' || !this.originalText) {
        this.translatedText = this.originalText;
        return;
      }

      // 检查缓存
      if (this.enableCache && this.translationCache.has(this.cacheKey)) {
        this.translatedText = this.translationCache.get(this.cacheKey);
        return;
      }

      // 检查本地存储缓存
      const cachedTranslation = this.getFromLocalCache();
      if (cachedTranslation) {
        this.translatedText = cachedTranslation;
        if (this.enableCache) {
          this.translationCache.set(this.cacheKey, cachedTranslation);
        }
        return;
      }

      // 执行翻译
      await this.performTranslation(locale);
    },

    /**
     * 执行翻译请求
     */
    async performTranslation(locale) {
      if (this.isTranslating) return;

      this.isTranslating = true;
      try {
        // 方案1：从数据库多语言字段获取
        const dbTranslation = await this.getFromDatabase(locale);
        if (dbTranslation) {
          this.translatedText = dbTranslation;
          this.saveToLocalCache(dbTranslation);
          return;
        }

        // 如果数据库没有翻译，直接使用原文（不调用翻译API）
        this.translatedText = this.originalText;
      } catch (error) {
        console.error('翻译失败:', error);
        this.translatedText = this.originalText;
      } finally {
        this.isTranslating = false;
      }
    },

    /**
     * 从数据库获取翻译
     */
    async getFromDatabase(locale) {
      if (!this.entityId) return null;

      try {
        const response = await this.$axios.get('/api/front/translation/get', {
          params: {
            type: this.translateType,
            entityId: this.entityId,
            locale: locale
          }
        });
        return response.data?.translation || null;
      } catch (error) {
        console.log('数据库翻译获取失败:', error);
        return null;
      }
    },

    /**
     * 调用翻译API
     */
    async getFromTranslationAPI(locale) {
      try {
        const response = await this.$axios.post('/api/front/translation/translate', {
          text: this.originalText,
          targetLanguage: locale,
          sourceLanguage: 'zh-CN',
          type: this.translateType,
          entityId: this.entityId
        });
        return response.data?.translatedText || null;
      } catch (error) {
        console.error('API翻译失败:', error);
        return null;
      }
    },

    /**
     * 保存翻译到数据库
     */
    async saveToDatabase(locale, translation) {
      if (!this.entityId) return;

      try {
        await this.$axios.post('/api/front/translation/save', {
          type: this.translateType,
          entityId: this.entityId,
          locale: locale,
          translation: translation
        });
      } catch (error) {
        console.error('保存翻译到数据库失败:', error);
      }
    },

    /**
     * 从本地缓存获取翻译
     */
    getFromLocalCache() {
      try {
        const cache = JSON.parse(localStorage.getItem('translation_cache') || '{}');
        return cache[this.cacheKey] || null;
      } catch (error) {
        return null;
      }
    },

    /**
     * 保存翻译到本地缓存
     */
    saveToLocalCache(translation) {
      try {
        const cache = JSON.parse(localStorage.getItem('translation_cache') || '{}');
        cache[this.cacheKey] = translation;
        
        // 限制缓存大小，只保留最近1000条
        const keys = Object.keys(cache);
        if (keys.length > 1000) {
          const keysToDelete = keys.slice(0, keys.length - 1000);
          keysToDelete.forEach(key => delete cache[key]);
        }
        
        localStorage.setItem('translation_cache', JSON.stringify(cache));
        
        if (this.enableCache) {
          this.translationCache.set(this.cacheKey, translation);
        }
      } catch (error) {
        console.error('保存本地缓存失败:', error);
      }
    }
  }
}
</script>

<style scoped>
/* 翻译加载状态样式 */
.translating {
  opacity: 0.7;
  transition: opacity 0.3s ease;
}
</style>

