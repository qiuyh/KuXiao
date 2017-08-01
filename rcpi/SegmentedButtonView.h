//
//  SegmentedButtonView.h
//  CourseDetails
//
//  Created by user on 15/10/13.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentedButtonView : UIView

@property (nonatomic,strong)UIButton *introduceButton;
@property (nonatomic,strong)UIButton *judgeButton;
@property (nonatomic,strong)UIButton *discussButton;
@property (nonatomic,strong)UIImageView *bottomImageView;
@property (nonatomic,assign)NSInteger selectedIndex;

@end
