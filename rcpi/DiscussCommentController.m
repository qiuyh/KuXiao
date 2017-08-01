//
//  DiscussCommentController.m
//  rcpi
//
//  Created by admin on 15/12/20.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "DiscussCommentController.h"
#import "Config.h"
#import "DisccussTool.h"
#import "CommentModel.h"
#import "CommuicationCell.h"
#import "SendDiscussionController.h"
#import "PublicTool.h"
#import "EditeCommentCtl.h"


//背景色
#define LightGrayColor [UIColor colorWithRed:239.0 / 255 green:239.0 / 255 blue:239.0 / 255 alpha:1.0]
//楼主背景颜色
#define PREFloor [UIColor colorWithRed:3.0 / 255.0 green:180.0 / 255.0 blue:170.0 / 255.0 alpha:1.0]
//楼主文字颜色
#define UNAMECOLOR [UIColor colorWithRed:43.0 / 255.0 green:127.0 / 255.0 blue:251.0 / 255.0 alpha:1.0]

@interface DiscussCommentController ()

@property (nonatomic,strong)UITableExtView *discussTableView;
//存放评论的数组
@property (nonatomic,strong)NSMutableArray *commentArrM;

@property (nonatomic,assign)CGFloat OneCellHeight;

@property (nonatomic,strong)UILabel   *commentL;
@property (nonatomic,strong)UILabel   *praiseL;
@property (nonatomic,strong)UIButton  *commentB;
@property (nonatomic,strong)UIButton  *praiseB;



@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic,strong)UILabel *footTitleL;

@property (nonatomic,assign)NSInteger page;//请求到第几页数据
@property (nonatomic)BOOL islogin;
@property (nonatomic)BOOL isjoin;


@property (nonatomic,assign)NSInteger up;//按钮数值修改，图片修改
@property (nonatomic,assign)NSInteger comments;//评论
@property (nonatomic)BOOL isUp;//点赞状态
@property (nonatomic,strong)UIButton *cellCommentB;
@property (nonatomic,assign)NSInteger total;//总评论数目


@end

@implementation DiscussCommentController


- (NSMutableArray *)communtArrM
{
    if (!_commentArrM)
    {
        _commentArrM = [NSMutableArray array];
    }
    return _commentArrM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = LightGrayColor;
    
    [self setNav];
    
    [self addTableView];
    //改变cell的属性
    [self changeCellFrame];
     self.page = 1;
    
    //增加底部按钮
     [self addBtn];
    
    //请求数据
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self network];
}

/**  去掉按钮条  */
- (void)changeCellFrame
{
    Communication *communication = _commentF.comunication;
    self.isUp = communication.isup;
    self.up = communication.up;
    self.topicId =communication.tid;
    self.comments = communication.comments;
    NSLog(@"===== %@",self.topicId);
    NSLog(@"=====   %d==",self.comments);
    if (communication.name.length == 0)
    {
        self.OneCellHeight = _commentF.cellNameHeight;
    }
    else
    {
        self.OneCellHeight = _commentF.cellTagHeight;
    }
    [self.discussTableView reloadData];
    
}

//导航栏
- (void)setNav
{
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(kScreen.width/2-60, 10, 50, 40)];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0 green:192/255.0 blue:183/255.0 alpha:100.0]];
    lable.textAlignment=NSTextAlignmentCenter;
    lable.text=@"讨论";
    lable.textColor=[UIColor whiteColor];
    lable.font=[UIFont systemFontOfSize:25];
    self.navigationItem.titleView=lable;    
    
}

/**增加一个TableView */
- (void)addTableView
{
    self.discussTableView = [[UITableExtView alloc]initWithFrame:CGRectMake(0, 0, kScreen.width, kScreen.height  - 49)];
    self.discussTableView.delegate = self;
    self.discussTableView.dataSource = self;
    self.discussTableView.scrollEnabled = YES;
    self.discussTableView.backgroundColor = [UIColor whiteColor];
    self.discussTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.discussTableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:self.discussTableView];
}


