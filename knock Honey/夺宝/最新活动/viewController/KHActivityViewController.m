//
//  KHActivityViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/12/8.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHActivityViewController.h"
#import "KHActivity.h"
#import "KHActivityTableViewCell.h"
#import "KHQiandaoViewController.h"

@interface KHActivityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation KHActivityViewController
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"最新活动";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
}

- (void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KHActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"ActivityCell"];
    
    [self getLatestPubData];
    
}
- (void)getLatestPubData{
    NSMutableDictionary *parameter = [Utils parameter];
    [YWHttptool GET:PortOuter_prom parameters:parameter success:^(id responseObject){
        if ([responseObject[@"isError"] integerValue]) return ;
        self.dataArray = [KHActivity kh_objectWithKeyValuesArray:responseObject[@"result"]];
        [self.tableView reloadData];
    } failure:^(NSError *error){
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KHActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell" forIndexPath:indexPath];
    [cell setModel:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KHActivity *model = self.dataArray[indexPath.row];
    KHQiandaoViewController *VC = [[KHQiandaoViewController alloc]init];
    VC.title = @"最新活动";
    VC.urlStr = model.link;
    [self hideBottomBarPush:VC];
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
