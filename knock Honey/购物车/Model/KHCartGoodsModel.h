//
//  KHCartGoodsModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/10/28.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHCartGoodsModel : NSObject
/**
 *  商品区id
 */
@property (nonatomic,copy) NSString *areaid;

/**
 *  参与人数
 */
@property (nonatomic,copy) NSString *canyurenshu;

/**
 *  商品id
 */
@property (nonatomic,copy) NSString *ID;

/**
 *  商品图
 */
@property (nonatomic,copy) NSString *thumb;

/**
 *  商品名
 */
@property (nonatomic,copy) NSString *title;

/**
 *  总人数
 */
@property (nonatomic,copy) NSString *zongrenshu;

+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict;
@end
