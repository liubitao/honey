//
//  KHHomeViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/10.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHHomeViewController.h"
#import "KHSearchViewController.h"
#import "KHMessageViewController.h"
#import "KHHOmeViewLayout.h"
#import "WinTreasureHeader.h"
#import "WinTreasureMenuHeader.h"
#import "KHHomeModel.h"
#import "WinTreasureCell.h"
#import "TSAnimation.h"
#import "HomeFooter.h"
#import "KHDowmViewCell.h"
#import "KHPublishModel.h"
#import "KHheard2View.h"
#import "KHTenViewController.h"
#import "KHDetailViewController.h"
#import "KHIMage.h"
#import "KHLoginViewController.h"
#import "KHQiandaoViewController.h"
#import "KHAdvertModel.h"
#import "KHActivityViewController.h"


@interface KHHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,WinTreasureCellDelegate,TSAnimationDelegate>
{
    KHAdvertModel *advertModel;
    NSMutableArray *_dataArray;
    NSMutableArray *_downArray;
    NSInteger _currentIndex;
    NSInteger _currentPage;
    
    CGFloat insetHeight;
}
@property (nonatomic,strong)  NSMutableArray *images;
@property (nonatomic,strong) UICollectionView *collectionView;

/**c产品图片(动画)
 */
@property (nonatomic, strong) UIImageView *productView;

@property (nonatomic,strong) NSTimer *timer;


@end
static NSString *Cell0Identifier = @"winTreasureCell0Identifier";
static NSString *Cell1Identifier = @"winTreasureCell1Identifier";
static NSString *Cell2Identifier = @"winTreasureCell2Identifier";

static NSString *Header0Identifier = @"winTreasureMenuHeader0Identifier";
static NSString *Header1Identifier = @"winTreasureMenuHeader1Identifier";
static NSString *HeaderIdentifier = @"winTreasureMenuHeaderIdentifier";

static NSString *footerIdentifier = @"winTreasureMenufooterIdentifier";

@implementation KHHomeViewController

#pragma mark - lazy load
- (UIImageView *)productView {
    if (!_productView) {
        _productView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _productView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _productView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array], nil];
    _currentIndex = 0;
    insetHeight = [WinTreasureHeader height];
    UILabel *titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    titleView.text = @"云网夺宝";
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.textColor = [UIColor whiteColor];
    titleView.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = titleView;
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEvent)
                                                 name:@"advertStop"
                                               object:nil];
    [self createNavi];
    [self configCollectionView];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)notificationCenterEvent{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.collectionView reloadSections:indexSet];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


//创建导航栏
- (void)createNavi{
    [self setLeftImageNamed:@"searchicon" action:@selector(search)];
    [self setRightImageNamed:@"message" action:@selector(message)];
    [self setBackItem];
}

//左侧搜索栏
- (void)search{
    KHSearchViewController *searchVC = [[KHSearchViewController alloc]init];
    [self pushController:searchVC];
}

