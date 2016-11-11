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


@interface KHMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *array;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,strong) NSMutableDictionary *dict;
@end

@implementation KHMessageViewController

- (NSMutableArray*)titleArray{
    if (_titleArray == nil) {
        _titleArray = [NSMutableArray arrayWithArray:@[@"客服消息",@"中奖消息",@"发货消息",@"系统消息"]];
    }
    return _titleArray;
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
    [self.view addSubview:self.tableView];
    self.title = @"消息中心";
    array =@[@"kefu",@"zhongjiang",@"fahuo",@"xitong"];
    [self getData];
}

- (void)getData{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    [YWHttptool GET:PortMessage_count parameters:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        _dict = responseObject[@"result"];
        [self.tableView reloadData];
    } failure:^(NSError *error){
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"messageCell"];
        cell.detailTextLabel.textColor = kDefaultColor;
        cell.detailTextLabel.font = SYSTEM_FONT(13);
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.imageView.image = IMAGE_NAMED(self.imageArray[indexPath.row]);
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@)条未读",_dict[array[indexPath.row]]];
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
    KHzhongjiangViewController *VC = [[KHzhongjiangViewController alloc]init];
    VC.type = @(indexPath.row+1);
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
