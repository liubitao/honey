//
//  KHPayResultModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/10.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHPayResultModel : NSObject
@property (nonatomic,copy) NSString *count;
@property (nonatomic,strong) NSMutableArray *goods;
@property (nonatomic,copy) NSString *status;

+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict;
@end
