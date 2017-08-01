//
//  CommentModel.m
//  rcpi
//
//  Created by admin on 15/12/21.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "CommentModel.h"
#import <UIKit/UIKit.h>
#import "Config.h"
//正文
#define MSGFont [UIFont systemFontOfSize:15]
#define CELLMARGIN   8

@implementation CommentModel


- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.
        //在这里赋值
        
        self.uname = [dic valueForKey:@"uName"];
        self.uid = [[dic valueForKey:@"uid"] stringValue];
        self.msg = [dic valueForKey:@"msg"];
        NSLog(@" self.msg  %@", self.msg );
        CGSize msgSize = [self.msg boundingRectWithSize:CGSizeMake(kScreen.width - 2 * 8, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:MSGFont} context:nil].size;
        self.msgHeight = msgSize.height;
        
        
        self.floorNo = [dic valueForKey:@"floorNo"];
        self.type = [dic valueForKey:@"type"];
        self.time = [dic valueForKey:@"time"];
        self.pid = [[dic valueForKey:@"pid"] stringValue];
        self.tid = [[dic valueForKey:@"tid"] stringValue];
        self.type = [dic valueForKey:@"type"];
        self.isup = [dic valueForKey:@"isUp"]; //只有讨论才能点赞，笔记不可以
        //self.up= [[dic valueForKey:@"up"] stringValue];
        //NSArray *commentArray = [dic valueForKey:@"comments"];
        //self.comments = [NSString stringWithFormat:@"%ld",commentArray.count];
        
        
        self.cellHeight = CELLMARGIN + 35 + CELLMARGIN + self.msgHeight + CELLMARGIN;
    }
    return self;
}

//@property (nonatomic,copy)NSString *topicId;//主题id 帖子
//@property (nonatomic,copy)NSString *uname;//发帖人
//@property (nonatomic,copy)NSString *uid;//发帖人id
//@property (nonatomic,copy)NSString *msg;//评论内容
//@property (nonatomic,copy)NSString *floorNo;//楼层
//@property (nonatomic,copy)NSString *type;//主题类别
//@property (nonatomic,copy)NSString *time;//发表时间
//@property (nonatomic,copy)NSString *up;//点赞数
//@property (nonatomic,copy)NSString *pid;//
//@property (nonatomic,copy)NSString *tid;
//@property (nonatomic)BOOL isup;//是否已点赞,你



@end
