//
//  KHDetailViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/12.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHDetailViewController.h"
#import "KHDetailModel.h"
#import "TreasureDetailCell.h"
#import "TreasureDetailFooter.h"
#import "TreasureDetailHeader.h"
#import "KHQiandaoViewController.h"
#import "KHCodeViewController.h"
#import "YWCover.h"
#import "YWPopView.h"
#import "KHGoodsAppearController.h"
#import "KHPastViewController.h"

@interface KHDetailViewController ()<UITableViewDataSource,UITableViewDelegate,TreasureDetailFooterDelegate,YWCoverDelegate>{
    NSInteger _currentPage;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) TreasureDetailFooter *footer;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) KHCodeViewController *codeVC;

@end

@implementation KHDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavi];
    [self configBottomMenu];
    [self createTableView];
}

- (void)createNavi{
    self.title = @"奖品详情";
    [self setRightImageNamed:@"share" action:@selector(share)];
}

- (void)createTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, KscreenWidth, KscreenHeight - kNavigationBarHeight-60) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    if (_showType == TreasureDetailHeaderTypeCountdown) {
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval time=[dat timeIntervalSince1970];
        _count = ([_model.winner.newtime doubleValue]- time)*1000;
    }
    TreasureDetailHeader *header = [[TreasureDetailHeader alloc]initWithFrame:({
        CGRect rect = {0, 0, kScreenWidth, 1};
        rect;
    }) type:_showType countTime:_count Model:_model];
     _tableView.tableHeaderView = header;
    
    
    __weak typeof(self) weakSelf = self;
    
    header.codeBlock = ^{
//        KHCodeViewController *vc = self.codeVC;
//        NSArray *array = [model.codes componentsSeparatedByString:@","];
//        vc.dataArray = array.mutableCopy;
//        if (model.lottery){
//            vc.winCode = model.lottery.wincode;
//        }
//        [vc.ColloctionView reloadData];
//        //弹出蒙版
//        YWCover  *cover = [YWCover show];
//        cover.delegate = self;
//        [cover setDimBackground:YES];
//        
//        // 弹出pop菜单
//        YWPopView *menu = [YWPopView showInRect:CGRectZero];
//        menu.center = self.view.center;
//        menu.transform = CGAffineTransformMakeScale(0, 0);
//        [UIView animateWithDuration:0.5
//                         animations:^{
//                             menu.transform = CGAffineTransformIdentity;
//                         }];
//        menu.contentView = vc.view;
    };
    //详情中的选项
    header.clickMenuBlock = ^(id object){
        switch ([object integerValue]) {
            case 0: {//图文详情
                NSLog(@"图文详情");
            }
                break;
            case 1: {//晒单分享
                KHGoodsAppearController *goodsVC = [[KHGoodsAppearController alloc]init];
                goodsVC.goodsid = _goodsid;
                [weakSelf hideBottomBarPush:goodsVC];
            }
                break;
            case 2: {//往期揭晓
                KHPastViewController *pastVC = [[KHPastViewController alloc]init];
                pastVC.goodsid = _goodsid;
                [weakSelf hideBottomBarPush:pastVC];
            }
                break;
            default:
                break;
        }
 
    };
    __weak typeof(header) weakHeader = header;
    header.headerHeight = ^(){//头高
        weakHeader.height = 695-200+kScreenWidth/375*200-30+weakHeader.productNameLabel.height;
        weakSelf.tableView.tableHeaderView = weakHeader;
    };
    
    header.countDetailBlock = ^(){//计算详情
        KHQiandaoViewController *VC = [[KHQiandaoViewController alloc]init];
        NSString *str = [NSString stringWithFormat:@"%@?goodsid=%@&userid=%@",PortFormula,_goodsid,_model.winner.qishu];
        VC.urlStr = str;
        VC.title = @"计算详情";
        [weakSelf hideBottomBarPush:VC];
    };
    
    header.declareBlcok = ^(){//点击声明
        NSLog(@"声明");
    };

    
    //下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    //上拉刷新
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getMoreData];
        [weakSelf.tableView .mj_footer endRefreshing];
    }];
    [_tableView.mj_header beginRefreshing];
    
}
//获取数据
- (void)getData{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"p"] = @"1";
    parameter[@"goodsid"] = _goodsid;
    parameter[@"qishu"] = _model.qishu;
    _currentPage = 1;
    [YWHttptool GET:PortGoodsOrder parameters:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        _dataArray = [KHDetailModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络连接有误"];
    }];

}

