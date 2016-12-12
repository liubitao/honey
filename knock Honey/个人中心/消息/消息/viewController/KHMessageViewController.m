//
//  KHMessageViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/11.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHMessageViewController.h"
#import "KHMessageModel.h"
#import <MJExtension.h>
#import "KHzhongjiangViewController.h"
#import "KHdisListViewController.h"
#import "KHPersonCell.h"
#import "KHXitongViewController.h"
#import "KHQiandaoViewController.h"

@interface KHMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,strong) NSMutableDictionary *dict;
@property (nonatomic,strong) NSArray *paraArray;
@end

@implementation KHMessageViewController

- (NSMutableArray*)titleArray{
    if (_titleArray == nil) {
        _titleArray = [NSMutableArray arrayWithArray:@[@"客服消息",@"中奖消息",@"发货消息",@"系统消息"]];
    }
    return _titleArray;
}

- (NSArray *)paraArray{
    if (_paraArray == nil) {
        _paraArray = @[@"",@"zhongjiang",@"fahuo",@""];
    }
    return _paraArray;
}

- (NSMutableArray*)imageArray{
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray arrayWithArray:@[@"service",@"Winning",@"send",@"system"]];
    }
    return _imageArray;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, KscreenWidth, KscreenHeight-kNavigationBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"消息中心";
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KHPersonCell" bundle:nil] forCellReuseIdentifier:@"personCell"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self request];
}
- (void)request{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    [YWHttptool GET:PortMessage_count parameters:parameter success:^(id responseObject) {
        if ([responseObject[@"isError"] integerValue] ) return ;
        _dict = responseObject[@"result"];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KHPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personCell" forIndexPath:indexPath] ;
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    NSString *string = [NSString stringWithFormat:@"%@",self.dict[self.paraArray[indexPath.row]]];
    cell.detailTextLabel.text = string.integerValue ? string:@"";
    cell.title.text = self.titleArray[indexPath.row];
    cell.pic.image = IMAGE_NAMED(self.imageArray[indexPath.row]);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {//客服
        KHQiandaoViewController *VC = [[KHQiandaoViewController alloc]init];
        VC.urlStr = PortCommon_problem;
        VC.title = @"常见问题";
        [self hideBottomBarPush:VC];
    }else if (indexPath.row == 1) {//中奖
        KHzhongjiangViewController *VC = [[KHzhongjiangViewController alloc]init];
        VC.type = @(indexPath.row+1);
        [self hideBottomBarPush:VC];
    }else if (indexPath.row == 2) {//物流
        KHdisListViewController *disListVC = [[KHdisListViewController alloc]init];
        [self hideBottomBarPush:disListVC];
    }else if (indexPath.row == 3){//系统
        KHXitongViewController *xitongVC = [[KHXitongViewController alloc]init];
        [self hideBottomBarPush:xitongVC];
    }
  
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
