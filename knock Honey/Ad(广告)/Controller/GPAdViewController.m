//
//  GPAdViewController.m
//  GPHandMade
//
//  Created by dandan on 16/5/29.
//  Copyright © 2016年 dandan. All rights reserved.
//

#import "GPAdViewController.h"
#import "KHTabbarViewController.h"
#import "KHcartModel.h"

@interface GPAdViewController ()

@property (strong, nonatomic) UIImageView *adImageView;
@property (strong,nonatomic) NSTimer *timer;

@end

@implementation GPAdViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupAdimage];
}

- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
}

- (void)setupAdimage
{
    _adImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KscreenHeight)];
    _adImageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:_adImageView];
    
    NSDictionary *parameter = [Utils parameter];
    [YWHttptool GET:PortFirst_banner parameters:parameter success:^(id responseObject) {
        [self.adImageView sd_setImageWithURL:[NSURL URLWithString:responseObject[@"url"]]];
        _timer  = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeAdImageView) userInfo:nil repeats:NO];
    } failure:^(NSError *error) {
           _timer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeAdImageView) userInfo:nil repeats:NO];
    }];
    
}

-(void)removeAdImageView
{
    [UIView animateWithDuration:0.3f animations:^{
        self.adImageView.transform = CGAffineTransformMakeScale(1.5f,1.5f);
        self.adImageView.alpha = 0.f;
    } completion:^(BOOL finished) {
         [UIApplication sharedApplication].keyWindow.rootViewController = [[KHTabbarViewController alloc]init];
        [self cartNumber];
    }];
    
}

//购物车中的商品数
- (void)cartNumber{
    if ([YWUserTool account]) {
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
