//
//  KHDistanceViewCell.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/26.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHMessageModel.h"

@interface KHDistanceViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *allView;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productTitle;
@property (weak, nonatomic) IBOutlet UILabel *qishuLabel;

@property (nonatomic,strong) KHMessageModel *model;

- (void) setModel:(KHMessageModel *)model;
@end
