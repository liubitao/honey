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

@interface KHPayResultViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation KHPayResultViewController



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:({
            CGRect rect = {0,kNavigationBarHeight,kScreenWidth,kScreenHeight- kNavigationBarHeight};
            rect;
        }) style:UITableViewStylePlain];
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
            case 2: {//夺宝纪录
            }
                break;
            default:
                break;
        }
    };
    _tableView.tableHeaderView = header;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultmodel.goods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PayResultCell *cell = [PayResultCell cellWithTableView:tableView];
    
    cell.model = self.resultmodel.goods[indexPath.row];
    return cell;
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
