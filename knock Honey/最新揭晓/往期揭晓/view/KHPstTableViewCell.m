//
//  KHPstTableViewCell.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/16.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHPstTableViewCell.h"

@implementation KHPstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _containerView.layer.borderWidth = 1;
    _containerView.layer.borderColor = UIColorHex(#F2F2F2).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(KHpastModel *)model{
    _model = model;
    
    _lotteryTime.text = [NSString stringWithFormat:@"期数:%@(揭晓时间:%@)",model.qishu,[Utils timeWith:model.addtime]];
    
    [_winerPic sd_setImageWithURL:[NSURL URLWithString:model.img]];
    _winerName.attributedText = [Utils stringWith:[NSString stringWithFormat:@"获奖者:%@",model.username] font1:SYSTEM_FONT(14) color1:UIColorHex(#999999) font2:SYSTEM_FONT(14) color2:UIColorHex(#8DCCEE) range:NSMakeRange(4, model.username.length)];
    _winerIP.attributedText = [Utils stringWith:[NSString stringWithFormat:@"用户IP:%@",model.user_ip] font1:SYSTEM_FONT(14) color1:UIColorHex(#999999) font2:SYSTEM_FONT(14) color2:UIColorHex(#7FCB71) range:NSMakeRange(5, model.user_ip.length)];
    _winerCode.attributedText = [Utils stringWith:[NSString stringWithFormat:@"幸运号码:%@",model.wincode] font1:SYSTEM_FONT(14) color1:UIColorHex(#999999) font2:SYSTEM_FONT(14) color2:kDefaultColor range:NSMakeRange(5, model.wincode.length)];
    _winerBuynum.attributedText = [Utils stringWith:[NSString stringWithFormat:@"本期参与:%@人次",model.buynum] font1:SYSTEM_FONT(14) color1:UIColorHex(#999999) font2:SYSTEM_FONT(14) color2:kDefaultColor range:NSMakeRange(5, model.buynum.length)];
}

@end
