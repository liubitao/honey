//
//  PayResultCell.m
//  WinTreasure
//
//  Created by Apple on 16/6/22.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import "PayResultCell.h"

@implementation PayResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"PayResultCell";
    PayResultCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (PayResultCell *)[[[NSBundle mainBundle] loadNibNamed:@"PayResultCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setModel:(KHresultGoods *)model {
    _model = model;
    _nameLabel.text = [NSString stringWithFormat:@"商品名称:%@",_model.title];
    _periodLabel.text = [NSString stringWithFormat:@"商品期号:%@",_model.qishu];
    _treasureNoLabel.text = [NSString stringWithFormat:@"夺宝号码:%@",_model.codes];
    _paticipateLabel.text = [NSString stringWithFormat:@"%@人次",_model.buynum];
}

@end
