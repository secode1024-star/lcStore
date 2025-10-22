<template>
  <div class="divBox" style="padding-top: 0">
    <el-card class="box-card" :body-style="{ paddingLeft: '0px', paddingBottom: '0px' }">
      <div class="flex">
        <!--左侧-->
        <div class="tab_view">
          <div
            class="cell_item"
            :class="{ tab_active: listActive == index }"
            v-for="(item, index) in tabList"
            :key="index"
            @click="ProductNavTab(index)"
          >
            {{ item }}
          </div>
        </div>
        <!--中间-->
        <div class="leftModel">
          <div v-show="currentPage == 'home'" class="current_home">
            <div class="model_header">
              <div class="logo">
                <img
                  class="tui-skeleton-rect"
                  src="https://api.java.crmeb.net/crmebimage/public/operation/2021/09/23/aa6e46fd9fbd424e8cb636a34db50176nj0e4r0f6o.png"
                />
              </div>
              <div class="search">
                <div class="search_input">
                  <div class="input_btn">
                    <span class="iconfont icon-sousuo2"></span>
                  </div>
                </div>
              </div>
              <div class="open">
                <i class="el-icon-s-fold"></i>
              </div>
            </div>
            <div class="mp-bg"></div>
            <div
              class="model_banner cur_pointer"
              :class="form.resource == 1 ? 'banner_big' : 'banner_small'"
              @click="handleMessage('indexBanner')"
            >
              <el-carousel indicator-position="none" :height="form.resource == 1 ? '375px' : '160px'">
                <el-carousel-item v-for="(item, index) in dataList[1]" :key="index">
                  <img :src="item.pic" alt="" :class="{ select_ctive: shows == 1 }" style="width: 100%; height: 100%" />
                </el-carousel-item>
              </el-carousel>
            </div>
            <div
              class="model_nav cur_pointer"
              :class="{ select_ctive: shows == 3 }"
              @click="handleMessage('indexMenu')"
            >
              <div class="model_nav_item" v-for="(item, index) in dataList[0]" :key="index">
                <div>
                  <img :src="item.pic" alt="" />
                </div>
                <p class="menu_name">{{ item.name }}</p>
              </div>
            </div>
            <div
              class="model_nav cur_pointer"
              :class="{ select_ctive: shows == 4 }"
              @click="handleMessage('indexRanking')"
              style="padding: 0 0 0 15px"
            >
              <div class="shop acea-row">
                <div v-for="(item, index) in dataList[5]" :key="index" :class="{ ml3: index === 1 }">
                  <div class="shop-item">
                    <div class="pic tui-skeleton-fillet">
                      <el-image :src="item.pic" :class="{ pic2: index === 1, pic1: index === 0 }"></el-image>
                    </div>
                  </div>
                  <div class="go acea-row row-between-wrapper">
                    <span>{{ item.name }}</span>
                    <div class="goTo">
                      <span class="iconfont icon-jiantou"></span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <!--底部菜单-->
            <div
              v-hasPermi="['platform:system:group:list']"
              class="page-foot cur_pointer"
              @click="handleMessage('bottomNavigation')"
            >
              <div class="page-fooot" :class="{ select_ctive: shows == 8 }">
                <div class="foot-item" v-for="(item, index) in navigationListTab" :key="index">
                  <el-image :src="item.checked" alt="" class="el-image" />
                  <p v-if="index == 0" class="fontColor3">{{ item.name }}</p>
                  <p v-else>{{ item.name }}</p>
                </div>
              </div>
            </div>
          </div>
          <div v-show="currentPage == 'cate'">
            <img :src="cateImg" alt="" style="width: 100%" />
          </div>
          <div v-show="currentPage == 'user'">
            <div class="user_head">
              <div class="user_bg">
                <div class="user_card">
                  <div class="user_info">
                    <img src="@/assets/imgs/default_avatar.png" alt="" />
                    <div class="info">
                      <p class="nick_name">用户信息</p>
                      <p class="phone">abcdefg123456 <i class="el-icon-arrow-right"></i></p>
                    </div>
                  </div>
                  <div class="num_wrapper">
                    <div class="num_wrap_item">
                      <p class="num_item_bold">0</p>
                      <p class="num_title">收藏</p>
                    </div>
                    <div class="num_wrap_item">
                      <p class="num_item_bold">0</p>
                      <p class="num_title">优惠券</p>
                    </div>
                  </div>
                </div>
                <div class="order_wrap">
                  <div class="order_wrap_tit">
                    <span class="weight_600">订单中心</span>
                    <div>
                      <span class="font_sm">查看全部</span>
                      <i class="el-icon-arrow-right"></i>
                    </div>
                  </div>
                  <div class="order_wrap_list">
                    <div class="order_list_item">
                      <img src="@/assets/imgs/fukuan.png" alt="" />
                      <p>待付款</p>
                    </div>
                    <div class="order_list_item">
                      <img src="@/assets/imgs/fahuo.png" alt="" />
                      <p>待发货</p>
                    </div>
                    <div class="order_list_item">
                      <img src="@/assets/imgs/shouhuo.png" alt="" />
                      <p>待收货</p>
                    </div>
                    <div class="order_list_item">
                      <img src="@/assets/imgs/pingjia.png" alt="" />
                      <p>待评价</p>
                    </div>
                    <div class="order_list_item">
                      <img src="@/assets/imgs/tuikuan.png" alt="" />
                      <p>售后/退款</p>
                    </div>
                  </div>
                </div>
                <div
                  class="slider_img cur_pointer"
                  :class="{ select_ctive: shows == 5 }"
                  @click="handleMessage('userBanner')"
                >
                  <el-carousel height="69px" :autoplay="true">
                    <el-carousel-item v-for="(item, index) in dataList[4]" :key="index">
                      <img :src="item.pic" alt="" style="height: 69px; display: block; margin: auto" />
                    </el-carousel-item>
                  </el-carousel>
                </div>
                <div
                  class="user_mens cur_pointer"
                  :class="{ select_ctive: shows == 6 }"
                  @click="handleMessage('userMenu')"
                >
                  <div class="menu_title">我的服务</div>
                  <div class="list_box_item" v-for="(item, index) in dataList[2]" :key="index">
                    <div>
                      <img :src="item.pic" alt="" />
                      <span>{{ item.name }}</span>
                    </div>
                    <i class="el-icon-arrow-right"></i>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <!--右侧-->
        <div class="flex_between">
          <div class="right-box" v-if="typeName">
            <div class="title-bar">模块配置</div>
            <!--底部菜单-->
            <template v-if="typeName === 'bottomNavigation' && checkPermi(['platform:page:layout:bottom:navigation'])">
              <span class="mr20">是否开启导航栏：</span>
              <el-switch
                :active-value="1"
                :inactive-value="0"
                active-text="开启"
                inactive-text="关闭"
                v-model="isCustom"
              >
              </el-switch>
              <div class="box-item" v-for="(item, index) in navigationList" :key="index">
                <div class="left-tool">
                  <div
                    class="move-icon"
                    draggable="true"
                    @dragstart="handleDragStart($event, item)"
                    @dragover.prevent="handleDragOver($event, item)"
                    @dragenter="handleDragEnter($event, item, navigationList, 'navigationList')"
                    @dragend="handleDragEnd($event, item)"
                  >
                    <span class="iconfont icondrag2"></span>
                  </div>
                </div>
                <div class="right-wrapper">
                  <div class="img-wrapper">
                    <div class="img-item" @click="modalPicTap('2', 'checked', index)">
                      <img :src="item.checked" alt="" v-if="item.checked" />
                      <p class="txt" v-if="item.checked">选中</p>
                      <div class="empty-img" v-else>
                        <span class="iconfont iconjiahao"></span>
                        <p>选中</p>
                      </div>
                    </div>
                    <div class="img-item" @click="modalPicTap('3', 'unchecked', index)">
                      <img :src="item.unchecked" alt="" v-if="item.unchecked" />
                      <p class="txt" v-if="item.unchecked">未选中</p>
                      <div class="empty-img" v-else>
                        <span class="iconfont iconjiahao"></span>
                        <p>未选中</p>
                      </div>
                    </div>
                  </div>
                  <div class="info mt20" style="margin-left: 0">
                    <div class="info-item">
                      <span>标题</span>
                      <div class="input-box">
                        <el-input
                          v-if="typeName !== 'indexNews'"
                          v-model.trim="item.name"
                          :placeholder="'请填写' + item.name"
                        />
                        <el-input v-else v-model.trim="item.info" :placeholder="'请填写' + item.info" />
                      </div>
                    </div>
                    <div class="info-item">
                      <span>链接</span>
                      <div class="input-box" @click="getLink(index)">
                        <el-input v-model.trim="item.link" placeholder="请填写链接" />
                      </div>
                    </div>
                    <div class="info-item">
                      <span>状态</span>
                      <div class="input-box">
                        <el-switch
                          v-model="item.status"
                          :active-value="true"
                          :inactive-value="false"
                          active-text="显示"
                          inactive-text="隐藏"
                        />
                      </div>
                    </div>
                  </div>
                </div>
                <div v-show="index > 0" class="delect-btn" @click.stop="handleDelMenu(item, index)">
                  <i class="el-icon-circle-close"></i>
                </div>
              </div>
            </template>
            <!--首页头部菜单-->
            <div v-show="typeName === 'indexBanner'">
              <el-form ref="form" :model="form" label-width="100px">
                <el-form-item label="样式选择：">
                  <el-radio-group v-model="form.resource">
                    <el-radio label="1">样式1</el-radio>
                    <el-radio label="2">样式2</el-radio>
                  </el-radio-group>
                </el-form-item>
              </el-form>
            </div>
            <el-alert
              v-show="typeName === 'userBanner'"
              title="链接请配置域名!"
              :closable="false"
              type="warning"
              effect="dark"
            >
            </el-alert>
            <!--其他菜单-->
            <el-alert
              :closable="false"
              v-show="typeName === 'userMenu'"
              title="pc商城菜单需要在组合数据里设置关联使用！"
              type="warning"
              effect="dark"
            >
            </el-alert>
            <div v-if="typeName !== 'bottomNavigation'" class="mobile-config">
              <div v-for="(item, index) in menuList" :key="index" class="item">
                <div
                  class="move-icon"
                  draggable="true"
                  @dragstart="handleDragStart($event, item)"
                  @dragover.prevent="handleDragOver($event, item)"
                  @dragenter="handleDragEnter($event, item, menuList, 'menuList')"
                  @dragend="handleDragEnd($event, item)"
                >
                  <span class="iconfont icondrag2"></span>
                </div>
                <div class="picBox" v-if="typeName !== 'indexNews'">
                  <div class="img-box flex justify-center align-center" @click="modalPicTap('1', 'duo', index, true)">
                    <img :src="item.pic" alt="" v-if="item.pic" />
                    <div v-else class="upLoad">
                      <i class="el-icon-camera cameraIconfont" />
                    </div>
                  </div>
                </div>
                <div
                  v-if="index > 0 && typeName !== 'indexTabNav' && typeName !== 'indexRanking'"
                  class="delect-btn"
                  @click.stop="bindDelete(item, index)"
                >
                  <i class="el-icon-circle-close"></i>
                </div>
                <div class="info">
                  <div v-if="typeName !== 'userBanner'" class="info-item">
                    <span>标题</span>
                    <div class="input-box">
                      <el-input
                        v-if="typeName !== 'indexNews'"
                        v-model="item.name"
                        :placeholder="'请填写' + item.name"
                      />
                      <el-input v-else v-model="item.info" :placeholder="'请填写' + item.info" />
                    </div>
                  </div>
                  <div
                    class="info-item"
                    v-if="addUrlStatus && typeName !== 'indexTabNav' && typeName !== 'indexRanking'"
                  >
                    <span>链接</span>
                    <div class="input-box" @click="getLink(index)">
                      <el-input v-model="item.url" placeholder="请填写链接" />
                    </div>
                  </div>
                  <div class="info-item" v-if="typeName == 'indexTabNav'">
                    <span>简介</span>
                    <div class="input-box">
                      <el-input v-model="item.info" placeholder="请填写简介" />
                    </div>
                  </div>
                  <div class="info-item" v-if="typeName !== 'indexRanking'">
                    <span>状态</span>
                    <div class="input-box">
                      <el-switch
                        v-model="item.status"
                        :active-value="true"
                        :inactive-value="false"
                        active-text="显示"
                        inactive-text="隐藏"
                      />
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="add-btn mb20 mt20">
              <el-button @click="addBox" type="primary">添加数据</el-button>
            </div>
          </div>
          <linkaddress ref="linkaddres" @linkUrl="linkUrl"></linkaddress>
          <div class="tip" v-if="!typeName && tip == true && cate == false">请选择左侧可操作可编辑区域</div>
        </div>
      </div>
      <div class="footer_btn">
        <el-button
          type="primary"
          @click="saveConfig"
          v-if="!mockGoods"
          v-hasPermi="[
            'platform:page:layout:save',
            'platform:page:layout:index:banner:save',
            'platform:page:layout:index:menu:save',
            'platform:page:layout:user:menu:save',
            'platform:page:layout:index:table:save',
            'platform:page:layout:category:config:save',
            'platform:page:layout:user:banner:save',
            'platform:page:layout:index:ranking:save',
            'platform:page:layout:bottom:navigation',
            'platform:page:layout:bottom:navigation:save',
          ]"
          >保存</el-button
        >
      </div>
    </el-card>
  </div>
