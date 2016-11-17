//
//  KHAllTableViewCell.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/14.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHAllTableViewCell.h"

@implementation KHAllTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _buyButton.layer.cornerRadius = 5;
    _buyButton.layer.masksToBounds = YES;
}
- (IBAction)buyClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tableViewWithBuy:)]) {
        [self.delegate tableViewWithBuy:_model];
    }
}
- (IBAction)lookUpCode:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tableViewLookup:)]) {
        [self.delegate tableViewLookup:_model];
    }
}

- (void)setModel:(KHSnatchModel *)model{
    _model = model;
    
    [_productImage sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    
    _productName.text = model.title;
    _productQishu.text = [NSString stringWithFormat:@"商品期数：%@",model.qishu];
    
    _zongrenshu.text = [NSString stringWithFormat:@"总需 %@",model.zongrenshu];
    NSString *str = [NSString stringWithFormat:@"剩余 %zi",model.zongrenshu.integerValue - model.canyurenshu.integerValue];
    _sehngyurenshu.attributedText = [Utils stringWith:str font1:SYSTEM_FONT(12) color1:UIColorHex(9A9A9A) font2:SYSTEM_FONT(12) color2:UIColorHex(#1A8BD8) range:NSMakeRange(3, str.length-3)];
    
    NSString *str2 = [NSString stringWithFormat:@"本次参与：%@人数",model.buynum];
    _buynum.attributedText = [Utils stringWith:str2 font1:SYSTEM_FONT(14) color1:UIColorHex(9A9A9A) font2:SYSTEM_FONT(14) color2:kDefaultColor range:NSMakeRange(5, str2.length-7)];
    _progressView.progress = model.canyurenshu.integerValue*100/model.zongrenshu.integerValue;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
