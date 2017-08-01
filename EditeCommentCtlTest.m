//
//  EditeCommentCtlTest.m
//  rcpi
//
//  Created by admin on 15/12/24.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "Config.h"
#import "EditeCommentCtl.h"

@interface EditeCommentCtlTest : XCTestCase<NSBoolable>

@property (nonatomic,retain) EditeCommentCtl *editCtl;
@property (readonly) BOOL boolValue;

@end

@implementation EditeCommentCtlTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [self performSelector:@selector(load) withObject:nil afterDelay:YES];
}

- (void)load{
    //new the view controller.
    self.editCtl=[[EditeCommentCtl alloc]init];
    UINavigationController* nv=(UINavigationController*)[[[UIApplication sharedApplication]keyWindow]rootViewController];
    //adding to UINavigationController
    [nv pushViewController:self.editCtl animated:YES];
}


- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.editCtl = nil;
}
- (void)testEdit
{
    [self.editCtl performSelectorOnMainThread:@selector(setNav) withObject:nil waitUntilDone:YES];
    [self.editCtl performSelectorOnMainThread:@selector(addTextView) withObject:nil waitUntilDone:YES];
    [self.editCtl performSelectorOnMainThread:@selector(textViewDidChange:) withObject:self.editCtl.textView waitUntilDone:YES];
    [self.editCtl performSelectorOnMainThread:@selector(textViewDidEndEditing:) withObject:self.editCtl.textView waitUntilDone:YES];
}
- (void)testTextView
{
    self.editCtl.topicId = @"21350";
    [self.editCtl performSelectorOnMainThread:@selector(rightbtnClick) withObject:nil waitUntilDone:YES];
    //[self.editCtl performSelectorOnMainThread:@selector(addTextView) withObject:nil waitUntilDone:YES];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
