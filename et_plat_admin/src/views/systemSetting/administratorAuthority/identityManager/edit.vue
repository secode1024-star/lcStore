<template>
  <div>
    <el-form ref="pram" :model="pram" label-width="100px" @submit.native.prevent>
      <el-form-item
        label="角色名称"
        prop="roleName"
        :rules="[{ required: true, message: '请填写角色名称', trigger: ['blur', 'change'] }]"
      >
        <el-input v-model="pram.roleName" placeholder="身份名称" />
      </el-form-item>
      <el-form-item label="状态">
        <el-switch v-model="pram.status" :active-value="true" :inactive-value="false" />
      </el-form-item>
      <el-form-item label="菜单权限">
        <el-checkbox v-model="menuExpand" @change="handleCheckedTreeExpand($event, 'menu')">展开/折叠</el-checkbox>
        <!-- <el-checkbox v-model="menuNodeAll" @change="handleCheckedTreeNodeAll($event, 'menu')">全选/全不选</el-checkbox> -->
        <el-checkbox v-model="menuCheckStrictly" @change="handleCheckedTreeConnect($event, 'menu')"
          >父子联动</el-checkbox
        >
        <el-tree
          class="tree-border"
          :data="menuOptions"
          show-checkbox
          ref="menu"
          node-key="id"
          :check-strictly="!menuCheckStrictly"
          empty-text="加载中，请稍候"
          :props="defaultProps"
          @check="handleNodeClick"
        ></el-tree>
      </el-form-item>
      <el-form-item>
        <el-button
          type="primary"
          @click="handlerSubmit('pram')"
          v-hasPermi="['platform:admin:role:update', 'platform:admin:role:save']"
          >{{ isCreate === 0 ? '确定' : '更新' }}</el-button
        >
        <el-button @click="close">取消</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
import * as roleApi from '@/api/role.js';
import { Debounce } from '@/utils/validate';

