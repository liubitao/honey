//
//  KHPublishModel.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/20.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHPublishModel.h"
#import <MJExtension/MJExtension.h>


@interface KHPublishModel ()
/**
 *  倒计时时间字符串
 */
@property (copy, nonatomic) NSString *valueString;

@property (strong, nonatomic) NSTimer *timer;

@property (nonatomic, assign) double value;

@property (nonatomic, assign) BOOL running;

@property (nonatomic,assign) BOOL Frist;
@end

@implementation KHPublishModel

+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict{
    [self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID":@"id"
                 };
    }];
    return [self mj_objectWithKeyValues:dict];
}

+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array{
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        KHPublishModel *model = [self kh_objectWithKeyValues:dict];
        if ([model.newtime doubleValue] - 0.2 >[[NSDate date] timeIntervalSince1970]){
            [model start];
        }
        [result addObject:model];
    }
    return result;
}
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

- (void)clockDidTick{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[dat timeIntervalSince1970];
    _value =  ([_newtime doubleValue]- time)*1000;
    [self updateDisplay];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PUSH_CELL object:nil];
}

- (void)stop {
    if (self.timer) {
        if ((self.newtime.doubleValue - 0.2)<[[NSDate date] timeIntervalSince1970]&& !_Frist) {
            _Frist = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STOP_CELL object:nil];
        }
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
