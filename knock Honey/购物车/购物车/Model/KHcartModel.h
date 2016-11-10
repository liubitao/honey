//
//  KHcartModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/20.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KHCartGoodsModel.h"


@interface KHcartModel : NSObject

@property (nonatomic, assign) BOOL isChecked;

/**
 *  添加时间
 */
@property (nonatomic,copy) NSString *addtime;

/**
 *  商品购买次数
 */
@property (nonatomic,copy) NSString *buynum;

/**
 *  商品id
 */
@property (nonatomic,copy) NSString *goodsid;

/**
 *  购物车id
 */
@property (nonatomic,copy) NSString *ID;

/**
 *  用户id
 */
@property (nonatomic,copy) NSString *userid;

/**
 *  区域
 */
@property (nonatomic,copy) NSString *price;


@property (nonatomic,strong) KHCartGoodsModel *goods;


+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict;

+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array;
@end
