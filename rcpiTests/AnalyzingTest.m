//
//  AnalyzingTest.m
//  rcpi
//
//  Created by wu on 15/11/25.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AnalyzingCtl.h"
#import <iwf/iwf.h>
#import "Config.h"
@interface AnalyzingTest : XCTestCase <NSBoolable>
@property (readonly) BOOL boolValue;
@property (nonatomic,strong)AnalyzingCtl *analyz;
@end

@implementation AnalyzingTest


- (void)setUp {
    [super setUp];
    [self performSelectorOnMainThread:@selector(load) withObject:nil waitUntilDone:YES];
}
- (void)load{
    //new the view controller.
    self.analyz = [[AnalyzingCtl alloc]initWithNibName:nil bundle:[NSBundle bundleForClass:[AnalyzingCtl class]]];
    UINavigationController* nv=(UINavigationController*)[[[UIApplication sharedApplication]keyWindow]rootViewController];
    //adding to UINavigationController
    [nv popToRootViewControllerAnimated:NO];
    [nv pushViewController:self.analyz animated:YES];
}
- (void)tearDown {
    self.analyz = nil;
    [super tearDown];
}

- (BOOL)boolValue{
    return YES;
}
- (void)testAnalyz{
    [self.analyz comeback];
    [self.analyz oneClick];
    DYTextView *text = [[DYTextView alloc]init];
    text.text = @"测试";
    text.placehoder =@"提示语";
    text.placehoderColor =[UIColor yellowColor];
    LoadingView *load = [[LoadingView alloc]init];
    [load startWaiting];
    [load stopWaiting];

}

@end
