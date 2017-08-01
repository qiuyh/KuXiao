//
//  LayerOne.h
//  rcpi
//
//  Created by wu on 15/11/10.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LayerThree.h"
#import "LayerTwo.h"
@interface LayerOne : NSObject

@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSArray *child;

+ (instancetype)appWithDict:(NSDictionary *)dict;

+ (NSArray *)childWithArray:(NSArray *)array;

@end
