//
//  ExamTwo.m
//  rcpi
//
//  Created by wu on 15/11/18.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "ExamTwo.h"

@implementation ExamTwo

+ (instancetype)appWithDict:(NSDictionary *)dict
{
    ExamTwo *one = [[self alloc] init];
    [one setValue:dict[@"desc"] forKeyPath:@"desc"];
    [one setValue:dict[@"name"] forKeyPath:@"name"];
    [one setValue:dict[@"id"] forKeyPath:@"queID"];
    [one setValue:dict[@"seq"] forKeyPath:@"seq"];
    [one setValue:dict[@"qGrp"] forKeyPath:@"qGrp"];
    [one setValue:dict[@"option"] forKey:@"option"];
    [one setValue:dict[@"type"] forKey:@"type"];
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
