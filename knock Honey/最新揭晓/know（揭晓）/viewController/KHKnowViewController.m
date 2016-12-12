//
//  KHKnowViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/10.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHKnowViewController.h"
#import "KHKnowTableViewCell.h"
#import "KHKnowModel.h"
#import "KHPulishedTableViewCell.h"
#import "KHDetailViewController.h"
#import "KHProductModel.h"

static NSString * nopublished = @"nopublished";
static NSString * published = @"published";

@interface KHKnowViewController ()<UITableViewDataSource,UITableViewDelegate,KHKnowtableViewCellDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>{
    NSInteger _currentPage;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) BOOL loading;
@end

@implementation KHKnowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    self.title = @"最新揭晓";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self cofigTableView];
}

- (void)cofigTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, KscreenWidth, KscreenHeight-kTabBarHeight-kNavigationBarHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.emptyDataSetDelegate = self;
    _tableView.emptyDataSetSource = self;
    [self.view addSubview:_tableView];
    
    
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
    
    [_tableView registerNib:NIB_NAMED(@"KHKnowTableViewCell") forCellReuseIdentifier:nopublished];
    [_tableView registerNib:NIB_NAMED(@"KHPulishedTableViewCell") forCellReuseIdentifier:published];
    
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
    [YWHttptool GET:PortGoodszxjx parameters:parameter success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        self.loading = YES;
        for (KHKnowModel *model in _dataArray) {
            [model stop];
        }
        [_dataArray removeAllObjects];
        _currentPage = 1;
        _dataArray = [KHKnowModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
        [self.tableView reloadData];
    } failure:^(NSError *error){
        [MBProgressHUD hideHUD];
        self.loading = YES;
    }];
}

- (void)getMoreData{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"p"] = [NSNumber numberWithInteger:++_currentPage];
    [YWHttptool GET:PortGoodszxjx parameters:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"isError"] integerValue] ==1){
            return ;
        };
        NSMutableArray *array = [KHKnowModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
        [_dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络连接有误"];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KHKnowModel *model = _dataArray[indexPath.row];
    if ([model.newtime doubleValue] >[[NSDate date] timeIntervalSince1970]) {
        KHKnowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nopublished forIndexPath:indexPath];
        cell.delegate = self;
        [cell setModel:model indexPath:indexPath];
        return cell;
    }
        KHPulishedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:published forIndexPath:indexPath];
        [cell setModel:model indexPath:indexPath];
        return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    KHKnowTableViewCell *tmpCell = (KHKnowTableViewCell *)cell;
    tmpCell.isDisplayed = YES;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    KHKnowTableViewCell *tmpCell = (KHKnowTableViewCell *)cell;
    tmpCell.isDisplayed = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [MBProgressHUD showMessage:@"加载中..."];
    KHKnowModel *knowModel = _dataArray[indexPath.row];
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"goodsid"] = knowModel.goodsid;
    parameter[@"qishu"] = knowModel.qishu;
    if ([YWUserTool account]) {
         parameter[@"userid"] = [YWUserTool account].userid;
    }
    [YWHttptool GET:PortGoodsdetails parameters:parameter success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",responseObject);
        if ([responseObject[@"isError"] integerValue])return;
        KHDetailViewController *DetailVC = [[KHDetailViewController alloc]init];
        DetailVC.model = [KHProductModel kh_objectWithKeyValues:responseObject[@"result"]];
        DetailVC.goodsid = knowModel.goodsid;
        DetailVC.qishu = knowModel.qishu;
        [self pushController:DetailVC];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络连接有误"];
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
    UITabBarController *tabBarVC = (UITabBarController *)[AppDelegate getAppDelegate].window.rootViewController;
    [tabBarVC setSelectedIndex:0];
}

#pragma mark - LatestPublishCellDelegate
- (void)countdownDidEnd:(NSIndexPath *)indexpath {
    [_tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
