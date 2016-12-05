//
//  KHQiandaoViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/14.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHQiandaoViewController.h"
#import "YHWebViewProgressView.h"
#import "YHWebViewProgress.h"

@interface KHQiandaoViewController ()<UIWebViewDelegate>
{
    BOOL first;
}
@property (strong, nonatomic) YHWebViewProgress *progressProxy;
@end

@implementation KHQiandaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    first = YES;
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    webView.delegate = self;

    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
    
    [self.view addSubview:webView];
    
    // 创建进度条代理，用于处理进度控制
    _progressProxy = [[YHWebViewProgress alloc] init];
    
    // 创建进度条
    YHWebViewProgressView *progressView = [[YHWebViewProgressView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), CGRectGetWidth(self.view.bounds), 4)];
    progressView.progressBarColor = kDefaultColor;
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    
    // 设置进度条
    self.progressProxy.progressView = progressView;
    // 将UIWebView代理指向YHWebViewProgress
    webView.delegate = self.progressProxy;
    // 设置webview代理转发到self（可选）
    self.progressProxy.webViewProxy = self;
    
    // 添加到视图
    [self.view addSubview:progressView];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"%@",request);
    NSString *titleStrs = @"新手帮助,新手指南,签到,最新活动";
    if ([titleStrs containsString:self.title]) {
        return YES;
    }else if (first){
        first = NO;
        return YES;
    }else{
    NSString *str = [request.URL.absoluteString stringByRemovingPercentEncoding];
        NSRange range1 = [str rangeOfString:@"="];
        NSRange range2 = [str rangeOfString:@"&"];
        NSRange range3 = [str rangeOfString:@"'"];
        NSString *title = [str substringWithRange:NSMakeRange(range1.location+1, range2.location - range1.location-1)];
        NSString *url = [str substringWithRange:NSMakeRange(range3.location+1, str.length - range3.location-1-1)];
        KHQiandaoViewController *VC = [[KHQiandaoViewController alloc]init];
        VC.urlStr = url;
        VC.title = title;
        [self hideBottomBarPush:VC];
        NSLog(@"%@",str);
        return NO;
    }
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
