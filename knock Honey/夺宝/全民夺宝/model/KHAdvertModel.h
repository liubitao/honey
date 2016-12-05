//
//  KHAdvertModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/30.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHAdvertModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *link;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *prom_end;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,copy) NSString *timeStr;

+ (instancetype)kh_objectWithKeyValues:(NSDictionary*)dict;
- (void)stop;
@end
