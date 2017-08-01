//
//  CourseDetailsViewController.m
//  CourseDetails
//
//  Created by user on 15/10/10.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "CourseDetailsViewController.h"
#import "CourseDetailsTableViewCell.h"
#import "FunctionButtonTableViewCell.h"
#import "SegmentedButtonView.h"
#import "CourseDetailsTools.h"
#import "MenuViewController.h"
#import "PublicTool.h"
#import "LearningContentCtl.h"
#import "LoginViewController.h"
#import "Config.h"
#import "DiscussionController.h"
#import "DisccussTool.h"
#import "CommunicationFrame.h"
#import "Communication.h"
#import "DiscussionCell.h"
#import "DiscussCommentController.h"
#import "EditeCommentCtl.h"
#import "TestViewController.h"


#define LightGrayColor [UIColor colorWithRed:239.0 / 255 green:239.0 / 255 blue:239.0 / 255 alpha:1.0]

@interface CourseDetailsViewController ()<DiscussionCellDelegate>

@property (nonatomic,strong)UIView *menuView;
@property (nonatomic,strong)UITableExtView *menuTableView;
@property (nonatomic,strong)NSString *moreBtnType;
@property (nonatomic,strong)NSTimer *myTimer;
@property (nonatomic,strong)NSTimer *introduceTimer;
@property (nonatomic,strong)NSTimer *tableViewTimer;
@property (nonatomic,strong)UITableExtView *tableView;
@property (nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic,assign)CGFloat contentOffsetY;
@property (nonatomic,assign)CGFloat newContentOffsetY;
@property (nonatomic,strong)WKWebView *introduceWebView;
@property (nonatomic,strong)UIView *backgroundView;
@property (nonatomic)BOOL isOpen;
@property (nonatomic)BOOL isLogin;
@property (nonatomic)BOOL isJoin;
@property (nonatomic,assign)NSInteger myType;
@property (nonatomic,assign)NSInteger reloadType;
@property (nonatomic,strong)UIButton *clicketMoreBtn;
@property (nonatomic,assign)CGFloat discussCellHeight;//讨论tableView的高度
@property (nonatomic)BOOL isDiscuss;//已获得讨论列表的数据
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic,strong)NSMutableArray *discussArrM;//存放讨论对象数组
@property (nonatomic,assign)NSInteger page;//在第几页

@property (nonatomic)BOOL isup;//是否已点赞
@property (nonatomic)BOOL islogin;//是够有登录
@property (nonatomic,assign)NSInteger up;//点赞数
@property (nonatomic,assign)NSInteger praiseIndex;//点了哪个主题；
@property (nonatomic,copy)NSString *topicId;
@property (nonatomic,assign)NSInteger commentIndex;
@property (nonatomic)BOOL iscomment;//标记点了那一条，如果有评论的话就刷数据



@end

@implementation CourseDetailsViewController

static NSString *cellID = @"courseDetailsCell";
static NSString *functionBtnCellID = @"functionButtonCell";
#define BtnTileColor [UIColor colorWithRed:3.0 / 255.0 green:180.0 / 255.0 blue:170.0 / 255.0 alpha:1.0]


- (NSMutableArray *)discussArrM
{
    if (!_discussArrM) {
        _discussArrM = [NSMutableArray array];
    }
    return _discussArrM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    titleLabel.center=[UIScreen mainScreen].bounds.origin;
    titleLabel.text=@"我的课程";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.moreBtnType = @"OFF";
    self.selectedIndex = 0;
    self.isOpen = NO;
    self.isJoin = NO;
    self.reloadType = 0;
    
    UIButton *moreButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [moreButton setBackgroundImage:[UIImage imageNamed:@"fp_more"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(moreClicket) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *moreBtnItem = [[UIBarButtonItem alloc]initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItem = moreBtnItem;
    
    self.tableView = [[UITableExtView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView.refreshView setHidden:YES];
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CourseDetailsTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FunctionButtonTableViewCell class]) bundle:nil] forCellReuseIdentifier:functionBtnCellID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCommentCount:) name:@"commentSuccess" object:nil];
}


