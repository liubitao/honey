//
//  KHOtherWinCell.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/12/7.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHWinCodeModel.h"

@interface KHOtherWinCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productPic;
@property (weak, nonatomic) IBOutlet UILabel *productTitle;
@property (weak, nonatomic) IBOutlet UILabel *productQishu;
@property (weak, nonatomic) IBOutlet UILabel *productWincode;
@property (weak, nonatomic) IBOutlet UILabel *productTime;
@property (nonatomic,strong) KHWinCodeModel *model;

- (void)setModel:(KHWinCodeModel *)model;
@end
