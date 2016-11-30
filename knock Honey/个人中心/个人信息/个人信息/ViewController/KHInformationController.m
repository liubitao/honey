//
//  KHInformationController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/3.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHInformationController.h"
#import "KHInformationCell.h"
#import "NicknameViewController.h"
#import "KHPhoneViewController.h"
#import "KHAddressViewController.h"


@interface KHInformationController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray    *titles;

@property (nonatomic,strong) UIImage *image;
@end

@implementation KHInformationController
- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"头像",@"昵称",@"手机号码",@"推荐ID",@"收货地址"];
    }
    return _titles;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, KscreenWidth, KscreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 30)];
    label.text = @"云网夺宝不会将用户个人资料作其他目的使用";
    label.font = [UIFont systemFontOfSize:11];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColorHex(999999);
    self.tableView.tableFooterView = label;
    [self.tableView registerNib:NIB_NAMED(@"KHPersonCell") forCellReuseIdentifier:@"personCell"];
}
#pragma mark - Datasource Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWUser *user = [YWUserTool account];
    if (indexPath.row == 0) {
        KHInformationCell *cell = [KHInformationCell cellWithTableView:tableView];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:user.img] placeholderImage:IMAGE_NAMED(@"kongren")];
        return cell;
    }
    ProfileDetailCell *cell = [ProfileDetailCell cellWithTableView:tableView];
    cell.textLabel.text = self.titles[indexPath.row];
    if (indexPath.row == 1) {
        cell.detailTextLabel.text = user.username;
    }
    if (indexPath.row == 2) {
        if ([user.mobile isEqualToString:@"0"]) {
            cell.detailTextLabel.text = @"请绑定电话号码";
        }else{
            cell.detailTextLabel.text = user.mobile;
        }
    }
    if (indexPath.row==3) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%zi",user.userid.integerValue +100000];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 85;
    }else{
        return 45;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0){
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
    if (indexPath.row == 1){
        NicknameViewController *nickVC = [[NicknameViewController alloc]init];
        nickVC.nicknameBlock = ^(NSString *name) {
            ProfileDetailCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.detailTextLabel.text = name;
        };
        [self hideBottomBarPush:nickVC];
        
    }
    if (indexPath.row == 2) {
        KHPhoneViewController *phoneVC = [[KHPhoneViewController alloc]init];
        phoneVC.phoneBlock = ^(NSString *phone) {
            ProfileDetailCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.detailTextLabel.text = phone;
        };
        [self hideBottomBarPush:phoneVC];
    }
    if (indexPath.row == 4) {
        KHAddressViewController *addresVC = [[KHAddressViewController alloc]init];
        [self hideBottomBarPush:addresVC];
    }
}


//上传头像
-(void)updatePotrait{
    NSMutableDictionary *parameter = [Utils parameter];
    NSData *data =  UIImageJPEGRepresentation(_image, 0.7);
    NSString *str1 =  [data base64EncodedStringWithOptions:0];
    parameter[@"pic"] = str1;
    parameter[@"userid"] = [YWUserTool account].userid;
    parameter[@"type"] = [Utils typeForImageData:data];
   [YWHttptool Post:PortChange_pic parameters:parameter success:^(id responseObject) {
       if ([responseObject[@"result"][@"status"] integerValue] == 1) {
           YWUser *user = [YWUserTool account];
           user.img = responseObject[@"result"][@"img"];
           [YWUserTool saveAccount:user];
           NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
           KHInformationCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
           cell.headImage.image = _image;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"freshenPerson" object:nil];
           [MBProgressHUD showSuccess:@"修改成功"];
       }
   } failure:^(NSError *error) {
       [MBProgressHUD showError:@"修改失败"];
   }];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    _image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:NO completion:^{
        [self updatePotrait];
    }];
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
