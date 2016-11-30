//
//  KH snatchListController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/10/31.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHSnatchListController.h"
#import "KHMeListViewController.h"

@implementation KHSnatchListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"夺宝纪录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setRightImageNamed:@"tenCart" action:@selector(gotoCart)];
    [self setItemBadge:[AppDelegate getAppDelegate].value];
    // 初始化样式
    [self setupView];
    // 添加子控制器
    [self addAllChildVc];
}

- (void)gotoCart{
    [self.tabBarController setSelectedIndex:3];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - 初始化子控件
- (void)setupView
{
    // 设置标题栏样式
    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight) {
        *titleScrollViewColor = [UIColor whiteColor];
        *norColor = [UIColor blackColor];
        *titleFont = SYSTEM_FONT(15);
        *selColor = kDefaultColor;
        *titleHeight = 46;
    }];
    
    // 设置下标
    [self setUpUnderLineEffect:^(BOOL *isShowUnderLine, BOOL *isDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor) {
        *isShowUnderLine = YES;
        *underLineColor = kDefaultColor;
    }];
}
- (void)addAllChildVc{
    KHMeListViewController *allVC = [[KHMeListViewController alloc]init];
    allVC.title = @"全部";
    allVC.type = @"0";
    [self addChildViewController:allVC];
    
    KHMeListViewController *ingVC= [[KHMeListViewController alloc]init];
    ingVC.title = @"进行中";
    ingVC.type = @"1";
    [self addChildViewController:ingVC];
    
    KHMeListViewController *edVC = [[KHMeListViewController alloc]init];
    edVC.title = @"已揭晓";
    edVC.type = @"2";
    [self addChildViewController:edVC];
    
}

@end
