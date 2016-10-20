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
@property (nonatomic, copy) NSNumber *diamondCount;



@end


@implementation KHPersonHeader

- (void)setDiamondCount:(NSNumber *)diamondCount {
    _diamondCount = diamondCount;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorHex(@"EAE5E1");
        [self _init];
    }
    return self;
}

- (void)_init {
    _bgImageView = [UIImageView new];
    _bgImageView.origin = CGPointMake(0, 0);
    _bgImageView.size = CGSizeMake(kScreenWidth, bgImageViewHeight);
    _bgImageView.image = [UIImage imageWithColor:kDefaultColor];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.clipsToBounds = YES;
    [self addSubview:_bgImageView];
    
    _headImageView = [UIImageView new];
    _headImageView.origin = CGPointMake(headImageViewLeftMargin, _bgImageView.bottom-45);
    _headImageView.size = CGSizeMake(headImageViewWidth, headImageViewWidth);
    _headImageView.layer.cornerRadius = 5;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.borderWidth = 5;
    _headImageView.layer.borderColor = [UIColor colorWithHexString:@"ffffff" withAlpha:0.5].CGColor;
    _headImageView.layer.shouldRasterize = YES;
    _headImageView.layer.rasterizationScale = kScreenScale;
    _headImageView.userInteractionEnabled = YES;

    _headImageView.image = [UIImage imageNamed:@"2"];
    __weak typeof(self) weakSelf = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (weakSelf.headImgBlock) {
            weakSelf.headImgBlock();
        }
    }];
    [_headImageView addGestureRecognizer:tap];
    
    
    _nameLabel = [YYLabel new];
    _nameLabel.text = @"湮灭&尘事";
    _nameLabel.origin = CGPointMake(_headImageView.right+headImageViewRightMargin, _headImageView.top);
    _nameLabel.size = CGSizeMake(kScreenWidth-_headImageView.right-10*2, 19);
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = SYSTEM_FONT(18);
    [self addSubview:_nameLabel];
    
    _IDLabel = [YYLabel new];
    _IDLabel.text = [NSString stringWithFormat:@"推荐ID:30611576"];
    _IDLabel.origin = CGPointMake(_headImageView.right+headImageViewRightMargin, _nameLabel.bottom+7);
    _IDLabel.size = CGSizeMake((kScreenWidth-_headImageView.right)/2, 12);
    _IDLabel.textColor = [UIColor whiteColor];
    _IDLabel.font = SYSTEM_FONT(11);
    [self addSubview:_IDLabel];
    
    _integralLabel = [YYLabel new];
    _integralLabel.text = [NSString stringWithFormat:@"积分:0"];
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
    _balanceView.balanceAmount = @0;
    _balanceView.topupBlock = ^(){
        if (weakSelf.topupBlock) {
            weakSelf.topupBlock();
        }
    };
    
    [self addSubview:_balanceView];
    [self addSubview:_headImageView];
}


- (void)makeScaleForScrollView:(UIScrollView *)scrollView {
    CGFloat scale = fabs(scrollView.contentOffset.y/bgImageViewHeight);
    _bgImageView.layer.position = CGPointMake(kScreenWidth/2.0, (scrollView.contentOffset.y+ (0.5*bgImageViewHeight)*2)/2);
    _bgImageView.transform = CGAffineTransformMakeScale(1+scale, 1+scale);
    
}

- (void)setRemainSum:(NSNumber *)remainSum {
    _remainSum = remainSum;
    _balanceView.balanceAmount = _remainSum;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.height = _balanceView.bottom;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
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

- (void)setBalanceAmount:(NSNumber *)balanceAmount {
    _balanceAmount = balanceAmount;
    NSString *aString = [NSString stringWithFormat:@"抢币：%@",_balanceAmount];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:aString];
    [attString addAttributes:@{NSForegroundColorAttributeName:UIColorHex(999999),NSFontAttributeName:SYSTEM_FONT(13)} range:NSMakeRange(0, 3)];
    [attString addAttributes:@{NSForegroundColorAttributeName:kDefaultColor,NSFontAttributeName:SYSTEM_FONT(13)} range:NSMakeRange(3, _balanceAmount.stringValue.length)];
    [attString addAttributes:@{NSForegroundColorAttributeName:UIColorHex(999999),NSFontAttributeName:SYSTEM_FONT(13)} range:NSMakeRange(attString.length-1, 1)];
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

- (void)topup {
    if (_topupBlock) {
        _topupBlock();
    }
}

@end
