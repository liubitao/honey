//
//  KHAppearDetailController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/10/26.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHAppearDetailController.h"
#import "KHAppearDetailView.h"
#import "KHLoginViewController.h"
#import "BtButton.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialUIManager.h"


@interface KHAppearDetailController ()
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation KHAppearDetailController

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:({
            CGRect rect = {5,70,kScreenWidth-10,kScreenHeight-kNavigationBarHeight-10};
            rect;
        })];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"晒单详情";
    self.view.backgroundColor = UIColorHex(efeff4);
    [self setRightImageNamed:@"share" action:@selector(share)];
    [self.view addSubview:self.scrollView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    KHAppearDetailView *detailView = [[KHAppearDetailView alloc]initWithFrame:({
        CGRect rect = {0,0,kScreenWidth-10,1};
        rect;
    }) model:_AppearModel];
    detailView.ClickBlcok = ^(BtButton * button ,KHAppearDetailModel *model){//点赞
       
        if (![YWUserTool account]) {//判断是不是登录状态
            KHLoginViewController *vc = [[KHLoginViewController alloc]init];
            KHNavigationViewController *nav = [[KHNavigationViewController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
            return;
        }
        NSMutableDictionary *parameter = [Utils parameter];
        parameter[@"userid"] = [YWUserTool account].userid;
        parameter[@"commentid"] = _AppearModel.ID;
        [YWHttptool GET:PortComment_support parameters:parameter success:^(id responseObject) {
            if (![responseObject[@"result"][@"status"] integerValue]){
                [MBProgressHUD showSuccess:@"已点赞"];
                return ;
            }
            [MBProgressHUD showSuccess:@"点赞成功"];
            [button setImage:[UIImage imageNamed:@"zanSelect"] title:[NSString stringWithFormat:@"(%zi)",model.support.integerValue+1] forState:UIControlStateNormal];
            
            if (self.block){
                self.block();
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"点赞失败"];
        }];
    };
    
    [self.scrollView addSubview:detailView];
    [MBProgressHUD hideHUD];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth-10, detailView.height);
}

/**
 *  分享
 */
- (void)share{
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"就是这么炫酷，随随便便又中奖了" descr:@"全场商品低至一元，手机电脑送送送" thumImage:[UIImage imageNamed:@"yunWang"]];
        //设置网页地址
        shareObject.webpageUrl =PortShareUrl;
        
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
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    NSLog(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    NSLog(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    NSLog(@"response data is %@",data);
                }
            }
            [UIAlertController showAlertViewWithTitle:@"提示" Message:result BtnTitles:@[@"确定"] ClickBtn:nil];
        }];
        
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
