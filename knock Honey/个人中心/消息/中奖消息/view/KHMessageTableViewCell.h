//
//  KHMessageTableViewCell.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/11.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHMessageModel.h"

@interface KHMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentStr;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,strong) KHMessageModel *model;

- (void)setModel:(KHMessageModel *)model;

@end
