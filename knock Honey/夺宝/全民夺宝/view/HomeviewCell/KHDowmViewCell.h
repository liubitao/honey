//
//  KHDowmViewCell.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/12.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KHKnowModel;
@interface KHDowmViewCell : UICollectionViewCell

@property (nonatomic,strong) KHKnowModel *model;

+(CGSize)size;


@end
