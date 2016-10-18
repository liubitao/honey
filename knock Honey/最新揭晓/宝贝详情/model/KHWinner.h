//
//  KHWinner.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/18.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHWinner : NSObject
/**
 *  中奖号码
 */
@property (nonatomic,copy) NSString *wincode;
/**
 *  开奖时间
 */
@property (nonatomic,copy) NSString *addtime;
/**
 *  中奖人头像
 */
@property (nonatomic,copy) NSString *img;
/**
 *  本期参与次数
 */
@property (nonatomic,copy) NSString *buynum;
/**
 *  中奖id
 */
@property (nonatomic,copy) NSString *winid;
/**
 *  订单id
 */
@property (nonatomic,copy) NSString *orderid;
/**
 *  开奖人姓名
 */
@property (nonatomic,copy) NSString *username;
/**
 *  开奖人ip
 */
@property (nonatomic,copy) NSString *user_ip;
/**
 *  中奖期数
 */
@property (nonatomic,copy) NSString *qishu;
/**
 *  开奖时间
 */
@property (nonatomic,copy) NSString *newtime;

@end
