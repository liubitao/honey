//
//  KHWinCodeModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/9.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHWinCodeModel : NSObject



@property (nonatomic,copy) NSString *issystem;

@property (nonatomic,copy) NSString *shipping_code;

/**
 *  1=实物；2=虚拟；
 */
@property (nonatomic,copy) NSString *goodstype;
/**
 *  获奖人id
 */
@property (nonatomic,copy) NSString *winid;
/**
 *  价值
 */
@property (nonatomic,copy) NSString *valueb;
/**
 *  奖品
 */
@property (nonatomic,copy) NSString *title;
/**
 *  购买次数
 */
@property (nonatomic,copy) NSString *buynum;

@property (nonatomic,copy) NSString *admin_note;
/**
 *  获得的code数
 */
@property (nonatomic,copy) NSString *codes;

/**
 *  0=有地址；1=没地址
 */
@property (nonatomic,copy) NSString *hasaddress;


/**
 *  状态码  0=待确认 1=未发货 2=已发货，晒单 3=已晒单
 */
@property (nonatomic,copy) NSString *order_status;
@property (nonatomic,copy) NSString *ssc_qishu;
/**
 *  获奖的code
 */
@property (nonatomic,copy) NSString *wincode;
@property (nonatomic,copy) NSString *ssc;
/**
 *  订单id
 */
@property (nonatomic,copy) NSString *orderid;
@property (nonatomic,copy) NSString *valuea;
@property (nonatomic,copy) NSString *qishu;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *shipping_mode;
@property (nonatomic,copy) NSString *addtime;
@property (nonatomic,copy) NSString *formula;
/**
 *  头像
 */
@property (nonatomic,copy) NSString *thumb;
@property (nonatomic,copy) NSString *ispoint;
/**
 *  总人数
 */
@property (nonatomic,copy) NSString *zongrenshu;
/**
 *  奖品id
 */
@property (nonatomic,copy) NSString *goodsid;
@property (nonatomic,copy) NSString *iscomment;
@property (nonatomic,copy) NSString *shipping_time;

+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict;

+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array;
@end
