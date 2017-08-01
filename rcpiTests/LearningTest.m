//
//  LearningTest.m
//  rcpi
//
//  Created by wu on 15/10/25.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <iwf/iwf.h>
#import "LearningContentCtl.h"
#import "Config.h"
@interface LearningTest : XCTestCase  <NSBoolable>
@property (readonly) BOOL boolValue;
@property (nonatomic,strong)LearningContentCtl *learn;
@end

@implementation LearningTest

- (void)setUp {
    [super setUp];
    [self performSelectorOnMainThread:@selector(load) withObject:nil waitUntilDone:YES];
}
- (void)load{
    //new the view controller.
    self.learn = [[LearningContentCtl alloc]initWithNibName:nil bundle:[NSBundle bundleForClass:[LearningContentCtl class]]];
    UINavigationController* nv=(UINavigationController*)[[[UIApplication sharedApplication]keyWindow]rootViewController];
    //adding to UINavigationController
    [nv pushViewController:self.learn animated:YES];
}
- (void)tearDown {
    self.learn=nil;
    [super tearDown];
}

- (BOOL)boolValue{
    return YES;
}
- (void)testLearning{

    XCTAssert(RunLoopv(self),@"time out");
    //菜单栏按钮
    [self.learn goToGroup:nil];
    [self.learn goToTeacher:nil];
    [self.learn goToNotes:nil];
    [self.learn getBack:nil];
    [self.learn goToList:nil];
    [self.learn goToNews:nil];
    [self.learn goToEvaluate:nil];
    [self.learn closeWindow];

    [self.learn webView:self.learn.wkView didFailProvisionalNavigation:nil withError:nil];
    [self.learn webView:self.learn.wkView didFinishNavigation:nil];
    //     link = "http://esp.aikexue.com/canluanlifuchudexinshengming/"
    [self.learn userContentController:nil didReceiveScriptMessage:nil];
    //与网页交互后进行处理
    [self.learn openTheLink:nil];
    [self.learn dismissViewControllerAnimated:YES completion:nil];
    [self.learn openThePhoto:nil];
    [self.learn openThePPT:nil];
    [self.learn openThePractise:nil];
    [self.learn openTheVideo:nil];
    //滚动测试
    [self.learn scrollViewWillBeginDragging:nil];
    [self.learn performSelectorOnMainThread:@selector(scrollViewDidEndDragging:willDecelerate:) withObject:nil waitUntilDone:YES];

    CGPoint point = CGPointMake(0, -10);
    UIScrollView *scroll = [[UIScrollView alloc]init];
    scroll.contentOffset = point;
    [self.learn scrollViewDidEndDragging:scroll willDecelerate:YES];
    self.learn.mpCtl = [[MPMoviePlayerController alloc]init];
    self.learn.hidden=YES;
    [self.learn openTheVideo:nil];

}

@end
