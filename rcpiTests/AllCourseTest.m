//
//  AllCourseTest.m
//  rcpi
//
//  Created by wu on 15/11/11.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AllCourseCtl.h"
#import <iwf/iwf.h>
#import "Config.h"
@interface AllCourseTest : XCTestCase<NSBoolable>
@property (readonly) BOOL boolValue;
@property (nonatomic,strong)AllCourseCtl *all;
//@property (assign)int type;

@end

@implementation AllCourseTest

- (void)setUp {
    [super setUp];
    [self performSelectorOnMainThread:@selector(load) withObject:nil waitUntilDone:YES];
}

- (void)load{
    //new the view controller.
    self.all=[[AllCourseCtl alloc]initWithNibName:nil bundle:[NSBundle bundleForClass:[AllCourseCtl class]]];
    UINavigationController* nv=(UINavigationController*)[[[UIApplication sharedApplication]keyWindow]rootViewController];
    //adding to UINavigationController
    [nv pushViewController:self.all animated:YES];
}

- (void)tearDown {
    self.all=nil;
    [super tearDown];
}

- (BOOL)boolValue{
    return YES;
}

- (void)testAllCourse {
    XCTAssert(RunLoopv(self),@"time out");
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];

    [self.all collectionView:self.all.collectionView didSelectItemAtIndexPath:path];
    [self.all leftbtnClick];
    self.all.strClass = @"/get-all-ta";
    [self.all performSelectorOnMainThread:@selector(setUpNetwork) withObject:nil waitUntilDone:YES];

}

@end
