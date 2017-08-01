//
//  FocusTest.m
//  rcpi
//
//  Created by wu on 15/11/11.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <iwf/iwf.h>
#import "FocusCtl.h"
@interface FocusTest : XCTestCase <NSBoolable>
@property (readonly) BOOL boolValue;
@property (nonatomic,strong)FocusCtl *focus;
@end

@implementation FocusTest

- (void)setUp {
    [super setUp];
    [self performSelectorOnMainThread:@selector(load) withObject:nil waitUntilDone:YES];
}
- (void)load{
    //new the view controller.
    self.focus = [[FocusCtl alloc]initWithNibName:nil bundle:[NSBundle bundleForClass:[FocusCtl class]]];
    UINavigationController* nv=(UINavigationController*)[[[UIApplication sharedApplication]keyWindow]rootViewController];
    //adding to UINavigationController
    [nv pushViewController:self.focus animated:YES];
}
- (void)tearDown {
    self.focus=nil;
    [super tearDown];
}
- (BOOL)boolValue{
    return YES;
}

- (void)testFocus {
    [self.focus showImages:self.focus.arrays];

}

@end
