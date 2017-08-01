//
//  FirstPageTest.m
//
//
//  Created by wu on 15/10/15.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "FirstController.h"
#import <iwf/iwf.h>
@interface FirstPageTest : XCTestCase <NSBoolable>
@property (nonatomic,strong) FirstController*firstCtl;
@property (assign)int type;
@end

@implementation FirstPageTest

- (void)setUp {
    [super setUp];
    [self performSelectorOnMainThread:@selector(load) withObject:nil waitUntilDone:YES];
}
- (void)load{
    //new the view controller.
    self.firstCtl=[[FirstController alloc]initWithNibName:nil bundle:[NSBundle bundleForClass:[FirstController class]]];
    UINavigationController* nv=(UINavigationController*)[[[UIApplication sharedApplication]keyWindow]rootViewController];
    //adding to UINavigationController
    [nv popToRootViewControllerAnimated:NO];
    [nv pushViewController:self.firstCtl animated:YES];
}

- (void)tearDown {
    self.firstCtl=nil;
    [super tearDown];
    //    UINavigationController* nv=(UINavigationController*)[[[UIApplication sharedApplication]keyWindow]rootViewController];
    //    [nv popToRootViewControllerAnimated:YES];
}

- (BOOL)boolValue{
    return self.firstCtl.arr;
}

- (void)testFirstCtl{
    // XCTAssert(RunLoopv(self),@"time out");
    //    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    //    [self.firstCtl collectionView:self.firstCtl.collectionView cellForItemAtIndexPath:path];
    //拖动代理
    [self.firstCtl collectionView:nil layout:nil sizeForItemAtIndexPath:nil];
    [self.firstCtl scrollViewWillBeginDragging:nil];
    [self.firstCtl scrollViewDidEndDragging:self.firstCtl.scrollView willDecelerate:nil];

    [self.firstCtl collectionView:self.firstCtl.collectionView didSelectItemAtIndexPath:nil];
    [self.firstCtl.navigationController popViewControllerAnimated:YES];

    //测试网络不通
    self.firstCtl.apiStr = @"/indexcourse-litt";
    [self.firstCtl performSelectorOnMainThread:@selector(network) withObject:self waitUntilDone:YES];
    //测试点击按钮
    [self.firstCtl leftBtnClick];
    [self.firstCtl rightbtnClick];
    [self.firstCtl.navigationController popViewControllerAnimated:YES];
    [self.firstCtl clickBut];
    [self.firstCtl.navigationController popViewControllerAnimated:YES];
    
}
@end
