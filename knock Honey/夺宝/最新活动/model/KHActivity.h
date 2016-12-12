//
//  KHActivity.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/12/8.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHActivity : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *instro;
@property (nonatomic,copy) NSString *thumb;
@property (nonatomic,copy) NSString *link;
@property (nonatomic,copy) NSString *addtime;
@property (nonatomic,copy) NSString *subs;
@property (nonatomic,strong) NSString *isshow;

+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict;

+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array;

@end
