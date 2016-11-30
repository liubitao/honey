//
//  KHPersonHeader.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/19.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,KHPersonType){
    KHPersonNOLogin = 0,//未登录
    KHPersonLogin = 1//已登录
};

typedef void(^MeHeaderBlock)(void);

typedef void (^KHPersonLoginBlock)(UIButton *);

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

/**
 *  未登录的时候的按钮
 */
@property (nonatomic,copy) KHPersonLoginBlock loginBlock;

/**余额
 */
@property (nonatomic, copy) NSString *remainSum;

@property (nonatomic,assign) KHPersonType type;


- (instancetype)initWithFrame:(CGRect)frame with:(KHPersonType )type;

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




