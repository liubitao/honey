//
//  KHDistaceHeaderView.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/26.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHDistaceHeaderView.h"

@interface KHDistaceHeaderView ()

@property (nonatomic,strong) UILabel *typeLabel;
@end

@implementation KHDistaceHeaderView
- (instancetype)initWithFrame:(CGRect)frame model:(KHMessageModel *)model{
    self = [super initWithFrame:frame];
    if (self) {
        _model = model;
        [self setUp];
    }
    return self;
}

- (void)setUp{
    self.backgroundColor = UIColorHex(#F5F5F5);
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 90)];
    topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topView];
    
    UIImageView *productImage = [[UIImageView alloc]init];
    productImage.origin = CGPointMake(15, 15);
    productImage.size = CGSizeMake(60, 60);
    [productImage sd_setImageWithURL:[NSURL URLWithString:_model.thumb] placeholderImage:IMAGE_NAMED(@"placeholder")];
    [topView addSubview:productImage];
    
    
    _typeLabel = [[UILabel alloc]init];
    _typeLabel.origin = CGPointMake(productImage.right+10, 15);
    _typeLabel.size = CGSizeMake(KscreenWidth - productImage.right - 20, 20);

    _typeLabel.textColor = UIColorHex(#999999);
    _typeLabel.font = SYSTEM_FONT(15);
    [topView addSubview:_typeLabel];
    
    UILabel *statusLabel = [[UILabel alloc]init];
    statusLabel.origin = CGPointMake(productImage.right+10, _typeLabel.bottom );
    statusLabel.size = CGSizeMake(KscreenWidth - productImage.right - 20, 20);
    statusLabel.text = [NSString stringWithFormat:@"承运来源:%@",_model.shipping.name];
    statusLabel.textColor = UIColorHex(#999999);
    statusLabel.font = SYSTEM_FONT(15);
    [topView addSubview:statusLabel];
    
    
    UILabel *numberLabel = [[UILabel alloc]init];
    numberLabel.origin = CGPointMake(productImage.right+10, statusLabel.bottom);
    numberLabel.size = CGSizeMake(KscreenWidth - productImage.right - 20, 20);
    numberLabel.text = [NSString stringWithFormat:@"运单编号:%@",_model.shipping.code];
    numberLabel.textColor = UIColorHex(#999999);
    numberLabel.font = SYSTEM_FONT(15);
    [topView addSubview:numberLabel];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, topView.bottom+15,  KscreenWidth, 45)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    
    UILabel *promptLabel = [[UILabel alloc]init];
    promptLabel.origin = CGPointMake(45, 0);
    promptLabel.size = CGSizeMake(KscreenWidth- 45, 44);
    promptLabel.text = @"小提示：晒单成功，即可获得1-18个抢币哦";
    promptLabel.textColor = kDefaultColor;
    promptLabel.font = SYSTEM_FONT(13);
    [bottomView addSubview:promptLabel];
    
    UIView *line = [[UIView alloc]init];
    line.origin = CGPointMake(0, promptLabel.bottom);
    line.size = CGSizeMake(kScreenWidth, 1);
    [bottomView addSubview:line];
    
    self.height = bottomView.bottom;
    
}


- (void)resetStatus:(NSString *)type{
    NSString *str;
    if (type.integerValue == 1) {
        str = @"运输状态:运输中";
    }else if(type.integerValue == 2) {
        str = @"运输状态:派件中";
    }else if (type.integerValue == 3){
        str = @"运输状态:已签收";
    }else if (type.integerValue == 4){
        str = @"运输状态:派件失败";
    }
    _typeLabel.attributedText = [Utils stringWith:str font1:SYSTEM_FONT(15) color1:UIColorHex(#44474A) font2:SYSTEM_FONT(15) color2:UIColorHex(#1FA764) range:NSMakeRange(5, str.length - 5)];
}

@end
