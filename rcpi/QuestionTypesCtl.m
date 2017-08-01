//
//  QuestionTypesCtl.m
//  rcpi
//
//  Created by wu on 15/11/15.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "QuestionTypesCtl.h"

@interface QuestionTypesCtl ()

@end
#define CELLID @"mycell2"
#define RowH 50
@implementation QuestionTypesCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    [self setUpTableView];
    [self network];
}
- (void)setUpNav{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    self.navigationItem.title = self.examName;
}

- (void)network{
            NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"tokenID"];
    if (self.aid) {
        //查看试卷
        [self networkWithExamDetails:token aid:self.aid paper:self.pid];
    }else{
    //开始作答请求
    NSString *urlStr = [NSString stringWithFormat:@"%@/begin-answer",ANSWER];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"p2bId"] = self.p2bID;
    args[@"bankId"] = self.bankID;
    args[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"tokenID"];
    [H doPost:urlStr dargs:args json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err) {
            NSLog(@"网络请求出错------%@",err.userInfo);
        }else{
            NSLog(@"请求内容如下%@",json);

            if (self.paperRecord!=nil) {
              self.aid = [NSString stringWithFormat:@"%@",json[@"data"]];
            }else{
                self.aid = json[@"data"][@"id"];
            }
            NSString *paperID = json [@"data"][@"pId"];
            NSLog(@"aid=======%@pid=======%@",self.aid,paperID);
            //获取试卷详情
            [self networkWithExamDetails:token aid:self.aid paper:paperID];
        }
    }];
    }
}

- (void)networkWithExamDetails:(NSString*)token aid:(NSString*)aid paper:(NSString*)pid{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/get-paper",ANSWER];
     NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"aid"] = aid;
    args[@"id"] = pid;
    args[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"tokenID"];
    [H doGet:urlStr args:args json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err) {
            NSLog(@"网络请求出错------%@",err.userInfo); 
        }else{
            NSLog(@"试卷详情请求成功---%@",json);
            self.dataArray = [ExamOne appWithArray:json[@"data"][@"qParse"]];
            [self.tableView reloadData];
        }
    }];
}

- (void)setUpTableView{
    self.tableView = [[UITableExtView alloc]initWithFrame:CGRectMake(0, 0, kScreen.width, kScreen.height)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.rowHeight = RowH;
    self.tableView.refreshView.hidden=YES;
    UIView *footV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen.width, 1)];
    footV.backgroundColor = CUSTOM_COLOR(200, 200, 200);
    self.tableView.tableFooterView = footV;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     EvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    if (cell==nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"EvaluationCell" owner:nil options:0][1];
    }
    cell.backgroundColor = [UIColor clearColor];
    ExamOne *one = self.dataArray[indexPath.row];
    cell.typeTitle.text = one.name;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ExamOne *one = self.dataArray[indexPath.row];
    if (self.type) {
        AnalyzingCtl *ana = [[AnalyzingCtl alloc]init];
        ana.dataArray = one.questions;
        ana.aid = self.aid;
        ana.qGroupID = one.qGroupID;
        ana.name = one.name;
        ana.examName = self.examName;
        [self.navigationController pushViewController:ana animated:YES];
    }else{
//        ExamDetailsCtl *details = [[ExamDetailsCtl alloc]init];
//        details.dataArray = one.questions;
//        details.aid = self.aid;
//        details.qGroupID = one.qGroupID;
//        [self.navigationController pushViewController:details animated:YES];
        ObjectiveItemCtl *obj = [[ObjectiveItemCtl alloc]init];
        obj.dataArray = one.questions;
        obj.aid = self.aid;
        obj.qGroupID = one.qGroupID;
        obj.name = one.name;
        obj.examName = self.examName;
        [self.navigationController pushViewController:obj animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
