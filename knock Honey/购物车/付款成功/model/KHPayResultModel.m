//
//  KHPayResultModel.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/10.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHPayResultModel.h"
#import <MJExtension.h>
#import "KHresultGoods.h"

@implementation KHPayResultModel
+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict{
    KHPayResultModel *model = [KHPayResultModel mj_objectWithKeyValues:dict];
    model.goods = [KHresultGoods mj_objectArrayWithKeyValuesArray:dict[@"goods"]];
    return model;
}
@end
