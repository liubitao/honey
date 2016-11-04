//
//  KHAddressModel.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/3.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHAddressModel.h"
#import <MJExtension.h>

@implementation KHAddressModel
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
        KHAddressModel *model = [self kh_objectWithKeyValues:dict];
        [result addObject:model];
    }
    return result;
}
@end
