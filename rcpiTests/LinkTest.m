//
//  LinkTest.m
//  rcpi
//
//  Created by wu on 15/11/11.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <iwf/iwf.h>
#import "LinkCtl.h"
@interface LinkTest : XCTestCase <NSBoolable>
@property (readonly) BOOL boolValue;
@property (nonatomic,strong)LinkCtl *link;
@end

@implementation LinkTest

- (void)setUp {
    [super setUp];
    [self performSelectorOnMainThread:@selector(load) withObject:nil waitUntilDone:YES];
}
- (void)load{
    //new the view controller.
    self.link = [[LinkCtl alloc]initWithNibName:nil bundle:[NSBundle bundleForClass:[LinkCtl class]]];
    UINavigationController* nv=(UINavigationController*)[[[UIApplication sharedApplication]keyWindow]rootViewController];
    //adding to UINavigationController
    [nv pushViewController:self.link animated:YES];
}
- (void)tearDown {
    self.link=nil;
    [super tearDown];
}
- (BOOL)boolValue{
    return YES;
}

- (void)testLink {
    XCTAssert(RunLoopv(self),@"time out");
    [self.link shouldAutorotate];
    [self.link preferredInterfaceOrientationForPresentation];
    [self.link getBack];
    //    [self.link presentViewController:self.link animated:YES completion:nil];

}

@end
