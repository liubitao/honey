//
//  TreasureDetailFooter.m
//  WinTreasure
//
//  Created by Apple on 16/6/23.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import "TreasureDetailFooter.h"
#import "KHProductModel.h"

@interface TreasureDetailFooter ()

@property (nonatomic, strong) NSArray *titles;

@end

const CGFloat kTreasureDetailFooterPadding = 10.0;
const CGFloat kFooterButtonHeight = 40.0;

@implementation TreasureDetailFooter

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"",@"加入购物车",@"立即购买"];
    }
    return _titles;
}

- (instancetype)initWithType:(TreasureDetailFooterType)type Model:(KHProductModel*)model{
    self = [super init];
    if (self) {
        _type = type;
        _model = model;
        self.backgroundColor = [UIColor whiteColor];
        self.frame = ({
            CGRect rect = {0,kScreenHeight-60,kScreenWidth,60};
            rect;
        });
        
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    CAShapeLayer *topLine = [CAShapeLayer layer];
    topLine.origin = CGPointMake(0, 0);
    topLine.size = CGSizeMake(kScreenWidth, CGFloatFromPixel(1));
    topLine.backgroundColor = UIColorHex(0xe5e5e5).CGColor;
    [self.layer addSublayer:topLine];
    
    switch (_type) {
            //没揭晓
        case TreasureUnPublishedType: {
            CGFloat buttonWidth = (kScreenWidth-50-kTreasureDetailFooterPadding*(self.titles.count))/(self.titles.count-1);
            __block typeof(self) weakSelf = self;
            [self.titles enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                      NSUInteger idx,
                                                      BOOL * _Nonnull stop) {
                NSLog(@"%@",obj);
                if (idx == 0) {
                     UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.origin = CGPointMake(kTreasureDetailFooterPadding, (self.height-kFooterButtonHeight)/2.0);
                    button.tag = idx + 1;
                    button.size = CGSizeMake(40, kFooterButtonHeight);
                    [button setImage:IMAGE_NAMED(@"tabbarcart") forState:UIControlStateNormal];
                    [button addTarget:weakSelf action:@selector(winTreasure:) forControlEvents:UIControlEventTouchUpInside];
                    [weakSelf addSubview:button];
                    [button setBadgeBGColor:kDefaultColor];
                    [button setBadgeValue:[NSString stringWithFormat:@"%zi",[AppDelegate getAppDelegate].value]];
                    [button setBadgeTextColor:[UIColor whiteColor]];
                    return ;
                }
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.origin = CGPointMake(50+kTreasureDetailFooterPadding*(idx)+buttonWidth*(idx-1), (self.height-kFooterButtonHeight)/2.0);
                button.tag = idx + 1;
                button.size = CGSizeMake(buttonWidth, kFooterButtonHeight);
                button.layer.cornerRadius = 5.0;
                button.backgroundColor = kDefaultColor;
                [button setTitle:_titles[idx] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                if (idx==1) {
                    button.backgroundColor = [UIColor whiteColor];
                    button.layer.borderColor = kDefaultColor.CGColor;
                    button.layer.borderWidth = CGFloatFromPixel(1);
                    button.layer.masksToBounds = YES;
                    [button setTitleColor:kDefaultColor forState:UIControlStateNormal];
                }
                [button addTarget:weakSelf action:@selector(winTreasure:) forControlEvents:UIControlEventTouchUpInside];
                [weakSelf addSubview:button];
            }];
        }
            break;
        case TreasurePublishedType: {
            YYLabel *label = [YYLabel new];
            label.origin = CGPointMake(kTreasureDetailFooterPadding, (self.height-15)/2.0);
            label.size = CGSizeMake(200, 15);
            label.font = SYSTEM_FONT(14);
            label.textColor = UIColorHex(666666);
            label.text = [NSString stringWithFormat:@"第%@期正在进行..",_model.qishu];
            [self addSubview:label];
            [label sizeToFit];
            
            UIButton *goButton = [UIButton buttonWithType:UIButtonTypeCustom];
            goButton.origin = CGPointMake(kScreenWidth-kTreasureDetailFooterPadding-80, (self.height-30)/2.0);
            goButton.size = CGSizeMake(80, 30);
            goButton.titleLabel.font = SYSTEM_FONT(15);
            goButton.layer.cornerRadius = 4.0;
            goButton.layer.masksToBounds = YES;
            goButton.layer.shouldRasterize = YES;
            goButton.layer.rasterizationScale = kScreenScale;
            goButton.backgroundColor = kDefaultColor;
            [goButton addTarget:self action:@selector(cilickGoBtn) forControlEvents:UIControlEventTouchUpInside];
            [goButton setTitle:@"立即前往" forState:UIControlStateNormal];
            [self addSubview:goButton];
        }
            break;
        default:
            break;
    }
}

- (void)winTreasure:(UIButton *)sender {
    if (_delegate&&[_delegate respondsToSelector:@selector(clickMenuButtonWithIndex:)]) {
        [_delegate clickMenuButtonWithIndex:sender.tag];
    }
}

- (void)cilickGoBtn {
    if (_delegate&&[_delegate respondsToSelector:@selector(checkNewTreasre)]) {
        [_delegate checkNewTreasre];
    }
}

@end
