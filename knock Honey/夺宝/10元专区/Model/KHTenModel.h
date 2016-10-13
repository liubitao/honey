//
//  KHTenModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/13.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHTenModel : NSObject

@property (nonatomic, copy) NSString *productImgUrl;

@property (nonatomic, copy) NSString *productName;

@property (nonatomic, copy) NSNumber *publishProgress;

@property (nonatomic, copy) NSNumber *totalAmount;

@property (nonatomic, copy) NSNumber *leftAmount;

@property (nonatomic, assign) BOOL isSelected;

@end
