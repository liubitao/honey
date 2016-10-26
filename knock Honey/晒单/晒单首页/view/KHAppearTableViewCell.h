//
//  KHAppearTableViewCell.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/25.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHAppearModel.h"

@interface KHAppearTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *winPic;
@property (weak, nonatomic) IBOutlet UILabel *winName;
@property (weak, nonatomic) IBOutlet UILabel *winTitle;
@property (weak, nonatomic) IBOutlet UILabel *proudceName;
@property (weak, nonatomic) IBOutlet UILabel *qishu;
@property (weak, nonatomic) IBOutlet UILabel *winContent;
@property (weak, nonatomic) IBOutlet UIImageView *sharePic;
@property (weak, nonatomic) IBOutlet UIImageView *pic1;
@property (weak, nonatomic) IBOutlet UIImageView *pic2;
@property (weak, nonatomic) IBOutlet UIImageView *pic3;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UIImageView *zanPic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;

- (void)setModel:(KHAppearModel *)model;
+ (CGFloat)height;
@end
