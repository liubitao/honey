//
//  KHEditAddressViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/4.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHEditAddressViewController.h"
#import "LocationPickerView.h"

@interface KHEditAddressViewController ()
@property (weak, nonatomic) IBOutlet UITextField *takeName;
@property (weak, nonatomic) IBOutlet UITextField *takePhone;
@property (weak, nonatomic) IBOutlet UITextField *takePhone2;


@property (weak, nonatomic) IBOutlet UILabel *addressFirst;
@property (weak, nonatomic) IBOutlet UITextField *addressSecone;

@property (weak, nonatomic) IBOutlet UISwitch *moren;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic,strong) LocationPickerView *pickerView;

@end

@implementation KHEditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _saveButton.layer.cornerRadius = 5;
    _saveButton.layer.masksToBounds = YES;
    
    self.title = @"添加地址";
    if (_editType == KHAddressEdit) {
        self.title = @"编辑地址";
        [self setRightItemTitle:@"删除" action:@selector(delete)];
        _takeName.text = _model.consignee;
        _takePhone.text = _model.mobile;
        _addressSecone.text = _model.address;
        [_moren setOn:[_model.isdefault isEqualToString:@"1"] ? YES:NO ];
    }
}

//删除
- (void)delete{
    
}

- (IBAction)chooseAddress:(id)sender {
    [self.view endEditing:YES];
        if (!_pickerView) {
            _pickerView = [[LocationPickerView alloc]initWithLoadLocal];
        }
    __weak typeof(self) weakSelf = self;
        [_pickerView show:^(LocationModel *provinceModel,
                            CityModel *cityModel,
                            DistrictModel *districtModel) {
            NSString *location = [NSString stringWithFormat:@"%@%@%@",provinceModel.locationName,cityModel.CityName,districtModel.DistrictName];
            weakSelf.addressFirst.text = location;
        }];
}
- (IBAction)chooseMoren:(id)sender {
    _moren.selected = !_moren.selected;
}
- (IBAction)saveAddress:(id)sender {
    [self.view endEditing:YES];
    if ([Utils isNull:_takeName]||[Utils isNull:_addressFirst.text]||[Utils isNull:_addressSecone.text]) {
        [MBProgressHUD showError:@"请完成你的资料"];
        return;
    }
    if (![_takePhone.text isEqualToString:_takePhone2.text]) {
        [MBProgressHUD showError:@"联系电话不一致"];
        return;
    }
    if (![Utils validateMobile:_takePhone.text]||![Utils validateMobile:_takePhone2.text]) {
        [MBProgressHUD showError:@"电话格式不对"];
        return;
    }
    NSMutableDictionary *parameter = [Utils parameter];
    parameter[@"userid"] = [YWUserTool account].userid;
    parameter[@"act"] = _editType == KHAddressEdit ? @"edit":@"add";
    parameter[@"addressid"] = _model.ID;
    parameter[@"type"] = @1;
    parameter[@"consignee"] = _takeName.text;
    parameter[@"mobile"] = _takePhone.text;
    parameter[@"address"] = [NSString stringWithFormat:@"%@%@",_addressFirst.text,_addressSecone.text];
    parameter[@"isdefault"] = _moren.selected ? @1:@0;
    
    [YWHttptool Post:PortAddress_handle parameters:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"isError"] integerValue]){
            [MBProgressHUD showError:@"保存失败"];
            return ;
        }
        [UIAlertController showAlertViewWithTitle:nil Message:@"保存成功" BtnTitles:@[@"确定"] ClickBtn:^(NSInteger index) {
            if (self.block) {
                self.block();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSError *error){
        [MBProgressHUD showError:@"保存失败"];
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
