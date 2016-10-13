//
//  KHProductModel.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/12.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHProductModel.h"

@implementation KHProductModel

- (NSMutableArray *)imgUrls {
    if (!_imgUrls) {
        _imgUrls = [NSMutableArray array];
    }
    return _imgUrls;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end
