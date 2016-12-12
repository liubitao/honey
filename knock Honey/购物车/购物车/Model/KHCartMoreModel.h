//
//  KHCartMoreModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/12/9.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHCartMoreModel : NSObject
@property (nonatomic,copy) NSString *jindu;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *zongrenshu;
@property (nonatomic,copy) NSString *thumb;
@property (nonatomic,copy) NSString *goodsid;
@property (nonatomic,copy) NSString *qishu;
@property (nonatomic,copy) NSString *canyurenshu;

+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict;

+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array;

@end
