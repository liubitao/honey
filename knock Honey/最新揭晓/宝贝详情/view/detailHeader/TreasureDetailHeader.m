//
//  TreasureDetailHeader.m
//  WinTreasure
//
//  Created by Apple on 16/6/8.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import "TreasureDetailHeader.h"
#import "TSProgressView.h"
#import "TSCountLabel.h"

#define  kTreasureDetailHeaderMarginBottom 10

const CGFloat kTreasureDetailHeaderPadding = 10.0; //左右边距

const CGFloat kTreasureDetailHeaderPageControlHeight = 30.0; //pagecontroll height

@interface TreasureDetailHeader () <UIScrollViewDelegate, TSCountLabelDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPageControl *pageControl;





@end

@implementation TreasureDetailHeader

+ (CGFloat)getHeight {
    return kScreenWidth*2;
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:({
            CGRect rect = {0,0,kScreenWidth,kScreenWidth/375*200};
            rect;
        })];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.model.picarr.count*kScreenWidth, kScreenWidth/375*200);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self.model.picarr enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                              NSUInteger idx,
                                              BOOL * _Nonnull stop) {
            UIImageView *imgView = [UIImageView new];
            imgView.tag = idx;
            imgView.userInteractionEnabled = YES;
            [imgView sd_setImageWithURL:[NSURL URLWithString:_model.picarr[idx]]];
            imgView.origin = CGPointMake(idx*kScreenWidth, 0);
            imgView.size = CGSizeMake(_scrollView.width, _scrollView.height);
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            [_scrollView addSubview:imgView];
        }];
    }
    return _scrollView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:({
            CGRect rect = {0,kScreenWidth/375*200-kTreasureDetailHeaderPageControlHeight,kScreenWidth,kTreasureDetailHeaderPageControlHeight};
            rect;
        })];
        _pageControl.numberOfPages = self.model.picarr.count;
        _pageControl.currentPageIndicatorTintColor = kDefaultColor;
        _pageControl.pageIndicatorTintColor = UIColorHex(666666);
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

- (instancetype)initWithFrame:(CGRect)frame
                         type:(TreasureDetailHeaderType)type
                    countTime:(NSInteger)countTime  Model:(KHProductModel*)model{
    self = [super initWithFrame:frame];
    if (self) {
        _count = countTime;
        _type = type;
        _model = model;
        [self setup];
    }
    return self;
}

