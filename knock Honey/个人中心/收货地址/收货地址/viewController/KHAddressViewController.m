//
//  KHAddressViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/2.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHAddressViewController.h"
#import "KHAddressTableViewCell.h"
#import "KHPhoneTableViewCell.h"

@interface KHAddressViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSoure;
@property (nonatomic, getter=isLoading) BOOL loading;
@end
static NSString * addressCell = @"addressCell";
static NSString * phoneCell = @"phoneCell";
@implementation KHAddressViewController

- (NSMutableArray *)dataSoure{
    if (!_dataSoure) {
        _dataSoure = [NSMutableArray array];
    }
    return _dataSoure;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, KscreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.backgroundColor = UIColorHex(EFEFF4);
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self setRightImageNamed:@"add" action:@selector(addAddress)];
    //下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getLatestPubData];
        //结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    [self getLatestPubData];
    
    [self.tableView registerNib:NIB_NAMED(@"KHAddressTableViewCell") forCellReuseIdentifier:addressCell];
    [self.tableView registerNib:NIB_NAMED(@"KHPhoneTableViewCell") forCellReuseIdentifier:phoneCell];

}
- (void)addAddress{
    
}

- (void)setLoading:(BOOL)loading
{
    if (self.isLoading == loading) {
        return;
    }
    _loading = loading;
    
    [self.tableView reloadEmptyDataSet];
}


- (void)getLatestPubData{
    self.loading = YES;
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    [YWHttptool GET:PortAddress_list parameters:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        self.loading = NO;
        [self.tableView reloadData];
    } failure:^(NSError *error){
        self.loading = NO;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSoure.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KHAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCell forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [KHAddressTableViewCell height];
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.isLoading) {
        return [UIImage imageNamed:@"loading"];
    }
    return [UIImage imageNamed:@"empty_placeholder"];
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView{
    return YES;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView
{
    return self.isLoading;
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    [self getLatestPubData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
