//
//  KHHomeModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/11.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHHomeModel : NSObject

@property (nonatomic, strong) NSMutableArray *adImgUrls;

@property (nonatomic, copy) NSString *productImgUrl;

@property (nonatomic, copy) NSString *productName;

@property (nonatomic, copy) NSString *publishProgress;

@property (nonatomic, assign) BOOL isAdded;

@property (nonatomic, assign) CGFloat height;

@end
