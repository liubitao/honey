//
//  KHheard2View.m
//  knock Honey
//
//  Created by 刘毕涛 on 16/10/12.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHheard2View.h"

@interface KHheard2View ()
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;


@end
@implementation KHheard2View

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)setCellBlcok:(heard2ViewBlcok)blcok{
    _blcok = blcok;
}

- (IBAction)touchMore:(id)sender {
    if (self.blcok) {
        self.blcok();
        
    }
}

@end
