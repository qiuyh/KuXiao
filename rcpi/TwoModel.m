//
//  TwoModel.m
//  rcpi
//
//  Created by wu on 15/10/28.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "TwoModel.h"

@implementation TwoModel

+ (NSArray *)listWithArray:(NSArray *)array{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self appWithDict:dict]];
    }
    return arrayM;
}

+ (instancetype)appWithDict:(NSDictionary *)dict
{
    TwoModel *two = [[self alloc] init];

    [two setValue:dict[@"name"] forKeyPath:@"name"];
    [two setValue:dict[@"id"] forKeyPath:@"id"];
    [two setValue:dict[@"imgs"] forKeyPath:@"imgs"];
    [two setValue:dict[@"category"] forKeyPath:@"category"];

    return two;
}
@end
