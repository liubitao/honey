//
//  KHPhoneViewController.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/3.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHBaseViewController.h"
typedef void(^PhoneModifyBlock)(NSString *phone);

@interface KHPhoneViewController : KHBaseViewController

@property (copy, nonatomic) PhoneModifyBlock phoneBlock;
@end
