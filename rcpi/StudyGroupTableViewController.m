//
//  StudyGroupTableViewController.m
//  rcpi
//
//  Created by Dc on 15/11/25.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "StudyGroupTableViewController.h"
#import "Config.h"
#import "SearchResultsTableViewCell.h"


@interface StudyGroupTableViewController ()
@property(nonatomic ,strong)NSArray *array;
@property(nonatomic ,strong)NSMutableArray *ChatArr;
@property(nonatomic ,strong)NSMutableArray *CourseArr;
@property(nonatomic ,strong)NSMutableArray *ChatImgArr;
@property(nonatomic ,strong)NSMutableArray *CourseImgArr;
@end

@implementation StudyGroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ChatArr = [NSMutableArray array];
    self.CourseArr = [NSMutableArray array];
    self.ChatImgArr = [NSMutableArray array];
    self.CourseImgArr = [NSMutableArray array];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    titleLabel.center=[UIScreen mainScreen].bounds.origin;
    titleLabel.text=@"学习群组";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"com_return"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBackClicket) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBtnItem;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
     NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"];
    
    [H doGet:[NSString stringWithFormat:@"http://imshs.dev.jxzy.com/get-usr-info?t=w&token=%@",token ]json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if(!err) {
            NSArray *arr = json[@"data"][@"friendGrp"];
            if([json[@"code"] integerValue]==1) {
            }
            if(!self.array) {
                self.array = arr;
                for(int i =0;i<self.array.count;i++) {
                    if([self.array[i][@"name"]isEqualToString:@"学习群组"]){
                        NSArray *arr =self.array[i][@"users"];
                        for(int j=0;j<arr.count;j++) {
                            NSString *chatType = arr[j][@"type"];
                            NSString *chatName = arr[j][@"name"];
                            NSString *CourseName = arr[j][@"name"];
                            NSString *chatImg = arr[j][@"img"];
                            NSString *courseImg = arr[j][@"img"];
                            if([chatType isEqualToString:@"CHAT_GRP"]) {
                                [self.ChatArr addObject:chatName];
                                [self.ChatImgArr addObject:chatImg];
                            } else {
                                [self.CourseArr addObject:CourseName];
                                [self.CourseImgArr addObject:courseImg];
                            }
                        }
                    }
                }
               [self.tableView reloadData];
            }
        } else {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"网络请求失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertview show];
        }
    }];
    self.tableView.rowHeight = 60;
    self.tableView.tableFooterView = [[UIView alloc]init];
}
-(void)goBackClicket{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return self.ChatArr.count;
    } else {
        return self.CourseArr.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SearchCell";
    SearchResultsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchResultsTableViewCell" owner:self options:nil] lastObject];
    }
    if(indexPath.section == 0) {
        cell.nameLab.text = self.ChatArr[indexPath.row];
        cell.headImgView.url = self.ChatImgArr[indexPath.row];
    } else {
        cell.nameLab.text = self.CourseArr[indexPath.row];
        cell.headImgView.url = self.CourseImgArr[indexPath.row];
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label.layer.borderWidth = 0.5;
    if(section == 0) {
        label.text = @"     我的讨论组";
    } else {
        label.text = @"     课程群组";
    }
    return label;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0){
        if(self.ChatArr.count == 0) {
            return 0;
        } else {
            return 44;
        }
    } else {
        if(self.CourseArr.count == 0) {
            return 0;
        } else {
            return 44;
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    SearchResultsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        ChatViewController *chatVC = [[ChatViewController alloc]init];
//        chatVC.name = cell.nameLab.text;
//        [self.navigationController pushViewController:chatVC animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
