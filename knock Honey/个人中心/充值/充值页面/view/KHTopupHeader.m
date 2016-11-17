//
//  KHTopupHeader.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/1.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHTopupHeader.h"


@interface KHTopupHeader()<UITextFieldDelegate>
{
    UIButton *_selectedButton;
    CGFloat kHeaderButtonWidth;
}
@property (nonatomic,strong) UIImageView *headerImage;

@property (nonatomic,strong) UILabel *userNameLabel;

@property (nonatomic,strong) UILabel *moneyLabel;

@property (nonatomic, strong) NSArray *amountArray;

@property (nonatomic,strong) UIView *btnContainer;
@end

const CGFloat kHeaderButtonHeight = 40.0;
const CGFloat kHeaderButtonPadding = 15.0;

@implementation KHTopupHeader

- (NSArray *)amountArray {
    if (!_amountArray) {
        _amountArray = @[@[@"20",@"50"],@[@"100",@"200"],@[@"500",@"其他金额"]];
    }
    return _amountArray;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorHex(f3f3f3);
        [self setupPerson];
        kHeaderButtonWidth = (kScreenWidth-(self.amountArray.count+1)*kHeaderButtonPadding)/self.amountArray.count;
        [self setupCommit];
    }
    return self;
}

- (void)setupPerson{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 75)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    YWUser *user = [YWUserTool account];
    _headerImage = [UIImageView new];
    _headerImage.origin = CGPointMake(20, 12);
    _headerImage.size = CGSizeMake(50, 50);
    
    _headerImage.layer.cornerRadius = 5;
    _headerImage.layer.masksToBounds = YES;
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:user.img] placeholderImage:[UIImage imageNamed:@"kongren"]];
    [view addSubview:_headerImage];
    
    _userNameLabel = [UILabel new];
    _userNameLabel.origin = CGPointMake(_headerImage.right+10, _headerImage.top+3);
    _userNameLabel.size = CGSizeMake(KscreenWidth - _userNameLabel.left, 20);
    _userNameLabel.font = [UIFont boldSystemFontOfSize:16];
    _userNameLabel.text = [NSString stringWithFormat:@"抢号:%@",user.username];
    [view addSubview:_userNameLabel];
    
    _moneyLabel = [UILabel new];
    _moneyLabel.origin = CGPointMake(_headerImage.right+10,_userNameLabel.bottom+5);
    _moneyLabel.size = CGSizeMake(KscreenWidth - _userNameLabel.left, 20);
    _moneyLabel.font = [UIFont boldSystemFontOfSize:16];
    _moneyLabel.text = [NSString stringWithFormat:@"抢币:%@",user.money];
    [view addSubview:_moneyLabel];
    
}


- (void)setupCommit{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 80, KscreenWidth, 160)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    UILabel *chooseLabel = [UILabel new];
    chooseLabel.origin = CGPointMake(15, 15);
    chooseLabel.size = CGSizeMake(kScreenWidth-15*2, 18);
    chooseLabel.text = @"选择充值金额";
    chooseLabel.font = SYSTEM_FONT(14);
    [view addSubview:chooseLabel];
    
    _btnContainer = [[UIView alloc]initWithFrame:({
        CGRect rect = {0,chooseLabel.bottom,kScreenWidth,kHeaderButtonHeight*2+kHeaderButtonPadding*3};
        rect;
    })];
    _btnContainer.backgroundColor = [UIColor whiteColor];
    for (int j=0; j<2; j++) {
        for (int i=0; i<3; i++) {
            if (i*j==2) {
                UITextField *field = [[UITextField alloc]initWithFrame:({
                    CGRect rect = {kHeaderButtonPadding*(i+1)+kHeaderButtonWidth*i, kHeaderButtonPadding*(j+1)+kHeaderButtonHeight*j,kHeaderButtonWidth, kHeaderButtonHeight};
                    rect;
                })];
                field.tag = 888;
                field.font = SYSTEM_FONT(15);
                field.placeholder = _amountArray[i][j];
                field.layer.borderWidth = CGFloatFromPixel(2);
                field.layer.borderColor = UIColorHex(96959a).CGColor;
                field.textAlignment = NSTextAlignmentCenter;
                field.delegate = self;
                field.clearButtonMode = UITextFieldViewModeWhileEditing;
                field.keyboardType = UIKeyboardTypeNumberPad;
                [_btnContainer addSubview:field];
            } else {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.layer.borderWidth = CGFloatFromPixel(2);
                button.layer.borderColor = UIColorHex(96959a).CGColor;
                button.titleLabel.font = SYSTEM_FONT(15);
                button.origin = CGPointMake(kHeaderButtonPadding*(i+1)+kHeaderButtonWidth*i, kHeaderButtonPadding*(j+1)+kHeaderButtonHeight*j);
                button.size = CGSizeMake(kHeaderButtonWidth, kHeaderButtonHeight);
                [button setTitleColor:UIColorHex(96959a) forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [button addTarget:self action:@selector(chooseMoney:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitle:_amountArray[i][j] forState:UIControlStateNormal];
                [_btnContainer addSubview:button];
            }
        }
    }
    [view addSubview:_btnContainer];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, view.bottom+5, KscreenWidth, 25)];
    view2.backgroundColor = [UIColor whiteColor];
    [self addSubview:view2];
    
    YYLabel *wayLabel = [YYLabel new];
    wayLabel.origin = CGPointMake(15, 5);
    wayLabel.size = CGSizeMake(kScreenWidth-15*2, 15);
    wayLabel.text = @"选择支付方式";
    wayLabel.font = SYSTEM_FONT(13);
    [view2 addSubview:wayLabel];
    
    self.height = view2.bottom+1;
}

- (void)chooseMoney:(UIButton *)sender {
    [self endEditing:YES];
    UITextField *textField = [_btnContainer viewWithTag:888];
    textField.layer.borderColor = UIColorHex(96959a).CGColor;
    
    _selectedButton.selected = NO;
    _selectedButton.userInteractionEnabled = YES;
    _selectedButton.backgroundColor = [UIColor whiteColor];
    _selectedButton.layer.borderColor = UIColorHex(96959a).CGColor;
    
    sender.selected = !sender.selected;
    sender.userInteractionEnabled = NO;
    sender.layer.borderColor = kDefaultColor.CGColor;
    sender.backgroundColor = kDefaultColor;
    _selectedButton = sender;
    _coinAmount = [_selectedButton titleForState:UIControlStateNormal].numberValue;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.layer.borderColor = kDefaultColor.CGColor;
    _selectedButton.selected = NO;
    _selectedButton.userInteractionEnabled = YES;
    _selectedButton.layer.borderColor = UIColorHex(96959a).CGColor;
    _selectedButton.backgroundColor = [UIColor whiteColor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.layer.borderColor = kDefaultColor.CGColor;
    _coinAmount = textField.text.numberValue;
}













@end
