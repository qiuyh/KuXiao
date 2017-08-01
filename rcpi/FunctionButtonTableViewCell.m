//
//  FunctionButtonTableViewCell.m
//  CourseDetails
//
//  Created by user on 15/10/11.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "FunctionButtonTableViewCell.h"

@implementation FunctionButtonTableViewCell

- (UIButton *)menuButton {
    if (!_menuButton) {
        _menuButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 70, 42)];
        _menuButton.titleEdgeInsets = UIEdgeInsetsMake(65, -60, 0, 0);
        _menuButton.imageEdgeInsets = UIEdgeInsetsMake(5, -4, 0, 0);
        [_menuButton setImage:[UIImage imageNamed:@"fp_directory-e"] forState:UIControlStateNormal];
        [_menuButton setTitle:@"目录" forState:UIControlStateNormal];
        [_menuButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _menuButton.tag = 0;
        [self addSubview:_menuButton];
    }
    return _menuButton;
}

- (UIButton *)answerButton {
    if (!_answerButton) {
        CGFloat screenWidth = [[[[UIApplication sharedApplication] keyWindow] screen] bounds].size.width;
        _answerButton = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth - 20 - 42, 0, 70, 42)];
        _answerButton.titleEdgeInsets = UIEdgeInsetsMake(65, -60, 0, 0);
        _answerButton.imageEdgeInsets = UIEdgeInsetsMake(5, -4, 0, 0);
        [_answerButton setImage:[UIImage imageNamed:@"fp_answeringQuestions_light"] forState:UIControlStateNormal];
        [_answerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_answerButton setTitle:@"答疑" forState:UIControlStateNormal];
        [_answerButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        _answerButton.tag = 4;
        [self addSubview:_answerButton];
    }
    return _answerButton;
}

- (UIButton *)teachButton {
    if (!_teachButton) {
        CGFloat screenWidth = [[[[UIApplication sharedApplication] keyWindow] screen] bounds].size.width;
        _teachButton = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth / 2 - 21, 0, 70, 42)];
        _teachButton.titleEdgeInsets = UIEdgeInsetsMake(65, -60, 0, 0);
        _teachButton.imageEdgeInsets = UIEdgeInsetsMake(5, -4, 0, 0);
        [_teachButton setImage:[UIImage imageNamed:@"fp_teaching-e"] forState:UIControlStateNormal];
        [_teachButton setTitle:@"教学" forState:UIControlStateNormal];
        [_teachButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_teachButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        _teachButton.tag = 2;
        [self addSubview:_teachButton];
    }
    return _teachButton;
}

- (UIButton *)judgeButton {
    if (!_judgeButton) {
        CGFloat screenWidth = [[[[UIApplication sharedApplication] keyWindow] screen] bounds].size.width;
        _judgeButton = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth / 4 - 1, 0, 70, 42)];
        _judgeButton.titleEdgeInsets = UIEdgeInsetsMake(65, -60, 0, 0);
        _judgeButton.imageEdgeInsets = UIEdgeInsetsMake(5, -4, 0, 0);
        [_judgeButton setImage:[UIImage imageNamed:@"fp_test-e"] forState:UIControlStateNormal];
        [_judgeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_judgeButton setTitle:@"评测" forState:UIControlStateNormal];
        [_judgeButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        _judgeButton.tag = 1;
        [self addSubview:_judgeButton];
    }
    return _judgeButton;
}

- (UIButton *)activityButton {
    if (!_activityButton) {
        _activityButton = [[UIButton alloc]initWithFrame:CGRectMake(self.judgeButton.frame.origin.x + self.teachButton.frame.origin.x - self.menuButton.frame.origin.x, 0, 70, 42)];
        _activityButton.titleEdgeInsets = UIEdgeInsetsMake(65, -60, 0, 0);
        _activityButton.imageEdgeInsets = UIEdgeInsetsMake(5, -4, 0, 0);
        [_activityButton setImage:[UIImage imageNamed:@"fp_activity-e"] forState:UIControlStateNormal];
        [_activityButton setTitle:@"活动" forState:UIControlStateNormal];
        [_activityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_activityButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        _activityButton.tag = 3;
        [self addSubview:_activityButton];
    }
    return _activityButton;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext(); CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:200.0 / 255.0 green:199.0 / 255.0 blue:204.0 / 255.0 alpha:1.0].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width , 1));
}

- (void)awakeFromNib {
    if (!self.menuButton || !self.judgeButton || !self.teachButton || !self.activityButton || !self.answerButton) {
        
    }
}

@end
