//
//  Utils.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/5.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "Utils.h"
#import <MBProgressHUD.h>


@implementation Utils




//检测手机号码
+ (BOOL)checkTelNumber:(NSString *) telNumber
{
    NSString *pattern = @"^1+[3578]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
    
}

//验证银行卡号
+ (BOOL) checkCardNo:(NSString*) cardNo{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }        allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}

+(void)timeDecrease:(UIButton *)button{
    __block int timeout=60; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [button setTitle:@"发送验证码" forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [button setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                button .userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
    
}




+(BOOL)isNull:(id)object{
    if ([object isEqual:[NSNull null]]) {
        return YES;
    }else if([object isKindOfClass:[NSNull class]]){
        return YES;
    }else if (object == nil){
        return YES;
    }else if([object isKindOfClass:[NSArray class]]){
        NSArray *array = (NSArray*)object;
        if (array.count == 0) {
            return YES;
        }
        
    }else if ([object isKindOfClass:[NSString class]]){
        NSString *str = (NSString *)object;
        if (str.length == 0) {
            return YES;
        }
    }
    return NO;
}

+ (CGFloat)labelWidth:(NSString *)text font:(NSInteger)font{
    
    CGRect detailSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}context:nil];
    
    return detailSize.size.width;
}

+ (NSString*)timeWith:(NSString*)timeStr{
    NSTimeInterval time=[timeStr doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate: detaildate];
}

+ (NSMutableAttributedString *)stringWith:(NSString *)string font1:(UIFont*)font1 color1:(UIColor *)color1 font2:(UIFont*)font2 color2:(UIColor *)color2 range:(NSRange)range{
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc]initWithString:string  attributes:@{NSFontAttributeName:font1,
                                                                                                            NSForegroundColorAttributeName:color1}];
    [string1 addAttribute:NSForegroundColorAttributeName value:color2 range:range];
    [string1 addAttribute:NSFontAttributeName value:font2 range:range];
    return string1;
}

+ (NSMutableDictionary *)parameter{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"mKey"] = [[NSString stringWithFormat:@"%@%@",[mKey MD5Digest],sKey]MD5Digest];
    return parameter;
}

//手机号
+ (BOOL) validateMobile:(NSString *)mobile {
    NSString *phoneRegex =@"^1\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//密码
+ (BOOL)validatePassword:(NSString *)passWord {
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}
//验证码
+ (BOOL)validateVerifyCode:(NSString *)verifyCode {
    BOOL flag;
    if (verifyCode.length != 4) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{4})";
    NSPredicate *verifyCodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [verifyCodePredicate evaluateWithObject:verifyCode];
}

//昵称 最长不得超过7个汉字，或20个字节(数字，字母和下划线)正则表达式
+ (BOOL) validateNickname:(NSString *)nickname {
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{1,7}$|^[\\dA-Za-z_]{4,20}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}

+(void)POST:(NSString *)urlstr paramter:(NSDictionary *)parameter completionHandler:(void(^)(id))success failure:(void(^)(NSError *))failure{
    
    NSURLSession *session = [NSURLSession sharedSession];
    //转化为URL
    NSURL *baseURL = [NSURL URLWithString:urlstr];
    //根据 baseURL 创建网络请求对象
    NSMutableURLRequest *requset = [NSMutableURLRequest requestWithURL:baseURL];
    //设置参数：1.POST 2.参数体（body）
    [requset setHTTPMethod:@"POST"];
    
    NSString *bodyString = [self stringWithDictiongary:parameter];
    
    NSData *badyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    //设置 body（POST参数）
    [requset setHTTPBody:badyData];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:requset completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (failure) {
                    failure(error);
                }
            }
            else{
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (success) {
                    success(dict);
                }
            }
        });
        
    }];
    [task resume];
    
}

+(void)GET:(NSString *)urlstr paramter:(NSDictionary *)parameter completionHandler:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *act1 = [self stringWithDictiongary:parameter];
    urlstr = [NSString stringWithFormat:@"%@?%@",urlstr,act1];
    //转化为URL
    NSURL *baseURL = [NSURL URLWithString:urlstr];
    //根据 baseURL 创建网络请求对象
    NSMutableURLRequest *requset = [NSMutableURLRequest requestWithURL:baseURL];
    //设置参数：1.POST 2.参数体（body）
    [requset setHTTPMethod:@"GET"];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:requset completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (failure) {
                    failure(error);
                }
            }
            else{
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (success) {
                    success(dict);
                }
            }
        });
        
    }];
    [task resume];
}

+(NSString *)stringWithDictiongary:(NSDictionary *)dictionary{
    //把字典转化为可以网络请求的字符串
    NSArray *keys = [dictionary allKeys];
    NSArray *values = [dictionary allValues];
    NSString *str;
    for (int i= 0; i<keys.count; i++) {
        if (i == 0) {
            str = [NSString stringWithFormat:@"%@=%@",keys[i],values[i]];
        }
        else{
            str = [NSString stringWithFormat:@"%@&%@=%@",str,keys[i],values[i]];
        }
    }
    return str;
}


@end
