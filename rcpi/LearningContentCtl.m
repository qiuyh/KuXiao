//
//  LearningContentCtl.m
//  rcpi
//
//  Created by wu on 15/10/21.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "LearningContentCtl.h"
#import "Config.h"
#import <WebKit/WebKit.h>
#import "FocusCtl.h"
#import "photoCtl.h"
#import "LinkCtl.h"
@interface LearningContentCtl ()<WKUIDelegate,WKScriptMessageHandler,WKNavigationDelegate,UIScrollViewDelegate>

@end

@implementation LearningContentCtl


- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //    self.view.backgroundColor = [UIColor blackColor];
    [self setButtons];
    [self setNav];
    [self setWkViewStart];
}
- (void)setWkViewStart{
    self.tokenID = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"];
    NSLog(@"拿到的token=========%@,cid=====%@,tid===%@",self.tokenID,self.courseID,self.targetID);
    //测试页
    //    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://rcp.dev.jxzy.com/courseContent.html?cid=35555&target=12803&token=%@",self.tokenID]];
    //正常接口
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/courseContent.html?cid=%@&target=%@&token=%@",SRV,self.courseID,self.targetID,self.tokenID]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    WKUserScript *script = [[WKUserScript alloc]initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    //    [config.userContentController addUserScript:script];
    WKWebViewConfiguration *config =[[WKWebViewConfiguration alloc]init];
    [config.userContentController addScriptMessageHandler:self name:@"notification"];
    self.wkView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 20, kScreen.width, kScreen.height-20-49) configuration:config];
    [self.wkView loadRequest:request];
    self.wkView.scrollView.bounces=NO;
    self.wkView.scrollView.delegate=self;
    self.wkView.navigationDelegate=self;
    self.wkView.UIDelegate=self;
    self.wkView.allowsBackForwardNavigationGestures=YES;
    [self.view addSubview:self.wkView];

}

