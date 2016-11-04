//
//  KHEditPhoneViewController.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/4.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHBaseViewController.h"
#import "KHAddressModel.h"

typedef NS_ENUM(NSInteger, KHEditPhoneType) {
    KHPhoneAdd = 0,    // 添加
    KHPhoneEdit = 1,   //修改
};
typedef void(^ReloadBlock)();

@interface KHEditPhoneViewController : KHBaseViewController

@property (nonatomic,strong) KHAddressModel *model;

@property (nonatomic,assign) KHEditPhoneType editType;

@property (nonatomic,copy) ReloadBlock block;
@end
