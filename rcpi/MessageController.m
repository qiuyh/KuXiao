//
//  MessageController.m
//  rcpi
//
//  Created by wu on 15/11/30.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "MessageController.h"
#import "Config.h"
#import "PopView.h"
#import "AddFriendsViewController.h"
#import "FriendsNoticeViewController.h"
#import "CreateGroupViewController.h"
#import "AddressBookTableViewController.h"
#import "UserInfoController.h"
#import "MessageTableViewCell.h"
#import "ChatContentList.h"
#import "ContactList.h"
#import "ChatController.h"
#import "LoginViewController.h"
#import "FriendsNoticeViewController.h"
#include <CoreData/CoreData.h>
#import "AppDelegate.h"
#define CELLID @"msgListCell"

@interface MessageController ()<UITableExtViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIView *btmBg;
@property (nonatomic,strong)UIView *popView;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic,strong)NSManagedObjectContext *context;
@property (nonatomic,assign)NSInteger count;
@property (nonatomic ,strong)PopView *pop;
@property (nonatomic,strong)NSArray *messageListArr;
@end

@implementation MessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHead];
    self.count = 0;
    [self createPopView];
    [self setMsgLIstTable];
 //   [self getMsgData];
   
    //[self removeMSgHistory];//删除一条本地记录
    //注册消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMessageListNotification:) name:@"changeMessageListNotification" object:nil];
}

-(void)setHead{
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"msg_more"] forState:UIControlStateNormal];
    self.rightBtn.frame = CGRectMake(0, 0, 20, 20);
    [self.rightBtn addTarget:self action:@selector(rightbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    
    UIButton *leftBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftBt setBackgroundImage:[UIImage imageNamed: @"Customer Service"] forState:UIControlStateNormal];
    [leftBt addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBt];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UILabel *tiLable=[[UILabel alloc]initWithFrame:CGRectMake(kScreen.width/2-60, 10, 100, 40)];
    tiLable.textAlignment=NSTextAlignmentCenter;
    tiLable.text=@"消息";
    tiLable.textColor=[UIColor whiteColor];
    tiLable.font=[UIFont systemFontOfSize:20];
    self.navigationItem.titleView=tiLable;

}

-(void)setMsgLIstTable{
    self.msgListTableView=[[UITableExtView alloc]initWithFrame:CGRectMake(0, 64,kScreen.width,kScreen.height-114)];
    self.msgListTableView.backgroundColor=[UIColor whiteColor];
    self.msgListTableView.delegate=self;
    self.msgListTableView.dataSource=self;
    self.msgListTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self.msgListTableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:self.msgListTableView];
    //cell
    [self.msgListTableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:CELLID];
    //去掉选中效果
    // self.msgListTableView.allowsSelection = NO;
    // hide line
    [UIView setExtraCellLineHidden:self.msgListTableView];
    


}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //重新获取一遍本地数据库的最近联系人列表
    AppDelegate *appD =[AppDelegate shared];
    self.context=appD.MSG_CONTEXT;
    [self searchMsg];
   
   
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
  
}
//通知消息方法
- (void)changeMessageListNotification:(NSNotification *)noti {
    //[self getDataAndReload];
    [self searchMsg];
}

//取消通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//获取个人消息列表数据
-(void)searchMsg{
    if ([PublicTool isSuccessLogin]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ContactList"];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"up_time" ascending:NO];
        request.sortDescriptors = [NSArray arrayWithObject:sort];
       NSPredicate *pre = [NSPredicate predicateWithFormat:@"u_id = %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"]];
       request.predicate = pre;
       NSError *error = nil;
       self.messageListArr = [self.context executeFetchRequest:request error:&error];
        if (self.messageListArr.count==0) {
            [self getMsgData];
        }
         [self.msgListTableView reloadData];
    }else{
        NSLog(@"未登录");
        [self jumpToLogin];//需要跳转到登录界面
    }
    
    
}

