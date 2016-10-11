//
//  SearchBar.m
//  LOL盒子
//
//  Created by imac on 15/11/1.
//  Copyright (c) 2015年 taoge. All rights reserved.
//

#import "SearchBar.h"

@implementation SearchBar


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.size = CGSizeMake(350, 30);
        self.font = [UIFont systemFontOfSize:15];
        self.placeholder = @"搜索感兴趣的产品";
        // 提前在Xcode上设置图片中间拉伸
        self.background = [UIImage imageWithStretchableName:@"searchbar_textfield_background"];
        
        // 通过init初始化的控件大多都没有尺寸
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
        // contentMode：default is UIViewContentModeScaleToFill，要设置为UIViewContentModeCenter：使图片居中，防止图片填充整个imageView
        searchIcon.contentMode = UIViewContentModeCenter;
        searchIcon.size = CGSizeMake(30, 30);
        self.tintColor = kDefaultColor;
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

+(instancetype)searchBar
{
    return [[self alloc] init];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
