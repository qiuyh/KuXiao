//
//  MenuViewTest.m
//  rcpi
//
//  Created by wu on 15/12/3.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MenuViewController.h"
#import "Config.h"

@interface MenuViewTest : XCTestCase <NSBoolable>
@property (readonly) BOOL boolValue;
@property (nonatomic,strong)MenuViewController *menuVC;
@end

@implementation MenuViewTest

- (void)setUp {
    [super setUp];
    [self performSelectorOnMainThread:@selector(load) withObject:nil waitUntilDone:YES];
}
- (void)load{
    //new the view controller.
    self.menuVC = [[MenuViewController alloc]initWithNibName:nil bundle:[NSBundle bundleForClass:[MenuViewController class]]];
    UINavigationController* nv=(UINavigationController*)[[[UIApplication sharedApplication]keyWindow]rootViewController];
    //adding to UINavigationController
    [nv popToRootViewControllerAnimated:NO];
    [nv pushViewController:self.menuVC animated:YES];
}
- (void)tearDown {
    self.menuVC = nil;
    [super tearDown];
}

- (BOOL)boolValue{
    return YES;
}
- (void)testMenu{

    XCTAssert(RunLoopv(self),@"time out");
    [self.menuVC tableView:self.menuVC.judgeTableView cellForRowAtIndexPath:nil];
    DYTextView *text = [[DYTextView alloc]init];
    text.text = @"测试";
    text.placehoder =@"提示语";
    text.placehoderColor =[UIColor yellowColor];
    LoadingView *load = [[LoadingView alloc]init];
    [load startWaiting];
    [load stopWaiting];
}





- (void)testMenuViewController {
    self.menuVC.courseID = @"29786";
    self.menuVC.selectedIndex = 0;
    XCTAssert(RunLoopv(self),@"time out");

    //点击打开右滑菜单
    [self.menuVC performSelectorOnMainThread:@selector(moreClicket) withObject:nil waitUntilDone:YES];
    //点击关闭右滑菜单
    [self.menuVC performSelectorOnMainThread:@selector(moreClicket) withObject:nil waitUntilDone:YES];
    //测试ScrollView代理方法
    [self.menuVC scrollViewWillBeginDragging:self.menuVC.tableScrollView];
    CGPoint firstPoint = CGPointMake(10, 0);
    CGPoint secondPoint = CGPointMake(320, 0);
    [self.menuVC scrollViewWillEndDragging:self.menuVC.tableScrollView withVelocity:firstPoint targetContentOffset:&secondPoint];
    //测试切换按钮
    UIButton *btn = [[UIButton alloc]init];
    for (int i = 0; i < 5; i++) {
        btn.tag = i;
        [self.menuVC changeSelectedIndex:btn];
    }
    //测试点击Cell跳转
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.menuVC tableView:self.menuVC.menuTableView didSelectRowAtIndexPath:indexPath];
    [self.menuVC.navigationController popViewControllerAnimated:YES];
    //测试进入课程
    if ([self.menuVC.clickInBtn.titleLabel.text isEqualToString:@"参与该课程"]) {
        [self.menuVC performSelectorOnMainThread:@selector(joinCourseDetails:) withObject:nil waitUntilDone:YES];
        [self.menuVC performSelectorOnMainThread:@selector(joinCourseDetails:) withObject:nil waitUntilDone:YES];
        [self.menuVC.navigationController popViewControllerAnimated:YES];
    }else {
        [self.menuVC performSelectorOnMainThread:@selector(joinCourseDetails:) withObject:nil waitUntilDone:YES];
        [self.menuVC.navigationController popViewControllerAnimated:YES];
    }
}

//测试不同按钮跳进页面时的定位
- (void)testMenuViewController2 {
    self.menuVC.courseID = @"29786";
    self.menuVC.selectedIndex = 1;
    XCTAssert(RunLoopv(self),@"time out");

}

- (void)testMenuViewController3 {
    self.menuVC.courseID = @"29786";
    self.menuVC.selectedIndex = 2;
    XCTAssert(RunLoopv(self),@"time out");

}

- (void)testMenuViewController4 {
    self.menuVC.courseID = @"29786";
    self.menuVC.selectedIndex = 3;
    XCTAssert(RunLoopv(self),@"time out");
}

- (void)testMenuViewController5 {
    self.menuVC.courseID = @"29786";
    self.menuVC.selectedIndex = 4;
    XCTAssert(RunLoopv(self),@"time out");

}
@end