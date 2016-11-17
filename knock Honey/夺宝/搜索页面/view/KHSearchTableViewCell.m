//
//  KHSearchTableViewCell.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/16.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHSearchTableViewCell.h"

@implementation KHSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)clickBtton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(click:)]) {
        if (sender.tag == 1) {
            [self.delegate click:_model1];
        }else{
            [self.delegate click:_model2];
        }
    }
}

- (void)setModel1:(KHSearchModel *)model1{
    _model1 = model1;
    
    [_button1 sd_setImageWithURL:[NSURL URLWithString:model1.img] forState:UIControlStateNormal];
    [_button1 setTitle:model1.name forState:UIControlStateNormal];
}

- (void)setModel2:(KHSearchModel *)model2{
    _model2 = model2;
    
    [_button2 sd_setImageWithURL:[NSURL URLWithString:model2.img] forState:UIControlStateNormal];
    [_button2 setTitle:model2.name forState:UIControlStateNormal];
}



@end
