//
//  RegisterController.m
//  Login
//
//  Created by wu on 15/9/21.
//  Copyright (c) 2015年 wu. All rights reserved.
//

#import "RegisterController.h"
#import "FirstController.h"
#import "ValidateString.h"
#import "TabbarController.h"
#import "Config.h"
@interface RegisterController ()

@end

@implementation RegisterController

static BOOL SELECT = YES ;
static BOOL AGREE = YES ;

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)defaultParameter{
    [self.buttonVisual setImage:[[UIImage imageNamed:@"lg_close"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.passwordField.secureTextEntry = YES;
    self.registerUrl = @"/ucenter/api/addUser";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景
    self.view.backgroundColor = [UIColor colorWithRed:244.0/256.0 green:244.0/256.0 blue:244.0/256.0 alpha:1];
    //设置导航栏和状态栏
    [self setNavigationBar];
    //设置按钮属性
    [self setButtonAttribute];
    //设置输入框属性
    [self setFieldAttribute];
    //初始参数
    [self defaultParameter];
}

- (void)setNavigationBar{


    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    self.navigationItem.title = @"注册大洋通行证";
}
- (void)setButtonAttribute{
    //设置按钮的属性
    [self buttonWithButton:self.buttonPR ImageName:[UIImage imageNamed:@"lg_iphonedown"] ImageBackgroundName:[UIImage imageNamed:@"lg_rectangle-2"] Radius:2.0 BorderWidth:0.5 Bordcolor:[UIColor grayColor]TitleColor:[UIColor whiteColor]];
    [self buttonWithButton:self.buttonER ImageName:[UIImage imageNamed:@"lg_emailnormal"] ImageBackgroundName:[UIImage imageNamed:@"lg_blank"] Radius:2.0 BorderWidth:0.5 Bordcolor:[UIColor grayColor] TitleColor:[UIColor grayColor]];
    [self.buttonFinish.layer setCornerRadius:5.0];
    [self.buttonFinish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)buttonWithButton:(UIButton *)button ImageName:(UIImage *)name ImageBackgroundName:(UIImage *)bgName Radius:(CGFloat)radius BorderWidth:(CGFloat)width Bordcolor:(UIColor*)color TitleColor:(UIColor*)tcolor{
    [button.layer setCornerRadius:radius];
    button.layer.borderColor = [color CGColor];
    button.layer.borderWidth = width;
    [button setTitleColor:tcolor forState:UIControlStateNormal];
    [button setBackgroundImage:bgName forState:UIControlStateNormal];
    [button setImage:[name imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.buttonPro setImage:[[UIImage imageNamed:@"lg_agree"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateNormal];
}

- (void)setFieldAttribute{
    [self setTextFieldLeftImage:@"lg_iphonenormal"UITextField:self.nameField  content:@"请输入手机号码"];
    [self setTextFieldLeftImage:@"lg_lock" UITextField:self.passwordField  content:@"6-16位字母或数字，区分大小写"];
    [self.inputFieldView.layer setCornerRadius:5.0];
    self.inputFieldView.layer.borderColor = [[UIColor colorWithRed:222.0/256.0 green:222.0/256.0 blue:222.0/256.0 alpha:1]CGColor];
    self.inputFieldView.layer.borderWidth = 0.5;
}

- (void)leftClick{
    NSLog(@"左导航");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setTextFieldLeftImage:(NSString *)image UITextField:(UITextField *)name  content:(NSString *)content{
    UIView *leftViews = [[UIView alloc]initWithFrame:name.frame];
    CGRect frame1 = leftViews.frame;
    frame1.size = CGSizeMake(30, 40);
    leftViews.frame = frame1;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:image]];
    CGFloat width = 10.0;
    CGFloat height =15.0;
    imageView.frame = CGRectMake((frame1.size.width-width)/2, (frame1.size.height-height)/2, width, height);
    [leftViews addSubview:imageView];
    name.leftView = leftViews;
    name.leftViewMode = UITextFieldViewModeAlways;
    name.placeholder = content;
}

- (IBAction)phoneRegister:(UIButton *)sender {
    
    SELECT = YES;
    self.nameField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view endEditing:YES];
    [self setButtonAttribute];
    self.nameField.placeholder = @"请输入手机号码";
    self.nameField.text = @"";
    self.passwordField.text = @"";
    
}
- (IBAction)emailRegister:(UIButton *)sender {
    SELECT = NO;
    self.nameField.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view endEditing:YES];
    self.nameField.placeholder = @"请输入邮箱账号";
    self.nameField.text = @"";
    self.passwordField.text = @"";
    [self buttonWithButton:self.buttonER ImageName:[UIImage imageNamed:@"lg_email-down"] ImageBackgroundName:[UIImage imageNamed:@"lg_rectangle-2"] Radius:2.0 BorderWidth:0.5 Bordcolor:[UIColor grayColor] TitleColor:[UIColor whiteColor]];
    [self buttonWithButton:self.buttonPR ImageName:[UIImage imageNamed:@"lg_iphonenormal"] ImageBackgroundName:[UIImage imageNamed:@"lg_blank"] Radius:2.0 BorderWidth:0.5 Bordcolor:[UIColor grayColor] TitleColor:[UIColor grayColor]];
    
}
- (IBAction)buttonVisualMethod:(UIButton *)sender {
    self.passwordField.secureTextEntry=!self.passwordField.secureTextEntry;
    if (self.passwordField.secureTextEntry) {
        [self.buttonVisual setImage:[[UIImage imageNamed:@"lg_close"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }else{
        [self.buttonVisual setImage:[[UIImage imageNamed:@"lg_open"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
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

- (IBAction)goToRegister:(UIButton *)sender {
    [self.view endEditing:YES];
    //输入框为空
    if (self.nameField.text.length==0||self.passwordField.text.length==0) {
        //        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"用户名或密码不允许为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //        [alertView show];
        [self popUp:@"用户名或密码不允许为空" time:1];
        return;
    }
    //用户名输入空格键会报错
    if ([ValidateString isEmpty:self.nameField.text]) {
        //        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"不能输入空白字符" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //        [alertView show];
        [self popUp:@"不能输入空白字符" time:1.5];
        return;
    }
    //限制密码长度
    if (self.passwordField.text.length<6||self.passwordField.text.length>16) {
        //        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"密码长度要在6-16位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //        [alertView show];
        [self popUp:@"密码长度要在6-16位" time:1.5];
        return;
    }
    //手机注册和邮箱注册的限制
    if (SELECT) {
        if (![ValidateString isValidNumber:self.nameField.text]) {
            //            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            //            [alertView show];
            [self popUp:@"请输入正确的手机号码" time:1.5];
            return;
        }
    }else{
        if (![ValidateString isValidateEmail:self.nameField.text]) {
            //            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的邮箱" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            //            [alertView show];
            [self popUp:@"请输入正确的邮箱" time:1.5];
            return;
        }
    }
    [self waiting];
    [self performSelector:@selector(networkRequest) withObject:nil afterDelay:2];
}
- (void)networkRequest{


    NSDictionary *params = @{@"usr":self.nameField.text,@"pwd":self.passwordField.text};
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",TS_SRV,self.registerUrl];
    [H doPost:urlStr dargs:params json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err) {
            NSELog(@"response err:%@", err);
            //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            //            [alert show];
            [self popUp:@"网络连接失败" time:2];
        }else if ([json[@"code"] integerValue]==0){
            NSLog(@"注册成功");
            [[NSUserDefaults standardUserDefaults] setObject:self.nameField.text forKey:@"name"];
            [[NSUserDefaults standardUserDefaults]setObject:json[@"msg"] forKey:@"tokenID"];
            [[NSUserDefaults standardUserDefaults]setObject:json[@"data"][@"tid"] forKey:@"userID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            //            [alert show];
            [self popUp:@"注册成功" time:1];
            NSILog(@"用户注册信息%@", json);
            //注册成功后，跳转界面
            [self.navigationController popToRootViewControllerAnimated:YES];

            NSLog(@"用户信息%@",json);
        }else {
            NSLog(@"用户名重复");
            //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"用户名重复" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            //            [alert show];
            [self popUp:@"用户名重复" time:1.5];
        }
        
    }];
    [self.indicator stopAnimating];
    self.view.alpha = 1;
}

- (void)waiting{
    self.indicator.alpha = 1;
    [self.indicator startAnimating];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:2 delay:0 options:0 animations:^{
        weakSelf.view.alpha = 0.8;
    } completion:nil];
}



- (IBAction)buttonProtocol:(UIButton *)sender {
    if (AGREE) {
        [self.buttonPro setImage:[[UIImage imageNamed:@"lg_whiteRoud"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateNormal];
        self.buttonFinish.enabled = NO;
        [self.buttonFinish setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        AGREE = NO;
    }else{
        [self.buttonPro setImage:[[UIImage imageNamed:@"lg_agree"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateNormal];
        self.buttonFinish.enabled = YES;
        [self.buttonFinish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        AGREE = YES;
    }
}


- (IBAction)nameText:(UITextField *)sender {
    [self.passwordField becomeFirstResponder];
    
}
- (IBAction)passwordText:(id)sender {
    [self goToRegister:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
