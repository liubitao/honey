//
//  KHHomeModel.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/11.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHHomeModel.h"
#import <MJExtension/MJExtension.h>


@implementation KHHomeModel

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
         KHHomeModel *model = [self kh_objectWithKeyValues:dict];
        [result addObject:model];
        }
    return result;
}

@end
