//
//  KHEditPhoneViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/4.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHEditPhoneViewController.h"

@interface KHEditPhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber2;
@property (weak, nonatomic) IBOutlet UITextField *QQnumber;
@property (weak, nonatomic) IBOutlet UITextField *QQnumber2;
@property (weak, nonatomic) IBOutlet UIButton *saveBtton;

@end

@implementation KHEditPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _saveBtton.layer.cornerRadius = 5;
    _saveBtton.layer.masksToBounds = YES;
    self.title = @"添加号码";
    if (_editType == KHPhoneEdit) {
        self.title = @"编辑号码";
        _phoneNumber.text = _model.czmobile;
        _QQnumber.text = _model.czqq;
    }
}

- (IBAction)save:(id)sender {
    [self.view endEditing:YES];
    if (![Utils validateMobile:_phoneNumber.text]) {
        [MBProgressHUD showError:@"手机号码格式不对"];
        return;
    }
    if ([Utils isNull:_QQnumber.text]) {
        [MBProgressHUD showError:@"请填写QQ号码"];
        return;
    }
    if (![_phoneNumber.text isEqualToString:_phoneNumber2.text]||![_QQnumber.text isEqualToString:_QQnumber2.text]) {
        [MBProgressHUD showError:@"号码不一致"];
        return;
    }
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"act"] = _editType == KHPhoneEdit ? @"edit":@"add";
    dict[@"id"] = _model.ID;
    dict[@"type"] = @2;
    dict[@"czmobile"] = _phoneNumber.text;
    dict[@"czqq"] = _QQnumber.text;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    parameter[@"address"] = jsonString;
    
    [YWHttptool Post:PortAddress_handle parameters:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"isError"] integerValue]){
            [MBProgressHUD showError:@"保存失败"];
            return ;
        }
        [UIAlertController showAlertViewWithTitle:nil Message:@"保存成功" BtnTitles:@[@"确定"] ClickBtn:^(NSInteger index) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSError *error){
        [MBProgressHUD showError:@"保存失败"];
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
