//
//  YWUser.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/6.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.

#import <Foundation/Foundation.h>

@interface YWUser : NSObject

/**
 *  头像
 */
@property (nonatomic,copy) NSString *img;
/**
 *  经验
 */
@property (nonatomic,copy) NSString *jingyan;
/**
 *  钱币
 */
@property (nonatomic,copy) NSString *money;
/**
 *  积分
 */
@property (nonatomic,copy) NSString *score;
/**
 *  用户id
 */
@property (nonatomic,copy) NSString *userid;
/**
 *  用户名
 */
@property (nonatomic,copy) NSString *username;

@property (nonatomic,copy) NSString *mobile;

@property (nonatomic,copy) NSString *grade;





@end
