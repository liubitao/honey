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
#import "KHKnowModel.h"
#import "KHheard2View.h"
#import "KHTenViewController.h"
#import "KHDetailViewController.h"



@interface KHHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,WinTreasureCellDelegate,TSAnimationDelegate>
{
    NSMutableArray *_dataArray;
    NSMutableArray *_downArray;
    NSInteger _currentIndex;
    NSInteger _currentPage;
}
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) WinTreasureHeader *header;
/**c产品图片(动画)
 */
@property (nonatomic, strong) UIImageView *productView;

@property (nonatomic,strong) NSTimer *timer;


@end
static NSString *Cell0Identifier = @"winTreasureCell0Identifier";
static NSString *Cell1Identifier = @"winTreasureCell1Identifier";
static NSString *Cell2Identifier = @"winTreasureCell2Identifier";

static NSString *Header1Identifier = @"winTreasureMenuHeader1Identifier";
static NSString *HeaderIdentifier = @"winTreasureMenuHeaderIdentifier";

static NSString *footerIdentifier = @"winTreasureMenufooterIdentifier";

@implementation KHHomeViewController

#pragma mark - lazy load


- (WinTreasureHeader *)header {
    if (!_header) {
        _header = [[WinTreasureHeader alloc]initWithFrame:({
            CGRect rect = {0,-[WinTreasureHeader height],KscreenWidth,[WinTreasureHeader height]};
            rect;
        })];
    }
    return _header;
}

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
    
    self.title = @"全民夺宝";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createNavi];
    [self configCollectionView];

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
    KHMessageViewController *messageVC = [[KHMessageViewController alloc]init];
    [self pushController:messageVC];
}

- (void)configCollectionView{
   
    KHHOmeViewLayout *layout = [[KHHOmeViewLayout alloc]init];

    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight) collectionViewLayout:layout];
     _collectionView.contentInset = UIEdgeInsetsMake([WinTreasureHeader height], 0, 0, 0);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:Cell0Identifier];
    [_collectionView registerNib:NIB_NAMED(@"KHDowmViewCell") forCellWithReuseIdentifier:Cell1Identifier];
    [_collectionView registerNib:NIB_NAMED(@"WinTreasureCell") forCellWithReuseIdentifier:Cell2Identifier];
    [_collectionView registerNib:NIB_NAMED(@"KHheard2View") forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:Header1Identifier];
    [_collectionView registerClass:[WinTreasureMenuHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
    [_collectionView registerClass:[HomeFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier];
    
    
    __weak typeof(self) weakSelf = self;
    //下拉刷新
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
    //上拉刷新
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getMoreDate];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
    
     _collectionView.mj_header.ignoredScrollViewContentInsetTop = [WinTreasureHeader height];
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
            NSLog(@"%@",responseObject);
            _dataArray[i] = [KHHomeModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
            if (i == 0) {
                 [_collectionView reloadData];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"网络连接有误"];
        }];
    }
    
    [YWHttptool GET:PortGoodsIndex parameters:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        for (KHKnowModel *model in _downArray) {
            [model stop];
        }
        [_downArray removeAllObjects];
        _downArray = [KHKnowModel kh_objectWithKeyValuesArray:responseObject[@"result"][@"zxjx"]];
        [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络连接有误"];
    }];
    
    
    for (int i = 0; i<3; i++) {
        KHKnowModel *model = [[KHKnowModel alloc]init];
        [model start];
        [_downArray addObject:model];
    }
    
    //轮播图
    [_collectionView addSubview:self.header];
    self.header.images = [NSMutableArray arrayWithArray:@[@"https://tse4-mm.cn.bing.net/th?id=OIP.M9271c634f71d813901afbc9e69602dcfo2&pid=15.1",@"https://tse4-mm.cn.bing.net/th?id=OIP.M9271c634f71d813901afbc9e69602dcfo2&pid=15.1",@"https://tse4-mm.cn.bing.net/th?id=OIP.M9271c634f71d813901afbc9e69602dcfo2&pid=15.1"]];
    [self.header resetImage];
    [self setupHeaderEvents];
}

