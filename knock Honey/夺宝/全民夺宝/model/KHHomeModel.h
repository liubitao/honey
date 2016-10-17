//
//  KHHomeModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/11.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHHomeModel : NSObject

/**
 *  ID
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  期数
 */
@property (nonatomic, copy) NSString *qishu;
/**
 *  商品名
 */
@property (nonatomic, copy) NSString *title;
/**
 *  商品图
 */
@property (nonatomic, copy) NSString *thumb;

/**
 *  进度
 */
@property (nonatomic, copy) NSString *jindu;

+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict;

+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array;

@end
