
//  ExamDetailsCtl.m
//  rcpi
//
//  Created by wu on 15/11/15.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "AnalyzingCtl.h"
#import "Config.h"
#import "ExamTwo.h"
#import "CourseDetailsViewController.h"
#import "AnalyzingCtl.h"
#import "AnalyzModel.h"
#import "AnswerModel.h"
#import "AnalyzCell.h"
#import "AnswerSheetCtl.h"
@interface AnalyzingCtl ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

//@property (nonatomic,strong)UIScrollView *scrollView;
//@property (nonatomic,strong)UIView *titleView;
//@property (nonatomic,strong)UIWebView *webView;
//@property (nonatomic,strong)UIButton *showBtn;
//@property (nonatomic,assign)int count;//记录按钮滑动次数
//@property (nonatomic,assign)CGFloat currentY;
//@property (nonatomic,assign)CGFloat currentX;

//信息存储
@property (nonatomic,strong)NSArray *analyzContent;
@property (nonatomic,strong)NSArray *answerContent;
@property (nonatomic,assign)NSInteger currentPage;
@end

@implementation AnalyzingCtl
#define CELLID @"collectionviewcell"
#define CELL_W (kScreen.width-10)
#define CELL_H (kScreen.height-64)
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCollectionView];
    [self setUpNav];
    [self network];

}
- (void)network{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"aId"] = self.aid ;
    args[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"tokenID"];
    //    agrs[@"t"] = @"r";
    NSLog(@"参数----%@",args);
    NSString *urlStr = [NSString stringWithFormat:@"%@/chk-analyze",ANSWER];
    [H doGet:urlStr args:args json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err) {
            NSLog(@"网络请求失败---%@",err.userInfo);
        }else{
            NSLog(@"解析--------%@",json);
            self.analyzContent = [AnalyzModel appWithArray:json[@"data"][@"analyze"]];
            self.answerContent = [AnswerModel appWithArray:json[@"data"][@"answer"]];
            [self.collectionView reloadData];
        }
    }];

}
- (void)setUpNav{
    UIBarButtonItem *one = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"eva_more"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(oneClick)];
    UIButton *timeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [timeBtn setBackgroundImage:[UIImage imageNamed:@"eva_timer_light"] forState:0];
    timeBtn.titleEdgeInsets = UIEdgeInsetsMake(3, -5, 0, -5);
    [timeBtn setTitle:@"03:24" forState:0];
    timeBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [timeBtn addTarget:self action:@selector(oneClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *two = [[UIBarButtonItem alloc]initWithCustomView:timeBtn];
    UIBarButtonItem *three = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"eva_answerSheet"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(answerSheet)];
    UIBarButtonItem *four = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"eva_pen_light"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(oneClick)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:@selector(oneClick)];
    item.width =20;

    self.navigationItem.rightBarButtonItems =@[one,item,two,item,three,item,four];
}
- (void)answerSheet{
    NSLog(@"进入查看答题卡");
    AnswerSheetCtl *sheet = [[AnswerSheetCtl alloc]init];
    sheet.counts = self.dataArray.count;
    sheet.name = self.examName;
    sheet.alreadyAnswer=YES;
    sheet.analy = self;
    sheet.currentPage = self.currentPage;
    [self presentViewController:sheet animated:YES completion:nil];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point =scrollView.contentOffset;
    // round四舍五入
    NSInteger index = round(point.x/kScreen.width);
    self.currentPage = index;
//    NSLog(@"%@",NSStringFromCGPoint(point));
}
- (void)oneClick{
    NSLog(@"还在建设中...");
}

- (void)setUpCollectionView{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreen.width, kScreen.height) collectionViewLayout:flow];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELLID];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.pagingEnabled=YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"AnalyzCell" bundle:nil] forCellWithReuseIdentifier:CELLID];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count+1;
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    AnalyzCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (indexPath.row<self.dataArray.count) {
        ExamTwo *two = self.dataArray[indexPath.row];
        cell.desc = two.desc;
        cell.indexPath = indexPath;
        cell.dataArray =self.dataArray;
        cell.name = two.name;
        cell.analyzContent = self.analyzContent;
        cell.answerContent = self.answerContent;
        [cell setNeedsDisplay];
    }else{
        //最后一页
        //        [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UIButton *finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 150, 64)];
        finishBtn.center = self.view.center;
        finishBtn.y = CELL_H-64;
        finishBtn.backgroundColor = CUSTOM_COLOR(32, 191, 184);
        [finishBtn setTitle:@"退出" forState:0];
        [finishBtn addTarget:self action:@selector(comeback) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:finishBtn];
    }

    return cell;
}
- (void)comeback{
    //    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[CourseDetailsViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreen.width, kScreen.height-64);
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return  UIEdgeInsetsMake(0, 5, 0, 5);
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


@end

