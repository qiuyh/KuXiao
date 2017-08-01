//
//  HistorySearchController.h
//  rcpi
//
//  Created by Dyang on 15/11/25.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
@interface HistorySearchController : UIViewController
@property (nonatomic,strong)UITextField *searchHisText;
@property (nonatomic,strong)NSMutableArray *historyData;
@property (nonatomic,strong)NSMutableArray *curryData;
@property (nonatomic,strong)NSMutableArray *hotCourseData;
@property (nonatomic) UITableView *courseHistoryTableView;
-(void)goBackFirstPage;
-(void)getHotData;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
//-(BOOL)isNeedRefresh:(UITableExtView *)tableview;
//-(void)onNextPage:(UITableExtView *)tableview;
-(void)addSearchData:(NSString *)arg_name;
-(void)updateDataFile;
-(void)getLocalData;
-(void)deleteHistoryData;
-(void)clickSearch;
- (void)setHotButton;
-(void)jumpHotCourse:(UIButton *)arg_hotCourseBut;
@end
