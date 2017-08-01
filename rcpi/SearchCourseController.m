//
//  SearchCourseController.m
//  rcpi
//
//  Created by Dyang on 15/10/8.
//  Copyright (c) 2015年 Dyang. All rights reserved.
//
#import "Config.h"
#import "SearchCourseController.h"
#import "SearchCourseViewCell.h"
#import "CourseSelectedModel.h"
#import "CourseDetailsViewController.h"
#import "HistorySearchController.h"
#define CELLID @"cell"
#define PS 12

#define  SAVE_SEAR_PATH  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject]stringByAppendingPathComponent:@"historyData.plist"]

@interface SearchCourseController ()<UITableViewDataSource,UITextFieldDelegate,UITableExtViewDelegate>

@property (nonatomic,strong)NSMutableArray *courseArrayContent;
@property (nonatomic,strong)NSMutableArray *searchCourseArr;
@property(nonatomic,assign)NSInteger totalCourse;
@property(nonatomic,assign)NSInteger pageCourseCount;
@property(nonatomic,assign)int coursePn;
@property (nonatomic,strong)UIView *bgView;

@end

@implementation SearchCourseController

- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openKeyboard) name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyboard) name:UIKeyboardWillHideNotification object:nil];

}
-(void)openKeyboard{
    [self.bgView removeFromSuperview];
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen.width, kScreen.height)];
    self.bgView.backgroundColor = [UIColor blackColor];

    self.bgView.alpha=0.3;
    [self.view addSubview:self.bgView];
    //设置手势
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    [self.bgView addGestureRecognizer:tapGR];

    UISwipeGestureRecognizer  *swipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    swipeGR.numberOfTouchesRequired = 1;
    swipeGR.direction = UISwipeGestureRecognizerDirectionDown;
    [self.bgView addGestureRecognizer:swipeGR];
}
- (void)closeKeyboard{
    [self.bgView removeFromSuperview];
    [self.searchText resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //initial definition
//    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self.indicator stopAnimating];
    self.courseCoutLabel.backgroundColor=[UIColor whiteColor];
    self.totalCourse=0;//课程总数
    self.coursePn=1;//当前页
    self.pageCourseCount=0;//cell数
    self.courseArrayContent=[NSMutableArray array];
    //set ui
    [self setnavigation];
    [self setcountLable];
    [self setcourseTable];
    //search course
    [self clickSearch];
}
-(void)setnavigation{
    self.searchText=[[UITextField alloc]init];
    [self.searchText setKeyboardType:UIKeyboardTypeDefault];
    [self.searchText addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.searchText.frame=CGRectMake(0, 0, kScreen.width*0.65, 28);
    self.searchText.placeholder=@"  输入课程名称";
    self.searchText.font= [UIFont systemFontOfSize:12] ;
    self.searchText.delegate=self;
    self.searchText.returnKeyType=UIReturnKeySearch;
    self.searchText.adjustsFontSizeToFitWidth=YES;
    [self.searchText.layer setCornerRadius:15];
    self.searchText.backgroundColor=[UIColor whiteColor];
    self.searchText.clearButtonMode= UITextFieldViewModeWhileEditing;
    self.navigationItem.titleView=self.searchText;
    //set navigationItem left backbutton
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
-(void)setcountLable{
    //set course sum lable
    NSMutableAttributedString *courseToTal=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"   总共%ld个搜索结果",(long)self.totalCourse]];
    [courseToTal addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,[NSString stringWithFormat: @"%ld", (long)self.totalCourse].length)];
    _courseCoutLabel.attributedText=courseToTal;
    _courseCoutLabel.font=[UIFont systemFontOfSize:14];
    [_courseCoutLabel setTextColor:[UIColor grayColor]];
    //draw line
    UILineView *LineView=[[UILineView alloc]initWithFrame:CGRectMake(0, 89, kScreen.width, 1)];
    [LineView addBottomLine];
    LineView.backgroundColor=[UIColor whiteColor];
    LineView.drawer.lineColor=[UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0];
    [self.view addSubview:LineView];


}
-(void)setcourseTable{
    //course table
        self.courseDataTableView=[[UITableExtView alloc]initWithFrame:CGRectMake(0, 90,kScreen.width,kScreen.height-90)];
        self.courseDataTableView.backgroundColor=[UIColor whiteColor];
        self.courseDataTableView.delegate=self;
        self.courseDataTableView.dataSource=self;
        self.courseDataTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        [self.courseDataTableView setSeparatorInset:UIEdgeInsetsZero];
        [self.view addSubview:self.courseDataTableView];
        //cell
        [self.courseDataTableView registerNib:[UINib nibWithNibName:@"SearchCourseViewCell" bundle:nil] forCellReuseIdentifier:CELLID];
        // hide line
        [UIView setExtraCellLineHidden:self.courseDataTableView];
}

