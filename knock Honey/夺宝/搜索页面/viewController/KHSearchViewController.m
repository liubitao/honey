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

@interface KHSearchViewController ()<UITableViewDataSource,UITableViewDelegate,KHSearchCellDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation KHSearchViewController
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, KscreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView setCustomSeparatorInset:UIEdgeInsetsZero];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];

    
    [self getData];
    [self createNavi];
    [self.tableView registerNib:[UINib nibWithNibName:@"KHSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"searchCell"];
}

- (void)getData{
    [MBProgressHUD showMessage:@"加载中..."];
    NSMutableDictionary *parameter = [Utils parameter];
    [YWHttptool GET:PortCategory_list parameters:parameter success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if ([responseObject[@"isError"] integerValue]) return ;
        self.dataArray = [KHSearchModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];

}

- (void)createNavi{
    SearchBar *search = [SearchBar searchBar];
    search.delegate = self;
    self.navigationItem.titleView = search;
    
    [self setBackItem];
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
    return (self.dataArray.count)/2 + (self.dataArray.count)%2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KHSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell setModel1:self.dataArray[indexPath.row*2]];
    if ((indexPath.row*2+1)<self.dataArray.count) {
        [cell setModel2:self.dataArray[indexPath.row*2+1]];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0, KscreenWidth, 35)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, KscreenWidth,34 )];
    label.text = @"热门品类";
    label.font = SYSTEM_FONT(14);
    [view addSubview:label];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 34, KscreenWidth, 1)];
    line.backgroundColor = UIColorHex(#F0F0F0);
    [view addSubview:line];
    
    return view;
    
}
- (void)click:(KHSearchModel *)model{
    KHTenViewController *tenVC = [[KHTenViewController alloc]init];
    tenVC.area = model.ID;
    tenVC.port = PortGoods_area;
    tenVC.title = model.name;
    [self hideBottomBarPush:tenVC];
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
