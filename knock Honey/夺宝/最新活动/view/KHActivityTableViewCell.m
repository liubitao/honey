//
//  KHActivityTableViewCell.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/12/8.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHActivityTableViewCell.h"

@implementation KHActivityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _picImage.layer.cornerRadius = 5;
    _picImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setModel:(KHActivity *)model{
    _model = model;
    
    [_picImage sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    _titleLabel.text = model.name;
    _deLabel.text = model.instro;
    _statueLabel.text = [NSString stringWithFormat:@"  %@  ",model.subs];
    
}
@end
