//
//  KHMyAppearViewController.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/10.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHBaseViewController.h"

@interface KHMyAppearViewController : KHBaseViewController
@property (nonatomic,copy) NSString *userID;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) BOOL otherType;
@end