</template>

<script>
import {
  designListApi,
  SaveDataApi,
  goodDesignList,
  getDataApi,
  themeSave,
  getTheme,
  getBottomNavigationApi,
} from '@/api/systemGroup';
import ClipboardJS from 'clipboard';
import { configInfo } from '@/api/systemConfig';
import linkaddress from '@/components/linkaddress';
import { checkPermi } from '@/utils/permission'; // 权限判断函数
import { Debounce } from '@/utils/validate';
export default {
  name: 'index',
  data() {
    return {
      //banner样式选择
      form: {
        resource: '1',
      },
      iframeUrl: '',
      menuList: [],
      menuInfo: {},
      typeName: '',
      currentPage: 'home',
      modelBanner: [
        'https://image.java.crmeb.net/crmebimage/maintain/2021/07/06/c99ee385e94d4711a0ea4be72169a86euwmzuhxbb2.jpg',
      ],
      indexTab: [],
      dataList: [],
      addUrlStatus: true,
      infoStatus: false,
      showStatus: false,
      shows: 0,
      indextTabMenu: [],
      tabActive: 0,
      cate: false,
      tip: false,
      mockGoods: false,
      mockGoodsImg: require('@/assets/theme/goodsList1.png'),
      showTabNav: true,
      cateArr: [
        { img: require('@/assets/imgs/moren.png'), tit: '默认模板' },
        { img: require('@/assets/imgs/youxuan.png'), tit: '模板1' },
        { img: require('@/assets/imgs/haowu.png'), tit: '模板2' },
        { img: require('@/assets/imgs/shengxian.png'), tit: '模板3' },
      ],
      cateImg: '',
      active: 1,
      active1: 0,
      disabled: false,
      radio: true,
      logoUrl: '',
      newsInfo: '',
      listActive: 0,
      tabList: ['首页', '个人中心', '底部菜单'],
      itemIndex: 0,
      navigationList: [], //右侧底部导航
      navigationListTab: [], //底部导航左侧展示
      isCustom: 0,
    };
  },
  components: {
    linkaddress,
  },
  created() {
    this.iframeUrl = `https://app.beta.java.crmeb.net?type=iframeVisualizing`;
  },
  mounted() {
    //监听子页面给当前页面传值
    window.addEventListener('message', this.handleMessage, false);
    this.designList();
    this.$set(this, 'typeName', '');
    this.$set(this, 'tip', true);
    this.$nextTick(function () {
      const clipboard = new ClipboardJS('.copy-data');
      clipboard.on('success', () => {
        this.$message.success('复制成功');
      });
    });
    this.getLogo();
    this.kindGet();
    if (checkPermi(['platform:page:layout:bottom:navigation'])) this.getBottomNavigation();
  },
  methods: {
    checkPermi,
    //获取底部导航
    getBottomNavigation() {
      getBottomNavigationApi().then((res) => {
        this.navigationList = res.bottomNavigationList;
        let data = res.bottomNavigationList.filter((item) => {
          return item.status;
        });
        this.navigationListTab = data;
        this.isCustom = Number(res.isCustom);
      });
    },
    // 获取logo
    getLogo() {
      configInfo({ id: 77 }).then((res) => {
        this.$set(this, 'logoUrl', res.mobile_top_logo);
      });
    },
    //右侧数据点击添加事件
    addBox() {
      if (this.typeName == 'bottomNavigation') {
        if (this.navigationList.length > 4) return this.$message.warning('设置数据不能超过5条');
        const indexMenu = JSON.parse(JSON.stringify(this.navigationList[0]));
        indexMenu.id = null;
        indexMenu.name = '';
        indexMenu.link = '';
        indexMenu.checked = '';
        indexMenu.unchecked = '';
        this.navigationList.push(indexMenu);
      } else if (this.menuList.length >= 10 && this.typeName == 'indexMenu') {
        this.$message.warning('设置数据不能超过10条');
      } else if (this.typeName == 'indexTabNav' && this.menuList.length >= 4) {
        this.addUrlStatus = false;
        this.infoStatus = true;
        this.$message.warning('设置数据不能超过4条');
      } else {
        if (this.menuList.length) {
          const indexMenu = JSON.parse(JSON.stringify(this.menuList[0]));
          indexMenu.id = null;
          indexMenu.name = '';
          indexMenu.url = '';
          indexMenu.info = '';
          indexMenu.pic = '';
          this.menuList.push(indexMenu);
        }
      }
    },
    // 获取列表值；
    designList() {
      designListApi().then((res) => {
        this.menuInfo = res;
        this.form.resource = this.menuInfo.indexBannerType;
        let newArr = [];
        let indexMenu = res.indexMenu.filter((item, index, arr) => {
          return item.status == true;
        });
        let indexBanner = res.indexBanner.filter((item, index, arr) => {
          return item.status == true;
        });
        let userMenu = res.userMenu.filter((item, index, arr) => {
          return item.status == true;
        });
        let indexNews = res.indexNews.filter((item, index, arr) => {
          return item.status == true;
        });
        let userBanner = res.userBanner.filter((item, index, arr) => {
          return item.status == true;
        });
        let indexRanking = res.indexRanking.filter((item, index, arr) => {
          return item.status == true;
        });
        newArr.push(indexMenu, indexBanner, userMenu, indexNews, userBanner, indexRanking);
        newArr[5].map(() => {
          newArr[5][0].name = 'SHOP STREET';
          newArr[5][1].name = 'TOP ONE';
        });
        this.dataList = newArr;
        this.$set(this, 'newsInfo', indexNews[0] ? indexNews[0].info : '这是一个新闻标题');
      });
      goodDesignList({ gid: 70 }).then((response) => {
        let list = response.list;
        let arr = [];
        let arr1 = [];
        list.forEach((item) => {
          let obj = {};
          obj.value = JSON.parse(item.value);
          obj.id = item.id;
          obj.gid = item.gid;
          obj.status = item.status;
          arr.push(obj);
        });
        arr.forEach((item1) => {
          let obj1 = {};
          obj1.pic = item1.value.fields[0].value;
          obj1.name = item1.value.fields[1].value;
          obj1.info = item1.value.fields[2].value;
          obj1.type = item1.value.fields[3].value;
          obj1.id = item1.id;
          obj1.gid = item1.gid;
          // obj1.show = '1';
          obj1.status = item1.status;
          arr1.push(obj1);
          this.indextTabMenu = arr1;
          let indexTab = arr1.filter((item, index, arr) => {
            return item.status == true;
          });
          this.indexTab = indexTab;
        });
        //
      });
    },
    //点击中间部分，模块区域
    handleMessage(event) {
      this.typeName = event;
      switch (event) {
        case 'bottomNavigation':
          this.shows = 8;
          break;
        case 'indexMenu':
          this.menuList = this.menuInfo.indexMenu;
          this.shows = 3;
          this.mockGoods = false;
          break;
        case 'indexBanner':
          this.menuList = this.menuInfo.indexBanner;
          this.shows = 1;
          this.mockGoods = false;
          break;
        case 'userMenu':
          this.menuList = this.menuInfo.userMenu;
          this.shows = 6;
          this.mockGoods = false;
          break;
        case 'userBanner':
          this.menuList = this.menuInfo.userBanner;
          this.shows = 5;
          this.mockGoods = false;
          break;
        case 'indexRanking':
          this.menuList = this.menuInfo.indexRanking;
          this.shows = 4;
          this.mockGoods = false;
          break;
      }
    },
    switchNav(index) {
      this.tabActive = index;
    },
    // 点击商品图
    modalPicTap(tit, num, i) {
      const _this = this;
      this.$modalUpload(
        function (img) {
          if (tit === '1' && num === 'duo') {
            _this.menuList[i].pic = img[0].sattDir;
          }
          if (tit === '2') {
            _this.navigationList[i].checked = img[0].sattDir;
          }
          if (tit === '3') {
            _this.navigationList[i].unchecked = img[0].sattDir;
          }
        },
        tit,
        'content',
        true,
      );
    },
    //删除底部菜单中的配置项
    handleDelMenu(item, index) {
      this.navigationList.splice(index, 1);
      this.navigationListTab.splice(index, 1);
    },
    // 删除 首页、个人中心中的配置项
    bindDelete(item, index) {
      this.menuList.splice(index, 1);
    },
    //保存数据
    saveConfig: Debounce(function () {
      switch (this.typeName) {
        case 'indexMenu':
          this.saveData('indexMenu', '/admin/platform/page/layout/index/menu/save');
          break;
        case 'indexBanner':
          this.saveData('indexBanner', '/admin/platform/page/layout/index/banner/save');
          break;
        case 'userMenu':
          this.saveData('userMenu', '/admin/platform/page/layout/user/menu/save');
          break;
        case 'indexNews':
          this.saveData('indexNews', '/admin/platform/page/layout/index/news/save');
          break;
        case 'userBanner':
          this.saveData('userBanner', '/admin/platform/page/layout/user/banner/save');
          break;
        case 'indexTabNav':
          this.saveData('indexTable', '/admin/platform/page/layout/index/table/save');
          break;
        case 'indexRanking':
          this.saveData('indexRanking', '/admin/platform/page/layout/index/ranking/save');
          break;
        case 'bottomNavigation':
          this.saveData('bottomNavigation', '/admin/platform/page/layout/bottom/navigation/save');
          break;
      }
    }),
    //保存请求接口提交数据
    saveData(param, url) {
      let tArr = this.menuList.filter((item, index, arr) => {
        return item.status == true;
      });
      let navigationList = this.navigationList.filter((item, index, arr) => {
        return item.status === true;
      });
      let data = {};
      if (param === 'bottomNavigation') {
        data = { bottomNavigationList: this.changeIndex(this.navigationList), isCustom: this.isCustom };
        if (navigationList.length < 4) return this.$message.warning('设置数据不能小于4条');
      } else if (param == 'indexMenu' && tArr.length < 4) {
        return this.$message.warning('设置数据不能小于4条');
      } else if (param === 'indexBanner') {
        data = {
          indexBannerType: this.form.resource,
          [param]: this.changeIndex(this.menuList),
        };
      } else {
        data = {
          [param]: this.changeIndex(this.menuList),
        };
      }
      SaveDataApi(data, url).then((res) => {
        this.$message.success('保存成功');
        if (param === 'bottomNavigation') {
          this.getBottomNavigation();
        } else {
          this.designList();
        }
      });
    },
    changeIndex(array) {
      array.map((item, index) => {
        item.sort = index;
      });
      return array;
    },
    // 移动
    handleDragStart(e, item) {
      this.dragging = item;
    },
    handleDragEnd(e, item) {
      this.dragging = null;
    },
    handleDragOver(e) {
      e.dataTransfer.dropEffect = 'move';
    },
    handleDragEnter(e, item, data, name) {
      e.dataTransfer.effectAllowed = 'move';
      if (item === this.dragging) {
        return;
      }
      const newItems = [...data];
      const src = newItems.indexOf(this.dragging);
      const dst = newItems.indexOf(item);
      newItems.splice(dst, 0, ...newItems.splice(src, 1));
      if (name === 'menuList') {
        this.menuList = newItems;
      } else {
        this.navigationList = newItems;
        this.navigationListTab = newItems;
      }
    },
    showCurrent(name) {
      this.currentPage = name;
      this.$set(this, 'typeName', '');
      this.$set(this, 'tip', true);
      this.$set(this, 'cate', false);
    },
    showTip() {
      this.$message.warning('暂不支持此操作');
    },
    cateNav() {
      this.currentPage = 'cate';
      this.$set(this, 'typeName', '');
      this.$set(this, 'cate', true);
      this.$set(this, 'mockGoods', false);
      this.getConfig();
    },
    switchTab(index) {
      this.active = index;
      if (this.active == 1) {
        this.cateImg = require('@/assets/imgs/moren.png');
      } else if (this.active == 2) {
        this.cateImg = require('@/assets/imgs/youxuan.png');
      } else if (this.active == 3) {
        this.cateImg = require('@/assets/imgs/haowu.png');
      } else if (this.active == 4) {
        this.cateImg = require('@/assets/imgs/shengxian.png');
      }
    },
    getConfig() {
      getDataApi().then((res) => {
        this.$set(this, 'active', res.categoryConfig);
        this.$set(this, 'radio', res.isShowCategory == 'true' ? true : false);
        this.switchTab(this.active);
      });
    },
    kindGet() {
      getTheme({ key: 'homePageSaleListStyle' }).then((res) => {
        let conque = res - 1;
        this.$set(this, 'active1', conque.toString());
        if (res == '1') {
          this.$set(this, 'mockGoodsImg', require('@/assets/theme/goodsList1.png')); //showTabNav
          this.$set(this, 'showTabNav', true);
        } else if (res == '2') {
          this.$set(this, 'mockGoodsImg', require('@/assets/theme/goodsList2.png'));
          this.$set(this, 'showTabNav', false);
        } else if (res == '3') {
          this.$set(this, 'mockGoodsImg', require('@/assets/theme/goodsList3.png'));
          this.$set(this, 'showTabNav', false);
        }
      });
    },
    //选择链接
    getLink(index) {
      this.itemIndex = index;
      this.$refs.linkaddres.dialogVisible = true;
    },
    //点击左侧菜单
    ProductNavTab(index) {
      this.listActive = index;
      //index=0,2显示首页，1显示个人中心
      if (index === 1) {
        this.showCurrent('user');
      } else {
        this.showCurrent('home');
      }
      //index=2,选中首页中的底部导航
      if (index === 2) {
        this.shows = 8;
        this.typeName = 'bottomNavigation';
      }
    },
    //选择链接弹窗回调获取链接地址
    linkUrl(e) {
      if (this.typeName == 'bottomNavigation') {
        this.navigationList[this.itemIndex].link = e;
      } else {
        this.menuList[this.itemIndex].url = e;
      }
    },
  },
};
</script>

