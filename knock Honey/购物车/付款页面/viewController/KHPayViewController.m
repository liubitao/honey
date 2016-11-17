//
//  KHPayViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/8.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHPayViewController.h"
#import <MJExtension.h>
#import "KHPayResultViewController.h"
#import "KHPauGoodsModel.h"


@interface KHPayViewController ()
@property (weak, nonatomic) IBOutlet UILabel  *payNumber;
@property (weak, nonatomic) IBOutlet UILabel  *discountLabel;

@property (weak, nonatomic) IBOutlet UILabel  *yueLabel;
@property (weak, nonatomic) IBOutlet UIButton *yueButton;
@property (weak, nonatomic) IBOutlet UILabel  *payNumber2;

@property (weak, nonatomic) IBOutlet UIButton *weixinButton;
@property (weak, nonatomic) IBOutlet UIButton *zhifubaoButton;
@property (weak, nonatomic) IBOutlet UIButton *submit;

@end

@implementation KHPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    _submit.layer.cornerRadius = 5;
    _submit.layer.masksToBounds = YES;
    
    [self setData]; 
}

- (void)setData{
    //钱包余额
    NSInteger total = [self.payModel.money integerValue];
    //支付金额（减去红包）
    NSInteger order_amount = [self.payModel.order_amount integerValue];
    //抵扣红包
    NSInteger red_Price = [self.payModel.red_price integerValue];
    
    _payNumber.text = [NSString stringWithFormat:@"%ld抢币",(order_amount+red_Price)];
    _discountLabel.text = [NSString stringWithFormat:@"-%ld抢币",red_Price];
    _yueLabel.text = [NSString stringWithFormat:@"余额支付(余额:%ld抢币)",total];
    
    if (total >= order_amount) {
        _payType = KHPayTypeCanPay;
        _payNumber2.text = [NSString stringWithFormat:@"%ld枪币",order_amount];
        [_yueButton setSelected:YES];
    }else if(1<=total<order_amount){
        _payType = KHPayTypeAddPay;
        _payNumber2.text = [NSString stringWithFormat:@"%ld枪币",(order_amount-total)];
        [_yueButton setSelected:YES];
        [_weixinButton setSelected:YES];
    }else{
        _payType = KHPayTypeNoPay;
        _payNumber2.text = [NSString stringWithFormat:@"%ld枪币",order_amount];
        [_weixinButton setSelected:YES];
    }
    
}
- (IBAction)yueClick:(UIButton *)sender {
    //钱包余额
    NSInteger total = [self.payModel.money integerValue];
    //支付金额（减去红包）
    NSInteger order_amount = [self.payModel.order_amount integerValue];
    switch (_payType) {
        case KHPayTypeCanPay:
            if (!sender.isSelected) {
                sender.selected = !sender.isSelected;
                _weixinButton.selected = NO;
                _zhifubaoButton.selected = NO;
            }
            break;
        case KHPayTypeAddPay:
            sender.selected = !sender.isSelected;
            if (sender.isSelected) {
                _payNumber2.text = [NSString stringWithFormat:@"%ld枪币",(order_amount-total)];
            }else{
                 _payNumber2.text = [NSString stringWithFormat:@"%@抢币",self.payModel.order_amount];
            }
            break;
        case KHPayTypeNoPay:
            break;
        default:
            break;
    }
}
- (IBAction)weixinClick:(UIButton *)sender {
     if (sender.isSelected) {
         return;
     }
    switch (_payType) {
        case KHPayTypeCanPay:{
                sender.selected = !sender.isSelected;
                _yueButton.selected = NO;
                _zhifubaoButton.selected = NO;
            }
            break;
        case KHPayTypeAddPay: {
                sender.selected = !sender.isSelected;
                _zhifubaoButton.selected = NO;
            }
            break;
        case KHPayTypeNoPay:{
           
                sender.selected = !sender.isSelected;
                _zhifubaoButton.selected = NO;
        }
        default:
            break;
    }
}
- (IBAction)zhifubaoClick:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    switch (_payType) {
        case KHPayTypeCanPay:{
            sender.selected = !sender.isSelected;
            _yueButton.selected = NO;
            _weixinButton.selected = NO;
        }
            break;
        case KHPayTypeAddPay: {
            sender.selected = !sender.isSelected;
            _weixinButton.selected = NO;
        }
            break;
        case KHPayTypeNoPay:{
            sender.selected = !sender.isSelected;
            _weixinButton.selected = NO;
        }
        default:
            break;
    }
}
- (IBAction)submit:(id)sender {//支付
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"pay_mode"] = @1;
    dict[@"user_money"] = self.payModel.order_amount;
    dict[@"red_price"] = self.payModel.red_price;
    dict[@"couponid"] = self.payModel.couponid;
    dict[@"goods_price"] = @(self.payModel.order_amount.integerValue +self.payModel.red_price.integerValue);
    dict[@"order_amount"] = self.payModel.order_amount;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    parameter[@"order"] = jsonString;
    
    NSMutableArray *array = [NSMutableArray array];

    for (KHPauGoodsModel *Paumodel in self.payModel.goods) {
        NSMutableDictionary *PuauDict = Paumodel.mj_keyValues;
        PuauDict[@"goodsid"] = PuauDict[@"id"];
        [array addObject:PuauDict];
    }
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString2 = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    
    parameter[@"goods"] = jsonString2;
    
  
    [MBProgressHUD showMessage:@"支付中..." toView:self.view];
    [YWHttptool GET:PortOrder_pay parameters:parameter success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"isError"] integerValue]) return ;
        NSString *str = responseObject[@"result"][@"money"];
        KHPayResultModel *model = [KHPayResultModel kh_objectWithKeyValues:responseObject[@"result"]];
        KHPayResultViewController *resultVC = [[KHPayResultViewController alloc]init];
        resultVC.resultmodel = model;
        [self hideBottomBarPush:resultVC];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCart" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kTopupNotification" object:str];
    } failure:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"支付失败"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
