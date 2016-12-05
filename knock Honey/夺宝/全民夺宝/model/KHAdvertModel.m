//
//  KHAdvertModel.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/30.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHAdvertModel.h"
#import <MJExtension.h>

@interface KHAdvertModel ()


@property (nonatomic, assign) BOOL running;
@property (nonatomic, assign) double value;

@end

@implementation KHAdvertModel

+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict{
    [self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID":@"id"
                 };
    }];
    KHAdvertModel *model = [self mj_objectWithKeyValues:dict];
    if ([model.prom_end doubleValue]  >[[NSDate date] timeIntervalSince1970]){
        [model start];
    }
    return model;
}

- (void)updateDisplay {
    if ( _value < 1) {
        [self stop];
    } else {
        self. timeStr= [self timeFormattedStringForValue:_value];
    }
}

- (void)start {
        if (self.running) return;
        self.running = YES;
        self.timer = [NSTimer timerWithTimeInterval:1
                                             target:self
                                           selector:@selector(clockDidTick)
                                           userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)clockDidTick{
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];
    _value =  ([_prom_end doubleValue]- time);
    [self updateDisplay];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"advertViewDown" object:nil];
}

- (void)stop {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"advertStop" object:nil];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.running = NO;
}

- (NSString *)timeFormattedStringForValue:(unsigned long)value {
    int msperhour = 3600;
    int mspermin = 60;
    
    int hrs = (int)value / msperhour;
    int mins = (value % msperhour) / mspermin;
    int secs = ((value % msperhour) % mspermin) ;
    
    NSString *formattedString = [NSString stringWithFormat:@"%02d%02d%02d", hrs, mins, secs];
    return formattedString;
}
@end
