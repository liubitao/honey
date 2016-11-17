//
//  KHAppearViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/10.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHAppearViewController.h"
#import "KHAppearTableViewCell.h"
#import "KHAppearModel.h"
#import "KHAppearDetailController.h"

@interface KHAppearViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>{
    NSInteger _pageCount;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation KHAppearViewController


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"晒单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTableView];
}

- (void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:self.tableView];
    _tableView.emptyDataSetDelegate = self;
    _tableView.emptyDataSetSource = self;

    
    [self.tableView registerNib:[UINib nibWithNibName:@"KHAppearTableViewCell" bundle:nil] forCellReuseIdentifier:@"AppearCell"];
    //下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getLatestPubData];
        //结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    //上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf getMoreData];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];  
    
}
- (void)getLatestPubData{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"p"] = @1;
    parameter[@"userid"] = [YWUserTool account].userid;
    [YWHttptool GET:PortComment_list parameters:parameter success:^(id responseObject){
         if ([responseObject[@"isError"] integerValue]) return ;
        _pageCount = 1;
        [self.dataArray removeAllObjects];
        self.dataArray = [KHAppearModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
        [self.tableView reloadData];
    } failure:^(NSError *error){
    }];
}

- (void)getMoreData{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    parameter[@"p"] = @(++_pageCount);
    parameter[@"userid"] = [YWUserTool account].userid;
    [YWHttptool GET:PortComment_list parameters:parameter success:^(id responseObject){
        if ([responseObject[@"isError"] integerValue]) return ;
        [self.dataArray addObjectsFromArray:[KHAppearModel kh_objectWithKeyValuesArray:responseObject[@"result"]]];
        [self.tableView reloadData];
    } failure:^(NSError *error){
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KHAppearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppearCell" forIndexPath:indexPath];
    [cell setModel:_dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [KHAppearTableViewCell height];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *parameter = [Utils parameter];
    KHAppearModel *apperModel = self.dataArray[indexPath.row];
    parameter[@"comment_id"] = apperModel.ID;
    parameter[@"userid"] = [YWUserTool account].userid;
    [YWHttptool GET:PortComment_detail parameters:parameter success:^(id responseObject){
        if ([responseObject[@"isError"] integerValue]) return ;
        KHAppearDetailModel *model = [KHAppearDetailModel kh_objectWithKeyValues:responseObject[@"result"]];
        KHAppearDetailController *detailVC = [[KHAppearDetailController alloc]init];
        __weak typeof(self) weakSelf = self;
        detailVC.block = ^{
            KHAppearModel *appearModel = weakSelf.dataArray[indexPath.row];
            appearModel.issupport = @"1";
            [weakSelf.dataArray replaceObjectAtIndex:indexPath.row withObject:appearModel];
            [weakSelf.tableView reloadData];
        };
        detailVC.AppearModel = model;
        detailVC.indexPath = indexPath;
        [self pushController:detailVC];
        [MBProgressHUD showMessage:@"加载中..."];
    } failure:^(NSError *error){
    }];
    
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_placeholder"];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
