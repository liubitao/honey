//
//  KHcartModel.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/20.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHcartModel.h"

@implementation KHcartModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imgUrl = @"http://onegoods.nosdn.127.net/goods/1093/5095bc4b3f4228b69d6b58acf67cae1c.jpg";
        self.name = @"iPhone 6s 64G 玫瑰金 玫瑰金玫瑰金玫瑰金玫瑰金玫瑰金玫瑰金金";
        self.totalAmount = @"6400";
        self.leftAmount = @"300";
        self.selectCount = @6;
        self.isChecked = NO;
        self.unitCost = @1;
    }
    return self;
}


@end
