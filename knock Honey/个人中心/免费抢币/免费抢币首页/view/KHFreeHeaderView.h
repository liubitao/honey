//
//  KHFreeHeaderView.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/11.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHChangButton.h"
#import "KHFreeModel.h"

typedef void(^FreeHeaderBlock)(NSInteger i);
@interface KHFreeHeaderView : UIView

@property (nonatomic,strong) KHChangButton *jifenListButton;
@property (nonatomic,strong) UILabel *jifenLabel;

@property (nonatomic,strong) UIButton *qiandaoButton;

@property (nonatomic,strong) UILabel *addLabel;

@property (nonatomic,copy) FreeHeaderBlock FreeBlock;

@property (nonatomic,strong) KHFreeModel *model ;

- (instancetype)initWithFrame:(CGRect)frame model:(KHFreeModel *)model;
- (void)reSetModel:(KHFreeModel *)model;

@end
