//
//  KHDetailViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/12.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHDetailViewController.h"
#import "KHDetailModel.h"
#import "TreasureDetailCell.h"
#import "TreasureDetailFooter.h"
#import "TreasureDetailHeader.h"
#import "KHQiandaoViewController.h"
#import "KHCodeViewController.h"
#import "YWCover.h"
#import "YWPopView.h"
#import "KHGoodsAppearController.h"
#import "KHPastViewController.h"
#import "KHOtherPersonController.h"
#import "KHLoginViewController.h"
#import <MJExtension.h>
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialUIManager.h"

@interface KHDetailViewController ()<UITableViewDataSource,UITableViewDelegate,TreasureDetailFooterDelegate,YWCoverDelegate>{
    NSInteger _currentPage;
    TreasureDetailHeader *header;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) TreasureDetailFooter *footer;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) KHCodeViewController *codeVC;


@end

@implementation KHDetailViewController
- (KHCodeViewController *)codeVC{
    if (!_codeVC) {
        _codeVC = [[KHCodeViewController alloc]init];
    }
    return _codeVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, KscreenWidth, KscreenHeight - kNavigationBarHeight-60) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    if ( [Utils isNull:_model.newtime]) {
        _showType = TreasureDetailHeaderTypeNotParticipate;
    }else if([_model.newtime doubleValue] >[[NSDate date] timeIntervalSince1970]){
        _showType = TreasureDetailHeaderTypeCountdown;
    }else{
        _showType = TreasureDetailHeaderTypeWon;
    }
    
    [self createNavi];
    [self configBottomMenu];
    [self createTableView];
}

- (void)createNavi{
    self.title = @"奖品详情";
    [self setRightImageNamed:@"share" action:@selector(share)];
}

- (void)createTableView{
    header = [[TreasureDetailHeader alloc]initWithFrame:({
        CGRect rect = {0, 0, kScreenWidth, 1};
        rect;
    }) type:_showType Model:_model];
     _tableView.tableHeaderView = header;
    
    
    __weak typeof(self) weakSelf = self;
    
    header.codeBlock = ^{//点击获奖人的参与次数
        KHCodeViewController *vc = weakSelf.codeVC;
        NSArray *array = [weakSelf.model.winner.codes componentsSeparatedByString:@","];
        vc.dataArray = array.mutableCopy;
        if (weakSelf.model.winner){
            vc.winCode = weakSelf.model.winner.wincode;
        }
        [vc.ColloctionView reloadData];
        //弹出蒙版
        YWCover  *cover = [YWCover show];
        cover.delegate = weakSelf;
        [cover setDimBackground:YES];
        
        // 弹出pop菜单
        YWPopView *menu = [YWPopView showInRect:CGRectZero];
        menu.center = weakSelf.view.center;
        menu.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:0.5
                         animations:^{
                             menu.transform = CGAffineTransformIdentity;
                         }];
        menu.contentView = vc.view;
    };
    //详情中的选项
    header.clickMenuBlock = ^(id object){
        switch ([object integerValue]) {
            case 0: {//图文详情
                KHQiandaoViewController *goodsVC = [[KHQiandaoViewController alloc]init];
                goodsVC.urlStr = [NSString stringWithFormat:@"%@=%@",PortImage_detail,weakSelf.goodsid];
                goodsVC.title = @"图文详情";
                [weakSelf hideBottomBarPush:goodsVC];
            }
                break;
            case 1: {//晒单分享
                KHGoodsAppearController *goodsVC = [[KHGoodsAppearController alloc]init];
                goodsVC.goodsid = weakSelf.goodsid;
                [weakSelf hideBottomBarPush:goodsVC];
            }
                break;
            case 2: {//往期揭晓
                KHPastViewController *pastVC = [[KHPastViewController alloc]init];
                pastVC.goodsid = weakSelf.goodsid;
                [weakSelf hideBottomBarPush:pastVC];
            }
                break;
            default:
                break;
        }
    };
    __weak typeof(header) weakHeader = header;
    header.headerHeight = ^(TreasureDetailHeaderType type){//头高
        if (type == TreasureDetailHeaderTypeNotParticipate ||type ==TreasureDetailHeaderTypeParticipated) {
            weakHeader.height = 775-200+kScreenWidth/375*200-30+weakHeader.productNameLabel.height;
        }else if (type == TreasureDetailHeaderTypeCountdown){
            weakHeader.height = 590-200+kScreenWidth/375*200-30+weakHeader.productNameLabel.height;
        }else  if(type == TreasureDetailHeaderTypeWon){
            weakHeader.height = 700-200+kScreenWidth/375*200-30+weakHeader.productNameLabel.height;
        }else{
            weakHeader.height = 585-200+kScreenWidth/375*200-30+weakHeader.productNameLabel.height;
        }
        weakSelf.tableView.tableHeaderView = weakHeader;
    };
    
    header.lookBlock = ^{
        KHCodeViewController *vc = weakSelf.codeVC;
        NSArray *array = [weakSelf.model.codes componentsSeparatedByString:@","];
        vc.dataArray = array.mutableCopy;
        [vc.ColloctionView reloadData];
        //弹出蒙版
        YWCover  *cover = [YWCover show];
        cover.delegate = weakSelf;
        [cover setDimBackground:YES];
        
        // 弹出pop菜单
        YWPopView *menu = [YWPopView showInRect:CGRectZero];
        menu.center = weakSelf.view.center;
        menu.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:0.5
                         animations:^{
                             menu.transform = CGAffineTransformIdentity;
                         }];
        menu.contentView = vc.view;
    };
    
    header.countDetailBlock = ^(){//计算详情
        KHQiandaoViewController *VC = [[KHQiandaoViewController alloc]init];
        NSString *str = [NSString stringWithFormat:@"%@?goodsid=%@&qishu=%@",PortFormula,weakSelf.goodsid,weakSelf.model.winner.qishu];
        VC.urlStr = str;
        VC.title = @"计算详情";
        [weakSelf hideBottomBarPush:VC];
    };
    
    header.declareBlcok = ^(){//点击声明
        KHQiandaoViewController *VC = [[KHQiandaoViewController alloc]init];
        VC.urlStr = PortDuobao_statement;
        VC.title = @"夺宝声明";
        [weakSelf hideBottomBarPush:VC];
    };

    
    //下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
        [weakSelf.tableView.mj_footer resetNoMoreData];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    //上拉刷新
    _tableView.mj_footer = [GPAutoFooter footerWithRefreshingBlock:^{
        [weakSelf getMoreData];
        [weakSelf.tableView .mj_footer endRefreshing];
    }];
    [_tableView.mj_header beginRefreshing];
    
}

