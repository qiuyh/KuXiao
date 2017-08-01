//
//  SendDiscussController.m
//  rcpi
//
//  Created by admin on 15/12/17.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "DiscussionController.h"
#import "DiscussSegmentButton.h"
#import "DYLZButton.h"
#import "SendDiscussionController.h"
#import "DisccussTool.h"
#import "Communication.h"
#import "CommunicationFrame.h"
#import "DiscussionCell.h"
#import "DiscussCommentController.h"
#import "EditeCommentCtl.h"
#import "PublicTool.h"

#define kScreen [UIScreen mainScreen].bounds.size
#define ToolH   44.0
#define NavH    64.0


#define LightGrayColor [UIColor colorWithRed:239.0 / 255 green:239.0 / 255 blue:239.0 / 255 alpha:1.0]
#define BtnTileColor [UIColor colorWithRed:3.0 / 255.0 green:180.0 / 255.0 blue:170.0 / 255.0 alpha:1.0]

//导航头部按钮
#define GroundColor [UIColor colorWithRed:23.0 / 255 green:125.0 / 255 blue:114.0 / 255 alpha:1.0]

//未选中颜色
#define titleC [UIColor colorWithRed:21.0 / 255 green:163.0 / 255 blue:154.0 / 255 alpha:1.0]

@interface DiscussionController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITableExtViewDelegate,DiscussionCellDelegate>

@property (nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic,strong)UIButton *lightGroundView;
@property (nonatomic,strong)UIView *btnView;
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic,strong)UIButton *allPeopleButton;
@property (nonatomic,strong)UIButton *meButton;

@property (nonatomic,strong)NSMutableArray *dataArrM;
@property (nonatomic)BOOL isUp;//点赞转态
@property (nonatomic)BOOL islogin;//登录状态
@property (nonatomic,copy)NSString *topicId;//要点赞的主题id
@property (nonatomic,assign)NSInteger up;//点赞数目
@property (nonatomic,assign)NSInteger praiseIndex;//点赞哪个帖子
@property (nonatomic,assign)NSInteger commentIndex;//评论哪个帖子
@property (nonatomic,assign)NSInteger total;//总数目

@property (nonatomic,assign)NSInteger page;//第几页数据

@end

@implementation DiscussionController

- (NSMutableArray *)dataArrM
{
    if (!_dataArrM) {
        _dataArrM = [NSMutableArray array];
    }
    return _dataArrM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNavTitle];
    [self addScroView];
    
    [self addSegmentButton];
    
    [self addBtntool];
    self.page = 1;
    [self network];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectedIndexNotification:) name:@"changeSelectedIndexNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCommentCount:) name:@"commentSuccess" object:nil];

}

/** 导航条选中选择按钮 */
- (void)setNavTitle
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 140, 30)];
    
    view.backgroundColor = GroundColor;
    self.navigationItem.titleView = view;
    
    self.allPeopleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.allPeopleButton.frame = CGRectMake(3, 3, 70, 24);
    [self.allPeopleButton setTitle:@"所有人" forState:UIControlStateNormal];
    [self.allPeopleButton setTitleColor:titleC forState:UIControlStateNormal];
    [self.allPeopleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.allPeopleButton.backgroundColor = BtnTileColor;
    
    [view addSubview:self.allPeopleButton];
    self.allPeopleButton.selected = YES;
    [self.allPeopleButton addTarget:self action:@selector(allClik:) forControlEvents:UIControlEventTouchUpInside];
    
    self.meButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.meButton.frame = CGRectMake(72, 3, 65, 24);
    [self.meButton setTitle:@"我的" forState:UIControlStateNormal];
    [self.meButton setTitleColor:titleC forState:UIControlStateNormal];
    [self.meButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.meButton.backgroundColor = [UIColor clearColor];
    [view addSubview:self.meButton];
    [self.meButton addTarget:self action:@selector(meClick:) forControlEvents:UIControlEventTouchUpInside];
    
    view.layer.cornerRadius = 5;
    self.allPeopleButton.layer.cornerRadius = 5;
    self.meButton.layer.cornerRadius = 5;

}

- (void)allClik:(UIButton *)sender
{
    self.allPeopleButton.selected = YES;
    self.meButton.selected = NO;
    self.allPeopleButton.backgroundColor = BtnTileColor;
    self.meButton.backgroundColor = [UIColor clearColor];
}

- (void)meClick:(id)sender
{

    self.allPeopleButton.selected = NO;
    self.meButton.selected = YES;
    self.allPeopleButton.backgroundColor = [UIColor clearColor];
    self.meButton.backgroundColor = BtnTileColor;
    
}
/**增加分段按钮*/
- (void)addSegmentButton
{
    DiscussSegmentButton *segmentV = [[DiscussSegmentButton alloc]initWithFrame:CGRectMake(0, 64, kScreen.width,44)];
    segmentV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:segmentV];
}

