//
//  SearchHistoryViewController.m
//  rcpi
//
//  Created by Dyang on 15/11/16.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "HistorySearchController.h"
#import "Config.h"
#import "SearchCourseController.h"
#define CELLID @"cell"
#define  PATH  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject]stringByAppendingPathComponent:@"historyData.plist"]
@interface HistorySearchController ()<UITableViewDataSource,UITextFieldDelegate,UITableExtViewDelegate>

@property (nonatomic,strong)UIButton *deleHistoryButton;

@end

@implementation HistorySearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setnavigation];
    [self getLocalData];
    [self setLableLine];
    [self getHotData];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //程序退到后台，自动缓存本次搜索记录
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(updateDataFile) name:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication]];
    //加载表和按钮
    [self setHitstoryTable];
    [self setDeleButton];
    
}
//设置头部
-(void)setnavigation{
    self.searchHisText=[[UITextField alloc]init];
    [self.searchHisText setKeyboardType:UIKeyboardTypeDefault];
    [self.searchHisText addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.searchHisText.frame=CGRectMake(0, 0, kScreen.width*0.65, 28);
    self.searchHisText.placeholder=@"  输入课程名称";
    self.searchHisText.font= [UIFont systemFontOfSize:12] ;
    self.searchHisText.delegate=self;
    self.searchHisText.returnKeyType=UIReturnKeySearch;
    self.searchHisText.adjustsFontSizeToFitWidth=YES;
    [self.searchHisText.layer setCornerRadius:15];
    self.searchHisText.backgroundColor=[UIColor whiteColor];
    self.searchHisText.clearButtonMode= UITextFieldViewModeWhileEditing;
    self.navigationItem.titleView=self.searchHisText;
    // set navigationItem left backbutton
    UIButton *leftBtn =[[UIButton alloc]init];
    leftBtn.frame = CGRectMake(0, 0, 25, 25);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"com_return"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(goBackFirstPage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=backButton;
    //set navigationItem right backbutton
    UIButton *rightBtn =[[UIButton alloc]init];
    rightBtn.frame = CGRectMake(0, 0, 25, 25);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"com_search"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchButton=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=searchButton;
}
-(void)setLableLine{
    //热门搜索
    UILabel *tableHotLable=[[UILabel alloc]init];
    tableHotLable.text=@"热门搜索";
    [tableHotLable setTextColor:[UIColor colorWithRed:152.0/255.0 green:152.0/255.0 blue:152.0/255.0 alpha:1.0]];
    [tableHotLable setFont:[UIFont systemFontOfSize:16]];
    tableHotLable.frame=CGRectMake(20, 75 ,70, 20);
    [self.view addSubview:tableHotLable];
    //历史搜索
    UILabel *tableHeadLable=[[UILabel alloc]init];
    tableHeadLable.text=@"历史搜索";
    [tableHeadLable setTextColor:[UIColor colorWithRed:152.0/255.0 green:152.0/255.0 blue:152.0/255.0 alpha:1.0]];
    [tableHeadLable setFont:[UIFont systemFontOfSize:16]];
    tableHeadLable.frame=CGRectMake(20, 220 ,70, 20);
    [self.view addSubview:tableHeadLable];
    //draw line
    UILineView *LineView=[[UILineView alloc]initWithFrame:CGRectMake(15, 249, kScreen.width, 1)];
    [LineView addBottomLine];
    LineView.backgroundColor=[UIColor whiteColor];
    LineView.drawer.lineColor=[UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0];
    [self.view addSubview:LineView];
}
//设置搜索记录表
-(void)setHitstoryTable{
    [self.courseHistoryTableView removeFromSuperview];
    self.courseHistoryTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 250,kScreen.width,self.curryData.count*40)];
    self.courseHistoryTableView.delegate=self;
    self.courseHistoryTableView.dataSource=self;
    [self.view addSubview:self.courseHistoryTableView];
    // hide line
    self.courseHistoryTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    UIView *footV = [[UIView alloc] initWithFrame:CGRectZero];
    [self.courseHistoryTableView setTableFooterView:footV];
    self.courseHistoryTableView.scrollEnabled=NO;
    //    [self.courseHistoryTableView setSeparatorInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    
}
//设置删除按钮
-(void)setDeleButton{
    [self.deleHistoryButton removeFromSuperview];
    // NSLog(@"============%f",self.courseHistoryTableView.frame.origin.y+self.curryData.count*40);
    self.deleHistoryButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreen.width/2-75,(self.courseHistoryTableView.frame.origin.y+self.curryData.count*40)+20, 150, 30)];
    self.deleHistoryButton.backgroundColor=[UIColor whiteColor];
    [self.deleHistoryButton setTitle:@"清空搜索历史" forState:UIControlStateNormal];
    //[deleHistoryButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.deleHistoryButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.deleHistoryButton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:192.0/255.0 blue:183.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.deleHistoryButton.layer setCornerRadius:10.0];
    [self.deleHistoryButton.layer setBorderWidth:1.0];
    [self.deleHistoryButton.layer setBorderColor:[UIColor colorWithRed:0.0/255.0 green:192.0/255.0 blue:183.0/255.0 alpha:1.0].CGColor ];
    [self.deleHistoryButton addTarget:self action:@selector(deleteHistoryData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.deleHistoryButton];
    
    [self hideDelButton];
    
    
    
}