//右侧消息栏
- (void)message{
    if (![YWUserTool account]) {
        KHLoginViewController *vc = [[KHLoginViewController alloc]init];
        KHNavigationViewController *nav = [[KHNavigationViewController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    KHMessageViewController *messageVC = [[KHMessageViewController alloc]init];
    [self pushController:messageVC];
}

- (void)configCollectionView{
    
    KHHOmeViewLayout *layout = [[KHHOmeViewLayout alloc]init];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:Cell0Identifier];
    [_collectionView registerNib:NIB_NAMED(@"KHDowmViewCell") forCellWithReuseIdentifier:Cell1Identifier];
    [_collectionView registerNib:NIB_NAMED(@"WinTreasureCell") forCellWithReuseIdentifier:Cell2Identifier];
    [_collectionView registerClass:[WinTreasureHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:Header0Identifier];
    [_collectionView registerNib:NIB_NAMED(@"KHheard2View") forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:Header1Identifier];
    [_collectionView registerClass:[WinTreasureMenuHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
    [_collectionView registerClass:[HomeFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier];
    
    
    __weak typeof(self) weakSelf = self;
    //下拉刷新
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
        [weakSelf.collectionView.mj_footer resetNoMoreData];
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
    //上拉刷新
    _collectionView.mj_footer = [GPAutoFooter footerWithRefreshingBlock:^{
        [weakSelf getMoreDate];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
    [_collectionView.mj_header beginRefreshing];
}

//下拉刷新
- (void)getData{
    NSArray *array = @[@"canyurenshu",@"jindu",@"addtime",@"zongrenshu"];
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"p"] = @"1";
    _currentPage = 1;
    for (int i = 0 ; i<=3; i++) {
        parameter[@"sort"] = array[i];
        [YWHttptool GET:PortGoodslist parameters:parameter success:^(id responseObject) {
            _dataArray[i] = [KHHomeModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
            if (i == 0) {
                [_collectionView reloadData];
            }
        } failure:^(NSError *error) {
        }];
    }
    
    [YWHttptool GET:PortGoodsIndex parameters:parameter success:^(id responseObject) {
        if ([responseObject[@"isError"] integerValue]) return;
        for (KHPublishModel *model in _downArray) {
            [model stop];
        }
        [_downArray removeAllObjects];
        
        [advertModel stop];
        //活动的数据
        advertModel = [KHAdvertModel kh_objectWithKeyValues:responseObject[@"result"][@"top_prom"]];
        if (advertModel && advertModel.prom_end.integerValue >[[NSDate date] timeIntervalSince1970]) {
            insetHeight = 260;
        }else{
            insetHeight = 216;
        }
        _images = [KHIMage kh_objectWithKeyValuesArray:responseObject[@"result"][@"banner"]];
       
        _downArray = [KHPublishModel kh_objectWithKeyValuesArray:responseObject[@"result"][@"zxjx"]];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)];
        [self.collectionView reloadSections:indexSet];
    } failure:^(NSError *error){
    }];
}

//上拉更多
- (void)getMoreDate{
    NSArray *array = @[@"canyurenshu",@"jindu",@"addtime",@"zongrenshu"];
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"p"] = [NSNumber numberWithInteger:++_currentPage];
    for (int i = 0 ; i<=3; i++) {
        parameter[@"sort"] = array[i];
        [YWHttptool GET:PortGoodslist parameters:parameter success:^(id responseObject) {
            if ([responseObject[@"isError"] integerValue]){
                    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            NSMutableArray *data = [KHHomeModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
            [_dataArray[i] addObjectsFromArray:data];
            if (i == 0) {
                [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
            }
        } failure:^(NSError *error){
        }];
    }
}

- (void)setupHeaderEvents {
 
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 1) {
        return 3;
    }else if (section == 2){
        NSMutableArray *array = _dataArray[_currentIndex];
        return array.count;
    }
    return 1;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Cell0Identifier forIndexPath:indexPath];
        return cell;
    }else if (indexPath.section == 1){
        KHDowmViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Cell1Identifier forIndexPath:indexPath];
        cell.model = _downArray[indexPath.row];
        return cell;
    }
    NSMutableArray *array = _dataArray[_currentIndex];
    WinTreasureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Cell2Identifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.model = array[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake( KscreenWidth, 0.1);
    }
    else if (indexPath.section == 1){
        return [KHDowmViewCell size];
    }
    return [WinTreasureCell size];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            WinTreasureHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:Header0Identifier forIndexPath:indexPath];
             __weak __typeof(self) weakSelf= self;
            header.advertBlock = ^{
                KHQiandaoViewController *VC = [[KHQiandaoViewController alloc]init];
                VC.title = @"活动";
                VC.urlStr = advertModel.link;
                [weakSelf pushController:VC];
            };
            [header setAdVertModel:advertModel with:_images];
           
            [header selectItem:^(UIButton *sender) {
                NSLog(@"点击%@",[sender titleForState:UIControlStateNormal]);
                [self setBackItem];
                switch (sender.tag) {
                    case 0: {//最新活动
                        KHActivityViewController *activityVC = [[KHActivityViewController alloc]init];
                        [weakSelf pushController:activityVC];
                    }
                        break;
                    case 1: {//十元专区
                        KHTenViewController *tenVC = [[KHTenViewController alloc]init];
                        tenVC.area = @"12";
                        tenVC.port = PortGoods_cate;
                        tenVC.title = @"十元专区";
                        [weakSelf pushController:tenVC];
                    }
                        break;
                    case 2: {//幸运转盘
                        if (![YWUserTool account]) {
                            KHLoginViewController *vc = [[KHLoginViewController alloc]init];
                            KHNavigationViewController *nav = [[KHNavigationViewController alloc] initWithRootViewController:vc];
                            [weakSelf presentViewController:nav animated:YES completion:nil];
                            return;
                        }
                        KHQiandaoViewController *activityVC = [[KHQiandaoViewController alloc]init];
                        activityVC.title = @"幸运转盘";
                        activityVC.urlStr = [NSString stringWithFormat:@"%@=%@",PortActivity,[YWUserTool account].userid];
                        [weakSelf pushController:activityVC];
                    }
                        break;
                    case 3: {//每日签到
                        KHQiandaoViewController *VC = [[KHQiandaoViewController alloc]init];
                        NSString *str = [NSString stringWithFormat:@"%@?userid=%@",PortSign_index,[YWUserTool account].userid];
                        VC.urlStr = str;
                        VC.title = @"签到";
                        [self pushController:VC];
                    }
                        break;
                    default:
                        break;
                }
            }];
            
            header.imageBlock = ^(UIImageView *sender) {
                NSLog(@"图片点击%ld",(long)sender.tag);
                KHQiandaoViewController *VC = [[KHQiandaoViewController alloc]init];
                VC.title = @"详情";
                KHIMage *model = weakSelf.images[sender.tag];
                VC.urlStr = model.link;
                [weakSelf pushController:VC];
            };
            return header;
        }else if (indexPath.section == 1) {
            KHheard2View *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:Header1Identifier forIndexPath:indexPath];
            [header setCellBlcok:^{
                [self.tabBarController setSelectedIndex:1];
            }];
            return header;
        }else{
        WinTreasureMenuHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
        __weak typeof(self) weakSelf = self;
        [header selectAMenu:^(id object) {
            UIButton *sender = (UIButton *)object;
            NSLog(@"点击%@",[sender titleForState:UIControlStateNormal]);
            _currentIndex = sender.tag- 1;
            [weakSelf.collectionView reloadData];
        }];
        return header;
        }
    }else{
        HomeFooter *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier forIndexPath:indexPath];
        return view;
    }
    
}