/** 底部两个按钮  */
- (void)addBtn
{
    self.commentB = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commentB.frame = CGRectMake(kScreen.width / 2  + 1, kScreen.height - 49, kScreen.width / 2 -1, 49);
    self.commentB.backgroundColor = [UIColor whiteColor];
    [self.commentB setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
    [self.commentB setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.commentB setTitle:[NSString stringWithFormat:@"评论(%ld)",self.comments] forState:UIControlStateNormal];
    self.commentB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.commentB.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.commentB addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.commentB];
    
    self.praiseB = [UIButton buttonWithType:UIButtonTypeCustom];
    self.praiseB.frame = CGRectMake(0, kScreen.height - 49, kScreen.width / 2 -1, 49);
    self.praiseB.backgroundColor = [UIColor whiteColor];
    [self.praiseB setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.praiseB setTitle:[NSString stringWithFormat:@"赞(%ld)",self.up] forState:UIControlStateNormal];
    self.praiseB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.praiseB.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.praiseB addTarget:self action:@selector(praise:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.praiseB];
    
    Communication *communication = _commentF.comunication;
    if (communication.isup)
    {
        [self.praiseB setImage:[UIImage imageNamed:@"icon_select_laud"] forState:UIControlStateNormal];
    }
    else
    {
        [self.praiseB setImage:[UIImage imageNamed:@"icon_laud"] forState:UIControlStateNormal];
    }
}

//评论成功后，修改一些属性
- (void)ChangBtnAndLableValue
{
   [self.praiseB setTitle:[NSString stringWithFormat:@"赞(%ld)",self.up] forState:UIControlStateNormal];
    [self.commentB setTitle:[NSString stringWithFormat:@"评论(%ld)",self.comments] forState:UIControlStateNormal];
    self.commentL.text = [NSString stringWithFormat:@"评论(%ld)",self.comments];
    [self.cellCommentB setTitle:[NSString stringWithFormat:@"%ld",self.comments] forState:UIControlStateNormal];
}

/** 对帖子 点赞 */
- (void)praise:(UIButton *)btn
{
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
        if (isJoin)
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
            weakSelf.praiseL.text = [NSString stringWithFormat:@"赞(%ld)",weakSelf.up];
            [weakSelf.praiseB setTitle:[NSString stringWithFormat:@"赞(%ld)",weakSelf.up] forState:UIControlStateNormal];
            [weakSelf.praiseB setImage:[UIImage imageNamed:@"icon_select_laud"]forState:UIControlStateNormal];
            [weakSelf popUp:@"点赞成功" time:1.0];
            weakSelf.block(weakSelf.isUp);
        }
    }];

}

/** 对帖子评论  */
- (void)comment:(UIButton *)btn
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
            [weakSelf goToEditComment];
        }
        else
        {
            [weakSelf popUp:@"您未参与该课程" time:2.0];
        }
    }];
}
//跳到评论编辑页面，编辑并发送
- (void)goToEditComment
{
    EditeCommentCtl *editVC = [[EditeCommentCtl alloc]init];
    editVC.topicId = self.topicId;
    [self.navigationController pushViewController:editVC animated:YES];
}


