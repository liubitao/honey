//
//  KHDistanceViewController.m
//  knock Honey
//
//  Created by 刘毕涛 on 2016/11/26.
//  Copyright © 2016年 liubitao. All rights reserved.
//

#import "KHDistanceViewController.h"
#import "KHDistanceModel.h"
#import "khDistanceCell.h"
#import "KHDistaceHeaderView.h"
#import <MJExtension.h>

@interface KHDistanceViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) KHDistaceHeaderView *headerView;

@end

@implementation KHDistanceViewController



- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, KscreenWidth, KscreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColorHex(#DCDCDC);
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColorHex(#F5F5F5);
    
    [self.view addSubview:self.tableView];
    [self getData];
    
    _headerView = [[KHDistaceHeaderView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 1) model:_model];
    self.tableView.tableHeaderView  = _headerView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"khDistanceCell" bundle:nil] forCellReuseIdentifier:@"khDistanceCell"];
}

- (void)getData{
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    NSString *appcode = WuliuMessage;
    NSString *host = @"http://jisukdcx.market.alicloudapi.com";
    NSString *path = @"/express/query";
    NSString *method = @"GET";
    NSString *querys = [NSString stringWithFormat:@"?number=%@&type=%@",_model.shipping.code,_model.shipping.type];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",  host,  path , querys];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url]  cachePolicy:1  timeoutInterval:600];
    request.HTTPMethod  =  method;
    [request addValue:  [NSString  stringWithFormat:@"APPCODE %@" ,  appcode]  forHTTPHeaderField:  @"Authorization"];
    NSURLSession *requestSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [requestSession dataTaskWithRequest:request
                                                   completionHandler:^(NSData * _Nullable body , NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                       if (error) {
                                                           return ;
                                                       }
                                                       NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:body
                                        options:NSJSONReadingMutableContainers
                                           error:nil];
                                                       self.dataArray = [KHDistanceModel mj_objectArrayWithKeyValuesArray:dic[@"result"][@"list"]];
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           [MBProgressHUD hideHUDForView:self.view];
                                                           [_headerView resetStatus:dic[@"result"][@"deliverystatus"] ];
                                                           [self.tableView reloadData];
                                                       });
                                                   }];
    [task resume];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    khDistanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"khDistanceCell" forIndexPath:indexPath];

    if (indexPath.row == 0) {
        cell.topView.hidden = YES;
        cell.messageLabel.textColor = UIColorHex(#2B9FFA);
        cell.timeLabel.textColor = UIColorHex(#2B9FFA);
        cell.centerImage.image = IMAGE_NAMED(@"firstPoint");
    }else{
        cell.topView.hidden = NO;
        cell.messageLabel.textColor = [UIColor blackColor];
        cell.timeLabel.textColor = [UIColor blackColor];
        cell.centerImage.image = IMAGE_NAMED(@"noFirstPoint");
    }
    if (indexPath.row == self.dataArray.count -1) {
        cell.lineCell.hidden = YES;
    }else{
          cell.lineCell.hidden = NO;
    }
    [cell setModel:self.dataArray[indexPath.row]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    KHDistanceModel *model = self.dataArray[indexPath.row];
    CGRect detailSize = [model.status boundingRectWithSize:CGSizeMake(KscreenWidth - 80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}context:nil];
    return detailSize.size.height +50;
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
