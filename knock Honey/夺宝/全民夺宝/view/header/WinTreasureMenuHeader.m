//
//  WinTreasureMenuHeader.m
//  WinTreasure
//
//  Created by Apple on 16/6/3.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import "WinTreasureMenuHeader.h"\

#define   kTSMenuHeight 44
@interface WinTreasureMenuHeader ()

@property (nonatomic, strong) NSArray *selectItems;
@property (nonatomic, strong) TSHomeMenu *menu;

@end

@implementation WinTreasureMenuHeader

- (NSArray *)selectItems {
    if (!_selectItems) {
        _selectItems = @[@"人气",@"最快",@"最新",@"高价"];
    }
    return _selectItems;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _menu = [[TSHomeMenu alloc]initWithDataArray:self.selectItems];
        _menu.origin = CGPointMake(0, 0);
        _menu.size = CGSizeMake(KscreenWidth, kTSMenuHeight);
        [self addSubview:_menu];
        
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        lineLayer.frame = CGRectMake(0, kTSMenuHeight-0.5, self.width, 0.5);
        lineLayer.backgroundColor = UIColorHex(0xEAE5E1).CGColor;
        [self.layer addSublayer:lineLayer];
    }
    return self;
}

+ (CGFloat)menuHeight {
    return kTSMenuHeight;
}

- (void)selectAMenu:(WinTreasureMenuHeaderBlock)block {
    _block = block;
    __weak typeof(self) weakSelf = self;
    _menu.menuBlock = ^(UIButton *sender) {
        if (weakSelf.block) {
            weakSelf.block(sender);
        }
    };
}


@end

@interface TSHomeMenu ()


@end

@implementation TSHomeMenu

const CGFloat kTSHomeMenuHeight = 45.0;
const CGFloat kTSHomeMenuDefaultHeight = 44.0;
const CGFloat kTSHomeMenuLineHeight = 2.5;
const CGFloat kTSHomeMenuLineSpacing = 20.0;

- (CAShapeLayer *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [CAShapeLayer layer];
        _bottomLine.frame = CGRectMake(kTSHomeMenuLineSpacing,
                                       kTSHomeMenuDefaultHeight-kTSHomeMenuLineHeight,
                                       (KscreenWidth-(kTSHomeMenuLineSpacing*2*_data.count))/_data.count,
                                       kTSHomeMenuLineHeight);
        _bottomLine.backgroundColor = kDefaultColor.CGColor;
    }
    return _bottomLine;
}

- (instancetype)initWithDataArray:(NSArray *)data {
    self = [super init];
    if (self) {
        _data = data;
        self.backgroundColor = [UIColor whiteColor];
        [self configMenu];
    }
    return self;
}

- (void)configMenu {
    [_data enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                        NSUInteger idx,
                                        BOOL * _Nonnull stop) {
        UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        menuBtn.tag = idx+1;
        menuBtn.origin = CGPointMake(idx*KscreenWidth/_data.count, 0);
        menuBtn.size = CGSizeMake(KscreenWidth/_data.count, kTSHomeMenuDefaultHeight);
        [menuBtn setTitle:_data[idx] forState:UIControlStateNormal];
        [menuBtn setTitleColor:UIColorHex(666666) forState:UIControlStateNormal];
        [menuBtn setTitleColor:kDefaultColor forState:UIControlStateSelected];
        [menuBtn addTarget:self action:@selector(selectMenu:) forControlEvents:UIControlEventTouchUpInside];
        menuBtn.titleLabel.font = SYSTEM_FONT(14);
        [self addSubview:menuBtn];
        if (idx == 0) {
            menuBtn.selected = YES;
            menuBtn.userInteractionEnabled = NO;
            _selectedBtn = menuBtn;
        }
        
    }];
    [self.layer addSublayer:self.bottomLine];
}

- (void)selectMenu:(UIButton *)sender {
    [self refreshButtonState:sender];
    CGFloat lineWidth = _bottomLine.frame.size.width;
    CGFloat x = (sender.tag-1) * (kTSHomeMenuLineSpacing + lineWidth) + (sender.tag) * kTSHomeMenuLineSpacing;
    [self scrollBottomLine:x];
    if (_menuBlock) {
        _menuBlock(sender);
    }
}

- (void)refreshButtonState:(UIButton *)sender {
    _selectedBtn.selected = NO;
    _selectedBtn.userInteractionEnabled = YES;
    sender.selected = !sender.selected;
    sender.userInteractionEnabled = NO;
    _selectedBtn = sender;
}

- (void)scrollBottomLine:(CGFloat)x {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _bottomLine.frame;
        rect.origin.x = x;
        _bottomLine.frame = rect;
    }];
}


@end
