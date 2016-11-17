//
//  KHAppearDetailController.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/10/26.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHBaseViewController.h"
#import "KHAppearDetailModel.h"

typedef void(^KHAppearBlock)();
@interface KHAppearDetailController : KHBaseViewController

@property (nonatomic,strong) KHAppearDetailModel *AppearModel;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,copy) KHAppearBlock block;

@end
