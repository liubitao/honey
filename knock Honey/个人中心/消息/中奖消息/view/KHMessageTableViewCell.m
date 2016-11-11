//
//  KHMessageTableViewCell.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/11.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHMessageTableViewCell.h"

@implementation KHMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(KHMessageModel *)model{
    _model = model;
    
    _contentStr.text = model.content;
    
    _timeLabel.text = [Utils timeWith:model.addtime];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
