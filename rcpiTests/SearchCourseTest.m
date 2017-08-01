//
//  SearchCourseTest.m
//  rcpi
//
//  Created by Dyang on 15/11/30.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "Config.h"
#import "SearchCourseController.h"

@interface SearchCourseTest : XCTestCase<NSBoolable>
@property (nonatomic,retain) SearchCourseController *searchControl;
@property (readonly) BOOL boolValue;
@end

@implementation SearchCourseTest

- (void)setUp {
    [super setUp];
    [self performSelectorOnMainThread:@selector(load) withObject:nil waitUntilDone:YES];
}

- (void)tearDown {
     self.searchControl=nil;
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)load{
    //new the view controller.
    self.searchControl=[[SearchCourseController alloc]initWithNibName:nil bundle:[NSBundle bundleForClass:[SearchCourseController class]]];
    UINavigationController* nv=(UINavigationController*)[[[UIApplication sharedApplication]keyWindow]rootViewController];
    //adding to UINavigationController
    [nv pushViewController:self.searchControl animated:YES];
}
- (BOOL)boolValue{
    //checking if view controller is loaded.
    return YES;
}
- (void)testSearchHttp {
    // XCTAssert(RunLoopv(self),@"time out");
    //test search
    [self.searchControl performSelectorOnMainThread:@selector(clickSearch) withObject:nil waitUntilDone:YES];
    [self.searchControl performSelectorOnMainThread:@selector(nextPageSearch) withObject:nil waitUntilDone:YES];
    
    //test nextPage refresh
    [self.searchControl performSelectorOnMainThread:@selector(isNeedRefresh:) withObject: self.searchControl.courseDataTableView waitUntilDone:YES];
    [self.searchControl performSelectorOnMainThread:@selector(onRefresh:) withObject: self.searchControl.courseDataTableView waitUntilDone:YES];
    [self.searchControl performSelectorOnMainThread:@selector(onNextPage:) withObject: self.searchControl.courseDataTableView waitUntilDone:YES];
    
    
}
-(void)testGoBackButton{
    [self.searchControl performSelectorOnMainThread:@selector(goBackFirstPage) withObject: nil waitUntilDone:YES];
    
}
-(void)testTableViewUi{
    NSIndexPath *IndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.searchControl tableView:self.searchControl.courseDataTableView cellForRowAtIndexPath:IndexPath];
    [self.searchControl tableView:self.searchControl.courseDataTableView didSelectRowAtIndexPath:IndexPath];
    [self.searchControl tableView:self.searchControl.courseDataTableView heightForRowAtIndexPath:IndexPath];
    NSIndexPath *courseIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.searchControl tableView:self.searchControl.courseDataTableView cellForRowAtIndexPath:courseIndexPath];
    
    
}
@end
