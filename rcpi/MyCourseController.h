//
//  MyCourseController.h
//  rcpi
//
//  Created by Dyang on 15/12/1.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"

@interface MyCourseController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *myCourseIcon;
@property (weak, nonatomic) IBOutlet UILabel *myCourseLable;
@property (weak, nonatomic) IBOutlet UIButton *immRegisterButton;
@property (weak, nonatomic) IBOutlet UIButton *immLoginButton;
@property (strong, nonatomic)  UITableExtView *myCourseTableView;
@property (nonatomic,strong)NSMutableArray *myCourseArrayContent;

-(void)searchMyCourse;
-(void)showIcon;
-(void)showCourseIcon;
-(void)searchNextMyCourse;
-(void)jumpToUserInfo;
-(void)jumpToSearch;
-(IBAction)jumpToLogin:(id)sender;
-(IBAction)jumpToRegister:(id)sender;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
-(BOOL)isNeedRefresh:(UITableExtView *)tableview;
-(void)onNextPage:(UITableExtView *)tableview;


@end
