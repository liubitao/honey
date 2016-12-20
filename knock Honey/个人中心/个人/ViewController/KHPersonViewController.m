//
//  KHPersonViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/10.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHPersonViewController.h"
#import "KHPersonCell.h"
#import "KHPersonHeader.h"
#import "KHTopupViewController.h"
#import "KHInformationController.h"
#import "KHAddressViewController.h"
#import "KHWinViewController.h"
#import "KHBounsViewController.h"
#import "KHMyAppearViewController.h"
#import "KHMessageViewController.h"
#import "KHFreeViewController.h"
#import "KHSnatchListController.h"
#import "KHSettingViewController.h"
#import "KHLoginViewController.h"
#import "KHRegiterViewController.h"
#import "KHQiandaoViewController.h"
#import <MJExtension.h>

@interface KHPersonViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) NSMutableArray *imageArray;
/**
 *  头视图
 */
@property (nonatomic,strong) KHPersonHeader *header;

@end

@implementation KHPersonViewController

- (NSMutableArray*)titleArray{
    if (_titleArray == nil) {
        _titleArray = [NSMutableArray arrayWithArray:@[@[@"中奖纪录",@"夺宝纪录",@"我的晒单",@"我的红包",@"收货地址"],@[@"免费抢币"],@[@"客服",@"消息"]]];
    }
    return _titleArray;
}

- (NSMutableArray*)imageArray{
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray arrayWithArray:@[@[@"winList",@"takeList",@"apperList",@"paperMoney",@"address"],@[@"coin"],@[@"phone",@"messages"]]];
    }
    return _imageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTopupResult:) name:@"kTopupNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshenPerson) name:@"freshenPerson" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:@"loginPerson" object:nil];
    [self configNavi];
    [self configTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)freshenPerson{
    [_header freshen];
}

- (void)login{
    [_header setType:[YWUserTool account]? KHPersonLogin:KHPersonNOLogin];
}
#pragma mark - notice
- (void)getTopupResult:(NSNotification *)notice {
    NSString *remainSum = [NSString stringWithFormat:@"%@", notice.object];
    _header.remainSum = remainSum;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)configNavi{
    [self setBackItem];
}

- (void)configTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-kTabBarHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self setupHeader];
    
    //下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getDatasource];
        [weakSelf.tableView.mj_footer resetNoMoreData];
        //结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 30)];
    label.text = @"声明：所有奖品抽奖活动与苹果公司(Apple Inc)无关";
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColorHex(999999);
    self.tableView.tableFooterView = label;
    [self.tableView registerNib:NIB_NAMED(@"KHPersonCell") forCellReuseIdentifier:@"personCell"];
}

- (void)getDatasource{
    if ([YWUserTool account]){
        NSMutableDictionary *parameter = [Utils parameter];
        parameter[@"userid"] = [YWUserTool account].userid;
        [YWHttptool GET:PortOther_user parameters:parameter success:^(id responseObject) {
            if ([responseObject[@"isError"] integerValue]) return ;
            YWUser *user = [YWUser mj_objectWithKeyValues:responseObject[@"result"]];
            [YWUserTool saveAccount:user];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"freshenPerson" object:nil];
        } failure:^(NSError *error){
            
        }];
    }
}

- (void)setupHeader{
    _header = [[KHPersonHeader alloc]initWithFrame:({
        CGRect rect = {0, 0, kScreenWidth, 190};
        rect;
    }) with:[YWUserTool account] ? KHPersonLogin:KHPersonNOLogin];
    _tableView.tableHeaderView = _header;
    __weak typeof(self) weakSelf = self;
    
    _header.loginBlock = ^(UIButton *button){//登陆注册
        if (button.tag == 112) {
            KHLoginViewController *vc = [[KHLoginViewController alloc]init];
            KHNavigationViewController *nav = [[KHNavigationViewController alloc] initWithRootViewController:vc];
            [weakSelf presentViewController:nav animated:YES completion:nil];
        }else if (button.tag == 110){
            KHRegiterViewController *vc = [[KHRegiterViewController alloc]init];
            KHNavigationViewController *nav = [[KHNavigationViewController alloc] initWithRootViewController:vc];
            [weakSelf presentViewController:nav animated:YES completion:nil];
        }
    };
    _header.settingBlock = ^{//设置
        KHSettingViewController *settingVC = [[KHSettingViewController alloc]init];
        [weakSelf pushController:settingVC];
    };
    
    _header.headImgBlock = ^{//头像
        KHInformationController *inforVC = [[KHInformationController alloc]init];
        [weakSelf pushController:inforVC];
    };
    
    _header.topupBlock = ^{//充值
        KHTopupViewController *topupVC = [[KHTopupViewController alloc]init];
        [weakSelf pushController:topupVC];
    };
    
    _header.diamondBlock = ^{
        NSLog(@"积分");
    };

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.titleArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KHPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personCell" forIndexPath:indexPath];
    [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    cell.title.text = _titleArray[indexPath.section][indexPath.row];
    cell.pic.image = IMAGE_NAMED(self.imageArray[indexPath.section][indexPath.row]);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![YWUserTool account]) {
        [MBProgressHUD showError:@"请先登陆"];
        return;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//中奖
            KHWinViewController *winVC = [[KHWinViewController alloc]init];
            [self pushController:winVC];
        }else if (indexPath.row == 1){//夺宝纪录
            KHSnatchListController *snatchVC = [[KHSnatchListController alloc]init];
            [self pushController:snatchVC];
        }
        else if (indexPath.row == 2) {//我的晒单
            KHMyAppearViewController *myAppearVC = [[KHMyAppearViewController alloc]init];
            [self pushController:myAppearVC];
        }else if (indexPath.row == 3) {//我的红包
            KHBounsViewController *bounsVC = [[KHBounsViewController alloc]init];
            [self pushController:bounsVC];
        }else if (indexPath.row == 4) {//地址管理
            KHAddressViewController *addresVC = [[KHAddressViewController alloc]init];
            [self pushController:addresVC];
        }
    }else if (indexPath.section == 1){//免费抢币
        KHFreeViewController *freeVC = [[KHFreeViewController alloc]init];
        [self pushController:freeVC];
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {//客服
            KHQiandaoViewController *VC = [[KHQiandaoViewController alloc]init];
            VC.urlStr = PortCommon_problem;
            VC.title = @"常见问题";
            [self pushController:VC];
        }else if (indexPath.row == 1){//消息
            KHMessageViewController *messageVC= [[KHMessageViewController alloc]init];
            [self pushController:messageVC];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0) {
        [_header makeScaleForScrollView:scrollView];;
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
