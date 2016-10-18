//
//  TreasureDetailHeader.h
//  WinTreasure
//
//  Created by Apple on 16/6/8.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreaureHeaderMenu.h"
#import "KHProductModel.h"

@class TSProgressView;
@class TSCountLabel;


typedef NS_ENUM(NSUInteger, TreasureDetailHeaderType) {
    TreasureDetailHeaderTypeNotParticipate = 0, //未参加
    TreasureDetailHeaderTypeCountdown, //倒计时
    TreasureDetailHeaderTypeWon, //已获奖
    TreasureDetailHeaderTypeParticipated //参加
};

typedef void(^TreasureDetailHeaderClickMenuButtonBlock)(id object);
typedef void(^TreasureDetailHeaderCountDetailButtonBlock)(void);

typedef void(^TreasureCountDetailButtonBlock)(void);

/**
 *  进度或时间倒计时
 */
@interface TreasureProgressView : UIView
/**
 *  倒计时时间
 */
@property (nonatomic, assign) NSInteger countTime;
@property (nonatomic,strong) KHProductModel *model;
/**
 *  商品时间类型
 */
@property (nonatomic, assign) TreasureDetailHeaderType type;
/**期号
 */
@property (nonatomic, strong) YYLabel *periodNumberLabel;

/**倒计时label
 */
@property (nonatomic, strong) YYLabel *countLabel;

/**时间
 */
@property (nonatomic, strong) TSCountLabel *countDownLabel;

/**计算详情
 */
@property (nonatomic, strong) UIButton *countDetailButton;

/**进度
 */
@property (nonatomic, strong)  TSProgressView *progressView;

/**参与人次
 */
@property (nonatomic, strong) YYLabel *totalLabel;

/**剩余
 */
@property (nonatomic, strong) YYLabel *rightLabel;

/**揭晓时间
 */
@property (nonatomic, strong) YYLabel *publishTimeLabel;

/**用户IP
 */
@property (nonatomic, strong) YYLabel *IDLabel;

/**
 *  地区
 */
@property (nonatomic,strong) YYLabel *addressLabel;

/**获奖者
 */
@property (nonatomic, strong) YYLabel *winnerLabel;

/**幸运号码
 */
@property (nonatomic, strong) YYLabel *luckyNumberLabel;

/**获奖者头像
 */
@property (nonatomic, strong) UIImageView *winnerImgView;

/**获奖者标志图片
 */
@property (nonatomic, strong) UIImageView *markImgView;

/**背景图片
 */
@property (nonatomic, strong) UIImageView *backImgView;

@property (nonatomic, strong) TreasureCountDetailButtonBlock block;

- (instancetype)initWithFrame:(CGRect)frame
                         type:(TreasureDetailHeaderType)type
                    countTime:(NSInteger)countTime Model:(KHProductModel*)model;
- (void)start;

@end

/**是否已参与
 */
@interface ParticipateView : UIView

@property (nonatomic, strong) YYLabel *participateLabel;

@property (nonatomic, strong) YYLabel *numberLabel;

@property (nonatomic, assign) BOOL isParticipated;

- (instancetype)initWithFrame:(CGRect)frame
               isParticipated:(BOOL)isParticipated;

@end


@interface TreasureDetailHeader : UIView

/**是否参与视图
 */
@property (nonatomic, strong) ParticipateView *participateView;

/**
 *  商品时间类型
 */
@property (nonatomic, assign) TreasureDetailHeaderType type;

/**
 *  点击
 */
@property (nonatomic, copy) TreasureDetailHeaderClickMenuButtonBlock clickMenuBlock;

/**计算详情
 */
@property (nonatomic, copy) TreasureDetailHeaderCountDetailButtonBlock countDetailBlock;

@property (nonatomic, strong) TreasureProgressView *treasureProgressView;

@property (nonatomic, strong) TreaureHeaderMenu *headerMenu;

//声明blcok
@property (nonatomic,copy) TreasureCountDetailButtonBlock declareBlcok;

@property (nonatomic,copy) TreasureCountDetailButtonBlock headerHeight;

@property (nonatomic, strong) YYLabel *productNameLabel;
//声明
@property (nonatomic,strong) UILabel *declareLabel;

@property (nonatomic,strong) UIButton *declareBtn;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic,strong) KHProductModel *model;


- (instancetype)initWithFrame:(CGRect)frame
                         type:(TreasureDetailHeaderType)type
                    countTime:(NSInteger)countTime Model:(KHProductModel*)model;
+ (CGFloat)getHeight;

@end
