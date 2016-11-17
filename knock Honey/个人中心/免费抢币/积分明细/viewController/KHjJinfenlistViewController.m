//
//  KHjJinfenlistViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/12.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHjJinfenlistViewController.h"
#import "KHGetJinfenViewController.h"
#import "KHUseJinfenViewController.h"

@interface KHjJinfenlistViewController ()

@end

@implementation KHjJinfenlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红包";
    self.view.backgroundColor = [UIColor whiteColor];
    // 初始化样式
    [self setupView];
    // 添加子控制器
    [self addAllChildVC];
}

#pragma mark - 初始化子控件
- (void)setupView
{
    // 设置标题栏样式
    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight) {
        *titleScrollViewColor = [UIColor whiteColor];
        *norColor = [UIColor blackColor];
        *titleFont = SYSTEM_FONT(16);
        *selColor = kDefaultColor;
        *titleHeight = 46;
    }];
    
    // 设置下标
    [self setUpUnderLineEffect:^(BOOL *isShowUnderLine, BOOL *isDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor) {
        *isShowUnderLine = YES;
        *underLineH = 3;
        *underLineColor = kDefaultColor;
    }];
}

- (void)addAllChildVC{
    KHGetJinfenViewController *getVC = [[KHGetJinfenViewController alloc]init];
    getVC.title = @"收益明细";
    [self addChildViewController:getVC];
    
    KHUseJinfenViewController *useVC = [[KHUseJinfenViewController alloc]init];
    useVC.title = @"兑换明细";
    [self addChildViewController:useVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
