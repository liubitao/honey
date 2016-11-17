//
//  KHpastModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/16.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHpastModel : NSObject
/**
 *  参与次数
 */
@property (nonatomic, copy) NSString * buynum;

/**
 *  头像
 */
@property (nonatomic, copy) NSString *img;
/**
 *  幸运号码
 */
@property (nonatomic, copy) NSString *wincode;

/**
 *  期数
 */
@property (nonatomic, copy) NSString *qishu;

/**
 *  开奖时间
 */
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *goodsid;
/**
 *  ip
 */
@property (nonatomic, copy) NSString *user_ip;
/**
 *  中奖人
 */
@property (nonatomic, copy) NSString *username;

@end
