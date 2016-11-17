//
//  KHCodeViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/15.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHCodeViewController.h"
#import "DDCollectionViewFlowLayout.h"
#import "KHCodeCell.h"
#import "YWPopView.h"
#import "YWCover.h"

@interface KHCodeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

static NSString *CodeCell = @"CodeCell";
@implementation KHCodeViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str = [NSString stringWithFormat:@"参与%zi人次,夺宝号码",self.dataArray.count];
    _numberLabel.attributedText = [Utils stringWith:str font1:SYSTEM_FONT(15) color1:[UIColor blackColor] font2:SYSTEM_FONT(15) color2:kDefaultColor range:NSMakeRange(2,str.length - 9 )];
    
    _ColloctionView.delegate = self;
    _ColloctionView.dataSource = self;
    _ColloctionView.backgroundColor = [UIColor clearColor];
    
    [self.ColloctionView registerClass:[KHCodeCell class] forCellWithReuseIdentifier:@"codeCell"];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KHCodeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"codeCell" forIndexPath:indexPath];
    NSString *str = self.dataArray[indexPath.row];
    cell.code = str;
    if ([_winCode isEqualToString:str]) {
        cell.selectColor = kDefaultColor;
    }else{
        cell.selectColor = [UIColor blackColor];
    }
    return cell;
}

#pragma mark - UICollectionView Delegate Methods

//上下item之间的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

//两个相邻的item之间的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.1;
}

//整个collectionView 到边缘的距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(8, 1, 8, 1);
}

//每个item的宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((KscreenWidth-60)/4, 13);
}



- (IBAction)hideView:(id)sender {
    for (UIView *popMenu in YWKeyWindow.subviews) {
        if ([popMenu isKindOfClass:[YWPopView class]]||[popMenu isKindOfClass:[YWCover class]]) {
            [UIView animateWithDuration:0.5
                             animations:^{
                                 popMenu.transform = CGAffineTransformMakeScale(0.01, 0.01);
                             } completion:^(BOOL finished) {
                                 if (finished) {
                                     [popMenu removeFromSuperview];
                                 }
                             }];
        }
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
