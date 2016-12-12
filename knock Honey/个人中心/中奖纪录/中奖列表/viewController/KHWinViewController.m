//
//  KHWinViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/7.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHWinViewController.h"
#import "KHWinTableViewCell.h"
#import "KHWinCodeModel.h"
#import "KHEditAddressViewController.h"
#import "KHEditPhoneViewController.h"
#import "KHWantAppearController.h"
#import "KHAddressViewController.h"
#import "KHQiandaoViewController.h"


@interface KHWinViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,KHWinTableViewDelegate>{
    NSInteger _pageCount;
    UILabel *_winCount;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSoure;
@property (nonatomic,assign) BOOL loading;

@end

static NSString *Wincell = @"winCell";

@implementation KHWinViewController

- (NSMutableArray *)dataSoure{
    if (!_dataSoure) {
        _dataSoure = [NSMutableArray array];
    }
    return _dataSoure;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight+30, kScreenWidth, KscreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tag = 1;
        _tableView.tableHeaderView = [UIView new];
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"中奖纪录";
    _winCount = [[UILabel alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, 30)];
    _winCount.backgroundColor = UIColorHex(#F8F8F8);
    [self.view addSubview:_winCount];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self setRightImageNamed:@"help" action:@selector(rightClick)];
    
    //下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getLatestPubData];
        //结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf getMoreData];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KHWinTableViewCell" bundle:nil] forCellReuseIdentifier:Wincell];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tableView.mj_header beginRefreshing];
    [super viewWillAppear:animated];
}

- (void)rightClick{
    KHQiandaoViewController *VC = [[KHQiandaoViewController alloc]init];
    VC.urlStr = PortAdress_place;
    VC.title = @"收货地址引导";
    [self hideBottomBarPush:VC];
}

- (void)setLoading:(BOOL)loading{
    if (self.loading == loading) {
        return;
    }
    _loading = loading;
    
    [self.tableView reloadEmptyDataSet];
}

- (void)getLatestPubData{
    [MBProgressHUD showMessage:@"加载中..."];
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    parameter[@"p"] = @1;
    [YWHttptool GET:PortWin_list parameters:parameter success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        self.loading = YES;
        _pageCount = 1;
        self.dataSoure = [KHWinCodeModel kh_objectWithKeyValuesArray:responseObject[@"result"][@"list"]];
        NSString *strNum = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"num"]];
        if (strNum.integerValue == 0) {
            _winCount.text = @"   您还没有中奖纪录";
            _winCount.font = SYSTEM_FONT(14);
            _winCount.textColor = UIColorHex(D2DBDB);
        }else{
        NSString *str = [NSString stringWithFormat:@"    恭喜亲已经获得了%@个宝物",strNum];
        _winCount.attributedText = [Utils stringWith:str font1:SYSTEM_FONT(14) color1:UIColorHex(#D2DBDB) font2:SYSTEM_FONT(14) color2:kDefaultColor range:NSMakeRange(12, strNum.length)];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error){
        [MBProgressHUD hideHUD];
        self.loading = YES;
    }];
}

- (void)getMoreData{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    parameter[@"p"] = [NSNumber numberWithInteger:++_pageCount];
    [YWHttptool GET:PortWin_list parameters:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"isError"] integerValue] == 1) {
            return ;
        }
        [self.dataSoure addObjectsFromArray: [KHWinCodeModel kh_objectWithKeyValuesArray:responseObject[@"result"][@"list"]]];
        [self.tableView reloadData];
    } failure:^(NSError *error){
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSoure.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KHWinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Wincell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:self.dataSoure[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 190;
}

- (void)tableViewClick:(KHWinCodeModel*)model type:(KHWinCodeStateType)type{

    switch (type) {
        case KHWinCodeStateConfirm:
        {
            KHAddressViewController *addressVC = [[KHAddressViewController alloc]init];
            addressVC.chooseAdd = YES;
            addressVC.goodstype = model.goodstype.integerValue;
            addressVC.lotteryid = model.ID;
            [self hideBottomBarPush:addressVC];
        }
            break;
        case KHWinCodeStateNODeliver://等待发货
            [UIAlertController showAlertViewWithTitle:nil Message:@"请稍等,工作人员正在发货" BtnTitles:@[@"确定"] ClickBtn:nil];
            break;
        case KHWinCodeStateDelivery://等待晒单
        {
            KHWantAppearController *wantVC = [[KHWantAppearController alloc]init];
            wantVC.model = model;
            [self hideBottomBarPush:wantVC];
        }
            break;
        default:
            break;
    }
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
         return [UIImage imageNamed:@"empty_placeholder"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无此纪录";
    return [[NSAttributedString alloc] initWithString:text attributes:@{
        NSFontAttributeName:SYSTEM_FONT(15)
    }];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -64;
}

- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    return IMAGE_NAMED(@"duobao");
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return self.loading;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    [self.navigationController popToRootViewControllerAnimated:NO];
     UITabBarController *tabBarVC = (UITabBarController *)[AppDelegate getAppDelegate].window.rootViewController;
    [tabBarVC setSelectedIndex:0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
