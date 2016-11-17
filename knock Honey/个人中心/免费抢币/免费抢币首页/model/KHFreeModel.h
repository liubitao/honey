//
//  KHFreeModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/11.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KHCoupon.h"

@interface KHFreeModel : NSObject

@property (nonatomic,copy) NSString *sign_in_time;
@property (nonatomic,copy) NSString *score;
@property (nonatomic,copy) NSString *issign;

@property (nonatomic,strong) NSMutableArray *coupons;

+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict;
@end
