//
//  CourseDetailsTools.m
//  CourseDetails
//
//  Created by user on 15/10/14.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "CourseDetailsTools.h"
#import <iwf/iwf.h>
#import "Config.h"

@implementation CourseDetailsTools

- (void)getCourseDetailsDataAndCallback:(MyCallback)callback {
    NSString *urlType = @"/get-course";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SRV,urlType];
    NSString *tokenID = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"];
    NSDictionary *params = [NSDictionary dictionary];
    if (tokenID) {
        params = @{@"id":self.courseID,@"token":tokenID};
    }else {
        params = @{@"id":self.courseID};
    }

    [H doGet:urlStr args:params json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err) {
            NSLog(@"提交错误");
        }else {
            callback(json);
        }
    }];
}

- (void)getCourseDetailsMenuDataAneCallback:(MyCallback)callback {
    NSString *urlType = @"/get-section";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SRV,urlType];
    NSDictionary *params = @{@"courseId":self.courseID};
    
    [H doGet:urlStr args:params json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err) {
            NSLog(@"提交错误");
        }else {
            self.menuArr = [self analysisJsonFromCourseDetailsMenuData:json];
            callback(self.menuArr);
        }
    }];
}

- (void)postJoinCourseDataAndCallback:(MyCallback)callback {
    NSString *urlType = @"/usr/purchase-course";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SRV,urlType];
    NSString *tokenID = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"];
    NSDictionary *params = @{@"id":self.courseID,@"token":tokenID};
    [H doPost:urlStr dargs:params json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err) {
            NSLog(@"提交错误");
            NSString *errStr = @"fail";
            callback(errStr);
        }else {
            NSLog(@"提交成功");
            NSLog(@"%@",json);
            callback([json objectForKey:@"data"]);
        }
    }];
}

- (NSArray *)analysisJsonFromCourseDetailsMenuData:(NSDictionary *)dic {
    NSMutableArray *menuArr= [NSMutableArray array];
    if ([[dic objectForKey:@"data"] isMemberOfClass:[NSNull class]]) {
        return [NSArray array];
    }
    
    NSDictionary *data = [dic objectForKey:@"data"];
    NSArray *items = [data objectForKey:@"items"];
    for (NSDictionary *menuDic in items) {
        CourseDetailsTools *courseDetails = [[CourseDetailsTools alloc]init];
        courseDetails.tid = [menuDic objectForKey:@"tid"];
        courseDetails.cid = [menuDic objectForKey:@"cid"];
        courseDetails.name = [menuDic objectForKey:@"name"];
        courseDetails.pid = [[menuDic objectForKey:@"pid"] integerValue];
        courseDetails.childItems = [menuDic objectForKey:@"childItems"];
        if ([courseDetails.childItems isKindOfClass:[NSNull class]]) {
            [menuArr addObject:courseDetails];
        }else {
            [menuArr addObject:courseDetails];
            for (NSDictionary *childDic in courseDetails.childItems) {
                CourseDetailsTools *childCourseDetails = [[CourseDetailsTools alloc]init];
                childCourseDetails.tid = [childDic objectForKey:@"tid"];
                childCourseDetails.cid = [childDic objectForKey:@"cid"];
                childCourseDetails.name = [childDic objectForKey:@"name"];
                childCourseDetails.pid = [[childDic objectForKey:@"pid"] integerValue];
                childCourseDetails.childItems = [childDic objectForKey:@"childItems"];
                [menuArr addObject:childCourseDetails];
            }
        }
    }
    
    return menuArr;
}

@end
