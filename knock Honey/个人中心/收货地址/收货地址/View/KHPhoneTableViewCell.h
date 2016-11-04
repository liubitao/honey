//
//  KHPhoneTableViewCell.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/3.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHAddressModel.h"

@protocol KHPhoneDelegate <NSObject>

- (void)editPhone:(KHAddressModel*)model indexpath:(NSIndexPath*)indexpath;

@end

@interface KHPhoneTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *QQnumber;
@property (nonatomic,strong) NSIndexPath *indexpath;
@property (nonatomic,strong) KHAddressModel *model;

@property (nonatomic,assign) id <KHPhoneDelegate>delegate;

- (void)setModel:(KHAddressModel *)model;
+(CGFloat)height;
@end
