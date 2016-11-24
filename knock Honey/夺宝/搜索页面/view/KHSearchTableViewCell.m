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
    
    _partInBtn.layer.cornerRadius = 5;
    _partInBtn.layer.borderWidth = 1;
    _partInBtn.layer.borderColor = kDefaultColor.CGColor;
    _partInBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)clickBtton:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(clickAddListButtonAtCell:)]) {
        [_delegate clickAddListButtonAtCell:self];
    }
}
- (void)setModel:(KHTenModel*)model{
    _model = model;
    
    [_productPic sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    _productName.text = model.title;
    
    _progressView.progress = _model.jindu.integerValue;
    

    
    _zongrenshu.attributedText = [Utils stringWith:[NSString stringWithFormat:@"总需%@",model.zongrenshu] font1:SYSTEM_FONT(12) color1:[UIColor blackColor] font2:SYSTEM_FONT(12) color2:UIColorHex(#7CC4EC) range:NSMakeRange(2, model.zongrenshu.length)];
    
    NSInteger right = [_model.zongrenshu intValue]- [_model.canyurenshu intValue];
    NSString *str = [NSString stringWithFormat:@"%zi",right];
    _shengyurenshu.attributedText = [Utils stringWith:[NSString stringWithFormat:@"剩余%@",str] font1:SYSTEM_FONT(12) color1:[UIColor blackColor] font2:SYSTEM_FONT(12) color2:kDefaultColor range:NSMakeRange(2, str.length)];
}


@end
