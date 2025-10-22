// +----------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2016~2023 https://www.crmeb.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +----------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +----------------------------------------------------------------------

import { Message, MessageBox } from "element-ui";

/**
 * 去商品详情
 */
export function goShopDetail(id, self) {
  self.$router.push({ path: "/goods_detail/" + id });
}

/**
 * 去店铺
 */
export function goMerchant(id, self) {
  self.$router.push({ path: "/merchant/merchant/home?id=" + id });
}

/**
 * 活动商品、普通商品、购物车、再次购买预下单
 */
export function getPreOrder(preOrderType, orderDetails, self) {
  return new Promise((resolve, reject) => {
    self.$axios
      .post(`/api/front/order/pre/order`, {
        preOrderType: preOrderType,
        orderDetails: orderDetails,
      })
      .then((res) => {
        self.$router.push({
          path: `/order/order_confirm?preOrderNo=${res.data.preOrderNo}`,
        });
      });
  });
}

/**
 * 取消订单
 */
export function cancelOrders(self, orderNo) {
  return new Promise((resolve, reject) => {
    MessageBox.confirm(
      self.$t(`page.orderDetails.confirmCancel`),
      self.$t(`message.login.prompt`)
    ).then((res) => {
      self.$axios.post("/api/front/order/cancel/" + orderNo).then((data) => {
        resolve(res);
        return Message.success(self.$t(`message.login.calSU`));
      });
    });
  });
}

/**
 * 删除订单
 */
export function delOrders(self, orderNo) {
  return new Promise((resolve, reject) => {
    MessageBox.confirm(
      self.$t(`page.orderDetails.confirmDel`),
      self.$t(`message.login.prompt`)
    ).then((res) => {
      self.$axios.post("/api/front/order/delete/" + orderNo).then((data) => {
        resolve(res);
        return Message.success(self.$t(`message.login.delSU`));
      });
    });
  });
}

/**
 * 待支付订单去付款
 */
export function goPay(self, item) {
  console.log(item);
  return new Promise((resolve, reject) => {
    MessageBox.confirm(
      self.$t(`message.tips.surePay`),
      self.$t(`message.login.prompt`)
    ).then((r) => {
      if (item.payType === "paypal") {
        window.location.href = item.redirect;
      } else {
        self.$axios
          .post("/api/front/pay/payment", {
            orderNo: item.orderNo,
            payType: item.payType,
            payChannel: "pc",
          })
          .then((res) => {
            if (item.payType === "stripe") {
              self.$router.push({
                path: `/order/stripe_payment`,
                query: { clientSecret: res.data.stripeClientSecret },
              });
            } else {
              resolve(res);
            }
          });
      }
    });
  });
}

/**
 * 关注、取消关注商品
 */
export function followPro(self, follow, id) {
  return new Promise((resolve, reject) => {
    if (!follow) {
      self.$axios
        .post("/api/front/collect/add/product", {
          id: id,
          category: "store",
        })
        .then((res) => {
          resolve(res);
        });
    } else {
      self.$axios.post(`/api/front/collect/cancel/${id}`).then((res) => {
        resolve(res);
      });
    }
  });
}

/**
 * 关注、取消关注店铺
 */
export function followMer(self, follow, id) {
  return new Promise((resolve, reject) => {
    if (!follow) {
      self.$axios.post(`/api/front/collect/add/merchant/${id}`).then((res) => {
        resolve(res);
      });
    } else {
      self.$axios
        .post(`/api/front/collect/cancel/merchant/${id}`)
        .then((res) => {
          resolve(res);
        });
    }
  });
}

/**
 *获取所在地
 */
export function getIpInfo(self) {
  return new Promise((resolve, reject) => {
    self.$axios.post("/api/front/address/ip/info").then((res) => {
      resolve(res);
    });
  });
}
