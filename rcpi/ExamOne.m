//
//  ExamOne.m
//  rcpi
//
//  Created by wu on 15/11/18.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "ExamOne.h"

@implementation ExamOne
+ (instancetype)appWithDict:(NSDictionary *)dict
{
    ExamOne *one = [[self alloc] init];
    [one setValue:dict[@"name"] forKeyPath:@"name"];
    [one setValue:[NSString stringWithFormat:@"%@",dict[@"id"]] forKeyPath:@"qGroupID"];
    one.questions = [ExamTwo appWithArray:dict[@"questions"]];
    return one;
}
+ (NSArray *)appWithArray:(NSArray *)array{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self appWithDict:dict]];
    }
    return arrayM;
}

@end
