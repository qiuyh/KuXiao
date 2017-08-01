//
//  FocusCtl.m
//  rcpi
//
//  Created by wu on 15/10/27.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "FocusCtl.h"
#import "Config.h"
@interface FocusCtl ()

//@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIScrollView *scrollView;
//@property (nonatomic,strong)NSOperationQueue *opQueue;
//@property (nonatomic,assign)BOOL isExist;
@end

@implementation FocusCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    //    假数据
    NSArray *arr = [NSArray arrayWithObjects:@"http://pic30.nipic.com/20130618/11860366_201437262000_2.jpg",@"http://f8.topit.me/8/f1/e2/112692244220de2f18o.jpg",@"http://pb.dev.jxzy.com/img/F10011.jpg",@"http://pb.dev.jxzy.com/img/F10017.jpg",@"http://pic.nipic.com/2008-07-16/2008716174548321_2.jpg", nil];
    self.arrays=arr;
    NSLog(@"数组的个数%ld",(unsigned long)self.arrays.count);
    [self showImages:self.arrays];

    //    [self myMethods];

}
- (void)showImages:(NSArray*)images{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen.width, self.view.frame.size.height-64)];
    self.scrollView.contentSize = CGSizeMake(images.count*kScreen.width, 0);
    for (int i=0; i<images.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*kScreen.width, 0, kScreen.width, kScreen.width*9/16)];

        imageView.y = (self.scrollView.height-imageView.height)/2;
        imageView.url = images[i];
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.pagingEnabled=YES;
    [self.view addSubview:self.scrollView];

}

/**
 #define PATH_CACHES [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

 - (NSOperationQueue *)opQueue
 {
 if (_opQueue == nil) {
 _opQueue = [[NSOperationQueue alloc]init];
 }
 return _opQueue;
 }

 -(void)myMethods{
 //判断本地是否存在图片
 for (int i=0; i<self.arrays.count; i++) {
 if ([[NSFileManager defaultManager] fileExistsAtPath:[PATH_CACHES stringByAppendingPathComponent:[self.arrays[i] lastPathComponent]]]){
 self.isExist=YES;
 }else{
 self.isExist=NO;
 break;
 }
 }
 if (self.isExist) {
 [self showScrollView:0];
 }else{
 NSLog(@"不存在,就下载");
 [self downLoad:self.arrays];
 UIApplication *app = [UIApplication sharedApplication];
 app.networkActivityIndicatorVisible = YES;
 }
 }

 //展示图片
 - (void)showScrollView:(int)yy{
 self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, yy, kScreen.width, self.view.frame.size.height-64)];
 //    NSLog(@"scroll的高%f Y==%f",self.scrollView.height,self.scrollView.y);
 self.scrollView.contentSize = CGSizeMake(self.arrays.count*kScreen.width, 0);
 for (int i=0; i<self.arrays.count; i++) {
 NSString *path = [PATH_CACHES stringByAppendingPathComponent:[self.arrays[i] lastPathComponent]];
 UIImage *image = [UIImage imageWithContentsOfFile:path];
 UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
 imageView.frame = CGRectMake(i*kScreen.width, 0, kScreen.width, kScreen.width*9/16);
 imageView.y = (self.scrollView.height-imageView.height)/2;
 [self.scrollView addSubview:imageView];
 }
 self.scrollView.pagingEnabled=YES;
 [self.view addSubview:self.scrollView];
 }

 - (void)downLoad:(NSArray*)arrays{
 NSBlockOperation * downLoadTask = [NSBlockOperation blockOperationWithBlock:^{
 for (int i=0; i<arrays.count; i++) {
 NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:arrays[i]]];
 UIImage *image = [UIImage imageWithData:data];
 NSString *path = [PATH_CACHES stringByAppendingPathComponent:[arrays[i] lastPathComponent]];
 if (image) {
 //本地化图片
 [data writeToFile:path atomically:YES];
 }else{
 NSLog(@"图片地址有误");
 return ;
 }
 }}];
 [self.opQueue addOperation:downLoadTask];

 NSBlockOperation * showTask = [NSBlockOperation blockOperationWithBlock:^{
 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
 //更新UI
 UIApplication *app = [UIApplication sharedApplication];
 app.networkActivityIndicatorVisible = NO;
 [self showScrollView:64];
 }];
 }];
 [showTask addDependency:downLoadTask];
 [self.opQueue addOperation:showTask];

 }
 **/

@end
