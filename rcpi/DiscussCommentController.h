//
//  DiscussCommentController.h
//  rcpi
//
//  Created by admin on 15/12/20.
//  Copyright © 2015年 Dyang. All rights reserved.


//评论页面的回复详情页面

#import <UIKit/UIKit.h>
#import "DiscussionCell.h"
#import <iwf/iwf.h>
#import "CommunicationFrame.h"

typedef void(^myBlock)(BOOL isup);

@interface DiscussCommentController : UIViewController<UITableViewDataSource,UITableExtViewDelegate>

@property (nonatomic,strong)DiscussionCell *discussCell;

@property (nonatomic,strong)CommunicationFrame *commentF;

@property (nonatomic,copy)NSString *topicId;//帖子id
@property (nonatomic,copy)NSString *courseID;//课程id
@property (nonatomic,copy)myBlock block;


@end
