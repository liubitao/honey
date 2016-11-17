//
//  KHFreeTableViewCell.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/11.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHFreeTableViewCell.h"

@implementation KHFreeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _submitButton.layer.cornerRadius = 5;
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.borderColor = kDefaultColor.CGColor;
    _submitButton.layer.borderWidth = 2;
}

- (void)setModel:(KHCoupon *)model{
    _model = model;
    
    _hongbaoMoney.attributedText = [Utils stringWith:[NSString stringWithFormat:@"¥%@",model.money] font1:SYSTEM_FONT(19) color1:[UIColor whiteColor] font2:SYSTEM_FONT(25) color2:[UIColor whiteColor] range:NSMakeRange(1, model.money.length)];
    
    _hongbaoTitle.text = model.name;
    
    _jifenNumber.text = [NSString stringWithFormat:@"消耗%@积分",model.typelimit];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)submit:(id)sender {
    if ([self.delegate respondsToSelector:@selector(submit:)]) {
        [self.delegate submit:_model];
    }
    
}

@end
