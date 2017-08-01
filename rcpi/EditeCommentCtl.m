//
//  EditeCommentCtl.m
//  rcpi
//
//  Created by admin on 15/12/21.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "EditeCommentCtl.h"
#import "Config.h"

@interface EditeCommentCtl ()<UITextViewDelegate>

@property (nonatomic,copy)NSString *textStr;
@property (nonatomic,strong)UILabel *placeholderL;


@end

@implementation EditeCommentCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNav];
    
    [self addTextView];
    
    
    
}

/** 修改导航栏 */
-(void)setNav{
    UIButton *rightBt=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBt.frame=CGRectMake(0, 0, 40, 30);
    [rightBt setTitle:@"发送" forState:UIControlStateNormal];
    [rightBt addTarget:self action:@selector(rightbtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBt];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(kScreen.width/2-60, 10, 50, 40)];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0 green:192/255.0 blue:183/255.0 alpha:100.0]];
    lable.textAlignment=NSTextAlignmentCenter;
    lable.text=@"发表";
    lable.textColor=[UIColor whiteColor];
    lable.font=[UIFont systemFontOfSize:20];
    self.navigationItem.titleView=lable;
}
//编辑输入框
- (void)addTextView
{
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(8, 64 + 8, kScreen.width - 2 * 8, 250)];
    [self.view addSubview:self.textView];
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:20];
    
    self.placeholderL = [[UILabel alloc]init];
    self.placeholderL.frame =CGRectMake(5, 0, 40, 40);
    self.placeholderL.text = @"评论";
    self.placeholderL.textColor = [UIColor lightGrayColor];
    self.placeholderL.font = [UIFont systemFontOfSize:20];
    self.placeholderL.enabled = NO;//lable必须设置为不可用
    self.placeholderL.backgroundColor = [UIColor clearColor];
    [self.textView addSubview:self.placeholderL];


}


//发送评论
- (void)rightbtnClick
{
    [self.textView resignFirstResponder];
    NSString *tokenID = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"];
    NSString *urlType = @"/usr/addComment";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DC_SRV,urlType];
    NSDictionary *params = @{@"msg":self.textStr,@"pid":@"0",@"token":tokenID,@"topicId":self.topicId};
    __weak typeof(self) weakSelf = self;
    [H doGet:urlStr args:params json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err) {
            NSLog(@"评论失败");
        }
        else if ([[json valueForKey:@"code"] integerValue] == 0)
        {
            NSLog(@"评论成功");
            [[NSNotificationCenter defaultCenter]postNotificationName:@"commentSuccess" object:@"comment"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length == 0)
    {
        self.placeholderL.text = @"评论";
    }else
    {
        self.placeholderL.text = @"";
    }
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.textStr = textView.text;
    NSLog(@"texte == %@",self.textStr);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 观看视图控制器是否销毁
- (void)dealloc
{
    NSLog(@"编辑销毁");
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