- (void)removeMSgHistory
{
    // 1. 实例化查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ContactList"];
    
    // 2. 设置谓词条件
    request.predicate = [NSPredicate predicateWithFormat:@"u_id=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"]];
    
    // 3. 由上下文查询数据
    NSArray *result = [_context executeFetchRequest:request error:nil];
   //   NSLog(@"删除前数据库：%ld",result.count);
    // 4. 输出结果
    for (ContactList *Contact in result) {
       //  NSLog(@"lalalalalallalala");
        // 删除一条记录
        [_context deleteObject:Contact];
        break;
    }
    // 5. 通知_context保存数据
    if ([_context save:nil]) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
   // NSArray *delArr=[_context executeFetchRequest:request error:nil];
  //  NSLog(@"删除后表格：%@",delArr);
    // NSLog(@"删除后数据库：%ld",delArr.count);
}
-(void)reloadListData{
    if (![PublicTool isSuccessLogin]) {
        NSLog(@"用户未登录！");
        [self jumpToLogin];
    }
}
-(void)getMsgData{
    if (![PublicTool isSuccessLogin]) {
        NSLog(@"用户未登录！");
        //[self jumpToLogin];
        return;
    }
    NSString *url=@"/usr/api/listRinfo";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",MSG_SRV,url];
    NSString *tokenId=[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"];
    NSDictionary *params=@{@"token":tokenId};
    [H doGet:urlStr args:params json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err) {
            NSLog(@"请求获取最近联系人列表失败");//处理方法待补充
        }else{
            NSLog(@"联系人列表数据%@",[json objectForKey:@"data"]);
            NSDictionary *msgList = json[@"data"];
           // [self.curryData containsObject:arg_name]
            for (NSDictionary *msg in msgList ) {//循环
                //...........获取最新的消息时间、
                 NSString *sIdStr= [[msg objectForKey:@"r"] substringFromIndex:2];
                NSFetchRequest *msgrequest=[NSFetchRequest fetchRequestWithEntityName:@"ChatContentList"];
                NSPredicate *msgPre=[NSPredicate predicateWithFormat:@"s_id = %@",sIdStr];
                msgrequest.predicate=msgPre;
                NSError *errorS=nil;
                ChatContentList *msgData=[[self.context executeFetchRequest:msgrequest error:&errorS]lastObject];
                
                //创建实体
                ContactList *ContListEntity = [NSEntityDescription insertNewObjectForEntityForName:@"ContactList" inManagedObjectContext:self.context];
                //插入数据
                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ContactList"];
                NSPredicate *pre = [NSPredicate predicateWithFormat:@"s_id = %@",sIdStr];
                request.predicate = pre;
                NSError *error = nil;
                NSArray *hisData = [self.context executeFetchRequest:request error:&error];
                // NSLog(@"s_id:%@",[msg objectForKey:@"r"]);
               //  NSLog(@"插入前判断：%ld",hisData.count);
                
                if (hisData.count==0) {//联系人表中已经有的不添加
                   // NSLog(@"添加");
                    ContListEntity.u_alias=[msg objectForKey:@"alias"];
                   
                    ContListEntity.s_id=sIdStr;
                    ContListEntity.u_img=[msg objectForKey:@"img"];
                    ContListEntity.u_type=@([[msg objectForKey:@"type"] integerValue]);
                    //ContList.up_time
                    ContListEntity.u_online= @([[msg objectForKey:@"online"] integerValue]);
                    ContListEntity.u_id=[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
                    ContListEntity.up_time=msgData.chat_time;//修改时间
//                NSSet *contavtSet=[NSSet setWithObject:ContListEntity];
                    NSError *err = nil;
                if ([self.context save:&err]) {//保存数据
                  //  NSLog(@"保存数据成功");
                 
                    //NSArray *arr = [_context executeFetchRequest:request error:nil];
                   // NSLog(@"arr======%@",arr);

                }else{
                    
                    NSLog(@"保存数据失败");
                 [NSException raise:@"保存数据失败" format:@"==%@", [err localizedDescription]];
                }
                }else{
                    for (ContactList *cont in hisData) {
                         cont.up_time=msgData.chat_time;//修改时间
                    }

                    NSError *err = nil;
                    if ([self.context save:&err]) {//保存数据
                       // NSLog(@"保存数据成功");
                        
                        //NSArray *arr = [_context executeFetchRequest:request error:nil];
                        // NSLog(@"arr======%@",arr);
                        
                    }else{
                        
                        NSLog(@"保存数据失败");
                        [NSException raise:@"保存数据失败" format:@"==%@", [err localizedDescription]];
                    }
                }
              
            }
        }
    }];
    
    



}

