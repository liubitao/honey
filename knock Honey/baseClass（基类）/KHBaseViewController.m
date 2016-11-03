//
//  KHBaseViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/10.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHBaseViewController.h"

@interface KHBaseViewController ()

@end

@implementation KHBaseViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


/**导航栏LeftItem文字
 */
- (void)setLeftItemTitle:(NSString *)title action:(SEL)action {
    NSDictionary *attributes = @{NSFontAttributeName: SYSTEM_FONT(15)};
    CGSize size = [title sizeWithAttributes:attributes];
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(0, 0, size.width <= 10 ? 70 : size.width + 10, 44);
    _leftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    _leftBtn.titleLabel.font = SYSTEM_FONT(15);
    [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_leftBtn setTitle:title forState:UIControlStateNormal];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -5;
    
    [_leftBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_leftBtn];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, backItem];
    
}

/**导航栏LeftItem图片
 */
- (void)setLeftImageNamed:(NSString *)name action:(SEL)action {
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(0, 0, 24, 24);
    UIImage *image = [UIImage imageNamed:name];
    [_leftBtn setImage:image forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_leftBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

//设置右边按钮的文字
- (void)setRightItemTitle:(NSString *)title action:(SEL)action {
    [self setRightItemTitle:title titleColor:[UIColor whiteColor] action:action];
}

/**导航栏RightItem图片
 */
- (void)setRightItemTitle:(NSString *)title titleColor:(UIColor *)color action:(SEL)action {
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSDictionary *attributes = @{NSFontAttributeName: SYSTEM_FONT(15)};
    CGSize size = [title sizeWithAttributes:attributes];
    //! 这里需要根据内容大小来调整宽度
    _rightBtn.frame = CGRectMake(0, 0, size.width <= 10 ? 70 : size.width + 10, 44);
    [_rightBtn setTitleColor:color forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[color colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [_rightBtn setTitle:title forState:UIControlStateNormal];
    _rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    _rightBtn.titleLabel.font = SYSTEM_FONT(15);
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -5;
    
    [_rightBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, backItem];
}

- (void)setRightImageNamed:(NSString *)name action:(SEL)action {
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image2=  [UIImage imageNamed:name];
    _rightBtn.frame =CGRectMake(0, 0, 50, 44);
    _rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 18, 0, -10);
    [_rightBtn setImage:image2 forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightBtn];
}

- (void)setTitleView:(NSString *)imageName {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 40.0f)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *image = IMAGE_NAMED(imageName);
    imageView.image = image;
    self.navigationItem.titleView = imageView;
}

- (void)setBadgeValue:(NSInteger)value atIndex:(NSInteger)index {
    [self.tabBarController.tabBar setBadgeValue:value AtIndex:index];
}

- (void)setItemBadge:(NSInteger)value {
    if (value==0) {
        _badge.hidden = YES;
        return;
    }
    _badge.hidden = NO;
    if (value>=99) {
        value = 99;
    }
    [_rightBtn addSubview:self.badge];
    _badge.origin = CGPointMake(ceilf(0.85 * _rightBtn.width), ceilf(0.1*_rightBtn.height));
    _badge.hidden = NO;
    _badge.text = [NSString stringWithFormat:@"%@",@(value)];
}

- (void)setBackItem {
    [self setBackItemAction:nil];
}

- (void)setBackItemAction:(SEL)sel {
    [self setBackItem:@"返回" action:sel];
    
}

- (void)setBackItem:(NSString *)title action:(SEL)sel {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:sel];
    self.navigationItem.backBarButtonItem = backItem;
}


- (void)pushController:(UIViewController *)controller {
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)hideBottomBarPush:(UIViewController *)controller {
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)setNavigationBarBackgroundImage:(UIImage *)image
                              tintColor:(UIColor *)tintColor
                              textColor:(UIColor *)textColor
                         statusBarStyle:(UIStatusBarStyle)style {
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarTintColor:tintColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:textColor,NSFontAttributeName:SYSTEM_FONT(18)};
    [UIApplication sharedApplication].statusBarStyle = style;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
