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
    
    [_productImage sd_setImageWithURL:[NSURL URLWithString:_model.thumb] placeholderImage:IMAGE_NAMED(@"placeholder")];
    _productLabel.text = [NSString stringWithFormat:@"恭喜您成为%@期%@的获奖者",_model.qishu,_model.title];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
