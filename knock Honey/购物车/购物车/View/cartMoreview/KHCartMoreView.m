//
//  KHCartMoreView.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/12/9.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHCartMoreView.h"

@implementation KHCartMoreView
+ (instancetype)viewFromNIB {
    
    // 加载xib中的视图，其中xib文件名和本类类名必须一致
    
    // 这个xib文件的File's Owner必须为空
    
    // 这个xib文件必须只拥有一个视图，并且该视图的class为本类
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}

- (void)setModel:(KHCartMoreModel *)model{
    _model = model;
    [self.productPic sd_setImageWithURL:[NSURL URLWithString:_model.thumb] placeholderImage:IMAGE_NAMED(@"placeholder")];
    
    self.productTitle.text = _model.title;
    self.progressView.progress = [_model.jindu integerValue];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.delegate respondsToSelector:@selector(clickPush:)]) {
        [self.delegate clickPush:_model];
    }
}
@end
