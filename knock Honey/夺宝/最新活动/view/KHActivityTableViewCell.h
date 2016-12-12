//
//  KHActivityTableViewCell.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/12/8.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHActivity.h"

@interface KHActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *deLabel;
@property (weak, nonatomic) IBOutlet UILabel *statueLabel;

@property (nonatomic,strong) KHActivity *model;

- (void)setModel:(KHActivity *)model;
@end
