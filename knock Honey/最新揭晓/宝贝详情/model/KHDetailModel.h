//
//  KHDetailModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/12.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHDetailModel : NSObject
/**
 *  时间
 */
@property (nonatomic,copy) NSString *addtime;
/**
 *  用户名
 */
@property (nonatomic,copy) NSString *username;
/**
 *  id
 */
@property (nonatomic,copy) NSString *userid;
/**
 *  头像
 */
@property (nonatomic,copy) NSString *img;

/**
 *  ip
 */
@property (nonatomic,copy) NSString *user_ip;

/**
 *  参与数
 */
@property (nonatomic,copy) NSString *buynum;


+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array;

@end
