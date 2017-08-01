//
//  MyCourseController.m
//  rcpi
//
//  Created by Dyang on 15/12/1.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "MyCourseController.h"
#import "Config.h"
#import "RegisterController.h"
#import "LoginViewController.h"
#import "MyCourseTableViewCell.h"
#import "MyCourseModel.h"
#import "userInfoController.h"
#import "HistorySearchController.h"
#import "CourseDetailsViewController.h"
#define CELLID @"myCourseCell"
#define PS 12
@interface MyCourseController ()<UITableViewDataSource,UITableExtViewDelegate>
@property (nonatomic,strong)NSMutableArray *myCourseArr;
@property(nonatomic)NSNumber* totalCourse;
@property(nonatomic,assign)NSInteger pageCourseCount;
@property(nonatomic,assign)int coursePn;
@end

@implementation MyCourseController

- (void)viewWillAppear:(BOOL)animated{
    [self showIcon];
    [self isPubSeach];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.coursePn=1;
    [self setNav];
    self.myCourseArrayContent=nil;
}

/**
 设置头部
 */
-(void)setNav{
    UILabel *tiLable=[[UILabel alloc]initWithFrame:CGRectMake(kScreen.width/2-60, 10, 100, 40)];
    tiLable.textAlignment=NSTextAlignmentCenter;
    tiLable.text=@"我的课程";
    tiLable.textColor=[UIColor whiteColor];
    tiLable.font=[UIFont systemFontOfSize:20];
    self.navigationItem.titleView=tiLable;

    UIButton *rightBt=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBt setBackgroundImage:[UIImage imageNamed:@"fp_search"] forState:UIControlStateNormal];
    rightBt.frame=CGRectMake(0, 0, 25, 25);
    [rightBt addTarget:self action:@selector(jumpToSearch) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBt];
    
    UIButton *leftBt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftBt setBackgroundImage:[UIImage imageNamed:@"Customer Service"] forState:UIControlStateNormal];
    [leftBt addTarget:self action:@selector(jumpToUserInfo) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftBt];
    
}

/**
没有课程状态或者没有登录，显示图标
 */
-(void)hideIcon{
    [self.myCourseTableView removeFromSuperview];
    [self.immLoginButton setHidden:YES];
    [self.immRegisterButton setHidden:YES];
    [self.myCourseIcon setHidden:YES];
    [self.myCourseLable setHidden:YES];
}
-(void)showIcon{
    [self.myCourseTableView removeFromSuperview];
    [self.immLoginButton setHidden:YES];
    [self.immRegisterButton setHidden:YES];
    [self.myCourseIcon setHidden:YES];
    [self.myCourseLable setHidden:YES];
    NSLog(@"user is login: %d",[PublicTool isSuccessLogin]);
    if (![PublicTool isSuccessLogin]) {
        NSLog(@"你还没有登录,请登录!");
    [self.myCourseTableView removeFromSuperview];
    self.myCourseLable.text=@"你还没有登录,请登录!";
    [self.immLoginButton setHidden:NO];
    [self.immRegisterButton setHidden:NO];
    [self.myCourseIcon setHidden:NO];
    [self.myCourseLable setHidden:NO];
    }
}
-(void)showCourseIcon{
    NSLog(@"用户参与课程数: %ld",(unsigned long)self.myCourseArrayContent.count);
    if (self.myCourseArrayContent.count==0||self.myCourseArrayContent==nil) {//用户参与课程数判断
        [self.myCourseTableView removeFromSuperview];
        self.myCourseLable.text=@"你还没有参与任何课程的学习！";
        [self.immLoginButton setHidden:YES];
        [self.immRegisterButton setHidden:YES];
        [self.myCourseIcon setHidden:NO];
        [self.myCourseLable setHidden:NO];
    }else{
        [self setMycouseTable];
        [self.immLoginButton setHidden:YES];
        [self.immRegisterButton setHidden:YES];
        [self.myCourseIcon setHidden:YES];
        [self.myCourseLable setHidden:YES];
    }
    


}
-(void)isPubSeach{
    if ([PublicTool isSuccessLogin]) {
        [self showLoad];
//        [self performSelector:@selector(showLoad) withObject:nil afterDelay:0.2];
        [ self searchMyCourse];
    }else{
        [self.view viewWithpopUp:@"用户未登录" time:1.5];
    }
    
}

