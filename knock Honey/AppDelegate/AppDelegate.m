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
#import <UMSocialCore/UMSocialCore.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "KHZhifubaoModel.h"
#import <MJExtension.h>
#import "AdvertiseHelper.h"
#import <RongIMKit/RongIMKit.h>
#import "IQKeyboardManager.h"


@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    KHTabbarViewController *tabbarVC =[[KHTabbarViewController alloc]init];
    self.window.rootViewController = tabbarVC;
    [self.window makeKeyAndVisible];
    
    //启动广告（记得放最后，才可以盖在页面上面）
    [self setupAdveriseView];
    
    
    [self cartNumber];
    
    [self configApper];
    
    //接收通知
    [self receiverNO];

    //友盟
    [self configUM];
    
    //融云
    [self configRongCloud];

    //微信支付
    [WXApi registerApp:@"wx1bf9134fbd335945" withDescription:@"knockHoney"];
    
    [self configureBoardManager];
    return YES;
}

- (void)receiverNO{
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartNumber) name:@"loginPerson" object:nil];
}

#pragma mark 启动广告
-(void)setupAdveriseView
{
    // TODO 请求广告接口 获取广告图片
    NSDictionary *parameter = [Utils parameter];
    [AdvertiseHelper showAdvertiserView];
    [YWHttptool GET:PortFirst_banner parameters:parameter success:^(id responseObject) {
        [[AdvertiseHelper sharedInstance] getAdvertisingImage:responseObject[@"url"]];
    } failure:^(NSError *error){
    }];
    
}

- (void)configApper{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [UINavigationBar appearance].titleTextAttributes = navbarTitleTextAttributes;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].barTintColor = kDefaultColor;
}

- (void)configRongCloud{
    [[RCIM sharedRCIM] initWithAppKey:@"8w7jv4qb8flvy"];
    if ([YWUserTool account]) {
        NSMutableDictionary *parameter = [Utils parameter];
        parameter[@"userid"] = [YWUserTool account].userid;
        [YWHttptool GET:PortRongcloud parameters:parameter success:^(id responseObject) {
            if ([responseObject[@"isError"] integerValue] == 0) {
                NSString *str = responseObject[@"result"][@"token"];
                [[RCIM sharedRCIM] connectWithToken:str success:nil error:nil tokenIncorrect:nil];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)configUM{
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMsocialAppKey];

    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:UMWeixinAppID   appSecret:UMWeixinAPPsecret redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:UMQQAppID  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:UMWeiboAppKey appSecret:UMWeiboAppsecret redirectURL:UMWeiboUrl];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
    }
    return result;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSData *data = [resultDic[@"result"] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSNotification *notification = [NSNotification notificationWithName:@"ORDER_PAY_NOTIFICATION" object:@"zhifubao" userInfo:weatherDic];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }];
        return YES;
    }else{
        [WXApi handleOpenURL:url delegate:self];
        return [[UMSocialManager defaultManager] handleOpenURL:url];
    
    }
}

/*发送一个sendReq后，收到微信的回应收到一个来自微信的处理结果。 
 * 调用一次sendReq后会收到onResp。 
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。 
 * @param resp具体的回应内容，是自动释放的 
 */
- (void)onResp:(BaseResp *)resp{
    //支付返回结果，实际支付结果需要去微信服务器端查询
    NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
    switch (resp.errCode) {
        case WXSuccess:{
            strMsg = @"支付结果：成功！";
            NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
            NSNotification *notification = [NSNotification notificationWithName:@"ORDER_PAY_NOTIFICATION" object:@"success"];
            
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
            break;
        default:{
            strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
            NSNotification *notification = [NSNotification notificationWithName:@"ORDER_PAY_NOTIFICATION" object:@"fail"];
            
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
           
            break;
    }
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

-(void)configureBoardManager
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.keyboardDistanceFromTextField=5;
    manager.enableAutoToolbar = NO;
}

//购物车中的商品数
- (void)cartNumber{
    [self configRongCloud];
    
    if ([YWUserTool account]){
        NSMutableDictionary *parameter = [Utils parameter];
        parameter[@"userid"] = [YWUserTool account].userid;
        [YWHttptool GET:PortIndex parameters:parameter success:^(id responseObject) {
            if ([responseObject[@"isError"] integerValue]) return ;
            NSMutableArray *mutableArray = [KHcartModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
            [AppDelegate getAppDelegate].value = mutableArray.count;
            KHTabbarViewController *tabbarVC = (KHTabbarViewController *)[AppDelegate getAppDelegate].window.rootViewController;
            [tabbarVC.tabBar setBadgeValue:[AppDelegate getAppDelegate].value AtIndex:3];
        } failure:^(NSError *error) {
        }];
    }else{
        [AppDelegate getAppDelegate].value = 0;
    }
}

@end
