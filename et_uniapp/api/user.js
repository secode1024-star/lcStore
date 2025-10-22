// +----------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +----------------------------------------------------------------------
// | Copyright (c)  https://www.crmeb.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +----------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +----------------------------------------------------------------------

import request from "@/utils/request.js";
import Cache from "@/utils/cache.js"

/**
 * 获取登录方式信息
 * @param data object 
 */
export function loginMethodInfo(data) {
  return request.get("login/method/info", data, { noAuth : true });
}

/**
 * 邮箱注册登录
 * @param data object 
 */
export function registerEmail(data) {
  return request.post("login/register/email", data, { noAuth : true });
}

/**
 * 邮箱验证码
 * @param data object 
 */
export function emailCaptcha(data) {
  return request.post("login/email/captcha", data, { noAuth : true });
}

/**
 * 发送邮箱忘记密码验证码
 * @param data object 
 */
export function emailForgetCode(data) {
  return request.post("login/email/forget/password", data, { noAuth : true });
}

/**
 * 邮箱忘记密码
 * @param data object 
 */
export function emailResetPassword(data) {
  return request.post("login/email/reset/password", data, { noAuth : true });
}

/**
 * 获取用户信息
 * 
*/
export function getUserInfo(){
  return request.get('user/info');
}


/**
 * 邮箱登录
 * @param data object 用户账号密码
 */
export function loginEmail(data) {
  return request.post("login/email", data, { noAuth : true });
}

/**
 * facebook登录
 * @param data object 
 */
export function loginFacebook(data) {
  return request.post("login/facebook", data, { noAuth : true });
}

/**
 * twitter登录
 * @param data object 
 */
export function twitterToken(data) {
  return request.get("login/twitter/request/token?end=h5", data, { noAuth : true });
}

/**
 * twitter登录
 * @param data object 
 */
export function loginTwitter(data) {
  return request.post("login/twitter", data, { noAuth : true });
}

/**
 * google登录
 * @param data object 
 */
export function loginGoogle(data) {
  return request.post("login/google", data, { noAuth : true });
}

/**
 * h5用户手机号密码登录
 * @param data object 
 */
export function mobilePassword(data) {
  return request.post("login/mobile/password", data, { noAuth : true });
}

/**
 * h5用户手机号验证码登录
 * @param data object 
 */
export function mobileCaptcha(data) {
  return request.post("login/mobile/captcha", data, { noAuth : true });
}

/**
 * h5用户手机号注册登录
 * @param data object 
 */
export function registerMobile(data) {
  return request.post("login/register/mobile", data, { noAuth : true });
}

/**
 * h5用户发送验证码
 * @param data object 用户手机号
 */
export function registerVerify(data){
  return request.post('login/sendCode', data,{noAuth:true},1)
}

/**
 * 邮箱修改密码验证码
 * @param data object 
 */
export function emailCaptcheReset(data) {
  return request.post("captcha/email/password", data, { noAuth : true });
}

/**
 * 手机号修改密码验证码
 * @param data object 
 */
export function phoneCaptcheReset(data) {
  return request.post("captcha/phone/password", data, { noAuth : true });
}

/**
 * 根据用户Ip获取地址信息
 */
export function addressIpInfo(){
  return request.post('address/ip/info')
}

/**
 * 游客登录注册
 */
export function loginVisor(data){
  return request.post('login/register/visitor',data, { noAuth : true })
}

/**
 * 用户手机号修改密码
 * @param data object 用户手机号 验证码 密码
 */
export function phoneUpdatePassword(data) {
  return request.post("user/phone/update/password", data, { noAuth: true });
}

/**
 * 用户邮箱修改密码
 * @param data object 用户邮箱 验证码 密码
 */
export function emailUpdatePassword(data) {
  return request.post("user/email/update/password", data, { noAuth: true });
}

/**
 * 获取用户中心菜单
 *
 */
export function getMenuList() {
  return request.get("user/menu/user");
}

/**
 * 活动状态
 * 
*/
export function userActivity(){
  return request.get('user/activity');
}

/**
 * 获取分销海报图片
 * 
*/
export function spreadBanner(data){
	return request.get('user/spread/banner',data);
}

/**
 *
 * 获取推广用户一级和二级
 * @param object data
*/
export function spreadPeople(data){
  return request.get('spread/people',data);
}

/**
 * 
 * 推广佣金/提现总和
 * @param int type
*/
export function spreadCount(type){
  return request.get('spread/count/'+type);
}

/*
 * 推广数据 当前佣金 提现总金额
 * */
