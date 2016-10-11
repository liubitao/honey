//
//  WinTreasureHeader.m
//  WinTreasure
//
//  Created by Apple on 16/6/1.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import "WinTreasureHeader.h"
#import "AdvertiseView.h"
#import "VerticalButton.h"
#import "TSMenu.h"

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
            button.origin = CGPointMake(idx*kScreenWidth/_menuImages.count, 0);
            button.size = CGSizeMake(kScreenWidth/_menuImages.count, kMenuButtonHeight);
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

@property (nonatomic, strong) TSMenu *selectMenu;

@property (nonatomic, strong) UIScrollView *imgScrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSArray *images;

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
            CGRect rect = {0,kScrollViewHeight-40,kScreenWidth,40};
            rect;
        })];
        _pageControl.numberOfPages = self.images.count;
        _pageControl.currentPageIndicatorTintColor = kDefaultColor;
        _pageControl.pageIndicatorTintColor = UIColorHex(666666);
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

- (NSArray *)images {
    if (!_images) {
        _images = @[@"1.jpg",
                    @"2.jpg",
                    @"3.jpg"];
    }
    return _images;
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
        _imgScrollView.contentSize = CGSizeMake(kScreenWidth*self.images.count, _imgScrollView.height);
        [self addSubview:_imgScrollView];
        for (int i=0; i<self.images.count; i++) {
            UIImageView *imgView = [UIImageView new];
            imgView.tag = i;
            imgView.userInteractionEnabled = YES;
            imgView.image = IMAGE_NAMED(_images[i]);
            imgView.origin = CGPointMake(i*kScreenWidth, 0);
            imgView.size = CGSizeMake(_imgScrollView.width, _imgScrollView.height);
            [_imgScrollView addSubview:imgView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
                if (_imageBlock) {
                    _imageBlock(sender);
                }
            }];
            [imgView addGestureRecognizer:tap];
        }
        [self addSubview:self.pageControl];
        [self addTimer];

        _menuView = [[TreasureMenuView alloc]initWithFrame:({
            CGRect rect = {0,_imgScrollView.bottom,self.width,kMenuButtonHeight};
            rect;
        })];
        _menuView.header = self;
        [self addSubview:_menuView];
    }
    return self;
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
    _menuBlock = block;
    @weakify(self);
    _menuView.block = ^(UIButton *sender){
        @strongify(self);
        if (self.menuBlock) {
            self.menuBlock(sender);
        }
    };
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _pageControl.currentPage = scrollView.contentOffset.x/kScreenWidth;
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
