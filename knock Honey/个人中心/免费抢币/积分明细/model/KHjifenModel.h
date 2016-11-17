//
//  KHjifenModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/12.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHjifenModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *score;
@property (nonatomic,copy) NSString *addtime;

+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict;
+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array;
@end
