//
//  PhotoTest.m
//  rcpi
//
//  Created by wu on 15/11/11.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <iwf/iwf.h>
#import "photoCtl.h"
@interface PhotoTest : XCTestCase <NSBoolable>
@property (readonly) BOOL boolValue;
@property (nonatomic,strong)photoCtl *photo;
@end

@implementation PhotoTest


- (void)setUp {
    [super setUp];
    [self performSelectorOnMainThread:@selector(load) withObject:nil waitUntilDone:YES];
}
- (void)load{
    //new the view controller.
    self.photo = [[photoCtl alloc]initWithNibName:nil bundle:[NSBundle bundleForClass:[photoCtl class]]];
    UINavigationController* nv=(UINavigationController*)[[[UIApplication sharedApplication]keyWindow]rootViewController];
    //adding to UINavigationController
    [nv pushViewController:self.photo animated:YES];
}
- (void)tearDown {
    self.photo=nil;
    [super tearDown];
}
- (BOOL)boolValue{
    return YES;
}

- (void)testPhoto{
    XCTAssert(RunLoopv(self),@"time out");
    self.photo.photoStr = @"http://pb.dev.jxzy.com/img/F100172";
    [self.photo network];
    self.photo.photoStr = @"http://pb.dev.jxzy.com/img/F10017.jpg";
    [self.photo network];
    [self.photo viewForZoomingInScrollView:self.photo.scrollView];
    [self.photo scrollViewDidZoom:self.photo.scrollView];

}

@end
