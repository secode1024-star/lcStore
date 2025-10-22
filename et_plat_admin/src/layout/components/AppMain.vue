<template>
  <section class="app-main">
    <keep-alive :include="cachedViews">
      <router-view :key="key" />
    </keep-alive>
    <div class="footers acea-row">
      <div class="title mb15" v-text="copyright"></div>
      <el-divider direction="vertical"></el-divider>
      <el-link v-for="item in links" :key="item.key" :href="item.href" target="_blank" class="mr15 mb20">{{
        item.title
      }}</el-link>
    </div>
  </section>
</template>

<script>
export default {
  name: 'AppMain',
  data() {
    return {
      links: [
        {
          title: '官网',
          key: '1',
          href: 'https://hqlccn.com/',
          blankTarget: true,
        },
      ],
      copyright: '寰球联采',
    };
  },
  computed: {
    cachedViews() {
      return this.$store.state.tagsView.cachedViews;
    },
    key() {
      return this.$route.path;
    },
  },
};
</script>

<style lang="scss" scoped>
.footers {
  text-align: center;
  font-size: 14px;
  color: #808695;
  justify-content: center;
  .title {
    font-size: 14px;
    color: #808695;
  }
}
.app-main {
  /* 50= navbar  50  */
  min-height: calc(100vh - 50px);
  width: 100%;
  position: relative;
  overflow: hidden;
}

.fixed-header + .app-main {
  padding-top: 50px;
}

.hasTagsView {
  .app-main {
    background: #f5f5f5;
    /* 84 = navbar + tags-view = 50 + 34 */
    min-height: calc(100vh - 84px);
    overflow-y: scroll;
  }

  .fixed-header + .app-main {
    padding-top: 80px;
  }
}
.el-popup-parent--hidden {
  .fixed-header {
    padding-right: 15px;
  }
}
</style>
