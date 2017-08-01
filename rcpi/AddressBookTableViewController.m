//
//  AddressBookTableViewController.m
//  rcpi
//
//  Created by user on 15/11/3.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "AddressBookTableViewController.h"
#import "Config.h"
#import "SearchResultsTableViewCell.h"
#import "StudyGroupTableViewController.h"
#import "LoginViewController.h"

@interface AddressBookTableViewController ()

@property (nonatomic ,strong)NSArray *array;

@end

@implementation AddressBookTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    //Set NavigationController
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    titleLabel.center=[UIScreen mainScreen].bounds.origin;
    titleLabel.text=@"通讯录";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"com_return"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBackClicket) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBtnItem;
    
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
        return 3;
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
            if (indexPath.row == 0) {
//                UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
//                searchBar.placeholder = @"搜索";
//                searchBar.backgroundColor = [UIColor clearColor];
//                [cell.contentView addSubview:searchBar];
            }else if (indexPath.row == 1) {
                cell.textLabel.text = @"新的朋友";
                cell.imageView.image = [UIImage imageNamed:@"msg_newFriends"];
            }else{
                cell.textLabel.text = @"学习群组";
                cell.imageView.image = [UIImage imageNamed:@"msg_studyGroup"];
            }
        return cell;
    } else {
        static NSString *CellIdentifier = @"SearchCell";
        SearchResultsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchResultsTableViewCell" owner:self options:nil] lastObject];
        }
        cell.nameLab.text = self.array[indexPath.section - 1][@"users"][indexPath.row][@"name"];
        if(self.array[indexPath.section - 1][@"users"][indexPath.row][@"img"]==nil){
            cell.headImgView.image = [UIImage imageNamed:@"com_man"];
        }else{
        cell.headImgView.url = self.array[indexPath.section - 1][@"users"][indexPath.row][@"img"];
        }
        if([self.array[indexPath.section-1][@"name"] isEqualToString:@"学习群组"]){
            cell.hidden = YES;
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.section != 0) {
//        ChatViewController *chatVC = [[ChatViewController alloc]init];
//        chatVC.name = cell.nameLab.text;
//        [self.navigationController pushViewController:chatVC animated:YES];
    } else {
        if(indexPath.row == 2) {
            StudyGroupTableViewController *vc = [[StudyGroupTableViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
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
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
//        NSArray *arr = @[@"",[NSString stringWithFormat:@"    %@",self.array[0][@"name"]],[NSString stringWithFormat:@"    %@",self.array[1][@"name"]],[NSString stringWithFormat:@"    %@",self.array[2][@"name"]],[NSString stringWithFormat:@"    %@",self.array[3][@"name"]]];
        label.text = [NSString stringWithFormat:@"     %@",self.array[section-1][@"name"]];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
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
#pragma mark - changeViewAnimation

- (void)goBackClicket {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
