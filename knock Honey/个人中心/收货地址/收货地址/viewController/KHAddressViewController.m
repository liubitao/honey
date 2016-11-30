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
#import "GSPopoverViewController.h"
#import "KHEditAddressViewController.h"
#import "KHEditPhoneViewController.h"
#import "KHAddressModel.h"

@interface KHAddressViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,KHAddressDelegate,KHPhoneDelegate>{
    NSInteger addressCount;
    NSInteger phoneCount;
    NSInteger selectRow;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSoure;
@property (nonatomic, strong) UITableView *RightTableView;
@property (nonatomic,strong) GSPopoverViewController *popView;
@end
static NSString * addressCell = @"addressCell";
static NSString * phoneCell = @"phoneCell";
static NSString * rightCell = @"rightCell";
@implementation KHAddressViewController

- (NSMutableArray *)dataSoure{
    if (!_dataSoure) {
        _dataSoure = [NSMutableArray array];
    }
    return _dataSoure;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, _chooseAdd ? KscreenHeight - kNavigationBarHeight- 45: KscreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tag = 1;
        _tableView.tableHeaderView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.backgroundColor = UIColorHex(efeff4);
    }
    return _tableView;
}

- (UITableView *)RightTableView{
        if(_RightTableView == nil) {
            _RightTableView = [[UITableView alloc] init];
            _RightTableView.frame = CGRectMake(0, 0, 200, 84);
            _RightTableView.backgroundColor = UIColorHex(434343);
            _RightTableView.tag = 2;
            _RightTableView.bounces = NO;
            _RightTableView.delegate = self;
            _RightTableView.dataSource = self;
            _RightTableView.rowHeight = 42;
        }
        return _RightTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    if (_chooseAdd) {
        UIButton *clickBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, KscreenHeight-45, kScreenWidth, 45)];
        clickBtn.backgroundColor = kDefaultColor;
        [clickBtn setTitle:@"确定" forState:UIControlStateNormal];
        clickBtn.titleLabel.font = SYSTEM_FONT(19);
        [clickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [clickBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:clickBtn];
    }
    self.title = @"地址管理";
    [self setRightImageNamed:@"add" action:@selector(addAddress:forEvent:)];
    [self setBackItem];
    //下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getLatestPubData];
        //结束刷新
//        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    [self.tableView registerNib:NIB_NAMED(@"KHAddressTableViewCell") forCellReuseIdentifier:addressCell];
    [self.tableView registerNib:NIB_NAMED(@"KHPhoneTableViewCell") forCellReuseIdentifier:phoneCell];
}

- (void)confirm{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"lotteryid"] = _lotteryid;
    KHAddressModel *model = self.dataSoure[selectRow];
    if (model.type.integerValue != _goodstype) {
        [UIAlertController showAlertViewWithTitle:@"提示" Message:_goodstype == 1 ?@"请选择实物地址":@"请选择虚拟地址" BtnTitles:@[@"知道了"] ClickBtn:nil];
        return;
    }
    parameter[@"addressid"] = model.ID;
    [YWHttptool GET:PortAddress_confirm parameters:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [self.navigationController popViewControllerAnimated:YES];
        [MBProgressHUD showSuccess:@"地址确认成功，等待发货"];
    } failure:^(NSError *error){
        [MBProgressHUD showError:@"地址确认失败"];
    }];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}
- (void)addAddress:(id)sender forEvent:(UIEvent *)event{
    self.popView = [[GSPopoverViewController alloc] initWithShowView:self.RightTableView];
    self.popView.borderWidth = 0;
    self.popView.borderColor = UIColorHex(434343);
    [self.popView showPopoverWithBarButtonItemTouch:event animation:YES];
}


- (void)getLatestPubData{
    addressCount = 0;
    phoneCount = 0;
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    [YWHttptool GET:PortAddress_list parameters:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        self.dataSoure = [KHAddressModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
        NSInteger j = 0;
        for (int i = 0 ; i <self.dataSoure.count; i++){
            KHAddressModel *model = self.dataSoure[i];
            if ([model.type integerValue] == 1) {
                addressCount++;
            }else{
                j = i;
                phoneCount ++;
            }
        }
        if (j!=(self.dataSoure.count - 1) &&self.dataSoure.count !=0) {
            [self.dataSoure exchangeObjectAtIndex:j withObjectAtIndex:self.dataSoure.count-1];
        }
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error){

    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 1) {
         return self.dataSoure.count;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1){
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1) {
        KHAddressModel *model = self.dataSoure[indexPath.section];
        if (model.type.integerValue == 1) {
            KHAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCell forIndexPath:indexPath];
            cell.indexPath = indexPath;
      
            [cell setModel:model];
            cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            KHPhoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:phoneCell forIndexPath:indexPath];
            cell.indexpath = indexPath;
            [cell setModel:model];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rightCell];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightCell];
            cell.textLabel.font = SYSTEM_FONT(15);
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = UIColorHex(434343);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row == 0) {
            cell.imageView.image = IMAGE_NAMED(@"locationRight");
            cell.textLabel.text = @"添加实物收货地址";
        }else{
            cell.imageView.image = IMAGE_NAMED(@"phoneRight");
            cell.textLabel.text = @"添加充值账号";
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 1) {
           return 5;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag ==1) {
        KHAddressModel *model = self.dataSoure[indexPath.section];
        if (model.type.integerValue == 1) {
             return [KHAddressTableViewCell height];
        }
        return [KHPhoneTableViewCell height];
    }else{
        return 42;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 2) {
        [GSPopoverViewController dissPopoverViewWithAnimation:NO];
        _RightTableView = nil;//右上角的表视图
        if (indexPath.row == 0) {
            if (addressCount >= 3) {
                [UIAlertController showAlertViewWithTitle:nil Message:@"您已经添加了三个收货地址了" BtnTitles:@[@"确定"] ClickBtn:nil];
                return;
            }
            KHEditAddressViewController *editAddressVC = [[KHEditAddressViewController alloc]init];
            editAddressVC.editType = KHAddressAdd;
            [self hideBottomBarPush:editAddressVC];
        }
        if (indexPath.row == 1) {
            if (phoneCount >= 1) {
                [UIAlertController showAlertViewWithTitle:nil Message:@"您已经添加了一个充值账号了" BtnTitles:@[@"确定"] ClickBtn:nil];
                return;
            }
            KHEditPhoneViewController *editPhoneVC = [[KHEditPhoneViewController alloc]init];
            editPhoneVC.editType = KHPhoneAdd;
            [self hideBottomBarPush:editPhoneVC];
        }
    }else{
        if (_chooseAdd) {
            UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:selectRow]];
            lastCell.accessoryType = UITableViewCellAccessoryNone;
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            selectRow = indexPath.section;
        }
    }
}

//编辑地址
- (void)editAddress:(KHAddressModel *)model indexpath:(NSIndexPath *)indexpath{
    KHEditAddressViewController *editAddressVC = [[KHEditAddressViewController alloc]init];
    editAddressVC.editType = KHAddressEdit;
    editAddressVC.model = self.dataSoure[indexpath.section];
    [self hideBottomBarPush:editAddressVC];
}

//编辑号码
- (void)editPhone:(KHAddressModel *)model indexpath:(NSIndexPath *)indexpath{
    KHEditPhoneViewController *editPhoneVC = [[KHEditPhoneViewController alloc]init];
    editPhoneVC.editType = KHPhoneEdit;
    editPhoneVC.model = self.dataSoure[indexpath.section];
    [self hideBottomBarPush:editPhoneVC];
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_placeholder"];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView{
    return YES;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
