//
//  KHPublishModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/20.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>
#define NOTIFICATION_PUSH_CELL  @"NotificationPushCell"
#define NOTIFICATION_STOP_CELL  @"NotificationStopCell"

@interface KHPublishModel : NSObject
/**
 *  购买数量
 */
@property (nonatomic, copy) NSString *buynum;
/**
 *  中奖人id
 */
@property (nonatomic, copy) NSString *winid;
/**
 *
 */
@property (nonatomic, copy) NSString *valueb;
/**
 *  商品标题
 */
@property (nonatomic, copy) NSString *title;
/**
 * 中奖人头像
 */
@property (nonatomic, copy) NSString *img;
/**
 *  中奖人昵称
 */
@property (nonatomic, copy) NSString *winner;
/**
 *  中奖人代码
 */
@property (nonatomic, copy) NSString *wincode;
/**
 *  中奖
 */
@property (nonatomic, copy) NSString *ssc;
/**
 *  订单id
 */
@property (nonatomic, copy) NSString *orderid;
@property (nonatomic, copy) NSString *valuea;
/**
 *  期数
 */
@property (nonatomic, copy) NSString *qishu;

@property (nonatomic, copy) NSString *ID;
/**
 *  商品照片
 */
@property (nonatomic, copy) NSString *thumb;
/**
 *
 */
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *formula;
@property (nonatomic, copy) NSString *orderstatus;
@property (nonatomic, copy) NSString *ispoint;
@property (nonatomic, copy) NSString *zongrenshu;

@property (nonatomic, copy) NSString *goodsid;
/**
 *  开奖时间
 */
@property (nonatomic, copy) NSString *newtime;



+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict;

+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array;

- (void)start;

- (void)stop;
@end
