//
//  KHRegiterViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/10/27.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHRegiterViewController.h"
#import "PooCodeView.h"
#import "KHRegiterSecondController.h"

@interface KHRegiterViewController ()<UITextFieldDelegate>
{
    NSString    *_previousTextFieldContent;
    UITextRange *_previousSelection;
}
@property (weak, nonatomic) IBOutlet UITextField *userPhone;
@property (weak, nonatomic) IBOutlet UITextField *validateCode;
@property (weak, nonatomic) IBOutlet PooCodeView *validatePic;
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation KHRegiterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _registerButton.layer.cornerRadius = 5;
    _registerButton.layer.masksToBounds = YES;
    
    [self setLeftItemTitle:@"取消" action:@selector(pop)];
    self.title = @"注册";
    NSString *remindStr = @"距离获得新手礼包还有2步！";
    _remindLabel.attributedText = [Utils stringWith:remindStr font1:SYSTEM_FONT(14) color1:UIColorHex(51B2EA) font2:SYSTEM_FONT(14) color2:kDefaultColor range:NSMakeRange(10, 1)];
    
    _userPhone.delegate = self;
    //当编辑改变的时候，进行字符校验
    [self.userPhone addTarget:self action:@selector(reformatAsPhoneNumber:) forControlEvents:UIControlEventEditingChanged];
}


- (void)pop{
    [self dismissViewControllerAnimated:YES completion:nil];
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


- (IBAction)changeCode:(id)sender {
       [_validatePic changeCode];
}
- (IBAction)registerAcoount:(id)sender {
    NSMutableString *string = [NSMutableString stringWithString:_userPhone.text];
    [string deleteCharactersInRange:NSMakeRange(3, 1)];
    [string deleteCharactersInRange:NSMakeRange(7, 1)];
    
    if (![Utils validateMobile:string]) {
        [MBProgressHUD showError:@"手机号码填写有误"];
        return;
    }
    
    if ([_validateCode.text compare:_validatePic.changeString
                             options:NSCaseInsensitiveSearch | NSNumericSearch] != NSOrderedSame) {
        [MBProgressHUD showError:@"图形验证码错误"];
        return;
    }
    NSMutableDictionary *parameters = [Utils parameter];
    parameters[@"mobile"] = string;
    
    [YWHttptool GET:PortDuanxin_send parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"result"][@"status"] integerValue] == 2) {
            [self.view endEditing:YES];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注册失败" message:@"号码已经被注册"  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"去登陆" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                 [self.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancel];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        KHRegiterSecondController *secondVC = [[KHRegiterSecondController alloc]init];
        secondVC.phone = string;
        [self pushController:secondVC];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
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
