//
//  KHKnowModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/10.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NOTIFICATION_TIME_CELL  @"NotificationTimeCell"

@interface KHKnowModel : NSObject
@property (nonatomic, copy) NSString *imgUrl;

@property (nonatomic, copy) NSString *productName;

@property (nonatomic, copy) NSString *sprice;

@property (nonatomic, copy) NSNumber *countTime;

/**获奖者
 */
@property (nonatomic, copy) NSString *winner;

/**参与次数
 */
@property (nonatomic, copy) NSString *partInTimes;

/**幸运号码
 */
@property (nonatomic, copy) NSString *luckyNumber;

/**揭晓时间
 */
@property (nonatomic, copy) NSString *publishTime;


@property (nonatomic, assign) BOOL isRunning;

@property (nonatomic, assign) NSInteger startValue;

@property (nonatomic, assign) NSInteger currentValue;

@property (strong, nonatomic) NSString *valueString;

@property (strong, nonatomic) NSTimer *timer;

+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict;

+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array;

- (void)start;


@end
