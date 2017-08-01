//
//  QuestionTypesCtl.h
//  rcpi
//
//  Created by wu on 15/11/15.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "EvaluationCell.h"
#import "ExamDetailsCtl.h"
#import "ExamOne.h"
#import "AnalyzingCtl.h"
#import "ObjectiveItemCtl.h"

@interface QuestionTypesCtl : UIViewController <UITableViewDataSource,UITableViewDelegate,UITableExtViewDelegate>
@property (nonatomic,strong)NSNumber *bankID;
@property (nonatomic,strong)NSNumber *p2bID;
@property (nonatomic,strong)NSArray *paperRecord;
@property (nonatomic,strong)NSString *examName;

@property (nonatomic,strong)NSString *pid;
@property (nonatomic,strong)NSString *aid;
@property (nonatomic,assign)BOOL type;

@property (nonatomic,strong)UITableExtView *tableView;
@property (nonatomic,strong)NSArray *dataArray;

//test

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)network;
@end
