//
//  KHPulishedTableViewCell.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/10.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHPulishedTableViewCell.h"
#import "KHKnowModel.h"

@interface KHPulishedTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *goodImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *sprice;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *publishTime;
    
@end
@implementation KHPulishedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setModel:(KHKnowModel *)model indexPath:(NSIndexPath *)indexPath{
    [_goodImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",portPic,model.thumb]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _title.text = model.title;
    _sprice.text = [NSString stringWithFormat:@"总需:￥%@",model.zongrenshu];
    _name.attributedText = [Utils stringWith:[NSString stringWithFormat:@"获奖者:%@",model.winner] font1:[UIFont systemFontOfSize:12.f] color1:[UIColor colorWithHexString:@"2a99f4"] font2:[UIFont systemFontOfSize:12.f] color2:[UIColor colorWithWhite:0 alpha:0.5] range:NSMakeRange(0, 3)];
    NSString *numebr =[NSString stringWithFormat:@"本期夺宝:%@人次",model.buynum];
    _number.attributedText = [Utils stringWith:numebr font1:[UIFont systemFontOfSize:12.f] color1:[UIColor colorWithWhite:0 alpha:0.5] font2:[UIFont systemFontOfSize:12.f] color2:[UIColor redColor] range:NSMakeRange(5, numebr.length-7)];
    _publishTime.text = [NSString stringWithFormat:@"揭晓时间:%@",[Utils timeWith:model.newtime]];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
