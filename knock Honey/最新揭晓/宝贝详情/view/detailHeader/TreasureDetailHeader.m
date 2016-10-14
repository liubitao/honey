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

@property (nonatomic, strong) YYLabel *productNameLabel;

//商品图片
@property (nonatomic, strong) NSArray *images;

@end

@implementation TreasureDetailHeader

+ (CGFloat)getHeight {
    return kScreenWidth*2;
}

- (NSArray *)images {
    if (!_images) {
        _images = @[@"1",
                    @"2",
                    @"3"];
    }
    return _images;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:({
            CGRect rect = {0,0,kScreenWidth,kScreenWidth/375*200};
            rect;
        })];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.images.count*kScreenWidth, kScreenWidth/375*200);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [_images enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                              NSUInteger idx,
                                              BOOL * _Nonnull stop) {
            UIImageView *imgView = [UIImageView new];
            imgView.tag = idx;
            imgView.userInteractionEnabled = YES;
            imgView.image = IMAGE_NAMED(_images[idx]);
            imgView.origin = CGPointMake(idx*kScreenWidth, 0);
            imgView.size = CGSizeMake(_scrollView.width, _scrollView.height);
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            [_scrollView addSubview:imgView];
        }];
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:({
            CGRect rect = {0,kScreenWidth/375*200-kTreasureDetailHeaderPageControlHeight,kScreenWidth,kTreasureDetailHeaderPageControlHeight};
            rect;
        })];
        _pageControl.numberOfPages = self.images.count;
        _pageControl.currentPageIndicatorTintColor = kDefaultColor;
        _pageControl.pageIndicatorTintColor = UIColorHex(666666);
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

- (instancetype)initWithFrame:(CGRect)frame
                         type:(TreasureDetailHeaderType)type
                    countTime:(NSInteger)countTime {
    self = [super initWithFrame:frame];
    if (self) {
        _count = countTime;
        _type = type;
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
    NSMutableAttributedString *name = [[NSMutableAttributedString alloc]initWithString:@"Apple Watch Sport 42毫米 铝金属表壳 运动表带 颜色随机"];
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
    }) type:_type countTime:_count];
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
}

//点击声明
- (void)clickDeclare:(UIButton *)sender{
    if (self.declareBlcok) {
        self.declareBlcok();
    }
}

