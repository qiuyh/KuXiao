//
//  ScreeningController.m
//  rcpi
//
//  Created by wu on 15/11/6.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "ScreeningController.h"
#import "Config.h"
#import "SearchCourseController.h"
#import "HistorySearchController.h"
#import "CourseSelectedCell.h"
#import "ScreeningModel.h"
#import "LayerOne.h"
#import "CourseDetailsViewController.h"
@interface ScreeningController ()<UITableExtViewDelegate,UITableViewDataSource,UITableViewDelegate>

@end
#define CELL1 @"courseSelctedCell"
#define CELL2 @"courseSelctedCell1"

#define LEFT_FIR_W 100
#define LEFT_SEC_W 100

@implementation ScreeningController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBtn];
    //网络请求
    [self network];
    [self setUpNav];
    [self setUpTableView];



}
- (void)setUpBtn{
    [self.oneBtn setTitle:self.courseOne forState:UIControlStateNormal];
    [self.oneBtn setBackgroundImage:[UIImage imageNamed:@"fp_delete"] forState:0];
    [self.oneBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [self.twoBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [self.threeBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    self.tags = self.courseOne;

}
- (void)setUpNav{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    self.navigationItem.title = @"职业教育";

    UIButton *rigthButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rigthButton setBackgroundImage:[UIImage imageNamed:@"fp_search"] forState:UIControlStateNormal];
    rigthButton.frame=CGRectMake(0, 0, 25, 25);
    [rigthButton addTarget:self action:@selector(rightbtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rigthButton];
    self.navigationItem.rightBarButtonItem=rightItem;
}
- (void)setUpTableView{
    self.tableView = [[UITableExtView alloc]initWithFrame:CGRectMake(0, 165, kScreen.width, kScreen.height-165)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //add backgroundView
   UIImageView *bgView = [[UIImageView alloc]initWithFrame:self.tableView.frame];
//    bgView.backgroundColor = CUSTOM_COLOR(220, 220, 220);
    bgView.image = [UIImage imageNamed:@"com_emptyState"];
    [self.view insertSubview:bgView belowSubview:self.tableView];
    [self.view addSubview:self.tableView];

}

#pragma UITableViewDataSource/UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.tableView) {
        if (self.arrayData.count==0) {
            self.tableView.height=0;
        }else{
            self.tableView.height=kScreen.height-165;
        }
        return self.arrayData.count;

    }else if (tableView==self.leftFirstTableView){
//#warning ------数据仍需要补充----->
        if (self.path.row>=4) {
            return 0;
        }
        LayerOne *one = self.arrayClassName[self.path.row];
        return one.child.count;
    }else{
        if (self.path.row>=4) {
            return 0;
        }
        LayerOne *one = self.arrayClassName[self.path.row];
        LayerTwo *two = one.child[0];
        return two.child.count;
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView==self.tableView) {
        CourseSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL1];
    if (cell==nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"CourseSelectedCell" owner:self options:0][0];
    }
    ScreeningModel * model = self.arrayData[indexPath.row];
    //用户名
    cell.userNameLabel.text = model.userName;
    //课程图片
//    if (model.imgs.length!=0&&model.imgs!=nil) {
//        [cell.iconImageView setUrl:[PublicTool isTureUrl:model.imgs]];
//    }
    //参与人数
    long learnCount = (long)model.joinCnt.integerValue;
    NSMutableAttributedString *learnCountTotel = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld人在学习",learnCount]];
    [learnCountTotel addAttribute:NSForegroundColorAttributeName value:CUSTOM_COLOR(20, 182, 170) range:NSMakeRange(0, [NSString stringWithFormat:@"%ld",learnCount].length)];
    cell.studyCountLable.attributedText = learnCountTotel;
    //标题
    cell.titleNameLablel.text = model.name;
    //课程价格
    if (model.totalPrice.floatValue == 0) {
        cell.priceLabel.text = @"免费";
    }else{
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.totalPrice.floatValue];
    }
    cell.priceLabel.textColor = CUSTOM_COLOR(20.0,182.0,170.0);
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else  {
        CourseSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL2];
        if (cell==nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"CourseSelectedCell" owner:self options:0][1];
            cell.backgroundColor = [UIColor clearColor];
                        }
        if (tableView==self.leftFirstTableView) {
            cell.rightLineView.backgroundColor = CUSTOM_COLOR(200, 200, 200);
            LayerOne *one = self.arrayClassName[self.path.row];
            LayerTwo *two = one.child[indexPath.row];
            cell.selectedNameLabel.text = two.name;
            self.twoBtnStr = two.name;
        }else{
            LayerOne *one = self.arrayClassName[self.path.row];
            LayerTwo *two = one.child[0];
            LayerThree *three = two.child[indexPath.row];
            cell.selectedNameLabel.text = three.name;
        }
        UIView *selectView = [[UIView alloc]init];
        selectView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = selectView;
            return cell;
        }
}

