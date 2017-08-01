//
//  registerTest.m
//  rcpi
//
//  Created by wu on 15/9/30.
//  Copyright (c) 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <iwf/iwf.h>
#import "RegisterController.h"
#import "Config.h"

@interface RegisterTest : XCTestCase<NSBoolable>
@property (readonly) BOOL boolValue;
@property (nonatomic,strong)RegisterController *regis;
//@property (assign)int type;
@end

@implementation RegisterTest


- (void)setUp {
    [super setUp];
    [self performSelectorOnMainThread:@selector(load) withObject:nil waitUntilDone:YES];}

- (void)load{
    //new the view controller.
    self.regis=[[RegisterController alloc]initWithNibName:nil bundle:[NSBundle bundleForClass:[RegisterController class]]];
    UINavigationController* nv=(UINavigationController*)[[[UIApplication sharedApplication]keyWindow]rootViewController];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"name"];
    //adding to UINavigationController
    [nv pushViewController:self.regis animated:YES];
}

- (void)tearDown {
    self.regis = nil;
    [super tearDown];
}

- (BOOL)boolValue{
    //    switch (self.type) {
    //        case 1:
    //            NSLog(@"我要的%@",self.regis.buttonFinish.currentTitle);
    //            return [@"完成" isEqualToString:self.regis.buttonFinish.currentTitle];
    //            break;
    //        case 2:
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    //            break;
    //        default: return false;
    //            break;
    //    }

}
- (void)testRegister{
    //    self.type=1;
    //    XCTAssert(RunLoopv(self),@"time out");
    [self.regis leftClick];
    //    [self.regis.navigationController popViewControllerAnimated:YES];
    [self.regis preferredStatusBarStyle];
    [self.regis phoneRegister:nil];
    [self.regis touchesBegan:nil withEvent:nil];
    [self.regis nameText:nil];
    [self.regis passwordText:nil];
    //是否同意协议
    [self.regis buttonProtocol:nil];
    [self.regis buttonProtocol:nil];

    //是否可视密码
    [self.regis buttonVisualMethod:nil];
    [self.regis buttonVisualMethod:nil];
    //输入框内容为空
    self.regis.nameField.text=@" ";
    self.regis.passwordField.text=@"";
    [self.regis performSelectorOnMainThread:@selector(goToRegister:) withObject:nil waitUntilDone:YES];
    //内容存在空白
    self.regis.nameField.text=@"13 13423424";
    self.regis.passwordField.text=@"123456";
    [self.regis performSelectorOnMainThread:@selector(goToRegister:) withObject:nil waitUntilDone:YES];
    //手机格式不合格
    self.regis.nameField.text=@"abc";
    self.regis.passwordField.text=@"123456";
    [self.regis performSelectorOnMainThread:@selector(goToRegister:) withObject:nil waitUntilDone:YES];
    //密码长度不合格
    self.regis.nameField.text=@"13333333333";
    self.regis.passwordField.text=@"12345";
    [self.regis performSelectorOnMainThread:@selector(goToRegister:) withObject:nil waitUntilDone:YES];
    //用户名重复
    self.regis.nameField.text=@"13333333333";
    self.regis.passwordField.text=@"123456";
    [self.regis performSelectorOnMainThread:@selector(goToRegister:) withObject:nil waitUntilDone:YES];
    [self.regis performSelectorOnMainThread:@selector(networkRequest) withObject:nil waitUntilDone:YES];
    //邮箱格式错误
    [self.regis performSelectorOnMainThread:@selector(emailRegister:) withObject:nil waitUntilDone:YES];
    self.regis.nameField.text=@"13333333333";
    self.regis.passwordField.text=@"1234567";
    [self.regis performSelectorOnMainThread:@selector(goToRegister:) withObject:nil waitUntilDone:YES];
    [self.regis performSelectorOnMainThread:@selector(emailRegister:) withObject:nil waitUntilDone:YES];
    //注册成功
    int rand = arc4random_uniform(9999)+1;
    self.regis.nameField.text = [NSString stringWithFormat:@"1381234%04d",rand];
    self.regis.passwordField.text=@"123456";
    [self.regis performSelectorOnMainThread:@selector(goToRegister:) withObject:nil waitUntilDone:YES];
    [self.regis performSelectorOnMainThread:@selector(networkRequest) withObject:nil waitUntilDone:YES];
    //网络错误
    self.regis.nameField.text=@"13333333333";
    self.regis.passwordField.text=@"123456";
    self.regis.registerUrl = @"/ucenter/api/addUserd";
    [self.regis performSelectorOnMainThread:@selector(goToRegister:) withObject:nil waitUntilDone:YES];
    [self.regis performSelectorOnMainThread:@selector(networkRequest) withObject:nil waitUntilDone:YES];

    //    self.type=2;
    XCTAssert(RunLoopv(self),@"time out");
}

@end