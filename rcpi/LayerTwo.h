//
//  LayerTwo.h
//  rcpi
//
//  Created by wu on 15/11/10.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LayerTwo : NSObject

@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSArray *child;

+ (NSArray *)childWithArray:(NSArray *)array;
+ (instancetype)appWithDict:(NSDictionary *)dict;
@end
