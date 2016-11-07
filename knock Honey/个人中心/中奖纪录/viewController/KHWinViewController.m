//
//  KHWinViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/7.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHWinViewController.h"
#import "KHWinTableViewCell.h"


@interface KHWinViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>{
    NSInteger _pageCount;
    UILabel *_winCount;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSoure;

@property (nonatomic, getter=isLoading) BOOL loading;

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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, KscreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tag = 1;
        _tableView.tableHeaderView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"中奖纪录";
    _winCount = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    _winCount.backgroundColor = UIColorHex(#F8F8F8);
    [self.view addSubview:_winCount];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self setRightImageNamed:@"help" action:@selector(rightClick)];
    [self getLatestPubData];
    
    
    //下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getLatestPubData];
        //结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    [self getLatestPubData];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf getMoreData];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KHWinTableViewCell" bundle:nil] forCellReuseIdentifier:Wincell];
}

- (void)rightClick{
    
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
    _pageCount = 0;
    self.loading = YES;
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    parameter[@"p"] = [NSNumber numberWithInteger:_pageCount];
    [YWHttptool GET:PortWin_list parameters:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        self.loading = NO;
        [self.tableView reloadData];
    } failure:^(NSError *error){
        self.loading = NO;
    }];
}

- (void)getMoreData{
    self.loading = YES;
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    parameter[@"p"] = [NSNumber numberWithInteger:++_pageCount];
    [YWHttptool GET:PortWin_list parameters:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        self.loading = NO;
        NSString *strNumber = [NSString stringWithFormat:@"%d",self.dataSoure.count];
        NSString *str = [NSString stringWithFormat:@"恭喜亲已经获得了%d个宝物",self.dataSoure.count];
        _winCount.attributedText = [Utils stringWith:str font1:SYSTEM_FONT(14) color1:UIColorHex(CDCDCD) font2:SYSTEM_FONT(14) color2:kDefaultColor range:NSMakeRange(8, strNumber.length)];
        [self.tableView reloadData];
    } failure:^(NSError *error){
        self.loading = NO;
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
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 190;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
