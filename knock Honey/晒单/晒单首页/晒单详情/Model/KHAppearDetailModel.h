//
//  KHAppearDetailModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/10.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHAppearDetailModel : NSObject

@property (nonatomic,copy) NSString *ID;

@property (nonatomic,copy) NSString *wincode;

@property (nonatomic,copy) NSString *support;

@property (nonatomic,copy) NSString *userid;

@property (nonatomic,copy) NSString *addtime;

@property (nonatomic,copy) NSString *goodstitle;

@property (nonatomic,copy) NSString *userimg;

@property (nonatomic,strong) NSMutableArray *img;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *check_status;

@property (nonatomic,copy) NSString *lotteryid;

@property (nonatomic,copy) NSString *qishu;

@property (nonatomic,copy) NSString *lotterytime;

@property (nonatomic,copy) NSString *buynum;

@property (nonatomic,copy) NSString *username;

@property (nonatomic,copy) NSString *goodsid;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) NSString *issupport;


+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict;
@end
