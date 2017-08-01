//
//  MenuViewController.m
//  rcpi
//
//  Created by user on 15/10/21.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "MenuViewController.h"
#import "CourseDetailsTools.h"
#import "LearningContentCtl.h"
#import "PublicTool.h"
#import "LoginViewController.h"
#import "Config.h"
#import "EvaluationModel.h"
#import "EvaluationCell.h"
#import "QuestionTypesCtl.h"
@interface MenuViewController ()<UITableExtViewDelegate>

@end

@implementation MenuViewController
#define CELLID @"mycell"
#define RowH 180


- (void)network{
    NSString *str = @"/get-tqe";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SRV,str];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"courseId"]=self.courseID;
    args[@"type"]=@30;
    args[@"token"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"tokenID"];
    args[@"t"]=@"r";
    [H doGet:urlStr args:args json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err) {
            NSLog(@"网络请求失败---%@",err.userInfo);
        }else{

            self.dataArray = [EvaluationModel appWithArray:json[@"data"][@"items"]];
            [self.judgeTableView reloadData];
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self network];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    titleLabel.center=[UIScreen mainScreen].bounds.origin;
    titleLabel.text=@"课程详情";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.moreBtnType = @"OFF";
    self.isLogin = [PublicTool isSuccessLogin];
    

    
    UIButton *moreButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [moreButton setBackgroundImage:[UIImage imageNamed:@"fp_more"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(moreClicket) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *moreBtnItem = [[UIBarButtonItem alloc]initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItem = moreBtnItem;
    
    [self.view addSubview:self.tableScrollView];
    [self.tableScrollView addSubview:self.menuTableView];


    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"com_develop"]];
    imageView2.frame = CGRectMake(self.view.frame.size.width*2, 0,  kScreen.width,kScreen.width/1.6);
    [self.tableScrollView addSubview:imageView2];
    UIImageView *imageView3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"com_develop"]];
    imageView3.frame = CGRectMake(self.view.frame.size.width*3, 0,  kScreen.width,kScreen.width/1.6);
    [self.tableScrollView addSubview:imageView3];
    UIImageView *imageView4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"com_develop"]];
    imageView4.frame = CGRectMake(self.view.frame.size.width*4, 0,  kScreen.width,kScreen.width/1.6);
    [self.tableScrollView addSubview:imageView4];
    [self.tableScrollView addSubview:self.judgeTableView];
