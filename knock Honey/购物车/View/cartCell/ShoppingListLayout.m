//
//  ShareListLayout.m
//  WinTreasure
//
//  Created by Apple on 16/6/23.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import "ShoppingListLayout.h"

@implementation ShoppingListLayout

- (instancetype)initWithModel:(KHcartModel *)model {
    if (!model) {
        return nil;
    }
    self = [super init];
    if (self) {
        _model = model;
        [self layout];
    }
    return self;
}

- (void)layout {
    [self commonInit];
}

- (void)commonInit {
    CGFloat tempHeight = 0;
    _marginTop = kProductImageDefaultMargin;
    _imageHeight = kProductImageDefaultHeight;
    _nameHeight = 0;
    _partInAmountHeight = 0;
    _counViewtHeight = kCountViewDefaultHeight;
    _marginBottom = kProductImageDefaultMargin;
    [self layoutProductName];
    [self layoutProductParticipte];
    tempHeight += _marginTop;
    tempHeight += _nameHeight;
    tempHeight += _partInAmountHeight;
    tempHeight += _counViewtHeight;
    tempHeight += _marginBottom;
    _height = (tempHeight>kProductImageDefaultMargin*2+kProductImageDefaultHeight) ? tempHeight : kProductImageDefaultMargin*2+kProductImageDefaultHeight;
}

- (void)layoutProductName {
    _nameHeight = 0;
    _nameLayout = nil;
    NSMutableAttributedString *attributeName = [[NSMutableAttributedString alloc]initWithString:_model.name];
    if (attributeName.length == 0) {
        return;
    }
    attributeName.font = SYSTEM_FONT(14);
    attributeName.color = UIColorHex(333333);
    attributeName.lineBreakMode = NSLineBreakByWordWrapping;
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kProductNameWidth, 16)];
    container.size = CGSizeMake(kProductNameWidth, HUGE);
    _nameLayout = [YYTextLayout layoutWithContainer:container text:attributeName];
    _nameHeight = _nameLayout.rowCount * 16.0 + kProductImageDefaultMargin;
}

- (void)layoutProductParticipte {
    _partInAmountHeight = 0;
    _paticipateLayout = nil;
    NSString *str = [NSString stringWithFormat:@"总需:%@人次,剩余%@人次",_model.totalAmount,_model.leftAmount];
    NSMutableAttributedString *attributeString = [Utils stringWith:str font1:SYSTEM_FONT(12) color1:UIColorHex(999999) font2:SYSTEM_FONT(14) color2:kDefaultColor range:NSMakeRange(_model.totalAmount.length+8, _model.leftAmount.length)];
    if (attributeString.length == 0) {
        return;
    }
    attributeString.font = SYSTEM_FONT(12);
    attributeString.color = UIColorHex(999999);
    attributeString.lineBreakMode = NSLineBreakByTruncatingTail;
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kProductNameWidth, 16)];
    container.maximumNumberOfRows = 1;
    container.size = CGSizeMake(kProductNameWidth, HUGE);
    _paticipateLayout = [YYTextLayout layoutWithContainer:container text:attributeString];
    _partInAmountHeight = _paticipateLayout.rowCount * 16.0 + kProductImageDefaultMargin;
}

@end
