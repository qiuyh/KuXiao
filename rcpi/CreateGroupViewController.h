//
//  CreateGroupViewController.h
//  rcpi
//
//  Created by Dc on 15/11/28.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
@interface CreateGroupViewController : UIViewController<UITableExtViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableExtView *tableView;
@property(nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic ,strong)NSArray *array;
@property (nonatomic ,strong)UIButton *rightBtn;
@property (nonatomic ,strong)NSMutableArray *nameArr;
@property (nonatomic ,strong)NSMutableArray *imgArr;
@property (nonatomic ,strong)NSMutableArray *uidArr;
@property (nonatomic ,strong)NSMutableArray *idArr;

-(void)rightBtnClick:(UIButton *)sender;
@end
