//
//  QuestionTest.m
//  rcpi
//
//  Created by wu on 15/11/25.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QuestionTypesCtl.h"
#import <iwf/iwf.h>
#import "Config.h"
@interface QuestionTest : XCTestCase <NSBoolable>
@property (readonly) BOOL boolValue;
@property (nonatomic,strong)QuestionTypesCtl *quest;
@end

@implementation QuestionTest
- (void)setUp {
    [super setUp];
    [self performSelectorOnMainThread:@selector(load) withObject:nil waitUntilDone:YES];
}
- (void)load{
    //new the view controller.
    self.quest = [[QuestionTypesCtl alloc]initWithNibName:nil bundle:[NSBundle bundleForClass:[QuestionTypesCtl class]]];
    UINavigationController* nv=(UINavigationController*)[[[UIApplication sharedApplication]keyWindow]rootViewController];

    [nv popToRootViewControllerAnimated:NO];
    [nv pushViewController:self.quest animated:YES];
}
- (void)tearDown {
    self.quest=nil;
    [super tearDown];
}

- (BOOL)boolValue{
    return self.quest.dataArray;
//    return YES;
}
- (void)testQuest{

    self.quest.p2bID = @10693;
    self.quest.bankID =@54793;
    [self.quest performSelectorOnMainThread:@selector(network) withObject:nil waitUntilDone:YES];
    XCTAssert(RunLoopv(self),@"time out");
    self.quest.type =YES;
    [self.quest tableView:self.quest.tableView didSelectRowAtIndexPath:nil];
    //    [self.quest tableView:self.quest.tableView willDisplayCell:nil forRowAtIndexPath:nil];
    //    [self.quest tableView:self.quest.tableView cellForRowAtIndexPath:nil ];

    
}

@end
