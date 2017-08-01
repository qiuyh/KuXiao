//
//  photoCtl.h
//  rcpi
//
//  Created by wu on 15/10/30.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface photoCtl : UIViewController
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)NSString *photoStr;
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;
- (void)scrollViewDidZoom:(UIScrollView *)scrollView;
- (void)showPhoto:(UIImage*)images;
-(void)network;
@end
