//
//  KHProductModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/12.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KHWinner.h"


@interface KHProductModel : NSObject

/**
 *  总需人数
 */
@property (nonatomic,copy) NSString *zongrenshu;

/**
 *  商品图标
 */
@property (nonatomic,copy) NSString *thumb;
/**
 *  开奖时间
 */
@property (nonatomic,copy) NSString *newtime;

/**
 *  单价
 */
@property (nonatomic,copy) NSString *price;

/**
 *  商品标题
 */
@property (nonatomic,copy) NSString *title;

/**
 *  自己购买的代码
 */
@property (nonatomic,copy) NSString *codes;

/**
 *  评论次数
 */
@property (nonatomic,copy) NSString *comment_count;

/**
 *  期数
 */
@property (nonatomic,copy) NSString *qishu;

/**
 *  计算方式
 */
@property (nonatomic,copy) NSString *formula;
/**
 *  开奖进度
 */
@property (nonatomic,copy) NSString *jindu;
/**
 *  参与人数
 */
@property (nonatomic,copy) NSString *canyurenshu;
/**
 *  商品描述
 */
@property (nonatomic,copy) NSString *content;

/**
 *  图片组
 */
@property (nonatomic,strong) NSArray *picarr;

@property (nonatomic,strong) KHWinner *winner;

+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict;
@end
