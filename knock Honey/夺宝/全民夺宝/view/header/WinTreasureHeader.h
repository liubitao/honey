//
//  WinTreasureHeader.h
//  WinTreasure
//
//  Created by Apple on 16/6/1.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WinTreasureHeader;

//分类图
typedef void(^TreasureMenuViewSelectItemBlock)(id object);

@interface TreasureMenuView : UIView

@property (nonatomic, copy)TreasureMenuViewSelectItemBlock block;

@end


typedef void(^WinTreasureHeaderSelectItemBlock)(id object);


@interface WinTreasureHeader : UIView

@property (nonatomic, strong) TreasureMenuView *menuView;

//图片
@property (nonatomic, strong) NSMutableArray *images;
/**点击图片
 */
@property (nonatomic, copy) WinTreasureHeaderSelectItemBlock imageBlock;

- (void)resetImage;

+ (CGFloat)height;

- (void)selectItem:(WinTreasureHeaderSelectItemBlock)block;

@end
