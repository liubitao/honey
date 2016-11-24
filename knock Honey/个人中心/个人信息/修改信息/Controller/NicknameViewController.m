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
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    parameter[@"username"] = _nameField.text;
    [YWHttptool GET:PortChange_username parameters:parameter success:^(id responseObject) {
        if ([responseObject[@"result"][@"status"] integerValue] == 1) {
            YWUser *user = [YWUserTool account];
            user.username = _nameField.text;
            [YWUserTool saveAccount:user];
            [self.navigationController popViewControllerAnimated:YES];
            if (_nicknameBlock) {
                _nicknameBlock(_nameField.text);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"freshenPerson" object:nil];
            [MBProgressHUD showSuccess:@"修改成功"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"修改失败"];
    }];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