//获取表单信息
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELLID];
    }
    if (self.historyData.count!=0&&self.historyData.count>self.curryData.count) {
        //  NSLog(@"2");
        cell.textLabel.text=self.historyData[indexPath.row];
        
    }else{
        // NSLog(@"3");
        cell.textLabel.text=self.curryData[indexPath.row];
    }
    return cell;
}
//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;//cell高度
}
//点击搜索记录
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchHisText resignFirstResponder];
    SearchCourseController *courseDetailVc = [[SearchCourseController alloc] init];
    courseDetailVc.searchThing=self.curryData[indexPath.row];
    courseDetailVc.searchData=self.curryData;
    //  NSLog(@"courseDetailVc searchThing %@", courseDetailVc.searchThing);
    [self.navigationController pushViewController:courseDetailVc animated:YES];
    
}
//返回表行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.historyData.count!=0&&self.historyData.count>self.curryData.count) {
        //  NSLog(@"4");
        return self.historyData.count;
        
    }else{
        // NSLog(@"5");
        return self.curryData.count;
    }
    
}
//添加搜索记录
-(void)addSearchData:(NSString *)arg_name{
    //add data
    if (arg_name.length!=0&&![self.curryData containsObject:arg_name]) {
        // NSLog(@"6");
        // NSLog(@"%@",arg_name);
        
        //[self.curryData addObject:self.searchHisText.text];
        [self.curryData insertObject:arg_name atIndex:0];//插入搜索记录
        if (self.curryData.count>=7) {
            [self.curryData removeObjectAtIndex:6];
        }
    }
    
    //NSLog(@"===当前数组===%@",[[self.curryData toJson:nil]UTF8String]);
    [self.courseHistoryTableView reloadData];// reload table
    [self hideDelButton];
}
//更新记录文件
-(void)updateDataFile{
    //  NSLog(@"进入后台");
    //NSLog(@"curryData data :%@",[[self.curryData toJson:nil]UTF8String]);
    [self.curryData writeToFile:PATH atomically:YES];
}
//获取本地缓存数据
-(void)getLocalData{
    
    // NSLog(@"%@",PATH);
    self.historyData=[[NSMutableArray alloc] initWithContentsOfFile:PATH];
    // NSLog(@"--arr----%@",arr);
    
    // NSLog(@"------%@",self.historyData);
    if (self.historyData.count!=0&&self.historyData.count>self.curryData.count) {
        //  NSLog(@"1");
        
        self.curryData=[NSMutableArray arrayWithArray:self.historyData];
    }else{
        self.curryData=[NSMutableArray array];
        
    }
    [self hideDelButton];
}
-(void)deleteHistoryData{
    [self.curryData removeAllObjects];
    [self.historyData removeAllObjects];
    [self.courseHistoryTableView reloadData];
    [self.curryData writeToFile:PATH atomically:YES];
    [self hideDelButton];
    
}
//搜索课程
-(void)clickSearch{
    [self addSearchData:self.searchHisText.text];
    [self.searchHisText resignFirstResponder];
    SearchCourseController *search = [[SearchCourseController alloc]init];
    search.searchThing=self.searchHisText.text;
    search.searchData=self.curryData;
    // NSLog(@"search.searchThing %@",search.searchThing);
    [self.navigationController pushViewController:search animated:YES];
    
}
//返回首页
-(void)goBackFirstPage{
    //  NSLog(@"curryData data :%@",[[self.curryData toJson:nil]UTF8String]);
    [self.curryData writeToFile:PATH atomically:YES];
    [self.searchHisText resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
//隐藏删除按钮
-(void)hideDelButton{
    if (self.curryData.count==0) {
        [self.deleHistoryButton setHidden:YES];
    }else{
        [self.deleHistoryButton setHidden:NO];
    }
    
}
//获取热门搜索数据
-(void)getHotData{
   // [self SLoad];
    NSString *url=@"/s";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",SRV,url];
    //    LoadingView *loadingView = [LoadingView alloc]initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    [H doGet:urlStr args:nil json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err!=nil||[json[@"code"] integerValue]!=0) {
              [[LoadingView shareWait]stopWaiting];
            //NSLog(@"获取热门搜索信息失败");
            NSWLog(@"warn when get hots course:%@", err.userInfo);
            [self.view viewWithpopUp:@"网络异常，请重试" time:1.5];
        }else{
              [[LoadingView shareWait]stopWaiting];
            self.hotCourseData = [NSMutableArray array];
            self.hotCourseData = json[@"data"][@"hots"];
            //NSLog(@"arr%@", [[self.hotCourseData toJson:nil] UTF8String]);
            if (self.hotCourseData.count==0) {
                // NSLog(@"热门搜索信息为空");
                NSWLog(@"热门搜索信息为空:%@", json[@"data"]);
            }else{
                //  NSLog(@"热门搜索信息获取成功");
                [self setHotButton];
            }
        }
        
    }];
}
//设置热门搜索按钮
- (void)setHotButton{
    //第一排
    int line1=0;
    int line2=10;
    long cunLine1=0;//第一行按钮数
    long cunLine2=0;//第二行按钮数
    for (int i =0;i<=self.hotCourseData.count;i++) {
        UIButton *hotBut1=[[UIButton alloc]init];
        // NSLog(@"1");
        //动态获取title长度控制按钮长度
       // CGSize titleSize = [self.hotCourseData[i][@"kw"] sizeWithFont:hotBut1.titleLabel.font];
        CGSize titleSize=[PublicTool widthOfLable:self.hotCourseData[i][@"kw"] font:12 type:@"HelveticaNeue-Light"];
        hotBut1.frame=CGRectMake((i+1)*10+cunLine1, 110, titleSize.width+20, 25);
        if ((cunLine1+hotBut1.frame.size.width+(i+1)*10)<=kScreen.width) {
            // NSLog(@"cunX+hotBut1.frame.size.width: %fd",(cunLine1+hotBut1.frame.size.width+(i-4)*10));
            cunLine1=cunLine1+hotBut1.frame.size.width;
            
        }else{
            //NSLog(@"停止循环: %d",i);
            // NSLog(@"停止循环: %fd",(cunLine1+hotBut1.frame.size.width+(i-4)*10));
            break;//停止循环
            
        }
        [hotBut1 setTitle:self.hotCourseData[i][@"kw"] forState:UIControlStateNormal];
        [hotBut1 setBackgroundColor:[UIColor whiteColor]];
        [hotBut1.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [hotBut1 setTitleColor:[UIColor colorWithRed:0.0/255.0 green:192.0/255.0 blue:183.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [hotBut1.layer setCornerRadius:10.0];
        [hotBut1.layer setBorderWidth:1.0];
        [hotBut1.layer setBorderColor:[UIColor colorWithRed:0.0/255.0 green:192.0/255.0 blue:183.0/255.0 alpha:1.0].CGColor ];
        [hotBut1 addTarget:self action:@selector(jumpHotCourse:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:hotBut1];
        line1++;
        
        
    }
    if (self.hotCourseData.count<line1) {
        return;//如果热门课程数据不够2排，则不排到第二排
    }
    //第二排
    for (int i =line1+1;i<=self.hotCourseData.count;i++) {
        //NSLog(@"2");
        UIButton *hotBut1=[[UIButton alloc]init];
        //动态获取title长度控制按钮长度
        CGSize titleSize=[PublicTool widthOfLable:self.hotCourseData[i][@"kw"] font:12 type:@"HelveticaNeue-Light"];
        hotBut1.frame=CGRectMake((i-line1)*10+cunLine2, 150, titleSize.width+20, 25);
        if ((cunLine2+hotBut1.frame.size.width+(i-line1)*10)<=kScreen.width) {
            // NSLog(@"cunX+hotBut1.frame.size.width: %fd",(cunLine2+hotBut1.frame.size.width+(i-line1)*10));
            cunLine2=cunLine2+hotBut1.frame.size.width;
            
        }else{
            // NSLog(@"停止循环: %d",i);
            // NSLog(@"停止循环: %fd",(cunLine2+hotBut1.frame.size.width+(i-4)*10));
            break;//停止循环
            
        }
        [hotBut1 setTitle:self.hotCourseData[i][@"kw"] forState:UIControlStateNormal];
        [hotBut1 setBackgroundColor:[UIColor whiteColor]];
        [hotBut1.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [hotBut1 setTitleColor:[UIColor colorWithRed:0.0/255.0 green:192.0/255.0 blue:183.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [hotBut1.layer setCornerRadius:10.0];
        [hotBut1.layer setBorderWidth:1.0];
        [hotBut1.layer setBorderColor:[UIColor colorWithRed:0.0/255.0 green:192.0/255.0 blue:183.0/255.0 alpha:1.0].CGColor ];
        [hotBut1 addTarget:self action:@selector(jumpHotCourse:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:hotBut1];
        line2++;
        
        
        
        
    }
    
}
//点击热门课程搜索
-(void)jumpHotCourse:(UIButton *)arg_hotCourseBut{
    [self.searchHisText resignFirstResponder];
    if (arg_hotCourseBut.titleLabel.text==nil||arg_hotCourseBut.titleLabel.text.length==0) {
        //NSLog(@"点击的热门搜索课程为空");
        return;
    }
    [self addSearchData:(NSString *)arg_hotCourseBut.titleLabel.text];
    SearchCourseController *search = [[SearchCourseController alloc]init];
    search.searchThing=arg_hotCourseBut.titleLabel.text;
    // NSLog(@"arg_hotCourse %@",arg_hotCourseBut.titleLabel.text);
    [self.navigationController pushViewController:search animated:YES];
}
-(void)SLoad{
    LoadingView *load = [[LoadingView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [load startWaiting];
    [self.view addSubview:load];
    
}
@end
