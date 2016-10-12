//
//  KHDetailViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/12.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHDetailViewController.h"

@interface KHDetailViewController ()

@end

@implementation KHDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavi];
}

- (void)createNavi{
    self.title = @"奖品详情";
    [self setRightImageNamed:@"share" action:@selector(share)];
    
}

//分享
- (void)share{
    
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