- (void)getMoreData{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"p"] = [NSNumber numberWithInteger:++_currentPage];
    parameter[@"goodsid"] = _goodsid;
    parameter[@"qishu"] = _model.qishu;
    [YWHttptool GET:PortGoodsOrder parameters:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"isError"] integerValue])return ;
        NSArray *array = [KHDetailModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
        [_dataArray addObjectsFromArray:array];
        [_tableView reloadData];
    } failure:^(NSError *error){
        [MBProgressHUD showError:@"网络连接有误"];
    }];
}

//加载下面菜单视图
- (void)configBottomMenu{
    _footer = [[TreasureDetailFooter alloc]initWithType:(_showType==TreasureDetailHeaderTypeNotParticipate)?TreasureUnPublishedType:TreasurePublishedType Model:_model];
    _footer.delegate = self;
    [self.view addSubview:_footer];
}

//分享
- (void)share{
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TreasureDetailCell *cell = [TreasureDetailCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.model = _dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%ld",(long)indexPath.row);
}

//夺宝中下面的，点击按钮
- (void)clickMenuButtonWithIndex:(NSInteger)index{
    switch (index) {
        case 1:
            [self.tabBarController setSelectedIndex:3];
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        case 2:{
            NSMutableDictionary *parameter = [Utils parameter];
            parameter[@"userid"] = [YWUserTool account].userid;
            parameter[@"goodsid"] = _goodsid;
            [YWHttptool GET:PortAddCart parameters:parameter success:^(id responseObject) {
                if ([responseObject[@"isError"] integerValue]) return ;
                
                UIButton *firstbtn = [_footer viewWithTag:1];
                [firstbtn setBadgeValue:responseObject[@"result"][@"count_cart"]];

                [AppDelegate getAppDelegate].value = [responseObject[@"result"][@"count_cart"] integerValue];
                [self setBadgeValue:[AppDelegate getAppDelegate].value atIndex:3];
                //刷新购物车
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshCart" object:nil userInfo:nil];
            } failure:^(NSError *error) {
            }];
        }
            break;
        case 3:{
            NSMutableDictionary *parameter = [Utils parameter];
            parameter[@"userid"] = [YWUserTool account].userid;
            parameter[@"goodsid"] = _goodsid;
            [YWHttptool GET:PortAddCart parameters:parameter success:^(id responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject[@"isError"] integerValue]) return ;
                
                [AppDelegate getAppDelegate].value = [responseObject[@"result"][@"count_cart"] integerValue];
                [self setBadgeValue:[AppDelegate getAppDelegate].value atIndex:3];
                //刷新购物车
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshCart" object:nil userInfo:nil];
            } failure:^(NSError *error) {
            }];
        }
            break;
        default:
            break;
    }
}

//倒计时，进入新的一期
- (void)checkNewTreasre{
    [MBProgressHUD showMessage:@"加载中..."];
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"goodsid"] = _goodsid;
    parameter[@"qishu"] = _model.qishu;
    [YWHttptool GET:PortGoodsdetails parameters:parameter success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if ([responseObject[@"isError"] integerValue])return;
        KHDetailViewController *DetailVC = [[KHDetailViewController alloc]init];
        DetailVC.model = [KHProductModel kh_objectWithKeyValues:responseObject[@"result"]];
        DetailVC.goodsid = _goodsid;
        DetailVC.showType = TreasureDetailHeaderTypeNotParticipate;
        [self hideBottomBarPush:DetailVC];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络连接有误"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
