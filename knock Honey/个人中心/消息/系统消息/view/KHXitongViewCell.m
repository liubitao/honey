//
//  KHXitongViewCell.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/30.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHXitongViewCell.h"

@implementation KHXitongViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(KHMessageModel *)model{
    _model = model;
    
    _title.text = model.title;
    _contentLabel.text = model.content;
    _timeLabel.text = [NSString transToTime:model.addtime];
}

@end
