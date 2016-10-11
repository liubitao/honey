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

@property (nonatomic, weak) WinTreasureHeader *header;

@property (nonatomic, copy)TreasureMenuViewSelectItemBlock block;

@end


typedef void(^WinTreasureHeaderSelectItemBlock)(id object);
typedef void(^WinTreasureHeaderSelectNoticeBlock)(NSUInteger index);

@protocol WinTreasureHeaderDelegate <NSObject>

/**点击图片
 */
- (void)selectImageView:(WinTreasureHeader *)header currentIndex:(NSInteger)index;

/**点击菜单
 */
- (void)selectItem:(WinTreasureHeader *)header currentIndex:(NSInteger)index;



@end

@interface WinTreasureHeader : UIView

@property (nonatomic, strong) TreasureMenuView *menuView;


@property (nonatomic, copy) WinTreasureHeaderSelectItemBlock menuBlock;


/**点击图片
 */
@property (nonatomic, copy) WinTreasureHeaderSelectItemBlock imageBlock;

+ (CGFloat)height;

- (void)selectItem:(WinTreasureHeaderSelectItemBlock)block;

@end
