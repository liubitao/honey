//
//  KHWinTableViewCell.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/7.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHWinTableViewCell.h"

@implementation KHWinTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _confirmButton.layer.cornerRadius= 5;
    _confirmButton.layer.masksToBounds = YES;
}

- (void)setModel:(KHWinCodeModel *)model{
    _model = model;
    [_productImage sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    _productName.text = model.title;
    _productQishu.text = [NSString stringWithFormat:@"商品期数:%@",model.qishu];
    _productNumber.text = [NSString stringWithFormat:@"幸运号码:%@",model.wincode];
    _productTime.text = [NSString stringWithFormat:@"揭晓数据:%@",[Utils timeWith:model.addtime]];
    _confirmButton.hidden = NO;
    if (model.order_status.integerValue == 1) {//待确认
        _stateType = KHWinCodeStateConfirm;
        _line1.backgroundColor = UIColorHex(C2C2C2);
        _image1.image = IMAGE_NAMED(@"progressstart");
        _midLabel.textColor = UIColorHex(C2C2C2);
        _line2.backgroundColor = UIColorHex(C2C2C2);
        _image2.image = IMAGE_NAMED(@"progressend");
        _endLabel.textColor = UIColorHex(C2C2C2);
        if (model.hasaddress.integerValue == 0) {
          [_confirmButton setTitle:@"完善地址" forState:UIControlStateNormal];
        }else{
           [_confirmButton setTitle:@"等待发货" forState:UIControlStateNormal];
        }
    }else{
        _line1.backgroundColor = UIColorHex(1D93DE);
        _image1.image = IMAGE_NAMED(@"progressstartSelect");
        _midLabel.textColor = UIColorHex(1D93DE);
        if(model.order_status.integerValue == 3){//已晒单
            _stateType = KHWinCodeStateShine;
            _line2.backgroundColor = UIColorHex(1D93DE);
            _image2.image = IMAGE_NAMED(@"progressendSelect");
            _endLabel.textColor = UIColorHex(1D93DE);
            _confirmButton.hidden = YES;
        }else{
            _stateType = KHWinCodeStateDelivery;
            _line2.backgroundColor = UIColorHex(C2C2C2);
            _image2.image = IMAGE_NAMED(@"progressend");
            _endLabel.textColor = UIColorHex(C2C2C2);
            [_confirmButton setTitle:@"添加晒单" forState:UIControlStateNormal];
        }
    }
}

- (IBAction)confirmClick:(UIButton *)sender {
        if ([self.delegate respondsToSelector:@selector(tableViewClick:type:)]) {
            [self.delegate tableViewClick:_model type:_stateType];
        }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