//选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //firstTable
    if (tableView==self.leftFirstTableView) {
        CourseSelectedCell *cell = [self.leftFirstTableView cellForRowAtIndexPath:indexPath];
        cell.leftLineView.backgroundColor = CUSTOM_COLOR(65.0,200.0,194.0);
        cell.selectedNameLabel.textColor = CUSTOM_COLOR(65.0,200.0,194.0);
        self.twoBtnStr = cell.selectedNameLabel.text;

    }else if (tableView==self.leftSecondTableView) {
        CourseSelectedCell *cell = [self.leftSecondTableView cellForRowAtIndexPath:indexPath];
        cell.selectedNameLabel.textColor = CUSTOM_COLOR(65.0,200.0,194.0);
        [self.threeBtn setTitle:cell.selectedNameLabel.text forState:0];
        [self.threeBtn setBackgroundImage:[UIImage imageNamed:@"fp_delete"] forState:0];
        self.threeBtn.hidden=NO;

        [self.twoBtn setTitle:self.twoBtnStr forState:0];
        [self.twoBtn setBackgroundImage:[UIImage imageNamed:@"fp_delete"] forState:0];
        self.twoBtn.hidden=NO;
        self.tags = [NSString stringWithFormat:@"%@,%@,%@",self.courseOne,self.twoBtnStr,cell.selectedNameLabel.text];
        [self closeMenu];
        [self network];
    }else if (tableView == self.tableView){
        ScreeningModel *model = self.arrayData[indexPath.row];
        CourseDetailsViewController *course = [[CourseDetailsViewController alloc]init];
        course.courseID = model.CourseID;
        [self.navigationController pushViewController:course animated:YES];

    }

}

//取消选中的cell
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.leftFirstTableView) {
        CourseSelectedCell *cell = [self.leftFirstTableView cellForRowAtIndexPath:indexPath];
        cell.selectedNameLabel.textColor = [UIColor blackColor];
    }else if (tableView==self.leftSecondTableView) {
        CourseSelectedCell *cell = [self.leftSecondTableView cellForRowAtIndexPath:indexPath];
        cell.selectedNameLabel.textColor = [UIColor blackColor];
    }
}
//分割线填充
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
//heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        return 125;
    }else{
        return 60;
    }
}

- (void)network{
    //课程内容
    NSString *strCourse  = @"/searchCourse";
    NSString *urlCourse = [NSString stringWithFormat:@"%@%@",SRV,strCourse];
    //NSMutableDictionary *courseDict = [NSMutableDictionary dictionary];
    //courseDict[@"pn"] = @1;
    //courseDict[@"ps"] = @10;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"firstTag"] = @"职业教育";
    if (self.tags) {
        params[@"tags"] = self.tags;
        NSArray *level = [self.tags componentsSeparatedByString:@","];
        params[@"level"] = [NSNumber numberWithInteger:level.count];
    }else{
            params[@"level"] = @0;
    }
    //params[@"filter"] = @"电子商务";
    //params[@"pa"] = courseDict;
    [H doGet:urlCourse args:params json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err) {
            NSLog(@"err==================%@",err.userInfo);
        }else{
//            NSLog(@"====所有返回参数====》%@",json);
            self.arrayData = [ScreeningModel appWithArray:json[@"data"][@"list"]];
            [self.tableView reloadData];
        }
    }];

//筛选内容
    NSString *StrClass  = @"/get-all-tag";
    NSString *urlClass = [NSString stringWithFormat:@"%@%@",SRV,StrClass];
    NSMutableDictionary *params2 = [NSMutableDictionary dictionary];
    params2[@"firstTag"] = @"职业教育";
    [H doGet:urlClass args:params2 json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err) {
            NSLog(@"err==================%@",err.userInfo);
        }else{
            self.arrayClassName = [LayerOne childWithArray:json[@"data"]];
            [self.leftFirstTableView reloadData];
            [self.leftSecondTableView reloadData];
        }
    }];


}