<style scoped lang="scss">
.box-item {
  position: relative;
  display: flex;
  margin-top: 20px;
  padding: 20px 30px 20px 0;
  border: 1px dashed #ddd;
  border-radius: 3px;
  .del-box {
    position: absolute;
    right: -13px;
    top: -18px;
    cursor: pointer;
    .iconfont {
      color: #999;
      font-size: 30px;
    }
  }
  .left-tool {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 72px;
    .iconfont {
      color: #999;
      font-size: 36px;
      cursor: move;
    }
  }

  .right-wrapper {
    flex: 1;
    .img-wrapper {
      display: flex;
      .img-item {
        position: relative;
        width: 80px;
        height: 80px;
        margin-right: 20px;
        cursor: pointer;
      }
      img {
        display: block;
        width: 100%;
        height: 100%;
      }
      .empty-img {
        display: flex;
        align-items: center;
        justify-content: center;
        flex-direction: column;
        width: 100%;
        height: 100%;
        background: #f7f7f7;
        font-size: 12px;
        color: #bfbfbf;
        .iconfont {
          font-size: 16px;
        }
      }
      .txt {
        position: absolute;
        left: 0;
        bottom: 0;
        width: 100%;
        height: 22px;
        line-height: 22px;
        text-align: center;
        background: rgba(0, 0, 0, 0.4);
        color: #fff;
        font-size: 12px;
      }
    }
  }
  .c_row-item {
    margin-top: 10px;
  }
}
.page-fooot {
  display: flex;
  background: #fff;
  position: fixed;
  bottom: 0;
  width: 373px;
  .foot-item {
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    height: 50px;
    .el-image {
      width: 24px;
      height: 24px;
    }
    p {
      padding: 0;
      margin: 0;
      font-size: 12px;
      color: #282828;
      margin-top: 3px;
      &.on {
        color: #00a4f8;
      }
    }
  }
}
.mp-bg {
  position: absolute;
  left: 0;
  top: 49px;
  width: 100%;
  height: 152px;
  background: -webkit-linear-gradient(270deg, #e93323 0%, #f5f5f5 100%);
}
.ml3 {
  margin-left: 5px;
}
.shop {
  .go {
    width: 170px;
    height: 40px;
    line-height: 40px;
    background-color: #f6f6f6;
    padding: 0 8px;
    font-weight: 600;
    color: #333333;
    font-size: 15px;
  }
  .goTo {
    font-size: 12px;
    color: #000000;
  }
}
.shop-item {
  .pic {
    width: 170px;
    height: 170px;
    img {
      width: 100%;
      height: 100%;
    }
    .pic1 {
      border-radius: 8px 0px 0px 0px;
    }
    .pic2 {
      border-radius: 0px 8px 0px 0px;
    }
  }
}
::-webkit-scrollbar {
  display: none;
}
.flex {
  display: flex;
  flex-wrap: nowrap;
}
.justify-center {
  justify-content: center;
}
.justify-between {
  justify-content: space-between;
}
.align-center {
  align-items: center;
}
.iframe-box {
  width: 375px;
  height: 700px;
  border-radius: 4px;
  box-shadow: 0 0 7px #cccccc;
  margin-right: 50px;
}
.leftModel {
  width: 375px;
  height: 658px;
  border-radius: 4px;
  border: 1px solid #cccccc;
  margin: 30px 50px 0 0;
  background: #f5f5f5;
  margin-bottom: 27px;
  position: relative;
  overflow: auto;
  transform: rotate(360deg);
}
.current_home {
  width: 100%;
  height: 647px;
  overflow-y: scroll;
  padding-bottom: 50px;
}
.model_header {
  width: 100%;
  height: 50px;
  background: #e93323;
  display: flex;
  align-items: center;
  .logo {
    width: 69px;
    height: 24px;
    margin: 0 15px 0;
  }
  img {
    width: 69px;
    height: 24px;
  }
  .search {
    width: 275px;
    height: 32px;
    .search_input {
      width: 100%;
      height: 32px;
      background: #ffffff;
      border-radius: 17px;
      position: relative;
      .input_btn {
        position: absolute;
        top: 0;
        right: 0;
        width: 41px;
        height: 32px;
        background: #eeeeee;
        border-radius: 0px 17px 17px 0px;
        text-align: center;
        line-height: 32px;
        font-size: 14px;
        color: #999;
      }
    }
  }
  .open {
    width: 20px;
    height: 18px;
    color: #fff;
    font-size: 20px;
    margin: 0 18px 0 15px;
  }
}
.model_banner {
  padding: 0;
  box-sizing: border-box;
}
.banner_big {
  width: 375px;
  height: 375px;
}
.banner_small {
  width: 100%;
  /*height: 160px;*/
  margin: 0 auto;
  border-radius: 5px;
  overflow: hidden;
  margin-bottom: 12px;
  padding: 0 15px;
  img {
    border-radius: 5px;
    width: 100%;
    height: 100%;
  }
}

.model_nav {
  display: flex;
  justify-content: space-between;
  flex-wrap: wrap;
  padding: 0 15px 15px;
}
.model_nav_item {
  width: 78px;
  height: 74px;
  background: #ffffff;
  border-radius: 8px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  margin-top: 16px;
  img {
    width: 30px;
    height: 30px;
  }
  .menu_name {
    font-size: 12rx;
    font-family: PingFangSC-Regular, PingFang SC;
    font-weight: 400;
    color: #333333;
    padding-top: 8px;
  }
}

.tab_nav_bd {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 14px;
  white-space: nowrap;
  margin: 15px 0 15px;
  padding: 5px 15px 5px;
  border: 1px solid #f5f5f5;
  cursor: pointer;
}
.nav_bd_item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}
.item_txt {
  color: #282828;
}
.item_label {
  width: 62px;
  height: 16px;
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 2px;
  font-size: 12px;
  border-radius: 8px;
  color: #999;
}
.label_active {
  .item_txt {
    color: #e93323 !important;
  }
  .item_label {
    color: #fff;
    background: linear-gradient(90deg, #ff7931 0%, #e93323 100%);
  }
}
.cate_box_style {
  margin-top: 30px;
  width: 100%;
  font-size: 14px;
}
.shop_cart {
  opacity: 0.6;
}
.moni_goods {
  width: 100%;
  font-size: 20px;
  img {
    display: block;
    width: 100%;
  }
}
.user_head {
  width: 375px;
  height: 262px;
  background: linear-gradient(180deg, #e93323 0%, #f5f5f5 100%);
  cursor: not-allowed;
}
.user_card {
  position: relative;
  width: 100%;
  margin: 0 auto;
  padding: 17px 0 14px 0;
}
.user_info {
  display: flex;
}
.user_info img {
  width: 59px;
  height: 59px;
  border-radius: 50%;
}
.user_info .info {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  margin-left: 9px;
  padding: 7px 0;
}
.nick_name {
  color: #fff;
  font-size: 15px;
}
.phone {
  display: flex;
  align-items: center;
  padding: 3px 10px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 18px;
  font-size: 10px;
  color: #fff;
}
.num_wrapper {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 15px;
  height: 69px;
  color: #333;
  background-color: #fff;
  border-radius: 7px;
}
.num_wrap_item {
  width: 33.33%;
  text-align: center;
}
.num_item_bold {
  font-size: 20px;
  font-weight: bold;
}
.num_title {
  margin-top: 4px;
  font-size: 12px;
  color: #333;
}
.order_wrap {
  background-color: #fff;
  border-radius: 6px;
  padding: 14px 7px;
  width: 345px;
  height: 112px;
  margin: auto;
}
.order_wrap_tit {
  display: flex;
  justify-content: space-between;
  font-size: 14px;
  color: #282828;
  margin-bottom: 19px;
  padding: 0 7px;
}
.weight_600 {
  font-weight: 600;
}
.font_sm {
  font-size: 12px;
}
.order_wrap_list {
  display: flex;
  justify-content: space-between;
}
.order_list_item {
  width: 20%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}
.order_list_item img {
  width: 24px;
  display: block;
  margin-bottom: 7px;
}
.order_list_item p {
  font-size: 13px;
  color: gray；;
}
.slider_img {
  margin: 10px auto;
  background-color: #fff;
  border-radius: 6px;
  border: 1px solid #f5f5f5;
  width: 345px;
  height: 69px;
}
.user_mens {
  margin: 0 auto;
  background-color: #fff;
  border: 1px solid #fff;
  border-radius: 6px;
  width: 345px;
  height: 200px;
  padding: 0 15px 0;
  overflow: auto;
}
.menu_title {
  padding: 15px 0 10px;
  font-size: 15px;
  color: #282828;
  font-weight: 600;
}
.list_box {
  display: flex;
  flex-wrap: wrap;
}
.list_box_item {
  height: 50px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  img {
    width: 22px;
    height: 22px;
  }
  border-bottom: 1px solid #f5f5f5;
  .list_item_title {
    color: #333;
    font-size: 28rpx;
  }
}
.user_bg {
  width: 100%;
  height: 208px;
  background-repeat: no-repeat;
  background-size: cover;
  padding: 0 15px 0;
}

.move-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 30px;
  height: 80px;
  cursor: move;
  color: #d8d8d8;
  .icondrag2 {
    font-size: 25px;
    cursor: move;
  }
}
.select_ctive {
  border: 1px dashed #666;
  box-sizing: border-box;
}
.upLoad {
  width: 58px;
  height: 58px;
  line-height: 58px;
  border: 1px dotted rgba(0, 0, 0, 0.1);
  border-radius: 4px;
  background: rgba(0, 0, 0, 0.02);
  display: flex;
  justify-content: center;
  align-items: center;
}
.flex_between {
  flex: 1;
  display: flex;
  justify-content: space-between;
  position: relative;
}
.tip {
  width: 100%;
  text-align: center;
  font-size: 24px;
  text-align: center;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}
.right-box {
  width: 70%;
  min-width: 400px;
  border-radius: 4px;
  height: 700px;
  overflow-y: scroll;
  padding: 0 10px;
  margin-top: 30px;
  &::-webkit-scrollbar {
    /*滚动条整体样式*/
    width: 4px; /*高宽分别对应横竖滚动条的尺寸*/
    height: 1px;
  }
  &::-webkit-scrollbar-thumb {
    /*滚动条里面小方块*/
    border-radius: 4px;
    box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.2);
    background: #535353;
  }
  &::-webkit-scrollbar-track {
    /*滚动条里面轨道*/
    box-shadow: inset 0 0 5px #fff;
    border-radius: 4px;
    background: #fff;
  }
}

