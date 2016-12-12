//
//  KHjifenTableViewCell.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/12.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHjifenModel.h"

@interface KHjifenTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jifenNumber;
@property (weak, nonatomic) IBOutlet UILabel *leixing;

@property (nonatomic,strong) KHjifenModel *model;

- (void)setModel:(KHjifenModel *)model;
@end
