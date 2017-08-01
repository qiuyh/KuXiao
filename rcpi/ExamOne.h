//
//  ExamOne.h
//  rcpi
//
//  Created by wu on 15/11/18.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExamTwo.h"
@interface ExamOne : NSObject

@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSArray *questions;
@property (nonatomic,strong)NSString *qGroupID;
+ (instancetype)appWithDict:(NSDictionary *)dict;

+ (NSArray *)appWithArray:(NSArray *)array;
@end
