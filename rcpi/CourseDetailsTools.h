//
//  CourseDetailsTools.h
//  CourseDetails
//
//  Created by user on 15/10/14.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseDetailsTools : NSObject

typedef void (^MyCallback) (id courseDetailsData);

@property (nonatomic,strong)NSString *courseID;
@property (nonatomic,strong)NSArray *menuArr;

@property (nonatomic,strong)NSString *tid;
@property (nonatomic,strong)NSString *cid;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,assign)NSInteger pid;
@property (nonatomic,strong)NSArray *childItems;

- (void)getCourseDetailsDataAndCallback:(MyCallback)callback;
- (void)getCourseDetailsMenuDataAneCallback:(MyCallback)callback;
- (void)postJoinCourseDataAndCallback:(MyCallback)callback;

@end
