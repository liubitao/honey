//
//  BtButton.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/10/26.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "BtButton.h"

@implementation BtButton


 - (void)setImage:(UIImage *)image
              title:(NSString *)title
           forState:(UIControlState)state {
     [self setImage:image forState:state];
     [self setTitle:title forState:state];
 }


- (void)layoutSubviews {
    [super layoutSubviews];
    
    //调整图片(imageView)的位置和尺寸
    self.imageView.frame = CGRectMake(0, 0, self.width, self.height/2);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //调整文字(titleLable)的位置和尺寸
    CGRect newFrame = self.titleLabel.frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.imageView.height+5;
    
    newFrame.size.width = self.width;
    newFrame.size.height = self.height - self.imageView.height - 5;
    
    self.titleLabel.frame = newFrame;
    
    //让文字居中
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}


@end
