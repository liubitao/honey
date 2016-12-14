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
#import "KHCartMoreModel.h"
#import "KHCartMoreView.h"
#import "KHDetailViewController.h"
#import "KHSnatchListController.h"
#import "KHTabbarViewController.h"

@interface KHCartViewController ()<UITableViewDataSource,UITableViewDelegate,ShoppingListCellDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,KHCartMoreDelegate>
@property (nonatomic, strong) NSNumber *moneySum;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *deleteArray;
@property (nonatomic,strong) NSMutableArray *moreArray;
@property  (nonatomic,strong) UIView *bottomView;
@property (nonatomic,assign) BOOL loading;
/**
 *  下面视图
 */
@property (nonatomic,strong) BillView *billView;

@property (assign, nonatomic) BOOL isAllSelected;

@end

@implementation KHCartViewController

- (NSMutableArray *)moreArray{
    if (!_moreArray) {
        _moreArray = [NSMutableArray arrayWithCapacity:8];
    }
    return _moreArray;
}

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

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,KscreenHeight- kTabBarHeight - 190,KscreenWidth, 190)];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (BillView *)billView{
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(testBuy:)
                                                 name:@"testNOtification"
                                               object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"购物车";
    [self.view addSubview:self.tableView];
  
    [self setRightImageNamed:@"cartHelp" action:@selector(helpClick)];
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

- (void)testBuy:(NSNotification *)notice {
    NSString *str = [NSString stringWithFormat:@"%@", notice.object];
    if ([str isEqualToString:@"success"]) {
        [self getDatasource];
        KHSnatchListController *snatchVC = [[KHSnatchListController alloc]init];
        KHTabbarViewController *tab = (KHTabbarViewController *)[AppDelegate getAppDelegate].window.rootViewController;
        [tab pushOtherIndex:4 viewController:snatchVC];
        [UIAlertController showAlertViewWithTitle:nil Message:@"支付成功" BtnTitles:@[@"知道"] ClickBtn:nil];
    }else{
         [UIAlertController showAlertViewWithTitle:nil Message:@"支付取消" BtnTitles:@[@"知道"] ClickBtn:nil];
    }
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

- (void)setLoading:(BOOL)loading{
    if (self.loading == loading) {
        return;
    }
    _loading = loading;
    
    [self.tableView reloadEmptyDataSet];
}

- (void)getDatasource{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    [YWHttptool GET:PortIndex parameters:parameter success:^(id responseObject) {
         self.loading = YES;
        if ([responseObject[@"isError"] integerValue]){
             [self setupBillview];
            return ;
        };
        [_dataArray removeAllObjects];
        NSMutableArray *mutableArray = [KHcartModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
        for (KHcartModel *cartModel in mutableArray) {
            ShoppingListLayout *layout = [[ShoppingListLayout alloc]initWithModel:cartModel];
            [self.dataArray addObject:layout];
        }
        [self getMoneySum];
        [self setupBillview];
    } failure:^(NSError *error){
         self.loading = YES;
    }];
  
}

- (void)setupBillview {
    if (self.dataArray.count==0){
        _tableView.frame = CGRectMake(0,0,kScreenWidth,_isPushed?kScreenHeight:kScreenHeight- 190- kTabBarHeight);
         [self.tableView reloadData];
        self.leftBtn.hidden = YES;
        [self.billView removeFromSuperview];
        [self setBottomMoreView];
        [AppDelegate getAppDelegate].value = 0;
        [self setBadgeValue:[AppDelegate getAppDelegate].value atIndex:3];
        return;
    }
    _tableView.frame = CGRectMake(0,0,kScreenWidth,_isPushed?kScreenHeight:kScreenHeight- kTabBarHeight);
    [self.tableView reloadData];
    [self.bottomView removeFromSuperview];
    [self setLeftItemTitle:@"编辑" action:@selector(editList)];
    [self.view addSubview:self.billView];
    [_billView setMoneyNumber:_dataArray.count Sum:_moneySum];
    [self excuteBuyEvent];
    [self excuteDeleteEvent];
    [self excuteSelectEvent];
}

- (void)setBottomMoreView{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KscreenWidth, 30)];
    label.text = @"猜你喜欢";
    label.textColor = UIColorHex(#5D5D5D);
    label.font = SYSTEM_FONT(17);
    [self.bottomView addSubview:label];
    
    UIScrollView *moreScroollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, KscreenWidth, 140)];
    moreScroollView.bounces = NO;
    moreScroollView.showsHorizontalScrollIndicator = NO;
    moreScroollView.contentSize = CGSizeMake(120*8, 140);
    [self.bottomView addSubview:moreScroollView];
    
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"type"] = @"1";
    [YWHttptool GET:PortExten_goods parameters:parameter success:^(id responseObject) {
        if ([responseObject[@"isError"] integerValue]) return ;
        self.moreArray = [KHCartMoreModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
        for (int i = 0; i<self.moreArray.count; i++) {
            KHCartMoreView *view = [KHCartMoreView viewFromNIB];
            view.origin = CGPointMake(i*120, 0);
            [view setModel:self.moreArray[i]];
            view.delegate = self;
            [moreScroollView addSubview:view];
        }
    } failure:^(NSError *error) {
    }];
    
    [self.view addSubview:self.bottomView];
}

- (void)excuteBuyEvent{
    __weak typeof(self) weakSelf = self;
    _billView.buyBlock = ^{//提交订单
    [MBProgressHUD showMessage:@"提交订单..." ];
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
        [MBProgressHUD hideHUD];
        if ([responseObject[@"isError"] integerValue]) return ;
        KHPayModel *model = [KHPayModel kh_objectWithKeyValues:responseObject[@"result"]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *str = [defaults valueForKey:@"test"];
        if (str.integerValue == 1) {
            NSString *urlStr = [NSString stringWithFormat:@"%@?orderid=%@&userid=%@",PortOther_pay,model.orderid,[YWUserTool account].userid];
             [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlStr]];
            return ;
        }
        KHPayViewController *payVC = [[KHPayViewController alloc]init];
        payVC.payModel = model;
        [weakSelf pushController:payVC];
    } failure:^(NSError *error){
          [MBProgressHUD hideHUD];
    }];
    };
}

- (void)excuteDeleteEvent {
    __weak typeof(self) weakSelf = self;
    __weak typeof(_billView) weaKbillView = _billView;
    _billView.deleteBlock = ^{
    [UIAlertController showAlertViewWithTitle:nil Message:@"确定要删除吗?" BtnTitles:@[@"确定",@"取消"] ClickBtn:^(NSInteger index) {
                if (index==0) {
                    if (!weakSelf.tableView.editing){
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
                                weakSelf.tableView.frame = CGRectMake(0,0,kScreenWidth,weakSelf.isPushed?kScreenHeight:kScreenHeight- 190- kTabBarHeight);
                                [weakSelf.billView removeFromSuperview];
                                [weakSelf setBottomMoreView];
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
    VC.urlStr = PortShopping_help;
    VC.title = @"购物指南";
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
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"购物车空空如也";
    return [[NSAttributedString alloc] initWithString:text attributes:@{
                                                                        NSFontAttributeName:SYSTEM_FONT(15)
                                                                        }];
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


- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView{
    return UIColorHex(#F0F0F0);
}

- (void)clickPush:(KHCartMoreModel *)model{

    [MBProgressHUD showMessage:@"加载中..."];
    NSMutableDictionary *parameter = [Utils parameter];
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
        [self pushController:DetailVC];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
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
