//
//  ExamTwo.h
//  rcpi
//
//  Created by wu on 15/11/18.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamTwo : NSObject
@property (nonatomic,strong)NSString *desc;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *seq;
@property (nonatomic,strong)NSString *queID;
@property (nonatomic,strong)NSString *qGrp;
@property (nonatomic,strong)NSString *option;
@property (nonatomic,strong)NSString *type;
+ (instancetype)appWithDict:(NSDictionary *)dict;

+ (NSArray *)appWithArray:(NSArray *)array;
@end
