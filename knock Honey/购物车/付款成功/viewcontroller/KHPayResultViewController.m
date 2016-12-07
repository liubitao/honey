//
//  KHPayResultViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/10.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHPayResultViewController.h"
#import "PayResultHeader.h"
#import "PayResultCell.h"
#import "KHCartViewController.h"
#import "KHSnatchListController.h"
#import "KHTabbarViewController.h"

@interface KHPayResultViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation KHPayResultViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:({
            CGRect rect = {0,kNavigationBarHeight,kScreenWidth,kScreenHeight- kNavigationBarHeight};
            rect;
        }) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = UIColorHex(E5E5E5);
        _tableView.tableFooterView = [UIView new];
        [_tableView setCustomSeparatorInset:UIEdgeInsetsZero];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付结果";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self setLeftItemTitle:@"" action:nil];
    [self configureTableview];
    
}

- (void)configureTableview {
    _tableView.estimatedRowHeight = 96.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    PayResultHeader *header = [[PayResultHeader alloc]initWithFrame:({
        CGRect rect = {0,0,kScreenWidth,100};
        rect;
    }) model:_resultmodel];
    __weak typeof(self) weakSelf = self;
    header.clickButton = ^(NSInteger index){
        switch (index) {
            case 1://支付成功
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                break;
            case 2:{//夺宝纪录
                KHSnatchListController *snatchVC = [[KHSnatchListController alloc]init];
                KHTabbarViewController *tab = (KHTabbarViewController *)[AppDelegate getAppDelegate].window.rootViewController;
                [tab pushOtherIndex:4 viewController:snatchVC];
            }
                break;
            default:
                break;
        }
    };
    _tableView.tableHeaderView = header;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.resultmodel.failmoney.integerValue == 0) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.resultmodel.goods.count;
    }else{
        return self.resultmodel.fails.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PayResultCell *cell = [PayResultCell cellWithTableView:tableView];
    if (indexPath.section == 0) {
        cell.model = self.resultmodel.goods[indexPath.row];
    }else{
        cell.model = self.resultmodel.fails[indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 103;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 30;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 60;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView  *seperatorLayer = [UIView new];
        seperatorLayer.origin = CGPointMake(0, 0);
        seperatorLayer.size = CGSizeMake(kScreenWidth, 60);
        seperatorLayer.backgroundColor = [UIColor whiteColor];
        
        YYLabel *productLabel = [YYLabel new];
        productLabel.origin = CGPointMake(15, 20);
        productLabel.size = CGSizeMake(kScreenWidth-15, 18);
        productLabel.font = SYSTEM_FONT(16);
        productLabel.textColor = kDefaultColor;
        NSInteger renci = self.resultmodel.fails.count;
        NSInteger count = 0;
        NSInteger failMoney = self.resultmodel.failmoney.integerValue;
        for (KHresultGoods *good in self.resultmodel.fails) {
            count+= good.buynum.integerValue;
        }
        productLabel.text = [NSString stringWithFormat:@"参与失败%zi件商品,共%zi人次,%zi抢币将立即退回",renci,count,failMoney];
        [seperatorLayer addSubview:productLabel];
        
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        lineLayer.origin = CGPointMake(0, productLabel.bottom+20);
        lineLayer.size = CGSizeMake(kScreenWidth, 1);
        lineLayer.backgroundColor = UIColorHex(E5E5E5).CGColor;
        [seperatorLayer.layer addSublayer:lineLayer];
        
        return seperatorLayer;
    }
    return nil;
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
