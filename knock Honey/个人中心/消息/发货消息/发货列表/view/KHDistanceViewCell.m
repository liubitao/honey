//
//  KHDistanceViewCell.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/26.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHDistanceViewCell.h"

@implementation KHDistanceViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _allView.layer.cornerRadius = 5;
    _allView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setModel:(KHMessageModel *)model{
    _model = model;
    
    
    [_productImage sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:IMAGE_NAMED(@"placeholder")];
    _productTitle.text = model.title;
    
    _qishuLabel.text = [NSString stringWithFormat:@"运单编号：%@",model.qishu];
    
    
}
@end
