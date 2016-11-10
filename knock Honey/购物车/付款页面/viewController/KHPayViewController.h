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


@interface KHPayViewController : KHBaseViewController


@property (nonatomic,strong) KHPayModel *payModel;

@property (nonatomic,assign) KHPayTotalType payType;


@end