- (void)setup {
    //添加图片滚动
    [self addSubview:self.scrollView];
    //添加pageControl
    [self addSubview:self.pageControl];
    //添加状态
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kTreasureDetailHeaderPadding, _scrollView.bottom+15, 45, 16)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    switch (_type) {
            //进行中
        case TreasureDetailHeaderTypeNotParticipate:
        case TreasureDetailHeaderTypeParticipated:
            label.text = @"进行中";
            label.backgroundColor = kDefaultColor;
            break;
        case TreasureDetailHeaderTypeCountdown://倒计时
            label.text = @"倒计时";
            label.backgroundColor = kDefaultColor;
            break;
        case TreasureDetailHeaderTypeWon://商品揭晓
            label.text = @"已揭晓";
            label.backgroundColor = UIColorHex(55bf41);
            break;
        default:
            break;
    }
    //添加商品名
    NSMutableAttributedString *name = [[NSMutableAttributedString alloc]initWithString:_model.title];
    name.color = UIColorHex(333333);
    name.font = [UIFont boldSystemFontOfSize:14];
    name.lineSpacing = 1.0;
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth-kTreasureDetailHeaderPadding*3-50, HUGE)];
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:name];
    
    _productNameLabel = [YYLabel new];
    _productNameLabel.displaysAsynchronously = YES;
    _productNameLabel.origin = CGPointMake(kTreasureDetailHeaderPadding*2+50, _scrollView.bottom+15);
    _productNameLabel.size = CGSizeMake(kScreenWidth-kTreasureDetailHeaderPadding*3-50, 16*layout.rowCount);
    _productNameLabel.numberOfLines = 0;
    _productNameLabel.textLayout = layout;
    
    [self addSubview:_productNameLabel];
    
    //添加进度页面
    _treasureProgressView = [[TreasureProgressView alloc]initWithFrame:({
        CGRect rect = {kTreasureDetailHeaderPadding,
                        _productNameLabel.bottom+20,
        kScreenWidth-kTreasureDetailHeaderPadding*2,
                                                1};
        rect;
    }) type:_type countTime:_count Model:_model];
    _treasureProgressView.countDownLabel.delegate = self;
    __weak typeof(self) weakSelf = self;
    _treasureProgressView.block = ^() {
        if (weakSelf.countDetailBlock) {
            weakSelf.countDetailBlock();
        }
    };
    [self addSubview:_treasureProgressView];

    //是否参加页面
    _participateView = [[ParticipateView alloc]initWithFrame:({
        CGRect rect = {(self.width-_treasureProgressView.width)/2.0,
            _treasureProgressView.bottom+kTreasureDetailHeaderMarginBottom,
            _treasureProgressView.width,
            30};
        rect;
    }) isParticipated:_type==TreasureDetailHeaderTypeParticipated?YES:NO];

    _participateView.backgroundColor = UIColorHex(0xF5F5F5);
    [self addSubview:_participateView];
    
    //声明
    _declareLabel = [[UILabel alloc]initWithFrame:({
        CGRect rect = {kTreasureDetailHeaderPadding,
            _participateView.bottom+5,
            _treasureProgressView.width,
            15};
        rect;
    })];
    _declareLabel.font = SYSTEM_FONT(12);
    _declareLabel.text = @"声明:所有商品抽奖活动与苹果公司(Apple Inc)无关";
    _declareLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_declareLabel];
    
    //声明按钮
    _declareBtn = [[UIButton alloc]initWithFrame:({
        CGRect rect = {kTreasureDetailHeaderPadding,
            _declareLabel.bottom+5,
            _treasureProgressView.width,
            15};
        rect;
    })];
    [_declareBtn setImage:IMAGE_NAMED(@"select") forState:UIControlStateNormal];
    [_declareBtn setTitle:@"我已阅读《夺宝声明》" forState:UIControlStateNormal];
    _declareBtn.titleLabel.font = SYSTEM_FONT(13);
    _declareBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_declareBtn setTitleColor:UIColorHex(999999) forState:UIControlStateNormal];
    [_declareBtn addTarget:self action:@selector(clickDeclare:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_declareBtn];
    
    
    //下面的选项
    NSArray *dataArray = @[@"图文详情",@"晒单分享",@"往期揭晓"];
    _headerMenu = [[TreaureHeaderMenu alloc]initWithFrame:({
        CGRect rect = {0,_declareBtn.bottom+5,kScreenWidth,1};
        rect;
    }) data:dataArray];
    _headerMenu.block = ^(NSInteger index){
        if (weakSelf.clickMenuBlock) {
            weakSelf.clickMenuBlock(@(index));
        }
    };
    [self addSubview:_headerMenu];
    self.height = _headerMenu.bottom;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _participateView.top = _treasureProgressView.bottom+kTreasureDetailHeaderMarginBottom;
    _declareLabel.top = _participateView.bottom+5;
    _declareBtn.top = _declareLabel.bottom+5;
    _headerMenu.top = _declareBtn.bottom+5;
    self.height = _headerMenu.bottom;
    NSLog(@"%f",_headerMenu.bottom);
}

//点击声明
- (void)clickDeclare:(UIButton *)sender{
    if (self.declareBlcok) {
        self.declareBlcok();
    }
}

#pragma mark - TSCountLabelDelegate
//倒计时完成
- (void)countdownDidEnd {
    _treasureProgressView.type = TreasureDetailHeaderTypeWon;
    [self setNeedsLayout];
    self.headerHeight();
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControl.currentPage = scrollView.contentOffset.x/kScreenWidth;
}
- (void)dealloc{
    if (_treasureProgressView.countDownLabel.timer) {
        [_treasureProgressView.countDownLabel.timer invalidate];
        _treasureProgressView.countDownLabel.timer = nil;
    }
}

