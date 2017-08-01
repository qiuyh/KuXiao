//
//  SearchCourseController.h
//  rcpi
//
//  Created by Dyang on 15/10/8.
//  Copyright (c) 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
@interface SearchCourseController : UIViewController

@property (nonatomic,strong)UITextField *searchText;

@property (strong, nonatomic)  UITableExtView *courseDataTableView;

@property (weak, nonatomic) IBOutlet UILabel *courseCoutLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic,strong)NSString *urlStr;
@property(nonatomic,strong)NSString *searchThing;
@property(nonatomic,strong)NSMutableArray *searchData;

-(void)searchCourse;
-(void)goBackFirstPage;
-(void)clickSearch;
-(void)nextPageSearch;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
-(BOOL)isNeedRefresh:(UITableExtView *)tableview;
-(void)onNextPage:(UITableExtView *)tableview;
@end
