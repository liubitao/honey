//
//  KHPayViewController.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/8.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHBaseViewController.h"
#import "KHPayModel.h"

typedef NS_ENUM(NSUInteger, KHPayTotalType) {
    KHPayTypeCanPay = 0, //可支付
    KHPayTypeAddPay, //有余额
    KHPayTypeNoPay, //没余额
};

typedef NS_ENUM(NSUInteger, KHPayHybridType) {
    KHPayTypeYuePay = 0, //只是余额
    KHPayTypeWeixinPay, //只是微信
    KHPayTypeAliPay, //只是支付宝
    KHPayTypeYueWeixinPay, //余额和微信
    KHPayTypeYueAliPay, //余额和支付宝
};



@interface KHPayViewController : KHBaseViewController


@property (nonatomic,strong) KHPayModel *payModel;

@property (nonatomic,assign) KHPayTotalType payType;

@property (nonatomic,assign) KHPayHybridType hybridType;



@end
