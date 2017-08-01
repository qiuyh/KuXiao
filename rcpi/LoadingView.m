//
//  LoadingView.m
//  rcpi
//
//  Created by user on 15/11/18.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "LoadingView.h"
#import <UIKit/UIKit.h>

@interface LoadingView ()
@property (nonatomic,strong)UIImageView *waitingImageView;
@property (nonatomic,strong)UILabel *waitingLabel;
@end

@implementation LoadingView
singleton_implementation(Wait);

- (void)startWaiting{
    [self stopWaiting];
        self.backgroundColor = [UIColor whiteColor];
        NSArray * arrayImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"com_loading1"],[UIImage imageNamed:@"com_loading2"], nil];
        _waitingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 84, 105)];
        _waitingImageView.center = self.center;
        _waitingImageView.animationImages=arrayImages;
        _waitingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 60)];
        _waitingLabel.center =_waitingImageView.center;
        _waitingLabel.y = CGRectGetMaxY(_waitingImageView.frame);
        _waitingLabel.text = @"玩命加载中...";
        _waitingLabel.textAlignment = NSTextAlignmentCenter;
        _waitingLabel.textColor = [UIColor blackColor];
        // 2. 设置动画时长
        [_waitingImageView  setAnimationDuration:arrayImages.count * 0.075];
        [_waitingImageView setAnimationRepeatCount:MAXFLOAT];
        // 3. 开始动画
        [_waitingImageView  startAnimating];
        [self addSubview:_waitingImageView];
        [self addSubview:_waitingLabel];

}

- (void)stopWaiting{
    [_waitingImageView removeFromSuperview];
    [_waitingLabel removeFromSuperview];
    [self removeFromSuperview];

}


@end
