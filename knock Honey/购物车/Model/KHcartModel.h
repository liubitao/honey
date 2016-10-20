//
//  KHcartModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/20.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHcartModel : NSObject

@property (nonatomic, assign) BOOL isChecked;

@property (nonatomic, copy) NSString *imgUrl;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *totalAmount;

@property (nonatomic, copy) NSString *leftAmount;

@property (nonatomic, copy) NSNumber *selectCount;

@property (nonatomic, copy) NSNumber *unitCost;
@end
