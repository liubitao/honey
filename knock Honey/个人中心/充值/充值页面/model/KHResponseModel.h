//
//  KHResponseModel.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/21.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHResponseModel : NSObject
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *msg;
@property (nonatomic,copy) NSString *app_id;
@property (nonatomic,copy) NSString *out_trade_no;
@property (nonatomic,copy) NSString *trade_no;
@property (nonatomic,copy) NSString *total_amount;
@property (nonatomic,copy) NSString *seller_id;
@property (nonatomic,copy) NSString *charset;
@property (nonatomic,copy) NSString *timestamp;
@end
