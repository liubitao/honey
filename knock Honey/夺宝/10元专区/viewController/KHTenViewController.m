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
#import "TSAnimation.h"

@interface KHTenViewController ()<UITableViewDataSource,UITableViewDelegate,CategoryDetailCellDelegate,TSAnimationDelegate>
{
    NSInteger _currentPage;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
/**c产品图片(动画)
 */
@property (nonatomic, strong) UIImageView *productView;


@end

@implementation KHTenViewController

- (UIImageView *)productView {
    if (!_productView) {
        _productView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _productView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _productView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    [self createNavi];
    [self createTableView];
    
}

- (void)createNavi{
    self.title = @"十元专区";
    [self setRightImageNamed:@"tenCart" action:@selector(gotoCart)];
    [self setItemBadge:[AppDelegate getAppDelegate].value];
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
        [weakSelf getDatasource];
        //结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    //开始下拉刷新
    [self.tableView.mj_header beginRefreshing];
    
    //上拉刷新
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf getMoreData];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
- (void)getDatasource{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"p"] = @"1";
    _currentPage = 1;
    parameter[@"areaid"] = @"1";
    [YWHttptool GET:PortGoodsarea parameters:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        _dataArray = [KHTenModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"连接网络有误"];
    }];
}

- (void)getMoreData{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"p"] = [NSNumber numberWithInteger:++_currentPage];
    parameter[@"areaid"] = @"1";
    [YWHttptool GET:PortGoodsarea parameters:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"isError"] integerValue])return ;
        NSArray *array = [KHTenModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
        [_dataArray addObjectsFromArray:array];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"连接网络有误"];
    }];
}
//进去购物车
- (void)gotoCart{
    [self.tabBarController setSelectedIndex:3];
    [self.navigationController popViewControllerAnimated:NO];
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
    [MBProgressHUD showMessage:@"加载中..."];
    NSMutableDictionary *parameter = [Utils parameter];
    NSString *goodsid;
    KHTenModel *Model = _dataArray[indexPath.row];
    parameter[@"goodsid"] = Model.ID;
    parameter[@"qishu"] = Model.qishu;
    goodsid = Model.ID;
    [YWHttptool GET:PortGoodsdetails parameters:parameter success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if ([responseObject[@"isError"] integerValue])return;
        KHDetailViewController *DetailVC = [[KHDetailViewController alloc]init];
        DetailVC.model = [KHProductModel kh_objectWithKeyValues:responseObject[@"result"]];
        DetailVC.goodsid = goodsid;
        DetailVC.showType = TreasureDetailHeaderTypeNotParticipate;
        [self pushController:DetailVC];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];

}

#pragma mark - CategoryDetailCellDelegate
//点击加入了清单
- (void)clickAddListButtonAtCell:(CategoryDetailCell *)cell {
    if ([TSAnimation sharedAnimation].isShowing) {
        return;
    }
    NSIndexPath *indexPath = cell.indexpath;
    KHTenModel *model = _dataArray[indexPath.row];
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    parameter[@"goodsid"] = model.ID;
    [YWHttptool GET:PortAddCart parameters:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"isError"] integerValue]) return ;
        [AppDelegate getAppDelegate].value = [responseObject[@"result"][@"count_cart"] integerValue];
    } failure:^(NSError *error) {
    }];
    CGRect parentRectA = [cell.contentView convertRect:cell.productImgView.frame toView:self.view];
    CGRect parentRectB = CGRectMake(KscreenWidth-60, 20, 40, 40);
    [self.view addSubview:self.productView];
    self.productView.frame = parentRectA;
    self.productView.image = cell.productImgView.image;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.productView.centerX, self.productView.centerY)];
    [path addQuadCurveToPoint:CGPointMake(parentRectB.origin.x+30, parentRectB.origin.y+40) controlPoint:CGPointMake(self.productView.centerX+50, self.productView.centerY-20)];
    [TSAnimation sharedAnimation].delegate = self;
    [[TSAnimation sharedAnimation] throwTheView:self.productView path:path isRotated:YES endScale:0.1];
}
#pragma mark - TSAnimationDelegate;//动画完成
- (void)animationFinished {
     [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshCart" object:nil userInfo:nil];
    [self setItemBadge:[AppDelegate getAppDelegate].value];
    [self setBadgeValue:[AppDelegate getAppDelegate].value atIndex:3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
