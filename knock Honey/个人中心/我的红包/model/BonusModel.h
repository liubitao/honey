//
//  BonusModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/9.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BonusModel : NSObject


/**
 *  红包状态0 可以使用 ；1已使用；2已过期
 */
@property (nonatomic,copy) NSString *user_status;
/**
 *  红包钱
 */
@property (nonatomic,copy) NSString *money;
/**
 *  条件
 */
@property (nonatomic,copy) NSString *condition;
/**
 *  备注
 */
@property (nonatomic,copy) NSString *note;
/**
 *  用户id
 */
@property (nonatomic,copy) NSString *userid;
/**
 *  红包id
 */
@property (nonatomic,copy) NSString *couponid;
/**
 *  添加时间
 */
@property (nonatomic,copy) NSString *addtime;
/**
 *  红包类型
 */
@property (nonatomic,copy) NSString *type;
/**
 *  使用时间
 */
@property (nonatomic,copy) NSString *use_time;
/**
 *  用了没有 1用了，0没使用
 */
@property (nonatomic,copy) NSString *isuse;
/**
 *  订单id
 */
@property (nonatomic,copy) NSString *orderid;
/**
 *
 */
@property (nonatomic,copy) NSString *use_end_time;


@property (nonatomic,copy) NSString *use_beg_time;
/**
 *  红包名
 */
@property (nonatomic,copy) NSString *name;


@end
