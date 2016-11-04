//
//  DistrictModel.m
//  iLight
//
//  Created by Apple on 15/5/22.
//  Copyright (c) 2015年 linitial. All rights reserved.
//

#import "DistrictModel.h"
#import "StreetModel.h"

@interface DistrictModel ()


@end

@implementation DistrictModel

- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.DistrictCode = [dic objectForKey:@"DistrictCode"];
        self.DistrictId = [dic objectForKey:@"DistrictId"];
        self.DistrictPinyin = [dic objectForKey:@"DistrictPinyin"];
        self.DistrictName = [dic objectForKey:@"DistrictName"];
        NSArray *streetArr = (NSArray *)[dic objectForKey:@"StreetList"];
        if (streetArr.count>0) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [streetArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    StreetModel *model = [[StreetModel alloc]initWithDictionary:obj];
                    [self.streetArr addObject:model];
                }];
            });
        }
    }
    return self;
}

- (NSMutableArray *)streetArr {
    if (!_streetArr) {
        _streetArr = [NSMutableArray array];
    }
    return _streetArr;
}

@end
