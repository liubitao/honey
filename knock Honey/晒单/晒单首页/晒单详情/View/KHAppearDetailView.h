//
//  KHAppearDetailView.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/10/26.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHAppearDetailModel.h"
#import "BtButton.h"



@interface ProductInfoView : UIView

/**产品名称
 */
@property (nonatomic, strong) UILabel *productNameLabel;

/**产品期号
 */
@property (nonatomic, strong) UILabel *periodLabel;
/**本期参与
 */
@property (nonatomic, strong) UILabel *participateLabel;

/**幸运号码
 */
@property (nonatomic, strong) UILabel *luckyNumberLabel;

/**揭晓时间
 */
@property (nonatomic, strong) UILabel *publishTimeLabel;

@property (nonatomic,strong) KHAppearDetailModel *model;

- (instancetype)initWithFrame:(CGRect)frame model:(KHAppearDetailModel*)model;
@end





@interface KHAppearDetailView : UIView

typedef void(^DetailClickBlcok)(BtButton *, KHAppearDetailModel *);
@property (nonatomic,copy) DetailClickBlcok ClickBlcok;

@property (nonatomic,strong) UIView *containerView;
/**
 *  头像
 */
@property (nonatomic,strong) UIImageView *headerImage;

/**用户名
 */
@property (nonatomic,strong) UILabel *usernameLabel;

/**晒单时间
 */
@property (nonatomic,strong) UILabel *timeLabel;
/**
 *  点赞
 */
@property (nonatomic,strong) BtButton *zanButton;

/**分享标题
 */
@property (nonatomic, strong) UILabel *headLabel;

/**分享内容
 */
@property (nonatomic,strong) UILabel *contentLabel;



@property (nonatomic, strong) NSArray<UIView *> *picViews;

@property (nonatomic, strong) ProductInfoView *infoView;

@property (nonatomic,strong) KHAppearDetailModel *model;

- (instancetype)initWithFrame:(CGRect)frame model:(KHAppearDetailModel*)model;


@end
