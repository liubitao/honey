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
- (IBAction)confirmClick:(id)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
