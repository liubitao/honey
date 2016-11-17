//
//  KHTopupTableViewCell.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/1.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KHTopupTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellimage;
@property (weak, nonatomic) IBOutlet UILabel *leibie;

@property (weak, nonatomic) IBOutlet UILabel *des;

@property (weak, nonatomic) IBOutlet UIImageView *selectImage;


+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
