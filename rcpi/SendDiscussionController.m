//
//  SendDiscussionController.m
//  rcpi
//
//  Created by admin on 15/12/17.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "SendDiscussionController.h"
#import "DiscussEditController.h"
#import "Config.h"

#define kScreen [UIScreen mainScreen].bounds.size

@interface SendDiscussionController ()<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic,strong)UIButton *tagButton;
@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)UILabel  *placeholderL;
@property (nonatomic,strong)NSTimer *timer;

@end

@implementation SendDiscussionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNav];
    
    [self addEditeView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTag:) name:@"changeTag" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**修改导航条*/
-(void)setNav{
    
    UIButton *rightBt=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBt.frame=CGRectMake(0, 0, 40, 25);
    [rightBt setTitle:@"发送" forState:UIControlStateNormal];
    [rightBt addTarget:self action:@selector(rightbtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBt];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(kScreen.width/2-60, 10, 50, 40)];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0 green:192/255.0 blue:183/255.0 alpha:100.0]];
    lable.textAlignment=NSTextAlignmentCenter;
    lable.text=@"发讨论";
    lable.textColor=[UIColor whiteColor];
    lable.font=[UIFont systemFontOfSize:20];
    self.navigationItem.titleView=lable;
}

/** 发送按钮，接口处理*/
- (void)rightbtnClick
{
    NSLog(@"==%@%@=",self.textView.text,self.textField.text);
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
    NSString *name = self.textField.text;
    NSString *msg  = self.textView.text;
    if (self.textView.text.length == 0 || self.textField.text.length == 0 ) {
        [self popUp:@"标题或内容为空" time:2.0];
        return ;
    }
    NSString *tokenID = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"];
    if (tokenID.length ==0) {
        return ;//重新登录；
    }
    NSString *urlType = @"/usr/addTopic";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?token=%@&m=C",DC_SRV,urlType,tokenID];
    NSDictionary *params = @{@"msg":msg,@"name":name,@"tag":@"11 123",@"type":@"DISCUSS",@"key":self.courseID};
    __weak typeof(self) weakSelf = self;
    [H doPost:urlStr dargs:params json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err) {
            NSLog(@"发表失败");
            NSLog(@"err=%@",err);
            [weakSelf popUp:@"发表失败" time:2.0];
        }
        else if ([[json valueForKey:@"code"] integerValue] == 0)
        {
            [self popUp:@"发表成功" time:1.0];
            
             NSLog(@"发表成功");
            //[[NSNotificationCenter defaultCenter]postNotificationName:@"commentSuccess" object:@"comment"];
            weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:weakSelf selector:@selector(popViewController) userInfo:nil repeats:NO];
        }
    }];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    self.timer = nil;
}

/** 添加编辑视图 */
- (void)addEditeView
{
    UIImageView *tagImg = [[UIImageView alloc]initWithFrame:CGRectMake(8, 64 + 8 + 12, 16, 16)];
    tagImg.image = [UIImage imageNamed:@"标签"];
    [self.view addSubview:tagImg];
    
    
    self.tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.tagButton.frame = CGRectMake(16 + 2 * 8, 64 + 8, kScreen.width - 16 - 3 * 8, 40);
    [self.tagButton addTarget:self action:@selector(addTag:) forControlEvents:UIControlEventTouchUpInside];
    self.tagButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.tagButton setTitle:@"点击添加标签(可选)" forState:UIControlStateNormal];
    self.tagButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.tagButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.tagButton];
    
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(8, 64 + 8 + 2+ 40, kScreen.width - 2 *8, 40)];
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
    self.textField.font = [UIFont systemFontOfSize:18];
    self.textField.placeholder = @"标题";

    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(8, 64 + 8 +2 + 40 + 2 + 40 , kScreen.width - 2 *8, 200)];
    self.textView.font = [UIFont systemFontOfSize:18];
    self.textView.delegate = self;
    //textView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.textView];
    
    self.placeholderL = [[UILabel alloc]init];
    self.placeholderL.frame =CGRectMake(5, 0, 40, 40);
    self.placeholderL.text = @"内容";
    self.placeholderL.enabled = NO;//lable必须设置为不可用
    self.placeholderL.backgroundColor = [UIColor clearColor];
    [self.textView addSubview:self.placeholderL];
    
    UIView *lineS = [[UIView alloc]initWithFrame:CGRectMake(8, 64 + 8 + 1 + 40, kScreen.width - 2 * 8, 1)];
    lineS.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineS];
    
    UIView *lineL = [[UIView alloc]initWithFrame:CGRectMake(8, 64 + 8 + 2 + 40 + 40 + 1, kScreen.width -2 * 8,1)];
    lineL.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineL];
    
    
}
/** 标签 */
- (void)addTag:(UIButton *)btn
{
    DiscussEditController *tagEditVC = [[DiscussEditController alloc]init];
    
    [self.navigationController pushViewController:tagEditVC animated:YES];
}



#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length == 0)
    {
        self.placeholderL.text = @"内容";
    }else
    {
        self.placeholderL.text = @"";
    }
}

#pragma mark - 发帖提醒
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


- (void)changeTag:(NSNotification *)noti
{
    NSDictionary *tagDict = [noti userInfo];
    //NSString *tagStr = [tagDict valueForKey:@""];
}


@end





