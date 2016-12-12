//
//  KHCartMoreView.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/12/9.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSProgressView.h"
#import "KHCartMoreModel.h"

@protocol KHCartMoreDelegate <NSObject>

- (void)clickPush:(KHCartMoreModel *)model;
@end

@interface KHCartMoreView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *productPic;
@property (weak, nonatomic) IBOutlet UILabel *productTitle;
@property (weak, nonatomic) IBOutlet TSProgressView *progressView;

@property (nonatomic,strong) KHCartMoreModel *model;
@property (nonatomic,assign) id<KHCartMoreDelegate> delegate;
+ (instancetype)viewFromNIB;

- (void)setModel:(KHCartMoreModel *)model;

@end
