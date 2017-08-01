//
//  DisccussTool.m
//  rcpi
//
//  Created by admin on 15/12/20.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "DisccussTool.h"
#import <iwf/iwf.h>
#import "Config.h"
@implementation DisccussTool



- (void)postListTopicDataWithpage:(NSString *)page andCallBack:(MyCallback)callback{
    NSString *urlType = @"/listTopic";
    NSString *srv = @"http://dms.dev.jxzy.com";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",srv,urlType];
    NSString *tokenID = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"];
    NSDictionary *params;
    if (tokenID) {
        params = @{@"pageNo":page,@"pageSize":@"10",@"searchKey":self.courseID,@"token":tokenID,@"topic":@"DISCUSS",@"type":@"LIST"};
    }
    else
    {
        //@"pageNo":page,@"pageSize":@"10",
        params = @{@"pageNo":page,@"pageSize":@"10",@"searchKey":self.courseID,@"topic":@"DISCUSS",@"type":@"LIST"};
    }
//    [H doGet:urlStr args:params json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
//        
////    }
     [H doPost:urlStr dargs:params json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err) {
            NSLog(@"请求数据失败");
        }else {
            NSLog(@"===============33333============%@",json[@"data"]);
            NSLog(@"请求数据成功");
            callback(json);
        }
    }];

}

- (void)getlistCommentDataWithpage:(NSString *)page topicId:(NSString *)topicId andCallBack:(MyCallback)callback{
    NSString *urlType = @"/listComment";
    NSString *srv = @"http://dms.dev.jxzy.com";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",srv,urlType];
    NSString *tokenID = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"];
    NSDictionary *params;
    if (tokenID) {
        params = @{@"commentType":@"COMMENT",@"order":@"desc",@"pageNo":page,@"pageSize":@"10",@"token":tokenID,@"topicId":topicId,@"type":@"LIST"};
    }
    else
    {
        //@"pageNo":page,@"pageSize":@"10",
        params = @{@"commentType":@"COMMENT",@"order":@"desc",@"pageNo":page,@"pageSize":@"10",@"topicId":topicId,@"type":@"LIST"};
    }
    [H doPost:urlStr dargs:params json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if (err) {
            NSLog(@"请求数据失败");
        }else {
            NSLog(@"请求数据成功");
            callback(json);
        }
    }];
    
}



@end
