//
//  KHKnowModel.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/10.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHKnowModel.h"
#import <MJExtension/MJExtension.h>

@interface KHKnowModel ()

@property (nonatomic, assign) double value;

@property (nonatomic, assign) BOOL running;

@end

@implementation KHKnowModel
MJCodingImplementation
- (instancetype)init {

    self = [super init];
    if (self) {
        self.imgUrl = @"https://tse4-mm.cn.bing.net/th?id=OIP.M9271c634f71d813901afbc9e69602dcfo2&pid=15.1";
        self.productName = @"斯嘉丽·约翰逊(Scarlett Johansson),1984年11月22日生于纽约，美国女演员。";
        self.sprice = @"220";
        self.winner = @"起什么名能中奖";
        self.partInTimes = @"20次";
        self.luckyNumber = @"1000043";
        self.publishTime = @"1476262390";
    }
    return self;
}
+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict{
    [self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID":@"id"
                 };
    }];
    return [self mj_objectWithKeyValues:dict];
}

//+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array{
//    NSMutableArray *result = [NSMutableArray array];
//    for (NSDictionary *dict in array) {
//        
//        }
//        [result addObject:model];
//    }
//    return result;
//}
#pragma mark - Setters

- (void)updateDisplay {
    if ( _value < 200) {
        [self stop];
        self.valueString = @"正在揭晓";
    } else {
        self.valueString = [self timeFormattedStringForValue:_value];
    }
}

- (void)start {
    if (self.running) return;
    self.running = YES;
    self.timer = [NSTimer timerWithTimeInterval:0.05
                                         target:self
                                       selector:@selector(clockDidTick)
                                       userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)clockDidTick {
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[dat timeIntervalSince1970];
    _value =  ([_publishTime doubleValue]- time)*1000;
    [self updateDisplay];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_CELL object:nil];
    
}

- (void)stop {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.running = NO;
}

- (NSString *)timeFormattedStringForValue:(unsigned long)value {
    int msperhour = 3600000;
    int mspermin = 60000;
    
    int hrs = (int)value / msperhour;
    int mins = (value % msperhour) / mspermin;
    int secs = ((value % msperhour) % mspermin) / 1000;
    int frac = value % 1000 / 10;
    
    NSString *formattedString = @"";
    
    if (hrs == 0) {
        if (mins == 0) {
            formattedString = [NSString stringWithFormat:@"%02d:%02d:%02d",hrs, secs, frac];
        } else {
            formattedString = [NSString stringWithFormat:@"%02d:%02d:%02d", mins, secs, frac];
        }
    } else {
        formattedString = [NSString stringWithFormat:@"%02d:%02d:%02d:%02d", hrs, mins, secs, frac];
    }
    
    return formattedString;
}
@end
