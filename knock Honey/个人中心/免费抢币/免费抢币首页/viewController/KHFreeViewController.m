//
//  KHFreeViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/11.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHFreeViewController.h"
#import "KHFreeTableViewCell.h"
#import "KHFreeModel.h"
#import "KHCoupon.h"
#import "KHFreeHeaderView.h"
#import "KHjJinfenlistViewController.h"
#import "KHQiandaoViewController.h"

@interface KHFreeViewController ()<UITableViewDataSource,UITableViewDelegate,KHFreeCellDelegate>{
    KHFreeHeaderView *headerView;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) KHFreeModel *freeModel;
@end

static NSString *FreeCell = @"FreeCell";
@implementation KHFreeViewController


- (NSMutableArray*)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, KscreenWidth, KscreenHeight-kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColorHex(#EEF3FA);
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    self.title = @"免费抢币";
    
   headerView = [[KHFreeHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 160) model:_freeModel];
    self.tableView.tableHeaderView = headerView;
    __weak typeof(self) weakSelf = self;
    headerView.FreeBlock = ^(NSInteger i){
        if (i == 1) {//积分明细
            KHjJinfenlistViewController *jinfenVC = [[KHjJinfenlistViewController alloc]init];
            [weakSelf hideBottomBarPush:jinfenVC];
        }else if(i == 2){//签到
            KHQiandaoViewController *VC = [[KHQiandaoViewController alloc]init];
            NSString *str = [NSString stringWithFormat:@"%@?userid=%@",PortSign_index,[YWUserTool account].userid];
            VC.urlStr = str;
            VC.title = @"签到";
            [weakSelf hideBottomBarPush:VC];
        }
    };
    
    [self getData];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KHFreeTableViewCell" bundle:nil] forCellReuseIdentifier:FreeCell];
}

- (void)getData{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    [YWHttptool GET:PortScore_coupon parameters:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        _freeModel = [KHFreeModel kh_objectWithKeyValues:responseObject[@"result"]];
        
        [headerView reSetModel:_freeModel];
        self.dataArray = _freeModel.coupons;
        [self.tableView reloadData];
    } failure:^(NSError *error){
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KHFreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FreeCell forIndexPath:indexPath];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    cell.delegate =  self;
    [cell setModel:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    view.origin = CGPointMake(0, 0);
    view.size = CGSizeMake(kScreenWidth, 50);
    
    UIView *view1 = [UIView new];
    view1.backgroundColor = UIColorHex(#F0F6FD);
    view1.origin = CGPointMake(0, 0);
    view1.size = CGSizeMake(kScreenWidth, 10);
    [view addSubview:view1];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth/2, 40)];
    label1.text = @"积分兑换红包";
    label1.font = SYSTEM_FONT(16);
    [view addSubview:label1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 49, kScreenWidth, 1)];
    line2.backgroundColor = UIColorHex(#6A6A6A);
    [view addSubview:line2];
    return view;
}

- (void)submit:(KHCoupon *)model{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    parameter[@"couponid"] = model.ID;
    [YWHttptool GET:PortScore_coupon_handle parameters:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"isError"] integerValue]) {
            [MBProgressHUD showError:@"兑换失败"];
            return;
        };
        [MBProgressHUD showSuccess:@"兑换成功"];
    } failure:^(NSError *error){
        [MBProgressHUD showError:@"兑换失败"];
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
