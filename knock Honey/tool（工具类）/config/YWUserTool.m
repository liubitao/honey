//
//  YWUserTool.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/6.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWUserTool.h"
#import "YWUser.h"

#define YWAccountFileName [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"account.data"]

@implementation YWUserTool
//不能缺少 底层便利当前的类的所有属性，一个一个归档和接档  MJCodingImplementation
+ (void)saveAccount:(YWUser *)account{
    [NSKeyedArchiver archiveRootObject:account toFile:YWAccountFileName];
}

+ (YWUser *)account{
    YWUser *_account = [NSKeyedUnarchiver unarchiveObjectWithFile:YWAccountFileName];
    return _account;
}

+ (void)quit{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:YWAccountFileName];
    if (!blHave) {
        return ;
    }else {
       [fileManager removeItemAtPath:YWAccountFileName error:nil];
    }
}
@end
