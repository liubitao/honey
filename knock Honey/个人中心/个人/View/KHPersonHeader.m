//
//  KHPersonHeader.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/19.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHPersonHeader.h"



CGFloat bgImageViewHeight = 145.0;
CGFloat headImageViewWidth = 75.0;
CGFloat headImageViewLeftMargin = 10.0;
CGFloat headImageViewRightMargin = 10.0;
CGFloat balanceViewHeight = 45.0;

@interface KHPersonHeader ()


/**头像
 */
@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic,strong)  UIImageView *gradeImage;

@property (nonatomic,strong) UIButton *settingButton;

/**昵称
 */
@property (nonatomic, strong) YYLabel *nameLabel;

/**推荐id
 */
@property (nonatomic, strong) YYLabel *IDLabel;


@property (nonatomic,strong) YYLabel *integralLabel;

/**资产
 */
@property (nonatomic, strong) BalanceView *balanceView;

/**抢币数量
 */
@property (nonatomic, copy) NSString *diamondCount;



//未登陆

@property (nonatomic,strong) UIButton *zuceBtn;

@property (nonatomic,strong) UIButton *loginBtn;



@end


@implementation KHPersonHeader

- (void)setDiamondCount:(NSString *)diamondCount {
    _diamondCount = diamondCount;
}

- (instancetype)initWithFrame:(CGRect)frame with:(KHPersonType )type{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        self.backgroundColor = UIColorHex(@"EAE5E1");
        [self _init];
    }
    return self;
}

