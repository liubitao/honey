//
//  KHCodeCell.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/15.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHCodeCell.h"

@interface KHCodeCell ()
@property (nonatomic , strong) UILabel *CodeShow;

@end
@implementation KHCodeCell


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _CodeShow = [[UILabel alloc] initWithFrame:CGRectZero];
        _CodeShow.font = SYSTEM_FONT(12);
        _CodeShow.textColor = UIColorHex(#323232);
        _CodeShow.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_CodeShow];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    _CodeShow.frame = self.contentView.bounds;
}

- (void)setCode:(NSString *)code{
     _CodeShow.text = code;
}

- (void)setSelectColor:(UIColor *)selectColor{
    _CodeShow.textColor = selectColor;
}
@end
