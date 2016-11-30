//
//  KHSearchResultController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/16.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHSearchResultController.h"
#import "KHTenModel.h"
#import "CategoryDetailCell.h"
#import "KHDetailViewController.h"
#import "SearchBar.h"
#import "TSAnimation.h"

@interface KHSearchResultController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CategoryDetailCellDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,TSAnimationDelegate>{
    SearchBar *search;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
/**c产品图片(动画)
 */
@property (nonatomic, strong) UIImageView *productView;
@end

@implementation KHSearchResultController

- (UIImageView *)productView {
    if (!_productView) {
        _productView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _productView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _productView;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, KscreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
        [_tableView setCustomSeparatorInset:UIEdgeInsetsZero];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    
    [self getData];
    [self createNavi];
    
}

- (void)getData{
    [MBProgressHUD showMessage:@"加载中..."];
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"keyword"] = search.text;
    [YWHttptool GET:PortGoods_search parameters:parameter success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if ([responseObject[@"isError"] integerValue]) return ;
        self.dataArray = [KHTenModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
    
}

- (void)createNavi{
    search = [SearchBar searchBar];
    search.delegate = self;
    search.returnKeyType = UIReturnKeySearch;
    self.navigationItem.titleView = search;
    
    [self setRightImageNamed:@"tenCart" action:@selector(gotoCart)];
    [self setItemBadge:[AppDelegate getAppDelegate].value];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self getData];
    [textField resignFirstResponder];
    return YES;
}

//进去购物车
- (void)gotoCart{
    [self.tabBarController setSelectedIndex:3];
    [self.navigationController popViewControllerAnimated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CategoryDetailCell *cell = [CategoryDetailCell cellWithTableView:tableView];
    cell.tenYImgView.hidden = YES;
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
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshCart" object:nil userInfo:nil];
        [self setItemBadge:[AppDelegate getAppDelegate].value];
        [self setBadgeValue:[AppDelegate getAppDelegate].value atIndex:3];
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
    
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_placeholder"];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView{
    return YES;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
