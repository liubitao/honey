//
//  CategoryDetailCell.h
//  WinTreasure
//
//  Created by Apple on 16/6/6.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHTenModel.h"


@protocol CategoryDetailCellDelegate;
@class TSProgressView;

@interface CategoryDetailCell : UITableViewCell

/**十元专区图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *tenYImgView;

/**商品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *productImgView;

/**商品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;

/**商品期数
 */
@property (weak, nonatomic) IBOutlet UILabel *timeCount;

/**商品已售比例
 */
@property (weak, nonatomic) IBOutlet TSProgressView *progressView;

/**商品参与数
 */
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

/**商品剩余量
 */
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) id<CategoryDetailCellDelegate>delegate;

@property (strong, nonatomic) KHTenModel *model;

@property (copy, nonatomic) NSIndexPath *indexpath;

+ (CGFloat)height;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end

@protocol CategoryDetailCellDelegate <NSObject>

- (void)clickAddListButtonAtCell:(CategoryDetailCell *)cell;

@end
