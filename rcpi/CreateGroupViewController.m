//
//  CreateGroupViewController.m
//  rcpi
//
//  Created by Dc on 15/11/28.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "CreateGroupViewController.h"
#import "SearchResultsTableViewCell.h"
#import "LoginViewController.h"

@interface CreateGroupViewController ()

@end

@implementation CreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameArr = [NSMutableArray array];
    self.imgArr = [NSMutableArray array];
    self.uidArr = [NSMutableArray array];
    self.idArr = [NSMutableArray array];
    // Do any additional setup after loading the view.
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen.width, kScreen.height)];
    //self.scrollView.contentSize = CGSizeMake(kScreen.width, 1000);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    self.tableView = [[UITableExtView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    [self.scrollView addSubview:self.tableView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    titleLabel.center=[UIScreen mainScreen].bounds.origin;
    titleLabel.text=@"创建群组";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"com_return"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBackClicket) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBtnItem;
    
    self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    [self.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"];
    [H doGet:[NSString stringWithFormat:@"http://imshs.dev.jxzy.com/get-usr-info?t=w&token=%@",token ]json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if(!err) {
            NSArray *arr = json[@"data"][@"friendGrp"];
            if([json[@"code"] integerValue]==1) {
                LoginViewController*vc =[[LoginViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if(!self.array) {
                self.array = arr;
                [self.tableView reloadData];
                NSLog(@"%@",self.array);
                float height = 0;
                for(int i =0;i<self.array.count;i++){
                    for(NSDictionary*dic in self.array[i][@"users"]){
                        NSString *str1 = dic[@"type"];
                        if([str1 isEqualToString:@""]){
                            height = ([self.array[i][@"users"] count]*60/[self.array[i][@"users"] count])+height;
                            
                        }
                    }
                }
                NSInteger sectionNum = [self.tableView numberOfSections]-self.array.count+1;
                self.tableView.frame = CGRectMake(0, 0, kScreen.width, height+sectionNum*35);
                self.scrollView.contentSize = CGSizeMake(kScreen.width, height+sectionNum*35);
            }
        } else {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"网络请求失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertview show];
        }
    }];
    
   
}
-(void)goBackClicket{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBtnClick:(UIButton *)sender {
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"];
    NSString *ns = [self.uidArr componentsJoinedByString:@","];
    NSString *name = [self.nameArr componentsJoinedByString:@","];
    
    [H doGet:[NSString stringWithFormat:@"http://imshs.dev.jxzy.com//usr/add-discuss-grp?t=w&token=%@",token] args:@{@"uids":ns} json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if(!err) {
            if(self.uidArr.count == 0) {
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请先选择要加入讨论组的用户" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertview show];
            } else {
//                ChatViewController *vc = [[ChatViewController alloc]init];
//                vc.name = name;
//                [self.navigationController pushViewController:vc animated:YES];
            }
        } else {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"网络请求失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertview show];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.array.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    if([self.array[section-1][@"name"] isEqualToString:@"学习群组"]){
        return 0;
    }
    else {
        return [self.array[section-1][@"users"] count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        [tableView setSeparatorInset:UIEdgeInsetsZero];
        return cell;
    } else {
        static NSString *CellIdentifier = @"SearchCell";
        SearchResultsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchResultsTableViewCell" owner:self options:nil] lastObject];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nameLab.text = self.array[indexPath.section - 1][@"users"][indexPath.row][@"name"];
        if(self.array[indexPath.section - 1][@"users"][indexPath.row][@"img"]==nil){
            cell.headImgView.image = [UIImage imageNamed:@"com_man"];
        }else{
            cell.headImgView.url = self.array[indexPath.section - 1][@"users"][indexPath.row][@"img"];
        }
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"msg_noSelect"]];
        
        cell.accessoryView = img;
        if([self.array[indexPath.section-1][@"name"] isEqualToString:@"学习群组"]){
            cell.hidden = YES;
        }
       
       
        
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 0;
    }
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    if([self.array[section-1][@"name"] isEqualToString:@"学习群组"]){
        return 0;
    }
    if([self.array[section-1][@"users"] count] == 0) {
        return 1;
    }
    return 35;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    //        NSArray *arr = @[@"",[NSString stringWithFormat:@"    %@",self.array[0][@"name"]],[NSString stringWithFormat:@"    %@",self.array[1][@"name"]],[NSString stringWithFormat:@"    %@",self.array[2][@"name"]],[NSString stringWithFormat:@"    %@",self.array[3][@"name"]]];
    label.text = [NSString stringWithFormat:@"     %@",self.array[section-1][@"name"]];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor blackColor];
    label.alpha = 0.7;
    label.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.4];
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    if([self.array[section-1][@"users"] count] == 0) {
        label.hidden = YES;
    }
    if([label.text isEqualToString:@"     学习群组"]) {
        label.hidden = YES;
    }
    
    return label;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString*str= [[NSString stringWithFormat:@"%@",self.array[indexPath.section -1][@"users"][indexPath.row][@"uuid"]] componentsSeparatedByString:@"-"][1];
    NSString*nameStr= [NSString stringWithFormat:@"%@",self.array[indexPath.section-1 ][@"users"][indexPath.row][@"name"]];
    NSString *imgStr = [NSString stringWithFormat:@"%@",self.array[indexPath.section-1 ][@"users"][indexPath.row][@"img"]];
    if([self.uidArr containsObject:str]) {
        [self.uidArr removeObject:str];
        [self.nameArr removeObject:nameStr];
        [self.imgArr removeObject:imgStr];
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"msg_noSelect"]];
        cell.accessoryView = img;
    } else {
        [self.uidArr addObject:str];
        [self.nameArr addObject:nameStr];
        [self.imgArr addObject:imgStr];
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"msg_isSelect"]];
        cell.accessoryView = img;
    }
    [self.rightBtn setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.uidArr.count] forState:UIControlStateNormal];
    if(self.uidArr.count == 0) {
        [self.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    }
}
-(void)didReceiveMemoryWarning {
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
