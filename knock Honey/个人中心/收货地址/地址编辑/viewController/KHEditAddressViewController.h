//
//  KHEditAddressViewController.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/4.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHBaseViewController.h"
#import "KHAddressModel.h"

typedef NS_ENUM(NSInteger, KHEditAddressType) {
    KHAddressAdd = 0,    // 添加
    KHAddressEdit = 1,   //修改
};

@interface KHEditAddressViewController : KHBaseViewController

@property (nonatomic,strong) KHAddressModel *model;
@property (nonatomic,assign) KHEditAddressType editType;


@end