@end

@interface ParticipateView ()

@end

@implementation ParticipateView

- (instancetype)initWithFrame:(CGRect)frame
               isParticipated:(BOOL)isParticipated {
    self = [super initWithFrame:frame];
    if (self) {
        _isParticipated = isParticipated;
        [self _init];
    }
    return self;
}

- (void)_init {
    if (!_isParticipated) {
        _participateLabel = [YYLabel new];
        _participateLabel.backgroundColor = UIColorHex(0xF5F5F5);
        _participateLabel.origin = CGPointMake(0, 0);
        _participateLabel.size = CGSizeMake(self.width, self.height);
        _participateLabel.text = @"您没有参与本期夺宝哦！";
        _participateLabel.textAlignment = NSTextAlignmentCenter;
        _participateLabel.textColor = UIColorHex(666666);
        _participateLabel.font = SYSTEM_FONT(12);
        [self addSubview:_participateLabel];
        return;
    }
    _participateLabel = [YYLabel new];
    _participateLabel.origin = CGPointMake(5, 5);
    _participateLabel.size = CGSizeMake(self.width-5*2, 15);
    _participateLabel.textColor = UIColorHex(666666);
    _participateLabel.font = SYSTEM_FONT(12);
    _participateLabel.text = @"您参与了:2人次";
    [self addSubview:_participateLabel];
    
    _numberLabel = [YYLabel new];
    _numberLabel.origin = CGPointMake(5, _participateLabel.bottom+5);
    _numberLabel.size = CGSizeMake(self.width-5*2, 15);
    _numberLabel.textColor = UIColorHex(666666);
    _numberLabel.font = SYSTEM_FONT(12);
    _numberLabel.text = @"夺宝号码:10004253 10003234";
    [self addSubview:_numberLabel];
    self.height = _numberLabel.bottom+5;
}

@end

//计算详情按钮宽高
const CGFloat kTreasureProgressViewCountButtonHeight = 26.0;
const CGFloat kTreasureProgressViewCountButtonWidth = 100.0;
const CGFloat kWinnerImageWidth = 40.0;
const CGFloat kWinnerImagePadding = 20.0;
const CGFloat kBackImageViewHeight = 45.0;

@implementation TreasureProgressView

- (instancetype)initWithFrame:(CGRect)frame
                         type:(TreasureDetailHeaderType)type
                    countTime:(NSInteger)countTime Model:(KHProductModel*)model{
    self = [super initWithFrame:frame];
    if (self) {
        _countTime = countTime;
        _type = type;
        _model = model;
        [self setup];
    }
    return self;
}

- (void)setType:(TreasureDetailHeaderType)type {
    _type = type;
    [self removeAllSubviews];
    [self setup];
}

