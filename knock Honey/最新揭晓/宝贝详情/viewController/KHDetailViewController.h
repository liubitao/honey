//
//  KHDetailViewController.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/12.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHBaseViewController.h"
#import "TreasureDetailHeader.h"
@class KHHomeModel;

typedef NS_ENUM(NSUInteger, TreasureDetailType) {
    TreasureDetailTypePublished = 0,
    TreasureDetailTypeToBePublished
};

@interface KHDetailViewController : KHBaseViewController

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) KHHomeModel *model;

@property (nonatomic, assign) TreasureDetailHeaderType showType;
@end
