//
//  KHAdvertView.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/30.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHAdvertView.h"

@implementation KHAdvertView

+(instancetype)viewFromNiB{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}

#pragma mark - 通知中心
- (void)registerNSNotificationCenter{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEvent)
                                                 name:@"advertViewDown"
                                               object:nil];
}

- (void)notificationCenterEvent{
    for (int i = 0; i<6; i++) {
        UILabel *label =  [self viewWithTag:i+1];
        label.text = [_model.timeStr substringWithRange:NSMakeRange(i, 1)];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
     [self registerNSNotificationCenter];
    // 视图内容布局
    self.height = 45;
    self.backgroundColor = [UIColor whiteColor];
    self.nameLabel.layer.cornerRadius = 5;
    self.nameLabel.layer.masksToBounds = YES;
}

- (void)setModel:(KHAdvertModel *)model{
    _model = model;
    _titleLabel.text = model.title;
    _nameLabel.text = model.name;
}

- (void)removeNSNotificationCenter{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.advertBlock) {
        self.advertBlock();
    }
}

-(void)dealloc{
    [self removeNSNotificationCenter];
}

@end
