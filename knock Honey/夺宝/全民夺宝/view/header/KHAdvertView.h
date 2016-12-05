//
//  KHAdvertView.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/30.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHAdvertModel.h"
typedef void(^KHAdvertBlock)();
@interface KHAdvertView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic,copy)  KHAdvertBlock advertBlock;
@property (nonatomic,strong) KHAdvertModel *model;
+(instancetype)viewFromNiB;
@end
