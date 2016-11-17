              //
//  KHSnatchModel.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/14.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHSnatchModel.h"
#import <MJExtension.h>

@implementation KHSnatchModel

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
        KHSnatchModel *model = [self kh_objectWithKeyValues:dict];
        if (model.isopen.integerValue == 1) {
             model.lottery = [KHSnatchWinModel mj_objectWithKeyValues:dict[@"lottery"]];
        }
        [result addObject:model];
    }
    return result;
}
@end
