//
//  FirstController.m
//
//
//  Created by wu on 15/10/12.
//
//

#import "FirstController.h"
#import "FirstCell.h"
#import "HeadView.h"
#import "AllCourseCtl.h"
#import "Config.h"
#import "SearchCourseController.h"
#import "HistorySearchController.h"
#import "OneModel.h"
#import "CourseDetailsViewController.h"
#import "ScreeningController.h"
#import "userInfoController.h"
//test
#import "ObjectiveItemCtl.h"
@interface FirstController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@end

@implementation FirstController
#define CELLID @"collectionViewCell"
#define HEAD   @"headView"
#define HEAD_H 40
#define HEAD_S_H kScreen.width*9/16+HEAD_H+55
#define IMAGES 3
#define HEAD_TEXT_FONT 16
#define PAGE_W 200

- (void)viewDidLoad {
    [super viewDidLoad];
    self.apiStr=@"/index-course-list";
    [self setNav];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator=NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"FirstCell" bundle:nil] forCellWithReuseIdentifier:CELLID];
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[HeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEAD];
    [self network];
    [self addTimer];
//    self.collectionView.contentInset=UIEdgeInsetsMake(0, 0, -49, 0);
    [self addRefresh];
}

- (void)setBackgroundView {
    if (!self.arr) {
        UIView *bgview = [[UIView alloc]initWithFrame:self.collectionView.frame];
        bgview.backgroundColor=[UIColor clearColor];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(50, HEAD_S_H+64, 120, 120)];
        imageview.centerX = bgview.centerX;
        imageview.image=[UIImage imageNamed:@"fp_no_internet"];
        UILabel *netLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
        netLabel.centerX = bgview.centerX;
        netLabel.y = CGRectGetMaxY(imageview.frame);
        netLabel.textAlignment =NSTextAlignmentCenter;
        netLabel.text = @"请检查一下您的网络";
        netLabel.font = [UIFont systemFontOfSize:13];
        netLabel.textColor = CUSTOM_COLOR(200, 200, 200);
        [bgview addSubview:imageview];
        [bgview addSubview:netLabel];
        [self.collectionView setBackgroundView:bgview];
    }else{
        [self.collectionView setBackgroundView:nil];
    }
}

- (void)network{
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",SRV,self.apiStr];
    [H doGet:urlStr json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err){
            NSELog(@"数据请求错误%@",err.userInfo);
            self.arr=nil;

            //提示用户
            [self popUp:@"网络连接失败" time:3];
        }else if([json[@"code"] integerValue]==0){
            NSLog(@"成功请求数据返回");
            self.arr = [OneModel appWithArray:json[@"data"]];

            [self popUp:@"更新成功" time:0.5];
            CGPoint point = CGPointMake(0, -64);
            [self.collectionView setContentOffset:point animated:YES];
        }
    }];
    CGPoint point = CGPointMake(0, -64);
    [self.collectionView setContentOffset:point animated:YES];
}

- (void)popUp:(NSString*)title time:(CGFloat)times{
    UIView *baffleView = [[UIView alloc]initWithFrame:self.view.frame];
    baffleView.alpha=0.5;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.center=self.view.center;
    label.font=[UIFont systemFontOfSize:15];
    label.alpha = 1;
    label.text = title;
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor = [UIColor blackColor];
    [baffleView addSubview:label];
    [self.view.window addSubview:baffleView];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:times animations:^{
        label.alpha = 0.5;
        CGPoint point = CGPointMake(0, -64);
        [weakSelf.collectionView setContentOffset:point animated:YES];
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
        [baffleView removeFromSuperview];
        [self.collectionView reloadData];
        [self setBackgroundView];
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.arr.count==0 ?1:self.arr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    OneModel *one = self.arr[section];
    return self.arr==0 ?0:one.list.count;
}

#pragma collectionViewCell content
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FirstCell *cell=[self.collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    if (self.arr) {
        OneModel *one = self.arr[indexPath.section];
        TwoModel *two = one.list[indexPath.row];
        cell.label.font = [UIFont systemFontOfSize:12];
        cell.label.text = two.name;
            if (two.imgs.length!=0) {
                [cell.imageView setUrl:[PublicTool isTureUrl:two.imgs]];
            }
    }
    return cell;
    
}
#pragma  collection click content
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CourseDetailsViewController *course = [[CourseDetailsViewController alloc]init];
    [self.navigationController pushViewController:course animated:YES];
    if (self.arr) {
        OneModel *one = self.arr[indexPath.section];
        TwoModel *two = one.list[indexPath.row];
        course.courseID = two.id;
    }else{
        course.courseID = nil;
    }
}
//内嵌
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5, 0, 5);
}
//cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat cell_W = kScreen.width/2-10;
    return CGSizeMake((kScreen.width-20)/2, (kScreen.width-20)/2/16*9+20);
}
//cell minimumLineSpacing
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

