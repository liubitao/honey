//
//  KHForgetViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/12/6.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHForgetViewController.h"
#import "PooCodeView.h"

@interface KHForgetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *telPhoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *passWordLabel;
@property (weak, nonatomic) IBOutlet UITextField *numberLabel;
@property (weak, nonatomic) IBOutlet PooCodeView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *telCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *subimt;

@end

@implementation KHForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    _subimt.layer.cornerRadius = 5;
    _subimt.layer.masksToBounds = YES;
}
//改变电话验证码
- (IBAction)changeTel:(UIButton *)sender {
    if (![Utils validateMobile:_telPhoneLabel.text]) {
        [UIAlertController showAlertViewWithTitle:@"提示" Message:@"手机号码格式不对" BtnTitles:@[@"知道了"] ClickBtn:nil];
        return;
    }
    [Utils timeDecrease:sender];
    NSMutableDictionary *parameters = [Utils parameter];
    parameters[@"mobile"] = _telPhoneLabel.text;
    [YWHttptool GET:PortCode_send parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"result"][@"status"] integerValue] == 2) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注册失败" message:@"号码已经被被绑定"  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        [MBProgressHUD showSuccess:@"已发送"];
    } failure:^(NSError *error) {
    }];

}
//图形验证码
- (IBAction)changeCode:(id)sender {
    [_codeView changeCode];
}
//密码隐藏
- (IBAction)seeClear:(id)sender {
    _passWordLabel.secureTextEntry = !_passWordLabel.secureTextEntry;
}

- (IBAction)subimtData:(id)sender {
    if (![Utils validateMobile:_telPhoneLabel.text]) {
        [UIAlertController showAlertViewWithTitle:@"提示" Message:@"手机号码格式不对" BtnTitles:@[@"知道了"] ClickBtn:nil];
        return;
    }
    if ([_numberLabel.text compare:_codeView.changeString
                        options:NSCaseInsensitiveSearch | NSNumericSearch] != NSOrderedSame) {
        [MBProgressHUD showError:@"图形验证码错误"];
        return;
    }
    if ([Utils isNull:_telCodeLabel.text]) {
        [MBProgressHUD showError:@"短信验证码错误"];
        return;
    }
    if (![Utils validatePassword:_passWordLabel.text]) {
        [MBProgressHUD showError:@"请设置数字和英文的密码"];
        return;
    }
    NSMutableDictionary *parameters = [Utils parameter];
    parameters[@"mobile"] = _telPhoneLabel.text;
    parameters[@"code"] = _telCodeLabel.text;
    [YWHttptool GET:PortDuanxin_check parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"result"][@"status"] integerValue] == 1) {
            NSMutableDictionary *parameters = [Utils parameter];
            parameters[@"mobile"] = _telPhoneLabel.text;
            parameters[@"password"] = [[NSString stringWithFormat:@"YWTEAM%@",_passWordLabel.text]MD5Digest];
            [YWHttptool GET:PortPwd_change parameters:parameters success:^(id responseObject) {
                if ([responseObject[@"result"][@"status"] integerValue] == 1||[responseObject[@"result"][@"status"] integerValue] == 0) {
                    [self.navigationController popViewControllerAnimated:YES];
                    return;
                }
            } failure:^(NSError *error) {
            }];
            return ;
        }
        [MBProgressHUD showError:responseObject[@"result"][@"msg"]];
    } failure:^(NSError *error) {
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
