//
//  KHCartViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/10.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHCartViewController.h"
#import "BillView.h"
#import "ShoppingListCell.h"
#import "KHcartModel.h"
#import "ShoppingListLayout.h"
#import <MJExtension.h>
#import "KHPayViewController.h"
#import "KHPayModel.h"
#import "KHQiandaoViewController.h"

@interface KHCartViewController ()<UITableViewDataSource,UITableViewDelegate,ShoppingListCellDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong) NSNumber *moneySum;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *deleteArray;
/**
 *  下面视图
 */
@property (nonatomic,strong) BillView *billView;

@property (assign, nonatomic) BOOL isAllSelected;

@end

@implementation KHCartViewController

- (NSMutableArray *)deleteArray {
    if (!_deleteArray) {
        _deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:({
            CGRect rect = {0,0,kScreenWidth,_isPushed?kScreenHeight-[BillView getHeight]:kScreenHeight-[BillView getHeight]-kTabBarHeight};
            rect;
        }) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.allowsMultipleSelection = YES;
        _tableView.allowsSelectionDuringEditing = YES;
        [_tableView setCustomSeparatorInset:UIEdgeInsetsZero];
        _tableView.editing = NO;
    }
    return _tableView;
}

- (BillView *)billView {
    if (!_billView) {
        _billView = [[BillView alloc]initWithFrame:({
            CGRect rect = {0,_isPushed ? kScreenHeight-[BillView getHeight] : kScreenHeight-[BillView getHeight]-kTabBarHeight, kScreenWidth, [BillView getHeight]};
            rect;
        })];
    }
    return _billView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEvent)
                                                 name:@"refreshCart"
                                               object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"购物车";
    [self.view addSubview:self.tableView];
  
    [self setRightImageNamed:@"help" action:@selector(helpClick)];
    //下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getDatasource];
        //结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    //开始下拉刷新
    [self.tableView.mj_header beginRefreshing];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)notificationCenterEvent{
    [self getDatasource];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshe];
}

