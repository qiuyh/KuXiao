//
//  photoCtl.m
//  rcpi
//
//  Created by wu on 15/10/30.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "photoCtl.h"
#import "Config.h"

@interface photoCtl () <UIScrollViewDelegate>

@end

@implementation photoCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self network];
}
- (void)network{
    NSError *err =nil;
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.photoStr] options:0 error:&err];
    if (data==nil) {
        NSLog(@"网络地址有误%@",err.userInfo);
    }else{
        UIImage *images = [UIImage imageWithData:data];
        if (images==nil) {
            NSLog(@"获取图片的数据有误");
        }else{
            [self showPhoto:images];
        }

    }

}
- (void)showPhoto:(UIImage*)images{
    NSLog(@"宽--%f 高--%f",images.size.width,images.size.height);
    self.scrollView = [[UIScrollView alloc]init];
    // 设定scrollView的可显示区域窗口的大小
    self.scrollView.frame = CGRectMake(0, 0, kScreen.width, kScreen.height);
    // 设置缩放的相关属性
    CGFloat xScale = kScreen.width/images.size.width;
    CGFloat yScale = (self.scrollView.height)/images.size.height;
    CGFloat minScale = MIN(xScale, yScale);
    NSLog(@"缩放率==%f",minScale);
    //初始化imageView
    CGSize sizeImage = images.size;
    sizeImage.height = sizeImage.height *minScale;
    sizeImage.width = sizeImage.width *minScale;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:images];
    imageView.size = sizeImage;


    // 设定scrollView的可滚动区域的大小
    self.scrollView.contentSize = imageView.frame.size;
    self.scrollView.maximumZoomScale = 1/MIN(xScale, yScale);
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.showsVerticalScrollIndicator=NO;
    self.scrollView.bounces=NO;
    imageView.y=(kScreen.height-64)/2-imageView.height/2;
    [self.scrollView addSubview:imageView];
    [self.view addSubview:self.scrollView];
    self.imageView=imageView;

}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return  self.imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    if ((kScreen.height-64)/2-self.imageView.height/2<=0) {
        self.imageView.y=0;
    }else{
        self.imageView.y=(kScreen.height-64)/2-self.imageView.height/2;
    }
}
@end
