//
//  LinkCtl.m
//  rcpi
//
//  Created by wu on 15/11/2.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "LinkCtl.h"
#import <WebKit/WebKit.h>
#import "Config.h"
@interface LinkCtl ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)WKWebView *webView;

@end

@implementation LinkCtl

-(BOOL)shouldAutorotate
{
    return NO;
}


-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setWkViewStart:self.url];
    [self setNav];

    self.view.backgroundColor = [UIColor blackColor];
}
- (WKWebView *)webView{
    if (_webView==nil) {
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0,kScreen.height,kScreen.width)];
    }
    return _webView;
}

- (void)setWkViewStart:(NSURL *)url{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.webView.scrollView.bounces=NO;
    self.webView.allowsBackForwardNavigationGestures=YES;
    [self.view addSubview:self.webView];
}
- (void)setNav{
    UIButton *leftBut =[[UIButton alloc]initWithFrame:CGRectMake(10, kScreen.width*0.4, 30, 30)];
    [leftBut setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftBut addTarget:self action:@selector(getBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBut];

}
- (void)getBack{
    NSLog(@"点击");
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
