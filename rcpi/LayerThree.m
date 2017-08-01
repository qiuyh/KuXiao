//
//  LayerThree.m
//  rcpi
//
//  Created by wu on 15/11/10.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "LayerThree.h"

@implementation LayerThree

+ (instancetype)appWithDict:(NSDictionary *)dict
{
    LayerThree *three = [[self alloc] init];
    [three setValue:dict[@"name"] forKeyPath:@"name"];

    return three;
}
+ (NSArray *)childWithArray:(NSArray *)array{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self appWithDict:dict]];
    }
    return arrayM;
}
@end
