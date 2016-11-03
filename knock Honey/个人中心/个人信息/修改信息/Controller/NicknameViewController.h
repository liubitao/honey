//
//  NicknameViewController.h
//  WinTreasure
//
//  Created by Apple on 16/6/22.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import "KHBaseViewController.h"

typedef void(^NicknameModifyBlock)(NSString *name);

@interface NicknameViewController : KHBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *nameField;

@property (copy, nonatomic) NicknameModifyBlock nicknameBlock;

@end