- (void)_init{
    if (_type == KHPersonNOLogin) {
        _bgImageView = [UIImageView new];
        _bgImageView.origin = CGPointMake(0, 0);
        _bgImageView.size = CGSizeMake(kScreenWidth, 190);
        _bgImageView.image = IMAGE_NAMED(@"personHeader");
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.clipsToBounds = YES;
        [self addSubview:_bgImageView];
        
        _settingButton = [[UIButton alloc]initWithFrame:CGRectZero];
        _settingButton.origin = CGPointMake(kScreenWidth - 50, 30);
        _settingButton.size = CGSizeMake(40, 40);
        _settingButton.userInteractionEnabled = YES;
        [_settingButton setImage:IMAGE_NAMED(@"install") forState:UIControlStateNormal];
        [_settingButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_settingButton];
        
        YYLabel *titleLabel = [YYLabel new];
        titleLabel.text = @"欢迎使用云网夺宝";
        titleLabel.origin = CGPointMake(0 ,85);
        titleLabel.size = CGSizeMake(kScreenWidth, 18);
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = SYSTEM_FONT(17);
        [self addSubview:titleLabel];
        
        _zuceBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        _zuceBtn.userInteractionEnabled = YES;
        _zuceBtn.origin = CGPointMake(kScreenWidth/2 - 130, titleLabel.bottom + 15);
        _zuceBtn.size = CGSizeMake(120, 35);
        _zuceBtn.backgroundColor = UIColorHex(#E06A7F);
        [_zuceBtn setTitle:@"免费注册" forState:UIControlStateNormal];
        [_zuceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _zuceBtn.titleLabel.font = SYSTEM_FONT(17);
        [_zuceBtn addTarget:self action:@selector(noLogin:) forControlEvents:UIControlEventTouchUpInside];
        _zuceBtn.layer.cornerRadius = 5;
        _zuceBtn.layer.borderWidth = 1;
        _zuceBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _zuceBtn.layer.masksToBounds = YES;
        _zuceBtn.tag = 110;
        [self addSubview:_zuceBtn];
        
        _loginBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        _loginBtn.userInteractionEnabled = YES;
        _loginBtn.origin = CGPointMake(kScreenWidth/2 +10,  titleLabel.bottom + 15);
        _loginBtn.size = CGSizeMake(120, 35);
        _loginBtn.backgroundColor = kDefaultColor;
        [_loginBtn setTitle:@"马上登陆" forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = SYSTEM_FONT(17);
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(noLogin:) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.layer.cornerRadius = 5;
        _loginBtn.layer.borderWidth = 1;
        _loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.tag = 112;
        [self addSubview:_loginBtn];

        return;
    }
    
    
    _bgImageView = [UIImageView new];
    _bgImageView.origin = CGPointMake(0, 0);
    _bgImageView.size = CGSizeMake(kScreenWidth, bgImageViewHeight);
    _bgImageView.image = IMAGE_NAMED(@"personHeader");
    _bgImageView.userInteractionEnabled = YES;
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.clipsToBounds = YES;
    [self addSubview:_bgImageView];
    
    _settingButton = [[UIButton alloc]initWithFrame:CGRectZero];
    _settingButton.origin = CGPointMake(kScreenWidth - 50, 30);
    _settingButton.size = CGSizeMake(40, 40);
    [_settingButton setImage:IMAGE_NAMED(@"install") forState:UIControlStateNormal];
    [_settingButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_settingButton];
    
    
    _headImageView = [UIImageView new];
    _headImageView.origin = CGPointMake(headImageViewLeftMargin, _bgImageView.bottom-45);
    _headImageView.size = CGSizeMake(headImageViewWidth, headImageViewWidth);
    _headImageView.contentMode = UIViewContentModeScaleToFill;
    _headImageView.layer.cornerRadius = 5;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.borderWidth = 5;
    _headImageView.layer.borderColor = [UIColor colorWithHexString:@"ffffff" withAlpha:0.5].CGColor;
    _headImageView.layer.shouldRasterize = YES;
    _headImageView.layer.rasterizationScale = kScreenScale;
    _headImageView.userInteractionEnabled = YES;
    
    YWUser *user = [YWUserTool account];
    _gradeImage = [UIImageView new];
    _gradeImage.origin = CGPointMake(0, _headImageView.bottom -20);
    _gradeImage.size = CGSizeMake(90, 30);
    NSString *gradeStr = [NSString stringWithFormat:@"grade%@",user.grade];
    _gradeImage.image = IMAGE_NAMED(gradeStr);
    _gradeImage.contentMode = UIViewContentModeScaleAspectFit;
    
   
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:user.img] placeholderImage:[UIImage imageNamed:@"kongren"]];
    __weak typeof(self) weakSelf = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (weakSelf.headImgBlock) {
            weakSelf.headImgBlock();
        }
    }];
    [_headImageView addGestureRecognizer:tap];

    _nameLabel = [YYLabel new];
    _nameLabel.text = user.username;
    _nameLabel.origin = CGPointMake(_headImageView.right+headImageViewRightMargin, _headImageView.top);
    _nameLabel.size = CGSizeMake(kScreenWidth-_headImageView.right-10*2, 19);
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = SYSTEM_FONT(18);
    [self addSubview:_nameLabel];
    
    _IDLabel = [YYLabel new];
    
    _IDLabel.text = [NSString stringWithFormat:@"推荐ID:%zi",user.userid.integerValue +100000];
    _IDLabel.origin = CGPointMake(_headImageView.right+headImageViewRightMargin, _nameLabel.bottom+7);
    _IDLabel.size = CGSizeMake((kScreenWidth-_headImageView.right)/2, 12);
    _IDLabel.textColor = [UIColor whiteColor];
    _IDLabel.font = SYSTEM_FONT(11);
    [self addSubview:_IDLabel];
    
    _integralLabel = [YYLabel new];
    _integralLabel.text = [NSString stringWithFormat:@"积分:%@",user.score];
    _integralLabel.origin = CGPointMake(KscreenWidth-160, _nameLabel.bottom+10);
    _integralLabel.size = CGSizeMake(150, 12);
    _integralLabel.textAlignment = NSTextAlignmentRight;
    _integralLabel.textColor = [UIColor whiteColor];
    _integralLabel.font = SYSTEM_FONT(11);
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (weakSelf.diamondBlock) {
            weakSelf.diamondBlock();
        }
    }];
    [_integralLabel addGestureRecognizer:tap2];
    [self addSubview:_integralLabel];
    
    _balanceView = [[BalanceView alloc] initWithFrame:({
        CGRect rect = {
            0,
            _headImageView.bottom-30,
            kScreenWidth,
            balanceViewHeight};
        rect;
    })];
    _balanceView.balanceAmount = user.money;
    _balanceView.topupBlock = ^(){
        if (weakSelf.topupBlock) {
            weakSelf.topupBlock();
        }
    };
    
    [self addSubview:_balanceView];
    [self addSubview:_headImageView];
    [self addSubview:_gradeImage];
}

