//
//  KHGetJinfenViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/12.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHGetJinfenViewController.h"
#import "KHjifenModel.h"
#import "KHjifenTableViewCell.h"

@interface KHGetJinfenViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>{
    NSInteger _currentPage;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end
static NSString *jifenCell = @"jifenCell";
@implementation KHGetJinfenViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, kScreenHeight -kNavigationBarHeight -46 ) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.backgroundColor = UIColorHex(#F0F0F0);
        [_tableView setCustomSeparatorInset:UIEdgeInsetsZero];
        _tableView.tableFooterView = [UIView new];
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KHjifenTableViewCell" bundle:nil] forCellReuseIdentifier:jifenCell];
}

- (void)getData{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    parameter[@"type"] = @1;
    parameter[@"p"] = @1;
    [YWHttptool GET:PortScore_record parameters:parameter success:^(id responseObject) {
        _currentPage = 1;
        NSLog(@"%@",responseObject);
        self.dataArray = [KHjifenModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
        [self.tableView reloadData];
    } failure:^(NSError *error){
    }];
}

- (void)getMoreData{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    parameter[@"type"] = @1;
    parameter[@"p"] = @(++_currentPage);
    [YWHttptool GET:PortScore_record parameters:parameter success:^(id responseObject) {
        [self.dataArray addObjectsFromArray:[KHjifenModel kh_objectWithKeyValuesArray:responseObject[@"result"]]];
        [self.tableView reloadData];
    } failure:^(NSError *error){
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KHjifenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:jifenCell forIndexPath:indexPath];
    [cell setModel:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 30)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = @"时间";
    label3.textColor = UIColorHex(#6A6A6A);
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = SYSTEM_FONT(15);
    label3.origin = CGPointMake(20, 0);
    label3.size = CGSizeMake((KscreenWidth-60)/2, 30);
    [view addSubview:label3];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"类型";
    label2.textColor = UIColorHex(#6A6A6A);
    label2.font = SYSTEM_FONT(15);
    label2.textAlignment = NSTextAlignmentCenter;
    label2.origin = CGPointMake(label3.right +20, 0);
    label2.size = CGSizeMake(((KscreenWidth-60)/2-20)/2, 30);
    [view addSubview:label2];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"积分";
    label1.textColor = UIColorHex(#6A6A6A);
    label1.font = SYSTEM_FONT(15);
    label1.textAlignment = NSTextAlignmentCenter;
    label1.origin = CGPointMake(label2.right + 20, 0);
    label1.size = CGSizeMake(((KscreenWidth-60)/2-20)/2, 30);
    [view addSubview:label1]; 
    return view;
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_placeholder"];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
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