.title-bar {
  width: 100%;
  height: 38px;
  line-height: 38px;
  padding-left: 10px;
  color: #303133;
  font-size: 16px;
  font-weight: 600;
  position: relative;
  &::before {
    content: '';
    position: absolute;
    left: 0;
    top: 10px;
    width: 2px;
    height: 16px;
    background: #1890ff;
  }
}

.mobile-config {
  padding: 0 15px 20px 0px;
  .item {
    position: relative;
    display: flex;
    margin-top: 20px;
    border: 1px dashed #ddd;
    padding: 15px 15px 0 0;
  }
  .picBox {
    cursor: pointer;
    position: relative;
  }
  .img-box {
    width: 70px;
    height: 70px;
    border-radius: 50%;
    img {
      width: 100%;
    }
  }
}
.delect-btn {
  position: absolute;
  right: -12px;
  top: -16px;
  color: #999999;
  z-index: 11;
  .el-icon-circle-close {
    font-size: 21px;
    color: #999;
    cursor: pointer;
  }
}
.info {
  flex: 1;
  margin-left: 12px;
  .info-item {
    display: flex;
    align-items: center;
    margin-bottom: 10px;
  }
  span {
    width: 40px;
    font-size: 13px;
  }
  .input-box {
    flex: 1;
  }
}
.cur_pointer {
  cursor: pointer;
}
.link-item {
  padding: 10px 0;
  border-bottom: 1px solid #f5f5f5;
  .title {
    font-size: 14px;
    color: #2d8cf0;
  }
  .txt {
    margin: 5px 0;
    font-size: 12px;
    span {
      color: #333;
    }
    p {
      display: inline-block;
      color: #19be6b;
      margin-right: 10px;
      span {
        color: #333;
      }
      &.red {
        color: #f00;
      }
    }
  }
  .tips {
    font-size: 12px;
    color: #999;
    .copy {
      padding: 3px 5px;
      border: 1px solid #cccccc;
      border-radius: 5px;
      color: #333;
      cursor: pointer;
      margin-left: 5px;
      &:hover {
        border-color: #2d8cf0;
        color: #2d8cf0;
      }
    }
  }
}
.on {
  border: 1px solid #1db0fc;
}
.image {
  width: 100%;
  display: block;
}
// .card_cate{
//   border:2px solid #e6ebf5;
// }
.card_bt {
  padding: 14px;
  background: #f5f5f5;
  display: flex;
  justify-content: center;
  span {
    font-size: 18px;
    font-weight: 600;
  }
}
.tab_view {
  width: 200px;
  border-right: 1px solid #eee;
  margin-right: 40px;
  display: flex;
  flex-direction: column;
  .cell_item {
    height: 50px;
    font-size: 14px;
    line-height: 50px;
    text-align: left;
    padding-left: 30px;
    cursor: pointer;
  }
}
.tab_active {
  background: #f6fbff;
  color: #1890ff;
  border-right: 1px solid #1890ff;
}
.footer_btn {
  border-top: 1px solid #eee;
  height: 50px;
  display: flex;
  justify-content: center;
  align-items: center;
}
</style>
