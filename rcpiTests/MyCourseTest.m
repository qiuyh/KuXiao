//
//  MyCourseTest.m
//  rcpi
//
//  Created by Dyang on 15/12/3.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "Config.h"
#import "MyCourseController.h"

@interface MyCourseTest : XCTestCase<NSBoolable>
@property (nonatomic,retain) MyCourseController *myCourse;
@property (readonly) BOOL boolValue;

@end

@implementation MyCourseTest

- (void)setUp {
    [super setUp];
     [self performSelectorOnMainThread:@selector(load) withObject:nil waitUntilDone:YES];
}

- (void)tearDown {
    self.myCourse=nil;
    [super tearDown];
}

- (void)load{
    //new the view controller.
    self.myCourse=[[MyCourseController alloc]initWithNibName:nil bundle:[NSBundle bundleForClass:[MyCourseController class]]];
    UINavigationController* nv=(UINavigationController*)[[[UIApplication sharedApplication]keyWindow]rootViewController];
    //adding to UINavigationController
    [nv pushViewController:self.myCourse animated:YES];
}
- (BOOL)boolValue{
    //checking if view controller is loaded.
    return YES;
}
-(void)testMyCourseFunc{
    [self.myCourse performSelectorOnMainThread:@selector(searchMyCourse) withObject:nil waitUntilDone:YES];
    [self.myCourse performSelectorOnMainThread:@selector(showIcon) withObject:nil waitUntilDone:YES];
    [self.myCourse performSelectorOnMainThread:@selector(showCourseIcon) withObject:nil waitUntilDone:YES];
    [self.myCourse performSelectorOnMainThread:@selector(searchNextMyCourse) withObject:nil waitUntilDone:YES];
    [self.myCourse performSelectorOnMainThread:@selector(jumpToUserInfo) withObject:nil waitUntilDone:YES];
    [self.myCourse performSelectorOnMainThread:@selector(jumpToSearch) withObject:nil waitUntilDone:YES];
    
    [self.myCourse performSelectorOnMainThread:@selector(jumpToLogin:) withObject:nil waitUntilDone:YES];
    [self.myCourse performSelectorOnMainThread:@selector(jumpToRegister:) withObject:nil waitUntilDone:YES];
    //test nextPage refresh
    [self.myCourse performSelectorOnMainThread:@selector(isNeedRefresh:) withObject: self.myCourse.myCourseTableView waitUntilDone:YES];
    [self.myCourse performSelectorOnMainThread:@selector(onRefresh:) withObject: self.myCourse.myCourseTableView waitUntilDone:YES];
    [self.myCourse performSelectorOnMainThread:@selector(onNextPage:) withObject: self.myCourse.myCourseTableView waitUntilDone:YES];


}

-(void)testTableViewUi{
    NSIndexPath *IndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myCourse tableView:self.myCourse.myCourseTableView cellForRowAtIndexPath:IndexPath];
    [self.myCourse tableView:self.myCourse.myCourseTableView didSelectRowAtIndexPath:IndexPath];
    [self.myCourse tableView:self.myCourse.myCourseTableView heightForRowAtIndexPath:IndexPath];
    NSIndexPath *courseIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myCourse tableView:self.myCourse.myCourseTableView cellForRowAtIndexPath:courseIndexPath];
    
    
}

@end
