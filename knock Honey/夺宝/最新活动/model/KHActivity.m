//
//  KHActivity.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/12/8.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHActivity.h"
#import <MJExtension.h>

@implementation KHActivity
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
        KHActivity *model = [self kh_objectWithKeyValues:dict];
        [result addObject:model];
    }
    return result;
}
@end
