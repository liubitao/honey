//
//  KHheard2View.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/12.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^heard2ViewBlcok)(void);

@interface KHheard2View : UICollectionReusableView

@property (nonatomic,copy) heard2ViewBlcok blcok;

- (void)setCellBlcok:(heard2ViewBlcok)blcok;
@end