//点击蒙版的时候调用
- (void)coverDidClickCover:(YWCover *)cover{
    // 隐藏pop菜单
    [YWPopView hide];
}


//获取数据
- (void)getData{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"p"] = @"1";
    parameter[@"goodsid"] = _goodsid;
    parameter[@"qishu"] = _qishu;
    [YWHttptool GET:PortGoodsOrder parameters:parameter success:^(id responseObject) {
        _currentPage = 1;
        self.dataArray = [KHDetailModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
        [_tableView reloadData];
    } failure:^(NSError *error){
    }];
    
    NSMutableDictionary *parameter2 = [Utils parameter];
    parameter2[@"goodsid"] = _goodsid;
    parameter2[@"qishu"] = _qishu;
    if ([YWUserTool account]) {
        parameter2[@"userid"] = [YWUserTool account].userid;
    }
    [YWHttptool GET:PortGoodsdetails parameters:parameter2 success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if ([responseObject[@"isError"] integerValue])return;
        KHProductModel *model = [KHProductModel kh_objectWithKeyValues:responseObject[@"result"]];
        if ( [Utils isNull:model.newtime]) {
            _showType = TreasureDetailHeaderTypeNotParticipate;
            header.statueLabel.text = @"进行中";
            header.statueLabel.backgroundColor = kDefaultColor;
        }else if([model.newtime doubleValue] >[[NSDate date] timeIntervalSince1970]){
            _showType = TreasureDetailHeaderTypeCountdown;
            header.statueLabel.text = @"倒计时";
            header.statueLabel.backgroundColor = kDefaultColor;
        }else{
            _showType = TreasureDetailHeaderTypeWon;
            header.statueLabel.text = @"已揭晓";
            header.statueLabel.backgroundColor = UIColorHex(55bf41);
        }
        [self configBottomMenu];
        [header refreshHeader:model];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

- (void)getMoreData{
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"p"] = [NSNumber numberWithInteger:++_currentPage];
    parameter[@"goodsid"] = _goodsid;
    parameter[@"qishu"] = _qishu;
    [YWHttptool GET:PortGoodsOrder parameters:parameter success:^(id responseObject) {
        if ([responseObject[@"isError"] integerValue]){
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        };
        NSArray *array = [KHDetailModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
        [self.dataArray addObjectsFromArray:array];
        [_tableView reloadData];
    } failure:^(NSError *error){
    }];
}

//加载下面菜单视图
- (void)configBottomMenu{
    [_footer removeFromSuperview];
    _footer = [[TreasureDetailFooter alloc]initWithType:(_showType==TreasureDetailHeaderTypeNotParticipate)?TreasureUnPublishedType:TreasurePublishedType Model:_model];
    _footer.delegate = self;
    [self.view addSubview:_footer];
}

//分享
- (void)share{
    //显示分享面板
    NSString *desct = [NSString stringWithFormat:@"最新一期的%@只要一元起",_model.title];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"这是一份来自“云网夺宝”的惊喜，必须分享给你！" descr:desct thumImage:[UIImage imageNamed:@"yunWang"]];
        //设置网页地址
        shareObject.webpageUrl =PortShareUrl;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            NSString *result = nil;
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
                result = @"分享失败";
            }else{
                result = @"分享成功";
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    NSLog(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    NSLog(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    NSLog(@"response data is %@",data);
                }
            }
            [UIAlertController showAlertViewWithTitle:@"提示" Message:result BtnTitles:@[@"确定"] ClickBtn:nil];
        }];

    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TreasureDetailCell *cell = [TreasureDetailCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.model = _dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KHOtherPersonController *otherVC = [[KHOtherPersonController alloc]init];
    KHDetailModel *model = self.dataArray[indexPath.row];
    otherVC.userID = model.userid;
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = model.userid;
    [YWHttptool GET:PortOther_user parameters:parameter success:^(id responseObject) {
        if ([responseObject[@"isError"] integerValue]) return ;
        otherVC.model = [KHOtherModel mj_objectWithKeyValues:responseObject[@"result"]];
        [self hideBottomBarPush:otherVC];
    } failure:^(NSError *error) {
    }];
}

