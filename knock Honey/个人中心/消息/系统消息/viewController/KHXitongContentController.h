//
//  KHXitongContentController.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/30.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHBaseViewController.h"

@interface KHXitongContentController : KHBaseViewController
@property (nonatomic,copy) NSString *content;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
