//
//  KHTenModel.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/13.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHTenModel.h"

@implementation KHTenModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.productImgUrl = @"https://tse4-mm.cn.bing.net/th?id=OIP.M9271c634f71d813901afbc9e69602dcfo2&pid=15.1";
        self.productName = @"斯嘉丽·约翰逊(Scarlett Johansson),1984年11月22日生于纽约，美国女演员。";
        self.totalAmount = @5288;
        self.leftAmount = @(arc4random() % 5287);
        self.publishProgress =  @([self.leftAmount integerValue]*1.0/[self.totalAmount integerValue]*100.0);
        self.isSelected = NO;
    }
    return self;
}
@end
