//
//  CourseDetailsViewController.h
//  CourseDetails
//
//  Created by user on 15/10/10.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iwf/iwf.h>
#import <WebKit/WebKit.h>

@interface CourseDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,WKNavigationDelegate,WKUIDelegate>

@property (nonatomic,strong)NSString *courseID;
@property (nonatomic,strong)UIScrollView *tableScrollView;
@property (nonatomic,strong)UITableExtView *introduceTableView;
@property (nonatomic,strong)UITableExtView *judgeTableView;
@property (nonatomic,strong)UITableExtView *discussTableView;
@property (nonatomic,strong)NSDictionary *courseDetailsDic;
@property (nonatomic,strong)UIButton *clickInBtn;
@property (nonatomic,assign)NSInteger introduceViewHeight;

- (void)moreClicket;
- (void)openMenuBtnView:(UIButton *)sender;
- (void)clicketMore;
- (void)joinCourseDetails:(UIButton *)sender;

@end