/**增加一个大的ScrollView，里面放了三个tableView*/
-(void)addScroView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, ToolH + NavH, kScreen.width, kScreen.height - ToolH - NavH - 49)];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(kScreen.width * 3, self.scrollView.bounds.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
    
    //    //讨论的TableView
    [self addDiscussTableView];
    
    //用来占位的UIImageView
    UIImageView *answerImgV = [[UIImageView alloc]init];
    answerImgV.frame = CGRectMake(kScreen.width, 0, kScreen.width, self.scrollView.bounds.size.height);
    answerImgV.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:answerImgV];
    // NSLog(@"== %f == %f == %f == %f",ToolH + NavH, kScreen.width, kScreen.width - ToolH - NavH - 49,self.scrollView.bounds.size.height);
    
    UIImageView *noteImgV = [[UIImageView alloc]init];
    noteImgV.frame = CGRectMake(kScreen.width * 2, 0, kScreen.width, self.scrollView.bounds.size.height);
    noteImgV.backgroundColor = [UIColor yellowColor];
    [self.scrollView addSubview:noteImgV];
}
/**在scrollView中添加三个Tableview answers */
//- (UITableView *)judgeTableView {
//    if (!_judgeTableView) {
//        _judgeTableView = [[UITableExtView alloc]init];
//        _judgeTableView.delegate = self;
//        _judgeTableView.dataSource = self;
//        _judgeTableView.scrollEnabled = NO;
//        _judgeTableView.tableFooterView = [[UIView alloc]init];
//    }
//    return _judgeTableView;
//}
//
//- (UITableView *)introduceTableView {
//    if (!_introduceTableView) {
//        _introduceTableView = [[UITableExtView alloc]init];
//        _introduceTableView.dataSource = self;
//        _introduceTableView.delegate = self;
//        _introduceTableView.scrollEnabled = NO;
//        _introduceTableView.tableFooterView = [[UIView alloc]init];
//    }
//    return _introduceTableView;
//}

/**讨论tableView*/
- (void)addDiscussTableView {
    
    UITableExtView *discussTableView = [[UITableExtView alloc]initWithFrame:CGRectMake(0, 0, kScreen.width, self.scrollView.frame.size.height)];
    //discussTableView.frame = CGRectMake(0, 0, kScreen.width, self.scrollView.frame.size.height);
    discussTableView.delegate = self;
    discussTableView.dataSource = self;
    discussTableView.scrollEnabled = YES;
    //_discussTableView.backgroundColor = [UIColor lightGrayColor];
    // _discussTableView.tableFooterView = [[UIView alloc]init];
    discussTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.scrollView addSubview:discussTableView];
    self.discussTableView = discussTableView;
}
#pragma mark - 网络请求
- (void)network
{
    NSString *pageStr = [NSString stringWithFormat:@"%d",self.page];
    if (self.courseID) {
        //获取数据
        DisccussTool *disccussTool = [[DisccussTool alloc]init];
        
        disccussTool.courseID = self.courseID;
        __weak typeof(self) weakSelf = self;
        [disccussTool postListTopicDataWithpage:pageStr andCallBack:^(id discussionData) {
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
        if (self.page == 1) {
            [self.dataArrM removeAllObjects];
        }
        //NSMutableArray *communicationFDict = [NSMutableArray array];
        NSDictionary *dataDict = [_dict valueForKey:@"data"];
        self.total = [[dataDict valueForKey:@"total"] integerValue];
        NSArray *array = [dataDict valueForKey:@"list"];
        NSLog(@"array.count === %d",array.count);
        for (NSDictionary *listDict in array) {
            Communication *communication = [[Communication alloc]initWithDic:listDict];
            CommunicationFrame *communicationFrame = [[CommunicationFrame alloc]init];
            communicationFrame.comunication = communication;
            [weakSelf.dataArrM addObject:communicationFrame];
        }
        [weakSelf.discussTableView reloadData];
    }
}

#pragma mark - 点击 +
/**底部按钮条*/
- (void)addBtntool
{
    UIView *btnTooView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreen.height - 49,kScreen.width, 49)];
    btnTooView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnTooView];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(kScreen.width / 2 - 30, 5, 60, 40);
    addButton.backgroundColor = BtnTileColor;
    [addButton setImage:[UIImage imageNamed:@"msg_more"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addDiscuss:) forControlEvents:UIControlEventTouchUpInside];
    [btnTooView addSubview:addButton];
    
    //上分割线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:200.0 / 255.0 green:199.0 / 255.0 blue:204.0 / 255.0 alpha:1.0];
    [btnTooView addSubview:line];
}

