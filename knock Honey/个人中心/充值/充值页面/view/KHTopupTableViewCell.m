//
//  KHTopupTableViewCell.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/1.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHTopupTableViewCell.h"

@implementation KHTopupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"TopUpCell";
    KHTopupTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (KHTopupTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"KHTopupTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
