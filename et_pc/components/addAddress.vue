<template>
    <div v-loading="loading">
      <el-form :model="formData" :rules="rules" ref="formData" label-width="100px" class="demo-ruleForm" label-position="top" :inline="true">
        <el-form-item :label="$t(`page.users.userAddress.name`)" prop="realName" class="inline">
          <el-input v-model="formData.realName" :placeholder='$t(`page.users.userAddress.place`) +  $t(`page.users.userAddress.name`)'></el-input>
        </el-form-item>
        <el-form-item :label="$t(`page.users.userAddress.Email`)" prop="email" class="inline">
          <el-input v-model="formData.email" :placeholder='$t(`page.users.userAddress.place`) +  $t(`page.users.userAddress.Email`)'></el-input>
        </el-form-item>
        <el-form-item :label="$t(`page.users.userAddress.phone`)" prop="phone" class="inline">
          <el-input v-model="formData.phone" :placeholder='$t(`page.users.userAddress.place`) +  $t(`page.users.userAddress.phone`)'></el-input>
        </el-form-item>
        <el-form-item :label="$t(`page.users.userAddress.postCode`)" prop="postCode" class="inline">
          <el-input v-model="formData.postCode" :placeholder='$t(`message.login.postCode`)'></el-input>
        </el-form-item>
        <el-form-item :label="$t(`page.users.userAddress.country`)" prop="country" class="lang">
          <div class="tel-container el-form-item__content el-input__inner">
            <div class="right_select">
              {{this.countryName}}{{this.formData.country}}
              <country-code-selector @countryInfo="countryInfo" :countryCode.sync="formData.countryCode">
              </country-code-selector>
            </div>
          </div>
        </el-form-item>
        <el-form-item :label="$t(`page.users.userAddress.address`)" prop="detail" class="lang">
          <el-input
            type="textarea"
            :rows="2"
            :placeholder='$t(`page.users.userAddress.place`) +  $t(`page.users.userAddress.address`)'
            v-model="formData.detail">
          </el-input>
        </el-form-item>
        <el-form-item prop="isDefault" class="lang">
          <el-checkbox v-model="formData.isDefault">{{$t(`page.users.userAddress.default`)}}</el-checkbox>
        </el-form-item>
        <el-form-item>
          <el-button :loading="loadingBtn" type="primary" @click="submitForm('formData')">{{$t(`page.users.userAddress.save`)}}</el-button>
          <el-button @click="resetForm('formData')">{{$t(`page.goodsDetail.cancel`)}}</el-button>
        </el-form-item>
      </el-form>
    </div>
</template>

<script>
  import CountryCodeSelector from "~/components/countryCodeSelector.vue";
  import { getIpInfo } from '@/utils/order.js';
    export default {
        name: "addAddress",
      props: {
        formDatas: {
          type: Object,
          default: {}
        }
      },
        data() {
          return {
            loading: true,
            loadingBtn: false,
            countryName: '',
            formData: {
              country: '',
              countryCode: 86,
              email: '',
              realName: '',
              phone: '',
              detail: '',
              isDefault: false,
              postCode: ''
            },
            rules: {
              realName:[
                { required: true, message: this.$t(`message.login.name`), trigger: 'blur' }
              ],
              email:[
                { required: true, message: this.$t(`message.login.emailEmpty`), trigger: 'blur' },
                { type: 'email', message: this.$t(`message.login.correctEmail`), trigger: ['blur', 'change'] }
              ],
              phone:[
                { required: true, message: this.$t(`message.login.emptyPhone`), trigger: 'blur' }
              ],
              country:[
                { required: true, message: this.$t(`message.login.country`), trigger: 'blur' }
              ],
              detail:[
                { required: true, message: this.$t(`message.login.detail`), trigger: 'blur' }
              ],
              postCode: [
                {required: true, message: this.$t(`message.login.postCode`), trigger: 'blur'}
              ]
            }
          }
        },
      watch: {
        formDatas(n) {
          this.formData = n
          this.formData.countryCode = Number(n.countryCode)
          this.loading = false
        }
      },
      components: {CountryCodeSelector},
      beforeCreate(){

      },
      mounted() {
          if(this.formDatas.id){
            this.formData = this.formDatas
            this.formData.countryCode = Number(this.formDatas.countryCode)
          }else{
            getIpInfo(this).then((res) => {
              if(!this.id){
                this.$set(this.formData,'country',res.data.country_name);
                this.$set(this.formData,'countryCode', Number(res.data.country_calling_code));
                this.$set(this.formData,'detail',res.data.region + ' ' + res.data.city);
              }
              this.loading = false
            });
          }
      },
      methods: {
        countryInfo(obj){
          this.countryName = obj.name
          this.formData.country = obj.CNName
        },
        resetForm(formName) {
          this.$emit('closeAddressModal')
          this.$refs[formName].resetFields();
        },
        submitForm(formName) {
          this.$refs[formName].validate((valid) => {
            if (valid) {
              this.loadingBtn = true
              this.$axios.post('/api/front/address/edit', this.formData).then(res => {
                this.$message.success(this.$t(`message.login.saveSU`));
                this.$emit('closeAddress')
                this.loadingBtn = false
              }).catch(err => {
                this.loadingBtn = false
              })
            } else {
              console.log('error submit!!');
              return false;
            }
          });
        },
      }
    }
</script>

<style scoped lang="scss">
.lang{
  width: 100%;
}
.inline{
  width: 48%;
}
  .tel-container{
    width: 100%;
    height: 40px;
    border: 1px solid #DCDFE6;
    border-radius: 4px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding-left: 20px;
    .right_select {
      display: flex;
      align-items: center;

      .keyword {
        width: 62px;
        height: 16px;
        background: #EEEEEE;
        border-radius: 20px;
        font-size: 12px;
        font-family: ArialMT;
        color: #999999;
        line-height: 16px;
        text-align: center;
      }

      .search {
        width: 60px;
        height: 40px;
        background: #E93323;
        border-radius: 20px;
        text-align: center;
        line-height: 40px;
        color: #fff;
        margin-left: 11px;
      }
    }
  }
</style>
