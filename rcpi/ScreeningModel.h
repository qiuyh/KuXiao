//
//  ScreeningModel.h
//  rcpi
//
//  Created by wu on 15/11/6.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScreeningModel : NSObject
//课程ID
@property(nonatomic,copy)NSString *CourseID;
//用户名
@property(nonatomic,copy)NSString *userName;
//星级
@property(nonatomic,copy)NSNumber *burdenType;
//课程名称
@property(nonatomic,copy)NSString *name;
//在线人数
@property(nonatomic,copy)NSNumber *joinCnt;
//测试价格
@property(nonatomic,copy)NSNumber *totalPrice;
//大图
@property(nonatomic,copy)NSString *imgs;
//课程类型
@property(nonatomic,copy)NSString *category;

+ (instancetype)appWithDict:(NSDictionary *)dict;
+ (NSArray *)appWithArray:(NSArray *)array;
@end
