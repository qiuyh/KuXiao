//
//  DiscussSegmentButton.m
//  rcpi
//
//  Created by admin on 15/12/17.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "DiscussSegmentButton.h"

#define BtnTileColor [UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0]

@implementation DiscussSegmentButton
- (UIButton *)discussButton {
    if (!_discussButton) {
        CGFloat screenWidth = [[[[UIApplication sharedApplication] keyWindow] screen] bounds].size.width;
        _discussButton = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth / 2 - 110, 0, 60, 44)];
        _discussButton.tag = 0;
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

- (UIButton *)answerButton {
    if (!_answerButton) {
        CGFloat screenWidth = [[[[UIApplication sharedApplication] keyWindow] screen] bounds].size.width;
        _answerButton = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth / 2 - 30, 0, 60, 44)];
        _answerButton.tag = 1;
        [_answerButton setTitle:@"问答" forState:UIControlStateNormal];
        if (_answerButton.tag == self.selectedIndex) {
            [_answerButton setTitleColor:[UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        }else {
            [_answerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [_answerButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_answerButton addTarget:self action:@selector(changeSelectedIndex:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_answerButton];
    }
    return _answerButton;
}

- (UIButton *)noteButton {
    if (!_noteButton) {
        CGFloat screenWidth = [[[[UIApplication sharedApplication] keyWindow] screen] bounds].size.width;
        _noteButton = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth / 2 + 50, 0, 60, 44)];
        _noteButton.tag = 2;
        [_noteButton setTitle:@"笔记" forState:UIControlStateNormal];
        if (_noteButton.tag == self.selectedIndex) {
            [_noteButton setTitleColor:[UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        }else {
            [_noteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [_noteButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_noteButton addTarget:self action:@selector(changeSelectedIndex:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_noteButton];
    }
    return _noteButton;
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
    if (self.discussButton && self.answerButton && self.noteButton) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            if (weakSelf.selectedIndex == 0) {
                weakSelf.bottomImageView.frame = CGRectMake(weakSelf.discussButton.frame.origin.x, 40, 60, 4);
            }else if (weakSelf.selectedIndex == 1) {
                weakSelf.bottomImageView.frame = CGRectMake(weakSelf.answerButton.frame.origin.x, 40, 60, 4);
            }else {
                weakSelf.bottomImageView.frame = CGRectMake(weakSelf.noteButton.frame.origin.x, 40, 60, 4);
            }
        }];
    }
}

- (void)changeButtonTitleColor {
    if (self.selectedIndex == 0) {
        [self.discussButton setTitleColor:[UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.answerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.noteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else if (self.selectedIndex == 1) {
        [self.discussButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.answerButton setTitleColor:[UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.noteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else {
        [self.discussButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.answerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.noteButton setTitleColor:[UIColor colorWithRed:3.0 / 255.0 green:186.0 / 255.0 blue:180.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    }
}

- (void)drawRect:(CGRect)rect {
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectedIndexFromScrollViewNotification:) name:@"changeSelectedIndexFromScrollViewNotification" object:nil];
    
    self.selectedIndex = 0;
    self.bottomImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"矩形-17"]];
    self.bottomImageView.frame = CGRectMake(self.discussButton.frame.origin.x, 40, 60, 4);
    [self addSubview:self.bottomImageView];
    self.bottomImageView.backgroundColor = BtnTileColor;
    [self changeBottomImageViewFrame];
    
    CGContextRef context = UIGraphicsGetCurrentContext(); CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //上分割线，
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:200.0 / 255.0 green:199.0 / 255.0 blue:204.0 / 255.0 alpha:1.0].CGColor);
    //CGContextStrokeRect(context, CGRectMake(0, -1, rect.size.width, 1));
    //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:200.0 / 255.0 green:199.0 / 255.0 blue:204.0 / 255.0 alpha:1.0].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width , 1));
}

//取消通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
