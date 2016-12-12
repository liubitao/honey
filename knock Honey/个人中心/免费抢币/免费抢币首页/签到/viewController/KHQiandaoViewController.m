//
//  KHQiandaoViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/14.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHQiandaoViewController.h"
#import "YHWebViewProgressView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialUIManager.h"
#import <MJExtension.h>
#import "KHDetailViewController.h"
#import "KHTopupViewController.h"
#import "KHTenViewController.h"
#import <WebKit/WebKit.h>
#import "RCDCustomerServiceViewController.h"

@interface KHQiandaoViewController ()<WKNavigationDelegate>
{
    BOOL first;
}
@property (strong, nonatomic) WKWebView *webView;
@end

@implementation KHQiandaoViewController

- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    first = YES;
  
    [self.view addSubview:self.webView];
    
      [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
//    // 创建进度条
    YHWebViewProgressView *progressView = [[YHWebViewProgressView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.navigationController.navigationBar.frame), CGRectGetWidth(self.view.bounds), 4)];
    
    progressView.progressBarColor = kDefaultColor;
    [progressView useWkWebView:self.webView];
    
    // 添加到视图
    [self.view addSubview:progressView];
    
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString *titleStrs = @"新手帮助,新手指南,签到,最新活动,活动";
    if ([titleStrs containsString:self.title]){
        //        openpage
        //        1.分享—url,img
        //        2.商品详情—goodsid
        //        3.商品列表—cateid（从接口/Api/Goods/goods_cate获取数据）
        //        4.会员充值—money（0则不限充值金额,title）
        if ([navigationAction.request.URL.absoluteString containsString:@"openpage"]){
            NSString *decodedString=[navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
            NSRange range = [decodedString rangeOfString:@"parameter="];
            NSString *strJson = [decodedString substringFromIndex:range.location + range.length];
            NSString *parameter = [strJson stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
            NSRange rangePage = [decodedString rangeOfString:@"openpage="];
            NSString *openPage = [decodedString substringWithRange:NSMakeRange(rangePage.location+rangePage.length, 1)];
            NSInteger page = openPage.integerValue;
            NSData *jsonData = [parameter dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                 
                                                                options:NSJSONReadingMutableContainers
                                 
                                                                  error:&err];
            if (page == 1) {
                [self share:parameter];
            }else if (page == 2){
                [self goodsDetali:dic];
            }else if (page == 3){
                [self goodsArea:dic];
            }else if (page == 4){
                [self Recharge:dic];
            }
            decisionHandler(WKNavigationActionPolicyCancel);
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    }else if (first){
        first = NO;
         decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        NSString *str = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
        NSRange range1 = [str rangeOfString:@"="];
        NSRange range2 = [str rangeOfString:@"&"];
        NSRange range3 = [str rangeOfString:@"'"];
        NSString *title = [str substringWithRange:NSMakeRange(range1.location+1, range2.location - range1.location-1)];
        NSString *url = [str substringWithRange:NSMakeRange(range3.location+1, str.length - range3.location-1-1)];
        if ([title isEqualToString:@"5"]) {
                if ([YWUserTool account]) {
                    RCDCustomerServiceViewController *chatService = [[RCDCustomerServiceViewController alloc] init];
                    chatService.conversationType = ConversationType_CUSTOMERSERVICE;
                    chatService.targetId = KefuMessageID;
                    chatService.title = @"客服";
                    [self hideBottomBarPush:chatService];
                }else{
                    [MBProgressHUD showError:@"请先登录"];
                }
        }else{
        KHQiandaoViewController *VC = [[KHQiandaoViewController alloc]init];
        VC.urlStr = url;
        VC.title = title;
        [self hideBottomBarPush:VC];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}
//分享
- (void)share:(NSString *)para{
    NSData *jsonData = [para dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:nil];
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType){
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dic[@"img"]]];
        UIImage *image = [UIImage imageWithData:data];
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:dic[@"title"] descr:dic[@"content"] thumImage:image];
        //设置网页地址
        shareObject.webpageUrl = dic[@"url"];
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            NSString *result = nil;
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
                result = @"分享失败";
            }else{
                result = @"分享成功";
                if ([data isKindOfClass:[UMSocialShareResponse class]]){
                    
                    NSMutableDictionary *parameter = [Utils parameter];
                    parameter[@"userid"] = [YWUserTool account].userid;
                    parameter[@"parameter"] = para;
                    [YWHttptool Post:PortProm_handle parameters:parameter success:^(id responseObject) {
                        if (![responseObject[@"isError"] integerValue]) {
                             [self.webView reloadFromOrigin];
                        }
                    } failure:^(NSError *error){
      
                    }];
                }else{
                    NSLog(@"response data is %@",data);
                }
            }
            [UIAlertController showAlertViewWithTitle:@"提示" Message:result BtnTitles:@[@"确定"] ClickBtn:nil];
        }];
        
    }];
}

//商品详情
- (void)goodsDetali:(NSDictionary *)dic{
    [MBProgressHUD showMessage:@"加载中..."];
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"goodsid"] = dic[@"goodsid"];
    parameter[@"qishu"] = dic[@"qishu"];
    if ([YWUserTool account]) {
        parameter[@"userid"] = [YWUserTool account].userid;
    }
    [YWHttptool GET:PortGoodsdetails parameters:parameter success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if ([responseObject[@"isError"] integerValue])return;
        KHDetailViewController *DetailVC = [[KHDetailViewController alloc]init];
        DetailVC.model = [KHProductModel kh_objectWithKeyValues:responseObject[@"result"]];
        DetailVC.goodsid = dic[@"goodsid"];
        DetailVC.qishu = dic[@"qishu"];
        DetailVC.showType = TreasureDetailHeaderTypeNotParticipate;
        [self hideBottomBarPush:DetailVC];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];

}

//商品列表
- (void)goodsArea:(NSDictionary *)dic{
    KHTenViewController *VC = [[KHTenViewController alloc]init];
    VC.area = dic[@"cateid"];
    VC.port = PortGoods_cate;
    VC.title = dic[@"title"];
    [self hideBottomBarPush:VC];
}

//充值
- (void)Recharge:(NSDictionary *)dic{
    KHTopupViewController *topupVC = [[KHTopupViewController alloc]init];
    topupVC.money = dic[@"money"];
    topupVC.title = dic[@"title"];
    [self hideBottomBarPush:topupVC];
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