#pragma mark - netWork
//先写一页;
- (void)network
{
    NSString *pageStr = [NSString stringWithFormat:@"%d",self.page];
    NSString *urlType = @"/listComment";
    NSString *srv = @"http://dms.dev.jxzy.com";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",srv,urlType];
    NSString *tokenID = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"];
    NSDictionary *params;
    if (tokenID) {
        params = @{@"commentType":@"COMMENT",@"order":@"desc",@"pageNo":pageStr,@"pageSize":@"10",@"token":tokenID,@"topicId":self.topicId,@"type":@"LIST"};
    }
    else
    {
        params = @{@"commentType":@"COMMENT",@"order":@"desc",@"pageNo":@"1",@"pageSize":@"10",@"topicId":self.topicId,@"type":@"LIST"};
    }
    [H doGet:urlStr args:params json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err)
     {
        if (err)
        {
            NSELog(@"数据请求错误%@",err.userInfo);
        }else if([json[@"code"] integerValue]==0)
        {
            if (self.page == 1) {
            
                [self.commentArrM removeAllObjects];
            }
            NSLog(@"成功请求数据返回");
            [self popUp:@"更新成功" time:0.5];
            self.dict = [json valueForKey:@"data"];
           [self changeCommunication];
        }
         //[[LoadingView shareWait]stopWaiting];

    }];
}
- (void)changeCommunication
{
    __weak typeof(self) weakSelf = self;
    NSArray *array = [self.dict valueForKey:@"list"];
    NSLog(@"array.count === %d",array.count);
    for (NSDictionary *listDict in array)
    {
        CommentModel *commentModel = [[CommentModel alloc]initWithDic:listDict];
        //时间修改
        NSString *floorAndTime = [NSString stringWithFormat:@"%@楼 %@",commentModel.floorNo,commentModel.time];
        commentModel.time = floorAndTime;
        [self.commentArrM addObject:commentModel];
        }
    //评论数目
    NSDictionary *topicDic = [self.dict valueForKey:@"topic"];
    self.comments = [[self.dict valueForKey:@"total"] integerValue];
    NSLog(@"self.comments === %d",self.comments);
    self.up = [[topicDic valueForKey:@"up"] integerValue];
    [weakSelf ChangBtnAndLableValue];
    [self.discussTableView reloadData];

}

#pragma mark -UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    return self.communtArrM.count == 0?0:self.communtArrM.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
    static NSString *cellID = @"discussComment";
        DiscussionCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[DiscussionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.communicationgFrame = _commentF;
        cell.unameL.textColor = UNAMECOLOR;
        cell.preFloorL.hidden = NO;
        cell.discussB.hidden = NO;
        cell.buttonV.hidden = YES;
        self.cellCommentB = cell.discussB;
        cell.backgroundColor = LightGrayColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString *reusedID = @"commentCell";
    CommuicationCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedID];
    NSLog(@"indexPath.row ===  %d",indexPath.row);
    if (!cell)
    {
        cell = [[CommuicationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedID];
    }
    cell.commentModel = _commentArrM[indexPath.row];
    cell.praiseB.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0)
    {
        return _OneCellHeight;
        
    }
    CommentModel *commentModel = _commentArrM[indexPath.row];
    return commentModel.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    if (section == 1 && _commentArrM.count == 0) {
        return 40;
    }
    return 0.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self addSectionView];
}

- (UIView *)addSectionView
{
    Communication *commnication = _commentF.comunication;
    UIView *sectionView = [[UIView alloc]init];
    sectionView.frame = CGRectMake(0, 0, kScreen.width, 40);
    sectionView.backgroundColor = [UIColor whiteColor];
    
    self.commentL = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, kScreen.width / 3, 40)];
    self.commentL.textColor = PREFloor;
    self.commentL.text = [NSString stringWithFormat:@"评论(%d)",commnication.comments];
    [sectionView addSubview:self.commentL];
    
    self.praiseL = [[UILabel alloc]initWithFrame:CGRectMake(kScreen.width /3, 0, kScreen.width / 3, 40)];
    self.praiseL.text = [NSString stringWithFormat:@"赞(%d)",commnication.up];
    [sectionView addSubview:self.praiseL];
    return sectionView;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1 && _commentArrM.count == 0) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen.width, 40)];
        label.text = @"暂无更多评论~";
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }
    
    return nil;
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
- (void)dealloc
{
    NSLog(@"帖子评论列表销毁");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableExtViewDelegate
-(void)onRefresh:(UITableExtView *)tableview{
    NSLog(@"刷新中....");
    self.page = 1;
    [self network];
}

- (void)onNextPage:(UITableExtView *)tableview
{
    if (self.comments > self.page * 10) {
        self.page++;
        [self network];
    }
}

- (BOOL)isNeedRefresh:(UITableExtView *)tableview
{
    if (tableview == self.discussTableView) {
        return YES;
    }
    return NO;
}



@end











