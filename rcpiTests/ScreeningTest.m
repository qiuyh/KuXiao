//
//  ScreeningTest.m
//  rcpi
//
//  Created by wu on 15/11/11.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <iwf/iwf.h>
#import "ScreeningController.h"
@interface ScreeningTest : XCTestCase<NSBoolable>

@property (readonly) BOOL boolValue;
@property (nonatomic,strong)ScreeningController *screen;
@end

@implementation ScreeningTest

- (void)setUp {
    [super setUp];
    [self performSelectorOnMainThread:@selector(load) withObject:nil waitUntilDone:YES];
}

- (void)load{
    //new the view controller.
    self.screen=[[ScreeningController alloc]initWithNibName:nil bundle:[NSBundle bundleForClass:[ScreeningController class]]];
    UINavigationController* nv=(UINavigationController*)[[[UIApplication sharedApplication]keyWindow]rootViewController];
    //adding to UINavigationController
    [nv pushViewController:self.screen animated:YES];
}

- (void)tearDown {
    self.screen=nil;
    [super tearDown];
}
- (BOOL)boolValue{
    return YES;
}
- (void)testScreening{
    //    -(void)leftbtnClick;
    //    -(void)rightbtnClick;
    //    - (IBAction)selectedTeacherClass:(UIButton *)button;
    //    - (IBAction)OneBtn:(UIButton *)sender;
    //    - (IBAction)TwoBtn:(UIButton *)sender;
    //    - (IBAction)ThreeBtn:(UIButton *)sender;
    //    - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
    //    - (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;
    //    - (IBAction)goToScreening:(UIButton *)sender;
    //    - (void)closeMenu;
    //    - (BOOL)isNeedRefresh:(UITableExtView *)tableview;
    //    - (void)onRefresh:(UITableExtView *)tableview;
    //    - (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    [self.screen leftbtnClick];
    [self.screen rightbtnClick];
    [self.screen selectedTeacherClass:nil];
    [self.screen OneBtn:nil];
    [self.screen TwoBtn:nil];
    [self.screen ThreeBtn:nil];
    [self.screen goToScreening:nil];
    [self.screen closeMenu];

    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.screen tableView:self.screen.leftFirstTableView cellForRowAtIndexPath:path];
    [self.screen tableView:self.screen.leftSecondTableView cellForRowAtIndexPath:path];
    //点击cell
    [self.screen tableView:(UITableView*)self.screen.tableView didSelectRowAtIndexPath:path];
    [self.screen tableView:(UITableView*)self.screen.leftFirstTableView didSelectRowAtIndexPath:path];
    [self.screen tableView:(UITableView*)self.screen.leftSecondTableView didSelectRowAtIndexPath:path];
    //取消点击cell
    [self.screen tableView:(UITableView*)self.screen.leftFirstTableView didDeselectRowAtIndexPath:path];
    [self.screen tableView:(UITableView*)self.screen.leftSecondTableView didDeselectRowAtIndexPath:path];

    [self.screen isNeedRefresh:self.screen.tableView];
    [self.screen onRefresh:self.screen.tableView];
    
}

@end
