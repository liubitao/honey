//
//  KHPauGoodsModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/9.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHPauGoodsModel : NSObject

@property (nonatomic,copy) NSString *buynum;

@property (nonatomic,copy) NSString *goodsid;

@property (nonatomic,copy) NSString *title;


+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict;

+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array;
@end
