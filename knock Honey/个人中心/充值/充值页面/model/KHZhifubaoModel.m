//
//  KHZhifubaoModel.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/21.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHZhifubaoModel.h"
#import <MJExtension.h>

@implementation KHZhifubaoModel
+ (instancetype)kh_objectWithKeyValues:(id)dict{
    KHZhifubaoModel *model = [KHZhifubaoModel mj_objectWithKeyValues:dict];
    model.response = [KHResponseModel mj_objectWithKeyValues:dict[@"alipay_trade_app_pay_response"]];
    return model;
}
@end
