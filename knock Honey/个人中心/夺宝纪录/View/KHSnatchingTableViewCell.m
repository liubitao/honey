//
//  KHSnatchingTableViewCell.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/14.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHSnatchingTableViewCell.h"

@implementation KHSnatchingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(KHSnatchModel *)model{
    _model = model;
    
    [_productImage sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    
    _producytName.text = model.title;
    _productQishu.text = [NSString stringWithFormat:@"商品期数：%@",model.qishu];
    
    _zhongrenshu.text = [NSString stringWithFormat:@"总需 %@",model.zongrenshu];
    
    NSString *str1 = [NSString stringWithFormat:@"本次参与：%@人数",model.buynum];
    _buynum.attributedText = [Utils stringWith:str1 font1:SYSTEM_FONT(13) color1:UIColorHex(9A9A9A) font2:SYSTEM_FONT(13) color2:kDefaultColor range:NSMakeRange(5, str1.length-7)];
    
//    _winerName.text = [NSString stringWithFormat:@"%@",model.lottery.];

    NSString *str2 = [NSString stringWithFormat:@"本次参与：%@人数",model.lottery.buynum];
    _winerBuynum.attributedText = [Utils stringWith:str2 font1:SYSTEM_FONT(13) color1:UIColorHex(9A9A9A) font2:SYSTEM_FONT(13) color2:kDefaultColor range:NSMakeRange(5, str2.length-7)];
    
    NSString *str3 = [NSString stringWithFormat:@"幸运号码：%@",model.lottery.wincode];
    _winerCode.attributedText = [Utils stringWith:str3 font1:SYSTEM_FONT(13) color1:UIColorHex(9A9A9A) font2:SYSTEM_FONT(13) color2:kDefaultColor range:NSMakeRange(5, str3.length-5)];
    _winerName.text = [NSString stringWithFormat:@"获奖者：%@",model.lottery.username];
    
    _winerTime.text = [NSString stringWithFormat:@"揭晓时间：%@",[Utils timeWith:model.lottery.addtime]];        
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)lookUpCode:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tableViewLookup:)]) {
        [self.delegate tableViewLookup:_model];
    }
}

@end
