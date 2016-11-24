//
//  Utils.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/5.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MBProgressHUD;

@interface Utils : NSObject


//检查银行卡号
+ (BOOL)checkCardNo:(NSString*) cardNo;

//倒计时
+(void)timeDecrease:(UIButton *)button;


//判断对象是不是空的
+(BOOL)isNull:(id)object;

//计算字符串的长度
+ (CGFloat)labelWidth:(NSString *)text font:(NSInteger)font;
//时间戳转化为时间
+ (NSString*)timeWith:(NSString*)time;

+ (NSMutableAttributedString *)stringWith:(NSString *)string font1:(UIFont*)font1 color1:(UIColor *)color1 font2:(UIFont*)font2 color2:(UIColor *)color2 range:(NSRange)range;

+ (NSMutableDictionary *)parameter;


/**手机号码
 */
+ (BOOL)validateMobile:(NSString *)mobile;

/**密码
 */
+ (BOOL)validatePassword:(NSString *)passWord;

/**验证码
 */
+ (BOOL)validateVerifyCode:(NSString *)verifyCode;

/**昵称
 */
+ (BOOL)validateNickname:(NSString *)nickname;

//获取图片的格式
+ (NSString *)typeForImageData:(NSData *)data;

+(void)POST:(NSString *)urlstr paramter:(NSDictionary *)parameter completionHandler:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

+(void)GET:(NSString *)urlstr paramter:(NSDictionary *)parameter completionHandler:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

@end
