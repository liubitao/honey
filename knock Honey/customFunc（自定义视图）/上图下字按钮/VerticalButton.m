//
//  VerticalButton.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/11.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "VerticalButton.h"

@implementation VerticalButton

- (void)setImage:(UIImage *)image
           title:(NSString *)title
        forState:(UIControlState)state {
    [self setImage:image forState:state];
    [self setTitle:title forState:state];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    //调整图片(imageView)的位置和尺寸
    CGPoint center = self.imageView.center;
    center.x = self.width/2;
    center.y = self.imageView.height/2+15;
    self.imageView.center = center;
    
    //调整文字(titleLable)的位置和尺寸
    CGRect newFrame = self.titleLabel.frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.imageView.height;
    
    newFrame.size.width = self.width;
    newFrame.size.height = self.height - self.imageView.height;
    
    self.titleLabel.frame = newFrame;
    
    //让文字居中
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}


@end
