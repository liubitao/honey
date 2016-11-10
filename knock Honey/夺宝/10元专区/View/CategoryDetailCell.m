//
//  CategoryDetailCell.m
//  WinTreasure
//
//  Created by Apple on 16/6/6.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import "CategoryDetailCell.h"
#import "TSProgressView.h"

@interface CategoryDetailCell ()

/**加入清单
 */
@property (weak, nonatomic) IBOutlet UIButton *addListButton;


@end

@implementation CategoryDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _addListButton.layer.cornerRadius = 4.0;
    _addListButton.layer.borderWidth = CGFloatFromPixel(0.6);
    _addListButton.layer.borderColor = kDefaultColor.CGColor;
    _addListButton.layer.masksToBounds = YES;
    _addListButton.layer.shouldRasterize = YES;
    _addListButton.layer.rasterizationScale = kScreenScale;

}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"CategoryDetailCell";
    CategoryDetailCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (CategoryDetailCell *)[[[NSBundle mainBundle] loadNibNamed:@"CategoryDetailCell" owner:self options:nil] lastObject];
    }
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addList {
    if (_delegate && [_delegate respondsToSelector:@selector(clickAddListButtonAtCell:)]) {
        [_delegate clickAddListButtonAtCell:self];
    }
}

- (void)setModel:(KHTenModel *)model {
    _model = model;
    [_productImgView setImageWithURL:[NSURL URLWithString:model.thumb] options:YYWebImageOptionProgressive];
    _productNameLabel.text = _model.title;
    
    _totalLabel.text = [NSString stringWithFormat:@"已参与:%@",_model.canyurenshu];
    
    _timeCount.text = [NSString stringWithFormat:@"商品期数:%@",model.qishu];
    
    int right = [_model.zongrenshu intValue]- [_model.canyurenshu intValue];
    _progressView.progress = _model.jindu.integerValue;
    NSString *rightString = [NSString stringWithFormat:@"剩余:%d",right];
    _leftLabel.text = rightString;
}

+ (CGFloat)height {
    return 134.0;
}

@end
