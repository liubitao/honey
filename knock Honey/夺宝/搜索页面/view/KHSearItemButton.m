//
//  KHSearItemButton.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/16.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHSearItemButton.h"

@implementation KHSearItemButton

- (void)setImage:(UIImage *)image
           title:(NSString *)title
        forState:(UIControlState)state {
    [self setImage:image forState:state];
    [self setTitle:title forState:state];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    //调整图片(imageView)的位置和尺寸
    CGRect imageFrame = self.imageView.frame;
    imageFrame.origin = CGPointMake(0, 10);
    imageFrame.size = CGSizeMake(50, 50);
    self.imageView.frame = imageFrame;
    
    //调整文字(titleLable)的位置和尺寸
    CGRect newFrame = self.titleLabel.frame;
    newFrame.origin.x = self.imageView.right +10;
    newFrame.size.width = self.width - self.imageView.width-10;
    self.titleLabel.frame = newFrame;

}


@end
