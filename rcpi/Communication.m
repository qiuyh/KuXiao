//
//  Communication.m
//  rcpi
//
//  Created by admin on 15/12/20.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "Communication.h"

@implementation Communication

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.
        //在这里赋值
        self.uname = [dic valueForKey:@"uname"];
        self.time = [dic valueForKey:@"time"];
        self.name = [dic valueForKey:@"name"];
        self.msg = [dic valueForKey:@"msg"];
        self.tag = [dic valueForKey:@"tag"];
        self.tid = [[dic valueForKey:@"tid"] stringValue];
        self.uid = [[dic valueForKey:@"uid"] stringValue];
        self.type = [dic valueForKey:@"type"];
        self.up= [[dic valueForKey:@"up"] integerValue];
        self.comments = [[dic valueForKey:@"floorsCount"]integerValue] - 1;
        self.isup = [[dic valueForKey:@"isUp"]boolValue];
    }
        return self;
}

//@property (nonatomic,copy)NSString *tid;//主题id
//@property (nonatomic,copy)NSString *uname;//发帖人
//@property (nonatomic,copy)NSString *name;//主题
//@property (nonatomic,copy)NSString *msg;//主题内容
//@property (nonatomic,copy)NSString *tag;//标签
//@property (nonatomic,copy)NSString *uid;//发帖人id
//@property (nonatomic,copy)NSString *type;//主题类别
//@property (nonatomic,copy)NSString *time;//发表时间
//@property (nonatomic,copy)NSString *up;//点赞数
//@property (nonatomic,copy)NSString *comments;//评论数
//@property (nonatomic)BOOL isup;//是否已点赞
//

@end
