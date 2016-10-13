//
//  KHTenViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/13.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHTenViewController.h"
#import "KHTenModel.h"
#import "CategoryDetailCell.h"
#import "KHDetailViewController.h"

@interface KHTenViewController ()<UITableViewDataSource,UITableViewDelegate,CategoryDetailCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;


@end

@implementation KHTenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    [self createNavi];
    [self createTableView];
    
}

- (void)createNavi{
    self.title = @"十元专区";
    [self setRightImageNamed:@"tabbarcart" action:@selector(gotoCart)];
    
}

- (void)createTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, KscreenWidth, kScreenHeight- kNavigationBarHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.view addSubview:_tableView];
    
    //下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDatasource];
        //结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    //开始下拉刷新
    [self.tableView.mj_header beginRefreshing];
    
    //上拉刷新
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
    }];
}

- (void)getDatasource {
    for (int i=0; i<8; i++) {
        KHTenModel *model = [[KHTenModel alloc]init];
        [self.dataArray addObject:model];
    }
    [_tableView reloadData];
}
//进去购物车
- (void)gotoCart{
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CategoryDetailCell *cell = [CategoryDetailCell cellWithTableView:tableView];
    [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    KHTenModel *model = _dataArray[indexPath.row];
    [cell setModel:model];
    cell.indexpath = indexPath;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [CategoryDetailCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KHDetailViewController *DetailVC = [[KHDetailViewController alloc]init];
    [self hideBottomBarPush:DetailVC];
}

#pragma mark - CategoryDetailCellDelegate
//点击加入了清单
- (void)clickAddListButtonAtCell:(CategoryDetailCell *)cell {
    NSLog(@"加入清单");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