//购物车批量更新
- (void)refreshe{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    NSMutableArray *array = [NSMutableArray array];
    for (ShoppingListLayout *layout in self.dataArray) {
        [array addObject:layout.model.mj_keyValues];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    parameter[@"cart"] = jsonString;
    [YWHttptool Post:PortCart_change parameters:parameter success:^(id responseObject){
    } failure:^(NSError *error){
    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _tableView.editing = NO;
    [_billView setNormalStyle];
}


- (void)getDatasource{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    [YWHttptool GET:PortIndex parameters:parameter success:^(id responseObject) {
        if ([responseObject[@"isError"] integerValue]) return ;
        [_dataArray removeAllObjects];
        NSMutableArray *mutableArray = [KHcartModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
        for (KHcartModel *cartModel in mutableArray) {
            ShoppingListLayout *layout = [[ShoppingListLayout alloc]initWithModel:cartModel];
            [self.dataArray addObject:layout];
        }
        [self.tableView reloadData];
        [self getMoneySum];
        [self setupBillview];
    } failure:^(NSError *error) {
    }];
  
}

- (void)setupBillview {
    if (self.dataArray.count==0) {
        _tableView.frame = CGRectMake(0,0,kScreenWidth,_isPushed?kScreenHeight:kScreenHeight-kTabBarHeight);
        self.leftBtn.hidden = YES;
        [self.billView removeFromSuperview];
        [AppDelegate getAppDelegate].value = 0;
        [self setBadgeValue:[AppDelegate getAppDelegate].value atIndex:3];
        return;
    }
    [self setLeftItemTitle:@"编辑" action:@selector(editList)];
    [self.view addSubview:self.billView];
    [_billView setMoneyNumber:_dataArray.count Sum:_moneySum];
    [self excuteBuyEvent];
    [self excuteDeleteEvent];
    [self excuteSelectEvent];
}

- (void)excuteBuyEvent{
    __weak typeof(self) weakSelf = self;
    _billView.buyBlock = ^{//提交订单
        [MBProgressHUD showMessage:@"提交订单..." toView:weakSelf.tableView];
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    NSMutableArray *array = [NSMutableArray array];
    for (ShoppingListLayout *layout in weakSelf.dataArray) {
        [array addObject:layout.model.mj_keyValues];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    parameter[@"cart"] = jsonString;
    [YWHttptool Post:PortOrder_submit parameters:parameter success:^(id responseObject){
        NSLog(@"%@",responseObject);
        [MBProgressHUD hideHUDForView:weakSelf.tableView];
        if ([responseObject[@"isError"] integerValue]) return ;
        KHPayModel *model = [KHPayModel kh_objectWithKeyValues:responseObject[@"result"]];
        KHPayViewController *payVC = [[KHPayViewController alloc]init];
        payVC.payModel = model;
        [weakSelf pushController:payVC];
    } failure:^(NSError *error){
          [MBProgressHUD hideHUDForView:weakSelf.tableView];
    }];
    };
}

- (void)excuteDeleteEvent {
    __weak typeof(self) weakSelf = self;
   
    __weak typeof(_billView) weaKbillView = _billView;
    _billView.deleteBlock = ^{
    [UIAlertController showAlertViewWithTitle:nil Message:@"确定要删除吗?" BtnTitles:@[@"取消",@"确定"] ClickBtn:^(NSInteger index) {
                if (index==1) {
                    if (!weakSelf.tableView.editing) {
                        return;
                    }
                    [weakSelf.deleteArray removeAllObjects];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        NSMutableArray *indexPaths = [NSMutableArray array];
                        [weakSelf.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            ShoppingListLayout *layout = (ShoppingListLayout *)obj;
                            if (layout.model.isChecked) {
                                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                                [indexPaths addObject:indexPath];
                                [weakSelf.deleteArray addObject:layout];
                            }
                        }];
                        
                        NSMutableString *str = [NSMutableString string];
                        for (ShoppingListLayout *layout in weakSelf.deleteArray) {
                            if ([Utils isNull:str]) {
                                [str appendString:layout.model.goodsid];
                            }else{
                            [str appendString:[NSString stringWithFormat:@",%@",layout.model.goodsid]];
                            }
                        }
                        
                        NSMutableDictionary *parameter = [Utils parameter];
                        parameter[@"userid"] = [YWUserTool account].userid;
                        parameter[@"goodsid"] = str;
                        [YWHttptool GET:PortCart_del parameters:parameter success:^(id responseObject) {
                            if ([responseObject[@"isError"] integerValue]) return;
                            //删除
                            NSInteger dataCount = weakSelf.dataArray.count;
                            [weakSelf.dataArray removeObjectsInArray:weakSelf.deleteArray];
                            [weakSelf getMoneySum];
                            [weaKbillView setMoneyNumber:weakSelf.dataArray.count Sum:weakSelf.moneySum];
                            [weakSelf editList];
                            if (weakSelf.deleteArray.count == dataCount) {
                                weakSelf.leftBtn.hidden = YES;
                                weakSelf.tableView.frame = CGRectMake(0,0,kScreenWidth,weakSelf.isPushed?kScreenHeight:kScreenHeight-kTabBarHeight);
                                [weakSelf.billView removeFromSuperview];
                            }
                            [AppDelegate getAppDelegate].value = [AppDelegate getAppDelegate].value -weakSelf.deleteArray.count;
                            [weakSelf setBadgeValue:[AppDelegate getAppDelegate].value atIndex:3];
                        } failure:^(NSError *error) {
                        }];
                    
                    });
                    }
        }];
    };
}
- (void)excuteSelectEvent {
    __weak typeof(self) weakSelf = self;
    _billView.selectBlock = ^(UIButton *sender) {
        if (!weakSelf.billView.isSelect) {
            [weakSelf.billView setAttributeTitle:[NSString stringWithFormat:@"全选\n已选中0件商品"]forState:UIControlStateNormal];
            [weakSelf selectAllProducts:NO];
            weakSelf.isAllSelected = NO;
            [weakSelf.tableView reloadData];
            return;
        }
        weakSelf.isAllSelected = YES;
        [weakSelf.billView setAttributeTitle:[NSString stringWithFormat:@"取消全选\n已选中%@件商品",@(weakSelf.dataArray.count)] forState:UIControlStateSelected];
        [weakSelf selectAllProducts:YES];
    };
}

- (void)selectAllProducts:(BOOL)isChecked {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ShoppingListLayout *layout = (ShoppingListLayout *)obj;
            layout.model.isChecked = isChecked;
            [_dataArray replaceObjectAtIndex:idx withObject:layout];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!isChecked) {
                return;
            }
            [_tableView reloadData];
        });
    });
}

