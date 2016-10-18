//
//  KHIMage.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/18.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHIMage.h"
#import <MJExtension/MJExtension.h>
@implementation KHIMage
MJCodingImplementation

+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array{
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        KHIMage *model = [self mj_objectWithKeyValues:dict];
        [result addObject:model];
    }
    return result;
}
@end