-(void)clickSearch{
    [self closeKeyboard];
 [self.indicator startAnimating];
  self.coursePn=1;//搜索第一页
 [self searchCourse];
}
//search course
-(void)searchCourse {
    //hide keybord
    [self.view.window endEditing:YES];
    [self addSearchData];
    self.searchCourseArr=nil;//remove array
    NSString *str = @"/searchCourse";//set url
    self.coursePn=1;
    //set param
    self.urlStr=[NSString stringWithFormat:@"%@%@",SRV,str];
    NSMutableDictionary *pageMsgDict=[NSMutableDictionary dictionary];
    [pageMsgDict setValue:@(self.coursePn) forKey:@"pn"];
    pageMsgDict[@"ps"]=@PS;
 

    if (self.searchText.text.length==0&&self.searchThing.length!=0) {
        self.searchText.text=self.searchThing;
    }
    NSMutableDictionary *paDict=[NSMutableDictionary dictionary];
    paDict[@"filter"]=self.searchText.text;
    paDict[@"pa"]=pageMsgDict;
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    paramsDict[@"firstTag"] = @"职业教育";
    paramsDict[@"level"] = @0;
    paramsDict[@"param"] = [[paDict toJson:nil]UTF8String];
    //http
    [H doGet:self.urlStr args:paramsDict json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err!=nil||[json[@"code"] integerValue]!=0) {
          //  [PublicTool rcpAlert:@C_NET_WORK_ERROR];
            [self.indicator startAnimating];
            NSWLog(@"warn when get course:%@", err.userInfo);
            [self.view viewWithpopUp:@"网络异常，请重试" time:1.5];
        }else{
            
            NSMutableDictionary *courseArr = [NSMutableDictionary dictionary];
                 courseArr = json[@"data"];
                 NSArray *dataArray =[NSArray array];
                 dataArray=courseArr[@"list"];
               //  NSLog(@"courseArr%@",courseArr);
                 self.searchCourseArr=courseArr[@"list"];
                //set total course count
                 self.totalCourse=[courseArr[@"total"] integerValue];
                 NSMutableAttributedString *courseToTal=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"   总共%ld个搜索结果",(long)self.totalCourse]];
                 [courseToTal addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,[NSString stringWithFormat: @"%ld", (long)self.totalCourse].length)];
                 self.courseCoutLabel.attributedText=courseToTal;
               // set table
               NSMutableArray *arr = [NSMutableArray array];//临时数组，存储每次获取的12条课程数据
                 for (NSDictionary *dict in dataArray) {
                    CourseSelectedModel *one =[CourseSelectedModel appWithDict:dict];
                    [arr addObject:one];
                }
                self.courseArrayContent=arr;
                [self.indicator stopAnimating];
                self.pageCourseCount=[self.courseArrayContent count];//当前返回课程总门数
                [self.courseDataTableView reloadData];
            
        }
    }];
}
-(void)nextPageSearch{
    //hide keybord
    [self.view.window endEditing:YES];
    self.searchCourseArr=nil;//remove array
    NSString *str = @"/searchCourse";//set url
    //set param
    self.urlStr=[NSString stringWithFormat:@"%@%@",SRV,str];
    NSMutableDictionary *pageMsgDict=[NSMutableDictionary dictionary];
    [pageMsgDict setValue:@(self.coursePn) forKey:@"pn"];
    pageMsgDict[@"ps"]=@PS;
    NSMutableDictionary *paDict=[NSMutableDictionary dictionary];
    paDict[@"filter"]=self.searchText.text;
    paDict[@"pa"]=pageMsgDict;
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    paramsDict[@"firstTag"] = @"职业教育";
    paramsDict[@"level"] = @0;
    paramsDict[@"param"] = [[paDict toJson:nil]UTF8String];
    //http
    [H doGet:self.urlStr args:paramsDict json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err!=nil||[json[@"code"] integerValue]!=0) {
         //   [PublicTool rcpAlert:@C_NET_WORK_ERROR];
            [self.indicator startAnimating];
            NSWLog(@"warn when get course:%@", err.userInfo);
            [self.view viewWithpopUp:@"网络异常，请重试" time:1.5];
        }else{
            
            NSMutableDictionary *courseArr = [NSMutableDictionary dictionary];
            courseArr = json[@"data"];
            NSArray *dataArray =[NSArray array];
            dataArray=courseArr[@"list"];
            self.searchCourseArr=courseArr[@"list"];
            //set total course count
            self.totalCourse=[courseArr[@"total"] integerValue];
            NSMutableAttributedString *courseToTal=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"   总共%ld个搜索结果",(long)self.totalCourse]];
            [courseToTal addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,[NSString stringWithFormat: @"%ld", (long)self.totalCourse].length)];
            self.courseCoutLabel.attributedText=courseToTal;
            // set table
            
            for (NSDictionary *dict in dataArray) {
                CourseSelectedModel *one =[CourseSelectedModel appWithDict:dict];
                [self.courseArrayContent addObject:one];
            }
            [self.indicator stopAnimating];
            self.pageCourseCount=[self.courseArrayContent count];//当前返回课程总门数
            [self.courseDataTableView reloadData];
            
        }
    }];


}


