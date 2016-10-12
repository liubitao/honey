//
//  KHDowmViewCell.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/12.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHDowmViewCell.h"
#import "KHKnowModel.h"

@interface KHDowmViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *timeDown;

@end

@implementation KHDowmViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
    _timeDown.layer.cornerRadius = 9;
    _timeDown.layer.masksToBounds = YES;
    
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
    [self setModel:self.model ];
}

-(void)setModel:(KHKnowModel *)model{
    _model = model;
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:IMAGE_NAMED(@"placeholder")];
    _goodsName.text = model.productName;
    _timeDown.text = model.valueString;
    if ([_timeDown.text isEqualToString:@"00:00:00"]) {
        _timeDown.text = @"正在揭晓";
    }
}
- (void)dealloc {
    [self removeNSNotificationCenter];

    
}
+(CGSize)size{
    return CGSizeMake((KscreenWidth-1)/3, 155);
}


@end