//点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [MBProgressHUD showMessage:@"加载中..."];
    NSMutableDictionary *parameter = [Utils parameter];
    NSString *qishu;
    NSString *goodsid;
    if (indexPath.section == 1) {
        KHPublishModel * knowModel = _downArray[indexPath.row];
        parameter[@"goodsid"] = knowModel.goodsid;
        parameter[@"qishu"] = knowModel.qishu;
        goodsid = knowModel.goodsid;
        qishu = knowModel.qishu;
    }else{
        KHHomeModel *knowModel = _dataArray[_currentIndex][indexPath.row];
        parameter[@"goodsid"] = knowModel.ID;
        parameter[@"qishu"] = knowModel.qishu;
        goodsid = knowModel.ID;
        qishu = knowModel.qishu;
    }
    if ([YWUserTool account]) {
        parameter[@"userid"] = [YWUserTool account].userid;
    }
    [YWHttptool GET:PortGoodsdetails parameters:parameter success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if ([responseObject[@"isError"] integerValue])return;
        KHDetailViewController *DetailVC = [[KHDetailViewController alloc]init];
        DetailVC.model = [KHProductModel kh_objectWithKeyValues:responseObject[@"result"]];
        DetailVC.goodsid = goodsid;
        DetailVC.qishu = qishu;
        [self pushController:DetailVC];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

//UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return CGSizeMake(KscreenWidth, insetHeight);
    }
    return CGSizeMake(KscreenWidth, _dataArray.count > 0 ? [WinTreasureMenuHeader menuHeight]:0);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(KscreenWidth, 10);
}

#pragma mark - WinTreasureCellDelegate
#pragma mark - 加入清单
- (void)addShoppingList:(WinTreasureCell *)cell indexPath:(NSIndexPath *)indexPath {
    if (![YWUserTool account]) {
        KHLoginViewController *vc = [[KHLoginViewController alloc]init];
        KHNavigationViewController *nav = [[KHNavigationViewController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    if ([TSAnimation sharedAnimation].isShowing) {
        return;
    }
    CGRect listRect = self.tabBarController.tabBar.frame;
    listRect.origin.x = 3*KscreenWidth/5+KscreenWidth/5/2;
    listRect.size.width = KscreenWidth/5.0;
    
    KHHomeModel *model = _dataArray[_currentIndex][indexPath.row];
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    parameter[@"goodsid"] = model.ID;
    [YWHttptool GET:PortAddCart parameters:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"isError"] integerValue]) return ;
        [AppDelegate getAppDelegate].value = [responseObject[@"result"][@"count_cart"] integerValue];
         [self setBadgeValue:[AppDelegate getAppDelegate].value atIndex:3];
        //刷新购物车
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshCart" object:nil userInfo:nil];
    } failure:^(NSError *error){
    }];
    
    CGRect parentRectA = [cell.contentView convertRect:cell.productImgView.frame toView:self.tabBarController.view];
    CGRect parentRectB = [self.view convertRect:listRect toView:self.tabBarController.view];
    [self.tabBarController.view addSubview:self.productView];
    self.productView.frame = parentRectA;
    self.productView.image = cell.productImgView.image;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.productView.centerX, self.productView.centerY)];
    [path addQuadCurveToPoint:CGPointMake(parentRectB.origin.x, parentRectB.origin.y) controlPoint:CGPointMake(self.productView.centerX+30, self.productView.centerY+20)];
    [TSAnimation sharedAnimation].delegate = self;
    [[TSAnimation sharedAnimation] throwTheView:self.productView path:path isRotated:YES endScale:0.1];
}

#pragma mark - TSAnimationDelegate;//动画完成
- (void)animationFinished{    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
