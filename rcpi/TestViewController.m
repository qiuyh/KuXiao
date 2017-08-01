//
//  TestViewController.m
//  rcpi
//
//  Created by admin on 15/12/24.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "TestViewController.h"
#import <iwf/iwf.h>
#import "Config.h"
#import "DiscussionCell.h"


@interface TestViewController ()<UITableViewDataSource,UITableExtViewDelegate>

@property (nonatomic,strong)UITableExtView * discussTableView;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    
    self.discussTableView = [[UITableExtView alloc]initWithFrame:CGRectMake(0, 0, kScreen.width, kScreen.height -  49)];
    self.discussTableView.delegate = self;
    self.discussTableView.dataSource = self;
    self.discussTableView.scrollEnabled = YES;
    self.discussTableView.backgroundColor = [UIColor whiteColor];
    self.discussTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.discussTableView setSeparatorInset:UIEdgeInsetsZero];
    
    [self.view addSubview:self.discussTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *celld = @"cell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:celld];
    if (! cell) {
        cell = [[UITableViewCell alloc]init];
    }
    //cell.textLabel.text = [NSString stringWithFormat:@"==%d",indexPath.row];
    cell.textLabel.text= @"wwwww";
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen.width, 40)];
    view.backgroundColor = [UIColor redColor];
    return view;
}

- (void)onNextPage:(UITableExtView *)tableview
{
    NSLog(@"进来了");
}
- (void)dealloc
{
    NSLog(@"djdjdj");
}

- (BOOL)isNeedRefresh:(UITableExtView *)tableview
{
    return  YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
