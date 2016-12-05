//
//  KHPhoneViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/3.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHPhoneViewController.h"
#import "PooCodeView.h"

@interface KHPhoneViewController ()<UITextFieldDelegate>
{
    NSString    *_previousTextFieldContent;
    UITextRange *_previousSelection;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *valiCode;
@property (weak, nonatomic) IBOutlet UITextField *phoneValiCode;
@property (weak, nonatomic) IBOutlet PooCodeView *pooCode;
@property (weak, nonatomic) IBOutlet UIButton *valiButton;

@end

@implementation KHPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _phoneText.delegate = self;
    //当编辑改变的时候，进行字符校验
    [self.phoneText addTarget:self action:@selector(reformatAsPhoneNumber:) forControlEvents:UIControlEventEditingChanged];
}
-(void)reformatAsPhoneNumber:(UITextField *)textField {
    /**
     *  判断正确的光标位置
     */
    NSUInteger targetCursorPostion = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
    NSString *phoneNumberWithoutSpaces = [self removeNonDigits:textField.text andPreserveCursorPosition:&targetCursorPostion];
    
    
    if([phoneNumberWithoutSpaces length]>11) {
        /**
         *  避免超过11位的输入
         */
        
        [textField setText:_previousTextFieldContent];
        textField.selectedTextRange = _previousSelection;
        
        return;
    }
    
    
    NSString *phoneNumberWithSpaces = [self insertSpacesEveryFourDigitsIntoString:phoneNumberWithoutSpaces andPreserveCursorPosition:&targetCursorPostion];
    
    textField.text = phoneNumberWithSpaces;
    UITextPosition *targetPostion = [textField positionFromPosition:textField.beginningOfDocument offset:targetCursorPostion];
    [textField setSelectedTextRange:[textField textRangeFromPosition:targetPostion toPosition:targetPostion]];
    
}

/**
 *  除去非数字字符，确定光标正确位置
 *
 *  @param string         当前的string
 *  @param cursorPosition 光标位置
 *
 *  @return 处理过后的string
 */
- (NSString *)removeNonDigits:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition {
    NSUInteger originalCursorPosition =*cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString new];
    
    for (NSUInteger i=0; i<string.length; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        
        if(isdigit(characterToAdd)) {
            NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
            [digitsOnlyString appendString:stringToAdd];
        }
        else {
            if(i<originalCursorPosition) {
                (*cursorPosition)--;
            }
        }
    }
    return digitsOnlyString;
}

/**
 *  将空格插入我们现在的string 中，并确定我们光标的正确位置，防止在空格中
 *
 *  @param string         当前的string
 *  @param cursorPosition 光标位置
 *
 *  @return 处理后有空格的string
 */
- (NSString *)insertSpacesEveryFourDigitsIntoString:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition{
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger cursorPositionInSpacelessString = *cursorPosition;
    
    for (NSUInteger i=0; i<string.length; i++) {
        if(i>0)
        {
            if(i==3 || i==7) {
                [stringWithAddedSpaces appendString:@"-"];
                
                if(i<cursorPositionInSpacelessString) {
                    (*cursorPosition)++;
                }
            }
        }
        
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    return stringWithAddedSpaces;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    _previousSelection = textField.selectedTextRange;
    _previousTextFieldContent = textField.text;
    
    if(range.location==0) {
        if(string.integerValue >1)
        {
            return NO;
        }
    }
    
    return YES;
}

//修改验证码
- (IBAction)valiCodeClick:(id)sender {
    [_pooCode changeCode];
    
}
- (IBAction)phoneClick:(id)sender {
    [Utils timeDecrease:sender];
    NSMutableDictionary *parameters = [Utils parameter];
    NSMutableString *string = [NSMutableString stringWithString:_phoneText.text];
    [string deleteCharactersInRange:NSMakeRange(3, 1)];
    [string deleteCharactersInRange:NSMakeRange(7, 1)];
    parameters[@"mobile"] = string;
    [YWHttptool GET:PortDuanxin_send parameters:parameters success:^(id responseObject) {
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
- (IBAction)savePhone:(id)sender {
    if ([_valiCode.text compare:_pooCode.changeString
                             options:NSCaseInsensitiveSearch | NSNumericSearch] != NSOrderedSame) {
        [MBProgressHUD showError:@"图形验证码错误"];
        return;
    }
    if ([Utils isNull:_phoneText.text] || [Utils isNull:_phoneValiCode.text]) {
        [MBProgressHUD showError:@"账号或密码不能为空"];
        return;
    }
    
    NSMutableDictionary *parmeter = [Utils parameter];
    parmeter[@"code"] = _phoneValiCode.text;
    NSMutableString *string = [NSMutableString stringWithString:_phoneText.text];
    [string deleteCharactersInRange:NSMakeRange(3, 1)];
    [string deleteCharactersInRange:NSMakeRange(7, 1)];
    parmeter[@"mobile"] = string;
    parmeter[@"userid"] = [YWUserTool account].userid;
    [YWHttptool GET:PortBinding_mobile parameters:parmeter success:^(id responseObject) {
        if ([responseObject[@"result"][@"status"] integerValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
            YWUser *user = [YWUserTool account];
            user.mobile = string;
            [YWUserTool saveAccount:user];
            if (_phoneBlock) {
                _phoneBlock(string);
            }
            [MBProgressHUD showSuccess:@"修改成功"];
        }
        [MBProgressHUD showError:@"短信验证码输入错误"];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"修改失败"];
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
