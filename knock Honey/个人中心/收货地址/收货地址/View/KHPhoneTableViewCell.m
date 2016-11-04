//
//  KHPhoneTableViewCell.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/3.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHPhoneTableViewCell.h"

@implementation KHPhoneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setModel:(KHAddressModel *)model{
    _model = model;
    _phone.text = [NSString stringWithFormat:@"手机号码:%@",model.czmobile];
    _QQnumber.text = [NSString stringWithFormat:@"QQ号码:%@",model.czqq];
}
- (IBAction)editPhone:(id)sender {
    if ([self.delegate respondsToSelector:@selector(editPhone:indexpath:)]) {
        [self.delegate editPhone:_model indexpath:_indexpath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)height{
    return 115;
}
@end
