//
//  KHBounsViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/9.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHBounsViewController.h"
#import "KHUserAbleViewController.h"
#import "KHUseredViewController.h"


@interface KHBounsViewController ()

@end

@implementation KHBounsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红包";
    self.view.backgroundColor = [UIColor whiteColor];
    // 初始化样式
    [self setupView];
    // 添加子控制器
    [self addAllChildVc];
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
        *underLineColor = kDefaultColor;
    }];
}
- (void)addAllChildVc{
    KHUserAbleViewController *userableVC = [[KHUserAbleViewController alloc]init];
    userableVC.title = @"未使用";
    [self addChildViewController:userableVC];

    KHUseredViewController *useredVC = [[KHUseredViewController alloc]init];
    useredVC.title = @"已使用/过期";
    [self addChildViewController:useredVC];
    
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
