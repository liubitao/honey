//
//  KHRegiterSecondController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/10/27.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHRegiterSecondController.h"
#import "KHRegiterThirdViewController.h"

@interface KHRegiterSecondController ()
@property (weak, nonatomic) IBOutlet UILabel *userPhone;
@property (weak, nonatomic) IBOutlet UITextField *phoneCode;
@property (weak, nonatomic) IBOutlet UIButton *daojishi;
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;


@end

@implementation KHRegiterSecondController

- (void)viewDidLoad {
    [super viewDidLoad];
    _submitButton.layer.cornerRadius = 5;
    _submitButton.layer.masksToBounds = YES;
    self.title = @"注册";
    NSString *remindStr = @"距离获得新手礼包还有1步！";
    _remindLabel.attributedText = [Utils stringWith:remindStr font1:SYSTEM_FONT(14) color1:UIColorHex(51B2EA) font2:SYSTEM_FONT(14) color2:kDefaultColor range:NSMakeRange(10, 1)];
    _userPhone.text = [NSString stringWithFormat:@"短信验证码已发送到%@",_phone];
    [Utils timeDecrease:_daojishi];

}
- (IBAction)downTime:(UIButton *)sender {
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"发送验证码"]) {
        NSMutableDictionary *parameters = [Utils parameter];
        parameters[@"mobile"] = _phone;
        [YWHttptool GET:PortDuanxin_send parameters:parameters success:^(id responseObject) {
            [MBProgressHUD showSuccess:@"已发送"];
             [Utils timeDecrease:sender];
        } failure:^(NSError *error) {
        }];

    }
}
- (IBAction)submitCode:(id)sender{
    if (![Utils validateVerifyCode:_phoneCode.text]) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    
    NSMutableDictionary *parameters = [Utils parameter];
    parameters[@"mobile"] = _phone;
    parameters[@"code"] = _phoneCode.text;
    [YWHttptool GET:PortDuanxin_check parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"result"][@"status"] integerValue] == 1) {
            KHRegiterThirdViewController *thirdVC = [[KHRegiterThirdViewController alloc]init];
            thirdVC.phone = _phone;
            [self hideBottomBarPush:thirdVC];
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
