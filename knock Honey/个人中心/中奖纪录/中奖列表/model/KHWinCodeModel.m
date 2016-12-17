//
//  KHWinCodeModel.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/9.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHWinCodeModel.h"
#import <MJExtension/MJExtension.h>

@implementation KHWinCodeModel

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
        KHWinCodeModel *model = [KHWinCodeModel kh_objectWithKeyValues:dict];
        [result addObject:model];
    }
    return result;
}

@end
