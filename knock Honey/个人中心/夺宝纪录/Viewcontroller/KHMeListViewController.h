//
//  KHMeListViewController.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/14.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHBaseViewController.h"


@interface KHMeListViewController : KHBaseViewController
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *userID;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) BOOL otherType;
@end
