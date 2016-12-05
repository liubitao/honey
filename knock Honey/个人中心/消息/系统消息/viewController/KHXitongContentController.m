//
//  KHXitongContentController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/30.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHXitongContentController.h"

@interface KHXitongContentController ()

@end

@implementation KHXitongContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息内容";
    _contentLabel.text = _content;
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
