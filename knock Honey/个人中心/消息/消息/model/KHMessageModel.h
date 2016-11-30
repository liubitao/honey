//
//  KHMessageModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/11.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KHShipping.h"

@interface KHMessageModel : NSObject

@property (nonatomic,copy) NSString *userid;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *isread;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *lotteryid;
@property (nonatomic,copy) NSString *addtime;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *goodsid;
@property (nonatomic,copy) NSString *qishu;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *thumb;
@property (nonatomic,strong) KHShipping *shipping;



+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict;

+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array;

@end