#pragma 头视图内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        HeadView *headV = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEAD forIndexPath:indexPath];
        //清理上一次的值
        [headV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kScreen.width, HEAD_H)];
        headLabel.textAlignment = NSTextAlignmentLeft;
        headLabel.font = [UIFont systemFontOfSize:HEAD_TEXT_FONT];
        if (indexPath.section==0) {
            UIView *headContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen.width, HEAD_S_H)];
            //滚动视图创建
            self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen.width,kScreen.width*9/16)];
            self.scrollView.delegate=self;
            self.scrollView.contentSize = CGSizeMake(kScreen.width*IMAGES,0);
            for (int i=0; i<IMAGES; i++) {
                //创建图片视图
                UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"com_adv_%d",i+1]]];
                CGRect frame = CGRectZero;
                frame.size = CGSizeMake(kScreen.width, self.scrollView.frame.size.height);
                frame.origin= CGPointMake(i*self.scrollView.frame.size.width, 0);
                imageView.frame  = frame;
                //添加到滚动视图中
                [self.scrollView addSubview:imageView];
                self.scrollView.showsHorizontalScrollIndicator=NO;
                self.scrollView.pagingEnabled=YES;
            }
            [headContentView addSubview:self.scrollView];

            self.pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake((kScreen.width - PAGE_W)/2, self.scrollView.frame.size.height*0.9, PAGE_W, self.scrollView.frame.size.height*0.1)];
            self.pageCtrl.numberOfPages = IMAGES;
            [headContentView insertSubview:self.pageCtrl aboveSubview:self.scrollView];
            
            //按钮内容
            UIImageView *headViewClickImage =[[UIImageView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.scrollView.frame)+10, 40, 40)];
            headViewClickImage.image=[UIImage imageNamed:@"fp_all-course"];
            //this is the text what
            UILabel *headTL=[[UILabel alloc]initWithFrame:CGRectMake(49, CGRectGetMaxY(_scrollView.frame)+10, 100, 30)];
            headTL.text=@"全部课程";
            headTL.textColor=[UIColor colorWithRed:0/255.0 green:192/255.0 blue:183/255.0 alpha:100.0];
            headTL.font=[UIFont systemFontOfSize:18];
            
            //this the button when click right picture
            UIImageView *rightImage=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-20, CGRectGetMaxY(self.scrollView.frame)+18, 15, 30)];
            rightImage.image=[UIImage imageNamed:@"fp_all-course-arrow"];
            
            //this is the labeltext with object count
            UILabel *headObjectLabel=[[UILabel alloc]initWithFrame:CGRectMake(49, CGRectGetMaxY(_scrollView.frame)+38, 200, 18)];
            headObjectLabel.textColor=[UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1.0];
            headObjectLabel.text=@"课程总数量5000个，今日新增200个";
            headObjectLabel.font=[UIFont systemFontOfSize:12];
            UIButton *courseBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), kScreen.width, HEAD_S_H-self.scrollView.frame.size.height-HEAD_H+10)];
            courseBtn.backgroundColor=[UIColor clearColor];
            [courseBtn addTarget:self action:@selector(clickBut) forControlEvents:UIControlEventTouchUpInside];
            [headContentView addSubview:headViewClickImage];
            [headContentView addSubview:headTL];
            [headContentView addSubview:rightImage];
            [headContentView addSubview:headObjectLabel];
            [headContentView addSubview:courseBtn];
            
            //文本内容
            UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, HEAD_S_H-HEAD_H, kScreen.width, HEAD_H)];
            firstLabel.textAlignment = NSTextAlignmentLeft;
            firstLabel.font = [UIFont systemFontOfSize:HEAD_TEXT_FONT];
            OneModel *one = self.arr[indexPath.section];
            firstLabel.text = one.name;
            [headContentView addSubview:firstLabel];
            [headV addSubview:headContentView];
            
        }else{
            OneModel *one = self.arr[indexPath.section];
            headLabel.text = one.name;
        }

        [headV addSubview:headLabel];
        reusableView = headV;
    }
    return reusableView;
}

