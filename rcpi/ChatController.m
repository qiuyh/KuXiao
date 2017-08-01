//
//  ChatController.m
//  rcpi
//
//  Created by Dyang on 15/12/14.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "ChatController.h"
#import <iwf/iwf.h>
#import "MyMessage.h"
#import "MessageFrame.h"
#import "AppDelegate.h"
#import "Config.h"
#import "ChatMsgTableViewCell.h"
#import <CoreData/CoreData.h>
#import "ChatContentList.h"
#import "ContactList.h"
#import "AppDelegate.h"

@interface ChatController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (nonatomic,strong) NSMutableArray *msgFrames;
@property (nonatomic,strong) NSManagedObjectContext *context;
@property (nonatomic,strong) NSArray *msgArray;
@property (nonatomic,strong) NSString *userId;

@end

@implementation ChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    AppDelegate *appD =[[AppDelegate alloc]init];
    self.context=appD.getConText;
    //联系人名字
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    titleLabel.center = [UIScreen mainScreen].bounds.origin;
    titleLabel.text = self.name;//聊天对象的名字
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    //右边功能按钮（未完成，暂时默认）
    UIButton *moreMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreMsgBtn setBackgroundImage:[UIImage imageNamed:@"chat_msgTask"] forState:UIControlStateNormal];
    moreMsgBtn.frame = CGRectMake(0, 0, 20, 20);
    [moreMsgBtn addTarget:self action:@selector(moreMessageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *moreMsgItem = [[UIBarButtonItem alloc]initWithCustomView:moreMsgBtn];
    UIButton *studyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [studyBtn setBackgroundImage:[UIImage imageNamed:@"chat_guide_learn"] forState:UIControlStateNormal];
    studyBtn.frame = CGRectMake(0, 0, 22, 22);
    UIBarButtonItem *studyItem = [[UIBarButtonItem alloc]initWithCustomView:studyBtn];
    self.navigationItem.rightBarButtonItems = @[studyItem,moreMsgItem];
    if (self.msgFrames.count) {//有聊天记录的时候、定位显示到最新的聊天记录位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.msgFrames.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMessageListNotification:) name:@"changeMessageListNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
     [self setChatTable];//加载聊天列表
}

//聊天列表

-(void)setChatTable{

    //Set TableView
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.textView.delegate = self;
    self.textView.keyboardType = UIKeyboardTypeDefault;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
    //去除选中背景
    self.tableView.allowsSelection = NO;
    //去除分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.textView.leftViewMode = UITextFieldViewModeAlways;

}




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getMsgArr];//获取本地聊天记录
    if (self.msgFrames.count) {//有聊天记录的时候、定位显示到最新的聊天记录位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.msgFrames.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)changeMessageListNotification:(NSNotification *)noti {
    [self getMsgArr];
    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.msgFrames.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
- (void)getMsgArr {//获取本地聊天记录
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ChatContentList"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"u_id=%@",self.userId];//获取消息记录表中的本人部分信息
    request.predicate = pre;
    NSError *error = nil;
    self.msgArray = [self.context executeFetchRequest:request error:&error];
    //NSLog(@"my id :%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"]);
    //NSLog(@"aaaa%@",self.msgArray);
    NSMutableArray *muArray = [[NSMutableArray alloc]init];
    for (int i = 0;i < self.msgArray.count;i++) {
        MyMessage *msg = [[MyMessage alloc]init];
        ChatContentList *chatMsg = self.msgArray[i];
        
        if ([chatMsg.s_id isEqualToString:self.r] || [chatMsg.r_id isEqualToString:self.r]) {
            msg.text = chatMsg.chat_content;
            //NSLog(@"chat time%@",chatMsg.chat_time);
            msg.time = [PublicTool timeFunc:chatMsg.chat_time];//时间待处理
            //NSLog(@" cur  chat time%@",msg.time);
            if ([chatMsg.s_id isEqualToString:self.r]) {//筛选聊天消息
                msg.type = MessageTypeOther;//别人发来的
            }else if ([chatMsg.s_id isEqualToString:self.userId]&&[chatMsg.r_id isEqualToString:self.r]){
                msg.type = MessageTypeMe;//自己发给别人的
            }
            
            MessageFrame *msgFrame = [[MessageFrame alloc]init];
            MessageFrame *lastMsgFrame = [muArray lastObject];
            if (msg.time == lastMsgFrame.message.time) {
                msg.hideTime = YES;
            }
            msgFrame.message = msg;
            [muArray addObject:msgFrame];
        }
      
    }
    [self.msgFrames removeAllObjects];
     self.msgFrames = muArray;
    [self.tableView reloadData];
     //NSLog(@"lalalalalal%@",self.msgFrames);
}


#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   // NSLog(@"self.msgFrames.count:%ld",self.msgFrames.count);
    return self.msgFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatMsgTableViewCell *cell = [ChatMsgTableViewCell cellWithTableView:tableView];
    cell.otherImg = self.img;
    cell.messageFrame = self.msgFrames[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageFrame *msgFrame = self.msgFrames[indexPath.row];
    return msgFrame.cellHeight;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - changeViewAnimation
- (void)changeFrame:(NSNotification *)note {
    self.view.superview.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
    CGFloat duration = [note.userInfo [UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat keyboardY = [note.userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    UIViewAnimationOptions option = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, keyboardY - screenH);
    } completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)moreMessageButtonClick {
    
}


//发送消息
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    //发送消息
    AppDelegate *appD = [AppDelegate shared];
    NSString *re_id=[NSString stringWithFormat:@"U-%@",self.r];
    NSLog(@"%@",re_id);
    [appD sendMessageWithMsg:textField.text AndUid:re_id];
   
    //本地存储消息
    MyMessage *msg = [[MyMessage alloc]init];
    msg.text = textField.text;//消息内容
    msg.type = MessageTypeMe;//我发的消息
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    msg.time = [dateFormatter stringFromDate:now];//当前时间
    
    MessageFrame *lastMsgFrame = [self.msgFrames lastObject];
    msg.hideTime = [lastMsgFrame.message.time isEqualToString:msg.time];
    
    MessageFrame *msgFrame = [[MessageFrame alloc] init];
    msgFrame.message = msg;
    
    ChatContentList *chatMsg = [NSEntityDescription insertNewObjectForEntityForName:@"ChatContentList" inManagedObjectContext:self.context];
    // NSLog(@"lalalal%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"]);
    //NSLog(@"----------------dsadsa-------------%@",self.userId);
    NSString *myId=[NSString stringWithFormat:@"%@",self.userId];
    chatMsg.s_id = myId;
    chatMsg.chat_content = textField.text;
    chatMsg.u_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    chatMsg.r_id=self.r;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue]; // 将double转为long long型
     //NSString *curTime = [NSString stringWithFormat:@"%llu",dTime*1000]; // 输出long long型
    //NSString *t=[PublicTool timeFunc:@(dTime*1000)];
   // NSLog(@"当前聊天时间====%@",t);
    
    //NSLog(@"当前聊天时间：%@",curTime);
    chatMsg.chat_time = @(dTime*1000);
    NSError *err = nil;
    [self.context save:&err];
    if (err) {
        NSLog(@"本地存储发送消息失败: %@",err);
    }
    [self.msgFrames addObject:msgFrame];
    //清空
    self.textView.text = nil;
    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.msgFrames.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    return YES;
}

- (NSMutableArray *)msgFrames {
    if (_msgFrames == nil) {
        
        
        //        _msgFrames = muArray;
    }
    return _msgFrames;
}



@end
