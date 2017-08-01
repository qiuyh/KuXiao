//
//  CourseSelectedModel.m
//  rcpi
//
//  Created by 王文选 on 15/10/15.
//  Copyright (c) 2015年 Dyang. All rights reserved.
//

#import "CourseSelectedModel.h"

@implementation CourseSelectedModel
+ (instancetype)appWithDict:(NSDictionary *)dict
{
    CourseSelectedModel *courseModel = [[self alloc] init];
    
    [courseModel setValue:dict[@"name"] forKeyPath:@"name"];
    [courseModel setValue:dict[@"category"] forKeyPath:@"category"];
    [courseModel setValue:dict[@"totalPrice"] forKeyPath:@"totalPrice"];
    [courseModel setValue:dict[@"id"] forKeyPath:@"id"];
    [courseModel setValue:dict[@"joinCnt"] forKeyPath:@"joinCnt"];
    [courseModel setValue:dict[@"burdenType"] forKeyPath:@"burdenType"];
    [courseModel setValue:dict[@"userName"] forKeyPath:@"userName"];
    [courseModel setValue:dict[@"imgs"] forKeyPath:@"imgs"];
    
    return courseModel;
}

@end
