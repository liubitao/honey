//
//  KHPayModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/9.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KHPauGoodsModel.h"

@interface KHPayModel : NSObject

/**
 *  红包id
 */
@property (nonatomic,copy) NSString *couponid;

/**
 *  用户余额
 */
@property (nonatomic,copy) NSString *money;

/**
 *  应付金额
 */
@property (nonatomic,copy) NSString *order_amount;
/**
 *  订单id
 */
@property (nonatomic,copy) NSString *orderid;
/**
 *  红包抵扣价格
 */
@property (nonatomic,copy) NSString *red_price;

@property (nonatomic,strong) NSMutableArray *goods;


+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict;



@end
