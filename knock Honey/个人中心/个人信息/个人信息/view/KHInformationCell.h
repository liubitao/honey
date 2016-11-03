//
//  KHInformationCell.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/3.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KHInformationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
+ (instancetype)cellWithTableView:(UITableView *)tableview;
@end

@interface ProfileDetailCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
