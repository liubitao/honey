//
//  KHOtherHeaderView.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/28.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHOtherHeaderView.h"

@interface KHOtherHeaderView ()

@property (nonatomic,strong) UIImageView *bgImageView;

@end

@implementation KHOtherHeaderView

- (instancetype)initWithFrame:(CGRect)frame model:(KHOtherModel *)model{
    self = [super initWithFrame:frame];
    if (self) {
        _model = model;
        [self setUp];
    }
    return self;
}

- (void)setUp{
    _bgImageView = [UIImageView new];
    _bgImageView.origin = CGPointMake(0, 0);
    _bgImageView.size = CGSizeMake(kScreenWidth, 190);
    _bgImageView.image = IMAGE_NAMED(@"otherHeader");
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.userInteractionEnabled = YES;
    _bgImageView.clipsToBounds = YES;
    [self addSubview:_bgImageView];
    
    UIImageView *userImage = [UIImageView new];
    userImage.origin = CGPointMake((kScreenWidth- 65)/2, 72);
    userImage.size = CGSizeMake(65, 65);
    [userImage sd_setImageWithURL:[NSURL URLWithString:_model.img]];
    userImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:userImage];
    
    UIImageView *gradeImage = [UIImageView new];
    gradeImage.origin = CGPointMake((kScreenWidth- 90)/2, userImage.bottom -20);
    gradeImage.size = CGSizeMake(90, 30);
    NSString *gradeStr = [NSString stringWithFormat:@"grade%@",_model.grade];
    gradeImage.image = IMAGE_NAMED(gradeStr);
    gradeImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:gradeImage];
    
    
    YYLabel *titleLabel = [YYLabel new];
    titleLabel.text = _model.username;
    titleLabel.origin = CGPointMake(0 ,userImage.bottom +20);
    titleLabel.size = CGSizeMake(kScreenWidth, 20);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = SYSTEM_FONT(18);
    [self addSubview:titleLabel];

}
@end
