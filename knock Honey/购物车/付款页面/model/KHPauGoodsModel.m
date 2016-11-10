//
//  KHPauGoodsModel.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/9.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHPauGoodsModel.h"
#import <MJExtension.h>

@implementation KHPauGoodsModel
+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict{
    [self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"gid":@"id"
                 };
    }];
    return [self mj_objectWithKeyValues:dict];
}

+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array{
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        KHPauGoodsModel *model = [self kh_objectWithKeyValues:dict];
        [result addObject:model];
    }
    return result;
}
@end
