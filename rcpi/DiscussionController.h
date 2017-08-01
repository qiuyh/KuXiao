//
//  SendDiscussController.h
//  rcpi
//
//  Created by admin on 15/12/17.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iwf/iwf.h>

@interface DiscussionController : UIViewController

@property (nonatomic,strong)UIActivityIndicatorView *indicator;
@property (nonatomic,assign)BOOL isRefresh;
@property (nonatomic,strong)UIScrollView *scrollView;

//@property (nonatomic,strong)UITableExtView *introduceTableView;
//@property (nonatomic,strong)UITableExtView *judgeTableView;

@property (nonatomic,weak)UITableExtView *discussTableView;
@property (nonatomic,assign)CGFloat newContentOffsetY;
@property (nonatomic,assign)CGFloat contentOffsetY;

@property (nonatomic,copy)NSString *courseID;


@end
