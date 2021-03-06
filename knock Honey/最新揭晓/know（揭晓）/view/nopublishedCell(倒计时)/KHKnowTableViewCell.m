//
//  KHKnowTableViewCell.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/10.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHKnowTableViewCell.h"

@interface KHKnowTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *knowImage;
@property (weak, nonatomic) IBOutlet UIImageView *goodImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *sprice;

@end
@implementation KHKnowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self registerNSNotificationCenter];
}

#pragma mark - 通知中心
- (void)registerNSNotificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEvent:)
                                                 name:NOTIFICATION_TIME_CELL
                                               object:nil];
}

- (void)removeNSNotificationCenter {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_TIME_CELL object:nil];
}

- (void)notificationCenterEvent:(id)sender{
    if (self.isDisplayed){
        [self settime:self.model];
    }
}

- (void)setModel:(KHKnowModel *)model indexPath:(NSIndexPath *)indexPath{
    [self storeWeakValueWithData:model indexPath:indexPath];
    [_goodImage sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _timeLabel.text = [model valueForKey:@"valueString"];
    _title.text = model.title;
    _sprice.text = [NSString stringWithFormat:@"总需:￥%@",model.zongrenshu];
}
- (void)settime:(KHKnowModel *)model{
    _timeLabel.text = [model valueForKey:@"valueString"];
    if ([_timeLabel.text isEqualToString:@"已揭晓"]){
        if (_delegate && [_delegate respondsToSelector:@selector(countdownDidEnd:)]) {
            [_delegate countdownDidEnd:self.indexPath];
        }
    }
}


- (void)storeWeakValueWithData:(KHKnowModel *)model indexPath:(NSIndexPath *)indexPath {
    self.model = model;
    self.indexPath = indexPath;
}

- (void)dealloc {
    [self removeNSNotificationCenter];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
