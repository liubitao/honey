//
//  KHAppearDetailController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/10/26.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHAppearDetailController.h"
#import "KHAppearDetailView.h"

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
    detailView.ClickBlcok = ^(){
        NSLog(@"zan");
    };
    
    [self.scrollView addSubview:detailView];
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