// set table view row num

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.totalCourse==0) {
        return 0;//没有课程的时候
    }else{
        return self.pageCourseCount;//当前返回课程门数
    }
}
 //get cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchCourseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    if (cell ==nil) {
        //cell = [[NSBundle mainBundle] loadNibNamed:@"SearchCourseViewCell" owner:self options:nil][0];
        cell=[[SearchCourseViewCell alloc ]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELLID];
    }
    CourseSelectedModel *courseModel=self.courseArrayContent[indexPath.row];

    if ((NSNull *)courseModel.imgs != [NSNull null]&&courseModel.imgs.length!=0) {

        [cell.courseImgView setUrl:[PublicTool isTureUrl:courseModel.imgs]];
    }
    //learner num
    long learnnerSum=0;
    if ((NSNull *)courseModel.joinCnt != [NSNull null]) {
        learnnerSum=(long)courseModel.joinCnt.integerValue;
    }
    [cell.courseLearnnerSumLable setTextColor:[UIColor grayColor]];
    NSMutableAttributedString *learnnerToTal=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld人在学习",learnnerSum]];
    [learnnerToTal addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:20.0/255.0 green:182.0/255.0 blue:170.0/255.0 alpha:1.0] range:NSMakeRange(0,[NSString stringWithFormat: @"%ld", learnnerSum].length)];
    cell.courseLearnnerSumLable.attributedText=learnnerToTal;
    //course name
    cell.courseNameLable.text=[NSString stringWithFormat:@"%@",courseModel.name];
    [cell.courseNameLable setTextColor:[UIColor grayColor]];
    //course price
    cell.coursePriceLable.textColor=[UIColor colorWithRed:20.0/255.0 green:182.0/255.0 blue:170.0/255.0 alpha:1.0];
    if ((NSNull *)courseModel.totalPrice == [NSNull null]||courseModel.totalPrice.floatValue==0) {
         cell.coursePriceLable.text=@"免费";
    }else{
         cell.coursePriceLable.text=[NSString stringWithFormat:@"￥%.2f",courseModel.totalPrice.floatValue];
    }
    //course rating
    cell.courseRatingImgView.image=[UIImage imageNamed:@"com_fire"];
    //teacher image
    cell.userImgView.image=[UIImage imageNamed:@"com_man"];
    //teacher name
    cell.userNameLable.text=[NSString stringWithFormat:@"%@",courseModel.userName];
     [cell.userNameLable setTextColor:[UIColor grayColor]];
    return cell;
}
//set row height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;//cell高度
}
//click cell func
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     CourseDetailsViewController *courseDetailVc = [[CourseDetailsViewController alloc] init];
     CourseSelectedModel *model = self.courseArrayContent[indexPath.row];
    if (model.id!=0||model.id!=nil) {
        courseDetailVc.courseID = model.id;
    }else{
        NSELog(@"参数错误,课程ID：%@", model.id);
        courseDetailVc.courseID = nil;
    }
    [self.navigationController pushViewController:courseDetailVc animated:YES];
 
}


//table func
-(BOOL)isNeedRefresh:(UITableExtView *)tableview{
    if (self.pageCourseCount==0) {
        return NO;
    }else{
         return YES;//下拉都可以刷新
    }
   
}
-(void)onRefresh:(UITableExtView *)tableview{
        [self.indicator stopAnimating];
        [self searchCourse];
         NSLog(@"刷新中....");
       // [tableview performSelector:@selector(reloadData) withObject:nil afterDelay:1.5];
    
}
-(void)onNextPage:(UITableExtView *)tableview{
    if (self.totalCourse>self.coursePn*PS) {
        self.coursePn+=1;
        [self nextPageSearch];
    }else{
        NSLog(@"无需到下一页");
    }

}
// go back to first page
-(void)goBackFirstPage{

    [self closeKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
    
}
//存储搜索记录
-(void)addSearchData{
    //add data
    if (self.searchText.text.length!=0&&![self.searchData containsObject:self.searchText.text]) {
        //[self.curryData addObject:self.searchHisText.text];
        [self.searchData insertObject:self.searchText.text atIndex:0];//插入搜索记录
        if (self.searchData.count>=7) {
            [self.searchData removeObjectAtIndex:6];
        };
       // NSLog(@"==========%@",self.searchData);
        [self.searchData writeToFile:SAVE_SEAR_PATH atomically:YES];
    }
    

}
@end
