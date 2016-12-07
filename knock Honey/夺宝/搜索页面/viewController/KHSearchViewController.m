//
//  KHSearchViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/11.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHSearchViewController.h"
#import "SearchBar.h"
#import "KHSearchModel.h"
#import "KHSearchTableViewCell.h"
#import "KHTenViewController.h"
#import "KHSearchResultController.h"
#import "KHTenModel.h"
#import "KHDetailViewController.h"
#import "TSAnimation.h"

@interface KHSearchViewController ()<UITableViewDataSource,UITableViewDelegate,KHSearchCellDelegate,UITextFieldDelegate,TSAnimationDelegate>{
     CGFloat _leftTableWidth;
    NSInteger currentPage;
}
@property (nonatomic,strong) UITableView *leftTableView;
@property (nonatomic,strong) UITableView *rightTableView;
@property (nonatomic,assign) NSInteger leftTableCurRow;//当前选中行
@property (nonatomic,strong) NSMutableArray *categories;
@property (nonatomic,strong) NSMutableArray *dataArray;
/**c产品图片(动画)
 */
@property (nonatomic, strong) UIImageView *productView;
@end

@implementation KHSearchViewController

- (UIImageView *)productView {
    if (!_productView) {
        _productView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _productView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _productView;
}

- (NSMutableArray *)categories{
    if (!_categories) {
        _categories = [NSMutableArray array];
    }
    return _categories;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)leftTableView{
    if (!_leftTableView) {
        _leftTableWidth = 100.f;
        _leftTableView = [[UITableView alloc] init];
        _leftTableView.tableFooterView = [[UIView alloc]init]; //去掉多余的空行分割线
        _leftTableView.backgroundColor = UIColorHex(#EFEFF4);
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        _leftTableCurRow = 0;
    }
    return _leftTableView;
}

- (UITableView *)rightTableView{
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] init];
        _rightTableView.backgroundColor = [UIColor whiteColor];
        _rightTableView.tableFooterView = [[UIView alloc]init]; //去掉多余的空行分割线
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
    }
    return _rightTableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.leftTableView];
    [_leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.width.mas_equalTo(_leftTableWidth);
        make.height.equalTo(self.view);
    }];
    
    [self.view addSubview:self.rightTableView];
    [_rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftTableView.mas_right);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view).with.offset(64);
        make.height.equalTo(self.view);
    }];
    
    __weak typeof(self) weakSelf = self;
    //下拉刷新
    self.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getCategories];
        [weakSelf.rightTableView.mj_footer resetNoMoreData];
        [weakSelf.rightTableView.mj_header endRefreshing];
    }];
    //上拉刷新
    self.rightTableView.mj_footer = [GPAutoFooter footerWithRefreshingBlock:^{
        [weakSelf getMoreData];
        [weakSelf.rightTableView.mj_footer endRefreshing];
    }];
    
    [self.rightTableView.mj_header beginRefreshing];
    
    [self getData];
    [self createNavi];
    [self.rightTableView registerNib:[UINib nibWithNibName:@"KHSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"rightCell"];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:_leftTableCurRow inSection:0];
    
    [self.leftTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [super viewDidAppear:animated];
}

- (void)getData{
    NSMutableDictionary *parameter = [Utils parameter];
    [YWHttptool GET:PortCategory_list parameters:parameter success:^(id responseObject) {
        if ([responseObject[@"isError"] integerValue]) return ;
        self.dataArray = [KHSearchModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
        [self.leftTableView reloadData];
    } failure:^(NSError *error) {
    }];
}

- (void)getCategories{
    currentPage = 1;
    NSMutableDictionary *parameter = [Utils parameter];
    if ([Utils isNull:self.dataArray]) {
        parameter[@"cateid"] = @"1";
    }else{
    KHSearchModel *model = self.dataArray[_leftTableCurRow];
    parameter[@"cateid"] = model.ID;
    }
    parameter[@"p"] = @"1";
    [YWHttptool GET:PortGoods_cate parameters:parameter success:^(id responseObject) {
        currentPage++;
        self.categories = [KHTenModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
        [self.rightTableView reloadData];
    } failure:^(NSError *error) {
    }];
}

- (void)getMoreData{
    NSMutableDictionary *parameter = [Utils parameter];
    KHSearchModel *model = self.dataArray[_leftTableCurRow];
    parameter[@"cateid"] = model.ID;
    parameter[@"p"] = @(currentPage);
    [YWHttptool GET:PortGoods_cate parameters:parameter success:^(id responseObject) {
        if ([responseObject[@"isError"] integerValue]){
            [self.rightTableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        };
        currentPage++;
        [self.categories addObjectsFromArray:[KHTenModel kh_objectWithKeyValuesArray:responseObject[@"result"]]];
        [self.rightTableView reloadData];
    } failure:^(NSError *error) {
    }];
}
- (void)createNavi{
    SearchBar *search = [SearchBar searchBar];
    search.delegate = self;
    self.navigationItem.titleView = search;
    
    [self setBackItem];
    
    [self setRightImageNamed:@"tenCart" action:@selector(gotoCart)];
    [self setItemBadge:[AppDelegate getAppDelegate].value];
}
//进去购物车
- (void)gotoCart{
    [self.tabBarController setSelectedIndex:3];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    KHSearchResultController *searchResultVC = [[KHSearchResultController alloc]init];
    [self hideBottomBarPush:searchResultVC];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return self.dataArray.count;
    }else{
        return self.categories.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftCell"];
        if (!cell) {
         
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"leftCell"];
            cell.backgroundColor = UIColorHex(#EFEFF4);
            cell.textLabel.font = SYSTEM_FONT(14);
            cell.contentView.backgroundColor = UIColorHex(#EFEFF4);
            
            cell.textLabel.highlightedTextColor = kDefaultColor;
            UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
            UIView *selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 45)];
            selectView.backgroundColor = kDefaultColor;
            selectView.tag = 10;
            [backView addSubview:selectView];
            
            cell.selectedBackgroundView = backView;
            cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        }
        KHSearchModel *model = self.dataArray[indexPath.row];
        cell.textLabel.text = model.name;
        return cell;
    }else{
        KHSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.indexPath= indexPath;
        [cell setModel:self.categories[indexPath.row]];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView){
        return 45;
    }else{
        return 110;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        _leftTableCurRow = indexPath.row;
        [self.rightTableView.mj_header beginRefreshing];
    }else{
        [MBProgressHUD showMessage:@"加载中..."];
        NSMutableDictionary *parameter = [Utils parameter];
        NSString *goodsid;
        KHTenModel *Model = self.categories[indexPath.row];
        parameter[@"goodsid"] = Model.ID;
        parameter[@"qishu"] = Model.qishu;
        goodsid = Model.ID;
        [YWHttptool GET:PortGoodsdetails parameters:parameter success:^(id responseObject) {
            [MBProgressHUD hideHUD];
            if ([responseObject[@"isError"] integerValue])return;
            KHDetailViewController *DetailVC = [[KHDetailViewController alloc]init];
            DetailVC.model = [KHProductModel kh_objectWithKeyValues:responseObject[@"result"]];
            DetailVC.goodsid = goodsid;
            DetailVC.showType = TreasureDetailHeaderTypeNotParticipate;
            [self hideBottomBarPush:DetailVC];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
        }];
    }
}

//点击加入了清单
- (void)clickAddListButtonAtCell:(KHSearchTableViewCell *)cell{
    if ([TSAnimation sharedAnimation].isShowing) {
        return;
    }
    NSIndexPath *indexPath = cell.indexPath;
    KHTenModel *model = self.categories[indexPath.row];
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    parameter[@"goodsid"] = model.ID;
    [YWHttptool GET:PortAddCart parameters:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"isError"] integerValue]) return ;
        [AppDelegate getAppDelegate].value = [responseObject[@"result"][@"count_cart"] integerValue];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshCart" object:nil userInfo:nil];
        [self setItemBadge:[AppDelegate getAppDelegate].value];
        [self setBadgeValue:[AppDelegate getAppDelegate].value atIndex:3];
    } failure:^(NSError *error) {
    }];
    CGRect parentRectA = [cell.contentView convertRect:cell.productPic.frame toView:self.view];
    CGRect parentRectB = CGRectMake(KscreenWidth-60, 20, 40, 40);
    [self.view addSubview:self.productView];
    self.productView.frame = parentRectA;
    self.productView.image = cell.productPic.image;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.productView.centerX, self.productView.centerY)];
    [path addQuadCurveToPoint:CGPointMake(parentRectB.origin.x+30, parentRectB.origin.y+40) controlPoint:CGPointMake(self.productView.centerX+50, self.productView.centerY-20)];
    [TSAnimation sharedAnimation].delegate = self;
    [[TSAnimation sharedAnimation] throwTheView:self.productView path:path isRotated:YES endScale:0.1];
}

#pragma mark - TSAnimationDelegate;//动画完成
- (void)animationFinished {
    
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
