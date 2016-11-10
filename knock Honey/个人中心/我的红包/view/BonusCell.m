//
//  BonusCell.m
//  WinTreasure
//
//  Created by Apple on 16/6/17.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import "BonusCell.h"

@implementation BonusCell

- (void)awakeFromNib {
    [super awakeFromNib];

    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"BonusCell";
    BonusCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (BonusCell *)[[[NSBundle mainBundle] loadNibNamed:@"BonusCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setModel:(BonusModel *)model {
    _model = model;
    _sumLabel.text = [NSString stringWithFormat:@"%@元",_model.money];
    _conditionLabel.text = [NSString stringWithFormat:@"满%@元使用",_model.condition];
    _effectDateLabel.text =  [NSString stringWithFormat:@"生效期:%@",[Utils timeWith:_model.addtime]];
    _indateLabel.text = [NSString stringWithFormat:@"有效期至:%@",[Utils timeWith:_model.use_end_time]];
    _bounsName.text = _model.name;
    if (_model.user_status.integerValue == 0 ) {
        _bonusTypeImgView.image = IMAGE_NAMED(@"bonus_new_status_icon_54x28_");
    }
    if (_model.user_status.integerValue == 1 ) {
        _bonusTypeImgView.image = IMAGE_NAMED(@"userEd");
    }
    if (_model.user_status.integerValue == 2 ) {
        _bonusTypeImgView.image = IMAGE_NAMED(@"timeOut");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
