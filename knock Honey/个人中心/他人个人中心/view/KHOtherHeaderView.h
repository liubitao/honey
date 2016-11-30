//
//  KHOtherHeaderView.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/28.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHOtherModel.h"

@interface KHOtherHeaderView : UIView
@property (nonatomic,strong) KHOtherModel *model;

- (instancetype)initWithFrame:(CGRect)frame model:(KHOtherModel *)model;

@end
