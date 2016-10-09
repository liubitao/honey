//
//  UIColor+YWcolor.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/6/29.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "UIColor+YWcolor.h"

@implementation UIColor (YWcolor)
+ (UIColor*)colorWithHexString:(NSString*)hex

{
    
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor grayColor];
    
    
    
    // strip 0X if it appears
    
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    
    
    if ([cString length] != 6) return [UIColor grayColor];
    
    
    
    // Separate into r, g, b substrings
    
    NSRange range;
    
    range.location = 0;
    
    range.length = 2;
    
    NSString *rString = [cString substringWithRange:range];
    
    
    
    range.location = 2;
    
    NSString *gString = [cString substringWithRange:range];
    
    
    
    range.location = 4;
    
    NSString *bString = [cString substringWithRange:range];
    
    
    
    // Scan values
    
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    
    
    return [UIColor colorWithRed:((float) r / 255.0f)
            
                           green:((float) g / 255.0f)
            
                            blue:((float) b / 255.0f)
            
                           alpha:1.0f];
    
}



+ (UIColor*)colorWithHexString:(NSString*)hex withAlpha:(CGFloat)alpha

{
    
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor grayColor];
    
    
    
    // strip 0X if it appears
    
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    
    
    if ([cString length] != 6) return [UIColor grayColor];
    
    
    
    // Separate into r, g, b substrings
    
    NSRange range;
    
    range.location = 0;
    
    range.length = 2;
    
    NSString *rString = [cString substringWithRange:range];
    
    
    
    range.location = 2;
    
    NSString *gString = [cString substringWithRange:range];
    
    
    
    range.location = 4;
    
    NSString *bString = [cString substringWithRange:range];
    
    
    
    // Scan values
    
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    
    
    return [UIColor colorWithRed:((float) r / 255.0f)
            
                           green:((float) g / 255.0f)
            
                            blue:((float) b / 255.0f)
            
                           alpha:alpha];
    
}

@end