- (UITableView *)introduceTableView {
    if (!_introduceTableView) {
        _introduceTableView = [[UITableExtView alloc]init];
        _introduceTableView.dataSource = self;
        _introduceTableView.delegate = self;
        _introduceTableView.scrollEnabled = NO;
        _introduceTableView.tableFooterView = [[UIView alloc]init];
    }
    return _introduceTableView;
}

- (UITableView *)judgeTableView {
    if (!_judgeTableView) {
        _judgeTableView = [[UITableExtView alloc]init];
        _judgeTableView.delegate = self;
        _judgeTableView.dataSource = self;
        _judgeTableView.scrollEnabled = NO;
        _judgeTableView.tableFooterView = [[UIView alloc]init];
    }
    return _judgeTableView;
}

- (UITableView *)discussTableView {
    if (!_discussTableView) {
        _discussTableView = [[UITableExtView alloc]init];
        _discussTableView.delegate = self;
        _discussTableView.dataSource = self;
        _discussTableView.scrollEnabled = NO;
        _discussTableView.separatorStyle = NO;
        _discussTableView.tableFooterView = [[UIView alloc]init];
    }
    return _discussTableView;
}

- (WKWebView *)introduceWebView {
    if (!_introduceWebView) {
        _introduceWebView = [[WKWebView alloc]init];
        _introduceWebView.navigationDelegate = self;
        _introduceWebView.UIDelegate = self;
    }
    return _introduceWebView;
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectedIndexNotification:) name:@"changeSelectedIndexNotification" object:nil];
    if (self.courseID) {
        //获取数据
        CourseDetailsTools *courseDetailsTools = [[CourseDetailsTools alloc]init];

        courseDetailsTools.courseID = self.courseID;
        __weak typeof(self) weakSelf = self;
        [courseDetailsTools getCourseDetailsDataAndCallback:^(id courseDetailsData) {
            weakSelf.courseDetailsDic = courseDetailsData;
            [weakSelf.tableView reloadData];
            weakSelf.tableScrollView.contentOffset = CGPointMake(self.selectedIndex * kScreen.width, 0);
        }];
    }
}

