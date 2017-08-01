//
//  MyMessage.m
//  rcpi
//
//  Created by Dyang on 15/12/16.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "MyMessage.h"

@implementation MyMessage
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)messageWithDict:(NSDictionary *)dict {
    return [[self alloc]initWithDict:dict];
}

@end
