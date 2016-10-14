//
//  TreaureMenu.m
//  WinTreasure
//
//  Created by Apple on 16/6/13.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import "TreaureHeaderMenu.h"

@implementation TreaureHeaderMenu

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)data{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorHex(0xEFEAE5);
        _data = data;
        [_data enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                            NSUInteger idx,
                                            BOOL * _Nonnull stop) {
            MenuView *menu = [[MenuView alloc]initWithFrame:({
                CGRect rect = {0, kTreaureHeaderMenuMargin+kMenuButtonHeight*idx, kScreenWidth, kMenuButtonHeight};
                rect;
            })];
            menu.tag = idx;
            menu.titleLabel.text = _data[idx];
            if ([_data[idx] isEqualToString:@"图文详情"]) {
                menu.detailLabel.text = @"建议在wifi下查看";
            }
            menu.eventButton.tag = idx;
            [menu.eventButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(f0f0f0)] forState:UIControlStateHighlighted];
            [menu.eventButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:menu];
            
        }];
        RecordView *record = [[RecordView alloc]initWithFrame:({
            CGRect rect = {0,_data.count*kMenuButtonHeight+kTreaureHeaderMenuMargin,self.width,kMenuButtonHeight};
            rect;
        })];
        [self addSubview:record];
        self.height = record.bottom;
    }
    return self;
}

- (void)clickButton:(UIButton *)sender {
    if (_block) {
        _block(sender.tag);
    }
}

@end


const CGFloat kMenuViewPadding = 8.0; //左右间距

@implementation MenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //主标题
        _titleLabel = [YYLabel new];
        _titleLabel.origin = CGPointMake(kMenuViewPadding, 0);
        _titleLabel.size = CGSizeMake(100, kMenuButtonHeight);
        _titleLabel.font = SYSTEM_FONT(17);
        _titleLabel.textColor = [UIColor blackColor];
        [self addSubview:_titleLabel];
    
        //向右箭头
        _arrowImageView = [UIImageView new];
        _arrowImageView.origin = CGPointMake(kScreenWidth-kMenuViewPadding-7, (kMenuButtonHeight-13)/2.0);
        _arrowImageView.size = CGSizeMake(7, 13);
        _arrowImageView.image = IMAGE_NAMED(@"right_Arrow");
        [self addSubview:_arrowImageView];
        //副标题
        _detailLabel = [YYLabel new];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.size = CGSizeMake(100, kMenuButtonHeight);
        _detailLabel.right = _arrowImageView.left-kMenuViewPadding;
        _detailLabel.font = SYSTEM_FONT(11);
        _detailLabel.textColor = UIColorHex(999999);
        [self addSubview:_detailLabel];
        
        _eventButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _eventButton.frame = self.bounds;
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame =  CGRectMake(0,kMenuButtonHeight-0.3,self.width,0.3);
        layer.backgroundColor = UIColorHex(0xEFEAE5).CGColor;
        [_eventButton.layer addSublayer:layer];
        [self addSubview:_eventButton];
    }
    return self;
}


@end

@implementation RecordView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _titleLabel = [YYLabel new];
        _titleLabel.origin = CGPointMake(kMenuViewPadding,11);
        _titleLabel.size = CGSizeMake(100, kMenuButtonHeight);
        _titleLabel.font = SYSTEM_FONT(17);
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = @"参与记录";
        [self addSubview:_titleLabel];
        [_titleLabel sizeToFit];
        
        _detailLabel = [YYLabel new];
        _detailLabel.origin = CGPointMake(_titleLabel.right, 0);
        _detailLabel.size = CGSizeMake(self.width-_titleLabel.right+8, kMenuButtonHeight);
        _detailLabel.font = SYSTEM_FONT(11);
        _detailLabel.textColor = UIColorHex(999999);
        _detailLabel.text = @"(2016-06-10 15:49:23开始)";
        [self addSubview:_detailLabel];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame =  CGRectMake(0,kMenuButtonHeight-0.3,self.width,0.3);
        layer.backgroundColor = UIColorHex(0xEFEAE5).CGColor;
        [self.layer addSublayer:layer];
    }
    return self;
}

@end
