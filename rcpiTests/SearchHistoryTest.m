//
//  SearchHistoryTest.m
//  rcpi
//
//  Created by Dyang on 15/12/3.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "Config.h"
#import "HistorySearchController.h"

@interface SearchHistoryTest : XCTestCase<NSBoolable>
@property(nonatomic,retain)HistorySearchController *hisControl;
@property(readonly) BOOL boolValue;

@end

@implementation SearchHistoryTest

- (void)setUp {
    [super setUp];
    [self performSelectorOnMainThread:@selector(load) withObject:nil waitUntilDone:YES];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    self.hisControl=nil;
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)load{
    //new the view controller.
    self.hisControl=[[HistorySearchController alloc]initWithNibName:nil bundle:[NSBundle bundleForClass:[HistorySearchController class]]];
    UINavigationController* nv=(UINavigationController*)[[[UIApplication sharedApplication]keyWindow]rootViewController];
    //adding to UINavigationController
    [nv pushViewController:self.hisControl animated:YES];
}
- (BOOL)boolValue{
    //checking if view controller is loaded.
    return YES;
}

- (void)testSearchHttp {
    // XCTAssert(RunLoopv(self),@"time out");
    
    [self.hisControl performSelectorOnMainThread:@selector(goBackFirstPage) withObject:nil waitUntilDone:YES];
    [self.hisControl performSelectorOnMainThread:@selector(getHotData) withObject:nil waitUntilDone:YES];
    [self.hisControl performSelectorOnMainThread:@selector(addSearchData:) withObject:@"test" waitUntilDone:YES];
    [self.hisControl performSelectorOnMainThread:@selector(updateDataFile) withObject:nil waitUntilDone:YES];
    [self.hisControl performSelectorOnMainThread:@selector(getLocalData) withObject:nil waitUntilDone:YES];
    [self.hisControl performSelectorOnMainThread:@selector(deleteHistoryData) withObject:nil waitUntilDone:YES];
    [self.hisControl performSelectorOnMainThread:@selector(clickSearch) withObject:nil waitUntilDone:YES];
    [self.hisControl performSelectorOnMainThread:@selector(setHotButton) withObject:nil waitUntilDone:YES];
    [self.hisControl performSelectorOnMainThread:@selector(jumpHotCourse:) withObject:nil waitUntilDone:YES];
}
-(void)testTableViewUi{
    NSIndexPath *IndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.hisControl tableView:self.hisControl.courseHistoryTableView cellForRowAtIndexPath:IndexPath];
    [self.hisControl tableView:self.hisControl.courseHistoryTableView didSelectRowAtIndexPath:IndexPath];
    [self.hisControl tableView:self.hisControl.courseHistoryTableView heightForRowAtIndexPath:IndexPath];
    NSIndexPath *courseIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.hisControl tableView:self.hisControl.courseHistoryTableView cellForRowAtIndexPath:courseIndexPath];
}



@end