//上拉更多
- (void)getMoreDate{
    NSArray *array = @[@"canyurenshu",@"jindu",@"addtime",@"zongrenshu"];
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"p"] = [NSNumber numberWithInteger:++_currentPage];
    for (int i = 0 ; i<=3; i++) {
        parameter[@"sort"] = array[i];
        [YWHttptool GET:PortGoodslist parameters:parameter success:^(id responseObject) {
            NSLog(@"%@",responseObject);
            if ([responseObject[@"isError"] integerValue])return ;
            NSMutableArray *data = [KHHomeModel kh_objectWithKeyValuesArray:responseObject[@"result"]];
            [_dataArray[i] addObjectsFromArray:data];
            if (i == 0) {
                [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"网络连接有误"];
        }];
    }
}

- (void)setupHeaderEvents {
    __weak __typeof(self) weakSelf= self;
    [_header selectItem:^(UIButton *sender) {
        NSLog(@"点击%@",[sender titleForState:UIControlStateNormal]);
        [self setBackItem];
        switch (sender.tag) {
            case 0: {
                    
            }
                break;
            case 1: {
                KHTenViewController *tenVC = [[KHTenViewController alloc]init];
                [weakSelf pushController:tenVC];
            }
                break;
            case 2: {

            }
                break;
            case 3: {

            }
                break;
            default:
                break;
        }
    }];
    
    _header.imageBlock = ^(UIImageView *sender) {
        NSLog(@"图片点击%ld",sender.tag);
    };
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 1) {
        return 3;
    }
    else if (section == 2) {
       
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
        if (indexPath.section == 1) {
            KHheard2View *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:Header1Identifier forIndexPath:indexPath];
            [header setCellBlcok:^{
                [self.tabBarController setSelectedIndex:1];
            }];
            return header;
        }
            WinTreasureMenuHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
        __weak typeof(self) weakSelf = self;
            [header selectAMenu:^(id object) {
                UIButton *sender = (UIButton *)object;
                NSLog(@"点击%@",[sender titleForState:UIControlStateNormal]);
                _currentIndex = sender.tag- 1;
                [weakSelf.collectionView reloadData];
            }];
            return header;
        
        
    }else{
        HomeFooter *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier forIndexPath:indexPath];
        return view;
    }
   
}

//点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    KHDetailViewController *DetailVC = [[KHDetailViewController alloc]init];
    [self pushController:DetailVC];
    if (indexPath.section == 1) {
        DetailVC.showType = TreasureDetailHeaderTypeCountdown;
        DetailVC.model = _downArray[indexPath.row];
        DetailVC.count = 10000;
        return;
    }
    DetailVC.showType = TreasureDetailHeaderTypeNotParticipate;
    DetailVC.model = _dataArray[indexPath.row];
   
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
        return CGSizeMake(KscreenWidth, 0);
    }
    return CGSizeMake(KscreenWidth, _dataArray.count > 0 ? [WinTreasureMenuHeader menuHeight]:0);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(KscreenWidth, 10);
}

#pragma mark - WinTreasureCellDelegate
#pragma mark - 加入清单
- (void)addShoppingList:(WinTreasureCell *)cell indexPath:(NSIndexPath *)indexPath {
    if ([TSAnimation sharedAnimation].isShowing) {
        return;
    }
    CGRect listRect = self.tabBarController.tabBar.frame;
    listRect.origin.x = 3*KscreenWidth/5+KscreenWidth/5/2;
    listRect.size.width = KscreenWidth/5.0;
    KHHomeModel *model = _dataArray[indexPath.row];
//    model.isAdded = YES;
    [_dataArray replaceObjectAtIndex:indexPath.row withObject:model];
    
    CGRect parentRectA = [cell.contentView convertRect:cell.productImgView.frame toView:self.tabBarController.view];
    CGRect parentRectB = [self.view convertRect:listRect toView:self.tabBarController.view];
    [self.tabBarController.view addSubview:self.productView];
    self.productView.frame = parentRectA;
    self.productView.image = cell.productImgView.image;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.productView.centerX, self.productView.centerY)];
    [path addQuadCurveToPoint:CGPointMake(parentRectB.origin.x, parentRectB.origin.y-kNavigationBarHeight) controlPoint:CGPointMake(self.productView.centerX+30, self.productView.centerY+20)];
    [TSAnimation sharedAnimation].delegate = self;
    [[TSAnimation sharedAnimation] throwTheView:self.productView path:path isRotated:YES endScale:0.1];
}

#pragma mark - TSAnimationDelegate;//动画完成
- (void)animationFinished {
    NSLog(@"动画完成");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
