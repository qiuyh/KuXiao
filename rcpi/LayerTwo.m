//
//  LayerTwo.m
//  rcpi
//
//  Created by wu on 15/11/10.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "LayerTwo.h"
#import "LayerThree.h"
@implementation LayerTwo

+ (instancetype)appWithDict:(NSDictionary *)dict
{
    LayerTwo *two = [[self alloc] init];

    [two setValue:dict[@"name"] forKeyPath:@"name"];
    two.child = [LayerThree childWithArray:dict[@"child"]];

    return two;
}
+ (NSArray *)childWithArray:(NSArray *)array{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self appWithDict:dict]];
    }
    return arrayM;
}
@end
