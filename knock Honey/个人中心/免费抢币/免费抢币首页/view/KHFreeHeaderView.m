//
//  KHFreeHeaderView.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/11.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHFreeHeaderView.h"

@implementation KHFreeHeaderView
- (instancetype)initWithFrame:(CGRect)frame model:(KHFreeModel *)model{
    self = [super initWithFrame:frame];
    if (self) {
        _model = model;
        [self setup];
    }
    return self;
}

- (void)setup{
    UIView *container = [[UIView alloc]init];
    container.origin = CGPointMake(0, 0);
    container.size = CGSizeMake(kScreenWidth, 160);
    container.backgroundColor = [UIColor whiteColor];
    [self addSubview:container];
    
    _jifenListButton = [[KHChangButton alloc]init];
    _jifenListButton.origin = CGPointMake(kScreenWidth - 100 , 15);
    _jifenListButton.size = CGSizeMake(90, 20);
    _jifenListButton.tag = 1;
    [_jifenListButton setTitle:@"积分明细" forState:UIControlStateNormal];
    [_jifenListButton setImage:IMAGE_NAMED(@"more") forState:UIControlStateNormal];
    [_jifenListButton setTitleColor:UIColorHex(#6A6A6A) forState:UIControlStateNormal];
        [_jifenListButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:_jifenListButton];
    
    UIImageView *jifenImage = [[UIImageView alloc]init];
    jifenImage.origin = CGPointMake(kScreenWidth/2-60,55);
    jifenImage.size = CGSizeMake(60, 40);
    jifenImage.image = IMAGE_NAMED(@"icon");
    jifenImage.contentMode = UIViewContentModeScaleAspectFit;
    [container addSubview:jifenImage];
    
    _jifenLabel = [UILabel new];
    _jifenLabel.origin = CGPointMake(jifenImage.right, jifenImage.top);
    _jifenLabel.size = CGSizeMake(kScreenWidth/2, 40);
    [container addSubview:_jifenLabel];
    
    UIView *line1 = [UIView new];
    line1.origin = CGPointMake(0, _jifenLabel.bottom+23);
    line1.size = CGSizeMake(kScreenWidth, 1);
    line1.backgroundColor = UIColorHex(#6A6A6A);
    [container addSubview:line1];
    
    UIImageView *riliImage = [[UIImageView alloc]init];
    riliImage.origin = CGPointMake(10,line1.bottom +5);
    riliImage.size = CGSizeMake(35 , 25);
    riliImage.image = IMAGE_NAMED(@"rili");
    riliImage.contentMode = UIViewContentModeScaleAspectFit;
    [container addSubview:riliImage];
    
    UILabel *qidaoLabel = [UILabel new];
    qidaoLabel.origin = CGPointMake(riliImage.right, riliImage.top);
    qidaoLabel.size = CGSizeMake(85, riliImage.height);
    qidaoLabel.textAlignment = NSTextAlignmentCenter;
    qidaoLabel.text = @"今日签到";
    qidaoLabel.font = SYSTEM_FONT(16);
    [container addSubview:qidaoLabel];
    
    _addLabel = [UILabel new];
    _addLabel.origin = CGPointMake(qidaoLabel.right, riliImage.top);
    _addLabel.size = CGSizeMake(70, riliImage.height);
    _addLabel.font = SYSTEM_FONT(18);
    _addLabel.textColor = kDefaultColor;
    [container addSubview:_addLabel];
    
    UIImageView *moreImage = [[UIImageView alloc]init];
    moreImage.origin = CGPointMake(kScreenWidth - 30,line1.bottom+8);
    moreImage.size = CGSizeMake(20 , 20);
    moreImage.image = IMAGE_NAMED(@"more");
    moreImage.contentMode = UIViewContentModeScaleAspectFit;
    [container addSubview:moreImage];
    
    _qiandaoButton = [UIButton new];
    _qiandaoButton.origin = CGPointMake(moreImage.left -85, line1.bottom+8);
    _qiandaoButton.size = CGSizeMake(75, 25);
    _qiandaoButton.tag = 2;
    _qiandaoButton.titleLabel.font = SYSTEM_FONT(13);
    [_qiandaoButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    _qiandaoButton.layer.cornerRadius =5;
    _qiandaoButton.layer.masksToBounds = YES;
    [container addSubview:_qiandaoButton];
    moreImage.centerY = _qiandaoButton.centerY;
   
    
    UIView *line2 = [UIView new];
    line2.origin = CGPointMake(0, container.height - 1);
    line1.size = CGSizeMake(kScreenWidth, 1);
    line2.backgroundColor = UIColorHex(#6A6A6A);
    [container addSubview:line2];
    
    [self reSetModel:_model];
}

- (void)reSetModel:(KHFreeModel *)model{
    _model = model;

    if ([Utils isNull:_model]) {
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%@积分",_model.score];
    _jifenLabel.attributedText = [Utils stringWith:str font1:[UIFont boldSystemFontOfSize:22] color1:[UIColor blackColor] font2:SYSTEM_FONT(15) color2:[UIColor blackColor] range:NSMakeRange(_model.score.length, 2)];
    
    
    if (_model.sign_in_time.integerValue == 0) {
        _addLabel.text = @"+5积分";
    }else if (_model.sign_in_time.integerValue <= 2){
        _addLabel.text = @"+10积分";
    }else if (_model.sign_in_time.integerValue <= 4){
        _addLabel.text = @"+15积分";
    }else{
        _addLabel.text = @"+20积分";
    }
    
    if (_model.issign.integerValue == 1) {
        [_qiandaoButton setTitle:@"已签到" forState:UIControlStateNormal];
        _qiandaoButton.backgroundColor = UIColorHex(#329ADD);
    }else{
         [_qiandaoButton setTitle:@"签到" forState:UIControlStateNormal];
        _qiandaoButton.backgroundColor = kDefaultColor;
    }
    
}

- (void)click:(UIButton *)sender{
    NSString *str = [sender titleForState:UIControlStateNormal];
    if (![str isEqualToString:@"已签到"]) {
        if (self.FreeBlock) {
            self.FreeBlock(sender.tag);
        }
    }
}

@end
