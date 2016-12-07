//
//  KHAddressTableViewCell.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/3.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHAddressTableViewCell.h"

@implementation KHAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _moren.layer.cornerRadius = 3;
    _moren.layer.masksToBounds = YES;
    
}
- (void)setModel:(KHAddressModel *)model{
    _model = model;
    if ([model.isdefault integerValue] == 0) {
        _moren.hidden = YES;
    }else{
        _moren.hidden = NO;
    }
    _addressNumber.text = [NSString stringWithFormat:@"实物收货地址%zi",(_indexPath.section+1)];
    _takeMan.text = [NSString stringWithFormat:@"收货人:%@",model.consignee];
    _phone.text = [NSString stringWithFormat:@"手机号码:%@",model.mobile];
    NSString *addressStr = [model.address stringByReplacingOccurrencesOfString:@"," withString:@""];
    _takeAddress.text = [NSString stringWithFormat:@"收货地址:%@",addressStr];
}
- (IBAction)edit:(id)sender {
    if ([self.delegate respondsToSelector:@selector(editAddress:indexpath:)]) {
            [self.delegate editAddress:_model indexpath:_indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(CGFloat)height{
    return 155;
}
@end
