//
//  TSProgressView.m
//  WinTreasure
//
//  Created by Apple on 16/6/2.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import "TSProgressView.h"

static const CGFloat kProcessHeight = 8.f;
static const CGFloat kTopSpaces = 2.f;
static const CGFloat kAnimationTime = 3.f;

@interface TSProgressView ()
@property (nonatomic, strong) CALayer *bgLayer;
@property (nonatomic, strong) CALayer *maskLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSArray *colorLocationArray;
@end

@implementation TSProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setup];
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    self.colorArray = @[(id)UIColorHex(0xFABF2C).CGColor,
                        (id)UIColorHex(0xFAB42B).CGColor,
                        (id)UIColorHex(0xF9A733).CGColor,
                        (id)UIColorHex(0xFC9D2B).CGColor,
                        (id)UIColorHex(0xF68E32).CGColor];
    self.colorLocationArray = @[@0.1, @0.3, @0.5, @0.7, @1];
    
    [self getGradientLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _bgLayer.frame = CGRectMake(0, self.height - kProcessHeight - kTopSpaces, self.width, kProcessHeight);
    _maskLayer.frame = CGRectMake(0, 0, self.width * self.progress / 100.f, kProcessHeight);
    _gradientLayer.frame = CGRectMake(0, self.height - kProcessHeight - kTopSpaces, self.width, kProcessHeight);

}

- (void)getGradientLayer { // 进度条设置渐变色
    
    // 灰色进度条背景
    _bgLayer = [CALayer layer];
    _bgLayer.frame = CGRectMake(0, self.height - kProcessHeight - kTopSpaces, self.width, kProcessHeight);
    _bgLayer.backgroundColor = UIColorHex(0xF5F5F5).CGColor;
    _bgLayer.masksToBounds = YES;
    _bgLayer.cornerRadius = kProcessHeight / 2;
    _bgLayer.shouldRasterize = YES;
    [self.layer addSublayer:_bgLayer];
    
    self.maskLayer = [CALayer layer];
    self.maskLayer.frame = CGRectMake(0, 0, self.width * self.progress / 100.f, kProcessHeight);
    self.maskLayer.shouldRasterize = YES;
    self.maskLayer.borderWidth = self.height / 2;
    
    self.gradientLayer =  [CAGradientLayer layer];
    self.gradientLayer.frame = CGRectMake(0, self.height - kProcessHeight - kTopSpaces, self.width, kProcessHeight);
    self.gradientLayer.masksToBounds = YES;
    self.gradientLayer.cornerRadius = kProcessHeight / 2;
    self.gradientLayer.shouldRasterize = YES;
    [self.gradientLayer setColors:self.colorArray];
    [self.gradientLayer setLocations:self.colorLocationArray];
    [self.gradientLayer setStartPoint:CGPointMake(0, 0)];
    [self.gradientLayer setEndPoint:CGPointMake(1, 0)];
    [self.gradientLayer setMask:self.maskLayer];
    [self.layer addSublayer:self.gradientLayer];
}

- (void)setProgress:(CGFloat)progress {
    [self setProgress:progress animated:YES];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    _progress = progress;
    self.maskLayer.frame = CGRectMake(0, 0, self.width  * _progress / 100.f, kProcessHeight);

}

//- (void)circleAnimation { // 进度条动画
//    
//    [CATransaction begin];
////    [CATransaction setDisableActions:NO];
//    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    [CATransaction setAnimationDuration:kAnimationTime];
//    [CATransaction commit];
//}


@end
