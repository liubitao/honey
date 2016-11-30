//
//  KHMessageTableViewCell.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/11.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHMessageModel.h"

@interface KHMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productLabel;

@property (nonatomic,strong) KHMessageModel *model;

- (void)setModel:(KHMessageModel *)model;

@end
