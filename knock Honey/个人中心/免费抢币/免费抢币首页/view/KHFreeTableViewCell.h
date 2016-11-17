//
//  KHFreeTableViewCell.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/11.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHCoupon.h"

@protocol KHFreeCellDelegate <NSObject>

- (void)submit:(KHCoupon *)model;

@end
@interface KHFreeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hongbaoMoney;
@property (weak, nonatomic) IBOutlet UILabel *hongbaoTitle;
@property (weak, nonatomic) IBOutlet UILabel *jifenNumber;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic,assign) id <KHFreeCellDelegate>delegate;
@property (nonatomic,strong) KHCoupon *model;

- (void)setModel:(KHCoupon *)model;
@end
