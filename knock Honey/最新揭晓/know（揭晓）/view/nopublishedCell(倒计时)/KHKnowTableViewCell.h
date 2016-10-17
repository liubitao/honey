//
//  KHKnowTableViewCell.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/10.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHKnowModel.h"

@protocol KHKnowtableViewCellDelegate <NSObject>

@optional;

- (void)countdownDidEnd:(NSIndexPath *)indexpath;

@end
@interface KHKnowTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (strong, nonatomic) KHKnowModel *model;

//是否展示
@property (nonatomic, assign) BOOL isDisplayed;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (assign, nonatomic) id<KHKnowtableViewCellDelegate>delegate;

- (void)setModel:(KHKnowModel *)model indexPath:(NSIndexPath *)indexPath;

- (void)settime:(KHKnowModel *)model;

@end
