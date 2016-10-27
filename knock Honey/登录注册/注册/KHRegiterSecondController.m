//
//  KHRegiterSecondController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/10/27.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHRegiterSecondController.h"

@interface KHRegiterSecondController ()
@property (weak, nonatomic) IBOutlet UILabel *userPhone;
@property (weak, nonatomic) IBOutlet UITextField *phoneCode;
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;


@end

@implementation KHRegiterSecondController

- (void)viewDidLoad {
    [super viewDidLoad];
    _submitButton.layer.cornerRadius = 5;
    _submitButton.layer.masksToBounds = YES;
    NSString *remindStr = @"距离获得新手礼包还有1步！";
    _remindLabel.attributedText = [Utils stringWith:remindStr font1:SYSTEM_FONT(14) color1:UIColorHex(51B2EA) font2:SYSTEM_FONT(14) color2:kDefaultColor range:NSMakeRange(10, 1)];

}
- (IBAction)downTime:(id)sender {
    [Utils timeDecrease:sender];
}
- (IBAction)submitCode:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
