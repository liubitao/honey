//
//  WinTreasureHeader.h
//  WinTreasure
//
//  Created by Apple on 16/6/1.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHAdvertModel.h"
#import "KHAdvertView.h"


@class WinTreasureHeader;

//分类
typedef void(^TreasureMenuViewSelectItemBlock)(id object);

//分类的按钮
@interface TreasureMenuView : UIView

@property (nonatomic, copy)TreasureMenuViewSelectItemBlock block;

@end


typedef void(^WinTreasureHeaderSelectItemBlock)(id object);
typedef void(^WinTreasureHeaderAdvertBlock)();


@interface WinTreasureHeader : UICollectionReusableView

@property (nonatomic, strong) TreasureMenuView *menuView;

//图片
@property (nonatomic, strong) NSMutableArray *images;
//广告视图
@property (nonatomic,strong) KHAdvertView *advertView;
@property (nonatomic,copy)  WinTreasureHeaderAdvertBlock advertBlock;

//广告模型
@property (nonatomic,strong) KHAdvertModel *adVertModel;


/**点击图片
 */
@property (nonatomic, copy) WinTreasureHeaderSelectItemBlock imageBlock;


- (void)setAdVertModel:(KHAdvertModel *)adVertModel with:(NSMutableArray *)images;
+ (CGFloat)height;

- (void)selectItem:(WinTreasureHeaderSelectItemBlock)block;

@end