//取消通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.menuTableView) {
        return 1;
    }else if (tableView == self.tableView) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.menuTableView) {
        return 6;
    }else if (tableView == self.tableView) {
        if (section == 1) {
            return 1;
        }
        return 2;
    }else if (tableView == self.introduceTableView) {
        return 1;
    }else if (tableView == self.discussTableView){
        return self.discussArrM.count;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.menuTableView) {
        NSString *cellID = @"tableViewCell";
        UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
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
        
        return cell;
    }else if (tableView == self.tableView) {

        if (indexPath.section == 0 && indexPath.row == 0) {
            CourseDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.courseDetailsDic) {
                NSDictionary *dic = [self.courseDetailsDic objectForKey:@"data"];
                if (![[dic objectForKey:@"name"] isKindOfClass:[NSNull class]]) {
                    cell.courseTitleLabel.text = [dic objectForKey:@"name"];
                }
                
                if (![[dic objectForKey:@"joinCnt"] isKindOfClass:[NSNull class]]) {
                    cell.coursePeopleLabel.text = [NSString stringWithFormat:@"%@人在学习",[dic objectForKey:@"joinCnt"]];
                }
                
                if (![[dic objectForKey:@"imgs"] isKindOfClass:[NSNull class]]) {
                    NSString *imageUrl = [PublicTool isTureUrl:[dic objectForKey:@"imgs"]];
                    [cell.courseImageView setUrl:imageUrl];
                }
                
                NSString *time = [[[dic objectForKey:@"time"] componentsSeparatedByString:@" "] firstObject];
                if (![time isKindOfClass:[NSNull class]]) {
                    cell.courseTimeLabel.text = time;
                }
                
                if (![[dic objectForKey:@"hasUserPurchased"] isKindOfClass:[NSNull class]]) {
                    NSInteger type = [[dic objectForKey:@"hasUserPurchased"] integerValue];
                    self.myType = type;
                    if (self.isJoin == NO) {
                        if (type == 0) {
                            cell.courseTypeLabel.text = @"未参与";
                            [self.clickInBtn setTitle:@"参与该课程" forState:UIControlStateNormal];
                        }else {
                            cell.courseTypeLabel.text = @"已参与";
                        }
                    }
                }
            }
            
            return cell;
        }else if (indexPath.section == 0 && indexPath.row == 1) {
            FunctionButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:functionBtnCellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSDictionary *dic = [self.courseDetailsDic objectForKey:@"data"];
            NSArray *typeArray = [dic objectForKey:@"allType"];
            if (![typeArray isKindOfClass:[NSNull class]]) {
                for (NSString *type in typeArray) {
                    if ([type isEqualToString:@"40"]) {
                        [cell.menuButton setImage:[UIImage imageNamed:@"fp_directory-light"] forState:UIControlStateNormal];
                        [cell.menuButton addTarget:self action:@selector(openMenuBtnView:) forControlEvents:UIControlEventTouchUpInside];
                    }else if ([type isEqualToString:@"30"]) {
                        [cell.judgeButton setImage:[UIImage imageNamed:@"fp_test-light"] forState:UIControlStateNormal];
                        [cell.judgeButton addTarget:self action:@selector(openMenuBtnView:) forControlEvents:UIControlEventTouchUpInside];
                    }else if ([type isEqualToString:@"10"]) {
                        [cell.teachButton setImage:[UIImage imageNamed:@"fp_teaching"] forState:UIControlStateNormal];
                        [cell.teachButton addTarget:self action:@selector(openMenuBtnView:) forControlEvents:UIControlEventTouchUpInside];
                    }else if ([type isEqualToString:@"50"]) {
                        [cell.activityButton setImage:[UIImage imageNamed:@"fp_activity"] forState:UIControlStateNormal];
                        [cell.activityButton addTarget:self action:@selector(openMenuBtnView:) forControlEvents:UIControlEventTouchUpInside];
                    }else if ([type isEqualToString:@"20"]) {
                        [cell.answerButton setImage:[UIImage imageNamed:@"fp_answeringQuestions"] forState:UIControlStateNormal];
                        [cell.answerButton addTarget:self action:@selector(openMenuBtnView:) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
            }
            
            return cell;
        }else {
            NSString *cellOtherID = @"otherCellID";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellOtherID];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellOtherID];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.isOpen == NO) {
                self.tableScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,200)];
            }else {
                if (self.introduceViewHeight == 0) {
                    self.tableScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,200)];
                }else {
                    self.tableScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.introduceViewHeight + 60)];
                }
            }//我改的地方--------------------
            if (self.selectedIndex == 2) {
                if (self.discussArrM.count == 0) {
                    self.tableScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
                }else if (self.discussCellHeight < 200){
                    self.tableScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
                }else
                self.tableScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.discussCellHeight + 100)];
            }//-----------------------------------
            self.tableScrollView.contentSize = CGSizeMake(self.tableScrollView.frame.size.width * 3, self.tableScrollView.frame.size.height);
            self.tableScrollView.backgroundColor = [UIColor whiteColor];
            self.tableScrollView.delegate = self;
            self.tableScrollView.pagingEnabled = YES;
            self.tableScrollView.showsHorizontalScrollIndicator = NO;
            self.tableScrollView.showsVerticalScrollIndicator = NO;
            
            self.introduceTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.tableScrollView.frame.size.height);
            self.judgeTableView.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.tableScrollView.frame.size.height);
            
            self.discussTableView.frame = CGRectMake(self.view.frame.size.width * 2, 0, self.view.frame.size.width, self.tableScrollView.frame.size.height);
            [self.tableScrollView addSubview:self.introduceTableView];
            [self.tableScrollView addSubview:self.discussTableView];

//#warning 建设中++++
//            UIImageView *imageViews1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jianshe"]];
//            imageViews1.frame = CGRectMake(0,0, kScreen.width,kScreen.width/1.6);
//            [self.tableScrollView addSubview:imageViews1];
//
            UIImageView *imageViews = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"com_develop"]];
            imageViews.frame = CGRectMake(self.view.frame.size.width,0, kScreen.width,kScreen.width/1.6);
            [self.tableScrollView addSubview:imageViews];
            //------------------------------
            //UIImageView *imageViews2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"com_develop"]];
            //imageViews2.frame = CGRectMake(self.view.frame.size.width * 2,0, kScreen.width,kScreen.width/1.6);
            //[self.tableScrollView addSubview:imageViews2];
            //-----------------------------------------------