//    [self.tableScrollView addSubview:self.teachTableView];
//    [self.tableScrollView addSubview:self.activityTableView];
//    [self.tableScrollView addSubview:self.answerTableView];

    [self.menuTableView.refreshView setHidden:YES];
    [self.judgeTableView.refreshView setHidden:NO];
    [self.teachTableView.refreshView setHidden:YES];
    [self.activityTableView.refreshView setHidden:YES];
    [self.answerTableView.refreshView setHidden:YES];
    
    if (self.courseID != 0) {
        CGPoint tableViewPoint = CGPointMake(self.view.frame.size.width * self.selectedIndex, 0);
        [self.tableScrollView setContentOffset:tableViewPoint animated:YES];
    }
    
    [self.view addSubview:self.headView];
    [self.headView addSubview:self.menuButton];
    [self.headView addSubview:self.answerButton];
    [self.headView addSubview:self.teachButton];
    [self.headView addSubview:self.judgeButton];
    [self.headView addSubview:self.activityButton];
    [self.headView addSubview:self.bottomImageView];
    
    if (!self.courseDetailsArr) {
        if (self.courseID) {
            //获取数据
            CourseDetailsTools *courseDetailsTools = [[CourseDetailsTools alloc]init];
            courseDetailsTools.courseID = self.courseID;
            __weak typeof(self) weakSelf = self;
            [courseDetailsTools getCourseDetailsMenuDataAneCallback:^(id courseDetailsData) {
                weakSelf.courseDetailsArr = courseDetailsData;
                [weakSelf.menuTableView reloadData];
            }];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.menuTableView) {
        return self.courseDetailsArr.count;
    }else if (tableView==self.judgeTableView){
        return self.dataArray.count;
    }
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellOtherID = @"CellID";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellOtherID];
    }
    //评测内容-----》
    if (tableView==self.judgeTableView) {
        EvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
        if (cell==nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"EvaluationCell" owner:nil options:0]firstObject];
        }
        EvaluationModel *model = self.dataArray[indexPath.row];
        if ([model.price intValue]==0) {
            cell.price.text = @"免费";
        }else{
            cell.price.text = [NSString stringWithFormat:@"%@",model.price];
        }
        NSLog(@"status状态==%@",model.status);

        if ([model.status rangeOfString:@"REMARKING"].length!=0 && [[NSUserDefaults standardUserDefaults]objectForKey:@"tokenID"]) {
            cell.waitLabel.hidden=NO;
        }else if ([model.status rangeOfString:@"REMARKED"].length!=0){
            cell.waitLabel.text =@"批改完成";
            cell.waitLabel.hidden=NO;
        }
        cell.examContent.text = model.examName;
        cell.title.text = model.name;
        cell.title.textAlignment=NSTextAlignmentLeft;
        cell.describe.text = [PublicTool filterHTML:model.descriptions];
        cell.timeContent.text = model.time;
        
        return cell;

    }else if (tableView == self.menuTableView) {
        if (self.courseDetailsArr) {
            CourseDetailsTools *courseDetailsToos = self.courseDetailsArr[indexPath.row];
            cell.textLabel.text = courseDetailsToos.name;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *timeLineImageView = [[UIImageView alloc]init];
            [cell.contentView addSubview:timeLineImageView];
            
            if (courseDetailsToos.pid == 0) {
                cell.contentView.backgroundColor = [UIColor colorWithRed:242.0 / 255.0 green:242.0 / 255.0 blue:242.0 / 255.0 alpha:1.0];
                if (indexPath.row == 0) {
                    timeLineImageView.frame = CGRectMake(14.5, 20, 18, 40);
                    timeLineImageView.image = [UIImage imageNamed:@"fp_top"];
                }else if (indexPath.row == self.courseDetailsArr.count - 1) {
                    timeLineImageView.frame = CGRectMake(14.5, 0, 18, 40);
                    timeLineImageView.image = [UIImage imageNamed:@"fp_big-last"];
                }else {
                    timeLineImageView.frame = CGRectMake(14.5, 0, 18, 60);
                    timeLineImageView.image = [UIImage imageNamed:@"fp_big-middle"];
                }
            }else {
                cell.contentView.backgroundColor = [UIColor whiteColor];
                if (indexPath.row == self.courseDetailsArr.count - 1) {
                    timeLineImageView.frame = CGRectMake(17.5, 0, 12, 40);
                    timeLineImageView.image = [UIImage imageNamed:@"fp_small-last"];
                }else {
                    timeLineImageView.frame = CGRectMake(17.5, 0, 12, 60);
                    timeLineImageView.image = [UIImage imageNamed:@"fp_middle"];
                }
            }
            
            CGSize itemSize = CGSizeMake(12.5, 60);
            UIGraphicsBeginImageContext(itemSize);
            CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }else if (tableView == self.rightMenuTableView) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"课程问答";
            [cell.imageView setImage:[UIImage imageNamed:@"course-answers"]];
        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"课程笔记";
            [cell.imageView setImage:[UIImage imageNamed:@"course-notes"]];
        }else if (indexPath.row == 2) {
            cell.textLabel.text = @"成果展示";
            [cell.imageView setImage:[UIImage imageNamed:@"fp_achievements-exhibition"]];
        }else if (indexPath.row == 3) {
            cell.textLabel.text = @"使用情况";
            [cell.imageView setImage:[UIImage imageNamed:@"fp_usage"]];
        }else if (indexPath.row == 4) {
            cell.textLabel.text = @"相关资源";
            [cell.imageView setImage:[UIImage imageNamed:@"fp_related-resources"]];
        }else if (indexPath.row == 5) {
            cell.textLabel.text = @"相关资质";
            [cell.imageView setImage:[UIImage imageNamed:@"fp_relevant-qualifications"]];
        }
    }else {
        cell.textLabel.text = @"test";
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"fp_small-top"];
        }else if (indexPath.row == 29) {
            cell.imageView.image = [UIImage imageNamed:@"fp_small-last"];
        }else {
            cell.imageView.image = [UIImage imageNamed:@"fp_middle"];
        }
    }
    if (tableView==self.menuTableView) {
        if (!self.clickInBtn) {
            self.clickInBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
            self.clickInBtn.backgroundColor = [UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0];
            [self.clickInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.clickInBtn addTarget:self action:@selector(joinCourseDetails:) forControlEvents:UIControlEventTouchUpInside];
            if (self.myType == 1) {
                [self.clickInBtn setTitle:@"进入该课程" forState:UIControlStateNormal];
            }else {
                [self.clickInBtn setTitle:@"参与该课程" forState:UIControlStateNormal];
            }
            [self.view addSubview:self.clickInBtn];
        }
    }
    //页面创建完再创建按钮,确保按钮始终在最上层

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.menuTableView) {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"tokenID"]) {
            if (self.myType == 1) {
                CourseDetailsTools *courseDetailsToos = self.courseDetailsArr[indexPath.row];
                LearningContentCtl *learningContentCtl = [[LearningContentCtl alloc]init];
                learningContentCtl.courseID = courseDetailsToos.cid;
                learningContentCtl.targetID = courseDetailsToos.tid;
                [self.navigationController pushViewController:learningContentCtl animated:YES];
            }else {
                [self popUp:@"请先参与该课程" time:2];
            }
        }else {
            LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            [self.navigationController pushViewController:login animated:YES];
        }
    }
    //评测内容
    if (tableView==self.judgeTableView) {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"tokenID"]) {
            [PublicTool isJoinCourse:self.courseID Callback:^(id isJoin) {
                if ([isJoin integerValue]) {
                    EvaluationCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    QuestionTypesCtl *question = [[QuestionTypesCtl alloc]init];
                    EvaluationModel *model = self.dataArray[indexPath.row];

                    if (cell.waitLabel.isHidden) {
                        question.bankID = model.bankId;
                        question.p2bID = model.p2bId;
                        question.examName = model.examName;
                        question.type = NO;
                        [self.navigationController pushViewController:question animated:YES];
                    }else if ([cell.waitLabel.text isEqualToString:@"批改完成"]){

                        question.pid = model.pid;
                        question.aid = model.aid;
                        question.examName = model.examName;
                        question.type = YES;
                        [self.navigationController pushViewController:question animated:YES];
                }
                }else{
                    //告诉用户参与课程
                    NSLog(@"请先参与课程");
                    [self.view viewWithpopUp:@"请先参与课程" time:1];
                }
            }];
        }else{
            LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            [self.navigationController pushViewController:login animated:YES];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.menuTableView) {
        return 60;
    }else if (tableView==self.judgeTableView) {
        return RowH;
    }else{
        return 40;
    }
}

