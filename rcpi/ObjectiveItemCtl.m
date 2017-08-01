//
//  ObjectiveItemCtl.m
//  rcpi
//
//  Created by wu on 15/12/5.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "ObjectiveItemCtl.h"
#import "ObjectiveCell.h"
#import "Config.h"
#import "ExamOne.h"
#import "CourseDetailsViewController.h"
#import "AnswerCardCell.h"
#import "AnswerSheetCtl.h"
@interface ObjectiveItemCtl ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)NSMutableArray *types;//题型

@end

@implementation ObjectiveItemCtl

#define CELLID @"collectionviewcell"
#define CELLID2 @"collectionviewcell2"


- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentData = [NSMutableDictionary dictionary];
    [self setUpCollectionView];
    [self setUpNav];

    [self.collectionView registerNib:[UINib nibWithNibName:@"ObjectiveCell" bundle:nil] forCellWithReuseIdentifier:CELLID];
    [self.collectionView registerNib:[UINib nibWithNibName:@"AnswerCardCell" bundle:nil] forCellWithReuseIdentifier:CELLID2];
    NSLog(@"tem路径==%@",PATH_TMP);
    //提取所有题型
    self.types = [NSMutableArray array];
    for (ExamTwo *model in self.dataArray) {
        [self.types addObject:model.type];
    }
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
    sheet.types = self.types;
    sheet.contentData = self.contentData;
    sheet.name = self.examName;
    sheet.obj = self;
    [self presentViewController:sheet animated:YES completion:nil];

}
- (void)oneClick{
    NSLog(@"还在建设中...");
}

- (void)setUpCollectionView{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreen.width, kScreen.height) collectionViewLayout:flow];

    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.pagingEnabled=YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count+1;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;

    if (indexPath.row<self.dataArray.count) {
        ObjectiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:PATH_TMP]) {
        self.contentData = [NSMutableDictionary dictionaryWithContentsOfFile:PATH_TMP];
        }
        ExamTwo *two = self.dataArray[indexPath.row];
        NSString *str = two.desc;
        NSString *option =two.option;
        NSData *data = [option dataUsingEncoding:NSUTF8StringEncoding];

        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        //选择
        NSInteger count = [json count];
        //填空
        if ([two.type integerValue]==35) {
            NSArray *array = [two.desc componentsSeparatedByString:@"___"];
            count = array.count-1;
        }
        if ([two.type integerValue]==40) {
            [cell textDidChange:^(NSString *text) {
                NSLog(@"拿到的%@",text);
                [weakSelf saveText];
            }];
            
        }
        NSArray *arr = (NSArray *)json;
        cell.contentData = self.contentData;
        cell.aid = self.aid;
        cell.qGroupID = self.qGroupID;
        cell.currentPage = indexPath.row+1;
        cell.type = two.type;
        cell.obj = self;
        [cell setUpContentAndHtml:str sumPage:self.dataArray.count chooseCounts:count labelContent:arr];
        return cell;

    }else{
            //最后一页
        AnswerCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID2 forIndexPath:indexPath];
        [cell answerCardName:self.name content:self.contentData count:self.dataArray.count types:self.types];
                [cell answerCardAndButtonAction:^(NSString *bttn) {
            if ([bttn integerValue]==10000) {
                [weakSelf upLoadData];
            }else{
//            [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[bttn integerValue] inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
                [weakSelf nextItems:[bttn integerValue]];
            }
        }];
        return cell;

    }

}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreen.width, kScreen.height-64);
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return  UIEdgeInsetsMake(0, 5, 0, 5);
//}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
//   NSLog(@"总内容--》%@",self.contentData);

}
//提交试卷
- (void)upLoadData{

    NSArray *abc = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",nil];
    NSMutableArray *mutArray = [NSMutableArray array];
    //总题数
    for (int i=0; i<self.dataArray.count; i++) {
        NSArray *answerArray = [self.contentData objectForKey:[NSString stringWithFormat:@"%d",i+1]];
        NSMutableString *answerStr = [NSMutableString string];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSMutableArray *items =[NSMutableArray array];

        //每一题中的数组
        if ([self.types[i] intValue]==10|[self.types[i] intValue]==20||[self.types[i] intValue]==30) {
            //选择题*******************************
            for (int i=0; i<answerArray.count; i++) {
                if ([answerArray[i] intValue]==1) {
                    [answerStr appendString:abc[i]];
                }
            }
            [items addObject:answerStr];
        }
        if ([self.types[i] intValue]==35||[self.types[i] intValue]==40) {
            //填空题********************************
            items = [NSMutableArray arrayWithArray:answerArray];
        }
        dic[@"aItem"]=items;
        ExamTwo *model = self.dataArray[i];
        NSString *str = model.queID;
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *qid = [numberFormatter numberFromString:str];
        dic[@"seq"] = model.seq;
        dic[@"qId"] = qid;
        dic[@"qGrp"]= model.qGrp;
        [mutArray addObject:dic];
    }
    NSString *jsonStr = [mutArray toJson:nil].UTF8String;

    NSString *url = [NSString stringWithFormat:@"%@/submit-answer",ANSWER];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"aId"] = self.aid;
    args[@"a"] = jsonStr;
//    NSLog(@"提交信息--%@",jsonStr);
    [self networkAndUrl:url dargs:args];
}
- (void)networkAndUrl:(NSString*)url dargs:(NSDictionary*)args {
    [H doPost:url dargs:args json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err) {
            NSLog(@"网络请求失败%@",err.userInfo);
        }else {
            NSLog(@"请求成功%@",data.UTF8String);
            if ([json[@"code"]intValue]==0) {
                NSLog(@"提交成功");
                //                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[CourseDetailsViewController class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
            }else{
                NSLog(@"提交失败");
            }
        }
    }];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (void)nextItems:(NSInteger)item{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}


- (void)saveText{
    NSIndexPath *path = [[self.collectionView indexPathsForVisibleItems]firstObject];
        ObjectiveCell *cell =(ObjectiveCell*) [self.collectionView cellForItemAtIndexPath:path];
        NSString *key = [NSString stringWithFormat:@"%ld",(long)path.row+1];
        NSArray *arr = [NSArray arrayWithObject:cell.textView.text];

        [self.contentData setObject:arr forKey:key];
        [self.contentData writeToFile:PATH_TMP atomically:YES];

}

@end