//筛选功能
- (IBAction)goToScreening:(UIButton *)sender {
    //最底层View
    self.menuView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreen.width, kScreen.height)];
    //半透明View
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen.width, kScreen.height)];
    self.backgroundView.backgroundColor = [UIColor blackColor];
    [self.backgroundView setAlpha:0];
    //设置手势
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeMenu)];
    [self.backgroundView addGestureRecognizer:tapGR];

    UISwipeGestureRecognizer  *swipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(closeMenu)];
    swipeGR.numberOfTouchesRequired = 1;
    swipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.backgroundView addGestureRecognizer:swipeGR];
    [self.menuView addSubview:self.backgroundView];

    //建立左菜单
    self.leftFirstTableView = [[UITableExtView alloc]initWithFrame:CGRectMake(-LEFT_FIR_W-LEFT_SEC_W, 64, LEFT_FIR_W, kScreen.height)];
    self.leftFirstTableView.backgroundColor = CUSTOM_COLOR(220, 220, 220);
    self.leftFirstTableView.showsVerticalScrollIndicator = NO;
    self.leftFirstTableView.delegate = self;
    self.leftFirstTableView.dataSource = self;
    self.leftFirstTableView.scrollEnabled = NO;
    //footerView
    UIView *footerView = [[UIView alloc]init];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(LEFT_FIR_W-1, 0, 1, self.leftFirstTableView.height)];
    lineView.backgroundColor = CUSTOM_COLOR(200, 200, 200);
    [footerView addSubview:lineView];
    self.leftFirstTableView.tableFooterView = footerView;
    NSInteger selectedIndex = 0;

    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];

    [self.leftFirstTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    CourseSelectedCell *cell = [self.leftFirstTableView cellForRowAtIndexPath:selectedIndexPath];
    cell.leftLineView.backgroundColor = CUSTOM_COLOR(65.0,200.0,194.0);
    cell.selectedNameLabel.textColor = CUSTOM_COLOR(65.0,200.0,194.0);

    //第二个tableView
    self.leftSecondTableView = [[UITableExtView alloc]initWithFrame:CGRectMake(-LEFT_SEC_W, 64, -LEFT_SEC_W, kScreen.height)];
    self.leftSecondTableView.showsVerticalScrollIndicator = NO;
    self.leftSecondTableView.delegate = self;
    self.leftSecondTableView.dataSource = self;
    self.leftSecondTableView.scrollEnabled = NO;
//    self.leftSecondTableView.tableFooterView = [[UIView alloc]init];
    self.leftSecondTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.menuView addSubview:self.leftFirstTableView];
    [self.menuView addSubview:self.leftSecondTableView];
    [self.view addSubview:self.menuView];

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.backgroundView setAlpha:0.3];
        weakSelf.leftFirstTableView.x=0;
        weakSelf.leftSecondTableView.x=LEFT_FIR_W;
    }];
}


- (void)closeMenu{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.leftFirstTableView.x=-LEFT_FIR_W-LEFT_SEC_W;
        weakSelf.leftSecondTableView.x=-LEFT_SEC_W;

    } completion:^(BOOL finished) {
        [weakSelf.menuView removeFromSuperview];
    }];
}


#pragma TableExtView delegate
- (BOOL)isNeedRefresh:(UITableExtView *)tableview{
    return YES;
}

- (void)onRefresh:(UITableExtView *)tableview{
    [self network];
//    [tableview performSelector:@selector(reloadData) withObject:nil afterDelay:1.5];
    NSLog(@"刷新中....");
}

#pragma button
-(void)leftbtnClick{
    NSLog(@"左点击");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightbtnClick{
    NSLog(@"---search");
      HistorySearchController *searchVc=[[HistorySearchController alloc]init];
     [self.navigationController pushViewController:searchVc animated:YES];
}
/**
 *只看名师课程
 */
- (IBAction)selectedTeacherClass:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [button setImage:[UIImage imageNamed:@"fp_down"] forState:0];
        // ...
    }else{
        [button setImage:[UIImage imageNamed:@"fp_normal"] forState:0];
        //...
    }
}

- (IBAction)OneBtn:(UIButton *)sender {
//    self.oneBtn.hidden=YES;
}

- (IBAction)TwoBtn:(UIButton *)sender {
    sender.hidden = YES;
    self.threeBtn.hidden = YES;
    self.tags = [NSString stringWithFormat:@"%@",self.courseOne];
    [self network];
}

- (IBAction)ThreeBtn:(UIButton *)sender {
    sender.hidden = YES;
    self.tags = [NSString stringWithFormat:@"%@,%@",self.courseOne,self.twoBtnStr];
    [self network];
}
@end