#pragma mark - getter

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        _headView.backgroundColor = [UIColor whiteColor];
    }
    return _headView;
}

- (UIButton *)menuButton {
    if (!_menuButton) {
        _menuButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 42, 50)];
        [_menuButton setTitle:@"目录" forState:UIControlStateNormal];
        [_menuButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        _menuButton.tag = 0;
        if (_menuButton.tag == self.selectedIndex) {
            [_menuButton setTitleColor:[UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        }else {
            [_menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [_menuButton addTarget:self action:@selector(changeSelectedIndex:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _menuButton;
}

- (UIButton *)answerButton {
    if (!_answerButton) {
        _answerButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 20 - 42, 0, 42, 50)];
        [_answerButton setTitle:@"答疑" forState:UIControlStateNormal];
        [_answerButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        _answerButton.tag = 4;
        if (_answerButton.tag == self.selectedIndex) {
            [_answerButton setTitleColor:[UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        }else {
            [_answerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [_answerButton addTarget:self action:@selector(changeSelectedIndex:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _answerButton;
}

- (UIButton *)teachButton {
    if (!_teachButton) {
        _teachButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 21, 0, 42, 50)];
        [_teachButton setTitle:@"教学" forState:UIControlStateNormal];
        [_teachButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        _teachButton.tag = 2;
        if (_teachButton.tag == self.selectedIndex) {
            [_teachButton setTitleColor:[UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        }else {
            [_teachButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [_teachButton addTarget:self action:@selector(changeSelectedIndex:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _teachButton;
}

- (UIButton *)judgeButton {
    if (!_judgeButton) {
        _judgeButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 4 - 1, 0, 42, 50)];
        [_judgeButton setTitle:@"评测" forState:UIControlStateNormal];
        [_judgeButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        _judgeButton.tag = 1;
        if (_judgeButton.tag == self.selectedIndex) {
            [_judgeButton setTitleColor:[UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        }else {
            [_judgeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [_judgeButton addTarget:self action:@selector(changeSelectedIndex:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _judgeButton;
}

- (UIButton *)activityButton {
    if (!_activityButton) {
        _activityButton = [[UIButton alloc]initWithFrame:CGRectMake(self.judgeButton.frame.origin.x + self.teachButton.frame.origin.x - self.menuButton.frame.origin.x, 0, 42, 50)];
        [_activityButton setTitle:@"活动" forState:UIControlStateNormal];
        [_activityButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        _activityButton.tag = 3;
        if (_activityButton.tag == self.selectedIndex) {
            [_activityButton setTitleColor:[UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        }else {
            [_activityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [_activityButton addTarget:self action:@selector(changeSelectedIndex:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _activityButton;
}

- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fp_rectangular-17"]];;
        _bottomImageView.frame = CGRectMake(self.menuButton.frame.origin.x + 2, 46, 42, 4);;
        [self changeBottomImageViewFrame];
    }
    return _bottomImageView;
}

- (UIScrollView *)tableScrollView {
    if (!_tableScrollView) {
        _tableScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 100)];
        _tableScrollView.contentSize = CGSizeMake(_tableScrollView.frame.size.width * 5, _tableScrollView.frame.size.height);
        _tableScrollView.backgroundColor = [UIColor whiteColor];
        _tableScrollView.delegate = self;
        _tableScrollView.pagingEnabled = YES;
        _tableScrollView.showsHorizontalScrollIndicator = NO;
        _tableScrollView.showsVerticalScrollIndicator = NO;
    }
    return _tableScrollView;
}

- (UITableView *)menuTableView {
    if (!_menuTableView) {
        _menuTableView = [[UITableExtView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.tableScrollView.frame.size.height- 65)];
        _menuTableView.delegate = self;
        _menuTableView.dataSource = self;
        _menuTableView.tableFooterView = [[UIView alloc]init];
    }
    return _menuTableView;
}

- (UITableView *)judgeTableView {
    if (!_judgeTableView) {
        _judgeTableView = [[UITableExtView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.tableScrollView.frame.size.height- 65)];
        _judgeTableView.delegate = self;
        _judgeTableView.dataSource = self;
        UIView *footV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen.width, 0.5)];
        footV.backgroundColor = CUSTOM_COLOR(200, 200, 200);
        _judgeTableView.tableFooterView = footV;
    }
    return  _judgeTableView;
}

- (UITableView *)teachTableView {
    if (!_teachTableView) {
        _teachTableView = [[UITableExtView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 2, 0, self.view.frame.size.width, self.tableScrollView.frame.size.height - 65)];
        _teachTableView.delegate = self;
        _teachTableView.dataSource = self;
        _teachTableView.tableFooterView = [[UIView alloc]init];
    }
    return _teachTableView;
}

- (UITableView *)activityTableView {
    if (!_activityTableView) {
        _activityTableView = [[UITableExtView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 3, 0, self.view.frame.size.width, self.tableScrollView.frame.size.height - 65)];
        _activityTableView.delegate = self;
        _activityTableView.dataSource = self;
        _activityTableView.tableFooterView = [[UIView alloc]init];
    }
    return _activityTableView;
}

- (UITableView *)answerTableView {
    if (!_answerTableView) {
        _answerTableView = [[UITableExtView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 4, 0, self.view.frame.size.width, self.tableScrollView.frame.size.height - 65)];
        _answerTableView.delegate = self;
        _answerTableView.dataSource = self;
        _answerTableView.tableFooterView = [[UIView alloc]init];
    }
    return _answerTableView;
}

#pragma mark - scrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.contentOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    self.newContentOffsetY = scrollView.contentOffset.y;
    
    if (self.newContentOffsetY == self.contentOffsetY) {
        NSInteger page = targetContentOffset->x / self.view.frame.size.width;
        [self changSelectedIndexFromScrollView:page];
    }
}

#pragma mark - changeViewAnimation


- (void)changeSelectedIndex:(UIButton *)sender {
    self.selectedIndex = sender.tag;
    [self changeBottomImageViewFrame];
    [self changeButtonTitleColor];
    CGPoint tableViewPoint = CGPointMake(self.view.frame.size.width * self.selectedIndex, 0);
    [self.tableScrollView setContentOffset:tableViewPoint animated:YES];
}

- (void)changSelectedIndexFromScrollView:(NSInteger)selectedIndex {
    self.selectedIndex = selectedIndex;
    [self changeBottomImageViewFrame];
    [self changeButtonTitleColor];
}

- (void)changeBottomImageViewFrame {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        if (weakSelf.selectedIndex == 0) {
            weakSelf.bottomImageView.frame = CGRectMake(weakSelf.menuButton.frame.origin.x + 2, 46, 42, 4);
        }else if (weakSelf.selectedIndex == 1) {
            weakSelf.bottomImageView.frame = CGRectMake(weakSelf.judgeButton.frame.origin.x + 2, 46, 42, 4);
        }else if (weakSelf.selectedIndex == 2) {
            weakSelf.bottomImageView.frame = CGRectMake(weakSelf.teachButton.frame.origin.x + 2, 46, 42, 4);
        }else if (weakSelf.selectedIndex == 3) {
            weakSelf.bottomImageView.frame = CGRectMake(weakSelf.activityButton.frame.origin.x + 2, 46, 42, 4);
        }else {
            weakSelf.bottomImageView.frame = CGRectMake(weakSelf.answerButton.frame.origin.x + 2, 46, 42, 4);
        }
    }];
}

- (void)changeButtonTitleColor {
    if (self.selectedIndex == 0) {
        [self.menuButton setTitleColor:[UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.judgeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.teachButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.activityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.answerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else if (self.selectedIndex == 1) {
        [self.menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.judgeButton setTitleColor:[UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.teachButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.activityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.answerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else if (self.selectedIndex == 2) {
        [self.menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.judgeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.teachButton setTitleColor:[UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.activityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.answerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else if (self.selectedIndex == 3) {
        [self.menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.judgeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.teachButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.activityButton setTitleColor:[UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.answerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else {
        [self.menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.judgeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.teachButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.activityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.answerButton setTitleColor:[UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    }
}

- (void)moreClicket {
//        [self.view viewWithpopUp:@"还在努力的建设中..." time:1];
    if ([self.moreBtnType isEqualToString:@"OFF"]) {
        
        self.moreBtnType = @"ON";
        
        //最底层View
        self.menuView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        //半透明View
        self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.backgroundView.backgroundColor = [UIColor blackColor];
        [self.backgroundView setAlpha:0];
        //点击手势
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeMenu)];
        [self.backgroundView addGestureRecognizer:tapGR];
        //滑动手势
        UISwipeGestureRecognizer  *swipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(closeMenu)];
        swipeGR.numberOfTouchesRequired = 1;
        swipeGR.direction = UISwipeGestureRecognizerDirectionRight;
        [self.backgroundView addGestureRecognizer:swipeGR];
        [self.menuView addSubview:self.backgroundView];
        
        //菜单
        self.rightMenuTableView = [[UITableExtView alloc]initWithFrame:CGRectMake(self.view.frame.size.width + self.view.frame.size.width / 2 + 20, 0, self.view.frame.size.width - (self.view.frame.size.width / 2 + 20), self.view.frame.size.height)];
        self.rightMenuTableView.showsVerticalScrollIndicator = NO;
        self.rightMenuTableView.delegate = self;
        self.rightMenuTableView.dataSource = self;
        self.rightMenuTableView.scrollEnabled = NO;
        //滑动手势
        UISwipeGestureRecognizer  *tableSwipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(closeMenu)];
        tableSwipeGR.numberOfTouchesRequired = 1;
        tableSwipeGR.direction = UISwipeGestureRecognizerDirectionRight;
        [self.rightMenuTableView addGestureRecognizer:tableSwipeGR];
        self.rightMenuTableView.tableFooterView = [[UIView alloc]init];
        UILabel *colorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 3, self.view.frame.size.height)];
        colorLabel.backgroundColor = [UIColor colorWithRed:23.0 / 255.0 green:174.0 / 255.0 blue:165.0 / 255.0 alpha:1.0];
        [self.rightMenuTableView addSubview:colorLabel];
        
        [self.menuView addSubview:self.rightMenuTableView];
        [self.view addSubview:self.menuView];
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf.backgroundView setAlpha:0.3];
            weakSelf.rightMenuTableView.frame = CGRectMake(weakSelf.view.frame.size.width / 2 + 20, 0, weakSelf.view.frame.size.width - (weakSelf.view.frame.size.width / 2 + 20), weakSelf.view.frame.size.height);
        }];
    }else {
        [self closeMenu];
    }
}

- (void)closeMenu {
    self.moreBtnType = @"OFF";
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.rightMenuTableView.frame = CGRectMake(weakSelf.view.frame.size.width + weakSelf.view.frame.size.width / 2 + 20, 0, weakSelf.view.frame.size.width - (weakSelf.view.frame.size.width / 2 + 20), weakSelf.view.frame.size.height);
        [weakSelf.backgroundView setAlpha:0];
        weakSelf.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:weakSelf selector:@selector(removeMenuView) userInfo:nil repeats:NO];
    }];
}

- (void)removeMenuView {
    [self.menuView removeFromSuperview];
    [self.myTimer invalidate];
}

- (void)joinCourseDetails:(UIButton *)sender {
    if (self.isLogin == YES) {
        if ([sender.titleLabel.text isEqualToString:@"参与该课程"]) {
            CourseDetailsTools *courseDetailsTools = [[CourseDetailsTools alloc]init];
            courseDetailsTools.courseID = self.courseID;
            __weak typeof(self) weakSelf = self;
            [courseDetailsTools postJoinCourseDataAndCallback:^(id courseDetailsData) {
                if ([courseDetailsData isEqualToString:@"success"]) {
                    weakSelf.isJoin = YES;
                    weakSelf.myType = 1;
                    [weakSelf.clickInBtn setTitle:@"进入该课程" forState:UIControlStateNormal];
                }else {
                    [weakSelf popUp:@"参与课程失败" time:2];
                }
            }];
        }else {
            LearningContentCtl *learningContentCtl = [[LearningContentCtl alloc]init];
            learningContentCtl.courseID = self.courseID;
            [self.navigationController pushViewController:learningContentCtl animated:YES];
        }
    }else {
        LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:login animated:YES];
    }
}

- (void)popUp:(NSString*)title time:(CGFloat)times{
    UIView *baffleView = [[UIView alloc]initWithFrame:self.view.frame];
    baffleView.alpha=0.5;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    label.center=self.view.center;
    label.font=[UIFont systemFontOfSize:15];
    label.alpha = 1;
    label.text = title;
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor = [UIColor blackColor];
    [baffleView addSubview:label];
    [self.view.window addSubview:baffleView];
    
    [UIView animateWithDuration:times animations:^{
        label.alpha = 0.5;
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
        [baffleView removeFromSuperview];
    }];
}

- (BOOL)isNeedRefresh:(UITableExtView *)tableview{
    return YES;
}
- (void)onRefresh:(UITableExtView *)tableview{
    [self network];
}

@end
