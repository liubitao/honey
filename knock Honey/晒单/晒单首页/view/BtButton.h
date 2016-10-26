//
//  BtButton.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/10/26.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BtButton : UIButton
- (void)setImage:(UIImage *)image
           title:(NSString *)title
        forState:(UIControlState)state;
@end
