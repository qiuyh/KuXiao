//
//  AllCourseCtl.m
//  rcpi
//
//  Created by wu on 15/11/8.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "AllCourseCtl.h"
#import "Config.h"
#import "AllCourseCell.h"
#import "Flowlayout.h"
#import "HeadView.h"
#import "ScreeningController.h"
#import "LayerOne.h"

@interface AllCourseCtl () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)NSArray *courses;
@end

@implementation AllCourseCtl

#define CELLID @"mycell"
#define HEADID @"head"
#define CUSTOM_COLOR(float1,float2,float3) [UIColor colorWithRed:float1/225.0 green:float2/225.0 blue:float3/225.0 alpha:100.0]
- (void)viewDidLoad {
    [super viewDidLoad];
    self.strClass  = @"/get-all-tag";
    [self setUpNav];
    [self setUpCollectionView];
    [self setUpNetwork];


}
- (void)setUpNetwork{
    //筛选内容
    //    NSString *StrClass  = @"/get-all-tag";
    NSString *urlClass = [NSString stringWithFormat:@"%@%@",SRV,self.strClass];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"firstTag"] = @"职业教育";
    [H doGet:urlClass args:params json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err) {
            NSLog(@"职业教育==================%@",err.userInfo);
        }else{
            //            NSLog(@"====所有返回参数====》%@",json);
            self.data_ProfessionEdu = [LayerOne childWithArray:json[@"data"]];

        }
        [self.collectionView reloadData];
    }];

    params[@"firstTag"] = @"基础教育";
    [H doGet:urlClass args:params json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err) {
            NSLog(@"基础教育===================%@",err.userInfo);
        }else{
            //            NSLog(@"====所有返回参数====》%@",json);
            self.data_BaseEdu = [LayerOne childWithArray:json[@"data"]];
        }
        [self.collectionView reloadData];
    }];

    params[@"firstTag"] = @"高等教育";
    [H doGet:urlClass args:params json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err) {
            NSLog(@"高等教育===================%@",err.userInfo);
        }else{
            //            NSLog(@"====所有返回参数====》%@",json);
            self.data_AdvancedEdu = [LayerOne childWithArray:json[@"data"]];
        }
        [self.collectionView reloadData];
    }];

}
-(NSArray *)courses{
    if (_courses==nil) {
        _courses = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"courses" ofType:@"plist"]];
    }
    return _courses;

}

- (void)setUpNav{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    self.navigationItem.title = @"全部课程";

}

- (void)setUpCollectionView{
    self.view.backgroundColor=[UIColor whiteColor];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 0, kScreen.width, kScreen.height) collectionViewLayout:[[Flowlayout alloc]init]];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.collectionView.showsVerticalScrollIndicator=NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"AllCourseCell" bundle:nil] forCellWithReuseIdentifier:CELLID];
    [self.collectionView registerClass:[HeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADID];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section==2) {
        return 3;
    }else{
        return 9;
    }
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AllCourseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    //边框
    //cell.layer.borderColor= [UIColor grayColor].CGColor;
    cell.layer.borderWidth=0.5;
    cell.layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.3f].CGColor;
    [cell.courseImgsBtn setImage:[UIImage imageNamed:self.courses[indexPath.row][@"icon"]] forState:0];
    [cell.courseName setFont:[UIFont systemFontOfSize:13]];
    if (indexPath.section==0) {
        LayerOne *one = self.data_ProfessionEdu[indexPath.row%4];
        [cell.courseName setText:one.name];
    }else{
        //    if (indexPath.section==1) {
        //        LayerOne *one = self.data_ProfessionEdu[indexPath.row];
        //        [cell.courseName setText:one.name];
        //    }
        [cell.courseName setText:self.courses[indexPath.row][@"name"]];
    }
    return cell;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView ;
    if (kind == UICollectionElementKindSectionHeader) {
        HeadView *headV = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADID forIndexPath:indexPath];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 5, 20)];
        lineView.backgroundColor = CUSTOM_COLOR(65.0,200.0,194.0);
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+10, 10, 100, 20)];
        [headV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        switch (indexPath.section) {
            case 0:
                title.text = @"职业教育";
                break;
            case 1:
                title.text = @"高等教育";
                break;
            default:
                title.text = @"基础教育";
                break;
        }
        title.font = [UIFont systemFontOfSize:15];
        title.textColor = [UIColor grayColor];
        [headV addSubview:lineView];
        [headV addSubview:title];
        reusableView = headV;
    }
    return reusableView;
}
//set size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreen.width-20)/3,(kScreen.width-20)/3);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = CGSizeMake(kScreen.width, 40);
    return size;
}


//点击cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ScreeningController *screen = [[ScreeningController alloc]init];
    AllCourseCell *cell = (AllCourseCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    screen.courseOne = cell.courseName.text;
    screen.path = indexPath;
    //    screen.courseOne = self.courses[indexPath.row][@"name"];

    [self.navigationController pushViewController:screen animated:YES];
}

-(void)leftbtnClick{
    NSLog(@"左点击");
    [self.navigationController popViewControllerAnimated:YES];
}
@end
