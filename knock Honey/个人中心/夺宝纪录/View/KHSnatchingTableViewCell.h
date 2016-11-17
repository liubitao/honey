//
//  KHSnatchingTableViewCell.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/14.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHSnatchModel.h"
#import "KHSnatchWinModel.h"

@protocol khEdCellDegelage <NSObject>
- (void)tableViewLookup:(KHSnatchModel *)model;
@end
@interface KHSnatchingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *producytName;
@property (weak, nonatomic) IBOutlet UILabel *zhongrenshu;
@property (weak, nonatomic) IBOutlet UILabel *productQishu;
@property (weak, nonatomic) IBOutlet UILabel *buynum;
@property (weak, nonatomic) IBOutlet UILabel *winerName;
@property (weak, nonatomic) IBOutlet UILabel *winerBuynum;
@property (weak, nonatomic) IBOutlet UILabel *winerCode;
@property (weak, nonatomic) IBOutlet UILabel *winerTime;

@property (nonatomic,assign) id <khEdCellDegelage>delegate;

@property (nonatomic,strong) KHSnatchModel *model;

- (void)setModel:(KHSnatchModel *)model;
@end
