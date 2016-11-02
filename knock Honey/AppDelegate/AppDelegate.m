//
//  AppDelegate.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/9.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "AppDelegate.h"
#import "KHTabbarViewController.h"
#import "KHcartModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    KHTabbarViewController *tabbarVC = [[KHTabbarViewController alloc]init];
    self.window.rootViewController = tabbarVC;
    [self.window makeKeyAndVisible];
    
    [self configApper];

    //购物车中的商品数
    [self cartNumber];
    
    return YES;
}

- (void)configApper{
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [UINavigationBar appearance].titleTextAttributes = navbarTitleTextAttributes;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].barTintColor = kDefaultColor;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (AppDelegate *)getAppDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

//购物车中的商品数
- (void)cartNumber{
    if ([YWUserTool account]) {
        NSMutableDictionary *parameter = [Utils parameter];
        parameter[@"userid"] = [YWUserTool account].userid;
        [YWHttptool GET:PortIndex parameters:parameter success:^(id responseObject) {
            if ([responseObject[@"isError"] integerValue]) return ;
            NSMutableArray *mutableArray = [KHcartModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
            _value = mutableArray.count;
        } failure:^(NSError *error) {
        }];
    }else{
            _value = 0;
    }
}

@end