-(void)setMycouseTable{
    self.myCourseTableView=[[UITableExtView alloc]initWithFrame:CGRectMake(0, 65,kScreen.width,kScreen.height-114)];
    self.myCourseTableView.backgroundColor=[UIColor whiteColor];
    self.myCourseTableView.delegate=self;
    self.myCourseTableView.dataSource=self;
    self.myCourseTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self.myCourseTableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:self.myCourseTableView];
    //cell
    [self.myCourseTableView registerNib:[UINib nibWithNibName:@"MyCourseTableViewCell" bundle:nil] forCellReuseIdentifier:CELLID];
    // hide line
    [UIView setExtraCellLineHidden:self.myCourseTableView];
    

}
//准备搜索URL 和 param
-(NSMutableDictionary *)setUrlParam{
    //set url
    NSString *urlType = @"/usr/get-purchased-course";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SRV,urlType];
    //set param
    NSMutableDictionary *pageMsgDict=[NSMutableDictionary dictionary];
    [pageMsgDict setValue:@(self.coursePn) forKey:@"pn"];
    pageMsgDict[@"ps"]=@PS;
    NSMutableDictionary *paDict=[NSMutableDictionary dictionary];
    paDict[@"pa"]=pageMsgDict;
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    paramsDict[@"courseType"] = @10;//类型 10表示课程
    paramsDict[@"param"] = [[paDict toJson:nil]UTF8String];
    paramsDict[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"tokenID"];

    NSMutableDictionary *arr=[NSMutableDictionary dictionary];
    [arr setValue:paramsDict forKey:@"param"];
    [arr setValue:urlStr forKey:@"url"];
    return arr;

}
//搜索课程
-(void)searchMyCourse{
   
    //是否登录、是否有token
    if (![PublicTool isSuccessLogin]) {
        NSLog(@"用户未登录");
        NSWLog(@"获取我的课程：%@", @"用户未登录");
        [self showIcon];
        [[LoadingView shareWait]stopWaiting];
         [self.view viewWithpopUp:@"用户未登录" time:1.5];
        return;
    }
    self.coursePn=1;
    self.myCourseArrayContent=nil;
    NSMutableDictionary *paDara=[self setUrlParam];
    [H doGet:paDara[@"url"] args:paDara[@"param"] json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err!=nil||[json[@"code"] integerValue]!=0) {
            [[LoadingView shareWait]stopWaiting];
            NSLog(@"连接失败");
            NSELog(@"获取我的课程请求失败：%@",err.userInfo);
            //提示用户
        }else {
            [[LoadingView shareWait]stopWaiting];
            NSMutableDictionary *courseArr = [NSMutableDictionary dictionary];
            courseArr = json[@"data"];
             //NSLog(@"courseArr%@",courseArr);
            NSMutableArray *arr = [NSMutableArray array];//临时数组，存储每次获取课程数据
            if (courseArr.count!=0) {
                for (NSDictionary *dict in courseArr) {
                    MyCourseModel *one =[MyCourseModel appWithDict:dict];
                    [arr addObject:one];
                }
                self.myCourseArrayContent=arr;
                 self.pageCourseCount=[self.myCourseArrayContent count];//当前返回课程总门数
                [self.myCourseTableView reloadData];
                self.totalCourse=json[@"pa"][@"total"];
                NSLog(@"totalCourse%@",self.totalCourse);
                [self showCourseIcon];
            }else{
                [self showCourseIcon];
            }
        }
    }];
    
}

