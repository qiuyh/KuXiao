//
//  ExamDetailsTest.m
//  rcpi
//
//  Created by wu on 15/11/25.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ExamDetailsCtl.h"
#import <iwf/iwf.h>
#import "Config.h"
@interface ExamDetailsTest : XCTestCase <NSBoolable>
@property (readonly) BOOL boolValue;
@property (nonatomic,strong)ExamDetailsCtl *exam;
@end

@implementation ExamDetailsTest

- (void)setUp {
    [super setUp];
    [self performSelectorOnMainThread:@selector(load) withObject:nil waitUntilDone:YES];
}
- (void)load{
    //new the view controller.
    self.exam = [[ExamDetailsCtl alloc]initWithNibName:nil bundle:[NSBundle bundleForClass:[ExamDetailsCtl class]]];
    UINavigationController* nv=(UINavigationController*)[[[UIApplication sharedApplication]keyWindow]rootViewController];
    //adding to UINavigationController
    [nv popToRootViewControllerAnimated:NO];
    NSMutableArray *data = [NSMutableArray array];
    for (int i=0; i<3; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"seq"] =[NSString stringWithFormat:@"%d",i];
        dic[@"id"] = [NSString stringWithFormat:@"%d",98703+i];
        dic[@"qGrp"] = [NSString stringWithFormat:@"1448505457"];
        dic[@"name"] = [NSString stringWithFormat:@"题目%d",i+1];
        dic[@"desc"] = [NSString stringWithFormat:@"<p>1、鲜花敬英雄，浩气存天地。党和国家领导人习近平、李克强、张德江、刘云山、王岐山、张高丽等，同首都各界代表一起出席仪式。当日，故宫博物院将正式对观众开放宝蕴楼、慈宁宫区域、午门雁翅楼区域、东华门等四个新的区域，使故宫的开放面积由目前带给观众更加完整丰富的参观体验。</p>"];
//        NSString *num = [NSString stringWithFormat:@"%d",i];
//        [self.exam.textContent setObject:@"abcdefghijklmnopqrstuvwxyz" forKey:num];
        [data addObject:dic];
    }
    self.exam.dataArray = data;

    [nv pushViewController:self.exam animated:YES];
}
- (void)tearDown {
    self.exam = nil;
    [super tearDown];
}

- (BOOL)boolValue{
    return self.exam.dataArray;
}
- (void)testExam{

    XCTAssert(RunLoopv(self),@"time out");
//    - (void)upLoadData;
//    - (void)scrollViewDidScroll:(UIScrollView *)scrollView;
//    - (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
//    [self.exam scrollViewDidScroll:self.exam.collectionView];
    [self.exam scrollViewWillBeginDragging:self.exam.collectionView];
}

@end
