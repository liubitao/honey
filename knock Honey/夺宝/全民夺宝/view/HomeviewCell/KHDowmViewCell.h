//
//  KHDowmViewCell.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/12.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KHKnowModel;

@protocol KHDowmViewCellDelegate <NSObject>

- (void)reloadDown;

@end
@interface KHDowmViewCell : UICollectionViewCell

@property (nonatomic,strong) KHKnowModel *model;

@property (nonatomic,assign) id <KHDowmViewCellDelegate>delagate;

+(CGSize)size;


@end
