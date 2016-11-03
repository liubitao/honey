//
//  NicknameViewController.m
//  WinTreasure
//
//  Created by Apple on 16/6/22.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import "NicknameViewController.h"

@interface NicknameViewController ()


@end

@implementation NicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改昵称";
    self.view.backgroundColor = UIColorHex(0xe5e5e5);
    [self setRightItemTitle:@"确定" action:@selector(confirm)];
}

- (void)confirm {
    if (![Utils validateNickname:_nameField.text]) {
        [MBProgressHUD showError:@"请输入正确的昵称"];
        return;
    }
    [self submit];
    if (_nicknameBlock) {
        _nicknameBlock(_nameField.text);
    }
}

- (void)submit{
    [UIAlertController showAlertViewWithTitle:nil Message:@"保存成功" BtnTitles:@[@"确定"] ClickBtn:^(NSInteger index) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