//夺宝中下面的，点击按钮
- (void)clickMenuButtonWithIndex:(NSInteger)index{
    if (![YWUserTool account]) {
        KHLoginViewController *vc = [[KHLoginViewController alloc]init];
        KHNavigationViewController *nav = [[KHNavigationViewController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    switch (index) {
        case 1:
            [self.tabBarController setSelectedIndex:3];
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        case 2:{
            NSMutableDictionary *parameter = [Utils parameter];
            parameter[@"userid"] = [YWUserTool account].userid;
            parameter[@"goodsid"] = _goodsid;
            [YWHttptool GET:PortAddCart parameters:parameter success:^(id responseObject) {
                if ([responseObject[@"isError"] integerValue]) return ;
                
                UIButton *firstbtn = [_footer viewWithTag:1];
                [firstbtn setBadgeValue:responseObject[@"result"][@"count_cart"]];

                [AppDelegate getAppDelegate].value = [responseObject[@"result"][@"count_cart"] integerValue];
                [self setBadgeValue:[AppDelegate getAppDelegate].value atIndex:3];
                
                //刷新购物车
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshCart" object:nil userInfo:nil];
            } failure:^(NSError *error) {
            }];
        }
            break;
        case 3:{
            NSMutableDictionary *parameter = [Utils parameter];
            parameter[@"userid"] = [YWUserTool account].userid;
            parameter[@"goodsid"] = _goodsid;
            [YWHttptool GET:PortAddCart parameters:parameter success:^(id responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject[@"isError"] integerValue]) return ;
                
                [AppDelegate getAppDelegate].value = [responseObject[@"result"][@"count_cart"] integerValue];
                [self setBadgeValue:[AppDelegate getAppDelegate].value atIndex:3];
                [self.tabBarController setSelectedIndex:3];
                [self.navigationController popToRootViewControllerAnimated:YES];
                //刷新购物车
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshCart" object:nil userInfo:nil];
            } failure:^(NSError *error) {
            }];
        }
            break;
        default:
            break;
    }
}

//倒计时，进入新的一期
- (void)checkNewTreasre{
    [MBProgressHUD showMessage:@"加载中..."];
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"goodsid"] = _goodsid;
    parameter[@"qishu"] = _model.qishu;
    if ([YWUserTool account]) {
        parameter[@"userid"] = [YWUserTool account].userid;
    }
    [YWHttptool GET:PortGoodsdetails parameters:parameter success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if ([responseObject[@"isError"] integerValue])return;
        KHDetailViewController *DetailVC = [[KHDetailViewController alloc]init];
        DetailVC.model = [KHProductModel kh_objectWithKeyValues:responseObject[@"result"]];
        DetailVC.goodsid = _goodsid;
        DetailVC.qishu = _model.qishu;
        DetailVC.showType = TreasureDetailHeaderTypeNotParticipate;
        [self hideBottomBarPush:DetailVC];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络连接有误"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
