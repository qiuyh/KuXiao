//
//  DYButton.m
//  Cource
//
//  Created by admin on 15/12/8.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "DYLZButton.h"

@implementation DYLZButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 设置字体颜色
        self.titleLabel.textColor = [UIColor redColor];
        // 图片居中
        self.imageView.contentMode = UIViewContentModeCenter;
        // 文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 设置文字字体
        
    }
    return self;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
     self.imageView.image = image;
    
}
- (void)layoutSubviews{
    
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = self.frame.size.width;
    CGFloat imageH = 40;
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    
    // 2.title
    CGFloat titleX = 0;
    CGFloat titleY = imageH + 5 ;
    CGFloat titleW = self.bounds.size.width;
    CGFloat titleH = self.bounds.size.height - titleY;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
