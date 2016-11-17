//
//  KHCoupon.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/11.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHCoupon : NSObject

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *money;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *typelimit;
+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict;

+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array;
@end