#pragma mark - TSCountLabelDelegate
- (void)countdownDidEnd {
    _treasureProgressView.type = TreasureDetailHeaderTypeWon;
    [self setNeedsLayout];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControl.currentPage = scrollView.contentOffset.x/kScreenWidth;
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
const CGFloat kWinnerImagePadding = 15.0;
const CGFloat kBackImageViewHeight = 45.0;

@implementation TreasureProgressView

- (instancetype)initWithFrame:(CGRect)frame
                         type:(TreasureDetailHeaderType)type
                    countTime:(NSInteger)countTime {
    self = [super initWithFrame:frame];
    if (self) {
        _countTime = countTime;
        _type = type;
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
            _periodNumberLabel.text = @"商品期号：306131836";
            [self addSubview:_periodNumberLabel];
            
            //进度条
            _progressView = [[TSProgressView alloc] initWithFrame:({
                CGRect rect = {0,_periodNumberLabel.bottom+kTreasureDetailHeaderPadding,self.width,10};
                rect;
            })];
            _progressView.progress = (1588/2588.0) *100.0;
            [self addSubview:_progressView];
            
            _rightLabel = [YYLabel new];
            _rightLabel.origin = CGPointMake(self.width/2, _progressView.bottom+kTreasureDetailHeaderPadding);
            _rightLabel.size = CGSizeMake(self.width/2, 12);
            NSString *rightStr = @"剩余1000人次";
            _rightLabel.attributedText = [Utils stringWith:rightStr font1:SYSTEM_FONT(12) color1:UIColorHex(999999) font2:SYSTEM_FONT(12) color2:kDefaultColor range:NSMakeRange(2, rightStr.length-4)];
            _rightLabel.textAlignment = NSTextAlignmentRight;
            [self addSubview:_rightLabel];
            
            _totalLabel = [YYLabel new];
            _totalLabel.origin = CGPointMake(0, _progressView.bottom+kTreasureDetailHeaderPadding);
            _totalLabel.size = CGSizeMake(self.width/2, 12);
            _totalLabel.font = SYSTEM_FONT(12);
            NSString *totalStr = @"总需2588人次";
            _totalLabel.attributedText = [Utils stringWith:totalStr font1:SYSTEM_FONT(12) color1:UIColorHex(999999) font2:SYSTEM_FONT(12) color2:UIColorHex(7cade8) range:NSMakeRange(2, totalStr.length-4)];
            [self addSubview:_totalLabel];
            
            [self setupWinnerView:_totalLabel.bottom+20];
        }
            break;
        case TreasureDetailHeaderTypeCountdown:{//倒计时
            self.backgroundColor = kDefaultColor;
            _periodNumberLabel = [YYLabel new];
            _periodNumberLabel.origin = CGPointMake(5, 15);
            _periodNumberLabel.size = CGSizeMake(self.width-kTreasureProgressViewCountButtonWidth, 12);
            _periodNumberLabel.font = SYSTEM_FONT(12);
            _periodNumberLabel.textColor = [UIColor whiteColor];
            _periodNumberLabel.text = @"商品期号：306131836";
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
    
    _winnerImgView = [UIImageView new];
    _winnerImgView.origin = CGPointMake(kWinnerImagePadding, kWinnerImagePadding+top);
    _winnerImgView.size = CGSizeMake(kWinnerImageWidth, kWinnerImageWidth);
    _winnerImgView.image = IMAGE_NAMED(@"touxiang");
    [self addSubview:_winnerImgView];
    
    YYLabel *aLabel = [YYLabel new];
    aLabel.origin = CGPointMake(_winnerImgView.right+10, _winnerImgView.top);
    aLabel.size = CGSizeMake(self.width-(_winnerImgView.right+5)-5, 13);
    aLabel.font = defaultFont;
    aLabel.text = @"获奖者：";
    aLabel.textColor = defaultColor;
    aLabel.numberOfLines = 0;
    [self addSubview:aLabel];
    [aLabel sizeToFit];
    
    _winnerLabel = [YYLabel new];
    _winnerLabel.origin = CGPointMake(aLabel.right, _winnerImgView.top);
    _winnerLabel.size = CGSizeMake(self.width-aLabel.right, 13);
    _winnerLabel.font = defaultFont;
    _winnerLabel.text = @"我被坑了";
    _winnerLabel.textColor = UIColorHex(7cade8);
    _winnerLabel.numberOfLines = 1;
    [self addSubview:_winnerLabel];
    [_winnerLabel sizeToFit];

    _IDLabel = [YYLabel new];
    _IDLabel.origin = CGPointMake(aLabel.left, _winnerLabel.bottom+5);
    _IDLabel.size = CGSizeMake(self.width-(_winnerImgView.right+5)-5, 13);
    _IDLabel.font = defaultFont;
    _IDLabel.textColor = defaultColor;
    _IDLabel.text = @"用户IP：10.1.1.1";
    [self addSubview:_IDLabel];
    [_IDLabel sizeToFit];
    
    _addressLabel = [YYLabel new];
    _addressLabel.origin = CGPointMake(_IDLabel.right+15, _winnerLabel.bottom+5);
    _addressLabel.size = CGSizeMake(self.width-aLabel.right, 13);
    _addressLabel.font = defaultFont;
    _addressLabel.text = @"(浙江杭州)";
    _addressLabel.textColor = UIColorHex(a0d791);
    _addressLabel.numberOfLines = 1;
    [self addSubview:_addressLabel];
    [_addressLabel sizeToFit];
    
    _periodNumberLabel = [YYLabel new];
    _periodNumberLabel.origin = CGPointMake(aLabel.left, _IDLabel.bottom+5);
    _periodNumberLabel.size = CGSizeMake(self.width-(_winnerImgView.right+5)-5, 13);
    _periodNumberLabel.font = defaultFont;
    _periodNumberLabel.textColor = defaultColor;
    _periodNumberLabel.text = @"商品期数：30981005";
    [self addSubview:_periodNumberLabel];
    [_periodNumberLabel sizeToFit];
    
    _totalLabel = [YYLabel new];
    _totalLabel.origin = CGPointMake(aLabel.left, _periodNumberLabel.bottom+5);
    _totalLabel.size = CGSizeMake(self.width-(_winnerImgView.right+5)-5, 13);
    NSString *str = @"本期参与：1000人次";
    
    _totalLabel.attributedText = [Utils stringWith:str font1:defaultFont color1:defaultColor font2:defaultFont color2:kDefaultColor range:NSMakeRange(4, str.length-6)] ;
    [self addSubview:_totalLabel];
    [_totalLabel sizeToFit];
    
    _publishTimeLabel = [YYLabel new];
    _publishTimeLabel.origin = CGPointMake(aLabel.left, _totalLabel.bottom+5);
    _publishTimeLabel.size = CGSizeMake(self.width-(_winnerImgView.right+5)-5, 13);
    _publishTimeLabel.font = defaultFont;
    _publishTimeLabel.textColor = defaultColor;
    _publishTimeLabel.text = @"揭晓时间：2016-06-10 14:15:16";
    [self addSubview:_publishTimeLabel];
    [_publishTimeLabel sizeToFit];

    _backImgView = [UIImageView new];
    _backImgView.origin = CGPointMake(0, _publishTimeLabel.bottom+20);
    _backImgView.size = CGSizeMake(self.width, kBackImageViewHeight);
    _backImgView.image = [UIImage imageWithStretchableName:@"winner_bottom_bg"];
    [self addSubview:_backImgView];
    
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
    [self addSubview:_countDetailButton];
    
    _luckyNumberLabel = [YYLabel new];
    _luckyNumberLabel.origin = CGPointMake(kWinnerImagePadding, _backImgView.top+(kBackImageViewHeight-16)/2.0);
    _luckyNumberLabel.size = CGSizeMake(self.width-kWinnerImagePadding*2, 16);
    NSString *numeber = @"幸运号码:10004038";
    _luckyNumberLabel.attributedText = [Utils stringWith:numeber font1:SYSTEM_FONT(14) color1:[UIColor whiteColor] font2:SYSTEM_FONT(18) color2:[UIColor whiteColor] range:NSMakeRange(4, numeber.length-4)];
    [self addSubview:_luckyNumberLabel];
    [_luckyNumberLabel sizeToFit];

    self.backgroundColor = UIColorHex(0xFBF1ED);
    self.height = _backImgView.bottom;
    self.layer.shadowColor = UIColorHex(333333).CGColor;
    self.layer.shadowOpacity = 0.3;
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

