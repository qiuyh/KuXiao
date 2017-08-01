//
//  MyCourseModel.m
//  rcpi
//
//  Created by Dyang on 15/12/2.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "MyCourseModel.h"

@implementation MyCourseModel
+ (instancetype)appWithDict:(NSDictionary *)dict
{
    MyCourseModel *McModel = [[self alloc] init];
    
    [McModel setValue:dict[@"bankId"] forKeyPath:@"bankId"];
    [McModel setValue:dict[@"cid"] forKeyPath:@"cid"];
    [McModel setValue:dict[@"imgs"] forKeyPath:@"imgs"];
    [McModel setValue:dict[@"name"] forKeyPath:@"name"];
    [McModel setValue:dict[@"process"] forKeyPath:@"process"];
    [McModel setValue:dict[@"detail"][@"chapterCnt"] forKeyPath:@"chapterCnt"];
    
    return McModel;
}

@end
