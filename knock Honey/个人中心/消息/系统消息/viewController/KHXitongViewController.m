//
//  KHXitongViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/30.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHXitongViewController.h"
#import "KHXitongModel.h"
#import "KHXitongViewCell.h"
#import "KHXitongContentController.h"

@interface KHXitongViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource>{
    NSInteger _pageCount;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation KHXitongViewController
- (NSMutableArray*)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, KscreenWidth, KscreenHeight-kNavigationBarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorHex(EEEEEE);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"系统消息";
    //下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getLatestPubData];
        //结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    //上拉刷新
    _tableView.mj_footer = [GPAutoFooter footerWithRefreshingBlock:^{
        [weakSelf getMoreData];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"KHXitongViewCell" bundle:nil] forCellReuseIdentifier:@"xitongCell"];
}

- (void)getLatestPubData{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    parameter[@"type"] = @"4";
    parameter[@"p"] = @1;
    [YWHttptool GET:PortMessage_list parameters:parameter success:^(id responseObject){
        if ([responseObject[@"isError"] integerValue]) return ;
        _pageCount = 1;
        self.dataArray = [KHXitongModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
        [self.tableView reloadData];
    } failure:^(NSError *error){
    }];
}

- (void)getMoreData{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    parameter[@"type"] = @"4";
    parameter[@"p"] = @(++_pageCount);
    [YWHttptool GET:PortMessage_list parameters:parameter success:^(id responseObject){
        if ([responseObject[@"isError"] integerValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        };
        [self.dataArray addObjectsFromArray:[KHXitongModel kh_objectWithKeyValuesArray:responseObject[@"result"]]];
        [self.tableView reloadData];
    } failure:^(NSError *error){
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KHXitongViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xitongCell" forIndexPath:indexPath];
    [cell setModel:_dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  90;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KHXitongModel *model = self.dataArray[indexPath.section];
    KHXitongContentController *VC = [[KHXitongContentController alloc]init];
    VC.content = model.content;
    [self hideBottomBarPush:VC];
}
#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_placeholder"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