/**点击+号点击*/
- (void)addDiscuss:(UIButton *)btn
{
    //灰色挡板
    self.lightGroundView = [[UIButton alloc]initWithFrame:self.view.bounds];
    self.lightGroundView.backgroundColor = [UIColor blackColor];
    self.lightGroundView.alpha = 0.0;
    [self.lightGroundView addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.lightGroundView];
    
    
    
    self.btnView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreen.height , kScreen.width, 139)];
    self.btnView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.btnView];
    
    CGFloat margin = (kScreen.width -60 * 3) / 4;
    UIButton *noteButton = [[DYLZButton alloc]initWithFrame:CGRectMake(margin, 10, 60, 70)];
    noteButton.tag = 0;
    [noteButton setTitle:@"笔记" forState:UIControlStateNormal];
    [noteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [noteButton setImage:[UIImage imageNamed:@"button_note"] forState:UIControlStateNormal];
    [noteButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:noteButton];
    
    UIButton *answerButton = [[DYLZButton alloc]initWithFrame:CGRectMake(kScreen.width / 2 - 30, 10, 60, 70)];
    answerButton.tag = 1;
    [answerButton setTitle:@"问答" forState:UIControlStateNormal];
    [answerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [answerButton setImage:[UIImage imageNamed:@"button_qa"] forState:UIControlStateNormal];
    [answerButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:answerButton];
    
    UIButton *discussButton = [[DYLZButton alloc]initWithFrame:CGRectMake(kScreen.width - margin - 60, 10, 60, 70)];
    discussButton.tag = 2;
    [discussButton setTitle:@"讨论" forState:UIControlStateNormal];
    [discussButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [discussButton setImage:[UIImage imageNamed:@"button_discuss"] forState:UIControlStateNormal];
    [discussButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:discussButton];
    
    //一条分割线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 90, kScreen.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:200.0 / 255.0 green:199.0 / 255.0 blue:204.0 / 255.0 alpha:1.0];
    [self.btnView addSubview:line];
    
    //最下面按钮
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(kScreen.width * 0.5 - 20, 95, 40, 40);
    [closeButton setImage:[UIImage imageNamed:@"button_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:closeButton];
    
    
    //[UIView animateWithDuration:0.2 animations:^{
        self.lightGroundView.alpha = 0.3;
        self.btnView.frame = CGRectMake(0, kScreen.height - 139, kScreen.width, 139);
        
    //}];

}

/**点击灰色挡板移除视图*/
- (void)close
{
    self.lightGroundView.alpha = 0.0;
    self.btnView.frame = CGRectMake(0, kScreen.height , kScreen.width, 139);
    [self.lightGroundView removeFromSuperview];
    [self.btnView removeFromSuperview];
}
/**笔记，问答，讨论点击*/
- (void)click:(UIButton *)btn
{
    [self close];
    if (btn.tag == 2)
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
            NSLog(@"isjoin == %@",isJoin);
            NSInteger join = [isJoin integerValue];
            if (join != 0 )
            {
                NSLog(@"参与了");
                SendDiscussionController *discussVC = [[SendDiscussionController alloc]init];
                discussVC.courseID = self.courseID;
                [weakSelf.navigationController pushViewController:discussVC animated:YES];

            }
            else
            {
                [weakSelf popUp:@"您未参与该课程" time:2.0];
            }
        }];
    }
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
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSelectedIndexFromScrollViewNotification" object:nil userInfo:@{@"selectedIndex":pageStr}];
    }
}

