//
//  KHAppearDetailView.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/10/26.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHAppearDetailView.h"

#define kAppearDetailTopPadding    10.0 //上部留白
#define kAppearDetailLeftPadding    8   //左右

@implementation ProductInfoView

- (instancetype)initWithFrame:(CGRect)frame model:(KHAppearDetailModel*)model{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorHex(f3f3f3);
        _model = model;
        [self setup];
    }
    return self;
}

- (void)setup{
    _productNameLabel = [UILabel new];
    _productNameLabel.origin = CGPointMake(kAppearDetailLeftPadding, kAppearDetailTopPadding);
    _productNameLabel.size = CGSizeMake(self.width- 2*kAppearDetailLeftPadding, 13);
    _productNameLabel.font = SYSTEM_FONT(12);
    _productNameLabel.textColor = UIColorHex(969696);
    NSString *str = [NSString stringWithFormat:@"获奖奖品：%@",_model.goodstitle];
    _productNameLabel.attributedText = [Utils stringWith:str font1:SYSTEM_FONT(12) color1:UIColorHex(969696) font2:SYSTEM_FONT(12) color2:UIColorHex(5cb0e5) range:NSMakeRange(5, _model.goodstitle.length)];
    [self addSubview:_productNameLabel];
    
    _periodLabel = [UILabel new];
    _periodLabel.origin = CGPointMake(kAppearDetailLeftPadding, _productNameLabel.bottom+5);
    _periodLabel.size = CGSizeMake(self.width- 2*kAppearDetailLeftPadding, 13);
    _periodLabel.font = SYSTEM_FONT(12);
    _periodLabel.textColor = UIColorHex(969696);
    _periodLabel.text = [NSString stringWithFormat:@"商品期数：%@",_model.qishu];
    [self addSubview:_periodLabel];
    
    _participateLabel = [UILabel new];
    _participateLabel.origin = CGPointMake(kAppearDetailLeftPadding, _periodLabel.bottom+5);
    _participateLabel.size = CGSizeMake(self.width- 2*kAppearDetailLeftPadding, 13);
    _participateLabel.font = SYSTEM_FONT(12);
    _participateLabel.textColor = UIColorHex(969696);
    _participateLabel.text = [NSString stringWithFormat:@"本期参与：%@人次",_model.buynum];
    [self addSubview:_participateLabel];
    
    _luckyNumberLabel = [UILabel new];
    _luckyNumberLabel.origin = CGPointMake(kAppearDetailLeftPadding,_participateLabel.bottom+5);
    _luckyNumberLabel.size = CGSizeMake(self.width- 2*kAppearDetailLeftPadding, 13);
    _luckyNumberLabel.font = SYSTEM_FONT(12);
    _luckyNumberLabel.textColor = UIColorHex(969696);
    _luckyNumberLabel.text = [NSString stringWithFormat:@"幸运号码：%@",_model.wincode];
    [self addSubview:_luckyNumberLabel];
    
    _publishTimeLabel = [UILabel new];
    _publishTimeLabel.origin = CGPointMake(kAppearDetailLeftPadding,_luckyNumberLabel.bottom+5);
    _publishTimeLabel.size = CGSizeMake(self.width- 2*kAppearDetailLeftPadding, 13);
    _publishTimeLabel.font = SYSTEM_FONT(12);
    _publishTimeLabel.textColor = UIColorHex(969696);
    _publishTimeLabel.text = [NSString stringWithFormat:@"揭晓时间：%@",[Utils timeWith:_model.lotterytime]];
    [self addSubview:_publishTimeLabel];
    
    self.height = _publishTimeLabel.bottom+kAppearDetailTopPadding;
    
}


@end

@implementation KHAppearDetailView

- (instancetype)initWithFrame:(CGRect)frame model:(KHAppearDetailModel*)model{
    self = [super initWithFrame:frame];
    if (self) {
        _model = model;
        [self setup];
    }
    return self;
}


