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
        _titleArray = [NSMutableArray arrayWithArray:@[@[@"中奖纪录",@"夺宝纪录",@"我的晒单",@"我的红包",@"收货地址",@"卡密自提",@"全价购买纪录"],@[@"免费抢币"],@[@"客服",@"消息"]]];
    }
    return _titleArray;
}

- (NSMutableArray*)imageArray{
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray arrayWithArray:@[@[@"winList",@"takeList",@"apperList",@"paperMoney",@"address",@"card",@"winList"],@[@"coin"],@[@"phone",@"messages"]]];
    }
    return _imageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTopupResult:) name:@"kTopupNotification" object:nil];
    [self configNavi];
    [self configTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
#pragma mark - notice
- (void)getTopupResult:(NSNotification *)notice {
    NSString *remainSum = (NSString *)notice.object;
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
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 30)];
    label.text = @"声明：所有奖品抽奖活动与苹果公司(Apple Inc)无关";
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColorHex(999999);
    self.tableView.tableFooterView = label;
    [self.tableView registerNib:NIB_NAMED(@"KHPersonCell") forCellReuseIdentifier:@"personCell"];
}

- (void)setupHeader{
    _header = [[KHPersonHeader alloc]initWithFrame:({
        CGRect rect = {0, 0, kScreenWidth, 190};
        rect;
    })];
    _tableView.tableHeaderView = _header;
    __weak typeof(self) weakSelf = self;
    _header.settingBlock = ^{
        NSLog(@"设置");
        [YWUserTool quit];
    };
    
    _header.headImgBlock = ^{
        KHInformationController *inforVC = [[KHInformationController alloc]init];
        [weakSelf pushController:inforVC];
    };
    
    _header.topupBlock = ^{
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
    switch (section) {
        case 0:
            return 7;
        case 1:
            return 1;
        case 2:
            return 2;
    }
    return 1;
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
    if (indexPath.section == 0) {
        if (indexPath.row == 4) {//地址管理
            KHAddressViewController *addresVC = [[KHAddressViewController alloc]init];
            [self pushController:addresVC];
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
