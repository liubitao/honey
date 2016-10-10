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

static NSString * nopublished = @"nopublished";
static NSString * published = @"published";

@interface KHKnowViewController ()<UITableViewDataSource,UITableViewDelegate,KHKnowtableViewCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

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
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, KscreenHeight-kTabBarHeight-kNavigationBarHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    
    //下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         [self getLatestPubData];
        //结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    //开始下拉刷新
    [self.tableView.mj_header beginRefreshing];
    
    [_tableView registerNib:NIB_NAMED(@"KHKnowTableViewCell") forCellReuseIdentifier:nopublished];
    
}

- (void)getLatestPubData {
    for (int i=0; i<10; i++) {
        KHKnowModel *model = [[KHKnowModel alloc]init];
        [model start];
        [self.dataArray addObject:model];
    }
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KHKnowModel *model = _dataArray[indexPath.row];
    KHKnowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nopublished forIndexPath:indexPath];
    cell.delegate = self;
    [cell setModel:model indexPath:indexPath];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    KHKnowTableViewCell *tmpCell = (KHKnowTableViewCell *)cell;
    tmpCell.isDisplayed = YES;
    [tmpCell setModel:_dataArray[indexPath.row] indexPath:indexPath];
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
    
}

#pragma mark - LatestPublishCellDelegate
- (void)countdownDidEnd:(NSIndexPath *)indexpath {
    [_tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
