//
//  KHProductModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/12.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHProductModel : NSObject

//图片组
@property (nonatomic,strong) NSArray *images;

//奖品名
@property (nonatomic,copy) NSString *productName;

//商品期数
@property (nonatomic, copy) NSNumber *countTime;



@end
