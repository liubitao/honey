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
- (void)serModel:(KHAddressModel *)model{
    _model = model;
    
}
- (IBAction)edit:(id)sender {
    if ([self.delegate respondsToSelector:@selector(edit:indexpath:)]) {
        [self.delegate edit:_model indexpath:_indexPath];
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
