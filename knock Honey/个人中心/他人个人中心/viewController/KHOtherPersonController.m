//
//  KHOtherPersonController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/28.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHOtherPersonController.h"
#import "KHMeListViewController.h"
#import "KHMyAppearViewController.h"

@interface KHOtherPersonController ()
@property (nonatomic,strong) KHOtherHeaderView *headerView;
@end

@implementation KHOtherPersonController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"他人个人中心";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    [self setRightImageNamed:@"tenCart" action:@selector(gotoCart)];
    [self setItemBadge:[AppDelegate getAppDelegate].value];
    // 初始化样式
    [self setupView];
    
    [self addChildVC];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

- (void)gotoCart{
    [self.tabBarController setSelectedIndex:3];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - 初始化子控件
- (void)setupView{
    _headerView = [[KHOtherHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 190) model:_model];
    [self.view insertSubview:_headerView atIndex:0];
    
    self.isfullScreen = NO;
    [self setUpContentViewFrame:^(UIView *contentView) {
        contentView.frame = CGRectMake(0, 190, kScreenWidth, KscreenHeight - 190);
    }];
    
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

- (void)addChildVC{
    KHMeListViewController *allVC = [[KHMeListViewController alloc]init];
    allVC.otherType = YES;
    allVC.title = @"夺宝纪录";
    allVC.type = @"0";
    allVC.userID = _userID;

    [self addChildViewController:allVC];
    
    KHMeListViewController *ingVC= [[KHMeListViewController alloc]init];
    ingVC.otherType = YES;
    ingVC.title = @"中奖纪录";
    ingVC.type = @"1";
    ingVC.userID = _userID;
    [self addChildViewController:ingVC];
    
    KHMyAppearViewController *edVC = [[KHMyAppearViewController alloc]init];
    edVC.otherType = YES;
    edVC.title = @"晒单记录";
    edVC.userID = _userID;
    [self addChildViewController:edVC];
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
