//
//  TreasureDetailCell.h
//  WinTreasure
//
//  Created by Apple on 16/6/13.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHDetailModel.h"


@interface TreasureDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UILabel *IPLabel;

@property (weak, nonatomic) IBOutlet UILabel *partInLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameWidth;

@property (copy, nonatomic) NSIndexPath *indexPath;


@property (strong, nonatomic) KHDetailModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end

@interface TimeLineCell : UITableViewCell

@property (copy, nonatomic) NSString *timeLine;

@property (nonatomic, strong) YYLabel *timeLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
