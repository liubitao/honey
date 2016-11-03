//
//  KHAddressTableViewCell.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/3.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHAddressModel.h"


@protocol KHAddressDelegate <NSObject>

- (void)edit:(KHAddressModel*)model indexpath:(NSIndexPath*)indexpath;

@end

@interface KHAddressTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *moren;
@property (weak, nonatomic) IBOutlet UILabel *takeMan;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *takeAddress;

@property (nonatomic,strong) KHAddressModel *model;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,assign) id <KHAddressDelegate>delegate;

- (void)serModel:(KHAddressModel *)model;
+(CGFloat)height;
@end