/**为了测试加的按钮要去的*/
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = CGRectMake(20, 20, 50, 50);
            btn.backgroundColor = [UIColor redColor];
            imageViews.userInteractionEnabled = YES;
            [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
            [imageViews addSubview:btn];
            
            //            [self.tableScrollView addSubview:self.judgeTableView];
            
//            [cell.contentView addSubview:self.tableScrollView];
            

//            [self.tableScrollView addSubview:self.judgeTableView];
//            [self.tableScrollView addSubview:self.discussTableView];
            [cell.contentView addSubview:self.tableScrollView];
            
            return cell;
        }
    }else if (tableView == self.introduceTableView) {
        
        NSString *introdeceCellID = @"introdeceCell";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:introdeceCellID];
        }
        if (self.isOpen == NO) {
            self.introduceWebView.frame = CGRectMake(0, 0, self.view.frame.size.width, 170);
        }else {
            self.introduceWebView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.introduceViewHeight);
        }
        if (self.reloadType == 0) {
            NSString *path = [NSString stringWithFormat:@"%@/course-content.html?id=",SRV];
            NSString *url = [NSString stringWithFormat:@"%@%@#/",path,self.courseID];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            [self.introduceWebView loadRequest:request];
        }
        self.introduceWebView.userInteractionEnabled = NO;
        
        [cell.contentView addSubview:self.introduceWebView];
        
        self.clicketMoreBtn = [[UIButton alloc]init];
        self.clicketMoreBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView setImage:[UIImage imageNamed:@"fp_triangle"]];
        self.clicketMoreBtn.userInteractionEnabled = NO;
        if (self.isOpen == NO) {
            self.clicketMoreBtn.frame = CGRectMake(self.view.frame.size.width - 80, 175, 80, 20);
            [self.clicketMoreBtn setTitle:@"...更多" forState:UIControlStateNormal];
            imageView.frame = CGRectMake(self.view.frame.size.width - 20, 180, 10, 10);
        }else {
            if (self.introduceViewHeight == 0) {
                self.clicketMoreBtn.frame = CGRectMake(self.view.frame.size.width - 80, 175, 80, 20);
                imageView.frame = CGRectMake(self.view.frame.size.width - 20, 180, 10, 10);
            }else {
                self.clicketMoreBtn.frame = CGRectMake(self.view.frame.size.width - 65, self.introduceViewHeight + 35, 60, 20);
                imageView.frame = CGRectMake(self.view.frame.size.width - 20, self.introduceViewHeight + 40, 10, 10);
            }
            [self.clicketMoreBtn setTitle:@"收起" forState:UIControlStateNormal];
            imageView.transform = CGAffineTransformRotate(imageView.transform, M_PI);
        }
        
        [self.clicketMoreBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [self.clicketMoreBtn setTitleColor:[UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.clicketMoreBtn addTarget:self action:@selector(clicketMore) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:self.clicketMoreBtn];
        [cell.contentView addSubview:imageView];

        //页面创建完再创建按钮,确保按钮始终在最上层
        if (!self.clickInBtn) {
            self.clickInBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
            self.clickInBtn.backgroundColor = [UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0];
            [self.clickInBtn setTitle:@"进入该课程" forState:UIControlStateNormal];
            [self.clickInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.clickInBtn addTarget:self action:@selector(joinCourseDetails:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.clickInBtn];
        }
        
        return cell;
    }else if (tableView == self.judgeTableView) {
        NSString *cellOtherID = @"CellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellOtherID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellOtherID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.textLabel.text = @"test2";
        
        return cell;
    }else {
        NSString *cellOtherID = @"discussCell";
         DiscussionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellOtherID];
        if (!cell) {
            cell = [[DiscussionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellOtherID];
        }
        //cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.backgroundColor = LightGrayColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.praiseB.tag = 500 + indexPath.row;
        cell.commentB.tag = indexPath.row;
        cell.communicationgFrame = self.discussArrM[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.introduceTableView) {
        self.isOpen = !self.isOpen;
        self.reloadType += 1;
        if (self.isOpen == NO) {
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.3 animations:^{
                CGPoint contentPoint = CGPointMake(0, 0);
                [weakSelf.tableView setContentOffset:contentPoint animated:YES];
                weakSelf.tableViewTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(reloadTableView) userInfo:nil repeats:NO];
            }];
        }else {
            [self reloadTableView];
        }
    }else if (tableView == self.discussTableView){
        //跳到评论列表页面
        self.commentIndex = indexPath.row;//评论
        self.iscomment= YES;
        DiscussCommentController *discussCommentVC = [[DiscussCommentController alloc]init];
        //self.commentIndex = indexPath.row;
        
        discussCommentVC.commentF = _discussArrM[indexPath.row];
        CommunicationFrame *communicationFrame = _discussArrM[indexPath.row];
        //Communication *communication = communicationFrame.comunication;
        discussCommentVC.courseID = self.courseID;
        discussCommentVC.commentF = communicationFrame;
        [self.navigationController pushViewController:discussCommentVC animated:YES];
//        __weak typeof(self) weakself = self;
//        [discussCommentVC setBlock:^(BOOL isup){
//            communication.isup = isup;
//            communication.up++;
//            [weakself.discussTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
//        }];

    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        if (section == 1) {
            SegmentedButtonView *segmentedBtnView = [[SegmentedButtonView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
            segmentedBtnView.backgroundColor = [UIColor whiteColor];
            return segmentedBtnView;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.menuTableView) {
        return 60;
    }else if (tableView == self.tableView) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            return (self.view.frame.size.width / 16) * 9 + 85;
        }else if (indexPath.section == 0 && indexPath.row == 1) {
            return 70;
        }else if (indexPath.section == 1 && indexPath.row == 0) {
            //我加的---------------------------
            if (self.selectedIndex == 2 && self.discussArrM.count != 0) {
                
                    return self.discussCellHeight + 170;
            }//------------------------------
            if (self.isOpen == NO) {
                return self.tableScrollView.frame.size.height + 120;
            }else {
                if (self.introduceViewHeight == 0) {
                    return self.tableScrollView.frame.size.height + 120;
                }else {
                    return self.introduceViewHeight + 170;
                }
            }
        }
    }else if (tableView == self.introduceTableView) {
        if (self.isOpen == NO) {
            return self.introduceWebView.frame.size.height + 50;
        }else {
            if (self.introduceViewHeight == 0) {
                return 200;
            }else {
                return self.introduceViewHeight + 170;
            }
        }
    }else if (tableView == self.discussTableView){
        if (self.discussArrM.count == 0) {
            return 200;
        }else{
            CommunicationFrame *commentF = self.discussArrM[indexPath.row];
            CGFloat cellheight = commentF.cellHeight;
            return cellheight;
        }
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.menuTableView) {
        return 0;
    }else if (tableView == self.tableView ) {
        if (section == 0) {
            return 10;
        }
        return 0;
    }else if (tableView == self.discussTableView){
        if (self.discussArrM.count != 0) {
            return 40;
        }
        return 0;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView == self.discussTableView) {
        if (self.discussArrM.count !=0) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen.width,40)];
            view.backgroundColor = [UIColor whiteColor];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, kScreen.width, 40);
            [button setTitle:@"查看更多" forState:UIControlStateNormal];
            [button setTitleColor:BtnTileColor forState:UIControlStateNormal];
            [button addTarget:self action:@selector(moreDiscuss:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
            
            UIView  *line = [[UIView alloc]initWithFrame:CGRectMake(0, 39, kScreen.width, 1)];
            line.backgroundColor = LightGrayColor;
            [view addSubview:line];
            
            return view;
        }
        return nil;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.menuTableView) {
        return 0;
    }else if (tableView == self.tableView) {
        if (section == 1) {
            return 44;
        }else {
            return 0;
        }
    }
    return 0;
}

