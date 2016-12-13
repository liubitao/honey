//
//  KHdisListViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/26.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHdisListViewController.h"
#import "KHDistanceViewCell.h"
#import "KHMessageModel.h"
#import "KHDistanceViewController.h"

@interface KHdisListViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>{
    NSInteger _pageCount;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) BOOL loading;
@end

@implementation KHdisListViewController
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, KscreenWidth, KscreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.backgroundColor = UIColorHex(#EEEEEE);
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColorHex(#F5F5F5);
    self.title = @"发货消息";
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KHDistanceViewCell" bundle:nil] forCellReuseIdentifier:@"KHDistanceViewCell"];
    
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
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KHMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"zhongjiangCell"];
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
    parameter[@"userid"] = [YWUserTool account].userid;
    parameter[@"type"] = @"3";
    parameter[@"p"] = @1;
    [YWHttptool GET:PortMessage_list parameters:parameter success:^(id responseObject){
        [MBProgressHUD hideHUD];
        self.loading = YES;
        if ([responseObject[@"isError"] integerValue]) return ;
        _pageCount = 1;
        self.dataArray = [KHMessageModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
        [self.tableView reloadData];
    } failure:^(NSError *error){
        [MBProgressHUD hideHUD];
        self.loading = YES;
    }];
}

- (void)getMoreData{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    parameter[@"type"] = @"3";
    parameter[@"p"] = @(_pageCount + 1);
    [YWHttptool GET:PortMessage_list parameters:parameter success:^(id responseObject){
        if ([responseObject[@"isError"] integerValue]) {
            return ;
        };
        _pageCount++;
        [self.dataArray addObjectsFromArray:[KHMessageModel kh_objectWithKeyValuesArray:responseObject[@"result"]]];
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
    KHDistanceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KHDistanceViewCell" forIndexPath:indexPath];
    [cell setModel:self.dataArray[indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KHDistanceViewController *VC = [[KHDistanceViewController alloc]init];
    VC.model = self.dataArray[indexPath.section];
    [self hideBottomBarPush:VC];
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
