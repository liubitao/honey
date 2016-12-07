//
//  KHTopupHeader.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/1.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KHTopupHeader : UIView
@property (nonatomic, copy) NSString *coinAmount;

- (instancetype)initWithFrame:(CGRect)frame coin:(NSString *)coinAmount;
@end
