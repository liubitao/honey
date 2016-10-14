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

@interface KHDetailViewController ()<UITableViewDataSource,UITableViewDelegate,TreasureDetailFooterDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) TreasureDetailFooter *footer;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation KHDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
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
    
    TreasureDetailHeader *header = [[TreasureDetailHeader alloc]initWithFrame:({
        CGRect rect = {0, 0, kScreenWidth, 1};
        rect;
    }) type:_showType countTime:_count];
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
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
    }];
    [_tableView.mj_header beginRefreshing];
    
}
//获取数据
- (void)getData{
    for (int i=0; i<8; i++) {
        KHDetailModel *model = [[KHDetailModel alloc]init];
        [self.dataArray addObject:model];
    }
    [_tableView reloadData];
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
