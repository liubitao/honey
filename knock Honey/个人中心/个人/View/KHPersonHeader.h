//
//  KHPersonHeader.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/19.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MeHeaderBlock)(void);

@interface KHPersonHeader : UIView
/**背景图
 */
@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic,copy) MeHeaderBlock settingBlock;
/**
 *  头像
 */
@property (nonatomic, copy) MeHeaderBlock headImgBlock;
/**
 *  充值
 */
@property (nonatomic, copy) MeHeaderBlock topupBlock;
/**
 *  积分
 */
@property (nonatomic, copy) MeHeaderBlock diamondBlock;

/**余额
 */
@property (nonatomic, copy) NSString *remainSum;

- (void)makeScaleForScrollView:(UIScrollView *)scrollView;

- (void)freshen;


@end

typedef void(^BalanceViewBlock) (void);

@interface BalanceView : UIView
/**余额
 */
@property (nonatomic, strong) YYLabel *balanceLabel;

/**余额数
 */
@property (nonatomic, copy) NSString *balanceAmount;

@property (nonatomic, copy) BalanceViewBlock topupBlock;

@end




