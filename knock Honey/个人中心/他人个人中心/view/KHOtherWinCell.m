//
//  KHOtherWinCell.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/12/7.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHOtherWinCell.h"

@implementation KHOtherWinCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(KHWinCodeModel *)model{
    _model = model;
    [_productPic sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    _productTitle.text = model.title;
    _productQishu.text = [NSString stringWithFormat:@"商品期数:%@",model.qishu];
    _productWincode.text = [NSString stringWithFormat:@"幸运号码:%@",model.wincode];
    _productTime.text = [NSString stringWithFormat:@"揭晓数据:%@",[Utils timeWith:model.addtime]];
}
@end
