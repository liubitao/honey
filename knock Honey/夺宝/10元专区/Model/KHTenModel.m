//
//  KHTenModel.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/13.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHTenModel.h"
#import <MJExtension/MJExtension.h>

@implementation KHTenModel

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
        KHTenModel *model = [self kh_objectWithKeyValues:dict];
        [result addObject:model];
    }
    return result;
}

@end
