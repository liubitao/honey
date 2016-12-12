//
//  KHjifenTableViewCell.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/12.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHjifenTableViewCell.h"

@implementation KHjifenTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(KHjifenModel *)model{
    _model = model;
    if (model.type.integerValue == 1) {
        _leixing.text = @"签到";
    }else if (model.type.integerValue == 2){
        _leixing.text = @"兑换红包";
    }else{
        _leixing.text = @"活动";
    }
    _timeLabel.text = [Utils timeWith:model.addtime];
    
    _jifenNumber.text = model.score;
    
}
@end
