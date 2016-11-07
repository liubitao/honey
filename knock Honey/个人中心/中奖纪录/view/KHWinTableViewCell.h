//
//  KHWinTableViewCell.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/7.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KHWinTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productQishu;
@property (weak, nonatomic) IBOutlet UILabel *productNumber;
@property (weak, nonatomic) IBOutlet UILabel *productTime;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end
