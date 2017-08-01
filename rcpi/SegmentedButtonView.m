//
//  SegmentedButtonView.m
//  CourseDetails
//
//  Created by user on 15/10/13.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "SegmentedButtonView.h"

@implementation SegmentedButtonView

- (UIButton *)introduceButton {
    if (!_introduceButton) {
        CGFloat screenWidth = [[[[UIApplication sharedApplication] keyWindow] screen] bounds].size.width;
        _introduceButton = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth / 2 - 110, 0, 60, 44)];
        _introduceButton.tag = 0;
        [_introduceButton setTitle:@"简介" forState:UIControlStateNormal];
        if (_introduceButton.tag == self.selectedIndex) {
            [_introduceButton setTitleColor:[UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        }else {
            [_introduceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [_introduceButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_introduceButton addTarget:self action:@selector(changeSelectedIndex:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_introduceButton];
    }
    return _introduceButton;
}

- (UIButton *)judgeButton {
    if (!_judgeButton) {
        CGFloat screenWidth = [[[[UIApplication sharedApplication] keyWindow] screen] bounds].size.width;
        _judgeButton = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth / 2 - 30, 0, 60, 44)];
        _judgeButton.tag = 1;
        [_judgeButton setTitle:@"评价" forState:UIControlStateNormal];
        if (_judgeButton.tag == self.selectedIndex) {
            [_judgeButton setTitleColor:[UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        }else {
            [_judgeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [_judgeButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_judgeButton addTarget:self action:@selector(changeSelectedIndex:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_judgeButton];
    }
    return _judgeButton;
}

- (UIButton *)discussButton {
    if (!_discussButton) {
        CGFloat screenWidth = [[[[UIApplication sharedApplication] keyWindow] screen] bounds].size.width;
        _discussButton = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth / 2 + 50, 0, 60, 44)];
        _discussButton.tag = 2;
        [_discussButton setTitle:@"讨论" forState:UIControlStateNormal];
        if (_discussButton.tag == self.selectedIndex) {
            [_discussButton setTitleColor:[UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        }else {
            [_discussButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [_discussButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_discussButton addTarget:self action:@selector(changeSelectedIndex:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_discussButton];
    }
    return _discussButton;
}

- (void)changeSelectedIndex:(UIButton *)sender {
    self.selectedIndex = sender.tag;
    [self changeBottomImageViewFrame];
    [self changeButtonTitleColor];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSelectedIndexNotification" object:nil userInfo:@{@"selectedIndex":[NSString stringWithFormat:@"%ld",(long)self.selectedIndex]}];
}

- (void)changeSelectedIndexFromScrollViewNotification:(NSNotification *)notification {
    NSDictionary *selectedIndexDic = [notification userInfo];
    self.selectedIndex = [[selectedIndexDic objectForKey:@"selectedIndex"] integerValue];
    [self changeBottomImageViewFrame];
    [self changeButtonTitleColor];
}

- (void)changeBottomImageViewFrame {
    if (self.introduceButton && self.judgeButton && self.discussButton) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            if (weakSelf.selectedIndex == 0) {
                weakSelf.bottomImageView.frame = CGRectMake(weakSelf.introduceButton.frame.origin.x, 40, 60, 4);
            }else if (weakSelf.selectedIndex == 1) {
                weakSelf.bottomImageView.frame = CGRectMake(weakSelf.judgeButton.frame.origin.x, 40, 60, 4);
            }else {
                weakSelf.bottomImageView.frame = CGRectMake(weakSelf.discussButton.frame.origin.x, 40, 60, 4);
            }
        }];
    }
}

- (void)changeButtonTitleColor {
    if (self.selectedIndex == 0) {
        [self.introduceButton setTitleColor:[UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.judgeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.discussButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else if (self.selectedIndex == 1) {
        [self.introduceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.judgeButton setTitleColor:[UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.discussButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else {
        [self.introduceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.judgeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.discussButton setTitleColor:[UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    }
}

- (void)drawRect:(CGRect)rect {
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectedIndexFromScrollViewNotification:) name:@"changeSelectedIndexFromScrollViewNotification" object:nil];
    
    self.selectedIndex = 0;
    self.bottomImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"矩形-17"]];
    self.bottomImageView.frame = CGRectMake(self.introduceButton.frame.origin.x, 40, 60, 4);
    [self addSubview:self.bottomImageView];
    [self changeBottomImageViewFrame];
    
    CGContextRef context = UIGraphicsGetCurrentContext(); CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //上分割线，
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:200.0 / 255.0 green:199.0 / 255.0 blue:204.0 / 255.0 alpha:1.0].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, -1, rect.size.width, 1));
    //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:200.0 / 255.0 green:199.0 / 255.0 blue:204.0 / 255.0 alpha:1.0].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width , 1));
}

//取消通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
