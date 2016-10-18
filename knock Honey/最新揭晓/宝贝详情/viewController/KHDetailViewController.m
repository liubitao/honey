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

@interface KHDetailViewController ()<UITableViewDataSource,UITableViewDelegate,TreasureDetailFooterDelegate>{
    NSInteger _currentPage;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) TreasureDetailFooter *footer;
@property (nonatomic,strong) NSMutableArray *dataArray;

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
    //详情中的选项
    header.clickMenuBlock = ^(id object){
        switch ([object integerValue]) {
            case 0: {//图文详情
                NSLog(@"图文详情");
            }
                break;
            case 1: {//晒单分享
                NSLog(@"晒单分享");
            }
                break;
            case 2: {//往期揭晓
                NSLog(@"往期揭晓");
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
        NSLog(@"计算详情");
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
    _footer = [[TreasureDetailFooter alloc]initWithType:(_showType==TreasureDetailHeaderTypeNotParticipate)?TreasureUnPublishedType:TreasurePublishedType];
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
    NSLog(@"%d",indexPath.row);
}

//夺宝中下面的，点击按钮
- (void)clickMenuButtonWithIndex:(NSInteger)index{
    switch (index) {
        case 1:
            NSLog(@"点击了购物车图标");
            break;
        case 2:
            NSLog(@"点击了加入购物车");
            break;
        case 3:
            NSLog(@"点击了立即购物");
            break;
        default:
            break;
    }
}

//倒计时，进入新的一期
- (void)checkNewTreasre{
    NSLog(@"进入新一期");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
