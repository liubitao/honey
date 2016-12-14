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
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "KHQiandaoViewController.h"

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
    
    [self setRightImageNamed:@"cartHelp" action:@selector(rightClick)];
    
    [self setData]; 
}

- (void)rightClick{
    [UIAlertController showAlertViewWithTitle:nil Message:@"充值金额用于购买云网夺宝提供的网盘空间(1元等于1M)，同时获得相应个数的夺宝币，可以用于云网夺宝，充值的金额将无法退回" BtnTitles:@[@"确定"] ClickBtn:nil];
}
- (IBAction)clickXieyi:(UIButton *)sender {
    KHQiandaoViewController *VC = [[KHQiandaoViewController alloc]init];
    VC.urlStr = PortAgreement;
    VC.title = @"夺宝声明";
    [self hideBottomBarPush:VC];
}

- (void)viewWillAppear:(BOOL)animated{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:@"ORDER_PAY_NOTIFICATION" object:nil];//监听一个通知
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)getOrderPayResult:(NSNotification *)notification{
    if ([notification.object isEqualToString:@"zhifubao"]) {//支付宝回调
        if ([notification.userInfo[@"alipay_trade_app_pay_response"][@"msg"] isEqualToString:@"Success"]) {
            if (_hybridType == KHPayTypeAliPay) {
                [self paykind:@"3" pay_money:self.payModel.order_amount user_money:@"0" pay_code:notification.userInfo[@"alipay_trade_app_pay_response"][@"trade_no"]];
            }else if (_hybridType == KHPayTypeYueAliPay){
                [self paykind:@"3" pay_money:[NSString stringWithFormat:@"%zi",self.payModel.order_amount.integerValue- self.payModel.money.integerValue] user_money:self.payModel.money pay_code:notification.userInfo[@"alipay_trade_app_pay_response"][@"trade_no"]];
            }
        }else{
            [UIAlertController showAlertViewWithTitle:@"提示" Message:@"支付失败" BtnTitles:@[@"知道了"] ClickBtn:nil];
        }
    }else if ([notification.object isEqualToString:@"success"]){//微信回调
        if (_hybridType == KHPayTypeWeixinPay) {
            [self paykind:@"2" pay_money:self.payModel.order_amount user_money:@"0" pay_code:self.payModel.ordersn];
        }else if (_hybridType == KHPayTypeYueWeixinPay){
            [self paykind:@"2" pay_money:[NSString stringWithFormat:@"%zi",self.payModel.order_amount.integerValue- self.payModel.money.integerValue] user_money:self.payModel.money pay_code:self.payModel.ordersn];
        }
    }else{
         [UIAlertController showAlertViewWithTitle:@"提示" Message:@"支付失败" BtnTitles:@[@"知道了"] ClickBtn:nil];
     }
}


- (void)setData{
    //钱包余额
    NSInteger total = [self.payModel.money integerValue];
    //支付金额（减去红包）
    NSInteger order_amount = [self.payModel.order_amount integerValue];
    //抵扣红包
    NSInteger red_Price = [self.payModel.red_price integerValue];
    
    _payNumber.text = [NSString stringWithFormat:@"%zi抢币",(order_amount+red_Price)];
    if(red_Price == 0){
         _discountLabel.text = @"无可用";
    }else{
    _discountLabel.text = [NSString stringWithFormat:@"-%zi抢币",red_Price];
    }
    _yueLabel.text = [NSString stringWithFormat:@"余额支付(余额:%zi抢币)",total];
    
    if (total >= order_amount){
        _payType = KHPayTypeCanPay;
        _payNumber2.text = [NSString stringWithFormat:@"%zi抢币",order_amount];
        [_yueButton setSelected:YES];
        _hybridType = KHPayTypeYuePay;
    }else if(total > 0){
        _payType = KHPayTypeAddPay;
        _payNumber2.text = [NSString stringWithFormat:@"%zi抢币",(order_amount-total)];
        [_yueButton setSelected:YES];
        [_weixinButton setSelected:YES];
        _hybridType = KHPayTypeYueWeixinPay;
    }else{
        _payType = KHPayTypeNoPay;
        _payNumber2.text = [NSString stringWithFormat:@"%zi抢币",order_amount];
        [_weixinButton setSelected:YES];
        _hybridType = KHPayTypeWeixinPay;
        _yueButton.userInteractionEnabled = NO;
        _yueButton.enabled = NO;
    }
}

- (IBAction)yueClick:(UIButton *)sender{
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
                _hybridType = KHPayTypeYuePay;
            }
            break;
        case KHPayTypeAddPay:
            sender.selected = !sender.isSelected;
            if (sender.isSelected) {
                _payNumber2.text = [NSString stringWithFormat:@"%zi枪币",(order_amount-total)];
                _hybridType = _weixinButton.isSelected ? KHPayTypeYueWeixinPay:KHPayTypeYueAliPay;
            }else{
                 _payNumber2.text = [NSString stringWithFormat:@"%@抢币",self.payModel.order_amount];
               _hybridType = _weixinButton.isSelected ? KHPayTypeWeixinPay:KHPayTypeAliPay;
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
            _hybridType = KHPayTypeWeixinPay;
            }
            break;
        case KHPayTypeAddPay: {
                sender.selected = !sender.isSelected;
                _zhifubaoButton.selected = NO;
            _hybridType = KHPayTypeYueWeixinPay;
            }
            break;
        case KHPayTypeNoPay:{
                sender.selected = !sender.isSelected;
                _zhifubaoButton.selected = NO;
            _hybridType = KHPayTypeWeixinPay;
        }
        default:
            break;
    }
}

