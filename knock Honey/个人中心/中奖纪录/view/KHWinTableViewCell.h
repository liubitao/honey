//
//  KHWinTableViewCell.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/7.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHWinCodeModel.h"

typedef NS_ENUM(NSInteger, KHWinCodeStateType) {
    KHWinCodeStateConfirm = 0,    //待确认
    KHWinCodeStateDelivery = 1,   //已发货
    KHWinCodeStateShine = 2,      //已晒单
};

@protocol KHWinTableViewDelegate <NSObject>
- (void)tableViewClick:(KHWinCodeModel*)model type:(KHWinCodeStateType)type;
@end

@interface KHWinTableViewCell : UITableViewCell
/**
 *  奖品图
 */
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
/**
 *  奖品名
 */
@property (weak, nonatomic) IBOutlet UILabel *productName;
/**
 *  奖品期数
 */
@property (weak, nonatomic) IBOutlet UILabel *productQishu;
/**
 *  奖品中奖code
 */
@property (weak, nonatomic) IBOutlet UILabel *productNumber;
/**
 *  奖品揭晓时间
 */
@property (weak, nonatomic) IBOutlet UILabel *productTime;
/**
 *  确认按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;



@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UILabel *midLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@property (nonatomic,assign) KHWinCodeStateType stateType;
@property (nonatomic,strong) KHWinCodeModel *model;
@property (nonatomic,assign) id  <KHWinTableViewDelegate>delegate;

- (void)setModel:(KHWinCodeModel *)model;
@end
