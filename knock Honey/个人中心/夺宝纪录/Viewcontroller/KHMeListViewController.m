//
//  KHMeListViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/14.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHMeListViewController.h"
#import "KHSnatchModel.h"
#import "KHAllTableViewCell.h"
#import "KHSnatchingTableViewCell.h"
#import "KHTabbarViewController.h"
#import "KHDetailViewController.h"
#import "YWCover.h"
#import "YWPopView.h"
#import "KHCodeViewController.h"
#import "KHProductModel.h"
#import "KHOtherPersonController.h"


@interface KHMeListViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,khAllCellDegelage,khEdCellDegelage,YWCoverDelegate>{
    NSInteger _currentPage;
    CGFloat _huadong;
}

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) KHCodeViewController *codeVC;
@property (nonatomic,assign) BOOL loading;
@end
static NSString *ingGoodsCell = @"ingGoodsCell";
static NSString *edGoodsCell = @"edGoodsCell";

@implementation KHMeListViewController

- (KHCodeViewController *)codeVC{
    if (!_codeVC) {
        _codeVC = [[KHCodeViewController alloc]init];
    }
    return _codeVC;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth,_otherType ? kScreenHeight - 190 - 46:kScreenHeight - kNavigationBarHeight- 60) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        [_tableView setCustomSeparatorInset:UIEdgeInsetsZero];
        _tableView.tableFooterView = [UIView new];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 1)];
        view.backgroundColor = UIColorHex(#DCDCDC);
        _tableView.tableHeaderView = view;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.tableView];
    
    //下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
        //结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf getMoreData];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KHSnatchingTableViewCell" bundle:nil] forCellReuseIdentifier:edGoodsCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"KHAllTableViewCell" bundle:nil] forCellReuseIdentifier:ingGoodsCell];
}
- (void)setLoading:(BOOL)loading{
    if (self.loading == loading) {
        return;
    }
    _loading = loading;
    
    [self.tableView reloadEmptyDataSet];
}

- (void)getData{
    NSMutableDictionary *parameter = [Utils parameter];
    if (_userID) {
        parameter[@"userid"] = _userID;
    }else{
        parameter[@"userid"] = [YWUserTool account].userid;
    }
    parameter[@"p"] = @1;
    parameter[@"type"] = _type;
    [YWHttptool GET:PortOrder_list parameters:parameter success:^(id responseObject) {
        self.loading = YES;
        _currentPage = 1;
        self.dataArray = [KHSnatchModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
        [self.tableView reloadData];
    } failure:^(NSError *error){
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
    parameter[@"p"] = [NSNumber numberWithInteger:++_currentPage];
    parameter[@"type"] = _type;
    [YWHttptool GET:PortOrder_list parameters:parameter success:^(id responseObject) {
        if ([responseObject[@"isError"] integerValue]) {
            return ;
        }
        [self.dataArray addObjectsFromArray:[KHSnatchModel kh_objectWithKeyValuesArray:responseObject[@"result"]]];
        [self.tableView reloadData];
    } failure:^(NSError *error){
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KHSnatchModel *model = self.dataArray[indexPath.row];
    if (model.isopen.integerValue == 1) {
        KHSnatchingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:edGoodsCell forIndexPath:indexPath];
        cell.delegate = self;
        [cell setModel:model];
        return cell;
    }else{
        KHAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ingGoodsCell forIndexPath:indexPath];
        cell.delegate = self;
        [cell setModel:model];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    KHSnatchModel *model= self.dataArray[indexPath.row];
    if (model.isopen.integerValue == 1) {
        return 240;
    }else{
        return 155;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [MBProgressHUD showMessage:@"加载中..."];
    NSMutableDictionary *parameter = [Utils parameter];
    KHSnatchModel *model = self.dataArray[indexPath.row];
    parameter[@"goodsid"] = model.goodsid;
    parameter[@"qishu"] = model.qishu;
    if ([YWUserTool account]) {
        parameter[@"userid"] = [YWUserTool account].userid;
    }
    [YWHttptool GET:PortGoodsdetails parameters:parameter success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if ([responseObject[@"isError"] integerValue])return;
        KHDetailViewController *DetailVC = [[KHDetailViewController alloc]init];
        DetailVC.model = [KHProductModel kh_objectWithKeyValues:responseObject[@"result"]];
        DetailVC.goodsid = model.goodsid;
        DetailVC.qishu = model.qishu;
        if (model.isopen.integerValue == 1) {
                DetailVC.showType = TreasureDetailHeaderTypeWon;
        }else{
            DetailVC.showType = TreasureDetailHeaderTypeNotParticipate;
        }
        
        KHBaseViewController *parentVC = (KHBaseViewController *)self.parentViewController;
        [parentVC hideBottomBarPush:DetailVC];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络连接有误"];
    }];

}
#pragma mark -  cell代理
- (void)tableViewLookup:(KHSnatchModel *)model{
    KHCodeViewController *vc = self.codeVC;
    NSArray *array = [model.codes componentsSeparatedByString:@","];
    vc.dataArray = array.mutableCopy;
    if (model.lottery){
        vc.winCode = model.lottery.wincode;
    }
    [vc.ColloctionView reloadData];
    //弹出蒙版
    YWCover *cover = [YWCover show];
    cover.delegate = self;
    [cover setDimBackground:YES];
    
    // 弹出pop菜单
    YWPopView *menu = [YWPopView showInRect:CGRectZero];
    menu.center = self.view.center;
    menu.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.5
                     animations:^{
                         menu.transform = CGAffineTransformIdentity;
                     }];
    menu.contentView = vc.view;
}

//点击蒙版的时候调用
- (void)coverDidClickCover:(YWCover *)cover{
    // 隐藏pop菜单
    [YWPopView hide];
}

- (void)tableViewWithBuy:(KHSnatchModel *)model{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    parameter[@"goodsid"] = model.goodsid;
    parameter[@"qishu"] = model.qishu;
    [YWHttptool GET:PortAddCart parameters:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"isError"] integerValue]) return ;
        [AppDelegate getAppDelegate].value = [responseObject[@"result"][@"count_cart"] integerValue];
        
        //刷新购物车
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshCart" object:nil userInfo:nil];
        KHTabbarViewController *tabbarVC = (KHTabbarViewController *)[AppDelegate getAppDelegate].window.rootViewController;
        [tabbarVC.tabBar setBadgeValue:[AppDelegate getAppDelegate].value AtIndex:3];
    } failure:^(NSError *error){
    }];
    [self.tabBarController setSelectedIndex:3];
    [self.navigationController popToRootViewControllerAnimated:NO];
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
