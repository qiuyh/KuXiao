//
//  CourseDetailsTest.m
//  rcpi
//
//  Created by user on 15/10/15.
//  Copyright (c) 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <iwf/iwf.h>
#import "CourseDetailsViewController.h"

@interface CourseDetailsTest : XCTestCase<NSBoolable>

@property (nonatomic,strong)CourseDetailsViewController *courseDetailsVC;
@property (readonly)BOOL boolValue;

@end

@implementation CourseDetailsTest

- (void)setUp {
    [super setUp];
    [self performSelectorOnMainThread:@selector(load) withObject:nil waitUntilDone:YES];

}

- (void)load {
    self.courseDetailsVC = [[CourseDetailsViewController alloc]initWithNibName:nil bundle:[NSBundle bundleForClass:[CourseDetailsViewController class]]];
    UINavigationController *navi = (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    [navi popToRootViewControllerAnimated:YES];
    [navi pushViewController:self.courseDetailsVC animated:YES];
}

- (BOOL)boolValue{
    //checking if view controller is loaded.
    if (self.courseDetailsVC.tableScrollView) {
        //测试通知方法
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSelectedIndexNotification" object:nil userInfo:@{@"selectedIndex":@"2"}];
        return YES;
    }else {
        return NO;
    }
}

- (void)tearDown {
    [super tearDown];
    self.courseDetailsVC = nil;
}

- (void)testCourseDetailsViewController {

    self.courseDetailsVC.courseID = @"860";
    self.courseDetailsVC.introduceViewHeight = 400;
    //    XCTAssert(RunLoopv(self),@"time out");

    //点击目录按钮
    [self.courseDetailsVC performSelectorOnMainThread:@selector(openMenuBtnView:) withObject:nil waitUntilDone:YES];
    [self.courseDetailsVC.navigationController popViewControllerAnimated:YES];
    //点击打开右滑菜单
    [self.courseDetailsVC performSelectorOnMainThread:@selector(moreClicket) withObject:nil waitUntilDone:YES];
    //点击关闭右滑菜单
    [self.courseDetailsVC performSelectorOnMainThread:@selector(moreClicket) withObject:nil waitUntilDone:YES];
    //测试ScrollView代理方法
    [self.courseDetailsVC scrollViewWillBeginDragging:self.courseDetailsVC.tableScrollView];
    CGPoint firstPoint = CGPointMake(10, 0);
    CGPoint secondPoint = CGPointMake(320, 0);
    [self.courseDetailsVC scrollViewWillEndDragging:self.courseDetailsVC.tableScrollView withVelocity:firstPoint targetContentOffset:&secondPoint];
    //测试展开收缩
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.courseDetailsVC tableView:self.courseDetailsVC.introduceTableView didSelectRowAtIndexPath:indexPath];
    [self.courseDetailsVC tableView:self.courseDetailsVC.introduceTableView didSelectRowAtIndexPath:indexPath];
    [self.courseDetailsVC performSelectorOnMainThread:@selector(clicketMore) withObject:nil waitUntilDone:YES];
    [self.courseDetailsVC performSelectorOnMainThread:@selector(clicketMore) withObject:nil waitUntilDone:YES];
    //测试进入课程
    if ([self.courseDetailsVC.clickInBtn.titleLabel.text isEqualToString:@"参与该课程"]) {
        [self.courseDetailsVC performSelectorOnMainThread:@selector(joinCourseDetails:) withObject:nil waitUntilDone:YES];
        [self.courseDetailsVC performSelectorOnMainThread:@selector(joinCourseDetails:) withObject:nil waitUntilDone:YES];
        [self.courseDetailsVC.navigationController popViewControllerAnimated:YES];
    }else {
        [self.courseDetailsVC performSelectorOnMainThread:@selector(joinCourseDetails:) withObject:nil waitUntilDone:YES];
        [self.courseDetailsVC.navigationController popViewControllerAnimated:YES];
    }
    //点击返回按钮
//    [self.courseDetailsVC performSelectorOnMainThread:@selector(goBackClicket) withObject:nil waitUntilDone:YES];
}

@end
