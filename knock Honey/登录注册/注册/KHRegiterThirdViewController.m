//
//  KHRegiterThirdViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/10/27.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHRegiterThirdViewController.h"
#import <MJExtension.h>

@interface KHRegiterThirdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation KHRegiterThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _loginButton.layer.cornerRadius = 5;
    _loginButton.layer.masksToBounds = YES;
    self.title = @"注册";
}
- (IBAction)loginAccount:(id)sender {
    if (![Utils validatePassword:_password.text]) {
        [MBProgressHUD showError:@"请设置正确的验证码"];
        return;
    }
    NSMutableDictionary *parameters = [Utils parameter];
    parameters[@"mobile"] = _phone;
    parameters[@"password"] = _password.text;
    [YWHttptool GET:PortMobile_regist parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"isError"] integerValue]) return ;
        YWUser *user = [YWUser mj_objectWithKeyValues:responseObject[@"result"]];
        [YWUserTool saveAccount:user];
        [MBProgressHUD showSuccess:@"登录成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"freshenPerson" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
       
    } failure:^(NSError *error){
    }];

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
