//
//  AddFriendsViewController.h
//  rcpi
//
//  Created by Dc on 15/11/19.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"

@interface AddFriendsViewController : UIViewController<UITableExtViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong)UILabel *accountLab;
@property (nonatomic, strong)UITextField *searchTextField;
@property (nonatomic, strong)UITableExtView *tableView;
@property (nonatomic, strong)NSArray *array;
@property (nonatomic, assign)NSInteger pageNo;
@property (nonatomic, assign)NSInteger pageSize;

-(void)searchBtnClick;
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
-(BOOL)textFieldShouldReturn:(UITextField *)textField;
@end