export function getSpreadInfo() {
  return request.get("commission");
}


/**
 * 
 * 推广订单
 * @param object data
*/
export function spreadOrder(data){
  return request.get('spread/order',data);
}

/*
 * 获取推广人排行
 * */
export function getRankList(q) {
  return request.get("rank", q);
}

/*
 * 获取佣金排名
 * */
export function getBrokerageRank(q) {
  return request.get("brokerage_rank", q);
}

/**
 * 提现申请
 * @param object data
*/
export function extractCash(data){
  return request.post('extract/cash',data)
}

/**
 * 提现银行/提现最低金额
 * 
*/
export function extractBank(){
  return request.get('extract/bank');
}

/**
 * 会员等级列表
 * 
*/
export function userLevelGrade(){
  return request.get('user/level/grade');
}

/**
 * 获取某个等级任务
 * @param int id 任务id
*/
export function userLevelTask(id){
  return request.get('user/level/task/'+id);
}

/**
 * 检查用户是否可以成为会员
 * 
*/
export function userLevelDetection(){
  return request.get('user/level/detection');
}

/**
 * 
 * 地址列表
 * @param object data
*/
export function getAddressList(data){
  return request.get('address/list',data);
}

/**
 * 设置默认地址
 * @param int id
*/
export function setAddressDefault(id){
  return request.post('address/default/set',{id:id})
}

/**
 * 修改 添加地址
 * @param object data
*/
export function editAddress(data){
  return request.post('address/edit',data);
}

/**
 * 删除地址
 * @param int id
 * 
*/
export function delAddress(id){
  return request.post('address/del',{id:id})
}

/**
 * 获取单个地址
 * @param int id 
*/
export function getAddressDetail(id){
  return request.get('address/detail/'+id);
}

/**
 * 修改用户信息
 * @param object
*/
export function userEdit(data){
  return request.post('user/edit',data);
}

/*
 * 退出登录
 * */
export function getLogout() {
  return request.get("login/logout");
}
/**
 * 小程序充值
 * 
*/
export function rechargeRoutine(data){
  return request.post('recharge/routine',data)
}
/*
 * 公众号充值
 * */
export function rechargeWechat(data) {
  return request.post("recharge/wechat", data);
}

/*
 * app微信充值
 * */
export function appWechat(data) {
  return request.post("recharge/wechat/app", data);
}

/*
 * 余额充值
 * */
export function transferIn(data) {
  return request.post("recharge/transferIn", data,{},1);
}

/*
 * 支付宝充值
 * */
export function alipayFull(data) {
  return request.post("recharge/alipay", data,{});
}

/**
 * 获取默认地址
 * 
*/
export function getAddressDefault(){
  return request.get('address/default');
}

/**
 * 充值金额选择
 */
export function getRechargeApi() {
  return request.get("recharge/index");
}

/**
 * 登录记录
 */
export function setVisit(data)
{
  return request.post('user/set_visit', {...data}, { noAuth:true});
}

/**
 * 客服列表
 */
export function serviceList() {
  return request.get("user/service/lst");
}
/**
 * 客服详情
 */
export function getChatRecord(to_uid, data) {
  return request.get("user/service/record/" + to_uid, data);
}

/**
 * 静默绑定推广人
 * @param {Object} puid
 */
export function spread(puid)
{
	return request.get("user/bindSpread?spreadPid="+ puid);
}

/**
 * 当前用户在佣金排行第几名
 * 
 */
export function brokerageRankNumber(data)
{
	return request.get("user/brokerageRankNumber",data);
}

/**
 * 会员等级经验值；
 * 
 */
export function getlevelInfo()
{
	return request.get("user/level/grade");
}

/**
 * 经验值明细；
 * 
 */
export function getlevelExpList(data)
{
	return request.get("user/expList",data);
}

/**
 * 经验值明细；
 * 
 */
export function getuserDalance()
{
	return request.get("user/balance");
}

/**
 * 账单记录；
 * 
 */
export function getBillList(data)
{
	return request.get("recharge/bill/record",data);
}

/*
 * 积分中心详情
 * */
export function postIntegralUser() {
  return request.get("user/integral");
}

/*
 * 立即提现 冻结期、冻结佣金、可提现佣金、最低可提现金额
 * */
export function extractUser() {
  return request.get("extract/user");
}

/*
 * 推广人统计页 推广人数（一级+二级）、一级人数、二级人数
 * */
export function spreadPeoCount() {
  return request.get("spread/people/count");
}

