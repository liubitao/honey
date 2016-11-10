//
//  KHCartGoodsModel.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/10/28.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHCartGoodsModel.h"
#import <MJExtension.h>

@implementation KHCartGoodsModel

+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict{
    [self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID":@"id"
                 };
    }];
    return [self mj_objectWithKeyValues:dict];
}
@end
