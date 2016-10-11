//
//  KHHomeModel.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/11.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHHomeModel.h"

@implementation KHHomeModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.productImgUrl = @"http://onegoods.nosdn.127.net/goods/1093/5095bc4b3f4228b69d6b58acf67cae1c.jpg";
        self.productName = @"Apple iPhone6s Plus 128G 颜色随机";
        self.publishProgress = [NSString stringWithFormat:@"%@",@(arc4random() % 99)];
        self.isAdded = NO;
    }
    return self;
}
- (NSMutableArray *)adImgUrls {
    if (!_adImgUrls) {
        _adImgUrls = [NSMutableArray array];
    }
    return _adImgUrls;
}


@end
