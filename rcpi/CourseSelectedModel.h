//
//  CourseSelectedModel.h
//  rcpi
//
//  Created by 王文选 on 15/10/15.
//  Copyright (c) 2015年 Dyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseSelectedModel : NSObject

@property(nonatomic,copy)NSString *id;
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


@end
