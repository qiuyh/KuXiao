//
//  ExamDetailsCtl.m
//  rcpi
//
//  Created by wu on 15/11/15.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "ExamDetailsCtl.h"
#import "Config.h"
#import "ExamTwo.h"
#import "DYTextView.h"
#import "CourseDetailsViewController.h"
#import "ExamCell.h"
@interface ExamDetailsCtl ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextViewDelegate>

@end

@implementation ExamDetailsCtl
#define CELLID @"collectionviewcell"
#define CELL_W (kScreen.width-10)
#define CELL_H (kScreen.height-64)
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpCollectionView];
    [self setUpNav];
    self.textContent = [NSMutableDictionary dictionary];
    for (int i=0; i<self.dataArray.count; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [self.textContent setObject:@"" forKey:str];
    };
    [self.collectionView registerNib:[UINib nibWithNibName:@"ExamCell" bundle:nil] forCellWithReuseIdentifier:CELLID];
}

- (void)setUpNav{
    UIBarButtonItem *one = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"eva_more"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(oneClick)];
    UIBarButtonItem *two = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"eva_timer_light"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(oneClick)];
    UIBarButtonItem *three = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"eva_answerSheet"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(oneClick)];
    UIBarButtonItem *four = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"eva_pen_light"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(oneClick)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:@selector(oneClick)];
    item.width =20;

    self.navigationItem.rightBarButtonItems =@[one,item,two,item,three,item,four];
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
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count+1;
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    ExamCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
        [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (indexPath.row<self.dataArray.count) {
        ExamTwo *two = self.dataArray[indexPath.row];
        cell.desc = two.desc;
        cell.indexPath = indexPath;
        cell.dataArray =self.dataArray;
        cell.name = two.name;
        cell.aid = self.aid;
        cell.qGroupID = self.qGroupID;
        [cell setNeedsDisplay];
    }else{
        //最后一页
        UIButton *finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(-5, CELL_H-64, kScreen.width, 64)];
        finishBtn.backgroundColor = CUSTOM_COLOR(32, 191, 184);
        [finishBtn setTitle:@"提交试卷" forState:0];
        [finishBtn addTarget:self action:@selector(upLoadData) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:finishBtn];
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreen.width-10, kScreen.height-64);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return  UIEdgeInsetsMake(0, 5, 0, 5);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
        [self.view endEditing:YES];

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSIndexPath *path = [[self.collectionView indexPathsForVisibleItems]firstObject];
    ExamCell *cell =(ExamCell*) [self.collectionView cellForItemAtIndexPath:path];
    NSString *key = [NSString stringWithFormat:@"%ld",(long)path.row];
    [self.textContent setObject:cell.textView.text forKey:key];
//        NSLog(@"内容本地化%@",self.textContent);

}

//提交试卷
- (void)upLoadData{

    NSMutableArray *mutArray = [NSMutableArray array];
    for (int i=0; i<self.dataArray.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSMutableArray *items =[NSMutableArray array];
        [items addObject:[self.textContent objectForKey:[NSString stringWithFormat:@"%d",i]]];
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
    NSString *urlCommit = @"http://ebs2.dev.jxzy.com/usr/submit-answer";
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"aId"] = self.aid;
    args[@"a"] = jsonStr;

    [H doPost:urlCommit dargs:args json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
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


@end
