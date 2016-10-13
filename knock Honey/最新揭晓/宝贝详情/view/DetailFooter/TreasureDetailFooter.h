//
//  TreasureDetailFooter.h
//  WinTreasure
//
//  Created by Apple on 16/6/23.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TreasureDetailFooterType) {
    TreasureUnPublishedType = 0,//没揭晓
    TreasurePublishedType
};

@protocol TreasureDetailFooterDelegate;

@interface TreasureDetailFooter : UIView

@property (assign, nonatomic) TreasureDetailFooterType type;


@property (weak, nonatomic) id<TreasureDetailFooterDelegate>delegate;

- (instancetype)initWithType:(TreasureDetailFooterType)type;

@end

@protocol TreasureDetailFooterDelegate <NSObject>

@optional;
- (void)checkNewTreasre;
- (void)clickMenuButtonWithIndex:(NSInteger)index;



@end
