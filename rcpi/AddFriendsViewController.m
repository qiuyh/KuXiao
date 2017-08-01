//
//  AddFriendsViewController.m
//  rcpi
//
//  Created by Dc on 15/11/19.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "SearchResultsTableViewCell.h"
#import "DetailViewController.h"

@interface AddFriendsViewController ()<UITextFieldDelegate>

@end

@implementation AddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
    self.pageSize = 10;
    self.pageNo = 1;
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(kScreen.width / 2 - 60, 10, 50, 40)];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:32.0 / 255.0 green:191.0 / 255.0 blue:184.0 / 255.0 alpha:1.0]];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"添加好友";
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = lable;
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"com_return"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBackClicket) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBtnItem;
    
    self.searchView = [[UIView alloc]init];
    self.searchView.center = CGPointMake(kScreen.width/2-1, 100);
    self.searchView.bounds = CGRectMake(0, 0, kScreen.width-20, 45);
    self.searchView.backgroundColor = [UIColor whiteColor];
    self.searchView.layer.cornerRadius = 5;
    self.searchView.layer.borderWidth = 0.5;
    self.searchView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.view addSubview:self.searchView];
    
    self.searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, kScreen.width-50, 30)];
    self.searchTextField.placeholder = @"账号/名字";
    self.searchTextField.textAlignment = 1;
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.delegate = self;
    [self.searchView addSubview:self.searchTextField];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(5, 13, 20, 20);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"msg_search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.searchView addSubview:searchBtn];
    
    self.accountLab = [[UILabel alloc]init];
    self.accountLab .center = CGPointMake(kScreen.width/2, CGRectGetMaxY(self.searchView.frame)+20);
    self.accountLab .bounds = CGRectMake(0, 0, 200, 30);
    self.accountLab .text = @"我的账号: xxx";
    self.accountLab .textAlignment = 1;
    self.accountLab .font = [UIFont systemFontOfSize:12];
    [self.view addSubview:self.accountLab];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"];
    [H doGet:[NSString stringWithFormat:@"http://imshs.dev.jxzy.com/get-usr-info?t=w&token=%@",token] json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if(!err) {
            self.accountLab.text = [NSString stringWithFormat:@"我的账号:%@",json[@"data"][@"alias"]];
        }
    }];
    
    self.tableView = [[UITableExtView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.accountLab.frame), kScreen.width, kScreen.height - CGRectGetMaxY(self.accountLab.frame))];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:footView];
    self.tableView.rowHeight = 70;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
}
-(void)goBackClicket{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)searchBtnClick {
    self.pageNo = 1;
    self.pageSize = 10;
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"];
    [self.view endEditing:YES];
    [H doGet:[NSString stringWithFormat:@"http://imshs.dev.jxzy.com/usr/search-usr?name=%@&token=%@",self.searchTextField.text,token] json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if(!err) {
             self.tableView.hidden = NO;
                self.array = json[@"data"][@"list"];
                [self.tableView reloadData];
            
            if(self.array.count == 0){
               UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"未查找到结果" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                  [alertController addAction:okAction];
                 [self presentViewController:alertController animated:YES completion:nil];
                self.tableView.hidden = YES;
            }
            
        } else {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"网络请求失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertview show];
        }
    }];
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SearchCell";
    SearchResultsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchResultsTableViewCell" owner:self options:nil] lastObject];
    }
    NSDictionary *dict = self.array[indexPath.row];
    if(self.array[indexPath.section - 1][@"users"][indexPath.row][@"img"]==nil){
        cell.headImgView.image = [UIImage imageNamed:@"com_man"];
    }else{
         cell.headImgView.url = dict[@"img"];
    }
    cell.nameLab.text = dict[@"name"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *vc = [[DetailViewController alloc]init];
    vc.nameStr = self.array[indexPath.row][@"name"];
    vc.imgUrlStr = self.array[indexPath.row][@"img"];
    vc.uuid = self.array[indexPath.row][@"uuid"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)onNextPage:(UITableExtView *)tableview {
     NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"];
    [H doGet:[NSString stringWithFormat:@"http://imshs.dev.jxzy.com/usr/search-usr?token=%@",token] args:@{@"name":self.searchTextField.text,@"pn":@(self.pageNo+1),@"ps":@(self.pageSize+10)} json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        NSArray *arr = json[@"data"][@"list"];
        if(arr.count != 0) {
            self.array = arr;
            self.pageNo = self.pageNo +1;
            self.pageSize = self.pageSize +10;
        }
        [self.tableView reloadData];
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.pageNo = 1;
    self.pageSize = 10;
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"];
    [self.view endEditing:YES];
    [H doGet:[NSString stringWithFormat:@"http://imshs.dev.jxzy.com/usr/search-usr?name=%@&token=%@",textField.text,token] json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if(!err) {
            self.tableView.hidden = NO;
            self.array = json[@"data"][@"list"];
            [self.tableView reloadData];
            
            if(self.array.count == 0){
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"未查找到结果" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
                self.tableView.hidden = YES;
            }
            
        } else {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"网络请求失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertview show];
        }
    }];
    return YES;
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
