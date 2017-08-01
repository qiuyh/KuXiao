//
//  Communication.h
//  rcpi
//
//  Created by admin on 15/12/20.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Communication : NSObject

@property (nonatomic,copy)NSString *tid;//主题id
@property (nonatomic,copy)NSString *uname;//发帖人
@property (nonatomic,copy)NSString *name;//主题
@property (nonatomic,copy)NSString *msg;//主题内容
@property (nonatomic,copy)NSString *tag;//标签
@property (nonatomic,copy)NSString *uid;//发帖人id
@property (nonatomic,copy)NSString *type;//主题类别
@property (nonatomic,copy)NSString *time;//发表时间
@property (nonatomic,assign)NSInteger up;//点赞数
@property (nonatomic,assign)NSInteger comments;//评论数
@property (nonatomic)BOOL isup;//是否已点赞

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
