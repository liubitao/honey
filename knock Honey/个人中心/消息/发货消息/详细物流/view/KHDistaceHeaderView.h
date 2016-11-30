//
//  KHDistaceHeaderView.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/26.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHMessageModel.h"

@interface KHDistaceHeaderView : UIView

@property (nonatomic,strong) KHMessageModel *model;

- (instancetype)initWithFrame:(CGRect)frame model:(KHMessageModel *)model;


- (void)resetStatus:(NSString *)type;
@end
