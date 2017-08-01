//
//  LayerOne.m
//  rcpi
//
//  Created by wu on 15/11/10.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "LayerOne.h"

@implementation LayerOne

+ (instancetype)appWithDict:(NSDictionary *)dict
{
    LayerOne *one = [[self alloc] init];

    [one setValue:dict[@"name"] forKeyPath:@"name"];
    one.child = [LayerTwo childWithArray:dict[@"child"]];

    return one;
}
+ (NSArray *)childWithArray:(NSArray *)array{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self appWithDict:dict]];
    }
    return arrayM;
}
@end
