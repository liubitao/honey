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

@interface KHTopupViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSIndexPath *_selectedIndexPath;
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
    
    NSMutableDictionary *params = [Utils parameter];
    params[@"order_amount"] = _header.coinAmount;
    params[@"userid"] = [YWUserTool account].userid;
    params[@"ordersn"] = @0;
    [MBProgressHUD showMessage:@"支付中..."];
    [YWHttptool GET:PortAlipaysign parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",responseObject);
        NSString *string = responseObject[@"result"];
        
        //将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = nil;
        if (string != nil) {
//            orderString = [NSString stringWithFormat:@"%@&sign=\\"%@\\"&sign_type=\\"%@\\"",
//                           orderSpec, string, @"RSA"];
            
            //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
            NSString *appScheme = @"KnockHoneyBT";
            [[AlipaySDK defaultService] payOrder:string fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
            }];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"支付失败"];
    }];
    
//    TopupResultViewController *vc = [[TopupResultViewController alloc]init];
//    NSLog(@"%@ coin",_header.coinAmount);
//    vc.coinAmount = _header.coinAmount;
//    [self hideBottomBarPush:vc];
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
