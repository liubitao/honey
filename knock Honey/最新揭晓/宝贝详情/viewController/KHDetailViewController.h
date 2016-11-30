//
//  KHDetailViewController.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/12.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHBaseViewController.h"
#import "TreasureDetailHeader.h"
#import "KHProductModel.h"

typedef NS_ENUM(NSUInteger, TreasureDetailType) {
    TreasureDetailTypePublished = 0,
    TreasureDetailTypeToBePublished
};

@interface KHDetailViewController : KHBaseViewController

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) KHProductModel *model;

@property (nonatomic, assign) TreasureDetailHeaderType showType;

@property (nonatomic,copy) NSString *goodsid;

@property (nonatomic,copy) NSString *qishu;
@end
