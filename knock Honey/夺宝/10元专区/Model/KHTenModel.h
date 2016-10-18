//
//  KHTenModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/13.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHTenModel : NSObject

@property (nonatomic, copy) NSString *ID;
/**
 *  商品名
 */
@property (nonatomic, copy) NSString *title;
/**
 *  总人数
 */
@property (nonatomic, copy) NSString *zongrenshu;
/**
 *  商品图片
 */
@property (nonatomic, copy) NSString *thumb;
/**
 *  进度
 */
@property (nonatomic, copy) NSString *jindu;
/**
 *  期数
 */
@property (nonatomic, copy) NSString *qishu;
/**
 *  参与人数
 */
@property (nonatomic, copy) NSString *canyurenshu;

+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict;

+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array;

@end