#pragma mark - scrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.contentOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    self.newContentOffsetY = scrollView.contentOffset.y;
    
    if (self.newContentOffsetY == self.contentOffsetY) {
        NSInteger page = targetContentOffset->x / self.view.frame.size.width;
        NSString *pageStr = [NSString stringWithFormat:@"%ld",(long)page];
        self.selectedIndex = page;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSelectedIndexFromScrollViewNotification" object:nil userInfo:@{@"selectedIndex":pageStr}];
        if (self.selectedIndex == 2) {
            NSLog(@"请求数据%ld",self.selectedIndex);
            if (self.isDiscuss) {
                
                return ;
            }
            [self network];
        }
        
    }
}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    
//}


#pragma mark - WKWebViewDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.introduceTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(loadIntroduceData) userInfo:nil repeats:NO];
}

- (void)loadIntroduceData {
    __weak typeof(self) weakSelf = self;
    [self.introduceWebView evaluateJavaScript:@"getHeight();" completionHandler:^(id result, NSError *error) {
        NSString *str = result;
        weakSelf.introduceViewHeight = [str integerValue];
        weakSelf.clicketMoreBtn.userInteractionEnabled = YES;
    }];
    [self.introduceTimer invalidate];
}

#pragma mark - changeViewAnimation
//点击按钮的通知
- (void)changeSelectedIndexNotification:(NSNotification *)notifiation {
    NSDictionary *selectedIndexDic = [notifiation userInfo];
    self.selectedIndex = [selectedIndexDic[@"selectedIndex"] integerValue];
    CGPoint tableViewPoint = CGPointMake(self.view.frame.size.width * self.selectedIndex, 0);
    [self.tableScrollView setContentOffset:tableViewPoint animated:YES];
    if (self.selectedIndex == 2) {
        self.page = self.selectedIndex;
        NSLog(@"=========%ld",self.page);
        if (self.isDiscuss) {
            return ;
        }
 
        [self network];
        
    }
    
}