//jump to login
- (void)jumpToLogin{
    LoginViewController *Login = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:Login animated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"row num=%ld",self.messageListArr.count+2);
    return self.messageListArr.count+2;//待完善
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 45;//搜索栏
    }else{
         return 65;//消息列表
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){//第一行是搜索
    NSString *cellId=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if(!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        }
        UISearchBar *searchBar =[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreen.width, 45)];
        searchBar.placeholder=@"搜索";
        searchBar.userInteractionEnabled=NO;
        searchBar.backgroundColor=[UIColor clearColor];
        searchBar.backgroundImage=[UIImage imageNamed:@"com_grayBack"];
//        UIView *bview = [UIView new];
//        bview.backgroundColor = [UIColor clearColor];
//        for (UIView *view in searchBar.subviews) {
//            // for before iOS7.0
//            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
//                view.backgroundColor=[UIColor clearColor];
//                
//                break;
//            }
//            // for later iOS7.0(include)
//            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
//                NSLog(@"========321321========%@",view.subviews);
//               [view.subviews objectAtIndex:0].backgroundColor=[UIColor redColor];
//            
//                break;
//            }
//        }
        
        [cell addSubview:searchBar];
        return cell;
    }else if (indexPath.row==1){
        MessageTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
        cell.userImageView.image=[UIImage imageNamed:@"msg_custmer"];
        cell.userNameLable.text=@"客服";
        cell.MsgLable.text=@"亲，需要什么帮助吗?";
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yy-MM-dd"];
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        cell.TimeLabel.text=dateStr;
        
    return cell;
    
    }else{
        MessageTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
        ContactList *contactData=self.messageListArr[indexPath.row-2];
        NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"ChatContentList"];
        NSPredicate *pre=[NSPredicate predicateWithFormat:@"s_id=%@",contactData.s_id];
                          request.predicate=pre;
                          NSError *error=nil;
        ChatContentList *msgData=[[self.context executeFetchRequest:request error:&error]lastObject];
        [cell.userImageView setUrl:contactData.u_img];
        cell.userNameLable.text=contactData.u_alias;
        cell.MsgLable.text=msgData.chat_content;
        if (msgData.chat_time) {
            cell.TimeLabel.text = [PublicTool timeFunc:msgData.chat_time];
        }
    return cell;
    }
}





//点击联系人
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//      UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
//      UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
//      cell.selectedBackgroundView = backView;
//      cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row ==1) {
        NSString *urlStr = [NSString stringWithFormat:@"%@/sel-help",KF_SRV];
        __weak typeof(self) weakSelf = self;
        [H doGet:urlStr json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
            if (err) {
                  NSLog(@"获取客服失败");//处理方法待补充
            }else{
                NSDictionary *dic = [json objectForKey:@"data"];
                ChatController *chatVC = [[ChatController alloc]init];
                chatVC.name = [dic objectForKey:@"alias"];
                chatVC.r = [dic objectForKey:@"uuid"];
                chatVC.img = [dic objectForKey:@"img"];
                NSString *uidStr= [[dic objectForKey:@"uuid"] substringFromIndex:2];
                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ContactList"];
                NSPredicate *pre = [NSPredicate predicateWithFormat:@"s_id=%@",uidStr];
                request.predicate = pre;
                NSArray *arr = [self.context executeFetchRequest:request error:nil];
                if (arr.count==0) {//如果消息列表没有这个人，添加一条最近联系人记录
                    ContactList *msgList = [NSEntityDescription insertNewObjectForEntityForName:@"ContactList" inManagedObjectContext:self.context];
                    msgList.u_alias = [dic objectForKey:@"alias"];
                    NSString *uuid=[dic objectForKey:@"uuid"];
                    msgList.s_id= [PublicTool cutString:uuid f_index:2 e_index:uuid.length-2];
                    msgList.u_online = @([[dic objectForKey:@"online"] integerValue]);
                    msgList.u_img = [dic objectForKey:@"img"];
                    msgList.u_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
                    
                    NSError *err = nil;
                    [self.context save:&err];
                    if (err) {
                        NSLog(@"保存客服最近联系人失败%@",err);
                        NSELog(@"保存客服最近联系人失败%@",err);
                    }
                }
                
                [weakSelf.navigationController pushViewController:chatVC animated:YES];//跳到聊天界面
                
            }
        }];
    }else if (indexPath.row >=2) {
        
        ContactList *messageLM = self.messageListArr[indexPath.row-2];
       // NSLog(@"我点是：%@",messageLM.s_id);
        if ([messageLM.s_id isEqualToString:@"1"]) {//好友通知
            FriendsNoticeViewController *friendsNotice=[[FriendsNoticeViewController alloc]init];
            [self.navigationController pushViewController:friendsNotice animated:YES];
        
        }else {
            ChatController *chatC = [[ChatController alloc]init];
            chatC.name = messageLM.u_alias;
            chatC.r = messageLM.s_id;
            chatC.img = messageLM.u_img;
            [self.navigationController pushViewController:chatC animated:YES];
        }
    }
}





