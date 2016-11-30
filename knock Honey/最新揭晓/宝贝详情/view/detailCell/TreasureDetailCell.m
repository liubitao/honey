//
//  TreasureDetailCell.m
//  WinTreasure
//
//  Created by Apple on 16/6/13.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import "TreasureDetailCell.h"

@interface TreasureDetailCell ()

@end

const CGFloat kHeadImageDiameter = 50.0; //图片直径
const CGFloat kTreasureDetailCellHeight = 75.0; //cell高度
const CGFloat kTimeLineCellHeight = 35.0; //cell高度

@implementation TreasureDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];

    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    _headImageView.layer.cornerRadius = 5;
    _headImageView.layer.masksToBounds = YES;
    
}



+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"TreasureDetailCell";
    TreasureDetailCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (TreasureDetailCell *)[[[NSBundle mainBundle] loadNibNamed:@"TreasureDetailCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setModel:(KHDetailModel *)model {
    _model = model;
    CGRect detailSize = [model.username boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}context:nil];
    _userNameWidth.constant = detailSize.size.width;
    [_headImageView setImageWithURL:[NSURL URLWithString:model.img] options:YYWebImageOptionProgressive];
    _usernameLabel.text = model.username;
    _IPLabel.text = [NSString stringWithFormat:@"(%@)",model.user_ip];
    NSString *participateStr = [NSString stringWithFormat:@"参与了%@人次",model.buynum];
   
    _partInLabel.attributedText = [Utils stringWith:participateStr font1:[UIFont systemFontOfSize:13] color1:[UIColor blackColor] font2:[UIFont systemFontOfSize:13] color2:kDefaultColor range:NSMakeRange(3, participateStr.length-5)];
    _timeLabel.text = [Utils timeWith:model.addtime];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@interface TimeLineCell ()


@end

@implementation TimeLineCell

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"TimeLineCell";
    TimeLineCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[TimeLineCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _timeLabel = [YYLabel new];
        _timeLabel.origin = CGPointMake(15, 10);
        _timeLabel.textColor = UIColorHex(999999);
        _timeLabel.font = SYSTEM_FONT(11);
        _timeLabel.layer.cornerRadius = 3.0;
//        _timeLabel.backgroundColor = UIColorHex(0xf5f5f5);
        [self.contentView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
            make.top.equalTo(@10);
            make.bottom.equalTo(@-10);
        }];
    }
    return self;
}

- (void)setTimeLine:(NSString *)timeLine {
    
    _timeLine = timeLine;
    CGFloat width = [_timeLine sizeWithAttributes:@{NSFontAttributeName : SYSTEM_FONT(11)}].width + 8;
    _timeLabel.size = CGSizeMake(width, _timeLabel.height);
    _timeLabel.text = _timeLine;
    [_timeLabel sizeToFit];
    
    CAShapeLayer *seperatorLayer = [CAShapeLayer layer];
    seperatorLayer.frame = CGRectMake(10+kHeadImageDiameter/2, 0, 0.5, _timeLabel.height + 20);
    seperatorLayer.backgroundColor = UIColorHex(0xEFEAE5).CGColor;
    [self.contentView.layer insertSublayer:seperatorLayer atIndex:0];
    
}

@end

