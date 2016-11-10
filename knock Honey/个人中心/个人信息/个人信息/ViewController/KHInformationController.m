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
        _titles = @[@"头像",@"昵称",@"手机号码",@"ID",@"收货地址"];
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
//    if (indexPath.row == 2) {
//        cell.detailTextLabel.text = user.
//    }
    
    if (indexPath.row==3) {
        cell.detailTextLabel.text = user.userid;
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
    if (indexPath.row == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择操作" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
         UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
        UIAlertAction *action_camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
                [pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
                [pickerController setCameraDevice:UIImagePickerControllerCameraDeviceRear];
            } else {
                [pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            }
        }];
        UIAlertAction *action_photo = [UIAlertAction actionWithTitle:@"从手机相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }];
        pickerController.delegate = self;
        pickerController.allowsEditing = YES;
        [self presentViewController:pickerController animated:YES completion:nil];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        
        [alertController addAction:action_camera];
        [alertController addAction:action_photo];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
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
        [self hideBottomBarPush:phoneVC];
    }
    if (indexPath.row == 4) {
        KHAddressViewController *addresVC = [[KHAddressViewController alloc]init];
        [self hideBottomBarPush:addresVC];
    }
}


//上传头像
-(void)updatePotrait{
    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    _image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
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