- (void)setNav{

    UIButton *leftBut =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    [leftBut setImage:[UIImage imageNamed:@"ln_comeback"] forState:UIControlStateNormal];
    [leftBut addTarget:self action:@selector(getBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftBut];
    self.navigationItem.leftBarButtonItem =leftItem;

    UIButton *listBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    [listBtn setImage:[UIImage imageNamed:@"ln_directorySlelcted"] forState:UIControlStateNormal];
    [listBtn setImage:[UIImage imageNamed:@"ln_directoryDown"] forState:UIControlStateHighlighted];
    [listBtn addTarget:self action:@selector(goToList:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *listItem=[[UIBarButtonItem alloc]initWithCustomView:listBtn];

    UIButton *newsBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    [newsBtn setImage:[UIImage imageNamed:@"ln_dynamic"] forState:UIControlStateNormal];
    [newsBtn setImage:[UIImage imageNamed:@"ln_dynamic-normal"] forState:UIControlStateHighlighted];
    [newsBtn addTarget:self action:@selector(goToNews:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *newsItem=[[UIBarButtonItem alloc]initWithCustomView:newsBtn];

    UIButton *evaluateBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    [evaluateBtn setImage:[UIImage imageNamed:@"ln_testNormal"] forState:UIControlStateNormal];
    [evaluateBtn setImage:[UIImage imageNamed:@"ln_testDown"] forState:UIControlStateHighlighted];
    [evaluateBtn addTarget:self action:@selector(goToEvaluate:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *evaluateItem=[[UIBarButtonItem alloc]initWithCustomView:evaluateBtn];

    UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    itemSpace.width = 30;
    self.navigationItem.rightBarButtonItems = @[evaluateItem,itemSpace,newsItem,itemSpace,listItem];

    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    //    self.navigationController.navigationBar.alpha=0.8;
    //修改透明度后记得在跳转一并修改！！！
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"加载失败-->%@",error.userInfo);
}
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//    NSLog(@"收到响应，返回数据%@",webView.URL.absoluteString);
//    //支持加载
//    decisionHandler(WKNavigationResponsePolicyAllow);
//}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"加载完成");
}

#pragma WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"%@",message.body);
    if (message.body[@"ppt"]) {
        NSArray * ppt = [NSArray array];
        ppt =message.body[@"ppt"];
        //        NSLog(@"ppt======%@",ppt);
        [self openThePPT:(ppt)];
    }
    if (message.body[@"photo"]) {
        NSString *photo = [message.body objectForKey:@"photo"];
        //        NSLog(@"photo===%@",photo);
        [self openThePhoto:(photo)];
    }
    if (message.body[@"video"]) {
        NSString *video = [message.body objectForKey:@"video"];
        //        NSLog(@"video===%@",video);
        [self openTheVideo:(video)];
    }
    if (message.body[@"link"]) {
        NSString *link = [message.body objectForKey:@"link"];
        //        NSLog(@"link===%@",link);
        [self openTheLink:(link)];
    }
    if (message.body[@"practise"]) {
        NSArray *practise = [message.body allValues];
        //        NSLog(@"practise===%@",practise);
        [self openThePractise:(practise)];
    }
}

- (void)openThePractise:(NSArray*)practise{
    NSLog(@"还在建设中");
}

- (void)openTheLink:(NSString*)link{
    NSURL *url =[NSURL URLWithString:link];
    LinkCtl *controller = [[LinkCtl alloc]init];
    controller.url =url;
    [self presentViewController:controller animated:NO completion:nil];
    //    self.navigationController.navigationBar.hidden=NO;
    //    [self.navigationController pushViewController:controller animated:YES];
    //    [self.wkView loadRequest:[NSURLRequest requestWithURL:url]];

}

/**
 - (void)viewWillAppear:(BOOL)animated{
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreen) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
 }
 - (void)fullScreen{
 NSLog(@"全屏了");
 NSLog(@"当前方向%ld",(long)[[UIDevice currentDevice] orientation]);
 //    CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(M_PI / 2);
 //    self.view.transform = landscapeTransform;
 //    self.view.frame = CGRectMake(0, 0, kScreen.height, kScreen.width);
 }
 */

-(void)openTheVideo:(NSString *)video{
    if (self.mpCtl) {
        [self.mpCtl.view removeFromSuperview];
    }
    NSURL *url = [NSURL URLWithString:video];
    int yy;
    self.mpCtl = [[MPMoviePlayerController alloc]initWithContentURL:url];
    if (self.hidden) {
        yy = 20;
    }else{
        yy = 64;
    }
    self.mpCtl.view.frame = CGRectMake(0, yy, kScreen.width, 250);
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(kScreen.width-25, 0, 25, 25)];
    //    [back setTitle:@"关闭" forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:@"closeWindows"] forState:UIControlStateNormal];
    [back setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchUpInside];
    [self.mpCtl.view addSubview:back];
    [self.view addSubview:self.mpCtl.view];
    [self.mpCtl play];
    self.wkView.y=CGRectGetMaxY(self.mpCtl.view.frame);

}
-(void)openThePhoto:(NSString*)photo{
    self.navigationController.navigationBar.hidden=NO;
    //NSString *photoStr = [NSString stringWithFormat:@"%@%@&token=%@",SRV,photo,self.tokenID];
    NSString *photoStr = [photo stringByAppendingFormat:@"&token=%@",self.tokenID];
    //    NSLog(@"图片路径%@",photoStr);
    photoCtl *pctl = [[photoCtl alloc]init];
    pctl.photoStr =photoStr;
    [self.navigationController pushViewController:pctl animated:YES];
}
- (void)openThePPT:(NSArray*)ppt{
    //    NSLog(@"数组个数%ld",ppt.count);
    self.navigationController.navigationBar.hidden=NO;
    FocusCtl *focus = [[FocusCtl alloc]init];
    NSMutableArray *arrays = [NSMutableArray array];
    for (NSString *str in ppt) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",SRV,str];
        [arrays addObject:urlStr];
    }
    focus.arrays = arrays;
    [self.navigationController pushViewController:focus animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.currentPoint = scrollView.contentOffset;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
            __weak typeof(self) weakSelf = self;
    if (self.currentPoint.y<=scrollView.contentOffset.y) {

        [UIView animateWithDuration:0.6 animations:^{
            //隐藏
            weakSelf.navigationController.navigationBar.hidden=YES;
            if (weakSelf.mpCtl) {
                weakSelf.mpCtl.view.y=20;
                weakSelf.wkView.y=CGRectGetMaxY(self.mpCtl.view.frame);
            }else{
                weakSelf.wkView.y=20;
            }
            weakSelf.hidden=YES;
        } completion:^(BOOL finished) {
        }];
    }else{   self.navigationController.navigationBar.hidden=NO;
        [UIView animateWithDuration:0.6 animations:^{
            //不隐藏

            if (weakSelf.mpCtl) {
                weakSelf.mpCtl.view.y=64;
                weakSelf.wkView.y=CGRectGetMaxY(self.mpCtl.view.frame);
            }else{
                weakSelf.wkView.y=20;
            }
            weakSelf.hidden=NO;
        }];
    }
}

- (IBAction)goToGroup:(UIButton *)sender {
        [self.view viewWithpopUp:@"还在努力的建设中..." time:1];
    self.groupBtn.selected = YES;
    self.teacherBtn.selected = NO;
    self.notesBtn.selected = NO;
}
- (IBAction)goToTeacher:(UIButton *)sender {
        [self.view viewWithpopUp:@"还在努力的建设中..." time:1];
    self.teacherBtn.selected = YES;
    self.groupBtn.selected = NO;
    self.notesBtn.selected = NO;
}
- (IBAction)goToNotes:(UIButton *)sender {
        [self.view viewWithpopUp:@"还在努力的建设中..." time:1];
    self.notesBtn.selected = YES;
    self.groupBtn.selected = NO;
    self.teacherBtn.selected = NO;
    
}

-(void)closeWindow{
    [self.mpCtl stop];
    [self.mpCtl.view removeFromSuperview];
    self.mpCtl=nil;
    self.wkView.y=20;
}
//菜单栏按钮
- (void)goToList:(UIButton *)sender {
    NSLog(@"打开目录");
        [self.view viewWithpopUp:@"还在努力的建设中..." time:1];
}
- (void)getBack:(UIButton *)sender {
    NSLog(@"返回菜单");

    UIApplication *app = [UIApplication sharedApplication];
    app.statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:32.0/255.0 green:191.0/255.0 blue:184.0/255.0 alpha:1.0]];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)goToNews:(UIButton *)sender {
    NSLog(@"进入动态");
        [self.view viewWithpopUp:@"还在努力的建设中..." time:1];
}
- (void)goToEvaluate:(UIButton *)sender {
    NSLog(@"去到评测");
        [self.view viewWithpopUp:@"还在努力的建设中..." time:1];
}
- (void)setButtons{
    [self.groupBtn setImage:[[UIImage imageNamed:@"ln_group"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.groupBtn setImage:[[UIImage imageNamed:@"ln_groupDown"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];

    [self.teacherBtn setImage:[[UIImage imageNamed:@"ln_guidingTeacherD"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [self.teacherBtn setImage:[[UIImage imageNamed:@"ln_guidingTeacher"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

    [self.notesBtn setImage:[[UIImage imageNamed:@"ln_noteDown"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [self.notesBtn setImage:[[UIImage imageNamed:@"ln_notes"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
}


@end
