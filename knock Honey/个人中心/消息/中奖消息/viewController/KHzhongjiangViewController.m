//
//  KHzhongjiangViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/11.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHzhongjiangViewController.h"
#import "KHMessageModel.h"
#import "KHMessageTableViewCell.h"

@interface KHzhongjiangViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>{
    NSInteger _pageCount;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation KHzhongjiangViewController


- (NSMutableArray*)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, KscreenWidth, KscreenHeight-kNavigationBarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorHex(F0F0F0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *array = @[@"客服消息",@"中奖消息",@"发货消息",@"系统消息"];
    self.title = array[_type.integerValue -1];
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
    

    [self.tableView registerNib:[UINib nibWithNibName:@"KHMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"zhongjiangCell"];
}

- (void)getLatestPubData{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    parameter[@"type"] = _type;
    parameter[@"p"] = @1;
    [YWHttptool GET:PortMessage_list parameters:parameter success:^(id responseObject){
        if ([responseObject[@"isError"] integerValue]) return ;
        _pageCount = 1;
        self.dataArray = [KHMessageModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
        [self.tableView reloadData];
    } failure:^(NSError *error){
    }];
}

- (void)getMoreData{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    parameter[@"type"] = _type;
    parameter[@"p"] = @(++_pageCount);
    [YWHttptool GET:PortMessage_list parameters:parameter success:^(id responseObject){
        if ([responseObject[@"isError"] integerValue]) return ;
        [self.dataArray addObjectsFromArray:[KHMessageModel kh_objectWithKeyValuesArray:responseObject[@"result"]]];
        [self.tableView reloadData];
    } failure:^(NSError *error){
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KHMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zhongjiangCell" forIndexPath:indexPath];
    [cell setModel:_dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    KHMessageModel *model = _dataArray[indexPath.row];
    CGRect rect = [model.content boundingRectWithSize:CGSizeMake(KscreenWidth - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
    return  45 + rect.size.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
