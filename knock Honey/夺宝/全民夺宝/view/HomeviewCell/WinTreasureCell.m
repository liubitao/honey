//
//  WinTreasureCell.m
//  WinTreasure
//
//  Created by Apple on 16/5/31.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import "WinTreasureCell.h"
#import "TSProgressView.h"

#define kWinTreasureCellImagePadding 12.0

@interface WinTreasureCell ()

@property (weak, nonatomic) IBOutlet TSProgressView *progressView;

@end

@implementation WinTreasureCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _addListButton.layer.cornerRadius = 4.0;
    _addListButton.layer.borderWidth = CGFloatFromPixel(1);
    _addListButton.layer.borderColor = kDefaultColor.CGColor;
    _addListButton.layer.masksToBounds = YES;
    _addListButton.layer.shouldRasterize = YES;
    _addListButton.layer.rasterizationScale = kScreenScale;
}



- (IBAction)addList:(UIButton *)sender {
    if (_delegate&&[_delegate respondsToSelector:@selector(addShoppingList:indexPath:)]) {
        [_delegate addShoppingList:self indexPath:_indexPath];
    }
}

- (void)setModel:(KHHomeModel *)model {
    _model = model;
    _nameLabel.text = _model.title;
    [_productImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",portPic,model.thumb]] placeholderImage:IMAGE_NAMED(@"placeholder")];
    NSMutableAttributedString *attrProgress = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"开奖进度%@%%",_model.jindu]];
    [attrProgress addAttribute:NSForegroundColorAttributeName value:UIColorHex(0x007AFF) range:NSMakeRange(4, _model.jindu.length+5-4)];

    _progressLabel.attributedText = attrProgress;

    _progressView.progress = [_model.jindu integerValue];
}

+ (CGSize)size {
    CGFloat imgHeight = ((KscreenWidth-0.5)/2.0-kWinTreasureCellImagePadding)*0.8;
    CGFloat nameHeight = 30;
    CGFloat progressHeight = 15;
    CGFloat tsViewHeight = 8.0;
    CGFloat height =  kImageMargin*4.0+imgHeight+nameHeight+progressHeight+2+tsViewHeight;
    return CGSizeMake((KscreenWidth-0.5)/2.0, height);
}

@end