- (void)setup {
    switch (_type) {
        case TreasureDetailHeaderTypeNotParticipate:case TreasureDetailHeaderTypeParticipated: {//参加和未参加
            //商品期数
            _periodNumberLabel = [YYLabel new];
            _periodNumberLabel.origin = CGPointMake(0, 0);
            _periodNumberLabel.size = CGSizeMake(self.width, 12);
            _periodNumberLabel.font = SYSTEM_FONT(12);
            _periodNumberLabel.textColor = UIColorHex(999999);
            _periodNumberLabel.text = [NSString stringWithFormat:@"商品期号：%@",_model.qishu];
            [self addSubview:_periodNumberLabel];
            
            //进度条
            _progressView = [[TSProgressView alloc] initWithFrame:({
                CGRect rect = {0,_periodNumberLabel.bottom+kTreasureDetailHeaderPadding,self.width,10};
                rect;
            })];
            _progressView.progress = [_model.jindu integerValue];
            [self addSubview:_progressView];
            
            _rightLabel = [YYLabel new];
            _rightLabel.origin = CGPointMake(self.width/2, _progressView.bottom+kTreasureDetailHeaderPadding);
            _rightLabel.size = CGSizeMake(self.width/2, 12);
            NSString *rightStr = [NSString stringWithFormat:@"剩余%d人次",[_model.zongrenshu intValue]-[_model.canyurenshu intValue]];
            _rightLabel.attributedText = [Utils stringWith:rightStr font1:SYSTEM_FONT(12) color1:UIColorHex(999999) font2:SYSTEM_FONT(12) color2:kDefaultColor range:NSMakeRange(2, rightStr.length-4)];
            _rightLabel.textAlignment = NSTextAlignmentRight;
            [self addSubview:_rightLabel];
            
            _totalLabel = [YYLabel new];
            _totalLabel.origin = CGPointMake(0, _progressView.bottom+kTreasureDetailHeaderPadding);
            _totalLabel.size = CGSizeMake(self.width/2, 12);
            _totalLabel.font = SYSTEM_FONT(12);
            NSString *totalStr = [NSString stringWithFormat:@"总需%@人次",_model.zongrenshu];
            _totalLabel.attributedText = [Utils stringWith:totalStr font1:SYSTEM_FONT(12) color1:UIColorHex(999999) font2:SYSTEM_FONT(12) color2:UIColorHex(7cade8) range:NSMakeRange(2, totalStr.length-4)];
            [self addSubview:_totalLabel];
            
            if ([Utils isNull:_model.winner.qishu]) {
                self.height = _totalLabel.bottom ;
            } else{
            [self setupWinnerView:_totalLabel.bottom+20];
            }
        }
            break;
        case TreasureDetailHeaderTypeCountdown:{//倒计时
            self.backgroundColor = kDefaultColor;
            _periodNumberLabel = [YYLabel new];
            _periodNumberLabel.origin = CGPointMake(5, 15);
            _periodNumberLabel.size = CGSizeMake(self.width-kTreasureProgressViewCountButtonWidth, 12);
            _periodNumberLabel.font = SYSTEM_FONT(12);
            _periodNumberLabel.textColor = [UIColor whiteColor];
            _periodNumberLabel.text = [NSString stringWithFormat:@"商品期号：%@",_model.qishu];
            [self addSubview:_periodNumberLabel];
            
            _countLabel = [YYLabel new];
            _countLabel.origin = CGPointMake(5, _periodNumberLabel.bottom+8);
            _countLabel.size = CGSizeMake(self.width-kTreasureProgressViewCountButtonWidth, 16);
            _countLabel.font = SYSTEM_FONT(12);
            _countLabel.textColor = [UIColor whiteColor];
            _countLabel.text = @"揭晓倒计时:";
            [self addSubview:_countLabel];
            [_countLabel sizeToFit];
            
            //倒计时
            _countDownLabel = [TSCountLabel new];
            _countDownLabel.textAlignment = NSTextAlignmentLeft;
            _countDownLabel.origin = CGPointMake(_countLabel.right+5, _periodNumberLabel.bottom+5);
            _countDownLabel.size = CGSizeMake(self.width-kTreasureProgressViewCountButtonWidth-(_countLabel.right+5), 19);
            _countDownLabel.centerY = _countLabel.centerY;
            _countDownLabel.font = SYSTEM_FONT(17);
            _countDownLabel.textColor = [UIColor whiteColor];
            _countDownLabel.startValue = _countTime;
            [self addSubview:_countDownLabel];
            [_countDownLabel start];
            self.height = _countDownLabel.bottom + 15;

            //计算详情
            _countDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _countDetailButton.origin = CGPointMake(self.width-kTreasureProgressViewCountButtonWidth-kTreasureDetailHeaderPadding, (self.height-kTreasureProgressViewCountButtonHeight)/2.0);
            _countDetailButton.size = CGSizeMake(kTreasureProgressViewCountButtonWidth, kTreasureProgressViewCountButtonHeight);
            _countDetailButton.titleLabel.font = SYSTEM_FONT(14);
            _countDetailButton.layer.cornerRadius = 5;
            _countDetailButton.layer.borderColor = [UIColor whiteColor].CGColor;
            _countDetailButton.layer.borderWidth = CGFloatFromPixel(1);
            _countDetailButton.layer.shouldRasterize = YES;
            _countDetailButton.layer.rasterizationScale = kScreenScale;
            [_countDetailButton setTitle:@"计算详情" forState:UIControlStateNormal];
            [_countDetailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_countDetailButton addTarget:self action:@selector(countDetail) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_countDetailButton];
        }
            break;
        case TreasureDetailHeaderTypeWon: {
            [self setupWinnerView:0];

        }
            break;
        default:
            break;
    }
}