#pragma mark - changeViewAnimation

- (void)changeSelectedIndexNotification:(NSNotification *)notifiation {
    NSDictionary *selectedIndexDic = [notifiation userInfo];
    self.selectedIndex = [selectedIndexDic[@"selectedIndex"] integerValue];
    CGPoint tableViewPoint = CGPointMake(self.view.frame.size.width * self.selectedIndex, 0);
    [self.scrollView setContentOffset:tableViewPoint animated:YES];
    
}

#pragma mark - changeCommentCount修改评论数目

- (void)changeCommentCount:(NSNotification *)notifi
{
    CommunicationFrame *commentF = _dataArrM[self.commentIndex];
    commentF.comunication.comments++;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.commentIndex inSection:0];
    [self.discussTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArrM.count == 0? 0:self.dataArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"discussCell";
    DiscussionCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[DiscussionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.communicationgFrame = _dataArrM[indexPath.row];
    cell.backgroundColor = LightGrayColor;
    cell.commentB.tag = indexPath.row;
    cell.praiseB.tag = 500 + indexPath.row;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommunicationFrame *communicationF = _dataArrM[indexPath.row];
    return communicationF.cellHeight;
}

//跳转到评论列表页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.commentIndex = indexPath.row;
    DiscussCommentController *discussCommentVC = [[DiscussCommentController alloc]init];
    discussCommentVC.commentF = _dataArrM[indexPath.row];
    CommunicationFrame *communicationFrame = _dataArrM[indexPath.row];
    Communication *communication = communicationFrame.comunication;
    discussCommentVC.courseID = self.courseID;
    __weak typeof(self) weakself = self;
    [discussCommentVC setBlock:^(BOOL isup){
        communication.isup = isup;
        communication.up++;
        [weakself.discussTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
//    DiscussionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    
//    discussCommentVC.discussCell = cell;
    
    [self.navigationController pushViewController:discussCommentVC animated:YES];
}

#pragma mark - DiscussionCellDelegate

//跳到评论页面
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
            CommunicationFrame *commentF = weakSelf.dataArrM[index];
            NSString *topicId = commentF.comunication.tid;
            EditeCommentCtl *editeVC = [[EditeCommentCtl alloc]init];
            editeVC.topicId= topicId;
            [self.navigationController pushViewController:editeVC animated:YES];        }
        else
        {
            [weakSelf popUp:@"您未参与该课程" time:2.0];
        }
    }];
}


//点赞
- (void)discussionCell:(DiscussionCell *)cell praiseIndex:(NSInteger)index
{
    CommunicationFrame *commentF = _dataArrM[index];
    self.isUp = commentF.comunication.isup;
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
    if (self.isUp)
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
            weakSelf.up ++;
            weakSelf.isUp = 1;
            CommunicationFrame *commentF = weakSelf.dataArrM[self.praiseIndex];
            commentF.comunication.up = weakSelf.up;
            commentF.comunication.isup = 1;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.praiseIndex inSection:0];
            [weakSelf.discussTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf popUp:@"点赞成功" time:1.0];
        }
    }];
    
}

#pragma mark - 点赞提醒
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


#pragma mark - 视图是否销毁
//取消通知
- (void)dealloc
{
    NSLog(@"帖子列表视图销毁了");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark - UITableExtViewDelegate
-(void)onRefresh:(UITableExtView *)tableview{
    NSLog(@"刷新中....");
    self.page = 1;
    [self network];
}

- (void)onNextPage:(UITableExtView *)tableview
{
    NSLog(@"-2222222--");
    if (self.total > self.page * 10) {
        self.page++;
        [self network];
    }
}
- (BOOL)isNeedRefresh:(UITableExtView *)tableview
{
    NSLog(@"111111111111");
    if (tableview == self.discussTableView) {
        return YES;
    }
    return NO;
}


@end






