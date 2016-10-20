//
//  KHBaseViewController.h
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/10.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KHBaseViewController : UIViewController
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIButton *leftBtn;

/**导航栏LeftItem文字
 */
- (void)setLeftItemTitle:(NSString *)title
                  action:(SEL)action;

/**导航栏LeftItem图片
 */
- (void)setLeftImageNamed:(NSString *)name
                   action:(SEL)action;



/**导航栏RightItem文字
 */
- (void)setRightItemTitle:(NSString *)title
                   action:(SEL)action;

- (void)setRightItemTitle:(NSString *)title
               titleColor:(UIColor *)color
                   action:(SEL)action;

/**导航栏RightItem图片
 */
- (void)setRightImageNamed:(NSString *)name
                    action:(SEL)action;


/**设置titleView图片
 */
- (void)setTitleView:(NSString *)imageName;


/**设置返回按钮
 */
- (void)setBackItem;
- (void)setBackItemAction:(SEL)sel;
- (void)setBackItem:(NSString *)title
             action:(SEL)sel;

/**push不隐藏tabbar
 */
- (void)pushController:(KHBaseViewController *)controller;
/**push隐藏tabbar
 */
- (void)hideBottomBarPush:(KHBaseViewController *)controller;

/**设置导航栏
 */
- (void)setNavigationBarBackgroundImage:(UIImage *)image
                              tintColor:(UIColor *)tintColor
                              textColor:(UIColor *)textColor
                         statusBarStyle:(UIStatusBarStyle)style;
@end
