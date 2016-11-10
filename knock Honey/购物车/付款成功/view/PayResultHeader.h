//
//  PayResultHeader.h
//  WinTreasure
//
//  Created by Apple on 16/6/22.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHPayResultModel.h"
#import "KHresultGoods.h"

typedef void(^PayResultHeaderBlock)(NSInteger index);

@interface PayResultHeader : UIView

@property (copy, nonatomic) PayResultHeaderBlock clickButton;
@property (nonatomic,strong) KHPayResultModel *model;


- (instancetype)initWithFrame:(CGRect)frame model:(KHPayResultModel *)model;
@end
