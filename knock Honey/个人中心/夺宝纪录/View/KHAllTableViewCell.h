//
//  KHAllTableViewCell.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/14.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSProgressView.h"
#import "KHSnatchModel.h"


@protocol khAllCellDegelage <NSObject>
- (void)tableViewWithBuy:(KHSnatchModel *)model;

- (void)tableViewLookup:(KHSnatchModel *)model;


@end
@interface KHAllTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productQishu;
@property (weak, nonatomic) IBOutlet UILabel *zongrenshu;
@property (weak, nonatomic) IBOutlet UILabel *sehngyurenshu;
@property (weak, nonatomic) IBOutlet UILabel *buynum;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet TSProgressView *progressView;

@property (nonatomic,assign) id <khAllCellDegelage>delegate;
@property (nonatomic,strong) KHSnatchModel *model;

- (void)setModel:(KHSnatchModel *)model;
@end
