//
//  AppDelegate.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/9.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) NSInteger value;

+ (AppDelegate *)getAppDelegate;
@end

