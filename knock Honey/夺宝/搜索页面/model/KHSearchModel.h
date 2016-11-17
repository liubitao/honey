//
//  KHSearchModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/16.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHSearchModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *keywords;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *sort;

+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict;

+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array;
@end
