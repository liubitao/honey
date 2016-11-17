//
//  KHSearchTableViewCell.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/16.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHSearchModel.h"
#import "KHSearItemButton.h"

@protocol KHSearchCellDelegate <NSObject>

- (void)click:(KHSearchModel *)model;

@end

@interface KHSearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *button1;

@property (weak, nonatomic) IBOutlet UIButton *button2;

@property (nonatomic,strong) KHSearchModel *model1;
@property (nonatomic,strong) KHSearchModel *model2;

@property (nonatomic,assign) id <KHSearchCellDelegate>delegate;

- (void)setModel1:(KHSearchModel *)model1;

- (void)setModel2:(KHSearchModel *)model2;

@end
