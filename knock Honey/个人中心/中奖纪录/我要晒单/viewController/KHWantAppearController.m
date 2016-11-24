//
//  KHWantAppearController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/24.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHWantAppearController.h"
#import "KHWantButton.h"

@interface KHWantAppearController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *themeText;
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (weak, nonatomic) IBOutlet UIButton *image1;
@property (weak, nonatomic) IBOutlet UIButton *image2;
@property (weak, nonatomic) IBOutlet UIButton *image3;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productQishu;
@property (weak, nonatomic) IBOutlet UILabel *productNum;
@property (weak, nonatomic) IBOutlet UILabel *productCode;
@property (weak, nonatomic) IBOutlet UILabel *productTime;
@property (weak, nonatomic) IBOutlet UIButton *subitemBtn;
@property (weak, nonatomic) IBOutlet UIButton *delect1;
@property (weak, nonatomic) IBOutlet UIButton *delect2;
@property (weak, nonatomic) IBOutlet UIButton *delect3;
@property (nonatomic,strong) UIButton *currentImage;
@end

@implementation KHWantAppearController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要晒单";
    _subitemBtn.layer.cornerRadius = 5;
    _subitemBtn.layer.masksToBounds = YES;
    
    _image2.hidden = YES;
    _image3.hidden = YES;
    
    _delect1.hidden = YES;
    _delect2.hidden = YES;
    _delect3.hidden = YES;
    
    _contentText.delegate = self;
    [self cofData];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text.length == 1 && range.length == 1&&range.location ==0) {
        textView.text = @"获奖感言，不少于30个字";
        textView.textColor = UIColorHex(C9C9CD);
        return NO;
    }
    if ([textView.text isEqualToString:@"获奖感言，不少于30个字"]) {
        textView.text = text;
        textView.textColor = [UIColor blackColor];
        return NO;
    }
    return YES;
}


- (void)cofData{
    _productName.attributedText = [Utils stringWith:[NSString stringWithFormat:@"获奖奖品:%@",_model.title] font1:SYSTEM_FONT(13) color1:UIColorHex(#5C5C5C) font2:SYSTEM_FONT(13) color2:UIColorHex(#67AEF6) range:NSMakeRange(5, _model.title.length)];
    _productQishu.text = [NSString stringWithFormat:@"商品期数:%@",_model.qishu];
    _productNum.attributedText = [Utils stringWith:[NSString stringWithFormat:@"本期参与:%@人次",_model.buynum] font1:SYSTEM_FONT(13) color1:UIColorHex(#5C5C5C) font2:SYSTEM_FONT(13) color2:kDefaultColor   range:NSMakeRange(5, _model.buynum.length)];
    _productCode.attributedText = [Utils stringWith:[NSString stringWithFormat:@"幸运号码:%@",_model.wincode] font1:SYSTEM_FONT(13) color1:UIColorHex(#5C5C5C) font2:SYSTEM_FONT(13) color2:kDefaultColor range:NSMakeRange(5, _model.wincode.length)];
    _productTime.text = [NSString stringWithFormat:@"揭晓时间:%@",[Utils timeWith:_model.addtime]];
}
- (IBAction)pushPic:(UIButton*)sender {
    self.currentImage = sender;
    [UIAlertController showActionSheetWithTitle:nil Message:nil cancelBtnTitle:@"取消" OtherBtnTitles:@[@"拍照",@"相册中选择"] ClickBtn:^(NSInteger index) {
        if (index == 0 ) {
            return ;
        }
            UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
        if (index == 1 ) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
                [pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
                [pickerController setCameraDevice:UIImagePickerControllerCameraDeviceRear];
            } else {
                [pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            }
        }else{
             pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        pickerController.delegate = self;
        pickerController.allowsEditing = YES;
        [self presentViewController:pickerController animated:YES completion:nil];
    }];
   
    

}

- (void)resetImage:(UIImage *)image{
    UIView *view = [self.currentImage superview];
    [self.currentImage setImage:image forState:UIControlStateNormal];
    [view viewWithTag:self.currentImage.tag*10].hidden = NO;
    if (self.currentImage.tag != 3) {
        [view viewWithTag:self.currentImage.tag +1].hidden = NO;
    }
}
- (IBAction)delect:(UIButton *)sender {
    UIView *view = [self.currentImage superview];
    sender.hidden = YES;
    UIButton *btn = [view viewWithTag:sender.tag/10];
    [btn setImage:IMAGE_NAMED(@"addImage") forState:UIControlStateNormal];
}
- (IBAction)subtim:(id)sender{
    if (_themeText.text.length <=6) {
        [UIAlertController showAlertViewWithTitle:@"提示" Message:@"晒单主题不能少于6个字" BtnTitles:@[@"知道了"] ClickBtn:nil];
        return;
    }
    if (_contentText.text.length <=30) {
        [UIAlertController showAlertViewWithTitle:@"提示" Message:@"获奖感言不能少于30个字" BtnTitles:@[@"知道了"] ClickBtn:nil];
        return;
    }
    if (_delect1.hidden == YES &&_delect2.hidden ==YES &&_delect3.hidden == YES) {
        [UIAlertController showAlertViewWithTitle:@"提示" Message:@"至少要添加一张晒单图片" BtnTitles:@[@"知道了"] ClickBtn:nil];
        return;
    }
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    parameter[@"goodsid"] = _model.goodsid;
    parameter[@"lotteryid"] = _model.ID;
    parameter[@"qishu"] = _model.qishu;
    parameter[@"title"] = _themeText.text;
    parameter[@"content"] = _contentText.text;

    NSMutableArray *array = [NSMutableArray array];
    if (_delect1.hidden == NO) {
        UIImage *image = [_image1 imageForState:UIControlStateNormal];
        NSMutableDictionary *dict =[NSMutableDictionary dictionary];
        dict[@"type"] = [Utils typeForImageData: UIImageJPEGRepresentation(image, 0.5)];
        NSData *data =  UIImageJPEGRepresentation(image, 0.5);
        NSString *str =  [data base64EncodedStringWithOptions:0];
        dict[@"img"] = str;
        [array addObject:dict];
    }
    if (_delect2.hidden == NO) {
        UIImage *image = [_image2 imageForState:UIControlStateNormal];
        NSMutableDictionary *dict =[NSMutableDictionary dictionary];
        dict[@"type"] = [Utils typeForImageData: UIImageJPEGRepresentation(image, 0.5)];
        NSData *data =  UIImageJPEGRepresentation(image, 0.5);
        NSString *str =  [data base64EncodedStringWithOptions:0];
        dict[@"img"] = str;
        [array addObject:dict];
    }
    if (_delect3.hidden == NO) {
        UIImage *image = [_image3 imageForState:UIControlStateNormal];
        NSMutableDictionary *dict =[NSMutableDictionary dictionary];
        dict[@"type"] = [Utils typeForImageData: UIImageJPEGRepresentation(image, 0.5)];
        NSData *data =  UIImageJPEGRepresentation(image, 0.5);
        NSString *str =  [data base64EncodedStringWithOptions:0];
        dict[@"img"] = str;
        [array addObject:dict];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    parameter[@"imgs"] = jsonString;
    [YWHttptool Post:PortAdd_comment parameters:parameter success:^(id responseObject) {
        if ([responseObject[@"result"][@"status"] integerValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showSuccess:@"晒单成功"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"晒单失败"];
    }];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:NO completion:^{
        [self resetImage:info[UIImagePickerControllerEditedImage]];
    }];
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
