//
//  KHWantButton.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/24.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHWantButton.h"

@implementation KHWantButton

- (void)layoutSubviews {
    [super layoutSubviews];

    //调整图片(imageView)的位置和尺寸
    CGPoint center = self.imageView.center;
    center.x = self.width/2;
    center.y = self.imageView.height/2;
    self.imageView.center = center;
    self.imageView.size = CGSizeMake(self.height, self.height);
//
//    //调整图片(imageView)的位置和尺寸
//    
//    self.imageView.width = self.height;
//    self.imageView.height = self.height;
//    
//    self.imageView.center = self.center;
}


@end
