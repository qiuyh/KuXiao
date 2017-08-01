//
//  EvaluationModel.m
//  rcpi
//
//  Created by wu on 15/11/17.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "EvaluationModel.h"

@implementation EvaluationModel

+ (instancetype)appWithDict:(NSDictionary *)dict
{
    EvaluationModel *one = [[self alloc] init];
    [one setValue:dict[@"name"] forKeyPath:@"name"];
    [one setValue:dict[@"description"] forKeyPath:@"descriptions"];
    [one setValue:dict[@"time"] forKeyPath:@"time"];
    [one setValue:dict[@"price"] forKeyPath:@"price"];
    [one setValue:dict[@"extra"][@"paper"][@"bankId"] forKeyPath:@"bankId"];
    [one setValue:dict[@"extra"][@"paper"][@"p2bId"] forKeyPath:@"p2bId"];
    [one setValue:dict[@"extra"][@"paper"][@"name"] forKeyPath:@"examName"];
    [one setValue:dict[@"extra"][@"record"][@"a_status"] forKeyPath:@"status"];

    one.paperRecord = dict[@"extra"][@"record"][@"paperRecord"];
    if (one.status.length!=0) {
        [one setValue:dict[@"extra"][@"record"][@"paperRecord"][0][@"aid"] forKeyPath:@"aid"];
        [one setValue:[NSString stringWithFormat:@"%@",dict[@"extra"][@"record"][@"id"]] forKeyPath:@"pid"];
    }

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
