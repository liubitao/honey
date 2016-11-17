//
//  KHFreeModel.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/11.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHFreeModel.h"
#import <MJExtension.h>

@implementation KHFreeModel
+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict;{
    KHFreeModel *model = [KHFreeModel mj_objectWithKeyValues:dict];
    model.coupons = [KHCoupon kh_objectWithKeyValuesArray:dict[@"coupon"]];
    return model;
}
@end
