//
//  KHZhifubaoModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/21.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KHResponseModel.h"

@interface KHZhifubaoModel : NSObject

@property (nonatomic,strong) KHResponseModel *response;
@property (nonatomic,copy) NSString *sign;
@property (nonatomic,copy) NSString *sign_type;
@property (nonatomic,copy) NSString *alipay_trade_app_pay_response;

+ (instancetype)kh_objectWithKeyValues:(id)dict;
@end