//next page search
-(void)searchNextMyCourse{
    //是否登录、是否有token
    if (![PublicTool isSuccessLogin]) {
        NSLog(@"用户未登录");
        NSWLog(@"获取我的课程：%@", @"用户未登录");
        [self.view viewWithpopUp:@"用户未登录" time:1.5];
        [self showIcon];
        return;
    }
    NSMutableDictionary *paDara=[self setUrlParam];
    [H doGet:paDara[@"url"] args:paDara[@"param"] json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err!=nil||[json[@"code"] integerValue]!=0) {
            NSLog(@"连接失败");
            NSELog(@"获取我的课程请求失败：%@",err.userInfo);
            //提示用户
        }else {
            NSMutableDictionary *courseArr = [NSMutableDictionary dictionary];
            courseArr = json[@"data"];
            //NSLog(@"courseArr%@",courseArr);
            if (courseArr.count!=0) {
                for (NSDictionary *dict in courseArr) {
                    MyCourseModel *one =[MyCourseModel appWithDict:dict];
                    [self.myCourseArrayContent addObject:one];
                }
                self.pageCourseCount=[self.myCourseArrayContent count];//当前返回课程总门数
                [self.myCourseTableView reloadData];
                self.totalCourse=json[@"pa"][@"total"];
                NSLog(@"totalCourse%@",self.totalCourse);
                [self showCourseIcon];
            }else{
                [self showCourseIcon];
            }
        }
    }];
    
}













//set row height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myCourseArrayContent.count;
}

//get cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell ==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyCourseTableViewCell" owner:nil options:nil][0];
        //cell=[[MyCourseTableViewCell alloc ]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELLID];
    }
    MyCourseModel *courseModel=self.myCourseArrayContent[indexPath.row];
    //course img
    if ((NSNull *)courseModel.imgs != [NSNull null]&&courseModel.imgs.length!=0) {
        
        [cell.courseImageView setUrl:[PublicTool isTureUrl:courseModel.imgs]];
    }
    //course name
    cell.courseLabel.text=courseModel.name;
    //course chapterCnt
    if ((NSNull *)courseModel.chapterCnt == [NSNull null]) {
        courseModel.chapterCnt =0;
    }
    cell.chaptersLabel.text=[NSString stringWithFormat:@"共%@章",courseModel.chapterCnt];
    //process
    courseModel.process=0.1;//后台没有做，暂时写死
    cell.progressView.progress=courseModel.process;
    return cell;
}

//click cell func
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CourseDetailsViewController *courseDetailVc = [[CourseDetailsViewController alloc] init];
    MyCourseModel *model = self.myCourseArrayContent[indexPath.row];
    if (model.cid!=0||model.cid!=nil) {
        courseDetailVc.courseID = model.cid;
    }else{
        NSELog(@"参数错误,课程ID：%@", model.cid);
        courseDetailVc.courseID = nil;
    }
    [self.navigationController pushViewController:courseDetailVc animated:YES];
    
}

//table func
-(BOOL)isNeedRefresh:(UITableExtView *)tableview{
    if ([PublicTool isSuccessLogin]) {
        return YES;
    }else {
        NSWLog(@"获取我的课程：%@", @"用户未登录");
        [self.view viewWithpopUp:@"用户未登录" time:1.5];
        return NO;
    }
    
}
-(void)onRefresh:(UITableExtView *)tableview{
    NSLog(@"刷新中....");
    [self searchMyCourse];
}
-(void)onNextPage:(UITableExtView *)tableview{
    if ([self.totalCourse intValue]>self.coursePn*PS) {
        self.coursePn++;
        NSLog(@"self.coursePn%d",self.coursePn);
        [self searchNextMyCourse];
    }{
        NSLog(@"no need to next page!");
    
    }
}

//jump to register
- (IBAction)jumpToRegister:(id)sender {
    RegisterController *Register = [[RegisterController alloc]init];
    [self.navigationController pushViewController:Register animated:YES];
}
//jump to login
- (IBAction)jumpToLogin:(id)sender {
    LoginViewController *Login = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:Login animated:YES];
}

-(void)jumpToUserInfo{
    UserInfoController *userInfo=[[UserInfoController alloc]init];
    [self.navigationController pushViewController:userInfo animated:YES];

}
-(void)jumpToSearch{
    HistorySearchController *Search=[[HistorySearchController alloc]init];
    [self.navigationController pushViewController:Search animated:YES];
    
}


-(void)showLoad{
    LoadingView *load = [[LoadingView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [load startWaiting];
    [self.view addSubview:load];

}

@end