export default {
  name: 'roleEdit',
  props: {
    isCreate: {
      type: Number,
      required: true,
    },
    editData: {
      type: Object,
      default: null,
    },
  },
  data() {
    return {
      pram: {
        roleName: null,
        rules: '',
        status: null,
        id: null,
      },
      menuExpand: false,
      menuNodeAll: false,
      menuOptions: [],
      menuCheckStrictly: true,
      currentNodeId: [],
      defaultProps: {
        children: 'childList',
        label: 'name',
      },
      menuIds: [],
      //存放一些需要关联选中的权限id，比如选中商品列表、商户列表也要默认选中，因为商品列表中调用拉拉商户列表的接口。
      selectedList: [],
    };
  },
  mounted() {
    this.initEditData();
    this.getCacheMenu();
  },
  methods: {
    /**
     * 分配权限的时候，有些关联权限会默认一起选中，即使他们不在一个菜单下面, 业务中会用到这些关联的权限
     * 比如选中商品列表、商户列表也要默认选中，因为商品列表中调用拉拉商户列表的接口。
     * @param data 选中这条数据的对象
     * @param checkedKeys 选中节点的key数组
     */
    handleNodeClick(data, checkedKeys) {
      let selected = checkedKeys.checkedKeys.indexOf(data.id); //判断是否选中
      let checkedId = checkedKeys.checkedKeys; // 这是选中的节点的key数组
      // 商品列表权限，选择商品、商品列表、财务、转账记录，商品评论，默认选中商户列表、商户分页列表表头数量、平台端商品分类列表、分类缓存树148
      // 商品2 商品列表188 财务5 转账记录325 分类缓存树148 商户分页列表表头数量345 平台端商品分类列表143 商品评论253
      if (data.id === 2 || data.id === 188 || data.id === 309 || data.id === 5 || data.id === 325 || data.id === 253) {
        let menuIds = [128, 148, 143, 345];
        menuIds.forEach((i, n) => {
          let node = this.$refs.menu.getNode(i);
          //选中
          this.onSelected(node, selected);
          //取消选中
          this.onUncheck(data, checkedId, node, selected);
        });
      }
      // 商户列表权限，选择商户列表、商户分页列表、商户入驻申请、商户入驻分页列表，商品评论，默认选中获取全部商户类型列表,全部商户类型列表，商户分页列表表头数量, 商户分类分页列表
      // 商户列表163 商户分页列表128 全部商户分类列表108 全部商户类型列表113 商户分类分页列表104
      // 商户入驻申请165 商户入驻分页列表125 商户分页列表表头数量345
      if (data.id === 128 || data.id === 163 || data.id === 165 || data.id === 125) {
        let menuIds = [113, 108, 345, 104];
        menuIds.forEach((i, n) => {
          let node = this.$refs.menu.getNode(i);
          //选中
          this.onSelected(node, selected);
          //取消选中
          this.onUncheck(data, checkedId, node, selected);
        });
      }
      //选择商品评论，默认选中商户
    },
    /**
     * 选中权限，并且一起选中关联权限呢
     * @param selected 当前选中的id
     */
    onSelected(node, selected) {
      //如果选中
      if (selected !== -1) this.$refs.menu.setChecked(node, true);
    },
    /**
     * 共同关联同一个权限时，取消选中，取消选中关联权限
     * 全部id数组 与 共同关联同一个权限数组，两个数组比较 是否存在相同的值，不存在，取消关联选中的权限
     * @param item 选中的对象
     * @param checkedId 所有tree选中的值
     * @param node 要关联选中的值
     */
    onUncheck(item, checkedId, node, selected) {
      //获取一些需要关联选中的权限id
      const { id } = item;
      // 进行过滤去重筛选
      if (selected !== -1) {
        this.selectedList.push(item.id);
      } else {
        //如果有就移除
        let arr = this.selectedList.filter((sub) => {
          return item.id != sub;
        });
        this.selectedList = arr;
      }
      //两个数组比较是否存在相同的值,不存在就删掉
      const hasCommonValue = this.selectedList.some((value) => checkedId.includes(value));
      if (!hasCommonValue) {
        this.$refs.menu.setChecked(node, false);
      }
    },
    close() {
      this.$emit('hideEditDialog');
    },
    initEditData() {
      if (this.isCreate !== 1) return;
      const { roleName, status, id } = this.editData;
      this.pram.roleName = roleName;
      this.pram.status = status;
      this.pram.id = id;
      const loading = this.$loading({
        lock: true,
        text: 'Loading',
      });
      roleApi.getInfo(id).then((res) => {
        this.menuOptions = res.menuList;
        this.checkDisabled(this.menuOptions);
        loading.close();
        this.getTreeId(res.menuList);
        this.$nextTick(() => {
          this.menuIds.forEach((i, n) => {
            var node = this.$refs.menu.getNode(i);
            if (node.isLeaf) {
              this.$refs.menu.setChecked(node, true);
            }
          });
        });
      });
    },
    handlerSubmit: Debounce(function (form) {
      this.$refs[form].validate((valid) => {
        if (!valid) return;
        let roles = this.getMenuAllCheckedKeys().toString();
        this.pram.rules = roles;
        if (this.isCreate === 0) {
          this.handlerSave();
        } else {
          this.handlerEdit();
        }
      });
    }),
    handlerSave() {
      roleApi.addRole(this.pram).then((data) => {
        this.$message.success('创建身份成功');
        this.$emit('hideEditDialog');
      });
    },
    handlerEdit() {
      roleApi.updateRole(this.pram).then((data) => {
        this.$message.success('更新身份成功');
        this.$emit('hideEditDialog');
      });
    },
    rulesSelect(selectKeys) {
      this.pram.rules = selectKeys;
    },
    // 树权限（展开/折叠）
    handleCheckedTreeExpand(value, type) {
      if (type == 'menu') {
        let treeList = this.menuOptions;
        for (let i = 0; i < treeList.length; i++) {
          this.$refs.menu.store.nodesMap[treeList[i].id].expanded = value;
        }
      }
    },
    // 树权限（全选/全不选）
    handleCheckedTreeNodeAll(value, type) {
      if (type == 'menu') {
        this.$refs.menu.setCheckedNodes(value ? this.menuOptions : []);
      }
    },
    // 树权限（父子联动）
    handleCheckedTreeConnect(value, type) {
      if (type == 'menu') {
        this.menuCheckStrictly = value ? true : false;
      }
    },
    // 所有菜单节点数据
    getMenuAllCheckedKeys() {
      // 目前被选中的菜单节点
      let checkedKeys = this.$refs.menu.getCheckedKeys();
      // 半选中的菜单节点
      let halfCheckedKeys = this.$refs.menu.getHalfCheckedKeys();
      checkedKeys.unshift.apply(checkedKeys, halfCheckedKeys);
      return checkedKeys;
    },
    getCacheMenu() {
      if (this.isCreate !== 0) return;
      const loading = this.$loading({
        lock: true,
        text: 'Loading',
      });
      roleApi.menuCacheList().then((res) => {
        this.menuOptions = res;
        this.checkDisabled(this.menuOptions);
        loading.close();
      });
    },
    getTreeId(datas) {
      for (var i in datas) {
        if (datas[i].checked) this.menuIds.push(datas[i].id);
        if (datas[i].childList) {
          this.getTreeId(datas[i].childList);
        }
      }
    },
    checkDisabled(data) {
      //设置公共权限默认勾选且不可操作
      data.forEach((item) => {
        if (item.id === 53 || item.id === 62 || item.id === 87) {
          item.disabled = true;
          item.childList.forEach((item1) => {
            item1.disabled = true;
            this.$nextTick(() => {
              var node = this.$refs.menu.getNode(item1.id);
              if (node.isLeaf) {
                this.$refs.menu.setChecked(node, true);
              }
            });
          });
        }
      });
    },
  },
};
</script>

<style scoped></style>
