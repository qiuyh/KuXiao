//
//  DetailViewController.m
//  rcpi
//
//  Created by Dc on 15/11/19.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "DetailViewController.h"
#import "Config.h"

@interface DetailViewController ()
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(kScreen.width / 2 - 60, 10, 50, 40)];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:32.0 / 255.0 green:191.0 / 255.0 blue:184.0 / 255.0 alpha:1.0]];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"详细资料";
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = lable;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(-1, 78, kScreen.width+2, 85)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 0.5;
    bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:bgView];
    
    UIImageView *headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(17.5, 17.5, 50, 50)];
    headImgView.url = self.imgUrlStr;
    [bgView addSubview:headImgView];
    
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(headImgView.frame)+10, 10, 150, 30)];
    nameLab.text = self.nameStr;
    nameLab.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:nameLab];
    
    UIView *introView = [[UIView alloc]initWithFrame:CGRectMake(-1, CGRectGetMaxY(bgView.frame)+10, kScreen.width+2, 45)];
    introView.backgroundColor = [UIColor whiteColor];
    introView.layer.borderWidth = 0.5;
    introView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:introView];
    
    UILabel *introLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(headImgView.frame), 17, 30, 10)];
    introLab.text = @"简介";
    introLab.font = [UIFont systemFontOfSize:15];
    [introView addSubview:introLab];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(20, CGRectGetMaxY(introView.frame)+15, kScreen.width-40, 40);
    [addBtn setTitle:@"添加到通讯录" forState:UIControlStateNormal];
    [addBtn setBackgroundColor:[UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0]];
    addBtn.layer.cornerRadius = 3;
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
}
-(void)addBtnClick {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入验证信息" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    static NSString *msgStr = nil;
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
         NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"];
        [H doGet:[NSString stringWithFormat:@"http://imshs.dev.jxzy.com/get-usr-info?t=w&token=%@",token] json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
            if(!err) {
                textField.text = [NSString stringWithFormat:@"我是:%@",json[@"data"][@"alias"]];
                msgStr = textField.text;
            } else {
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"网络请求失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertview show];
            }
        }];
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"添加好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [H doPost:@"http://imshs.dev.jxzy.com/usr/req-friend" dargs:@{@"uuid":self.uuid,@"msg":msgStr} json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
            if(!err) {
                NSString *str = [NSString stringWithFormat:@"%@",json[@"data"]];
                if([str isEqualToString:@"success"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:json[@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertview show];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
    }];
       
}];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
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
