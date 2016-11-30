//
//  khDistanceCell.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/26.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "khDistanceCell.h"

@implementation khDistanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setModel:(KHDistanceModel *)model{
    _model = model;
    _messageLabel.text = model.status;
    _timeLabel.text = model.time;
}

@end
