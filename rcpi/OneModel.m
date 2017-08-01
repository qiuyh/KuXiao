//
//  OneModel.m
//  
//
//  Created by wu on 15/10/13.
//
//

#import "OneModel.h"
@implementation OneModel

+ (instancetype)appWithDict:(NSDictionary *)dict
{
    OneModel *one = [[self alloc] init];
    
//    [one setValuesForKeysWithDictionary:dict];
    [one setValue:dict[@"name"] forKeyPath:@"name"];
    [one setValue:dict[@"key"] forKeyPath:@"key"];
    one.list = [TwoModel listWithArray:dict[@"list"]];
    
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
