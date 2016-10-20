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

- (void)notificationCenterEvent:(NSNotification*)sender{
    [self reset:sender.object];
}

-(void)setModel:(KHKnowModel *)model{
    _model = model;
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",portPic,model.thumb]] placeholderImage:IMAGE_NAMED(@"placeholder")];
    _goodsName.text = model.title;
    _timeDown.text = [model valueForKey:@"valueString"];
    if ([model.newtime doubleValue]<[[NSDate date] timeIntervalSince1970]) {
        _timeDown.text = @"即将揭晓";
    }
}
- (void)reset:(KHKnowModel*)model{
    _timeDown.text = [model valueForKey:@"valueString"];
    
//    if (![Utils isNull:model]&&[model.newtime doubleValue]<[[NSDate date] timeIntervalSince1970]) {
//            if ([self.delagate respondsToSelector:@selector(reloadDown)]) {
//                [self.delagate reloadDown];
//            }
  
}

- (void)dealloc {
    [self removeNSNotificationCenter];

    
}
+(CGSize)size{
    return CGSizeMake((KscreenWidth-1)/3, 155);
}


@end
