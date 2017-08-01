//
//  ScreeningModel.m
//  rcpi
//
//  Created by wu on 15/11/6.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "ScreeningModel.h"

@implementation ScreeningModel

+ (instancetype)appWithDict:(NSDictionary *)dict
{
    ScreeningModel *courseModel = [[self alloc] init];

    [courseModel setValue:dict[@"name"] forKeyPath:@"name"];
    [courseModel setValue:dict[@"category"] forKeyPath:@"category"];
    [courseModel setValue:dict[@"totalPrice"] forKeyPath:@"totalPrice"];
    [courseModel setValue:dict[@"id"] forKeyPath:@"CourseID"];
    [courseModel setValue:dict[@"joinCnt"] forKeyPath:@"joinCnt"];
    [courseModel setValue:dict[@"burdenType"] forKeyPath:@"burdenType"];
    [courseModel setValue:dict[@"userName"] forKeyPath:@"userName"];
    [courseModel setValue:dict[@"imgs"] forKeyPath:@"imgs"];

    return courseModel;
}
+ (NSArray *)appWithArray:(NSArray *)array{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self appWithDict:dict]];
    }
    return arrayM;
}
@end
