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
    detailView.ClickBlcok = ^(){//点赞
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
