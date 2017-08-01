//
//  EvaluationModel.h
//  rcpi
//
//  Created by wu on 15/11/17.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvaluationModel : NSObject

@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *descriptions;
@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSNumber *price;
@property (nonatomic,strong)NSNumber *bankId;
@property (nonatomic,strong)NSNumber *p2bId;
@property (nonatomic,strong)NSString *examName;
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSArray *paperRecord;

@property (nonatomic,strong)NSString *aid;
@property (nonatomic,strong)NSString *pid;
+ (instancetype)appWithDict:(NSDictionary *)dict;

+ (NSArray *)appWithArray:(NSArray *)array;
@end
