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
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>


@interface AppDelegate ()<WXApiDelegate,UNUserNotificationCenterDelegate>

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
    
    //友盟推送
    [self pushWithOptions:(NSDictionary *)launchOptions];

    //微信支付
    [WXApi registerApp:@"wx1bf9134fbd335945" withDescription:@"knockHoney"];
    
    [self configureBoardManager];
    
    //每次启动刷新个人数据
    [self refreshPerson];
    return YES;
}

- (void)pushWithOptions:(NSDictionary *)launchOptions{
    //初始化方法,也可以使用(void)startWithAppkey:(NSString *)appKey launchOptions:(NSDictionary * )launchOptions httpsenable:(BOOL)value;这个方法，方便设置https请求。
    [UMessage startWithAppkey:@"582167c9aed17960b30009d4" launchOptions:launchOptions];
    
    //添加别名(addAlias)
    if ([YWUserTool account]) {
        [UMessage addAlias:[YWUserTool account].userid type:@"ywteam" response:^(id responseObject, NSError *error) {
        }];
    }
  
    
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    
    //for log
    [UMessage setLogEnabled:YES];
}


//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
}


//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
    
}


- (void)receiverNO{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartNumber) name:@"loginPerson" object:nil];
}

#pragma mark 启动广告
-(void)setupAdveriseView{
    // TODO 请求广告接口 获取广告图片
    NSDictionary *parameter = [Utils parameter];
    [AdvertiseHelper showAdvertiserView];
    [YWHttptool GET:PortFirst_banner parameters:parameter success:^(id responseObject) {
        [[AdvertiseHelper sharedInstance] getAdvertisingImage:responseObject[@"result"]];
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


// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
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
            }
        if ([url.host isEqualToString:@"pay"]){
               return [WXApi handleOpenURL:url delegate:self];
            }
        return result;
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
    
    //添加别名(addAlias)
    if ([YWUserTool account]) {
        [UMessage addAlias:[YWUserTool account].userid type:@"ywteam" response:^(id responseObject, NSError *error) {
        }];
    }
    
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

- (void)refreshPerson{
    if ([YWUserTool account]){
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    [YWHttptool GET:PortOther_user parameters:parameter success:^(id responseObject) {
        if ([responseObject[@"isError"] integerValue]) return ;
        YWUser *user = [YWUser mj_objectWithKeyValues:responseObject[@"result"]];
        [YWUserTool saveAccount:user];
    } failure:^(NSError *error) {
    }];
    }
}

@end
