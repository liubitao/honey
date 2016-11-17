//
//  KHSnatchModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/14.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KHSnatchWinModel.h"

@interface KHSnatchModel : NSObject
/**
 *  图片
 */
@property (nonatomic,copy) NSString *thumb;

@property (nonatomic,copy) NSString *ID;
/**
 *  最新期数
 */
@property (nonatomic,copy) NSString *goodsqishu;

/**
 *  开奖时间
 */
@property (nonatomic,copy) NSString *addtime;


@property (nonatomic,copy) NSString *buynum;
/**
 *  当前期数
 */
@property (nonatomic,copy) NSString *qishu;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *issystem;

@property (nonatomic,copy) NSString *goodsid;

@property (nonatomic,copy) NSString *codes;
/**
 *  1=已经开奖了，0 = 进行中
 */
@property (nonatomic,copy) NSString *isopen;

@property (nonatomic,copy) NSString *zongrenshu;
@property (nonatomic,copy) NSString *canyurenshu;


@property (nonatomic,strong) KHSnatchWinModel *lottery;

+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict;

+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array;
@end
