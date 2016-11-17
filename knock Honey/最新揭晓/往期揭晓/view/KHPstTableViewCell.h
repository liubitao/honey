//
//  KHPstTableViewCell.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/16.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHpastModel.h"

@interface KHPstTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *lotteryTime;
@property (weak, nonatomic) IBOutlet UILabel *winerName;
@property (weak, nonatomic) IBOutlet UIImageView *winerPic;
@property (weak, nonatomic) IBOutlet UILabel *winerIP;
@property (weak, nonatomic) IBOutlet UILabel *winerCode;
@property (weak, nonatomic) IBOutlet UILabel *winerBuynum;
@property (nonatomic,strong) KHpastModel *model;
- (void)setModel:(KHpastModel *)model;
@end
