//
//  KHSearchTableViewCell.h
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/16.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHTenModel.h"
#import "TSProgressView.h"

@protocol KHSearchCellDelegate;



@interface KHSearchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UIImageView *productPic;
@property (weak, nonatomic) IBOutlet TSProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *zongrenshu;
@property (weak, nonatomic) IBOutlet UILabel *shengyurenshu;
@property (weak, nonatomic) IBOutlet UIButton *partInBtn;

@property (nonatomic,strong) KHTenModel *model;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,assign) id <KHSearchCellDelegate>delegate;

- (void)setModel:(KHTenModel *)model;
@end

@protocol KHSearchCellDelegate <NSObject>

- (void)clickAddListButtonAtCell:(KHSearchTableViewCell *)cell;

@end


