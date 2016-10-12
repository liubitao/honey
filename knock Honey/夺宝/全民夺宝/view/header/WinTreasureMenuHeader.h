//
//  WinTreasureMenuHeader.h
//  WinTreasure
//
//  Created by Apple on 16/6/3.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^WinTreasureMenuHeaderBlock)(id object);

@interface WinTreasureMenuHeader : UICollectionReusableView

@property (nonatomic, copy) WinTreasureMenuHeaderBlock block;


+ (CGFloat)menuHeight;

- (void)selectAMenu:(WinTreasureMenuHeaderBlock)block;

@end

typedef void (^TSHomeMenuSelectedBlock)(id object);


@interface TSHomeMenu : UIView


@property (nonatomic, strong) NSArray *data;

@property (nonatomic, strong) CAShapeLayer *bottomLine;

@property (nonatomic, copy) TSHomeMenuSelectedBlock menuBlock;


- (instancetype)initWithDataArray:(NSArray *)data;

@end
