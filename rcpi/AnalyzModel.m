//
//  AnalyzModel.m
//  rcpi
//
//  Created by wu on 15/11/23.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "AnalyzModel.h"

@implementation AnalyzModel

+ (instancetype)appWithDict:(NSDictionary *)dict
{
    AnalyzModel *one = [[self alloc] init];
    [one setValue:dict[@"analyze"] forKeyPath:@"analyze"];

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
