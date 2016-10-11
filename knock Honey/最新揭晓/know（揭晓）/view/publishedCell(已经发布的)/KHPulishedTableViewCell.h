//
//  KHPulishedTableViewCell.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/10.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KHKnowModel;

@interface KHPulishedTableViewCell : UITableViewCell
//是否展示
@property (nonatomic, assign) BOOL isDisplayed;

- (void)setModel:(KHKnowModel *)model indexPath:(NSIndexPath *)indexPath;
@end
