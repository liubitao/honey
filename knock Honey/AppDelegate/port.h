//
//  port.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/17.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#ifndef port_h
#define port_h
//a6e391fec0c6c459b66dcef77d39ce83
//1.skey

//QQ   APP ID  1105806530     APP KEY  LpnWofBiKeDb0aqA
//weixin  AppID：wx1bf9134fbd335945 Appsecret：50d04908bedb1ba715cb352c814efc81
//weibo   App Key：1110923628    App Secret： 8b321089624280ee25e1590fa6eca739

#define UMsocialAppKey      @"582167c9aed17960b30009d4"

#define UMQQAppID           @"1105806530"
#define UMQQAppKey          @"LpnWofBiKeDb0aqA"

#define UMWeixinAppID       @"wx1bf9134fbd335945"
#define UMWeixinAPPsecret   @"50d04908bedb1ba715cb352c814efc81"

#define UMWeiboAppKey       @"1110923628"
#define UMWeiboAppsecret    @"8b321089624280ee25e1590fa6eca739"
#define UMWeiboUrl          @"http://sns.whalecloud.com/sina2/callback"
#define sKey        @"bf9024c8e834146606c7f364e73f743a"
#define mKey        @"oneshopgoods"
//#define portPic     @"http://"
//#define PortCartPic @"http://oneshop.zhongwenyu1987.com"

//1.万能接口
#define PortUniversal_api @"http://oneshop.zhongwenyu1987.com/index.php/Api/Index/universal_api"

//2.商品列表
#define PortGoodslist   @"http://oneshop.zhongwenyu1987.com/index.php/Api/Goods/goodslist"

//3.商品详情
#define PortGoodsdetails @"http://oneshop.zhongwenyu1987.com/index.php/Api/Goods/goodsdetail"

//4.最新揭晓列表
#define PortGoodszxjx    @"http://oneshop.zhongwenyu1987.com/index.php/Api/Goods/goodszxjx"

//5.app首页
#define PortGoodsIndex  @"http://oneshop.zhongwenyu1987.com/index.php/Api/Index/index"

//6.购买记录
#define PortGoodsOrder  @"http://oneshop.zhongwenyu1987.com/index.php/Api/goods/goodsorder"

//7.十元专区
#define PortGoodsarea   @"http://oneshop.zhongwenyu1987.com/index.php/api/goods/goodsarea"

//8.会员登录
#define PortLogin       @"http://oneshop.zhongwenyu1987.com/index.php/api/User/login"

//9.加入购物车
#define PortAddCart     @"http://oneshop.zhongwenyu1987.com/index.php/api/Cart/addCart"

//10.查看购物车
#define PortIndex       @"http://oneshop.zhongwenyu1987.com/index.php/api/Cart/index"

//11.会员充值=====
#define PortRecharge    @"http://oneshop.zhongwenyu1987.com/index.php/api/User/recharge"

//12.会员充值处理=====
#define PortRecharge_handle @"http://oneshop.zhongwenyu1987.com/index.php/api/User/recharge_handle"

//13.订单提交
#define PortOrder_submit    @"http://oneshop.zhongwenyu1987.com/index.php/api/Cart/order_submit"

//14.订单支付
#define PortOrder_pay       @"http://oneshop.zhongwenyu1987.com/index.php/api/Cart/order_pay"

//15.购物车批量变更
#define PortCart_change     @"http://oneshop.zhongwenyu1987.com/index.php/api/Cart/cart_change"

//16.地址列表
#define PortAddress_list    @"http://oneshop.zhongwenyu1987.com/index.php/api/User/address_list"

//17.第三方登录
#define PortThird_login   @"http://oneshop.zhongwenyu1987.com/index.php/api/User/third_login"

//18.添加编辑地址处理
#define PortAddress_handle  @"http://oneshop.zhongwenyu1987.com/index.php/api/User/address_handle"

//19.夺宝纪录=====
#define PortOrder_list      @"http://oneshop.zhongwenyu1987.com/index.php/api/User/order_list"

//20.中奖纪录
#define PortWin_list        @"http://oneshop.zhongwenyu1987.com/index.php/api/User/win_list"

//21.红包列表
#define PortCoupon_list     @"http://oneshop.zhongwenyu1987.com/index.php/api/User/coupon_list"

//22.消息中心=====
#define PortMessage_count   @"http://oneshop.zhongwenyu1987.com/index.php/api/User/message_count"

//23.消息列表=====
#define PortMessage_list    @"http://oneshop.zhongwenyu1987.com/index.php/api/User/message_list"

//24.晒单列表
#define PortComment_list    @"http://oneshop.zhongwenyu1987.com/index.php/api/User/comment_list"

//25.晒单详情
#define PortComment_detail  @"http://oneshop.zhongwenyu1987.com/index.php/api/User/comment_detail"

//26.计算详情=====
#define PortFormula         @"http://oneshop.zhongwenyu1987.com/index.php/api/Goods/formula"

//27.签到页面=====
#define PortSign_index      @"http://oneshop.zhongwenyu1987.com/index.php/api/User/sign_index"

//28.每日签到=====
#define PortMember_sign     @"http://oneshop.zhongwenyu1987.com/index.php/api/User/member_sign"

//29.免费抢币=====
#define PortScore_coupon    @"http://oneshop.zhongwenyu1987.com/index.php/api/User/score_coupon"

//30.积分兑换红包=====
#define PortScore_coupon_handle @"http://oneshop.zhongwenyu1987.com/index.php/api/User/score_coupon_handle"

//31.积分明细=====
#define PortScore_record       @"http://oneshop.zhongwenyu1987.com/index.php/api/User/score_record"

//32.移除购物车
#define PortCart_del           @"http://oneshop.zhongwenyu1987.com/index.php/api/Cart/cart_del"

//33.删除地址
#define PortDel_address         @"http://oneshop.zhongwenyu1987.com/index.php/api/User/del_address"

//34.评论点赞
#define PortComment_support     @"http://oneshop.zhongwenyu1987.com/index.php/api/User/comment_support"
#endif /* port_h */