- (IBAction)zhifubaoClick:(UIButton *)sender{
    if (sender.isSelected) {
        return;
    }
    switch (_payType) {
        case KHPayTypeCanPay:{
            sender.selected = !sender.isSelected;
            _yueButton.selected = NO;
            _weixinButton.selected = NO;
            _hybridType = KHPayTypeAliPay;
        }
            break;
        case KHPayTypeAddPay: {
            sender.selected = !sender.isSelected;
            _weixinButton.selected = NO;
            _hybridType = KHPayTypeYueAliPay;
        }
            break;
        case KHPayTypeNoPay:{
            sender.selected = !sender.isSelected;
            _weixinButton.selected = NO;
            _hybridType = KHPayTypeAliPay;
        }
        default:
            break;
    }
}
- (IBAction)submit:(id)sender {//支付
    switch (_hybridType) {
        case KHPayTypeYuePay:{//余额支付
            [self paykind:@"1" pay_money:@"0" user_money:self.payModel.order_amount pay_code:@"0"];
        }
            break;
        case KHPayTypeWeixinPay:{//微信支付
            [self weixinPayOredersn:self.payModel.ordersn order_amount:_payNumber2.text user_money:@"0"];
        }
            break;
        case KHPayTypeAliPay:{//支付宝支付

            [self aliPayOredersn:self.payModel.ordersn order_amount:_payNumber2.text user_money:@"0"];
        }
            break;
        case KHPayTypeYueWeixinPay:{//微信和余额支付
            [self weixinPayOredersn:self.payModel.ordersn order_amount:_payNumber2.text user_money:self.payModel.money];
        }
            break;
        case KHPayTypeYueAliPay:{//支付宝和余额支付
               [self aliPayOredersn:self.payModel.ordersn order_amount:_payNumber2.text user_money:self.payModel.money];
        }
            break;
        default:
            break;
    }
   }

//微信支付
- (void)weixinPayOredersn:(NSString *)oredersn order_amount:(NSString *)oredersn_amount user_money:(NSString *)user_money{

    if([WXApi isWXAppInstalled])// 判断用户是否安装微信
    {
        NSMutableDictionary *params = [Utils parameter];
        params[@"order_amount"] = oredersn_amount;
        params[@"ordersn"] = oredersn;
        [MBProgressHUD showMessage:@"支付中..."];
        [YWHttptool GET:PortWxpaysign parameters:params success:^(id responseObject){
            [MBProgressHUD hideHUD];
            NSLog(@"%@",responseObject);
            NSDictionary *dataDict = responseObject[@"result"];
            //调起微信支付
            PayReq* wxreq             = [[PayReq alloc] init];
            wxreq.openID              = dataDict[@"appid"];
            wxreq.partnerId          = dataDict[@"partnerid"];
            
            wxreq.prepayId            = dataDict[@"prepayid"];
            
            wxreq.package             = dataDict[@"package"];
            
            wxreq.nonceStr            = dataDict[@"noncestr"];
            
            wxreq.timeStamp           = [dataDict[@"timestamp"] intValue];
            
            wxreq.sign                = dataDict[@"sign"];
            [WXApi sendReq:wxreq];//微信充值成功后
        } failure:^(NSError *error){
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"支付有误"];
        }];}else{
            [MBProgressHUD showError:@"您没有安装微信"];
        }
    

}

//支付宝支付
- (void)aliPayOredersn:(NSString *)oredersn order_amount:(NSString *)oredersn_amount user_money:(NSString *)user_money{
    NSMutableDictionary *params = [Utils parameter];
    params[@"order_amount"] = oredersn_amount;
    params[@"ordersn"] = oredersn;
    [MBProgressHUD showMessage:@"支付中..."];
    [YWHttptool GET:PortAlipaysign parameters:params success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [MBProgressHUD hideHUD];
        NSString *string = responseObject[@"result"][@"paysign"];
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
        NSString *appScheme = @"KnockHoneyBT";
        [[AlipaySDK defaultService] payOrder:string fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSData *data = [resultDic[@"result"] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSNotification *notification = [NSNotification notificationWithName:@"ORDER_PAY_NOTIFICATION" object:@"zhifubao" userInfo:weatherDic];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
                    }];
    } failure:^(NSError *error){
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"支付有误"];
    }];

}

- (void)paykind:(NSString *)kind pay_money:(NSString *)pay_money user_money:(NSString *)user_money pay_code:(NSString *)pay_code{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"pay_code"] = pay_code;
    dict[@"orderid"] = self.payModel.orderid;
    dict[@"ordersn"] = self.payModel.ordersn;
    dict[@"pay_mode"] = kind;
    dict[@"pay_money"] = pay_money;
    dict[@"user_money"] = user_money;
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
    [MBProgressHUD showMessage:@"正在支付..."];
    [YWHttptool GET:PortOrder_pay parameters:parameter success:^(id responseObject) {
        NSLog(@"购买之后=%@",responseObject);
        [MBProgressHUD hideHUD];
        if ([responseObject[@"isError"] integerValue]){
            [MBProgressHUD showError:@"支付失败"];
            return ;
        };
        NSString *str = responseObject[@"result"][@"money"];
        KHPayResultModel *model = [KHPayResultModel kh_objectWithKeyValues:responseObject[@"result"]];
        KHPayResultViewController *resultVC = [[KHPayResultViewController alloc]init];
        resultVC.resultmodel = model;
        [self hideBottomBarPush:resultVC];
        YWUser *user = [YWUserTool account];
        user.money = str;
        user.grade = responseObject[@"result"][@"grade"];
        [YWUserTool saveAccount:user];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCart" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kTopupNotification" object:str];
    } failure:^(NSError *error){
          [MBProgressHUD hideHUD];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
