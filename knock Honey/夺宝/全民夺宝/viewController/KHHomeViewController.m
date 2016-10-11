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



@interface KHHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,WinTreasureCellDelegate,TSAnimationDelegate>
{
    NSMutableArray *_dataArray;
}
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) WinTreasureHeader *header;
/**c产品图片(动画)
 */
@property (nonatomic, strong) UIImageView *productView;
@end
static NSString *CellIdentifier = @"winTreasureCellIdentifier";
static NSString *HeaderIdentifier = @"winTreasureMenuHeaderIdentifier";
static NSString *footerIdentifier = @"winTreasureMenufooterIdentifier";

@implementation KHHomeViewController

#pragma mark - lazy load
- (NSMutableArray *)datasource {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (WinTreasureHeader *)header {
    if (!_header) {
        _header = [[WinTreasureHeader alloc]initWithFrame:({
            CGRect rect = {0,-[WinTreasureHeader height],kScreenWidth,[WinTreasureHeader height]};
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
    _dataArray = [NSMutableArray array];
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

    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
     _collectionView.contentInset = UIEdgeInsetsMake([WinTreasureHeader height], 0, 0, 0);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];

    [_collectionView registerNib:NIB_NAMED(@"WinTreasureCell") forCellWithReuseIdentifier:CellIdentifier];
    [_collectionView registerClass:[WinTreasureMenuHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
    [_collectionView registerClass:[HomeFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier];
    
    
    __weak typeof(self) weakSelf = self;
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
     _collectionView.mj_header.ignoredScrollViewContentInsetTop = [WinTreasureHeader height];
    [_collectionView.mj_header beginRefreshing];
}

- (void)getData{
    for (int i=0; i<8; i++) {
        KHHomeModel *model = [[KHHomeModel alloc]init];
        [_dataArray addObject:model];
    }
    [_collectionView reloadData];
    if (_dataArray.count>0) {
        [_collectionView addSubview:self.header];
        [self setupHeaderEvents];
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
    
    _header.imageBlock = ^(id object) {

    };
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 1) {
        return _dataArray.count;
    }
    return 0;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     WinTreasureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [WinTreasureCell size];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 1) {
            WinTreasureMenuHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
            [header selectAMenu:^(id object) {
                UIButton *sender = (UIButton *)object;
                NSLog(@"点击%@",[sender titleForState:UIControlStateNormal]);
                
            }];
            return header;
        }else{
            return nil;
        }
    }else if (kind == UICollectionElementKindSectionFooter){
        HomeFooter *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier forIndexPath:indexPath];
        return view;
    }
    return nil;
    
   
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, _dataArray.count > 0 ? [WinTreasureMenuHeader menuHeight]:0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
}

//UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.25;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.25;
}

#pragma mark - WinTreasureCellDelegate
#pragma mark - 加入清单
- (void)addShoppingList:(WinTreasureCell *)cell indexPath:(NSIndexPath *)indexPath {
    if ([TSAnimation sharedAnimation].isShowing) {
        return;
    }
    CGRect listRect = self.tabBarController.tabBar.frame;
    listRect.origin.x = 3*kScreenWidth/5+kScreenWidth/5/2;
    listRect.size.width = kScreenWidth/5.0;
    KHHomeModel *model = _dataArray[indexPath.row];
    model.isAdded = YES;
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
