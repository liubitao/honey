//
//  KHTabbarViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/10.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHTabbarViewController.h"
#import "KHHomeViewController.h"
#import "KHKnowViewController.h"
#import "KHCartViewController.h"
#import "KHAppearViewController.h"
#import "KHPersonViewController.h"
#import "KHNavigationViewController.h"

@interface KHTabbarViewController ()

@end

@implementation KHTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup{
    KHHomeViewController *homeVC = [[KHHomeViewController alloc]init];
    KHNavigationViewController *homeNavi = [[KHNavigationViewController alloc]initWithRootViewController:homeVC];
    homeNavi.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"夺宝" image:[UIImage imageNamed:@"tabbarHome"] selectedImage:[UIImage imageWithOriginalName:@"tabbarHomesel"]];
    [homeNavi.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName :kDefaultColor} forState:UIControlStateSelected];
    
    KHKnowViewController *knowVC = [[KHKnowViewController alloc]init];
    KHNavigationViewController *knowNavi = [[KHNavigationViewController alloc]initWithRootViewController:knowVC];
    knowNavi.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"最新揭晓" image:[UIImage imageNamed:@"tabbarknow"] selectedImage:[UIImage imageWithOriginalName:@"tabbarknowsel"]];
    [knowNavi.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName :kDefaultColor} forState:UIControlStateSelected];
    
    KHCartViewController *cartVC = [[KHCartViewController alloc]init];
    KHNavigationViewController *cartNavi = [[KHNavigationViewController alloc]initWithRootViewController:cartVC];
    cartNavi.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"晒单" image:[UIImage imageNamed:@"tabbarappear"] selectedImage:[UIImage imageWithOriginalName:@"tabbarappearsel"]];
    [cartNavi.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName :kDefaultColor} forState:UIControlStateSelected];
    
    KHAppearViewController *appearVC = [[KHAppearViewController alloc]init];
    KHNavigationViewController *appearNavi = [[KHNavigationViewController alloc]initWithRootViewController:appearVC];
    appearNavi.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"购物车" image:[UIImage imageNamed:@"tabbarcart"] selectedImage:[UIImage imageWithOriginalName:@"tabbarcartsel"]];
    [appearNavi.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName :kDefaultColor} forState:UIControlStateSelected];
    
    KHPersonViewController *personVC = [[KHPersonViewController alloc]init];
    KHNavigationViewController *personNavi = [[KHNavigationViewController alloc]initWithRootViewController:personVC];
    personNavi.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"个人中心" image:[UIImage imageNamed:@"tabbarperson"] selectedImage:[UIImage imageWithOriginalName:@"tabbarpersonsel"]];
    [personNavi.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName :kDefaultColor} forState:UIControlStateSelected];
    
    self.viewControllers = @[homeNavi,knowNavi,appearNavi,cartNavi,personNavi];
    
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
