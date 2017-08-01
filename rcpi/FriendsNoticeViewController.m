//
//  FriendsNoticeViewController.m
//  rcpi
//
//  Created by Dc on 15/11/25.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "FriendsNoticeViewController.h"
#import "Config.h"
#import "ChatController.h"


@interface FriendsNoticeViewController ()
@property (nonatomic ,strong)NSMutableArray *oidArr;
@property (nonatomic ,strong)NSMutableArray *msgLabArr;
@property (nonatomic ,strong)NSMutableArray *btnArr;
@property (nonatomic ,strong)NSMutableArray *nameLabArr;
@end

@implementation FriendsNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    titleLabel.center = [UIScreen mainScreen].bounds.origin;
    titleLabel.text = @"好友通知";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"com_return"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBackClicket) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBtnItem;
    
    UIButton *moreMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreMsgBtn setBackgroundImage:[UIImage imageNamed:@"消息记录"] forState:UIControlStateNormal];
    moreMsgBtn.frame = CGRectMake(0, 0, 20, 20);
    //[moreMsgBtn addTarget:self action:@selector(moreMessageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *moreMsgItem = [[UIBarButtonItem alloc]initWithCustomView:moreMsgBtn];
    UIButton *studyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [studyBtn setBackgroundImage:[UIImage imageNamed:@"导学资料"] forState:UIControlStateNormal];
    studyBtn.frame = CGRectMake(0, 0, 22, 22);
    UIBarButtonItem *studyItem = [[UIBarButtonItem alloc]initWithCustomView:studyBtn];
    
    self.navigationItem.rightBarButtonItems = @[studyItem,moreMsgItem];
    
    self.oidArr = [NSMutableArray array];
    self.msgLabArr = [NSMutableArray array];
    self.btnArr = [NSMutableArray array];
    self.nameLabArr = [NSMutableArray array];
    
   
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"];
    if([titleLabel.text isEqualToString:@"好友通知"]) {
        [H doGet:[NSString stringWithFormat:@"http://imshs.dev.jxzy.com/usr/list-notify?t=w&token=%@",token] json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
            NSArray *arr = json[@"data"];
            NSLog(@"%@",arr);
            if(err ) {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"网络请求失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertview show];
            } else {
                UIScrollView *scro = [[UIScrollView alloc]initWithFrame:self.view.frame];
                scro.contentSize = CGSizeMake(kScreen.width, arr.count*130);
                [self.view addSubview:scro];
                for(int i =0;i<arr.count;i++) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                    [formatter setDateStyle:NSDateFormatterMediumStyle];
                    [formatter setTimeStyle:NSDateFormatterShortStyle];
                    [formatter setDateFormat:@"HH:mm"];
                    NSString *time = arr[i][@"time"];
                    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[time integerValue]];
                    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
                    UILabel*timeLab = [[UILabel alloc]init];
                    timeLab.frame =CGRectMake(kScreen.width/2-30, 74+i*110, 60, 10);
                    timeLab.text = confromTimespStr;
                    titleLabel.textAlignment = 1;
                    timeLab.font = [UIFont systemFontOfSize:10];
                    [scro addSubview:timeLab];
                    
                    UIView *view = [[UIView alloc]init];
                    view.frame = CGRectMake(15, 104+i*110, CGRectGetWidth(self.view.frame)-30, 70);
                    view.backgroundColor = [UIColor whiteColor];
                    view.layer.cornerRadius = 5;
                    [scro addSubview:view];
                    
                    UIImageView*img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 45, 45)];
                    img.url = arr[i][@"rImg"];
                    [view addSubview:img];
                    
                    UILabel *nameLab = [[UILabel alloc]init];
                    nameLab.frame = CGRectMake(60, 5, 200, 25);
                    nameLab.text = arr[i][@"lName"];
                    nameLab.font = [UIFont systemFontOfSize:12];
                    [view addSubview:nameLab];
                    [self.nameLabArr addObject:nameLab];
                    
                    UILabel* msgLab = [[UILabel alloc]init];
                    [msgLab setFrame:CGRectMake(60, 23, 100, 45)];
                    msgLab.text = arr[i][@"msg"];
                    msgLab.numberOfLines = 0;
                    msgLab.font = [UIFont systemFontOfSize:12];
                    msgLab.tag = i;
                    msgLab.textColor = [UIColor lightGrayColor];
                    [view addSubview:msgLab];
                    [self.msgLabArr addObject:msgLab];
                    
                    NSString *oidStr = [NSString stringWithFormat:@"%@",arr[i][@"oid"]];
                    [self.oidArr addObject:oidStr];
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btn setTitle:@"同意" forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    btn.titleLabel.font = [UIFont systemFontOfSize:10];
                    btn.backgroundColor = [UIColor blueColor];
                    btn.layer.cornerRadius = 5;
                    btn.tag = i;
                    btn.frame = CGRectMake(CGRectGetWidth(view.frame)-70, 20, 60, 30);
                    [view addSubview:btn];
                    [self.btnArr addObject:btn];
                    
                    for(UILabel *lab in self.msgLabArr) {
                        if([[NSString stringWithFormat:@"%@",arr[i][@"status"]]isEqualToString:@"4"]){
                            lab.text = @"已经成为好友";
                        }
                    }
                    for(UIButton *btn in self.btnArr) {
                        if([[NSString stringWithFormat:@"%@",arr[i][@"status"]]isEqualToString:@"4"]){
                            [btn setTitle:@"发送消息" forState:UIControlStateNormal];
                            
                        }
                    }
                }
            }
        }];
    }
}
-(void)agreeBtnClick:(UIButton *)sender {
    if([sender.titleLabel.text isEqualToString:@"发送消息"]){
        ChatController *vc =[[ChatController alloc]init];
        UILabel*lab=self.nameLabArr[sender.tag];
        vc.name = lab.text;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        for(int i =0;i<self.oidArr.count;i++) {
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"];
            [H doPost:[NSString stringWithFormat:@"http://imshs.dev.jxzy.com/usr/del-req-friend?t=w&token=%@",token] dargs:@{@"opt":@4,@"oid":self.oidArr[i]} json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
                if(!err){
                    [sender setTitle:@"发送消息" forState:UIControlStateNormal];
                    UILabel*lab = self.msgLabArr[sender.tag];
                    lab.text = @"已经成为好友";
                }else {
                    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"网络请求失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertview show];
                }
               
                
            }];
        }
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)goBackClicket{
    [self.navigationController popViewControllerAnimated:YES];
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
