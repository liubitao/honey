//
//  KHProductModel.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/12.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHProductModel.h"
#import <MJExtension/MJExtension.h>

@implementation KHProductModel

+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict{
    KHProductModel *model = [self mj_objectWithKeyValues:dict];
    model.winner = [KHWinner mj_objectWithKeyValues:dict[@"winner"]];
    return model;
}


@end
