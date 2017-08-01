

//
//  loginTest.m
//  rcpi
//
//  Created by wu on 15/9/25.
//  Copyright (c) 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "LoginViewController.h"
#import <iwf/iwf.h>
#import "Config.h"
@interface LoginTest : XCTestCase <NSBoolable>

@property (nonatomic,strong)LoginViewController *login;

@property (readonly) BOOL boolValue;
@property (assign)int type;
@end

@implementation LoginTest

- (void)setUp {
    [super setUp];
    [self performSelectorOnMainThread:@selector(load) withObject:nil waitUntilDone:YES];
}
- (void)load{
    //new the view controller.
    self.login=[[LoginViewController alloc]initWithNibName:nil bundle:[NSBundle bundleForClass:[LoginViewController class]]];
    UINavigationController* nv=(UINavigationController*)[[[UIApplication sharedApplication]keyWindow]rootViewController];
    //adding to UINavigationController
    [nv popToRootViewControllerAnimated:NO];
    [nv pushViewController:self.login animated:YES];
}

- (void)tearDown {
    self.login=nil;
    [super tearDown];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"name"];

}

- (BOOL)boolValue{
    switch (self.type) {
        case 1:
            return [@"登录" isEqualToString:self.login.loginButton.currentTitle];
            break;
        case 2:
            return [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
            break;
        default:
            return  false;
            break;
    }
}
- (void)testLogin{
    self.type=1;
    //    XCTAssert(RunLoopv(self),@"time out");
    [self.login goBackIndex];
    [self.login passwordTextField:nil];
    [self.login usernameTextField:nil];
    [self.login goToRegister:nil];
    [self.login.navigationController popViewControllerAnimated:YES];
    [self.login touchesBegan:nil withEvent:nil];
    //输入框为空
    self.login.loginUsername.text=@"";
    self.login.loginPassword.text=@"";
    [self.login performSelectorOnMainThread:@selector(goToLogin:) withObject:nil waitUntilDone:YES];
    //用户名存在空白键
    self.login.loginUsername.text = @"a sdf";
    self.login.loginPassword.text = @"assdsdf";
    [self.login performSelectorOnMainThread:@selector(goToLogin:) withObject:nil waitUntilDone:YES];
    //密码错误
    self.login.loginUsername.text=@"wu";
    self.login.loginPassword.text=@"12345633";
    [self.login performSelectorOnMainThread:@selector(goToLogin:) withObject:nil waitUntilDone:YES];
    [self.login performSelectorOnMainThread:@selector(networkRequest) withObject:nil waitUntilDone:YES];
    //密码正确
    self.login.loginUsername.text=@"wu";
    self.login.loginPassword.text=@"123456";
    [self.login performSelectorOnMainThread:@selector(goToLogin:) withObject:nil waitUntilDone:YES];
    [self.login performSelectorOnMainThread:@selector(networkRequest) withObject:nil waitUntilDone:YES];
    //测试网络错误
    [self.login performSelectorOnMainThread:@selector(goToLogin:) withObject:nil waitUntilDone:YES];
    self.login.urlStr=@"sso/api/logizn";
    [self.login performSelectorOnMainThread:@selector(networkRequest) withObject:nil waitUntilDone:YES];
    self.type=2;
    XCTAssert(RunLoopv(self),@"time out");

}

@end