//头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        CGSize size = CGSizeMake(self.view.bounds.size.width, HEAD_S_H);
        return size;
    }else{
        CGSize size = CGSizeMake(self.view.bounds.size.width, HEAD_H);
        return size;
    }
}


- (void)addRefresh{
    UIView *refreshView = [[UIView alloc]initWithFrame:CGRectMake(0, -50, kScreen.width, 50)];
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicator.color=[UIColor grayColor];
    self.indicator.center = refreshView.center;
    CGRect frame = self.indicator.frame;
    frame.origin.y=refreshView.frame.size.height-self.indicator.frame.size.height;
    self.indicator.frame=frame;
    self.indicator.hidesWhenStopped=NO;
    [self.indicator stopAnimating];
    [refreshView addSubview:self.indicator];
    [self.collectionView addSubview:refreshView];
}

#pragma  scrollView_delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
    if (self.isRefresh) {
        [self performSelectorOnMainThread:@selector(network) withObject:nil waitUntilDone:YES];
        [NSThread sleepForTimeInterval:3.0];
        self.isRefresh=NO;
    }
    self.indicator.color=[UIColor grayColor];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / kScreen.width +0.5;
    self.pageCtrl.currentPage = page ;
    if (scrollView.contentOffset.y>-100 && scrollView.contentOffset.y<0){
        [self.indicator stopAnimating];
        self.isRefresh=NO;
    }
    if (scrollView.contentOffset.y<=-115) {
        self.isRefresh=YES;
        CGPoint point = CGPointMake(0, -110);
        [self.collectionView setContentOffset:point animated:NO];
        self.indicator.color=[UIColor colorWithRed:0/255.0 green:192/255.0 blue:183/255.0 alpha:100.0];
        [self.indicator startAnimating];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}

- (void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)nextPage{
    NSInteger page = self.pageCtrl.currentPage;
    page++;
    if (page == IMAGES) {
        page = 0;
    }
    CGPoint point = CGPointMake(kScreen.width *page, 0);
    [self.scrollView setContentOffset:point animated:NO];
}


-(void)setNav{
    UIButton *rightBt=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBt setBackgroundImage:[UIImage imageNamed:@"fp_search"] forState:UIControlStateNormal];
    rightBt.frame=CGRectMake(0, 0, 25, 25);
    [rightBt addTarget:self action:@selector(rightbtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBt];
    
    UIButton *leftBt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftBt setBackgroundImage:[UIImage imageNamed: @"Customer Service"] forState:UIControlStateNormal];
    [leftBt addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftBt];
    
    self.navigationItem.leftBarButtonItem=leftItem;
    self.navigationItem.rightBarButtonItem=rightItem;
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(kScreen.width/2-60, 10, 50, 40)];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0 green:192/255.0 blue:183/255.0 alpha:100.0]];
    lable.textAlignment=NSTextAlignmentCenter;
    lable.text=@"首页";
    lable.textColor=[UIColor whiteColor];
    lable.font=[UIFont systemFontOfSize:20];
    self.navigationItem.titleView=lable;
}

-(void)leftBtnClick
{
    NSLog(@"个人信息");
    UserInfoController *eva = [[UserInfoController alloc]init];
    [self.navigationController pushViewController:eva animated:YES];
}

-(void)rightbtnClick
{
    HistorySearchController *controller=[[HistorySearchController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];

}

- (void)clickBut{
    NSLog(@"点击按钮进入全部课程");
    AllCourseCtl *controlle=[[AllCourseCtl alloc]init];
    [self.navigationController pushViewController:controlle animated:YES];

//    ObjectiveItemCtl *obj = [[ObjectiveItemCtl alloc]init];
//    [self.navigationController pushViewController:obj animated:YES];
}

@end
