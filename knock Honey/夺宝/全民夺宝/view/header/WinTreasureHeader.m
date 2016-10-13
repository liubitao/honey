//
//  WinTreasureHeader.m
//  WinTreasure
//
//  Created by Apple on 16/6/1.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import "WinTreasureHeader.h"
#import "VerticalButton.h"


const CGFloat kMenuButtonHeight = 75.0;
const CGFloat kScrollViewHeight = 140.0;


@interface TreasureMenuView ()

@property (nonatomic, strong) NSArray *menuImages;

@property (nonatomic, strong) NSArray *menuTitles;

@end

@implementation TreasureMenuView

- (NSArray *)menuImages {
    if (!_menuImages) {
        _menuImages = @[@"Activity",
                        @"prefecture",
                        @"lucky",
                        @"register"];
    }
    return _menuImages;
}

- (NSArray *)menuTitles {
    if (!_menuTitles) {
        _menuTitles = @[@"分类",@"10元专区",@"晒单",@"常见问题"];
    }
    return _menuTitles;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.menuImages enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                      NSUInteger idx,
                                                      BOOL * _Nonnull stop) {
            VerticalButton *button = [VerticalButton buttonWithType:UIButtonTypeCustom];
            button.tag = idx;
            button.origin = CGPointMake(idx*KscreenWidth/_menuImages.count, 0);
            button.size = CGSizeMake(KscreenWidth/_menuImages.count, kMenuButtonHeight);
            button.titleLabel.font = SYSTEM_FONT(12);
            [button setTitleColor:UIColorHex(999999) forState:UIControlStateNormal];
            [button setImage:IMAGE_NAMED(_menuImages[idx]) title:self.menuTitles[idx] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }];
    }
    return self;
}

#pragma mark - methods
- (void)selectItem:(UIButton *)sender {
    if (_block) {
        _block(sender);
    }
}

@end


@interface WinTreasureHeader () <UIScrollViewDelegate>



@property (nonatomic, strong) UIScrollView *imgScrollView;

@property (nonatomic, strong) UIPageControl *pageControl;



@property (nonatomic, strong) NSNumber *menuNumber;

@property (nonatomic, strong) NSTimer *timer;

@end


@implementation WinTreasureHeader

+ (CGFloat)height {
    return kScrollViewHeight+kMenuButtonHeight+1;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:({
            CGRect rect = {0,kScrollViewHeight-40,KscreenWidth,40};
            rect;
        })];
        
        _pageControl.currentPageIndicatorTintColor = kDefaultColor;
        _pageControl.pageIndicatorTintColor = UIColorHex(666666);
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorHex(0xEAE5E1);
        _imgScrollView = [[UIScrollView alloc]initWithFrame:({
            CGRect rect = {0,0,self.width,kScrollViewHeight};
            rect;
        })];
        _imgScrollView.delegate = self;
        _imgScrollView.pagingEnabled = YES;
        [self addSubview:_imgScrollView];
        
        [self addSubview:self.pageControl];
        [self addTimer];

        _menuView = [[TreasureMenuView alloc]initWithFrame:({
            CGRect rect = {0,_imgScrollView.bottom,self.width,kMenuButtonHeight};
            rect;
        })];
        [self addSubview:_menuView];
    }
    return self;
}

- (void)resetImage{
    for (UIView *object in _imgScrollView.subviews) {
        if([object isKindOfClass:[UIImageView class]]){
            [object removeFromSuperview];
        }
    }
    _imgScrollView.contentSize = CGSizeMake(KscreenWidth*self.images.count, _imgScrollView.height);
    
    for (int i=0; i<self.images.count; i++) {
        UIImageView *imgView = [UIImageView new];
        imgView.tag = i;
        imgView.userInteractionEnabled = YES;
        [imgView sd_setImageWithURL:[NSURL URLWithString:_images[i]] placeholderImage:[UIImage imageNamed:@"placeholder"]];;
        imgView.origin = CGPointMake(i*KscreenWidth, 0);
        imgView.size = CGSizeMake(_imgScrollView.width, _imgScrollView.height);
        [_imgScrollView addSubview:imgView];        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelect:)];
        [imgView addGestureRecognizer:tap];
    }
    
    _pageControl.numberOfPages = self.images.count;
}

- (void)didSelect:(UITapGestureRecognizer *)sender{
    if (_imageBlock) {
        _imageBlock(sender.view);
    }
}

- (void)addTimer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        return;
    }
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - timer
- (void)nextImage {
    int page = (int)self.pageControl.currentPage;
    if(page == _images.count-1){
        page = 0;
    }else{
        page++;
    }
    CGFloat X = page * _imgScrollView.frame.size.width;
    [_imgScrollView setContentOffset:CGPointMake(X, 0) animated:YES];
}

#pragma mark -

- (void)selectItem:(WinTreasureHeaderSelectItemBlock)block {
    _menuView.block = block;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _pageControl.currentPage = scrollView.contentOffset.x/KscreenWidth;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //打开定时器
    [self addTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //关闭定时器
    [self removeTimer];
}

@end
