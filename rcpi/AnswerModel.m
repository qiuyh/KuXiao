//
//  AnswerModel.m
//  rcpi
//
//  Created by wu on 15/11/23.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "AnswerModel.h"

@implementation AnswerModel
+ (instancetype)appWithDict:(NSDictionary *)dict
{
    AnswerModel *one = [[self alloc] init];
    [one setValue:dict[@"remark"] forKeyPath:@"remark"];
    [one setValue:[NSString stringWithFormat:@"%@",dict[@"score"]] forKeyPath:@"score"];
    one.aItem = dict[@"aItem"];
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
