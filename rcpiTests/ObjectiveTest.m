//
//  ObjectiveTest.m
//  rcpi
//
//  Created by wu on 15/12/15.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <XCTest/XCTest.h>
#import <iwf/iwf.h>
#import "Config.h"
#import "ObjectiveItemCtl.h"
#import "ExamOne.h"
@interface ObjectiveTest : XCTestCase<NSBoolable>
@property (readonly) BOOL boolValue;
@property (nonatomic,strong)ObjectiveItemCtl *obj;
@property (nonatomic,strong)NSDictionary *args;

@end

@implementation ObjectiveTest

- (void)setUp {
    [super setUp];
    [self performSelectorOnMainThread:@selector(load) withObject:nil waitUntilDone:YES];
}
- (void)load{
    //new the view controller.
    self.obj = [[ObjectiveItemCtl alloc]initWithNibName:nil bundle:[NSBundle bundleForClass:[ObjectiveItemCtl class]]];
    UINavigationController* nv=(UINavigationController*)[[[UIApplication sharedApplication]keyWindow]rootViewController];

    [nv popToRootViewControllerAnimated:NO];
    [nv pushViewController:self.obj animated:YES];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"hello" ofType:@"plist"]];
    self.args = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"args" ofType:@"plist"]];
        self.obj.aid = @"8888";
        self.obj.qGroupID =   @"6666";
        self.obj.dataArray = [ExamTwo appWithArray:dic[@"data"][@"qParse"][0][@"questions"]];
}
- (void)tearDown {
    self.obj=nil;
    [super tearDown];
}

- (BOOL)boolValue{
    return (BOOL)self.obj.dataArray;
    //    return YES;
}
- (void)testObj{

    XCTAssert(RunLoopv(self),@"time out");

    [self.obj oneClick];
    UIScrollView *scroll = [[UIScrollView alloc]init];
    scroll.contentOffset = CGPointMake(1, 1);
    [self.obj scrollViewDidScroll:scroll];
    for (int i=0; i<=self.obj.dataArray.count; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
        [self.obj collectionView:self.obj.collectionView cellForItemAtIndexPath:index];
    }
//    @"http://ebs2.dev.jxzy.com/usr/submit-answer"
    NSString *url = [NSString stringWithFormat:@"%@/submit-answer",ANSWER];
    [self.obj networkAndUrl:url dargs:self.args];
    //错误的信息
    NSString *url_no = [NSString stringWithFormat:@"%@/submit-ansr",ANSWER];
    [self.obj networkAndUrl:url_no dargs:self.args];




    
}

@end
