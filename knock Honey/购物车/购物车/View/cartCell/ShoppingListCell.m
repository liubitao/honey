//
//  ShoppingListCell.m
//  WinTreasure
//
//  Created by Apple on 16/6/6.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import "ShoppingListCell.h"
#import "ListCountView.h"

@interface ShoppingListCell () <UITextFieldDelegate>

/**商品图片
 */
@property (nonatomic, strong) UIImageView *productImgView;

/**商品名称
 */
@property (nonatomic, strong) YYLabel *productNameLabel;

/**商品总量
 */
@property (nonatomic, strong) YYLabel *productCountLabel;

/**人次
 */
@property (nonatomic, strong) YYLabel *renci;

@property (nonatomic,strong)  UIImageView *pricePic;

@end



@implementation ShoppingListCell

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"ShoppingListCell";
    ShoppingListCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ShoppingListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _productImgView = [UIImageView new];
        _productImgView.origin = CGPointMake(kProductImagePadding, 15);
        _productImgView.size = CGSizeMake(kProductImageDefaultHeight, kProductImageDefaultHeight);
        _productImgView.backgroundColor = UIColorHex(0xeeeeee);
        [self.contentView addSubview:_productImgView];
        
        _pricePic = [UIImageView new];
        _pricePic.origin = CGPointMake(10, 0);
        _pricePic.size = CGSizeMake(30, 35);
        _pricePic.image= IMAGE_NAMED(@"price_tag_ten");
        _pricePic.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_pricePic];
        
        _productNameLabel = [YYLabel new];
        _productNameLabel.origin = CGPointMake(_productImgView.right+kProductImagePadding, 15);
        _productNameLabel.size = CGSizeMake(kProductNameWidth, 39);
        [self.contentView addSubview:_productNameLabel];

        _productCountLabel = [YYLabel new];
        _productCountLabel.origin = CGPointMake(_productImgView.right+12, _productNameLabel.bottom+10);
        _productCountLabel.size = CGSizeMake(kProductNameWidth, 16);
        [self.contentView addSubview:_productCountLabel];

        _listView = [[ListCountView alloc]initWithFrame:({
            CGRect rect = {_productImgView.right+12,_productCountLabel.bottom+10,kChangeListViewWidth,kCountViewDefaultHeight};
            rect;
        })];
        [self.contentView addSubview:_listView];
        
        _renci = [YYLabel new];
        _renci.origin = CGPointMake(_listView.right+8, _listView.top);
        _renci.size = CGSizeMake(40, 16);
        _renci.font = SYSTEM_FONT(12);
        _renci.textColor = UIColorHex(999999);
        _renci.text = @"人次";
        [self.contentView addSubview:_renci];
        
        __weak typeof(self) weakSelf = self;
        _listView.latestCount = ^(NSNumber *listCount) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(listCount:atIndexPath:)]) {
                [weakSelf.delegate listCount:listCount atIndexPath:weakSelf.indexPath];
            }
        };
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)setLayout:(ShoppingListLayout *)layout {
    _layout = layout;
    self.height = _layout.height;
    self.contentView.height = _layout.height;
    CGFloat top = 0;
    if (layout.nameHeight>0) {
        top += kProductImageDefaultMargin;
    }
    if (layout.model.price.integerValue == 10) {
        _pricePic.hidden = NO;
    }else{
        _pricePic.hidden = YES;
    }
    
    _productImgView.top = top;
    [_productImgView sd_setImageWithURL:[NSURL URLWithString:layout.model.goods.thumb]];
    _productNameLabel.top = top;
    _productNameLabel.height = _layout.nameHeight;
    _productNameLabel.width = self.editing ? kProductNameWidth-47 : kProductNameWidth;
  
    _productNameLabel.textLayout = _layout.nameLayout;

    top += _layout.nameHeight;
    _productCountLabel.top = top;
    _productCountLabel.textLayout = _layout.paticipateLayout;
    _productCountLabel.height = _layout.partInAmountHeight;
    NSInteger  surplus = [layout.model.goods.zongrenshu integerValue] - [layout.model.goods.canyurenshu integerValue];
    NSString *surplusStr = [NSString stringWithFormat:@"%ld",(long)surplus];
    NSString *str = [NSString stringWithFormat:@"总需:%@人次,剩余:%@人次",layout.model.goods.zongrenshu,surplusStr];
    NSMutableAttributedString *attributeString = [Utils stringWith:str font1:SYSTEM_FONT(12) color1:UIColorHex(999999) font2:SYSTEM_FONT(12) color2:kDefaultColor range:NSMakeRange(layout.model.goods.zongrenshu.length+9, surplusStr.length)];
    _productCountLabel.attributedText = attributeString;
    
    top += _layout.partInAmountHeight;
    _listView.top = top;
    _listView.selectedCount = _layout.model.buynum.integerValue;
    NSInteger shengyuCount = _layout.model.goods.zongrenshu.integerValue-_layout.model.goods.canyurenshu.integerValue;
    [_listView setSelectedCount:_layout.model.buynum.integerValue totalCount:shengyuCount];
    _listView.userInteractionEnabled = self.editing ? NO : YES;
    
    _renci.top = top+10;
    
}

@end



