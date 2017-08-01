//
//  ScreeningController.h
//  rcpi
//
//  Created by wu on 15/11/6.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UITableExtView;
@interface ScreeningController : UIViewController
@property (nonatomic,strong)NSString *courseOne;
@property (nonatomic,strong)NSIndexPath *path;
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (strong, nonatomic) UITableExtView *tableView;
@property (nonatomic,strong)NSArray *arrayData;
@property (nonatomic,strong)NSArray *arrayClassName;
@property (nonatomic,strong)UIView *menuView;
@property (nonatomic,strong)UIView *backgroundView;
@property (nonatomic,strong)UITableView *leftFirstTableView;
@property (nonatomic,strong)UITableView *leftSecondTableView;
@property (nonatomic,strong)NSString *twoBtnStr;
@property (nonatomic,strong)NSString *tags;

//test
-(void)leftbtnClick;
-(void)rightbtnClick;
- (IBAction)selectedTeacherClass:(UIButton *)button;
- (IBAction)OneBtn:(UIButton *)sender;
- (IBAction)TwoBtn:(UIButton *)sender;
- (IBAction)ThreeBtn:(UIButton *)sender;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;
- (IBAction)goToScreening:(UIButton *)sender;
- (void)closeMenu;
- (BOOL)isNeedRefresh:(UITableExtView *)tableview;
- (void)onRefresh:(UITableExtView *)tableview;
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
