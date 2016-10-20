//
//  BillView.m
//  WinTreasure
//
//  Created by Apple on 16/6/6.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import "BillView.h"

@interface BillView ()
/**
 *  总价
 */
@property (nonatomic, strong) YYLabel *totalLabel;
/**
 *  声明
 */
@property (nonatomic, strong) YYLabel *riskLabel;
/**
 *  结账
 */
@property (nonatomic, strong) UIButton *billButton;
/**
 *  删除
 */
@property (nonatomic, strong) UIButton *deleteButton;
/**
 *  全选
 */
@property (nonatomic, strong) UIButton *selectButton;

@end

const CGFloat kBillButtonWidth = 80.0;
const CGFloat kBillButtonheight = 30.0;

@implementation BillView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        CAShapeLayer *topLine = [CAShapeLayer layer];
        topLine.origin = CGPointMake(0, 0);
        topLine.size = CGSizeMake(kScreenWidth, CGFloatFromPixel(1));
        topLine.backgroundColor = UIColorHex(0xe5e5e5).CGColor;
        [self.layer addSublayer:topLine];
        [self setup];
    }
    return self;
}

- (void)setup {
    _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectButton.origin = CGPointMake(15, (self.height-40)/2.0);
    _selectButton.size = CGSizeMake(150, 40);
    _selectButton.titleLabel.font = SYSTEM_FONT(14);
    _selectButton.titleLabel.numberOfLines = 0;
    _selectButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    _selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_selectButton setImage:IMAGE_NAMED(@"cartnoSelected") forState:UIControlStateNormal];
    [_selectButton setImage:IMAGE_NAMED(@"cartSelected") forState:UIControlStateSelected];
    NSMutableAttributedString *title = [Utils stringWith:@"全选\n共选中0件商品" font1:SYSTEM_FONT(14) color1:UIColorHex(666666) font2:SYSTEM_FONT(15) color2:[UIColor blackColor] range:NSMakeRange(0, 2)];
    [_selectButton setAttributedTitle:title forState:UIControlStateNormal];
    [_selectButton setTitleColor:UIColorHex(666666) forState:UIControlStateNormal];
    [_selectButton setTitleColor:UIColorHex(666666) forState:UIControlStateSelected];
    [_selectButton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    _selectButton.hidden = YES;
    [self addSubview:_selectButton];
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteButton.origin = CGPointMake(self.width-90, 0);
    _deleteButton.size = CGSizeMake(90, 60);
    _deleteButton.titleLabel.font = SYSTEM_FONT(18);
    _deleteButton.hidden = YES;
    _deleteButton.backgroundColor = [UIColor grayColor];
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_deleteButton];
    _selectButton.centerY = _deleteButton.centerY;

    _billButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _billButton.origin = CGPointMake(self.width-108, 0);
    _billButton.size = CGSizeMake(108, 60);
    _billButton.backgroundColor = kDefaultColor;
    _billButton.titleLabel.font = SYSTEM_FONT(18);
    [_billButton addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    [_billButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [self addSubview:_billButton];
    
    _totalLabel = [YYLabel new];
    _totalLabel.origin = CGPointMake(10, 10);
    _totalLabel.size = CGSizeMake(self.width-15*2-_billButton.width, 17);
    _totalLabel.font = SYSTEM_FONT(16);
    _totalLabel.textColor = [UIColor blackColor];
    [self addSubview:_totalLabel];
    
    _riskLabel = [YYLabel new];
    _riskLabel.origin = CGPointMake(10, _totalLabel.bottom+5);
    _riskLabel.size = CGSizeMake(self.width-15*2-_billButton.width, 15);
    _riskLabel.text = @"夺宝有风险，参与需谨慎";
    _riskLabel.font = SYSTEM_FONT(13);
    _riskLabel.textColor = UIColorHex(999999);
    [_riskLabel sizeToFit];
    [self addSubview:_riskLabel];
}

- (void)setDeleteStyle {
    _selectButton.selected = NO;
    _riskLabel.hidden = YES;
    _totalLabel.hidden = YES;
    _billButton.hidden = YES;
    _selectButton.hidden = NO;
    _deleteButton.hidden = NO;
}

- (void)setNormalStyle {
    _riskLabel.hidden = NO;
    _totalLabel.hidden = NO;
    _billButton.hidden = NO;
    _deleteButton.hidden = YES;
    _selectButton.hidden = YES;
    [self setAttributeTitle:@"全选\n共选中0件商品" forState:UIControlStateNormal];
}

- (void)setAttributeTitle:(NSString *)text forState:(UIControlState)state{
    NSInteger lenght;
    if (state == UIControlStateNormal) {
        lenght = 2;
    }else{
        lenght = 4;
    }
    NSMutableAttributedString *title = [Utils stringWith:text font1:SYSTEM_FONT(14) color1:UIColorHex(666666) font2:SYSTEM_FONT(15) color2:[UIColor blackColor] range:NSMakeRange(0, lenght)];
    [_selectButton setAttributedTitle:title forState:state];
}

- (void)setMoneyNumber:(NSInteger)number Sum:(NSNumber *)money;{
    _totalLabel.text = [NSString stringWithFormat:@"共%ld件商品,总计：%@抢币",number,money];
    _totalLabel.width = [_totalLabel.text sizeWithAttributes:@{NSFontAttributeName :  SYSTEM_FONT(16)}].width;
}

- (void)buy {
    if (_buyBlock) {
        _buyBlock();
    }
}

- (void)delete {
    if (_deleteBlock) {
        _deleteBlock();
    }
}

- (void)select:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.isSelect = sender.selected ? YES : NO;
    if (_selectBlock) {
        _selectBlock(sender);
    }
}

- (void)setSelected:(BOOL)selected {
    _selectButton.selected = selected;
}

+ (CGFloat)getHeight {
    return 60.0;
}

@end
