//
//  KHTopupViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/1.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHTopupViewController.h"
#import "KHTopupHeader.h"
#import "KHTopupTableViewCell.h"
#import "TopupResultViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface KHTopupViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSIndexPath *_selectedIndexPath;
    NSString *ordersn;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datasoure;
@property (nonatomic,strong) KHTopupHeader *header;

@end


@implementation KHTopupViewController


- (NSMutableArray *)datasoure {
    if (!_datasoure) {
        NSArray *array = @[@"微信支付",@"支付宝支付"];
        _datasoure = [NSMutableArray arrayWithArray:array];
    }
    return _datasoure;
}

- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, KscreenWidth, KscreenHeight-kNavigationBarHeight) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"充值";
    [self.view addSubview:self.tableView];
    [self setupHeader];
    [self setupBottom];
}

- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:@"ORDER_PAY_NOTIFICATION" object:nil];//监听一个通知
    [super viewWillAppear:animated];  
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//支付成功后
- (void)getOrderPayResult:(NSNotification *)notification{
    if ([notification.object isEqualToString:@"zhifubao"]) {//支付宝回调
        if ([notification.userInfo[@"alipay_trade_app_pay_response"][@"msg"] isEqualToString:@"Success"]) {
            NSMutableDictionary *dict = [Utils parameter];
            dict[@"userid"] = [YWUserTool account].userid;
            dict[@"ordersn"] = ordersn;
            dict[@"pay_code"] = notification.userInfo[@"alipay_trade_app_pay_response"][@"trade_no"];
            dict[@"pay_mode"] = @"3";
            [YWHttptool GET:Portuser_recharge parameters:dict success:^(id responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject[@"result"][@"status"] integerValue] == 1) {
                    TopupResultViewController *vc = [[TopupResultViewController alloc]init];
                    NSLog(@"%@ coin",_header.coinAmount);
                    vc.coinAmount = _header.coinAmount;
                    [self hideBottomBarPush:vc];
                    NSString *str = responseObject[@"result"][@"money"];
                    YWUser *user =  [YWUserTool account];
                    user.money = str;
                    [YWUserTool saveAccount:user];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kTopupNotification" object:str];
                }
            } failure:nil];

        }else{
              [UIAlertController showAlertViewWithTitle:@"提示" Message:@"支付失败" BtnTitles:@[@"知道了"] ClickBtn:nil];
        }
    }

    else if ([notification.object isEqualToString:@"success"]){//微信支付回调
        NSMutableDictionary *dict = [Utils parameter];
        dict[@"userid"] = [YWUserTool account].userid;
        dict[@"ordersn"] = ordersn;
        dict[@"pay_mode"] = @"2";
        dict[@"pay_code"] = ordersn;
        [YWHttptool GET:Portuser_recharge parameters:dict success:^(id responseObject) {
            NSLog(@"%@",responseObject);
            if ([responseObject[@"result"][@"status"] integerValue] == 1) {
                TopupResultViewController *vc = [[TopupResultViewController alloc]init];
                NSLog(@"%@ coin",_header.coinAmount);
                vc.coinAmount = _header.coinAmount;
                [self hideBottomBarPush:vc];
                NSString *str = responseObject[@"result"][@"money"];
                YWUser *user =  [YWUserTool account];
                user.money = str;
                [YWUserTool saveAccount:user];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kTopupNotification" object:str];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    else{
        [UIAlertController showAlertViewWithTitle:@"提示" Message:@"支付失败" BtnTitles:@[@"知道了"] ClickBtn:nil];
    }
}
- (void)setupHeader{
    _header = [[KHTopupHeader alloc]initWithFrame:({
        CGRect rect = {0,0,KscreenWidth,1};
        rect;
    })];

    self.tableView.tableHeaderView = _header;
}

- (void)setupBottom{
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.frame = ({
        CGRect rect = {15,KscreenHeight- 50,kScreenWidth-15*2,40};
        rect;
    });
    payButton.backgroundColor = kDefaultColor;
    payButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    payButton.layer.cornerRadius = 3.0;
    [payButton setTitle:@"马上充值" forState:UIControlStateNormal];
    [payButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(ed8686)] forState:UIControlStateHighlighted];
    [payButton addTarget:self action:@selector(confirmTopup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payButton];
}

- (void)confirmTopup {
    if (!_header.coinAmount) {
        [MBProgressHUD showError:@"请选择充值金额"];
        return;
    }

    if (_selectedIndexPath.row == 0) {//微信支付
        if([WXApi isWXAppInstalled]) // 判断用户是否安装微信
            {
                NSMutableDictionary *params = [Utils parameter];
                params[@"order_amount"] = _header.coinAmount;
                params[@"ordersn"] = @0;
                [MBProgressHUD showMessage:@"支付中..."];
                [YWHttptool GET:PortWxpaysign parameters:params success:^(id responseObject){
                    [MBProgressHUD hideHUD];
                    NSLog(@"%@",responseObject);
                    NSDictionary *dataDict = responseObject[@"result"];
                    
                    //订单单号
                    ordersn = dataDict[@"ordersn"];
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
            [MBProgressHUD showError:@"支付失败"];
            }];}else{
                [UIAlertController showAlertViewWithTitle:@"提示" Message:@"您未安装微信!" BtnTitles:@[@"确定"] ClickBtn:nil];
            }
        
        
    }else{//支付宝支付
        NSMutableDictionary *params = [Utils parameter];
        params[@"order_amount"] = _header.coinAmount;
        params[@"ordersn"] = @0;
        [MBProgressHUD showMessage:@"支付中..."];
        [YWHttptool GET:PortAlipaysign parameters:params success:^(id responseObject) {
            NSLog(@"%@",responseObject);
            [MBProgressHUD hideHUD];
            NSString *string = responseObject[@"result"][@"paysign"];
            NSString *ordersns = responseObject[@"result"][@"ordersn"];
            //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
            NSString *appScheme = @"KnockHoneyBT";
            ordersn = ordersns;
            [[AlipaySDK defaultService] payOrder:string fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);  NSData *data = [resultDic[@"result"] dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSNotification *notification = [NSNotification notificationWithName:@"ORDER_PAY_NOTIFICATION" object:@"zhifubao" userInfo:weatherDic];
                [[NSNotificationCenter defaultCenter] postNotification:notification];            }];
        } failure:^(NSError *error){
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"支付失败"];
        }];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasoure.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KHTopupTableViewCell *cell = [KHTopupTableViewCell cellWithTableView:tableView];
    if (indexPath.row == 0) {
        cell.imageView.image = IMAGE_NAMED(@"wenxinPay");
        cell.des.text = @"推荐已开通微信钱包的用户使用";
        cell.selectImage.image = IMAGE_NAMED(@"selected");
        _selectedIndexPath = indexPath;
    }else{
        cell.imageView.image = IMAGE_NAMED(@"zhifubaoPay");
        cell.des.text = @"推荐已开通支付宝的用户使用";
    }
    cell.leibie.text = _datasoure[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    KHTopupTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (_selectedIndexPath) {
        KHTopupTableViewCell *selectedCell = [tableView cellForRowAtIndexPath:_selectedIndexPath];
        selectedCell.selectImage.image = IMAGE_NAMED(@"noselected");
    }
    _selectedIndexPath = indexPath;
    cell.selectImage.image = IMAGE_NAMED(@"selected");
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
