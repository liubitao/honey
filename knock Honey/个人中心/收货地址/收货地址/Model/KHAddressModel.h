//
//  KHAddressModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/3.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHAddressModel : NSObject
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *addtime;
@property (nonatomic,copy) NSString *consignee;
@property (nonatomic,copy) NSString *czmobile;
@property (nonatomic,copy) NSString *czqq;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *isdefault;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *userid;
@property (nonatomic,copy) NSString *zipcode;

+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict;

+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array;
@end
