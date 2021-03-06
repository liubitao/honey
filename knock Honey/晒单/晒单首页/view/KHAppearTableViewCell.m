//
//  KHAppearTableViewCell.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/25.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHAppearTableViewCell.h"

@implementation KHAppearTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _winPic.layer.cornerRadius = 3;
    _winPic.layer.masksToBounds = YES;
    [self setLayoutMargins:UIEdgeInsetsZero];
    [self setSeparatorInset:UIEdgeInsetsZero];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setModel:(KHAppearModel *)model{
    NSString *tring = [model.userimg stringByReplacingOccurrencesOfString:@"\%" withString:@""];
    [_winPic sd_setImageWithURL:[NSURL URLWithString:tring] placeholderImage:IMAGE_NAMED(@"kongren")];
    _winName.text = model.username;
    _winTitle.text = model.title;
    _proudceName.text = model.goodstitle;
    _qishu.text = [NSString stringWithFormat:@"商品期数：%@",model.qishu];
    _winContent.text = model.content;
    
    _time.text = [NSString transToTime:model.addtime];
    NSString *str = [NSString stringWithFormat:@"(%@)",model.support];
    _number.text = str;
    
    if (model.issupport.integerValue == 1) {
        _zanPic.image = IMAGE_NAMED(@"zanSelect");
    }else{
        _zanPic.image = IMAGE_NAMED(@"zan");
    }
    
    
    if (model.support.integerValue >= 50) {
        _sharePic.hidden = NO;
    }else{
        _sharePic.hidden = YES;
    }
    
    NSArray *array = @[_pic1,_pic2,_pic3];
    
    for (int i = 0; i<model.img.count; i++) {
        if (i == 3) {
            break;
        }
        [array[i] sd_setImageWithURL:[NSURL URLWithString:model.img[i]]];
    }
 
}

+ (CGFloat)height{
    return 290- 229/3+(KscreenWidth - 40- 90- 16)/3;
}
@end
