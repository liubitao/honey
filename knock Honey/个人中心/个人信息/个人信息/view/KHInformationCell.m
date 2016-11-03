//
//  KHInformationCell.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/3.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHInformationCell.h"

@implementation KHInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _headImage.layer.cornerRadius = 5;
    _headImage.layer.masksToBounds = YES;
    _headImage.layer.shouldRasterize = YES;
    _headImage.layer.rasterizationScale = kScreenScale;
}
+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"informationCell";
    KHInformationCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (KHInformationCell *)[[[NSBundle mainBundle] loadNibNamed:@"KHInformationCell" owner:self options:nil] lastObject];
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation ProfileDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"ProfileDetailCell";
    ProfileDetailCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ProfileDetailCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.textLabel.font = SYSTEM_FONT(17);
        self.detailTextLabel.font = SYSTEM_FONT(17);
        self.textLabel.textColor = [UIColor darkGrayColor];
    }
    return self;
}

@end