- (void)setup{
    _containerView = [UIView new];
    _containerView.width = self.width;
    _containerView.height = 1;
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.userInteractionEnabled = YES;
    [self addSubview:_containerView];
    
    _headerImage = [UIImageView new];
    _headerImage.origin = CGPointMake(kAppearDetailLeftPadding, kAppearDetailTopPadding);
    _headerImage.size = CGSizeMake(40, 40);
    _headerImage.layer.cornerRadius = 3;
    _headerImage.layer.masksToBounds = YES;
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:_model.userimg] placeholderImage:IMAGE_NAMED(@"kongren")];
    [_containerView addSubview:_headerImage];
    
    _usernameLabel = [UILabel new];
    _usernameLabel.origin = CGPointMake(_headerImage.right+10, kAppearDetailTopPadding);
    _usernameLabel.size = CGSizeMake(self.width- 120, 20);
    _usernameLabel.font = SYSTEM_FONT(18);
    _usernameLabel.textColor = kDefaultColor;
    _usernameLabel.text = _model.username;
    [_containerView addSubview:_usernameLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.origin = CGPointMake(_headerImage.right+10, _usernameLabel.bottom+5);
    _timeLabel.size = CGSizeMake(self.width- 120, 13);
    _timeLabel.font = SYSTEM_FONT(12);
    _timeLabel.textColor = UIColorHex(969696);
    _timeLabel.text = [NSString transToTime:_model.addtime];
    [_containerView addSubview:_timeLabel];
    
    
    UIView *line1 = [UIView new];
    line1.origin = CGPointMake(_usernameLabel.right+5,5);
    line1.size = CGSizeMake(1, 55);
    line1.backgroundColor = UIColorHex(f1f1f5);
    [_containerView addSubview:line1];
    
    _zanButton = [BtButton new];
    _zanButton.origin = CGPointMake(line1.right+5, kAppearDetailTopPadding);
    _zanButton.size = CGSizeMake(40, 40);
    if (_model.issupport.integerValue == 0) {
         [_zanButton setImage:[UIImage imageNamed:@"zan"] title:[NSString stringWithFormat:@"(%@)",_model.support] forState:UIControlStateNormal];
    }else{
          [_zanButton setImage:[UIImage imageNamed:@"zanSelect"] title:[NSString stringWithFormat:@"(%@)",_model.support] forState:UIControlStateNormal];
    }
   
    
    _zanButton.titleLabel.font = SYSTEM_FONT(10);
    [_zanButton setTitleColor:UIColorHex(969696) forState:UIControlStateNormal];
    [_zanButton addTarget:self action:@selector(clickStar:) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_zanButton];
    
    _infoView = [[ProductInfoView alloc]initWithFrame:CGRectMake(kAppearDetailLeftPadding, _headerImage.bottom+10, self.width - 2*kAppearDetailLeftPadding, 105) model:_model];
    [_containerView addSubview:_infoView];
    
    _headLabel = [UILabel new];
    _headLabel.origin = CGPointMake(kAppearDetailLeftPadding,_infoView.bottom+ kAppearDetailTopPadding);
    _headLabel.size = CGSizeMake(self.width- 2*kAppearDetailLeftPadding, 1);
    CGRect detailSize = [_model.title boundingRectWithSize:CGSizeMake(self.width- 2*kAppearDetailLeftPadding, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}context:nil];
    _headLabel.height = detailSize.size.height;
    _headLabel.text = _model.title;
    _headLabel.numberOfLines = 0;
    _headLabel.font = [UIFont boldSystemFontOfSize:18];
    [_containerView addSubview:_headLabel];
    
    _contentLabel = [UILabel new];
    _contentLabel.origin = CGPointMake(kAppearDetailLeftPadding,_headLabel.bottom+ 5);
    _contentLabel.size = CGSizeMake(self.width- 2*kAppearDetailLeftPadding, 1);
    CGRect detailSize2 = [_model.content boundingRectWithSize:CGSizeMake(self.width- 2*kAppearDetailLeftPadding, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}context:nil];
    _contentLabel.height = detailSize2.size.height;
    _contentLabel.font = SYSTEM_FONT(12);
    _contentLabel.textColor = UIColorHex(969696);
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = _model.content;
    [_containerView addSubview:_contentLabel];
    
    self.height = _contentLabel.bottom+5;
    _containerView.height = _contentLabel.bottom;
    for (int i = 0; i<_model.img.count; i++) {
        [self addImageView:self.height url:_model.img[i]];
    }
}


- (void)addImageView:(CGFloat)top url:(NSString *)urlStr{

    // ，获取下载图片，获取尺寸
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
    UIImage *image = [UIImage imageWithData:data];
    if (!image) {
        return;
    }
    CGSize size = image.size;
    // 回到主线程执行
    UIImageView *imageView = [UIImageView new];
    imageView.origin = CGPointMake(kAppearDetailLeftPadding, top);
    imageView.size = CGSizeMake(self.width- kAppearDetailLeftPadding*2 , self.width*size.height/size.width);
    [self addSubview:imageView];
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.height = imageView.bottom;
    _containerView.height = self.height;
}

- (void)clickStar:(UIButton *)sender{
    if (_model.issupport.integerValue == 1){
        [MBProgressHUD showError:@"已点过赞"];
        return;
    }
    [_zanButton setImage:[UIImage imageNamed:@"zanSelect"] title:[NSString stringWithFormat:@"(%@)",_model.support] forState:UIControlStateNormal];
    if (_ClickBlcok) {
        _ClickBlcok();
    }
}


@end