- (void)moreClicket {
//    [self.view viewWithpopUp:@"还在努力的建设中..." time:1];
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
        self.menuTableView = [[UITableExtView alloc]initWithFrame:CGRectMake(self.view.frame.size.width + self.view.frame.size.width / 2 + 20, 0, self.view.frame.size.width - (self.view.frame.size.width / 2 + 20), self.view.frame.size.height)];
        self.menuTableView.showsVerticalScrollIndicator = NO;
        self.menuTableView.delegate = self;
        self.menuTableView.dataSource = self;
        self.menuTableView.scrollEnabled = NO;
        //滑动手势
        UISwipeGestureRecognizer  *tableSwipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(closeMenu)];
        tableSwipeGR.numberOfTouchesRequired = 1;
        tableSwipeGR.direction = UISwipeGestureRecognizerDirectionRight;
        [self.menuTableView addGestureRecognizer:tableSwipeGR];
        self.menuTableView.tableFooterView = [[UIView alloc]init];
        UILabel *colorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 3, self.view.frame.size.height)];
        colorLabel.backgroundColor = [UIColor colorWithRed:23.0 / 255.0 green:174.0 / 255.0 blue:165.0 / 255.0 alpha:1.0];
        [self.menuTableView addSubview:colorLabel];
        
        [self.menuView addSubview:self.menuTableView];
        [self.view addSubview:self.menuView];
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf.backgroundView setAlpha:0.3];
            weakSelf.menuTableView.frame = CGRectMake(weakSelf.view.frame.size.width / 2 + 20, 0, weakSelf.view.frame.size.width - (weakSelf.view.frame.size.width / 2 + 20), weakSelf.view.frame.size.height);
        }];
    }else {
        [self closeMenu];
    }
}

- (void)closeMenu {
    self.moreBtnType = @"OFF";
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.menuTableView.frame = CGRectMake(weakSelf.view.frame.size.width + weakSelf.view.frame.size.width / 2 + 20, 0, weakSelf.view.frame.size.width - (weakSelf.view.frame.size.width / 2 + 20), weakSelf.view.frame.size.height);
        [weakSelf.backgroundView setAlpha:0];
        weakSelf.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:weakSelf selector:@selector(removeMenuView) userInfo:nil repeats:NO];
    }];
}

