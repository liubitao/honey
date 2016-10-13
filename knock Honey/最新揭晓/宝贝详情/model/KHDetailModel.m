//
//  KHDetailModel.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/12.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHDetailModel.h"

@implementation KHDetailModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imgUrl = @"https://tse4-mm.cn.bing.net/th?id=OIP.M9271c634f71d813901afbc9e69602dcfo2&pid=15.1";
        self.nickname = @"中奖怎么了";
        self.ipAddress = @"(浙江杭州：1.1.1.1)";
        self.partInTimes = @5;
        self.time = @"2016-05-18 14:15:16";
    }
    return self;
}

@end
