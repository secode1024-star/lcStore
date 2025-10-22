export default {
  methods: {
    // 处理图片URL，确保在开发和生产环境都能正确访问
    processImageUrl(url) {
      if (!url) return '';

      // 🔥 修复：如果已经是完整的HTTP/HTTPS URL，直接返回
      if (url.startsWith('http://') || url.startsWith('https://')) {
        return url;
      }

      // 根据环境确定API基础URL
      const apiBaseUrl = process.env.NODE_ENV === 'production' 
        ? 'https://api1.hqlccn.com'  // 生产环境使用API服务器
        : 'http://localhost:20008';  // 开发环境使用本地

      // 如果已经是完整的相对路径，使用API基础URL
      if (url.startsWith('/crmebimage/')) {
        return `${apiBaseUrl}${url}`;
      }

      // 如果是相对路径（如：crmebimage/public/...），添加完整前缀
      if (url.startsWith('crmebimage/')) {
        return `${apiBaseUrl}/${url}`;
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