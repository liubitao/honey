//
//  KHLoginViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/10/27.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHLoginViewController.h"
#import "PooCodeView.h"
#import "KHRegiterViewController.h"
#import "KHNavigationViewController.h"
#import <MJExtension.h>


@interface KHLoginViewController ()<UITextFieldDelegate>
{
    NSString    *_previousTextFieldContent;
    UITextRange *_previousSelection;
}
@property (weak, nonatomic) IBOutlet UITextField *userPhone;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *validateCode;
@property (weak, nonatomic) IBOutlet PooCodeView *validatePic;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation KHLoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _loginButton.layer.cornerRadius = 5;
    _loginButton.layer.masksToBounds = YES;
    [self setLeftItemTitle:@"取消" action:@selector(pop)];
    self.title = @"登录";
    
    _userPhone.delegate = self;
    //当编辑改变的时候，进行字符校验
    [self.userPhone addTarget:self action:@selector(reformatAsPhoneNumber:) forControlEvents:UIControlEventEditingChanged];
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

- (void)pop{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  换验证码
 */
- (IBAction)changeCode:(id)sender {
    [_validatePic changeCode];
}
/**
 *  登录
 */
- (IBAction)loginAccount:(id)sender {
    if ([Utils isNull:_userPhone.text] || [Utils isNull:_passWord.text]) {
        [MBProgressHUD showError:@"账号或密码不能为空"];
        return;
    }
    if (![_validateCode.text compare:_validatePic.changeString
                   options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame) {
        [MBProgressHUD showError:@"图形验证码错误"];
        return;
    }
    
    NSMutableDictionary *parameters = [Utils parameter];
    NSMutableString *string = [NSMutableString stringWithString:_userPhone.text];
    [string deleteCharactersInRange:NSMakeRange(3, 1)];
    [string deleteCharactersInRange:NSMakeRange(7, 1)];
    parameters[@"mobile"] = string;
    parameters[@"password"] = [[NSString stringWithFormat:@"YWTEAM%@",_passWord.text] MD5Digest];
    [YWHttptool GET:PortLogin parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"isError"] integerValue]) return ;
        
        YWUser *user = [YWUser mj_objectWithKeyValues:responseObject[@"result"]];
        [YWUserTool saveAccount:user];
        [MBProgressHUD showSuccess:@"登录成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不佳"];
    }];
}

/**
 *  注册
 */
- (IBAction)registerAccount:(id)sender {
    KHRegiterViewController *regiterVC = [[KHRegiterViewController alloc]init];
    [self hideBottomBarPush:regiterVC];
}
/**
 *  忘记密码
 */
- (IBAction)forgetPassword:(id)sender {
}
/**
 *  第三方登录
 */
- (IBAction)loginWithThird:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
