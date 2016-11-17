//
//  KHCoupon.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/11.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHCoupon.h"
#import <MJExtension.h>

@implementation KHCoupon

+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict{
    [self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID":@"id"
                 };
    }];
    return [self mj_objectWithKeyValues:dict];
}

+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array{
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        KHCoupon *coupon = [KHCoupon kh_objectWithKeyValues:dict];
        [mutableArray addObject:coupon];
    }
    return mutableArray;
}
@end
