export default {
  methods: {
    // 处理图片URL，确保在开发和生产环境都能正确访问
    processImageUrl(url) {
      if (!url) return '';

      // 🔥 修复：如果已经是完整的HTTP/HTTPS URL，直接返回，不要转换为相对路径
      if (url.startsWith('http://') || url.startsWith('https://')) {
        return url;
      }

      // 如果已经是完整的相对路径，直接返回（适用于代理环境）
      if (url.startsWith('/crmebimage/')) {
        return url;
      }

      // 如果是相对路径（如：crmebimage/public/...），添加前缀
      if (url.startsWith('crmebimage/')) {
        return '/' + url;
      }

      // 其他情况直接返回原始URL
      return url;
    },
  },

  // 添加全局方法注册
  beforeCreate() {
    // 只在Vue实例上没有$imageUrl方法时才添加
    if (!this.$imageUrl) {
      this.$imageUrl = (url) => {
        return this.processImageUrl(url);
      };
    }
  },
};


