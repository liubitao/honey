//
//  KHMyAppearViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/10.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHMyAppearViewController.h"
#import "KHAppearTableViewCell.h"
#import "KHAppearModel.h"
#import "KHAppearDetailController.h"

@interface KHMyAppearViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>{
    NSInteger _pageCount;
}


@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) BOOL loading;
@end

@implementation KHMyAppearViewController
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的晒单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTableView];
}

- (void)createTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, _otherType ? kScreenHeight - 190 - 46:kScreenHeight) style:UITableViewStylePlain];
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
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf getMoreData];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
}
- (void)setLoading:(BOOL)loading{
    if (self.loading == loading) {
        return;
    }
    _loading = loading;
    
    [self.tableView reloadEmptyDataSet];
}

- (void)getLatestPubData{
    [MBProgressHUD showMessage:@"加载中..."];
    NSMutableDictionary *parameter = [Utils parameter];
    if (_userID) {
        parameter[@"userid"] = _userID;
    }else{
         parameter[@"userid"] = [YWUserTool account].userid;
    }
    parameter[@"p"] = @1;
    parameter[@"type"] = @1;
    [YWHttptool GET:PortComment_list parameters:parameter success:^(id responseObject){
        [MBProgressHUD hideHUD];
        self.loading = YES;
        if ([responseObject[@"isError"] integerValue]) return ;
        _pageCount = 1;
        [self.dataArray removeAllObjects];
        self.dataArray = [KHAppearModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
        [self.tableView reloadData];
    } failure:^(NSError *error){
        [MBProgressHUD hideHUD];
        self.loading = YES;
    }];
}

- (void)getMoreData{
    NSMutableDictionary *parameter = [Utils parameter];
    if (_userID) {
        parameter[@"userid"] = _userID;
    }else{
        parameter[@"userid"] = [YWUserTool account].userid;
    }
    parameter[@"p"] = @(++_pageCount);
    parameter[@"type"]= @1;
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
    parameter[@"type"] = @"1";
    [YWHttptool GET:PortComment_detail parameters:parameter success:^(id responseObject){
        if ([responseObject[@"isError"] integerValue]) return ;
        KHAppearDetailModel *model = [KHAppearDetailModel kh_objectWithKeyValues:responseObject[@"result"]];
        KHAppearDetailController *detailVC = [[KHAppearDetailController alloc]init];
        detailVC.AppearModel = model;
        [self hideBottomBarPush:detailVC];
        [MBProgressHUD showMessage:@"加载中..."];
    } failure:^(NSError *error){
    }];
    
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_placeholder"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无此纪录";
    return [[NSAttributedString alloc] initWithString:text attributes:@{
                                                                        NSFontAttributeName:SYSTEM_FONT(15)
                                                                        }];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -64;
}

- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    return IMAGE_NAMED(@"duobao");
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return self.loading;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    [self.navigationController popToRootViewControllerAnimated:NO];
    UITabBarController *tabBarVC = (UITabBarController *)[AppDelegate getAppDelegate].window.rootViewController;
    [tabBarVC setSelectedIndex:0];
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
