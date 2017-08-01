//
//  RegisterController.h
//  Login
//
//  Created by wu on 15/9/21.
//  Copyright (c) 2015年 wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *buttonPR;
@property (weak, nonatomic) IBOutlet UIButton *buttonER;
@property (weak, nonatomic) IBOutlet UIView *inputFieldView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *buttonVisual;
@property (weak, nonatomic) IBOutlet UIButton *buttonFinish;
@property (weak, nonatomic) IBOutlet UIButton *buttonPro;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
//test

@property (nonatomic,strong)NSString *registerUrl;
- (void)leftClick;
-(void)setTextFieldLeftImage:(NSString *)image UITextField:(UITextField *)name  content:(NSString *)content;
- (IBAction)phoneRegister:(UIButton *)sender;
- (IBAction)emailRegister:(UIButton *)sender;
- (IBAction)buttonVisualMethod:(UIButton *)sender;
- (IBAction)goToRegister:(UIButton *)sender;
- (void)networkRequest;
- (UIStatusBarStyle)preferredStatusBarStyle;
- (void)waiting;
- (IBAction)buttonProtocol:(UIButton *)sender;
- (IBAction)nameText:(UITextField *)sender;
- (IBAction)passwordText:(id)sender;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end