- (void)setType:(KHPersonType)type{
    _type = type;
    [self removeAllSubviews];
    [self _init];
}

//未登录情况下
- (void)noLogin:(UIButton *)sender{
    if (self.loginBlock) {
        self.loginBlock(sender);
    }
}

- (void)click:(UIButton *)sender{
    if (_settingBlock) {
        _settingBlock();
    }
}


- (void)makeScaleForScrollView:(UIScrollView *)scrollView {
    CGFloat imageHeight = _type == KHPersonLogin ?bgImageViewHeight:190;
    CGFloat scale = fabs(scrollView.contentOffset.y/imageHeight);
    _bgImageView.layer.position = CGPointMake(kScreenWidth/2.0, (scrollView.contentOffset.y+ (0.5*imageHeight)*2)/2);
    _bgImageView.transform = CGAffineTransformMakeScale(1+scale, 1+scale);
}

- (void)setRemainSum:(NSString *)remainSum {
    _remainSum = remainSum;
    _balanceView.balanceAmount = _remainSum;
    NSString *gradeStr = [NSString stringWithFormat:@"grade%@",[YWUserTool account].grade];
    _gradeImage.image = IMAGE_NAMED(gradeStr);
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)freshen{
    YWUser *user = [YWUserTool account];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:user.img] placeholderImage:[UIImage imageNamed:@"kongren"]];
    _nameLabel.text = user.username;
    
    _IDLabel.text = [NSString stringWithFormat:@"推荐ID:%zi",user.userid.integerValue +100000];
    _integralLabel.text = [NSString stringWithFormat:@"积分:%@",user.score];
    NSString *gradeStr = [NSString stringWithFormat:@"grade%@",user.grade];
    _gradeImage.image = IMAGE_NAMED(gradeStr);
    [self setRemainSum:user.money];
}

@end

@interface BalanceView ()

/**充值
 */
@property (nonatomic, strong) UIButton *topupButton;

@end


CGFloat balanceLabelHeight = 15.0;
CGFloat topupButtonHeight = 25.0;

@implementation BalanceView

- (void)setBalanceAmount:(NSString *)balanceAmount {
    _balanceAmount = balanceAmount;
    NSString *aString = [NSString stringWithFormat:@"抢币:%@",balanceAmount];
    NSMutableAttributedString *attString = [Utils stringWith:aString font1:SYSTEM_FONT(13) color1:UIColorHex(999999) font2:SYSTEM_FONT(13) color2:kDefaultColor range:NSMakeRange(3, aString.length-3)];
    _balanceLabel.attributedText = attString;
    _balanceLabel.size = [attString size];
    _topupButton.left = _balanceLabel.right + 8;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupBalance];
    }
    return self;
}

- (void)setupBalance {
    _balanceLabel = [YYLabel new];
    _balanceLabel.origin = CGPointMake(headImageViewLeftMargin+headImageViewWidth+headImageViewRightMargin, (self.height-balanceLabelHeight)/2.0);
    _balanceLabel.size = CGSizeMake(80, balanceLabelHeight);
    _balanceLabel.font = SYSTEM_FONT(14);
    [self addSubview:_balanceLabel];
    
    //根据test来判断
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults valueForKey:@"test"];
    if (str.integerValue == 0) {
    _topupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _topupButton.origin = CGPointMake(_balanceLabel.right+8, (self.height-topupButtonHeight)/2.0);
    _topupButton.size = CGSizeMake(60, topupButtonHeight);
    _topupButton.titleLabel.font = SYSTEM_FONT(15);
    _topupButton.backgroundColor = kDefaultColor;
    _topupButton.layer.cornerRadius = 4.0;
    _topupButton.layer.masksToBounds = YES;
    _topupButton.layer.rasterizationScale = kScreenScale;
    [_topupButton setTitle:@"充值" forState:UIControlStateNormal];
    [_topupButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_topupButton addTarget:self action:@selector(topup) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_topupButton];
    }
}

- (void)topup {
    if (_topupBlock) {
        _topupBlock();
    }
}

@end
