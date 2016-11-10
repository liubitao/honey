//
//  KHcartModel.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/20.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHcartModel.h"
#import <MJExtension.h>

@implementation KHcartModel

+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict{
    [self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID":@"id"
                 };
    }];
    return [self mj_objectWithKeyValues:dict];
}

+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array{
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        KHcartModel *model = [self kh_objectWithKeyValues:dict];
        model.goods = [KHCartGoodsModel kh_objectWithKeyValues:dict[@"goods"]];
        [result addObject:model];
    }
    return result;
}

@end