- (void)removeMenuView {
    [self.menuView removeFromSuperview];
    [self.myTimer invalidate];
}

- (void)openMenuBtnView:(UIButton *)sender {
    MenuViewController *menuVC = [[MenuViewController alloc]init];
    menuVC.selectedIndex = sender.tag;
    menuVC.courseID = self.courseID;
    menuVC.myType = self.myType;
    [self.navigationController pushViewController:menuVC animated:YES];
}

- (void)clicketMore {
    self.isOpen = !self.isOpen;
    self.reloadType += 1;
    if (self.isOpen == NO) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint contentPoint = CGPointMake(0, 0);
            [weakSelf.tableView setContentOffset:contentPoint animated:YES];
            weakSelf.tableViewTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(reloadTableView) userInfo:nil repeats:NO];
        }];
    }else {
        [self reloadTableView];
    }

}

- (void)reloadTableView {
    [self.introduceTableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableViewTimer invalidate];
}

- (void)joinCourseDetails:(UIButton *)sender {
    self.isLogin = [PublicTool isSuccessLogin];
    if (self.isLogin == YES) {
        if ([sender.titleLabel.text isEqualToString:@"参与该课程"]) {
            CourseDetailsTools *courseDetailsTools = [[CourseDetailsTools alloc]init];
            courseDetailsTools.courseID = self.courseID;
            __weak typeof(self) weakSelf = self;
            [courseDetailsTools postJoinCourseDataAndCallback:^(id courseDetailsData) {
                if ([courseDetailsData isEqualToString:@"success"]) {
                    weakSelf.isJoin = YES;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                    [weakSelf.clickInBtn setTitle:@"进入该课程" forState:UIControlStateNormal];
                    weakSelf.myType = 1;
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
        LoginViewController *login = [[LoginViewController alloc]init];
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

/** 更多的讨论数据 */
- (void)moreDiscuss:(UIButton *)moreDiscuss
{
    NSLog(@"更多的讨论数据");
    self.iscomment = NO;
    DiscussionController *discussVC = [[DiscussionController alloc]init];
    discussVC.courseID = self.courseID;
    [self.navigationController pushViewController:discussVC animated:YES];

}


#pragma mark - 网络请求
- (void)network
{
    //NSString *pageStr = [NSString stringWithFormat:@"%ld",se];
    if (self.courseID) {
        //获取数据
        DisccussTool *disccussTool = [[DisccussTool alloc]init];
        
        disccussTool.courseID = self.courseID;
        __weak typeof(self) weakSelf = self;
        [disccussTool postListTopicDataWithpage:@"1" andCallBack:^(id discussionData) {
            weakSelf.dict = discussionData;
            [weakSelf ChangeDiscussData];
        }];
    }
}
//解析数据
- (void)ChangeDiscussData
{
    __weak typeof(self) weakSelf = self;
    if (!_dict) {
        NSLog(@"成功");
        return ;
    }
    NSString *code = [[_dict valueForKey:@"code"] stringValue];
    //字典转模型
    if ([code isEqualToString:@"0"])
    {
        self.isDiscuss = YES;
        weakSelf.discussCellHeight = 0;
        [weakSelf.discussArrM removeAllObjects];
        NSDictionary *dataDict = [weakSelf.dict valueForKey:@"data"];
        NSArray *array = [dataDict valueForKey:@"list"];
        NSLog(@"array.count === %ld",array.count);
        for (NSDictionary *listDict in array) {
            Communication *communication = [[Communication alloc]initWithDic:listDict];
            CommunicationFrame *communicationFrame = [[CommunicationFrame alloc]init];
            communicationFrame.comunication = communication;
            [weakSelf.discussArrM addObject:communicationFrame];
            weakSelf.discussCellHeight += communicationFrame.cellHeight;
        }
        NSLog(@"weakSelf.discussCellHeight == %f",weakSelf.discussCellHeight);
        if (weakSelf.discussArrM.count == 0) {
            weakSelf.discussCellHeight = kScreen.width/1.6;
        }
//        else
//        {
//            weakSelf.discussCellHeight = weakSelf.discussCellHeight + 100;
//        }
        NSLog(@"weakSelf.discussCellHeight == %f",weakSelf.discussCellHeight);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        [weakSelf.discussTableView reloadData];
        weakSelf.tableScrollView.contentOffset = CGPointMake(self.selectedIndex * self.view.frame.size.width, 0);
    }
}


/**自己加的按钮点击事件*/
- (void)click
{
//__weak typeof(self) weakSelf = self;
    DiscussionController *discussVC = [[DiscussionController alloc]init];
    discussVC.courseID = self.courseID;
    [self.navigationController pushViewController:discussVC animated:YES];
}

#pragma mark - DiscussionCellDelegate
//点赞
- (void)discussionCell:(DiscussionCell *)cell praiseIndex:(NSInteger)index
{
    NSLog(@"index == %d",index);
    CommunicationFrame *commentF = _discussArrM[index];
    self.isup = commentF.comunication.isup;
    self.up = commentF.comunication.up;
    self.praiseIndex = index;
    self.topicId = commentF.comunication.tid;
    NSLog(@"%d",index);
    
    //先判断有没有登录
    self.islogin = [PublicTool isSuccessLogin];
    if (!self.islogin) {
        NSLog(@"没有登录");
        [self popUp:@"您未登录，请登录" time:2.0];
        return ;
    }
    if (self.isup)
    {
        [self popUp:@"已点赞" time:2.0];
        return ;
    }
    NSLog(@"登录了");
    //判断是否参与了课程
    __weak typeof(self) weakSelf = self;
    [PublicTool isJoinCourse:self.courseID Callback:^(id isJoin) {
        //参与了课程，可以点赞
        BOOL join = [isJoin boolValue];
        if (join)
        {
            [weakSelf getpraiseNet];
        }
        else
        {
            [weakSelf popUp:@"您未参与该课程" time:2.0];
        }
        
    }];
    
}
/** 对帖子发出点赞请求 */
- (void)getpraiseNet
{
    NSString *tokenID = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"];
    NSString *urlType = @"/usr/op";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DC_SRV,urlType];
    NSDictionary *params = @{@"op":@"UP",@"tid":self.topicId,@"token":tokenID,@"type":@"TOPIC"};
    __weak typeof(self) weakSelf = self;
    [H doGet:urlStr args:params json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err) {
            [weakSelf popUp:@"点赞失败" time:2.0];
            
        }else
        {
            NSLog(@"self.praiseIndex == %d",self.praiseIndex);
            weakSelf.up ++;
            weakSelf.isup = 1;
            CommunicationFrame *commentF = weakSelf.discussArrM[self.praiseIndex];
            commentF.comunication.up = weakSelf.up;
            commentF.comunication.isup = 1;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.praiseIndex inSection:0];
            [weakSelf.discussTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf popUp:@"点赞成功" time:1.0];
        }
    }];
    
}


//评论
- (void)discussionCell:(DiscussionCell *)cell selectIndex:(NSInteger)index
{
    //先判断有没有登录
    self.islogin = [PublicTool isSuccessLogin];
    if (!self.islogin) {
        NSLog(@"没有登录");
        [self popUp:@"您未登录，请登录" time:2.0];
        return ;
    }
    //判断是否参与了课程
    __weak typeof(self) weakSelf = self;
    [PublicTool isJoinCourse:self.courseID Callback:^(id isJoin) {
        //参与了课程，可以评论
        if (isJoin)
        {
            self.commentIndex = index;
            self.iscomment = YES;
            CommunicationFrame *commentF = weakSelf.discussArrM[index];
            NSString *topicId = commentF.comunication.tid;
            EditeCommentCtl *editeVC = [[EditeCommentCtl alloc]init];
            editeVC.topicId= topicId;
            [self.navigationController pushViewController:editeVC animated:YES];
        }
        else
        {
            [weakSelf popUp:@"您未参与该课程" time:2.0];
        }
    }];

}
//评论成功通知
- (void)changeCommentCount:(NSNotification *)noti
{
    if (self.iscomment) {
        CommunicationFrame *commentF = _discussArrM[self.commentIndex];
        commentF.comunication.comments++;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.commentIndex inSection:0];
        [self.discussTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone]; 
    }
}


@end


