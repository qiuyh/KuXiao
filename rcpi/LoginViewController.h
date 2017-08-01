//
//  LoginViewController.h
//  Login
//
//  Created by wu on 15/9/14.
//  Copyright (c) 2015年 wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *weixinButton;
@property (weak, nonatomic) IBOutlet UIButton *qqButton;
@property (weak, nonatomic) IBOutlet UIButton *taobaoButton;

@property (weak, nonatomic) IBOutlet UITextField *loginUsername;
@property (weak, nonatomic) IBOutlet UITextField *loginPassword;
@property (weak, nonatomic) IBOutlet UIButton *noLoginButton;
@property (nonatomic,strong)NSString *urlStr;

//test
- (IBAction)goToLogin:(UIButton *)sender;
//@property (nonatomic,strong)NSDictionary *json;
- (void)networkRequest;
-(void)goBackIndex;
- (IBAction)goToRegister:(id)sender;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (IBAction)usernameTextField:(UITextField *)sender;
- (IBAction)passwordTextField:(UITextField *)sender;

@end
