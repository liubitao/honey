//
//  HomeFooter.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/11.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "HomeFooter.h"

#define  HomeFooterHeight

@implementation HomeFooter


- (instancetype)init{
    return  [self initWithFrame:CGRectMake(0, 0, KscreenWidth, 10)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 10)];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
    }
    return self;
}

@end