//...进入个人信息
- (void)leftBtnClick {
   // NSLog(@"点击个人信息");
    UserInfoController *userInfo=[[UserInfoController alloc]init];
    [self.navigationController pushViewController:userInfo animated:YES];
}


/**
添加通讯录部分:邓翠
 */
//...dc
-(void)createPopView {
    self.bgView = [[UIView alloc]init];
    self.bgView.frame = self.view.frame;
    self.bgView.backgroundColor = [UIColor clearColor];
    self.bgView.hidden = YES;
    [self.view addSubview:self.bgView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTaps:)];
    [self.bgView addGestureRecognizer:tapGestureRecognizer];
    
    NSArray *arr = @[@"通讯录",@"添加朋友",@"创建群组"];
    NSArray *imgArr = @[[UIImage imageNamed:@"msg_book"],[UIImage imageNamed:@"msg_addfriend"],[UIImage imageNamed:@"msg_creatGroup"]];
    self.pop = [[PopView alloc]initWithTitleArray:arr imageArray:imgArr Frame:CGRectMake(kScreen.width/2+30, 74, kScreen.width*0.4, 120) delegate:self];
    [self.bgView addSubview:self.pop];
    
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"msg_tips"]];
    img.frame = CGRectMake(kScreen.width -30, 64, 10, 10);
    [self.bgView addSubview:img];
}
//...dc
-(void)PopView:(PopView *)PopView clickButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        
        self.bgView.hidden = YES;
        self.rightBtn.selected = !self.rightBtn.isSelected;
        AddressBookTableViewController *vc = [[AddressBookTableViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    } else if(buttonIndex == 1) {
        self.bgView.hidden = YES;
        self.rightBtn.selected =! self.rightBtn.isSelected;
        AddFriendsViewController *vc = [[AddFriendsViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if(buttonIndex == 2) {
        
        self.bgView.hidden = YES;
        self.rightBtn.selected = !self.rightBtn.isSelected;
        
        CreateGroupViewController *vc = [[CreateGroupViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}
//...dc
-(void)handleTaps:(UITapGestureRecognizer *)tap {
    self.rightBtn.selected = !self.rightBtn.isSelected;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.popView.alpha = 0;
        weakSelf.bgView.hidden = YES;
    }];
}
//...dc
-(void)addFriendBtnClick {
    self.bgView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.popView.alpha = 0;
        
        weakSelf.rightBtn.selected = !self.rightBtn.isSelected;
    } completion:^(BOOL finished) {
        AddFriendsViewController *vc = [[AddFriendsViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
}

//...dc
- (void)rightbtnClick:(UIButton *)sender {
        AddressBookTableViewController *addressBookTVC = [[AddressBookTableViewController alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addressBookTVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    __weak typeof(self) weakSelf = self;
    if(sender.isSelected == NO) {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.popView.alpha = 0.7;
            weakSelf.bgView.hidden = NO;
        }];
    } if(sender.isSelected == YES) {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.popView.alpha = 0;
            weakSelf.bgView.hidden = YES;
        }];
    }
    sender.selected = !sender.isSelected;
}
/**
 添加通讯录部分:邓翠
 */





@end
