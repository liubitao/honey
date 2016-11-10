//
//  KHAppearModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/10/26.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHAppearModel : NSObject
/**
 *  晒单id
 */
@property (nonatomic,copy) NSString *ID;
/**
 *  支持数 大于50是人气晒单
 */
@property (nonatomic,copy) NSString *support;
/**
 *  用户id
 */
@property (nonatomic,copy) NSString *userid;
/**
 *  晒单时间
 */
@property (nonatomic,copy) NSString *addtime;
/**
 *  商品标题
 */
@property (nonatomic,copy) NSString *goodstitle;
/**
 *  获奖人头像
 */
@property (nonatomic,copy) NSString *userimg;
/**
 *  图片组
 */
@property (nonatomic,strong) NSMutableArray *img;
/**
 *  标题
 */
@property (nonatomic,copy) NSString *title;
/**
 *  1=待审核； 2= 审核通过 ；3=审核不通过
 */
@property (nonatomic,copy) NSString *check_status;
/**
 *  开奖id
 */
@property (nonatomic,copy) NSString *lotteryid;
/**
 *  期数
 */
@property (nonatomic,copy) NSString *qishu;
/**
 *  用户名
 */
@property (nonatomic,copy) NSString *username;
/**
 *  商品id
 */
@property (nonatomic,copy) NSString *goodsid;
/**
 *  内容
 */
@property (nonatomic,copy) NSString *content;


+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict;

+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array;

@end
