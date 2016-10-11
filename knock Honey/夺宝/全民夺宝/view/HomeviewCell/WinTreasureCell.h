//
//  WinTreasureCell.h
//  WinTreasure
//
//  Created by Apple on 16/5/31.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHHomeModel.h"

#define kImagePadding 5.0 //图片左右间距
#define kImageMargin 8.0 //图片是上下间距

@class TSProgressView;
@protocol WinTreasureCellDelegate;

@interface WinTreasureCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *addListButton;

@property (weak, nonatomic) IBOutlet UIImageView *productImgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (nonatomic, copy) NSIndexPath *indexPath;

@property (nonatomic, strong) KHHomeModel *model;

@property (nonatomic, weak) id<WinTreasureCellDelegate>delegate;

+ (CGSize)size;

@end

@protocol WinTreasureCellDelegate <NSObject>

- (void)addShoppingList:(WinTreasureCell *)cell indexPath:(NSIndexPath *)indexPath;

@end
