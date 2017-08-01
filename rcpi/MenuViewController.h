//
//  MenuViewController.h
//  rcpi
//
//  Created by user on 15/10/21.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iwf/iwf.h>

@interface MenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITableExtViewDelegate>

@property (nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic,strong)NSString *courseID;
@property (nonatomic,strong)NSArray *courseDetailsArr;
@property (nonatomic,strong)UIScrollView *tableScrollView;
@property (nonatomic,strong)UITableExtView *rightMenuTableView;
@property (nonatomic,assign)NSInteger myType;
@property (nonatomic,strong)UITableExtView *menuTableView;
@property (nonatomic,strong)UIButton *clickInBtn;
@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UIImageView *bottomImageView;
@property (nonatomic,strong)UIButton *menuButton;
@property (nonatomic,strong)UIButton *judgeButton;
@property (nonatomic,strong)UIButton *teachButton;
@property (nonatomic,strong)UIButton *activityButton;
@property (nonatomic,strong)UIButton *answerButton;
@property (nonatomic,strong)UITableExtView *judgeTableView;
@property (nonatomic,strong)UITableExtView *teachTableView;
@property (nonatomic,strong)UITableExtView *activityTableView;
@property (nonatomic,strong)UITableExtView *answerTableView;
@property (nonatomic,assign)CGFloat contentOffsetY;
@property (nonatomic,assign)CGFloat newContentOffsetY;
@property (nonatomic,strong)UIView *menuView;
@property (nonatomic,strong)NSString *moreBtnType;
@property (nonatomic,strong)NSTimer *myTimer;
@property (nonatomic,strong)UIView *backgroundView;
@property (nonatomic)BOOL isLogin;
@property (nonatomic)BOOL isJoin;
@property (nonatomic,assign)BOOL isWait;
@property (nonatomic,strong)NSArray *dataArray;

- (void)moreClicket;

- (void)changeSelectedIndex:(UIButton *)sender;
- (void)joinCourseDetails:(UIButton *)sender;
//TEST
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
