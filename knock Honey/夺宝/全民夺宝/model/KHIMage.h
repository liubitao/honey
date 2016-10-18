//
//  KHIMage.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/18.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHIMage : NSObject

@property (nonatomic,copy) NSString *img;

@property (nonatomic,copy) NSString *link;

+ (NSMutableArray*)kh_objectWithKeyValuesArray:(NSArray *)array;
@end