#pragma mark - 编辑消息
- (void)editList {
    NSString *string = [self.leftBtn titleForState:UIControlStateNormal];
    if ([string isEqualToString:@"编辑"]) {
        [_billView setDeleteStyle];
        [self setLeftItemTitle:@"取消" action:@selector(editList)];
    } else if ([string isEqualToString:@"取消"]) {
        [_billView setNormalStyle];
        [self selectAllProducts:NO];
        [self setLeftItemTitle:@"编辑" action:@selector(editList)];
    }
    [_tableView setEditing:!_tableView.editing animated:YES];
    [_tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
}
/**
 *  点击右边的帮助
 */
- (void)helpClick{
    KHQiandaoViewController *VC = [[KHQiandaoViewController alloc]init];
    VC.urlStr = PortNovice_coure;
    VC.title = @"新手帮助";
    [self pushController:VC];
}

- (void)getMoneySum {
        __weak typeof(self) weakSelf = self;
        __block NSInteger sum = 0;
        [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                  NSUInteger idx,
                                                  BOOL * _Nonnull stop) {
            ShoppingListLayout *oneLayout = (ShoppingListLayout *)obj;
            KHcartModel *model = oneLayout.model;
            sum += oneLayout.model.buynum.integerValue *(model.price.integerValue);
            weakSelf.moneySum = @(sum);
        }];
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingListLayout *layout = (ShoppingListLayout *)_dataArray[indexPath.row];
    ShoppingListCell *cell = [ShoppingListCell cellWithTableView:tableView];
    cell.layout = layout;
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell setChecked:layout.model.isChecked];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingListLayout *layout = _dataArray[indexPath.row];
    return layout.height;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!tableView.editing) {
        return;
    }
    EditingCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    ShoppingListLayout *layout = _dataArray[indexPath.row];
    layout.model.isChecked = !layout.model.isChecked;
    [cell setChecked:layout.model.isChecked];
    int i = 0;
    for (ShoppingListLayout *layout in _dataArray) {
        if (layout.model.isChecked==YES) {
            i++;
        }
    }
    NSString *title = i>=_dataArray.count?[NSString stringWithFormat:@"取消全选\n已选中%@件商品",@(_dataArray.count)]:[NSString stringWithFormat:@"全选\n已选中%@件商品",@(i)];
    if (i >= _dataArray.count) {
        [_billView setSelected:YES];
        [_billView setAttributeTitle:title forState:UIControlStateSelected];
    } else {
        [_billView setSelected:NO];
        [_billView setAttributeTitle:title forState:UIControlStateNormal];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}


#pragma mark - ShoppingListCellDelegate
- (void)listCount:(NSNumber *)listCount atIndexPath:(NSIndexPath *)indexPath {
    ShoppingListLayout *layout = _dataArray[indexPath.row];
    layout.model.buynum = [NSString stringWithFormat:@"%@",listCount];
    [_dataArray replaceObjectAtIndex:indexPath.row withObject:layout];
    [self getMoneySum];
    [_billView setMoneyNumber:_dataArray.count Sum:_moneySum];
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
    //开始下拉刷新
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
