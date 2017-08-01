//
//  LoginViewController.m
//  Login
//
//  Created by wu on 15/9/14.
//  Copyright (c) 2015年 wu. All rights reserved.

#import "LoginViewController.h"
#import "RegisterController.h"
#import "FirstController.h"
#import "TabbarController.h"
#import "ValidateString.h"
#import "Config.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置输入框
    [self setTextFieldLeftImage:@"lg_user" UITextField:self.loginUsername  content:@"请输入您的账号"];
    [self setTextFieldLeftImage:@"lg_lock" UITextField:self.loginPassword  content:@"6-16位字母或数字，区分大小写"];
    self.loginPassword.secureTextEntry = YES;
    //设置登陆的button
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    self.loginButton.backgroundColor = [UIColor colorWithRed:31.0/256.0 green:190.0/256.0 blue:182.0/256.0 alpha:1];
    [self.loginButton.layer setCornerRadius:2.0];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //先睹为快
    UIImageView * arrowView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lg_arrow"]];
    arrowView.frame = CGRectMake(0, 0, 20, 20);
    [self.noLoginButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [self.noLoginButton setImage:[[UIImage imageNamed:@"lg_arrow"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.noLoginButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.noLoginButton.titleLabel.bounds.size.width, 0,-self.noLoginButton.frame.size.width-self.noLoginButton.titleLabel.bounds.size.width-150)];
    [self.noLoginButton addTarget:self action:@selector(goBackIndex) forControlEvents:UIControlEventTouchUpInside];
    self.urlStr = @"/sso/api/login";
    
}

//暂不登陆，跳转首页
-(void)goBackIndex{
    NSLog(@"暂不登陆，跳转首页");
    //    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


//设置textField里面的属性
-(void)setTextFieldLeftImage:(NSString *)image UITextField:(UITextField *)name  content:(NSString *)content{
    UIView *leftViews = [[UIView alloc]initWithFrame:name.frame];
    CGRect frame1 = leftViews.frame;
    frame1.size = CGSizeMake(30, 40);
    leftViews.frame = frame1;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:image]];
    CGFloat width = 13.0;
    CGFloat height =15.0;
    imageView.frame = CGRectMake(frame1.size.width-width, (frame1.size.height-height)/2, width, height);
    [leftViews addSubview:imageView];
    name.leftView = leftViews;
    name.leftViewMode = UITextFieldViewModeAlways;
    name.placeholder = content;
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - 登陆
- (IBAction)goToLogin:(UIButton *)sender {
    [self.view endEditing:YES];
    //输入框为空
    if (self.loginUsername.text.length==0||self.loginPassword.text.length==0) {
        //        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"用户名或密码不允许为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //         [alertView show];
        [self popUp:@"用户名或密码不允许为空" time:1];
        return;
    }
    //用户名输入空格键会报错
    if ([ValidateString isEmpty:self.loginUsername.text]) {
        NSDLog(@"输入框存在空格%d", [ValidateString isEmpty:self.loginUsername.text]);
        //        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"不能输入空白字符" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //        [alertView show];
        [self popUp:@"不能输入空白字符" time:1.5];
        return;
    }
    [self waiting];
    [self performSelector:@selector(networkRequest) withObject:nil afterDelay:2];
    
}
- (void)popUp:(NSString*)title time:(CGFloat)times{
    UIView *baffleView = [[UIView alloc]initWithFrame:self.view.frame];
    baffleView.alpha=0.5;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    label.center=self.view.center;
    label.font=[UIFont systemFontOfSize:15];
    label.alpha = 1;
    label.text = title;
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor = [UIColor blackColor];
    [baffleView addSubview:label];
    [self.view.window addSubview:baffleView];

    [UIView animateWithDuration:times animations:^{
        label.alpha = 0.5;
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
        [baffleView removeFromSuperview];
    }];
}
- (void)networkRequest{

    NSDictionary *params = @{@"usr":self.loginUsername.text,@"pwd":self.loginPassword.text};
NSString *urlStr = [NSString stringWithFormat:@"%@%@",TS_SRV,self.urlStr];
        [H doPost:urlStr dargs:params json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err) {
            NSELog(@"网络返回数据有误response err:%@", err);
            //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            //            [alert show];
            [self popUp:@"网络连接失败" time:2];
            
            [self.indicator stopAnimating];
            self.view.alpha = 1;
            
        }else if ([json[@"code"] integerValue]==0){
            [[NSUserDefaults standardUserDefaults] setObject:self.loginUsername.text forKey:@"name"];
            [[NSUserDefaults standardUserDefaults]setObject:json[@"data"][@"usr"][@"tid"] forKey:@"userID"];
            NSString *tokenID = json[@"data"][@"token"];
            [[NSUserDefaults standardUserDefaults]setObject:tokenID forKey:@"tokenID"];
            NSLog(@"token======%@",tokenID);
            [[NSUserDefaults standardUserDefaults] synchronize];

            NSLog(@"登陆成功，正在跳转");
            self.navigationController.navigationBarHidden=NO;
            [self.navigationController popViewControllerAnimated:YES];
            NSILog(@"用户登陆信息%@", json);
            
        }else {
            NSLog(@"用户名或密码错误");
            //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            //            [alert show];
            [self popUp:@"用户名或密码错误" time:1.5];
            [self.indicator stopAnimating];
            self.view.alpha = 1;
        }
    }];
    
}
- (void)waiting{
    self.indicator.alpha = 1;
    [self.indicator startAnimating];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:2 delay:0 options:0 animations:^{
        weakSelf.view.alpha = 0.8;
    } completion:nil];
}

//跳转注册页面
- (IBAction)goToRegister:(id)sender {
    self.navigationController.navigationBarHidden=NO;
    RegisterController *registerVC = [[RegisterController alloc]initWithNibName:@"RegisterController" bundle:nil];
    
    [self.navigationController pushViewController:registerVC animated:YES];
}


- (IBAction)usernameTextField:(UITextField *)sender {
    [self.loginPassword becomeFirstResponder];
    
}
- (IBAction)passwordTextField:(UITextField *)sender {
    [self goToLogin:nil];
}


@end
