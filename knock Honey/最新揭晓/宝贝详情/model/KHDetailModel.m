//
//  KHDetailModel.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/12.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHDetailModel.h"
#import <MJExtension.h>

@implementation KHDetailModel
MJCodingImplementation

+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array{
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        KHDetailModel *model = [self mj_objectWithKeyValues:dict];
        [result addObject:model];
    }
    return result;
}


@end