- (void)setupWinnerView:(CGFloat)top{
    UIColor *defaultColor = UIColorHex(666666);
    UIFont *defaultFont = SYSTEM_FONT(12);
    
    UIView *view = [UIView new];
    view.origin = CGPointMake(0, top);
    view.size = CGSizeMake(self.width, 1);
    [self addSubview:view];
    KHWinner *winner= _model.winner;
    
    UIImageView *iamgeView = [UIImageView new];
    iamgeView.origin = CGPointMake(-5, -5);
    iamgeView.size = CGSizeMake(45, 45);
    iamgeView.contentMode = UIViewContentModeScaleAspectFit;
    iamgeView.image = IMAGE_NAMED(@"lottery_container_user");
    [view addSubview:iamgeView];
    
    if (_type == TreasureDetailHeaderTypeParticipated || _type == TreasureDetailHeaderTypeNotParticipate) {
        UIImageView *imageView2 = [UIImageView new];
        imageView2.origin = CGPointMake(view.width -40  , 0);
        imageView2.size = CGSizeMake(20, 50);
        imageView2.image = IMAGE_NAMED(@"lottery_container_last_icon");
        [view addSubview:imageView2];
    }
    
    _winnerImgView = [UIImageView new];
    _winnerImgView.origin = CGPointMake(kWinnerImagePadding, kWinnerImagePadding);
    _winnerImgView.size = CGSizeMake(kWinnerImageWidth, kWinnerImageWidth);
    [_winnerImgView sd_setImageWithURL:[NSURL URLWithString:winner.img]];
    [view addSubview:_winnerImgView];
    
    YYLabel *aLabel = [YYLabel new];
    aLabel.origin = CGPointMake(_winnerImgView.right+10, _winnerImgView.top);
    aLabel.size = CGSizeMake(self.width-(_winnerImgView.right+5)-5, 13);
    aLabel.font = defaultFont;
    aLabel.text = @"获奖者：";
    aLabel.textColor = defaultColor;
    aLabel.numberOfLines = 0;
    [view addSubview:aLabel];
    [aLabel sizeToFit];
    
    _winnerLabel = [YYLabel new];
    _winnerLabel.origin = CGPointMake(aLabel.right, _winnerImgView.top);
    _winnerLabel.size = CGSizeMake(self.width-aLabel.right, 13);
    _winnerLabel.font = defaultFont;
    _winnerLabel.text = winner.username;
    _winnerLabel.textColor = UIColorHex(7cade8);
    _winnerLabel.numberOfLines = 1;
    [view addSubview:_winnerLabel];
    [_winnerLabel sizeToFit];

    _IDLabel = [YYLabel new];
    _IDLabel.origin = CGPointMake(aLabel.left, kWinnerImagePadding+13+5);
    _IDLabel.size = CGSizeMake(self.width-(_winnerImgView.right+5)-5, 13);
    _IDLabel.font = defaultFont;
    _IDLabel.textColor = defaultColor;
    _IDLabel.text = [NSString stringWithFormat:@"用户IP：%@",winner.user_ip];
    [view addSubview:_IDLabel];
    [_IDLabel sizeToFit];
    
    _periodNumberLabel = [YYLabel new];
    _periodNumberLabel.origin = CGPointMake(aLabel.left, _IDLabel.bottom+5);
    _periodNumberLabel.size = CGSizeMake(self.width-(_winnerImgView.right+5)-5, 13);
    _periodNumberLabel.font = defaultFont;
    _periodNumberLabel.textColor = defaultColor;
    _periodNumberLabel.text = [NSString stringWithFormat:@"商品期数:%@",winner.qishu];
    [view addSubview:_periodNumberLabel];
    [_periodNumberLabel sizeToFit];
    
    _totalLabel = [YYLabel new];
    _totalLabel.origin = CGPointMake(aLabel.left, _periodNumberLabel.bottom+5);
    _totalLabel.size = CGSizeMake(self.width-(_winnerImgView.right+5)-5, 13);
    NSString *str = [NSString stringWithFormat:@"本次参与:%@人次",winner.buynum];
    
    _totalLabel.attributedText = [Utils stringWith:str font1:defaultFont color1:defaultColor font2:defaultFont color2:kDefaultColor range:NSMakeRange(5, str.length-7)] ;
    [view addSubview:_totalLabel];
    [_totalLabel sizeToFit];
    
    _publishTimeLabel = [YYLabel new];
    _publishTimeLabel.origin = CGPointMake(aLabel.left, _totalLabel.bottom+5);
    _publishTimeLabel.size = CGSizeMake(self.width-(_winnerImgView.right+5)-5, 13);
    _publishTimeLabel.font = defaultFont;
    _publishTimeLabel.textColor = defaultColor;
    _publishTimeLabel.text = [NSString stringWithFormat:@"揭晓时间:%@",[Utils timeWith:winner.addtime]];
    [view addSubview:_publishTimeLabel];
    [_publishTimeLabel sizeToFit];

    _backImgView = [UIImageView new];
    _backImgView.origin = CGPointMake(0, _publishTimeLabel.bottom+20);
    _backImgView.size = CGSizeMake(self.width, kBackImageViewHeight);
    _backImgView.image = [UIImage imageWithStretchableName:@"winner_bottom_bg"];
    [view addSubview:_backImgView];
    
    _countDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _countDetailButton.origin = CGPointMake(self.width-kTreasureProgressViewCountButtonWidth-kTreasureDetailHeaderPadding, _backImgView.top+(kBackImageViewHeight-kTreasureProgressViewCountButtonHeight)/2.0);
    _countDetailButton.size = CGSizeMake(kTreasureProgressViewCountButtonWidth, kTreasureProgressViewCountButtonHeight);
    _countDetailButton.backgroundColor = [UIColor whiteColor];
    _countDetailButton.titleLabel.font = SYSTEM_FONT(14);
    _countDetailButton.layer.cornerRadius = 5;
    _countDetailButton.layer.masksToBounds = YES;
    _countDetailButton.layer.shouldRasterize = YES;
    _countDetailButton.layer.rasterizationScale = kScreenScale;
    [_countDetailButton setTitle:@"查看计算详情" forState:UIControlStateNormal];
    [_countDetailButton setTitleColor:kDefaultColor forState:UIControlStateNormal];
    [_countDetailButton addTarget:self action:@selector(countDetail) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_countDetailButton];
    
    _luckyNumberLabel = [YYLabel new];
    _luckyNumberLabel.origin = CGPointMake(kWinnerImagePadding, _backImgView.top+(kBackImageViewHeight-16)/2.0);
    _luckyNumberLabel.size = CGSizeMake(self.width-kWinnerImagePadding*2, 16);
    NSString *numeber = [NSString stringWithFormat:@"幸运号码:%@",winner.wincode];
    _luckyNumberLabel.attributedText = [Utils stringWith:numeber font1:SYSTEM_FONT(14) color1:[UIColor whiteColor] font2:SYSTEM_FONT(18) color2:[UIColor whiteColor] range:NSMakeRange(5, numeber.length-5)];
    [view addSubview:_luckyNumberLabel];
    [_luckyNumberLabel sizeToFit];

    view.backgroundColor = UIColorHex(0xFBF1ED);
    view.height = _backImgView.bottom;
    view.layer.shadowColor = UIColorHex(333333).CGColor;
    view.layer.shadowOpacity = 0.3;
    
    self.height = _backImgView.bottom+top;
}

- (void)countDetail {
    if (_block) {
        _block();
    }
}

#pragma mark - public
- (void)start {
    [_countDownLabel start];
}

@end

