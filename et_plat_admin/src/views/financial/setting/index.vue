<template>
  <div class="divBox">
    <el-card class="box-card">
      <div class="form-data" v-loading="loading">
        <z-b-parser
          v-if="!loading"
          :is-create="1"
          :form-conf="formConf"
          :edit-data="editData"
          :form-id="159"
          :key-num="keyNum"
          @submit="handlerSubmit"
        />
      </div>
    </el-card>
  </div>
</template>
<script>
// +----------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2016~2023 https://www.crmeb.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +----------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +----------------------------------------------------------------------
// import parser from '@/components/FormGenerator/components/parser/ZBParser'
import { transferEditApi, transferConfigApi } from '@/api/financial';
import { Debounce } from '@/utils/validate';
export default {
  // components: { parser },
  data() {
    return {
      formConf: { fields: [] },
      loading: false,
      keyNum: 0,
      editData: {},
    };
  },
  created() {
    //this.keyNum += 1
    this.getConfigInfo();
  },
  methods: {
    handlerSubmit: Debounce(function (formValue) {
      transferEditApi(formValue)
        .then((res) => {
          this.$message.success('操作成功');
          this.getConfigInfo();
        })
        .catch(() => {
          this.loading = false;
        });
    }),
    // 获取转账配置信息
    getConfigInfo() {
      this.keyNum += 1;
      this.loading = true;
      transferConfigApi()
        .then((res) => {
          for (var key in res) {
            res[key] = parseFloat(res[key]);
          }
          this.editData = res;
          this.loading = false;
        })
        .catch(() => {
          this.loading = false;
        });
    },
  },
};
</script>
