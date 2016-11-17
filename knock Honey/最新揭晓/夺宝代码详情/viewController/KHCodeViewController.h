//
//  KHCodeViewController.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/15.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHBaseViewController.h"

@interface KHCodeViewController : KHBaseViewController
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,copy) NSString *winCode;
@property (weak, nonatomic) IBOutlet UICollectionView *ColloctionView;
@end
