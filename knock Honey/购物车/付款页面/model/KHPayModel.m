//
//  KHPayModel.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/9.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHPayModel.h"
#import <MJExtension.h>

@implementation KHPayModel
+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict{
    KHPayModel *model = [KHPayModel mj_objectWithKeyValues:dict];
    model.goods = [KHPauGoodsModel kh_objectWithKeyValuesArray:dict[@"goods"]];
    return model;
}


@end
