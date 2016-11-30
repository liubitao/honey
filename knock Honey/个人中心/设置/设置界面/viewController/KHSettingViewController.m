//
//  KHSettingViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/21.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHSettingViewController.h"
#import "KHQiandaoViewController.h"

@interface KHSettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) NSArray *urlArray;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation KHSettingViewController

- (NSArray *)urlArray{
    if (!_urlArray) {
        _urlArray = @[PortNovice_coure,PortLottery_rule,PortCommon_problem,];
    }
    return _urlArray;
}

- (NSArray*)titles{
    if (!_titles) {
        _titles = @[@"新手帮助",@"开奖规则",@"常见问题",@"用户协议",@"清除缓存"];
    }
    return _titles;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, KscreenWidth, KscreenHeight-kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorHex(#EFEFF4);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorHex(#EFEFF4);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"设置";
    [self.view addSubview:self.tableView];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    view.backgroundColor = UIColorHex(#EFEFF4);
    
    if ([YWUserTool account]) {
        UIButton *quie = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, KscreenWidth - 60, 50)];
        quie.backgroundColor = kDefaultColor;
        [quie setTitle:@"注销登录" forState:UIControlStateNormal];
        [quie setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        quie.titleLabel.font = SYSTEM_FONT(20);
        [quie addTarget:self action:@selector(quie:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:quie];
        quie.layer.cornerRadius = 5;
        quie.layer.masksToBounds = YES;
        _tableView.tableFooterView = view;
    }else{
        _tableView.tableFooterView = [UIView new];
    }
   
    
   
    
}

- (void)quie:(UIButton *)sender{
    [UIAlertController showAlertViewWithTitle:@"提示" Message:@"确认退出" BtnTitles:@[@"确认",@"取消"] ClickBtn:^(NSInteger index) {
        if (index == 0) {
            [YWUserTool quit];
            [self.navigationController popToRootViewControllerAnimated:NO];
            [self.navigationController.tabBarController.tabBar hideBadgeValueAtIndex:3];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginPerson" object:nil];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell setLayoutMargins:UIEdgeInsetsZero];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        cell.textLabel.textColor = UIColorHex(#838383);
        cell.textLabel.font = SYSTEM_FONT(16);
    }
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 4) {//清除缓存
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
             [MBProgressHUD showSuccess:@"清除成功"];
        }];
    }else if (indexPath.row == 3){
        KHQiandaoViewController *VC = [[KHQiandaoViewController alloc]init];
        VC.urlStr = PortAgreement;
        VC.title = @"用户协议";
        [self hideBottomBarPush:VC];
    }else{
        KHQiandaoViewController *VC = [[KHQiandaoViewController alloc]init];
        VC.urlStr = self.urlArray[indexPath.row];
        VC.title = self.titles[indexPath.row];
        [self hideBottomBarPush:VC];
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
